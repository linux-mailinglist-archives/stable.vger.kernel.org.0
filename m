Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4D62ED1E3
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbhAGOTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729126AbhAGOR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50F6523356;
        Thu,  7 Jan 2021 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029023;
        bh=PZq/q3a2lL8AjVHhweQmI0qXZ3AxLRxMRtsWFfqdqeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHyL9j8ikIDXmjMef4MQSfrc7x3Ux9KMmvk6aEpa/bYHuFP7XwcrkNl1Pw27r9Xl0
         JAeWVvIjx8WdYpk9MshyUbjfcxeI+CRzJrVAGGATwR6op1ex6Qg96BTvQhRGfe3vov
         HzMPkv92wTVesYpbyMxJnkMSD0tg7TxSeAs0cOI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 05/32] ALSA: hda/realtek - Support Dell headset mode for ALC3271
Date:   Thu,  7 Jan 2021 15:16:25 +0100
Message-Id: <20210107140828.124378191@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.866214702@linuxfoundation.org>
References: <20210107140827.866214702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit fcc6c877a01f83cbce1cca885ea62df6a10d33c3 upstream

Add DELL4_MIC_NO_PRESENCE model.
Add the pin configuration value of this machine into the pin_quirk
table to make DELL4_MIC_NO_PRESENCE apply to this machine.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4896,6 +4896,7 @@ enum {
 	ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC269_FIXUP_DELL2_MIC_NO_PRESENCE,
 	ALC269_FIXUP_DELL3_MIC_NO_PRESENCE,
+	ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 	ALC269_FIXUP_HEADSET_MODE,
 	ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC,
 	ALC269_FIXUP_ASPIRE_HEADSET_MIC,
@@ -5199,6 +5200,16 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC269_FIXUP_DELL4_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ 0x1b, 0x01a1913d }, /* use as headphone mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE
+	},
 	[ALC269_FIXUP_HEADSET_MODE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_headset_mode,
@@ -6267,6 +6278,11 @@ static const struct snd_hda_pin_quirk al
 		{0x17, 0x90170110},
 		{0x1a, 0x03011020},
 		{0x21, 0x03211030}),
+	SND_HDA_PIN_QUIRK(0x10ec0299, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+		ALC225_STANDARD_PINS,
+		{0x12, 0xb7a60130},
+		{0x13, 0xb8a60140},
+		{0x17, 0x90170110}),
 	{}
 };
 


