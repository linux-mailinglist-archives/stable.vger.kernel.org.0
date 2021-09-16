Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F9740E11F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241642AbhIPQ1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241633AbhIPQZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:25:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E149061269;
        Thu, 16 Sep 2021 16:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809007;
        bh=MFn2xFF6eedNKjNLfyzWj+URVZpOwNk54p1yf31t4VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baEm8fuSNgwVzjSy0YSCgZnuu/9dN7SGPGyte4hc9yx1svERrX1oLzYrpcApEVV6D
         pGEx1PXDL28hK1KcxuocEvB5etcSZiLdDPmL2pJVZBDlcnhGomRtJSkYdx9KYo4BSp
         1Mke9Ss/yUSzuInlyoXwTveuHs4hmHVDYJM8byQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>,
        Chris Morgan <macromorgan@hotmail.com>
Subject: [PATCH 5.10 303/306] drm/panfrost: Simplify lock_region calculation
Date:   Thu, 16 Sep 2021 18:00:48 +0200
Message-Id: <20210916155804.418777102@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
@@ -59,21 +59,12 @@ static void lock_region(struct panfrost_
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


