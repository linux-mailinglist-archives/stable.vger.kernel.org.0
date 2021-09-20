Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBEA41231A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377820AbhITSVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377312AbhITSSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB14261A6E;
        Mon, 20 Sep 2021 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158569;
        bh=QTEgV2+CbJtibhd5MRwlttmhRzZyvvCqZLS1PqVA2m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhP48dEZNa2YDOGvmj7uAvD+lH8Yce19Zw+c6LdCeKMr/UkI2oVhNeuDyLvo3foLe
         3W+/Wu8HA53vzBkisH5U68qC/TNZGwaFQ9qjpWz3TvyzCNn7ki09gKm5GKJXcawNVl
         rZtkxwAeHgHEcf9c/3SV6R5QjyvoG1Wki6C882ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>,
        Chris Morgan <macromorgan@hotmail.com>
Subject: [PATCH 5.4 189/260] drm/panfrost: Simplify lock_region calculation
Date:   Mon, 20 Sep 2021 18:43:27 +0200
Message-Id: <20210920163937.542111669@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>

commit b5fab345654c603c07525100d744498f28786929 upstream.

In lock_region, simplify the calculation of the region_width parameter.
This field is the size, but encoded as ceil(log2(size)) - 1.
ceil(log2(size)) may be computed directly as fls(size - 1). However, we
want to use the 64-bit versions as the amount to lock can exceed
32-bits.

This avoids undefined (and completely wrong) behaviour when locking all
memory (size ~0). In this case, the old code would "round up" ~0 to the
nearest page, overflowing to 0. Since fls(0) == 0, this would calculate
a region width of 10 + 0 = 10. But then the code would shift by
(region_width - 11) = -1. As shifting by a negative number is undefined,
UBSAN flags the bug. Of course, even if it were defined the behaviour is
wrong, instead of locking all memory almost none would get locked.

The new form of the calculation corrects this special case and avoids
the undefined behaviour.

Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Reported-and-tested-by: Chris Morgan <macromorgan@hotmail.com>
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Cc: <stable@vger.kernel.org>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210824173028.7528-2-alyssa.rosenzweig@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -56,21 +56,12 @@ static void lock_region(struct panfrost_
 {
 	u8 region_width;
 	u64 region = iova & PAGE_MASK;
-	/*
-	 * fls returns:
-	 * 1 .. 32
-	 *
-	 * 10 + fls(num_pages)
-	 * results in the range (11 .. 42)
-	 */
-
-	size = round_up(size, PAGE_SIZE);
 
-	region_width = 10 + fls(size >> PAGE_SHIFT);
-	if ((size >> PAGE_SHIFT) != (1ul << (region_width - 11))) {
-		/* not pow2, so must go up to the next pow2 */
-		region_width += 1;
-	}
+	/* The size is encoded as ceil(log2) minus(1), which may be calculated
+	 * with fls. The size must be clamped to hardware bounds.
+	 */
+	size = max_t(u64, size, PAGE_SIZE);
+	region_width = fls64(size - 1) - 1;
 	region |= region_width;
 
 	/* Lock the region that needs to be updated */


