Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82756B83C1
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 23:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389316AbfISVyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 17:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389212AbfISVyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 17:54:52 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D0A1208C0;
        Thu, 19 Sep 2019 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930091;
        bh=KIhQ48U3dNoiHkDzOX49U/niastsj2CuhmI/VaL0iUU=;
        h=Date:From:To:Subject:From;
        b=k12L6nFSz9RFJBkDyKai2b7BqGfTUpBUK40dvS2ZusRtJGIgxiCtreRAQq5M/qEmj
         4mUEBzPzEstxo4nEwBtPhrpK+vpMMr6UXI6A+XGcJF00Ug+yvufYvjpYqzAuoEY0/Y
         XIddsW7DBGcsLmqCqQmEg8K+ZFZWy0/RsZ2vaQHg=
Date:   Thu, 19 Sep 2019 14:54:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        minchan@kernel.org, markus@oberhumer.com, dave.rodgman@arm.com
Subject:  + lib-lzo-fix-alignment-bug-in-lzo-rle.patch added to -mm
 tree
Message-ID: <20190919215450.AcDnN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/lzo/lzo1x_compress.c: fix alignment bug in lzo-rle
has been added to the -mm tree.  Its filename is
     lib-lzo-fix-alignment-bug-in-lzo-rle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-lzo-fix-alignment-bug-in-lzo-rle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-lzo-fix-alignment-bug-in-lzo-rle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-lzo-fix-alignment-bug-in-lzo-rle.patch

