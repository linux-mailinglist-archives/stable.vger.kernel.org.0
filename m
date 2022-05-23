Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61F531C08
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240473AbiEWRRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbiEWRRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:17:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0B53CA4B;
        Mon, 23 May 2022 10:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 841DFB8121B;
        Mon, 23 May 2022 17:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFBEC385AA;
        Mon, 23 May 2022 17:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326108;
        bh=eL20i6qlG/xkqbBVfFhJoF5nyxuxVSwUmf5zNK46F/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msWg2wVAn0Tt0K0QpvYfPj2i1k3DjGgUBA8A9WQy834Hf5zbW21kfAEVLyEu6VfK2
         D+PMbMLukup5vGQfNSvT+hlKAad6/6VqhG+nnrdRg6fJ9rdeaFtPBwz/BD4wNGdADN
         gtQxrCaNGDIKB6F9mB2kPYjoBhEOfjnWEEH1D4cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/97] gfs2: Disable page faults during lockless buffered reads
Date:   Mon, 23 May 2022 19:05:18 +0200
Message-Id: <20220523165814.598631250@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
References: <20220523165812.244140613@linuxfoundation.org>
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
index 2e6f622ed428..55a8eb3c1963 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -858,14 +858,16 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
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



