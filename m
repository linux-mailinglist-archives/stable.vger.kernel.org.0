Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B097BE931
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbfIYXsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 19:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbfIYXsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 19:48:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2EA222C5;
        Wed, 25 Sep 2019 23:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569455304;
        bh=aDH2TpPySJPqgmT2PsN5g49dcWh0DizBL2BmAH5JLNM=;
        h=Date:From:To:Subject:From;
        b=qzfB1QC0Ghr/ZlSoXj0cMagHfPu1InD/sorCx2DoGe7asYw2xx++ECcJYkB3PZSsh
         b3wSUy0wlwLIzEylrEeKJ36kD7s9DF+hC+kk1tNIvlYG1ZvJfIJOi0b8D/Idyh5I6t
         vNbGwZTthIuFyS1TRUjdXOKBpcy4ncoXUwqcs5/8=
Date:   Wed, 25 Sep 2019 16:48:24 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dave.rodgman@arm.com,
        markus@oberhumer.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 51/76] lib/lzo/lzo1x_compress.c: fix alignment bug
 in lzo-rle
Message-ID: <20190925234824.V0yRYYixK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
