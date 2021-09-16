Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E202640E8B2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356113AbhIPRpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355659AbhIPRl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3762B63295;
        Thu, 16 Sep 2021 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811233;
        bh=K+S7vrtV7L3w5D1KrANIWDKZmxsDT2+8SBdFnzpWBGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfbstJZYHzja6qh5cw/m9AxdL5dLu1I3KgROsnsu1PyZn04tIpeWzjEKtq46cEO1z
         8IwOy6iR373PSe6VHTLbUyr5/j6u1f+a+NqcTNi+ChDA/wuS8lMrU9DVYLMDynAE/P
         H922Ez5ZQNVvxzyjAB/XxRfqSeiT4gqPQR2eSNxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Chris Morgan <macromorgan@hotmail.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.14 431/432] drm/panfrost: Clamp lock region to Bifrost minimum
Date:   Thu, 16 Sep 2021 18:03:00 +0200
Message-Id: <20210916155825.451198622@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>

commit bd7ffbc3ca12629aeb66fb9e28cf42b7f37e3e3b upstream.

When locking a region, we currently clamp to a PAGE_SIZE as the minimum
lock region. While this is valid for Midgard, it is invalid for Bifrost,
where the minimum locking size is 8x larger than the 4k page size. Add a
hardware definition for the minimum lock region size (corresponding to
KBASE_LOCK_REGION_MIN_SIZE_LOG2 in kbase) and respect it.

Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210824173028.7528-4-alyssa.rosenzweig@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c  |    2 +-
 drivers/gpu/drm/panfrost/panfrost_regs.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -63,7 +63,7 @@ static void lock_region(struct panfrost_
 	/* The size is encoded as ceil(log2) minus(1), which may be calculated
 	 * with fls. The size must be clamped to hardware bounds.
 	 */
-	size = max_t(u64, size, PAGE_SIZE);
+	size = max_t(u64, size, AS_LOCK_REGION_MIN_SIZE);
 	region_width = fls64(size - 1) - 1;
 	region |= region_width;
 
--- a/drivers/gpu/drm/panfrost/panfrost_regs.h
+++ b/drivers/gpu/drm/panfrost/panfrost_regs.h
@@ -319,6 +319,8 @@
 #define AS_FAULTSTATUS_ACCESS_TYPE_READ		(0x2 << 8)
 #define AS_FAULTSTATUS_ACCESS_TYPE_WRITE	(0x3 << 8)
 
+#define AS_LOCK_REGION_MIN_SIZE                 (1ULL << 15)
+
 #define gpu_write(dev, reg, data) writel(data, dev->iomem + reg)
 #define gpu_read(dev, reg) readl(dev->iomem + reg)
 


