Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4191291A1F
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgJRTVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbgJRTVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52422222B9;
        Sun, 18 Oct 2020 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048898;
        bh=dYed6X7UzD5I9VNgwdOoBJJfWoPJ2WkX6zDSm48Mot4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGddnGw6NN2xSzT3tdLA2EieLc0dJZxay+GOPCAtaijZp6+7KnUONdOzHCBRykaEn
         2a8VRL9A90dO7OCBWo7QQj+cKkKTLrkrg6VqseZh2GRGko9NKLEXoGZYW+goZHZd4I
         jsODhMvzSzkpOuFHBcF5M7IuzEzdbzxCkcylzWKs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 059/101] drm/panfrost: add amlogic reset quirk callback
Date:   Sun, 18 Oct 2020 15:19:44 -0400
Message-Id: <20201018192026.4053674-59-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 110003002291525bb209f47e6dbf121a63249a97 ]

The T820, G31 & G52 GPUs integrated by Amlogic in the respective GXM,
G12A/SM1 & G12B SoCs needs a quirk in the PWR registers at the GPU reset
time.

Since the Amlogic's integration of the GPU cores with the SoC is not
publicly documented we do not know what does these values, but they
permit having a fully functional GPU running with Panfrost.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
[Steven: Fix typo in commit log]
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200916150147.25753-3-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c  | 11 +++++++++++
 drivers/gpu/drm/panfrost/panfrost_gpu.h  |  2 ++
 drivers/gpu/drm/panfrost/panfrost_regs.h |  4 ++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index f2c1ddc41a9bf..6606643850fc6 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -75,6 +75,17 @@ int panfrost_gpu_soft_reset(struct panfrost_device *pfdev)
 	return 0;
 }
 
+void panfrost_gpu_amlogic_quirk(struct panfrost_device *pfdev)
+{
+	/*
+	 * The Amlogic integrated Mali-T820, Mali-G31 & Mali-G52 needs
+	 * these undocumented bits in GPU_PWR_OVERRIDE1 to be set in order
+	 * to operate correctly.
+	 */
+	gpu_write(pfdev, GPU_PWR_KEY, GPU_PWR_KEY_UNLOCK);
+	gpu_write(pfdev, GPU_PWR_OVERRIDE1, 0xfff | (0x20 << 16));
+}
+
 static void panfrost_gpu_init_quirks(struct panfrost_device *pfdev)
 {
 	u32 quirks = 0;
diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.h b/drivers/gpu/drm/panfrost/panfrost_gpu.h
index 4112412087b27..468c51e7e46db 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.h
@@ -16,4 +16,6 @@ int panfrost_gpu_soft_reset(struct panfrost_device *pfdev);
 void panfrost_gpu_power_on(struct panfrost_device *pfdev);
 void panfrost_gpu_power_off(struct panfrost_device *pfdev);
 
+void panfrost_gpu_amlogic_quirk(struct panfrost_device *pfdev);
+
 #endif
diff --git a/drivers/gpu/drm/panfrost/panfrost_regs.h b/drivers/gpu/drm/panfrost/panfrost_regs.h
index ea38ac60581c6..eddaa62ad8b0e 100644
--- a/drivers/gpu/drm/panfrost/panfrost_regs.h
+++ b/drivers/gpu/drm/panfrost/panfrost_regs.h
@@ -51,6 +51,10 @@
 #define GPU_STATUS			0x34
 #define   GPU_STATUS_PRFCNT_ACTIVE	BIT(2)
 #define GPU_LATEST_FLUSH_ID		0x38
+#define GPU_PWR_KEY			0x50	/* (WO) Power manager key register */
+#define  GPU_PWR_KEY_UNLOCK		0x2968A819
+#define GPU_PWR_OVERRIDE0		0x54	/* (RW) Power manager override settings */
+#define GPU_PWR_OVERRIDE1		0x58	/* (RW) Power manager override settings */
 #define GPU_FAULT_STATUS		0x3C
 #define GPU_FAULT_ADDRESS_LO		0x40
 #define GPU_FAULT_ADDRESS_HI		0x44
-- 
2.25.1

