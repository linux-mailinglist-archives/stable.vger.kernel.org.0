Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2C34625F7
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbhK2Wpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbhK2WpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:45:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DEFC19AC00;
        Mon, 29 Nov 2021 10:35:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4585DCE1685;
        Mon, 29 Nov 2021 18:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73CEC53FC7;
        Mon, 29 Nov 2021 18:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210927;
        bh=ycupgcE9S+lsZetBlH+zSi9yeMp7t3H3EFmHg5I7wNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRU8/3ZJNCk4G+bWOFA3iocgxJY4moxMBbUBw/NeRPuH+zYDxNadLdfRRCxDngCBz
         p7utZuHeI4JsjGDRXVF34k1yqBpYhmU2FkOkaI6SEjZ3eENCRrgNppvNEFkEIjv3tM
         IF38NPUs0cIkpE2TvAB9snRVZctiQwlo55sZWr40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.15 043/179] drm/nouveau: recognise GA106
Date:   Mon, 29 Nov 2021 19:17:17 +0100
Message-Id: <20211129181720.380333199@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

commit 46741e4f593ff1bd0e4a140ab7e566701946484b upstream.

I've got HW now, appears to work as expected so far.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: <stable@vger.kernel.org> # 5.14+
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211118030413.2610-1-skeggsb@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2627,6 +2627,27 @@ nv174_chipset = {
 };
 
 static const struct nvkm_device_chip
+nv176_chipset = {
+	.name = "GA106",
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
+	.fifo     = { 0x00000001, ga102_fifo_new },
+};
+
+static const struct nvkm_device_chip
 nv177_chipset = {
 	.name = "GA107",
 	.bar      = { 0x00000001, tu102_bar_new },
@@ -3072,6 +3093,7 @@ nvkm_device_ctor(const struct nvkm_devic
 		case 0x168: device->chip = &nv168_chipset; break;
 		case 0x172: device->chip = &nv172_chipset; break;
 		case 0x174: device->chip = &nv174_chipset; break;
+		case 0x176: device->chip = &nv176_chipset; break;
 		case 0x177: device->chip = &nv177_chipset; break;
 		default:
 			if (nvkm_boolopt(device->cfgopt, "NvEnableUnsupportedChipsets", false)) {


