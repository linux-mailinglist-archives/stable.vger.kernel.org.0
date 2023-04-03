Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA59A6D488F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbjDCO3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbjDCO3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EFA319AA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C74BB61DE3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B54C433D2;
        Mon,  3 Apr 2023 14:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532177;
        bh=OcLHVubkdzeb5/bdCzqBaw1wvW5keTBpbV7ZGEEGEZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UW8vkezKvrKevvNkavd3d8KUz2JxrZA8re7YxvS2lVbzvkAEWmnGCDUQDkY6mVlNE
         sV3q3h0sEv5stSxSPVZQcPs+k1SE0iDBG/NA5tzb4eKDsCJbHhAHenDZW+7mO78Q3o
         3IH3Rah7BwyammJrWARfOL+5LZ7g/QOxHcLQ8gO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jetro Jormalainen <jje-lxkl@jetro.fi>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 157/173] ALSA: hda/conexant: Partial revert of a quirk for Lenovo
Date:   Mon,  3 Apr 2023 16:09:32 +0200
Message-Id: <20230403140419.533163685@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b871cb971c683f7f212e7ca3c9a6709a75785116 upstream.

The recent commit f83bb2592482 ("ALSA: hda/conexant: Add quirk for
LENOVO 20149 Notebook model") introduced a quirk for the device with
17aa:3977, but this caused a regression on another model (Lenovo
Ideadpad U31) with the very same PCI SSID.  And, through skimming over
the net, it seems that this PCI SSID is used for multiple different
models, so it's no good idea to apply the quirk with the SSID.

Although we may take a different ID check (e.g. the codec SSID instead
of the PCI SSID), unfortunately, the original patch author couldn't
identify the hardware details any longer as the machine was returned,
and we can't develop the further proper fix.

In this patch, instead, we partially revert the change so that the
quirk won't be applied as default for addressing the regression.
Meanwhile, the quirk function itself is kept, and it's now made to be
applicable via the explicit model=lenovo-20149 option.

Fixes: f83bb2592482 ("ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model")
Reported-by: Jetro Jormalainen <jje-lxkl@jetro.fi>
Link: https://lore.kernel.org/r/20230308215009.4d3e58a6@mopti
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230320140954.31154-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -973,7 +973,10 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x17aa, 0x3905, "Lenovo G50-30", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x390b, "Lenovo G50-80", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
-	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_PINCFG_LENOVO_NOTEBOOK),
+	/* NOTE: we'd need to extend the quirk for 17aa:3977 as the same
+	 * PCI SSID is used on multiple Lenovo models
+	 */
+	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo G50-70", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", CXT_FIXUP_THINKPAD_ACPI),
@@ -996,6 +999,7 @@ static const struct hda_model_fixup cxt5
 	{ .id = CXT_FIXUP_MUTE_LED_GPIO, .name = "mute-led-gpio" },
 	{ .id = CXT_FIXUP_HP_ZBOOK_MUTE_LED, .name = "hp-zbook-mute-led" },
 	{ .id = CXT_FIXUP_HP_MIC_NO_PRESENCE, .name = "hp-mic-fix" },
+	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
 	{}
 };
 


