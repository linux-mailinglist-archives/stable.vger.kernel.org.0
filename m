Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E3B531AD1
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240647AbiEWRaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242877AbiEWR2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098908B0B6;
        Mon, 23 May 2022 10:24:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04539B811FB;
        Mon, 23 May 2022 17:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C11C385A9;
        Mon, 23 May 2022 17:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326679;
        bh=BjLUN4csdZCLrnYxSslxYpcdSADwEQFWK4CgIkLut9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQMCPerhEVrYwOGMPR5V+ui/4IdiKi2YdOm6FuKhnWXbIkVD8Hp+FX+DkSLqFY1k7
         NykmRTqTK0OTH6PghVartW+G/fxC2kCpNbOowum5jDNgYLQlU/OaiUTzcLEam3a7Iz
         t0zjzeSIQZXPyHYKO1Ze0H95eY+zm7Hng6mil5+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 026/158] gfs2: Disable page faults during lockless buffered reads
Date:   Mon, 23 May 2022 19:03:03 +0200
Message-Id: <20220523165834.860951526@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 52f3f033a5dbd023307520af1ff551cadfd7f037 ]

During lockless buffered reads, filemap_read() holds page cache page
references while trying to copy data to the user-space buffer.  The
calling process isn't holding the inode glock, but the page references
it holds prevent those pages from being removed from the page cache, and
that prevents the underlying inode glock from being moved to another
node.  Thus, we can end up in the same kinds of distributed deadlock
situations as with normal (non-lockless) buffered reads.

Fix that by disabling page faults during lockless reads as well.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index fa071d738c78..c781c19303db 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -956,14 +956,16 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			return ret;
 		iocb->ki_flags &= ~IOCB_DIRECT;
 	}
+	pagefault_disable();
 	iocb->ki_flags |= IOCB_NOIO;
 	ret = generic_file_read_iter(iocb, to);
 	iocb->ki_flags &= ~IOCB_NOIO;
+	pagefault_enable();
 	if (ret >= 0) {
 		if (!iov_iter_count(to))
 			return ret;
 		written = ret;
-	} else {
+	} else if (ret != -EFAULT) {
 		if (ret != -EAGAIN)
 			return ret;
 		if (iocb->ki_flags & IOCB_NOWAIT)
-- 
2.35.1



