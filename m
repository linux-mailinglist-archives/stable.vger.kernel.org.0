Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC93F5491
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhHXAzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234015AbhHXAzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C198613CD;
        Tue, 24 Aug 2021 00:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766463;
        bh=Qq4OgdnOaggN6QkR5OfPnQXwH7SN2ps8A4x/L0CvvRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8NYoD9Ifkew8EEFR8wAHuMUc3vjiqIGsSKvxD6+WnkzVRX8RjCMMvlNOcGbFUD0L
         mpKDGDZ4faMVz6S+blDg1L0jZY9uocAe34H319b8WL4fEA+J7z1BwWSeCdyM82aT8O
         kuhDZJ8EBfGEr5d3EVcQzORDOvsqUWpKnHdUNLgL03PqQS6sU04FJaDqzi5lLa1Xd/
         xhHqSViBUfGeRjDtD9XkkmyHN998eaWlxaeMTPIHapwH64RZmWYPGaNuGDLGSGYIS2
         umDAh1QGksBzuKgicthx49LV5X/SSap7YjKx9B2gsuDclKxD43SUjnOnl2nKdTK8ZO
         gH26BFdQBFNUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 20/26] drm/nouveau: recognise GA107
Date:   Mon, 23 Aug 2021 20:53:50 -0400
Message-Id: <20210824005356.630888-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit fa25f28ef2cef19bc9ffeb827b8ecbf48af7f892 ]

Still no GA106 as I don't have HW to verif.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/nouveau/nvkm/engine/device/base.c | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index b930f539feec..93ddf63d1114 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2624,6 +2624,26 @@ nv174_chipset = {
 	.dma      = { 0x00000001, gv100_dma_new },
 };
 
+static const struct nvkm_device_chip
+nv177_chipset = {
+	.name = "GA107",
+	.bar      = { 0x00000001, tu102_bar_new },
+	.bios     = { 0x00000001, nvkm_bios_new },
+	.devinit  = { 0x00000001, ga100_devinit_new },
+	.fb       = { 0x00000001, ga102_fb_new },
+	.gpio     = { 0x00000001, ga102_gpio_new },
+	.i2c      = { 0x00000001, gm200_i2c_new },
+	.imem     = { 0x00000001, nv50_instmem_new },
+	.mc       = { 0x00000001, ga100_mc_new },
+	.mmu      = { 0x00000001, tu102_mmu_new },
+	.pci      = { 0x00000001, gp100_pci_new },
+	.privring = { 0x00000001, gm200_privring_new },
+	.timer    = { 0x00000001, gk20a_timer_new },
+	.top      = { 0x00000001, ga100_top_new },
+	.disp     = { 0x00000001, ga102_disp_new },
+	.dma      = { 0x00000001, gv100_dma_new },
+};
+
 static int
 nvkm_device_event_ctor(struct nvkm_object *object, void *data, u32 size,
 		       struct nvkm_notify *notify)
@@ -3049,6 +3069,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
 		case 0x168: device->chip = &nv168_chipset; break;
 		case 0x172: device->chip = &nv172_chipset; break;
 		case 0x174: device->chip = &nv174_chipset; break;
+		case 0x177: device->chip = &nv177_chipset; break;
 		default:
 			if (nvkm_boolopt(device->cfgopt, "NvEnableUnsupportedChipsets", false)) {
 				switch (device->chipset) {
-- 
2.30.2

