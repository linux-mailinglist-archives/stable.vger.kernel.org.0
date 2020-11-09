Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148212ABBDC
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgKINIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731626AbgKINIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B9E20789;
        Mon,  9 Nov 2020 13:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927299;
        bh=ewZJdkreJt73NoSDogfhx3hcp1u4U3+ieF6b3mjvZ2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pytliUw1IH54QJ4kLOe5xe0Hk3QOR+ox4gJCV7svZ+IJmWVlCmj/iW3eljgJ54TLK
         jdZMebC7V/w3OTsr9YWZdFZrqO2m76uf6YsfnDZtKBQT222pPw9hJrZ11XjSHE1yrF
         Kw4RrvR4F9Ou03zX0YHk3pvf5Oa/0cCkmElWwT8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 13/71] btrfs: extent_io: Kill the forward declaration of flush_write_bio
Date:   Mon,  9 Nov 2020 13:55:07 +0100
Message-Id: <20201109125020.534651064@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit bb58eb9e167d087cc518f7a71c3c00f1671958da upstream.

There is no need to forward declare flush_write_bio(), as it only
depends on submit_one_bio().  Both of them are pretty small, just move
them to kill the forward declaration.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Cherry-picked for 4.19 to ease backporting later fixes]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   66 ++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -138,7 +138,38 @@ static int add_extent_changeset(struct e
 	return ret;
 }
 
-static void flush_write_bio(struct extent_page_data *epd);
+static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
+				       unsigned long bio_flags)
+{
+	blk_status_t ret = 0;
+	struct bio_vec *bvec = bio_last_bvec_all(bio);
+	struct page *page = bvec->bv_page;
+	struct extent_io_tree *tree = bio->bi_private;
+	u64 start;
+
+	start = page_offset(page) + bvec->bv_offset;
+
+	bio->bi_private = NULL;
+
+	if (tree->ops)
+		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
+					   mirror_num, bio_flags, start);
+	else
+		btrfsic_submit_bio(bio);
+
+	return blk_status_to_errno(ret);
+}
+
+static void flush_write_bio(struct extent_page_data *epd)
+{
+	if (epd->bio) {
+		int ret;
+
+		ret = submit_one_bio(epd->bio, 0, 0);
+		BUG_ON(ret < 0); /* -ENOMEM */
+		epd->bio = NULL;
+	}
+}
 
 int __init extent_io_init(void)
 {
@@ -2710,28 +2741,6 @@ struct bio *btrfs_bio_clone_partial(stru
 	return bio;
 }
 
-static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
-				       unsigned long bio_flags)
-{
-	blk_status_t ret = 0;
-	struct bio_vec *bvec = bio_last_bvec_all(bio);
-	struct page *page = bvec->bv_page;
-	struct extent_io_tree *tree = bio->bi_private;
-	u64 start;
-
-	start = page_offset(page) + bvec->bv_offset;
-
-	bio->bi_private = NULL;
-
-	if (tree->ops)
-		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
-					   mirror_num, bio_flags, start);
-	else
-		btrfsic_submit_bio(bio);
-
-	return blk_status_to_errno(ret);
-}
-
 /*
  * @opf:	bio REQ_OP_* and REQ_* flags as one value
  * @tree:	tree so we can call our merge_bio hook
@@ -4033,17 +4042,6 @@ retry:
 	return ret;
 }
 
-static void flush_write_bio(struct extent_page_data *epd)
-{
-	if (epd->bio) {
-		int ret;
-
-		ret = submit_one_bio(epd->bio, 0, 0);
-		BUG_ON(ret < 0); /* -ENOMEM */
-		epd->bio = NULL;
-	}
-}
-
 int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 {
 	int ret;


