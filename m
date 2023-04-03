Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E6E6D472A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjDCORp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbjDCORo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:17:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CE62BEF5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BE7461CBD
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BE9C4339B;
        Mon,  3 Apr 2023 14:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531462;
        bh=KtJ0VQeQNAYoKsagb/LIaOW4p3iN/MIgF6EHF9gQb5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUDiSsZEiUZw4Xb8x08I051JjKG/PdWWnYjDiVZNpDp7qcgBGbG9iEEYPLNwj4r00
         ZO5M6NYqfhupgHOYJsZQAHCmR/G4fzacJGXbHP1Cp9+LJ5Qd/Gai2loV0zkJQjy7rz
         aK15Lga9Bps0cEGr5xc+mp+DZavln1zavK6vRTZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jetro Jormalainen <jje-lxkl@jetro.fi>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 73/84] ALSA: hda/conexant: Partial revert of a quirk for Lenovo
Date:   Mon,  3 Apr 2023 16:09:14 +0200
Message-Id: <20230403140355.941521139@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
@@ -952,7 +952,10 @@ static const struct snd_pci_quirk cxt506
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
@@ -974,6 +977,7 @@ static const struct hda_model_fixup cxt5
 	{ .id = CXT_FIXUP_HP_DOCK, .name = "hp-dock" },
 	{ .id = CXT_FIXUP_MUTE_LED_GPIO, .name = "mute-led-gpio" },
 	{ .id = CXT_FIXUP_HP_MIC_NO_PRESENCE, .name = "hp-mic-fix" },
+	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
 	{}
 };
 


