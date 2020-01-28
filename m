Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384E014B772
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgA1OO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729359AbgA1OO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9EB12468A;
        Tue, 28 Jan 2020 14:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220868;
        bh=ViKLiKUsFLh8npdo0eFWdWYH7r9YeMZzDa3TMAqTyG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oxuo9aZCv4JKSBkvsLsFG/r4ib6jU3fIekGwposE7P0DrAO+Gwir2Jz7HaZaV3cNO
         DKRx9RzpEiJuxZZKNsuhkh4NWKxYeglH3qtOukBR478CNuIYmxX6nz7eeoSULWY2Vr
         lhcW33HLYu6js3gziBiZ8xWjrpysv8TvGHJCWrF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Shaohua Li <shli@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.4 179/183] md: Avoid namespace collision with bitmap API
Date:   Tue, 28 Jan 2020 15:06:38 +0100
Message-Id: <20200128135847.631280854@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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
 drivers/md/bitmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1671,7 +1671,7 @@ void bitmap_flush(struct mddev *mddev)
 /*
  * free memory that was allocated
  */
-static void bitmap_free(struct bitmap *bitmap)
+static void md_bitmap_free(struct bitmap *bitmap)
 {
 	unsigned long k, pages;
 	struct bitmap_page *bp;
@@ -1721,7 +1721,7 @@ void bitmap_destroy(struct mddev *mddev)
 	if (bitmap->sysfs_can_clear)
 		sysfs_put(bitmap->sysfs_can_clear);
 
-	bitmap_free(bitmap);
+	md_bitmap_free(bitmap);
 }
 
 /*
@@ -1805,7 +1805,7 @@ struct bitmap *bitmap_create(struct mdde
 
 	return bitmap;
  error:
-	bitmap_free(bitmap);
+	md_bitmap_free(bitmap);
 	return ERR_PTR(err);
 }
 
@@ -1904,7 +1904,7 @@ int bitmap_copy_from_slot(struct mddev *
 	*low = lo;
 	*high = hi;
 err:
-	bitmap_free(bitmap);
+	md_bitmap_free(bitmap);
 	return rv;
 }
 EXPORT_SYMBOL_GPL(bitmap_copy_from_slot);


