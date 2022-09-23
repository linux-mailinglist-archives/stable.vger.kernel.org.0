Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E025E8122
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiIWRw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiIWRw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:52:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C036912C1C2
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 10:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D2846108C
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 17:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B749C433C1;
        Fri, 23 Sep 2022 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663955544;
        bh=XBeUmV8AIEsPM5jSdNQvF/ZZjnm7scrVu6NNYlFhyKI=;
        h=Subject:To:Cc:From:Date:From;
        b=A67darBdY846bovzQVLFNa+3UNmYhT287DPSe1UeKjoq4a3myWFpeLD0vgiRdBOyU
         6Xbir615F6q0IHIzYt9Jk2RQp/yHwKOd/wZyUTOgsHyextVjEpaGLWTpnDONDW3a1U
         Kf78Pe0DPu+tme9hFLAcXuu4xtsWBruxQcDX1Lx0=
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek: Add a quirk for HP OMEN 16 (8902) mute LED" failed to apply to 5.15-stable tree
To:     dhould3@gmail.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 23 Sep 2022 19:52:22 +0200
Message-ID: <166395554299179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

496322302bf1 ("ALSA: hda/realtek: Add a quirk for HP OMEN 16 (8902) mute LED")
5f5d8890789c ("ALSA: hda/realtek: Enable mute/micmute LEDs support for HP Laptops")
07bcab93946c ("ALSA: hda/realtek: Add support for HP Laptops")
91502a9a0b0d ("ALSA: hda/realtek: fix speakers and micmute on HP 855 G8")
ae7abe36e352 ("ALSA: hda/realtek: Add CS35L41 support for Thinkpad laptops")
d3dca026375f ("ALSA: hda/realtek: Add support for Legion 7 16ACHg6 laptop")
2aac550da325 ("ALSA: hda/realtek: Re-order quirk entries for Lenovo")
8f4c90427a8f ("ALSA: hda/realtek: Add quirk for Legion Y9000X 2020")
08977fe8cfb7 ("ALSA: hda/realtek: Use ALC285_FIXUP_HP_GPIO_LED on another HP laptop")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 496322302bf1e58dc2ff134173527493105f51ab Mon Sep 17 00:00:00 2001
From: Daniel Houldsworth <dhould3@gmail.com>
Date: Sun, 18 Sep 2022 18:13:00 +0100
Subject: [PATCH] ALSA: hda/realtek: Add a quirk for HP OMEN 16 (8902) mute LED

Similair to the HP OMEN 15, the HP OMEN 16 also needs
ALC285_FIXUP_HP_MUTE_LED for the mute LED to work.

[ Rearranged the entry in PCI SSID order by tiwai ]

Signed-off-by: Daniel Houldsworth <dhould3@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220918171300.24693-1-dhould3@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ab0ee0565706..f9d46ae4c7b7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9314,6 +9314,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x896e, "HP EliteBook x360 830 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8971, "HP EliteBook 830 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8972, "HP EliteBook 840 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),

