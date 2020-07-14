Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B6A21FB0B
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgGNS6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbgGNS6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3082C22B37;
        Tue, 14 Jul 2020 18:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753090;
        bh=pRAM5uxbYFcPLfSBwRsJ+pVFsdxPO7cUTTFpcYq2DkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+Ve+CJeSGklC0KCSpODANPF4hEKcVN3mXlZqsqWanP7pagYMmBw2CXXBLjaP+Efy
         9R6eayZTDz97rxNAdbkVvJ8xXzKCDiMmrd6m/vOhXBLhGDQnzoSMwbeCD3F3cJ6agj
         73gi255ogicOITnu4ZZGRHRx/ZWRU1f/ZuKWYQWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jian-hong@endlessm.com>,
        Daniel Drake <drake@endlessm.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 115/166] ALSA: hda/realtek: Enable headset mic of Acer C20-820 with ALC269VC
Date:   Tue, 14 Jul 2020 20:44:40 +0200
Message-Id: <20200714184121.342953983@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

commit 6e15d1261d522d1d222f8f89b23c6966905e9049 upstream.

The Acer Aspire C20-820 AIO's audio (1025:1065) with ALC269VC can't
detect the headset microphone until ALC269VC_FIXUP_ACER_HEADSET_MIC
quirk maps the NID 0x18 as the headset mic pin.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Daniel Drake <drake@endlessm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200706071826.39726-2-jian-hong@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6115,6 +6115,7 @@ enum {
 	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 	ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS,
+	ALC269VC_FIXUP_ACER_HEADSET_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7304,6 +7305,15 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MIC
 	},
+	[ALC269VC_FIXUP_ACER_HEADSET_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x18, 0x02a11030 }, /* use as headset mic */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7319,6 +7329,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x0775, "Acer Aspire E1-572", ALC271_FIXUP_HP_GATE_MIC_JACK_E1_572),
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1025, 0x1065, "Acer Aspire C20-820", ALC269VC_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x106d, "Acer Cloudbook 14", ALC283_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x1025, 0x1099, "Acer Aspire E5-523G", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x110e, "Acer Aspire ES1-432", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),


