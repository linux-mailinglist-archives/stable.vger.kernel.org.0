Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 987D314E899
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 07:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgAaGLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 01:11:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:02 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A863420663;
        Fri, 31 Jan 2020 06:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580451062;
        bh=gZnMHpmgJdAp9IfWwMGqKfeNJeEIeoMs4HZnqRiR7sQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t303P3GfkSCMcKA/Ebj+2O/N9FrED5ilnVBRAFC0BzBrvO0kuILkj+bfKwfYdS9DB
         +Ga1cvwE8YqPYiKD/Q5+rnyvghZmG863Hoo+t9IfQxbBwbmgEojuMLQZXzQXajq/aZ
         9Q1YbWvVyBqnHfEk40MNdqTsO40hAsQzGwXpf+gg=
Date:   Thu, 30 Jan 2020 22:11:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, linux@rasmusvillemoes.dk, linux@roeck-us.net,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, yury.norov@gmail.com
Subject:  [patch 001/118] lib/test_bitmap: correct test data
 offsets for 32-bit
Message-ID: <20200131061101.ZKr-lpeii%akpm@linux-foundation.org>
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
