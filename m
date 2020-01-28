Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE7A014B5B2
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgA1N7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 08:59:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbgA1N7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 08:59:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC04024683;
        Tue, 28 Jan 2020 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219992;
        bh=vQqvFC09o4R9eUKNMS1v87A0XM3UrGzARO258Rkec2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/mmqisxrQXrxNFHK53hzN7Twn/eHQPvzgbyJyYCT0Px0BgtHl56r0MpYqB7tlRxX
         5dBHU8DvoU0lnKcl1QXC33THvCCcYFzwUzIm/VZbTXNSbtelQtDCuwivwxqwZCfByq
         U2VGg06FsH3qrvxBBos+HJ7P0oo5zixfdCcvX6AI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Shaohua Li <shli@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 43/46] md: Avoid namespace collision with bitmap API
Date:   Tue, 28 Jan 2020 14:58:17 +0100
Message-Id: <20200128135755.369129765@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135749.822297911@linuxfoundation.org>
References: <20200128135749.822297911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e64e4018d572710c44f42c923d4ac059f0a23320 upstream.

bitmap API (include/linux/bitmap.h) has 'bitmap' prefix for its methods.

On the other hand MD bitmap API is special case.
Adding 'md' prefix to it to avoid name space collision.

No functional changes intended.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[only take the bitmap_free change for stable - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bitmap.c     |   10 +++++-----
 drivers/md/bitmap.h     |    2 +-
 drivers/md/md-cluster.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1729,7 +1729,7 @@ void bitmap_flush(struct mddev *mddev)
 /*
  * free memory that was allocated
  */
-void bitmap_free(struct bitmap *bitmap)
+void md_bitmap_free(struct bitmap *bitmap)
 {
 	unsigned long k, pages;
 	struct bitmap_page *bp;
@@ -1763,7 +1763,7 @@ void bitmap_free(struct bitmap *bitmap)
 	kfree(bp);
 	kfree(bitmap);
 }
-EXPORT_SYMBOL(bitmap_free);
+EXPORT_SYMBOL(md_bitmap_free);
 
 void bitmap_wait_behind_writes(struct mddev *mddev)
 {
@@ -1796,7 +1796,7 @@ void bitmap_destroy(struct mddev *mddev)
 	if (mddev->thread)
 		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
 
-	bitmap_free(bitmap);
+	md_bitmap_free(bitmap);
 }
 
 /*
@@ -1887,7 +1887,7 @@ struct bitmap *bitmap_create(struct mdde
 
 	return bitmap;
  error:
-	bitmap_free(bitmap);
+	md_bitmap_free(bitmap);
 	return ERR_PTR(err);
 }
 
@@ -1958,7 +1958,7 @@ struct bitmap *get_bitmap_from_slot(stru
 
 	rv = bitmap_init_from_disk(bitmap, 0);
 	if (rv) {
-		bitmap_free(bitmap);
+		md_bitmap_free(bitmap);
 		return ERR_PTR(rv);
 	}
 
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -271,7 +271,7 @@ int bitmap_resize(struct bitmap *bitmap,
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int bitmap_copy_from_slot(struct mddev *mddev, int slot,
 				sector_t *lo, sector_t *hi, bool clear_bits);
-void bitmap_free(struct bitmap *bitmap);
+void md_bitmap_free(struct bitmap *bitmap);
 void bitmap_wait_behind_writes(struct mddev *mddev);
 #endif
 
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1128,7 +1128,7 @@ int cluster_check_sync_size(struct mddev
 		bm_lockres = lockres_init(mddev, str, NULL, 1);
 		if (!bm_lockres) {
 			pr_err("md-cluster: Cannot initialize %s\n", str);
-			bitmap_free(bitmap);
+			md_bitmap_free(bitmap);
 			return -1;
 		}
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
@@ -1142,11 +1142,11 @@ int cluster_check_sync_size(struct mddev
 			sync_size = sb->sync_size;
 		else if (sync_size != sb->sync_size) {
 			kunmap_atomic(sb);
-			bitmap_free(bitmap);
+			md_bitmap_free(bitmap);
 			return -1;
 		}
 		kunmap_atomic(sb);
-		bitmap_free(bitmap);
+		md_bitmap_free(bitmap);
 	}
 
 	return (my_sync_size == sync_size) ? 0 : -1;


