Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 104C2F67B
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbfD3LsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730816AbfD3LsP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C189A20449;
        Tue, 30 Apr 2019 11:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624894;
        bh=dGp3iSHZeqM687ALn5iXYf8NFjT0EZ4EVAVx1Hi4FEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j00dn6x3dZ+6F1Fd0swOHZ8+kvnv+OnMdMMKw90p8qFiFIG2JaPJGYAp1NSAYGNve
         0l3FVGAXilSGpR8h5IAtMzv45GlSKEtsWqzA0DQCX++9e0xrKHAEjD/wW5OXRldC64
         Zf3zWnukFjdt4V7x4lGDlzlflUdcDsFxyAlJKUOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 05/89] ALSA: hda/realtek - Move to ACT_INIT state
Date:   Tue, 30 Apr 2019 13:37:56 +0200
Message-Id: <20190430113610.057774520@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8983eb602af511fc5822f5ff4a82074c68816fd9 ]

It will be lose Mic JD state when Chrome OS boot and headset was plugged.
Just Implement of reset combo jack JD verb for ACT_PRE_PROBE state.
Intel test result was also failed.
It test passed until changed the initial state to ACT_INIT.
Mic JD will show every time.
This patch also changed the model name as 'alc-chrome-book' for
application of Chrome OS.

Fixes: 10f5b1b85ed1 ("ALSA: hda/realtek - Fixed Headset Mic JD not stable")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 41 +++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f061167062bc..a9f69c3a3e0b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5490,7 +5490,7 @@ static void alc_headset_btn_callback(struct hda_codec *codec,
 	jack->jack->button_state = report;
 }
 
-static void alc295_fixup_chromebook(struct hda_codec *codec,
+static void alc_fixup_headset_jack(struct hda_codec *codec,
 				    const struct hda_fixup *fix, int action)
 {
 
@@ -5500,16 +5500,6 @@ static void alc295_fixup_chromebook(struct hda_codec *codec,
 						    alc_headset_btn_callback);
 		snd_hda_jack_add_kctl(codec, 0x55, "Headset Jack", false,
 				      SND_JACK_HEADSET, alc_headset_btn_keymap);
-		switch (codec->core.vendor_id) {
-		case 0x10ec0295:
-			alc_update_coef_idx(codec, 0x4a, 0x8000, 1 << 15); /* Reset HP JD */
-			alc_update_coef_idx(codec, 0x4a, 0x8000, 0 << 15);
-			break;
-		case 0x10ec0236:
-			alc_update_coef_idx(codec, 0x1b, 0x8000, 1 << 15); /* Reset HP JD */
-			alc_update_coef_idx(codec, 0x1b, 0x8000, 0 << 15);
-			break;
-		}
 		break;
 	case HDA_FIXUP_ACT_INIT:
 		switch (codec->core.vendor_id) {
@@ -5530,6 +5520,25 @@ static void alc295_fixup_chromebook(struct hda_codec *codec,
 	}
 }
 
+static void alc295_fixup_chromebook(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	switch (action) {
+	case HDA_FIXUP_ACT_INIT:
+		switch (codec->core.vendor_id) {
+		case 0x10ec0295:
+			alc_update_coef_idx(codec, 0x4a, 0x8000, 1 << 15); /* Reset HP JD */
+			alc_update_coef_idx(codec, 0x4a, 0x8000, 0 << 15);
+			break;
+		case 0x10ec0236:
+			alc_update_coef_idx(codec, 0x1b, 0x8000, 1 << 15); /* Reset HP JD */
+			alc_update_coef_idx(codec, 0x1b, 0x8000, 0 << 15);
+			break;
+		}
+		break;
+	}
+}
+
 static void alc_fixup_disable_mic_vref(struct hda_codec *codec,
 				  const struct hda_fixup *fix, int action)
 {
@@ -5684,6 +5693,7 @@ enum {
 	ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
 	ALC255_FIXUP_ACER_HEADSET_MIC,
 	ALC295_FIXUP_CHROME_BOOK,
+	ALC225_FIXUP_HEADSET_JACK,
 	ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE,
 	ALC225_FIXUP_WYSE_AUTO_MUTE,
 	ALC225_FIXUP_WYSE_DISABLE_MIC_VREF,
@@ -6645,6 +6655,12 @@ static const struct hda_fixup alc269_fixups[] = {
 	[ALC295_FIXUP_CHROME_BOOK] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_chromebook,
+		.chained = true,
+		.chain_id = ALC225_FIXUP_HEADSET_JACK
+	},
+	[ALC225_FIXUP_HEADSET_JACK] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_headset_jack,
 	},
 	[ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
@@ -7143,7 +7159,8 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC255_FIXUP_DUMMY_LINEOUT_VERB, .name = "alc255-dummy-lineout"},
 	{.id = ALC255_FIXUP_DELL_HEADSET_MIC, .name = "alc255-dell-headset"},
 	{.id = ALC295_FIXUP_HP_X360, .name = "alc295-hp-x360"},
-	{.id = ALC295_FIXUP_CHROME_BOOK, .name = "alc-sense-combo"},
+	{.id = ALC225_FIXUP_HEADSET_JACK, .name = "alc-headset-jack"},
+	{.id = ALC295_FIXUP_CHROME_BOOK, .name = "alc-chrome-book"},
 	{.id = ALC299_FIXUP_PREDATOR_SPK, .name = "predator-spk"},
 	{}
 };
-- 
2.19.1



