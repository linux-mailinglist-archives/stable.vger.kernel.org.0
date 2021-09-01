Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76673FDC86
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345425AbhIAMvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346209AbhIAMte (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B559061054;
        Wed,  1 Sep 2021 12:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500076;
        bh=Qq4OgdnOaggN6QkR5OfPnQXwH7SN2ps8A4x/L0CvvRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GA+7Tq77CrwxlbgkauuSibkVoxYE1qDjKy2tFiw+UwG8pr6NG+OhbUbyAr9NQnTTR
         0PpER3OC2WemqIjW0lTp3rRU/DDEb1KEWVr/4jxJGBtzWx5JTyXcBU5igUffESPr8g
         HCNe27KsMiw0+q1MxrITm07VDswnaKUCyk7k6mPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 092/113] drm/nouveau: recognise GA107
Date:   Wed,  1 Sep 2021 14:28:47 +0200
Message-Id: <20210901122305.028751285@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



