Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B974BFB29
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 23:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfIZVvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 17:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbfIZVvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Sep 2019 17:51:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ED2E22459;
        Thu, 26 Sep 2019 21:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569534659;
        bh=acBMVvJZx0Qy2l8t/1XUd7hk5TzAO+7/jpm2L7V7xM8=;
        h=Date:From:To:Subject:From;
        b=GxG9y6avPm031ovmj7I8922A0YmLOQA07MZ4eeNuFVqLSSCNbq9+WeMSI+m+vJHxT
         HQ6Ua1CE8LwULyTszGql6Lxk0Bdwki3jr4CA0RHDua6HpVGy1sDVDsdy60bQQ37QgE
         gOxv05Sj6gjy9odyyw7rlLna9Yl2ax8uSuzCYWc0=
Date:   Thu, 26 Sep 2019 14:50:59 -0700
From:   akpm@linux-foundation.org
To:     dave.rodgman@arm.com, markus@oberhumer.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged] lib-lzo-fix-alignment-bug-in-lzo-rle.patch
 removed from -mm tree
Message-ID: <20190926215059.pxyyHTQR4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/lzo/lzo1x_compress.c: fix alignment bug in lzo-rle
has been removed from the -mm tree.  Its filename was
     lib-lzo-fix-alignment-bug-in-lzo-rle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Rodgman <dave.rodgman@arm.com>
Subject: lib/lzo/lzo1x_compress.c: fix alignment bug in lzo-rle

Fix an unaligned access which breaks on platforms where this is not
permitted (e.g., Sparc).

Link: http://lkml.kernel.org/r/20190912145502.35229-1-dave.rodgman@arm.com
Signed-off-by: Dave Rodgman <dave.rodgman@arm.com>
Cc: Dave Rodgman <dave.rodgman@arm.com>
Cc: Markus F.X.J. Oberhumer <markus@oberhumer.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lzo/lzo1x_compress.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/lzo/lzo1x_compress.c~lib-lzo-fix-alignment-bug-in-lzo-rle
+++ a/lib/lzo/lzo1x_compress.c
@@ -83,17 +83,19 @@ next:
 					ALIGN((uintptr_t)ir, 4)) &&
 					(ir < limit) && (*ir == 0))
 				ir++;
-			for (; (ir + 4) <= limit; ir += 4) {
-				dv = *((u32 *)ir);
-				if (dv) {
+			if (IS_ALIGNED((uintptr_t)ir, 4)) {
+				for (; (ir + 4) <= limit; ir += 4) {
+					dv = *((u32 *)ir);
+					if (dv) {
 #  if defined(__LITTLE_ENDIAN)
-					ir += __builtin_ctz(dv) >> 3;
+						ir += __builtin_ctz(dv) >> 3;
 #  elif defined(__BIG_ENDIAN)
-					ir += __builtin_clz(dv) >> 3;
+						ir += __builtin_clz(dv) >> 3;
 #  else
 #    error "missing endian definition"
 #  endif
-					break;
+						break;
+					}
 				}
 			}
 #endif
_

Patches currently in -mm which might be from dave.rodgman@arm.com are


