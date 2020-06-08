Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B3A1F2D14
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgFHXO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729940AbgFHXO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0DA021531;
        Mon,  8 Jun 2020 23:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658096;
        bh=r40xR9yky9ysUsIA1cklADwENJSC421HPJ2x8zP4sZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2u3KzXVbFztIM0uTiOdV0e7P6/Auu5jHPCkphKfX6B6URk5bb/oHyBeKhj9kOVmC
         qGK7HiseSm3KZT2sRIUnPMYHrjOoTffTIZ/sfOPGYzIX3au1mHZygSxTV2gOFXc/jy
         VpVfeP2F9zFjzRDFI/IZGYmzBb9QiRk74EU63iuI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Chiu <chiu@endlessm.com>, Daniel Drake <drake@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 138/606] ALSA: hda/realtek - Enable headset mic of ASUS GL503VM with ALC295
Date:   Mon,  8 Jun 2020 19:04:23 -0400
Message-Id: <20200608231211.3363633-138-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessm.com>

[ Upstream commit 9e43342b464f1de570a3ad8256ac77645749ef45 ]

The ASUS laptop GL503VM with ALC295 can't detect the headset microphone.
The headset microphone does not work until pin 0x19 is enabled for it.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Daniel Drake <drake@endlessm.com>
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Link: https://lore.kernel.org/r/20200512061525.133985-1-jian-hong@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b377aca71cbf..f92cd420e98d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6096,6 +6096,7 @@ enum {
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
 	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
+	ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7259,6 +7260,15 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		},
 	},
+	[ALC295_FIXUP_ASUS_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8040,6 +8050,14 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
 		{0x21, 0x03211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1043, "ASUS", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
+		{0x12, 0x90a60130},
+		{0x17, 0x90170110},
+		{0x21, 0x03211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1043, "ASUS", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
+		{0x12, 0x90a60130},
+		{0x17, 0x90170110},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x14, 0x90170110},
 		{0x21, 0x04211020}),
-- 
2.25.1

