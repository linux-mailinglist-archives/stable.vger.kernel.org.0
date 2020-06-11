Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C191F6FFC
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 00:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgFKWW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 18:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgFKWW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 18:22:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B01D12075F;
        Thu, 11 Jun 2020 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591914179;
        bh=Wna8aT8h6bzpueRqvRBZpyEAIkEfLAPCa1vKpjYINbo=;
        h=Date:From:To:Subject:From;
        b=n1zHqMekHDZNNb8coD/hHmGgWUCg8yjXyqpydybtfxe2reRBJwUtG/7XeylwA6hyH
         lqJdUJNjppN+G+yOr7ya9180GZBhsz4elMlrBoDE2qY3J9A/4ywfQLFN/kvtpMLwno
         sgFK48Tm9NYUMa0voMULTI1JotlpwkOhH36Onnkw=
Date:   Thu, 11 Jun 2020 15:22:58 -0700
From:   akpm@linux-foundation.org
To:     acme@redhat.com, agordeev@linux.ibm.com, amritha.nambiar@intel.com,
        andriy.shevchenko@linux.intel.com, andy.shevchenko@gmail.com,
        chris@chris-wilson.co.uk, keescook@chromium.org,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        mszeredi@redhat.com, stable@vger.kernel.org,
        steffen.klassert@secunet.com, tobin@kernel.org,
        vineet.gupta1@synopsys.com, will.deacon@arm.com,
        willemb@google.com, willy@infradead.org, yury.norov@gmail.com
Subject:  [merged]
 lib-fix-bitmap_parse-on-64-bit-big-endian-archs.patch removed from -mm tree
Message-ID: <20200611222258.PU_jubF1t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib: fix bitmap_parse() on 64-bit big endian archs
has been removed from the -mm tree.  Its filename was
     lib-fix-bitmap_parse-on-64-bit-big-endian-archs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: lib: fix bitmap_parse() on 64-bit big endian archs

Commit 2d6261583be0 ("lib: rework bitmap_parse()") does not take into
account order of halfwords on 64-bit big endian architectures.  As result
(at least) Receive Packet Steering, IRQ affinity masks and runtime kernel
test "test_bitmap" get broken on s390.

[andriy.shevchenko@linux.intel.com: convert infinite while loop to a for loop]
  Link: http://lkml.kernel.org/r/20200609140535.87160-1-andriy.shevchenko@linux.intel.com
Link: http://lkml.kernel.org/r/1591634471-17647-1-git-send-email-agordeev@linux.ibm.com
Fixes: 2d6261583be0 ("lib: rework bitmap_parse()")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/bitmap.c~lib-fix-bitmap_parse-on-64-bit-big-endian-archs
+++ a/lib/bitmap.c
@@ -741,8 +741,9 @@ int bitmap_parse(const char *start, unsi
 	int chunks = BITS_TO_U32(nmaskbits);
 	u32 *bitmap = (u32 *)maskp;
 	int unset_bit;
+	int chunk;
 
-	while (1) {
+	for (chunk = 0; ; chunk++) {
 		end = bitmap_find_region_reverse(start, end);
 		if (start > end)
 			break;
@@ -750,7 +751,11 @@ int bitmap_parse(const char *start, unsi
 		if (!chunks--)
 			return -EOVERFLOW;
 
-		end = bitmap_get_x32_reverse(start, end, bitmap++);
+#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
+		end = bitmap_get_x32_reverse(start, end, &bitmap[chunk ^ 1]);
+#else
+		end = bitmap_get_x32_reverse(start, end, &bitmap[chunk]);
+#endif
 		if (IS_ERR(end))
 			return PTR_ERR(end);
 	}
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


