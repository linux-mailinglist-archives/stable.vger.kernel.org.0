Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A41B205C
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390139AbfIMNVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390714AbfIMNVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:03 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C59E206BB;
        Fri, 13 Sep 2019 13:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380862;
        bh=QMVlag0qqeZVF7AtUAiqBf+PBP+FgaKrteIQgjAKXPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXFtB5Wh892O42pPslZytxDP+fkS9lSkKnw2WqiE/O5GplTknT1AJx7QNkphSeSxq
         yYIz6bNkAfRgZXipT3/Ec6jqPI3dvI2kIbby8Rseqa/dVpl5H6U2FgqpUa7fvoyNI2
         72RfADro8oO+9aWXGB8F2azDF+CWlVJwLftXCLXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jian-hong@endlessm.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 06/37] ALSA: hda/realtek - Enable internal speaker & headset mic of ASUS UX431FL
Date:   Fri, 13 Sep 2019 14:07:11 +0100
Message-Id: <20190913130512.188810278@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

commit 60083f9e94b2f28047d71ed778adf89357c1a8fb upstream.

Original pin node values of ASUS UX431FL with ALC294:

0x12 0xb7a60140
0x13 0x40000000
0x14 0x90170110
0x15 0x411111f0
0x16 0x411111f0
0x17 0x90170111
0x18 0x411111f0
0x19 0x411111f0
0x1a 0x411111f0
0x1b 0x411111f0
0x1d 0x4066852d
0x1e 0x411111f0
0x1f 0x411111f0
0x21 0x04211020

1. Has duplicated internal speakers (0x14 & 0x17) which makes the output
   route become confused. So, the output volume cannot be changed by
   setting.
2. Misses the headset mic pin node.

This patch disables the confusing speaker (NID 0x14) and enables the
headset mic (NID 0x19).

Link: https://lore.kernel.org/r/20190902100054.6941-1-jian-hong@endlessm.com
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5799,6 +5799,7 @@ enum {
 	ALC286_FIXUP_ACER_AIO_HEADSET_MIC,
 	ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC299_FIXUP_PREDATOR_SPK,
+	ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -6839,6 +6840,16 @@ static const struct hda_fixup alc269_fix
 			{ }
 		}
 	},
+	[ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x411111f0 }, /* disable confusing internal speaker */
+			{ 0x19, 0x04a11150 }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -6998,6 +7009,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
+	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a30, "ASUS X705UD", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1b13, "Asus U41SV", ALC269_FIXUP_INV_DMIC),


