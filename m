Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DD32AB95B
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgKINIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731664AbgKINIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91D3B2076E;
        Mon,  9 Nov 2020 13:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927311;
        bh=ComJf9D52Oz0A/H1nooircs6qDFo+Nb/quiTYKT8his=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKg48L6V5pZsfDt75pgEg2En+CF68m6YMqWdrS54FRoZCYLuDCQumMw6HXTfgbYsR
         /YLnO9ByXtBHwaaMcr0fe9RU54ZkD24Pil0SLqJRdTiY59bkBsWTWpTo9+aspy/O83
         Z4qpqFTuFsq3zN5Xusfd8nTWbZMZ1Khwf7j/eVeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 17/71] btrfs: extent_io: Handle errors better in extent_write_full_page()
Date:   Mon,  9 Nov 2020 13:55:11 +0100
Message-Id: <20201109125020.725148118@linuxfoundation.org>
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

commit 3065976b045f77a910809fa7699f99a1e7c0dbbb upstream.

Since now flush_write_bio() could return error, kill the BUG_ON() first.
Then don't call flush_write_bio() unconditionally, instead we check the
return value from __extent_writepage() first.

If __extent_writepage() fails, we do cleanup, and return error without
submitting the possible corrupted or half-baked bio.

If __extent_writepage() successes, then we call flush_write_bio() and
return the result.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -160,6 +160,16 @@ static int __must_check submit_one_bio(s
 	return blk_status_to_errno(ret);
 }
 
+/* Cleanup unsubmitted bios */
+static void end_write_bio(struct extent_page_data *epd, int ret)
+{
+	if (epd->bio) {
+		epd->bio->bi_status = errno_to_blk_status(ret);
+		bio_endio(epd->bio);
+		epd->bio = NULL;
+	}
+}
+
 /*
  * Submit bio from extent page data via submit_one_bio
  *
@@ -3461,6 +3471,9 @@ done:
  * records are inserted to lock ranges in the tree, and as dirty areas
  * are found, they are marked writeback.  Then the lock bits are removed
  * and the end_io handler clears the writeback ranges
+ *
+ * Return 0 if everything goes well.
+ * Return <0 for error.
  */
 static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			      struct extent_page_data *epd)
@@ -3528,6 +3541,7 @@ done:
 		end_extent_writepage(page, ret, start, page_end);
 	}
 	unlock_page(page);
+	ASSERT(ret <= 0);
 	return ret;
 
 done_unlocked:
@@ -4067,7 +4081,6 @@ retry:
 int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
-	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(page->mapping->host)->io_tree,
@@ -4076,9 +4089,14 @@ int extent_write_full_page(struct page *
 	};
 
 	ret = __extent_writepage(page, wbc, &epd);
+	ASSERT(ret <= 0);
+	if (ret < 0) {
+		end_write_bio(&epd, ret);
+		return ret;
+	}
 
-	flush_ret = flush_write_bio(&epd);
-	BUG_ON(flush_ret < 0);
+	ret = flush_write_bio(&epd);
+	ASSERT(ret <= 0);
 	return ret;
 }
 


