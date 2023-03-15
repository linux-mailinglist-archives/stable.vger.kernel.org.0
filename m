Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AA56BB2E5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbjCOMjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbjCOMj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:39:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B42A4014
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:38:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C0D561D71
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B571C433D2;
        Wed, 15 Mar 2023 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883873;
        bh=O4nOY5xFcoyX7dOOrJS9q6nTol6/jYUknf93IFSLIaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XY4nP/CcaU0290DW1MCr6nQFzonRksHkpwoStE1hAyYQ9mB9ufzySitp7VpVICLSh
         dds1v9RZUnpl3FGtEkUUMW9fOJX2JAf2xce1EK8PWgNxy96dGkxXon/B+ILtcaLK/D
         Z7TDc65Ogem69Uld/Gj5hraC5HwEx9NmTKjc+vew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Eric Biggers <ebiggers@google.com>, Tejun Heo <tj@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.2 020/141] ext4: fix cgroup writeback accounting with fs-layer encryption
Date:   Wed, 15 Mar 2023 13:12:03 +0100
Message-Id: <20230315115740.602227163@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/page-io.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -409,7 +409,8 @@ static void io_submit_init_bio(struct ex
 
 static void io_submit_add_bh(struct ext4_io_submit *io,
 			     struct inode *inode,
-			     struct page *page,
+			     struct page *pagecache_page,
+			     struct page *bounce_page,
 			     struct buffer_head *bh)
 {
 	int ret;
@@ -421,10 +422,11 @@ submit_and_retry:
 	}
 	if (io->io_bio == NULL)
 		io_submit_init_bio(io, bh);
-	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
+	ret = bio_add_page(io->io_bio, bounce_page ?: pagecache_page,
+			   bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
 		goto submit_and_retry;
-	wbc_account_cgroup_owner(io->io_wbc, page, bh->b_size);
+	wbc_account_cgroup_owner(io->io_wbc, pagecache_page, bh->b_size);
 	io->io_next_block++;
 }
 
@@ -561,8 +563,7 @@ int ext4_bio_write_page(struct ext4_io_s
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		io_submit_add_bh(io, inode,
-				 bounce_page ? bounce_page : page, bh);
+		io_submit_add_bh(io, inode, page, bounce_page, bh);
 	} while ((bh = bh->b_this_page) != head);
 unlock:
 	unlock_page(page);


