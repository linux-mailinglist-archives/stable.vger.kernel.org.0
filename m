Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A923F303377
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbhAZEyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:54:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730815AbhAYSsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31DDE206FA;
        Mon, 25 Jan 2021 18:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600473;
        bh=wSr1RMry3InHkIhdUBQgjnCBPPXoDJZC94sGjZrYwyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ca+YzlUxEP5nYa9oXe6fduDg1tpJrM41z+KlCViEeBiCteMAEQ/ZSbfmcNXC7KzgT
         89ixEyZO49tTXVppfKazO2HoBmjbuW1QWXQB7V6nJgdBkYJR9/WKgoc/C8Ps5C1mdC
         V/IS9H2gqUY+XoSXmSGpi/FH5MdLjPnxy9NtCOYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessos.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 009/199] ALSA: hda/realtek - Limit int mic boost on Acer Aspire E5-575T
Date:   Mon, 25 Jan 2021 19:37:11 +0100
Message-Id: <20210125183216.652171066@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessos.org>

commit 495dc7637cb5ca8e39c46db818328410bb6e73a1 upstream.

The Acer Apire E5-575T laptop with codec ALC255 has a terrible
background noise comes from internal mic capture. And the jack
sensing dose not work for headset like some other Acer laptops.

This patch limits the internal mic boost on top of the existing
ALC255_FIXUP_ACER_MIC_NO_PRESENCE quirk for Acer Aspire E5-575T.

Signed-off-by: Chris Chiu <chiu@endlessos.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210114082728.74729-1-chiu@endlessos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6371,6 +6371,7 @@ enum {
 	ALC256_FIXUP_HP_HEADSET_MIC,
 	ALC236_FIXUP_DELL_AIO_HEADSET_MIC,
 	ALC282_FIXUP_ACER_DISABLE_LINEOUT,
+	ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7808,6 +7809,12 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE
 	},
+	[ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7826,6 +7833,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1065, "Acer Aspire C20-820", ALC269VC_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x106d, "Acer Cloudbook 14", ALC283_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0x1025, 0x1094, "Acer Aspire E5-575T", ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1025, 0x1099, "Acer Aspire E5-523G", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x110e, "Acer Aspire ES1-432", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1166, "Acer Veriton N4640G", ALC269_FIXUP_LIFEBOOK),


