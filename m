Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD4CCA905
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404355AbfJCQgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404352AbfJCQgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:36:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62D772070B;
        Thu,  3 Oct 2019 16:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120564;
        bh=CHkZLjem3nkE1m3RRY4Ods+xDIlfZDJEQ8AWlDXFenE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vthbJ40ltSc7c5i487f0FIJkQ79cTbYfOTNKkHAF2KOEddx/hYLAaTOYBx0qbo7S3
         qWloAxVRbqIf73+IC72k20JKHIUFgFhBu72B1P8eLjJCc7DTAzON0yc5cmj2RoQ7dP
         TDT4ozsCc47WhxfTQ3I4nJhNAEf4A++PWWCYFCxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Rodgman <dave.rodgman@arm.com>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 269/313] lib/lzo/lzo1x_compress.c: fix alignment bug in lzo-rle
Date:   Thu,  3 Oct 2019 17:54:07 +0200
Message-Id: <20191003154559.551134834@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Rodgman <dave.rodgman@arm.com>

commit 09b35b4192f6682dff96a093ab1930998cdb73b4 upstream.

Fix an unaligned access which breaks on platforms where this is not
permitted (e.g., Sparc).

Link: http://lkml.kernel.org/r/20190912145502.35229-1-dave.rodgman@arm.com
Signed-off-by: Dave Rodgman <dave.rodgman@arm.com>
Cc: Dave Rodgman <dave.rodgman@arm.com>
Cc: Markus F.X.J. Oberhumer <markus@oberhumer.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/lzo/lzo1x_compress.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/lzo/lzo1x_compress.c
+++ b/lib/lzo/lzo1x_compress.c
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


