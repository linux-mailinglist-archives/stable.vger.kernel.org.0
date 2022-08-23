Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9993A59D367
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbiHWIMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241834AbiHWIJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2125C24BD4;
        Tue, 23 Aug 2022 01:06:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C142B81C19;
        Tue, 23 Aug 2022 08:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974EAC433D7;
        Tue, 23 Aug 2022 08:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241969;
        bh=T+DYn5Fq8FGf1pD9DE5wI13Mf79PBMKBMOI7+SrtCaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqKplEop9y6qYbQfWqR1CfEqFvpAcoDW7FWWPPOFvDTKHcPXWBWzRjOXzWe0XT8va
         32M25+laYPQy7AGFjqjYW7fufuS8uC1JT76+Rt1Ip1Bfr23FdpvaNMyx5tFumTcwdP
         aXcDCfEj57Xg1GezDBoh/jGjOxcdihHefqQKBxjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.19 009/365] drm/nouveau: recognise GA103
Date:   Tue, 23 Aug 2022 09:58:30 +0200
Message-Id: <20220823080118.557303638@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2606,6 +2606,27 @@ nv172_chipset = {
 };
 
 static const struct nvkm_device_chip
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
+static const struct nvkm_device_chip
 nv174_chipset = {
 	.name = "GA104",
 	.bar      = { 0x00000001, tu102_bar_new },
@@ -3092,6 +3113,7 @@ nvkm_device_ctor(const struct nvkm_devic
 		case 0x167: device->chip = &nv167_chipset; break;
 		case 0x168: device->chip = &nv168_chipset; break;
 		case 0x172: device->chip = &nv172_chipset; break;
+		case 0x173: device->chip = &nv173_chipset; break;
 		case 0x174: device->chip = &nv174_chipset; break;
 		case 0x176: device->chip = &nv176_chipset; break;
 		case 0x177: device->chip = &nv177_chipset; break;


