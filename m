Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A062C0866
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732217AbgKWMuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733079AbgKWMty (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B45BB20657;
        Mon, 23 Nov 2020 12:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135792;
        bh=TkC4VZ6p+Qe8+X6yMXyAksyWxu5fpvbanGhwFJTWv3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQlN3wwdQwTvnE5JaQvI/7YrJJTJ1adhZ17RhyZrR84q1tg091XQOFpc/+sXwFeXS
         wUfnjgwYSFqOM6ZiNgL+HNj2CsHlxGhRbwZ78RlkK8tCoPX5KKZAlQwrDmDSKisbbP
         MNyt9+RwdizldW25R3K3xfEpUhXRnBwXxy6kM11U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 197/252] ALSA: hda/realtek - HP Headset Mic cant detect after boot
Date:   Mon, 23 Nov 2020 13:22:27 +0100
Message-Id: <20201123121845.105217535@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 9e885770277d2ed8d85f9cbd4992515ec324242f upstream.

System boot or warm boot with plugged headset.
If it turn on power save mode, Headset Mic will lose.
This patch will solve this issue.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1ae4d98e92c147b780ace3911c4e1d73@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6319,6 +6319,7 @@ enum {
 	ALC256_FIXUP_ASUS_HPE,
 	ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 	ALC287_FIXUP_HP_GPIO_LED,
+	ALC256_FIXUP_HP_HEADSET_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7733,6 +7734,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc287_fixup_hp_gpio_led,
 	},
+	[ALC256_FIXUP_HP_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc274_fixup_hp_headset_mic,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8348,6 +8353,10 @@ static const struct snd_hda_pin_quirk al
 		{0x19, 0x02a11020},
 		{0x1a, 0x02a11030},
 		{0x21, 0x0221101f}),
+	SND_HDA_PIN_QUIRK(0x10ec0236, 0x103c, "HP", ALC256_FIXUP_HP_HEADSET_MIC,
+		{0x14, 0x90170110},
+		{0x19, 0x02a11020},
+		{0x21, 0x02211030}),
 	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1028, "Dell", ALC255_FIXUP_DELL2_MIC_NO_PRESENCE,
 		{0x14, 0x90170110},
 		{0x21, 0x02211020}),
@@ -8450,6 +8459,10 @@ static const struct snd_hda_pin_quirk al
 		{0x1a, 0x90a70130},
 		{0x1b, 0x90170110},
 		{0x21, 0x03211020}),
+       SND_HDA_PIN_QUIRK(0x10ec0256, 0x103c, "HP", ALC256_FIXUP_HP_HEADSET_MIC,
+		{0x14, 0x90170110},
+		{0x19, 0x02a11020},
+		{0x21, 0x0221101f}),
        SND_HDA_PIN_QUIRK(0x10ec0274, 0x103c, "HP", ALC274_FIXUP_HP_HEADSET_MIC,
 		{0x17, 0x90170110},
 		{0x19, 0x03a11030},


