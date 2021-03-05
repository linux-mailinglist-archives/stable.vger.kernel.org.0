Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329EF32E96F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhCEMcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231496AbhCEMc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:32:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0902665004;
        Fri,  5 Mar 2021 12:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947545;
        bh=FOv0BkdzHo7D7naV05D1f11aF3sOdywnbWq1ZbmM3GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLp/eFVrRhUVi0CLhq3+eMpWAMw8ZIEfsdO9U8TSHCxfepfkH+rzE/zDv9iOcd9Y5
         /C6PBPA3c431lHfXb9G3Fam4Q20NI/UnCoz369HrtZbcdlrGftcKpdZKsZQGcqD2Nk
         vkJwsoISl8EPQGzKfzAiAavRz1brHjnsjNXb+X+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eckhart Mohr <e.mohr@tuxedocomputers.com>,
        Werner Sembach <wse@tuxedocomputers.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 101/102] ALSA: hda/realtek: Add quirk for Intel NUC 10
Date:   Fri,  5 Mar 2021 13:22:00 +0100
Message-Id: <20210305120908.249587892@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

commit 73e7161eab5dee98114987239ec9c87fe8034ddb upstream.

This adds a new SND_PCI_QUIRK(...) and applies it to the Intel NUC 10
devices. This fixes the issue of the devices not having audio input and
output on the headset jack because the kernel does not recognize when
something is plugged in.

The new quirk was inspired by the quirk for the Intel NUC 8 devices, but
it turned out that the NUC 10 uses another pin. This information was
acquired by black box testing likely pins.

Co-developed-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210302180414.23194-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6396,6 +6396,7 @@ enum {
 	ALC269_FIXUP_LEMOTE_A1802,
 	ALC269_FIXUP_LEMOTE_A190X,
 	ALC256_FIXUP_INTEL_NUC8_RUGGED,
+	ALC256_FIXUP_INTEL_NUC10,
 	ALC255_FIXUP_XIAOMI_HEADSET_MIC,
 	ALC274_FIXUP_HP_MIC,
 	ALC274_FIXUP_HP_HEADSET_MIC,
@@ -7782,6 +7783,15 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE
 	},
+	[ALC256_FIXUP_INTEL_NUC10] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE
+	},
 	[ALC255_FIXUP_XIAOMI_HEADSET_MIC] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -8223,6 +8233,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
+	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


