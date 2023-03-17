Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EBA6BE078
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 06:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCQFHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 01:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCQFHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 01:07:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CF84D2AC;
        Thu, 16 Mar 2023 22:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5787B82449;
        Fri, 17 Mar 2023 05:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9C8C433EF;
        Fri, 17 Mar 2023 05:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679029621;
        bh=+FCsAePNiEbZwQOAc4eWABK4quiynO1ZGWgjAZOkSBg=;
        h=From:To:Cc:Subject:Date:From;
        b=jGk7QdNsJVbDdvo98hgXxQ7ta0NhleCuHS9KwdLXgKxPNdAB4ba7fHaMuDZ1fcVzj
         YSYW8igZWutXHN0FTVCtlasVtEInGsICllg9cwic0lwLJEmcLWfwx2ApTpIO83YeD6
         uHaNYdC9/T4f9AoouZJEVj9p2X/4OwxzYmsuipBN6ufA6XHXIc+UIS6UdOG9kB9oU0
         RAqH8Kj7K/2K13dilRyXvgytWS3jxDGH5EVM9xO5awBKBSv4WZEHD5lw3TymMRW0I+
         MfZF33uJQsGn4eFSwPlZNKHEhG29/F3ihla8Fx/qGdiXYNICxpM/iFwLDaFMB1ukiP
         R39r081J7qDPA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4.14] ext4: fix cgroup writeback accounting with fs-layer encryption
Date:   Thu, 16 Mar 2023 22:06:56 -0700
Message-Id: <20230317050656.67910-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit ffec85d53d0f39ee4680a2cf0795255e000e1feb upstream.

When writing a page from an encrypted file that is using
filesystem-layer encryption (not inline encryption), ext4 encrypts the
pagecache page into a bounce page, then writes the bounce page.

It also passes the bounce page to wbc_account_cgroup_owner().  That's
incorrect, because the bounce page is a newly allocated temporary page
that doesn't have the memory cgroup of the original pagecache page.
This makes wbc_account_cgroup_owner() not account the I/O to the owner
of the pagecache page as it should.

Fix this by always passing the pagecache page to
wbc_account_cgroup_owner().

Fixes: 001e4a8775f6 ("ext4: implement cgroup writeback support")
Cc: stable@vger.kernel.org
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230203005503.141557-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/page-io.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 3de933354a08b..bf910f2664690 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -388,7 +388,8 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 
 static int io_submit_add_bh(struct ext4_io_submit *io,
 			    struct inode *inode,
-			    struct page *page,
+			    struct page *pagecache_page,
+			    struct page *bounce_page,
 			    struct buffer_head *bh)
 {
 	int ret;
@@ -403,10 +404,11 @@ static int io_submit_add_bh(struct ext4_io_submit *io,
 			return ret;
 		io->io_bio->bi_write_hint = inode->i_write_hint;
 	}
-	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
+	ret = bio_add_page(io->io_bio, bounce_page ?: pagecache_page,
+			   bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
 		goto submit_and_retry;
-	wbc_account_io(io->io_wbc, page, bh->b_size);
+	wbc_account_io(io->io_wbc, pagecache_page, bh->b_size);
 	io->io_next_block++;
 	return 0;
 }
@@ -514,8 +516,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		ret = io_submit_add_bh(io, inode,
-				       data_page ? data_page : page, bh);
+		ret = io_submit_add_bh(io, inode, page, data_page, bh);
 		if (ret) {
 			/*
 			 * We only get here on ENOMEM.  Not much else
-- 
2.39.2

