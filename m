Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2F84F70E1
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbiDGBXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238654AbiDGBS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:18:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C749219896F;
        Wed,  6 Apr 2022 18:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52A7C61DB0;
        Thu,  7 Apr 2022 01:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F210EC385A1;
        Thu,  7 Apr 2022 01:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293999;
        bh=xfgpvXLBJ9D+xkhpNr1wXVFNKuMDjkxsUwuX7gi0CXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCmyMqj680zwlqkpYpTD9pMsubg2OjyotNFQxQnbA3cqrdbnGtFPgdQ0Z/aD0yKtg
         igiglLwrypOfz6bOfahDF2jDMqkQEW6eqy0b/v0+1fxzAw9z4dGmWHjZD1RJYOCzz0
         SpV6etYn1KkkYBtj7Gcd6rRIjHmF80j8dJMQkmN3cUwYGXoLWmWwkPcgvwwSFKcPX9
         nMmOWhNfOKuVoRXmv5fKZIHr60Kp4/kJMX4CfMgB7PzbVlevbTai4Q6l/SyLhMgZ7A
         rLGrys1kjDn/CLX2OeMr9N9VDfHtDDeLgfvol18I1Pi3hgIECOfFF6YHiGeACPxUgF
         MKvjxxv7sh6cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, rpeterso@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 09/27] gfs2: Disable page faults during lockless buffered reads
Date:   Wed,  6 Apr 2022 21:12:39 -0400
Message-Id: <20220407011257.114287-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011257.114287-1-sashal@kernel.org>
References: <20220407011257.114287-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f6d3b3e13d72..c39c102f5005 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -850,14 +850,16 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
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

