Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4251114F51E
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 00:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgAaXQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 18:16:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 18:16:30 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 104E320705;
        Fri, 31 Jan 2020 23:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580512589;
        bh=wplLNDMlIN1zpefWY+PpGOE1BHXG2/H4q6SaC+/f7m8=;
        h=Date:From:To:Subject:From;
        b=bNJLEvCWYl90lZUP5rPl/Q9Vs+5vofAmurEAtSIyNy/psJe+r/UDmLHmTNUVURF7f
         rILyuSU+VzQfH/xc+hI9X4uMwUUgfVpHkyapMEqhdGOsgVrXUQ0baKAdp9s4OgDde7
         eEdNJmFcdHey/NjBvj0O0guIgH/wML72K2rwo9+E=
Date:   Fri, 31 Jan 2020 15:16:28 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        linux@roeck-us.net, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, yury.norov@gmail.com
Subject:  [merged]
 lib-test_bitmap-correct-test-data-offsets-for-32-bit.patch removed from -mm
 tree
Message-ID: <20200131231628.Kp_8AWnpK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/test_bitmap: correct test data offsets for 32-bit
has been removed from the -mm tree.  Its filename was
     lib-test_bitmap-correct-test-data-offsets-for-32-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test_bitmap: correct test data offsets for 32-bit

On 32-bit platform the size of long is only 32 bits which makes wrong
offset in the array of 64 bit size.

Calculate offset based on BITS_PER_LONG.

Link: http://lkml.kernel.org/r/20200109103601.45929-1-andriy.shevchenko@linux.intel.com
Fixes: 30544ed5de43 ("lib/bitmap: introduce bitmap_replace() helper")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/lib/test_bitmap.c~lib-test_bitmap-correct-test-data-offsets-for-32-bit
+++ a/lib/test_bitmap.c
@@ -275,22 +275,23 @@ static void __init test_copy(void)
 static void __init test_replace(void)
 {
 	unsigned int nbits = 64;
+	unsigned int nlongs = DIV_ROUND_UP(nbits, BITS_PER_LONG);
 	DECLARE_BITMAP(bmap, 1024);
 
 	bitmap_zero(bmap, 1024);
-	bitmap_replace(bmap, &exp2[0], &exp2[1], exp2_to_exp3_mask, nbits);
+	bitmap_replace(bmap, &exp2[0 * nlongs], &exp2[1 * nlongs], exp2_to_exp3_mask, nbits);
 	expect_eq_bitmap(bmap, exp3_0_1, nbits);
 
 	bitmap_zero(bmap, 1024);
-	bitmap_replace(bmap, &exp2[1], &exp2[0], exp2_to_exp3_mask, nbits);
+	bitmap_replace(bmap, &exp2[1 * nlongs], &exp2[0 * nlongs], exp2_to_exp3_mask, nbits);
 	expect_eq_bitmap(bmap, exp3_1_0, nbits);
 
 	bitmap_fill(bmap, 1024);
-	bitmap_replace(bmap, &exp2[0], &exp2[1], exp2_to_exp3_mask, nbits);
+	bitmap_replace(bmap, &exp2[0 * nlongs], &exp2[1 * nlongs], exp2_to_exp3_mask, nbits);
 	expect_eq_bitmap(bmap, exp3_0_1, nbits);
 
 	bitmap_fill(bmap, 1024);
-	bitmap_replace(bmap, &exp2[1], &exp2[0], exp2_to_exp3_mask, nbits);
+	bitmap_replace(bmap, &exp2[1 * nlongs], &exp2[0 * nlongs], exp2_to_exp3_mask, nbits);
 	expect_eq_bitmap(bmap, exp3_1_0, nbits);
 }
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-add-test-for-bitmap_parse-fix-2.patch

