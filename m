Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DF61881C6
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgCQLBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbgCQLBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:01:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B9420719;
        Tue, 17 Mar 2020 11:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442905;
        bh=gmTjiyzq7oG89aivUwhhWxL805v+c68/WPu0CmxB7ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ysLg1wdpTs5dKOPVrcQe+OYLC5MlfkwxrB6fvQOCq3uNM4rAvINdYswY+1i9JW7ME
         NkNVK+I4OvYSocW46CYzd3Zq9za8wJ5Q1NCKHqIAjPrAHpROK7PfYFYExHXPfysEd1
         J37J+29eDgrcydgMf+4KdAlbOMQ5pJRAcgZg6sbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 003/123] ALSA: hda/realtek - Add Headset Mic supported for HP cPC
Date:   Tue, 17 Mar 2020 11:53:50 +0100
Message-Id: <20200317103307.771412586@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 5af29028fd6db9438b5584ab7179710a0a22569d upstream.

HP ALC671 need to support Headset Mic.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/06a9d2b176e14706976d6584cbe2d92a@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   44 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8542,6 +8542,29 @@ static void alc662_fixup_aspire_ethos_hp
 	}
 }
 
+static void alc671_fixup_hp_headset_mic2(struct hda_codec *codec,
+					     const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x19, 0x02a11040 }, /* use as headset mic, with its own jack detect */
+		{ 0x1b, 0x0181304f },
+		{ }
+	};
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->gen.mixer_nid = 0;
+		spec->parse_flags |= HDA_PINCFG_HEADSET_MIC;
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		alc_write_coef_idx(codec, 0x19, 0xa054);
+		break;
+	}
+}
+
 static const struct coef_fw alc668_coefs[] = {
 	WRITE_COEF(0x01, 0xbebe), WRITE_COEF(0x02, 0xaaaa), WRITE_COEF(0x03,    0x0),
 	WRITE_COEF(0x04, 0x0180), WRITE_COEF(0x06,    0x0), WRITE_COEF(0x07, 0x0f80),
@@ -8615,6 +8638,7 @@ enum {
 	ALC662_FIXUP_LENOVO_MULTI_CODECS,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
+	ALC671_FIXUP_HP_HEADSET_MIC2,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -8956,6 +8980,10 @@ static const struct hda_fixup alc662_fix
 		.chained = true,
 		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET
 	},
+	[ALC671_FIXUP_HP_HEADSET_MIC2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc671_fixup_hp_headset_mic2,
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -9138,6 +9166,22 @@ static const struct snd_hda_pin_quirk al
 		{0x12, 0x90a60130},
 		{0x14, 0x90170110},
 		{0x15, 0x0321101f}),
+	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,
+		{0x14, 0x01014010},
+		{0x17, 0x90170150},
+		{0x1b, 0x01813030},
+		{0x21, 0x02211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,
+		{0x14, 0x01014010},
+		{0x18, 0x01a19040},
+		{0x1b, 0x01813030},
+		{0x21, 0x02211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,
+		{0x14, 0x01014020},
+		{0x17, 0x90170110},
+		{0x18, 0x01a19050},
+		{0x1b, 0x01813040},
+		{0x21, 0x02211030}),
 	{}
 };
 


