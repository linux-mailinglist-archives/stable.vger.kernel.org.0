Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630EB412316
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377812AbhITSVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351304AbhITSS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1BBF61A7B;
        Mon, 20 Sep 2021 17:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158584;
        bh=ezMrkwQK4gVmfO+w0CokXNJv9DTEQspGvofP2N70dFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwr1m4vV+b53G6x3oEKcSWs+Mrd4weKxvSI02o72oOZV/ASM13CjyroSynZWtlkdY
         lDrVYYTHKaL5R9/oiFiI97piRDfxrts6nKc6pZlhWJwcqY0UuyYBo/JEM/8p4F6wZH
         Xyha2j7rUBbXJiQezhY4cv8TEP+9ti2UxeXAOdEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Chris Morgan <macromorgan@hotmail.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 191/260] drm/panfrost: Clamp lock region to Bifrost minimum
Date:   Mon, 20 Sep 2021 18:43:29 +0200
Message-Id: <20210920163937.606242841@linuxfoundation.org>
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
@@ -60,7 +60,7 @@ static void lock_region(struct panfrost_
 	/* The size is encoded as ceil(log2) minus(1), which may be calculated
 	 * with fls. The size must be clamped to hardware bounds.
 	 */
-	size = max_t(u64, size, PAGE_SIZE);
+	size = max_t(u64, size, AS_LOCK_REGION_MIN_SIZE);
 	region_width = fls64(size - 1) - 1;
 	region |= region_width;
 
--- a/drivers/gpu/drm/panfrost/panfrost_regs.h
+++ b/drivers/gpu/drm/panfrost/panfrost_regs.h
@@ -318,6 +318,8 @@
 #define AS_FAULTSTATUS_ACCESS_TYPE_READ		(0x2 << 8)
 #define AS_FAULTSTATUS_ACCESS_TYPE_WRITE	(0x3 << 8)
 
+#define AS_LOCK_REGION_MIN_SIZE                 (1ULL << 15)
+
 #define gpu_write(dev, reg, data) writel(data, dev->iomem + reg)
 #define gpu_read(dev, reg) readl(dev->iomem + reg)
 


