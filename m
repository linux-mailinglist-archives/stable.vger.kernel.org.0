Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E6B59D9CA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243254AbiHWKCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351841AbiHWKAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:00:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A750521B4;
        Tue, 23 Aug 2022 01:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F991CE1B4B;
        Tue, 23 Aug 2022 08:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D19BC433D6;
        Tue, 23 Aug 2022 08:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243908;
        bh=7qKPlnNSAjzMUXbmR4g01RfKXQU2sqDa2PE+Zy4CoJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WeD9M4k8vYLcC9Ky9+hSUQZ3U2KoHEiQsrIYfbXVLDff4wvqq80evKY+kb8gRTzUt
         wWtHKLDbjvwWhRA3IvwkP6ljPNJEFkA2OToSPOeu9tti5QwHld3mrSRPaLFiPKz2LI
         G2mu1qG/YdSqZlBRQSotD6zwGYiJHbUtMfESh46A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.15 007/244] drm/nouveau: recognise GA103
Date:   Tue, 23 Aug 2022 10:22:46 +0200
Message-Id: <20220823080059.332289022@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

commit c20ee5749a3f688d9bab83a3b09b75587153ff13 upstream.

Appears to be ok with general GA10x code.

Signed-off-by: Karol Herbst <kherbst@redhat.com>
Cc: <stable@vger.kernel.org> # v5.15+
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220803142745.2679510-1-kherbst@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../gpu/drm/nouveau/nvkm/engine/device/base.c | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index 62efbd0f3846..b7246b146e51 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2605,6 +2605,27 @@ nv172_chipset = {
 	.fifo     = { 0x00000001, ga102_fifo_new },
 };
 
+static const struct nvkm_device_chip
+nv173_chipset = {
+	.name = "GA103",
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
 static const struct nvkm_device_chip
 nv174_chipset = {
 	.name = "GA104",
@@ -3092,6 +3113,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
 		case 0x167: device->chip = &nv167_chipset; break;
 		case 0x168: device->chip = &nv168_chipset; break;
 		case 0x172: device->chip = &nv172_chipset; break;
+		case 0x173: device->chip = &nv173_chipset; break;
 		case 0x174: device->chip = &nv174_chipset; break;
 		case 0x176: device->chip = &nv176_chipset; break;
 		case 0x177: device->chip = &nv177_chipset; break;
-- 
2.37.2



