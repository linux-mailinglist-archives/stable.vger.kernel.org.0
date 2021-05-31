Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675BB395FB9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhEaOP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233188AbhEaOMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5583F6198A;
        Mon, 31 May 2021 13:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468489;
        bh=Cr+EXjhufftiKNjthemRhKU/W3IgGWNsadDZ7TTRajc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPl7q0RC9hRg4bOJUMYFmoiD/H3QBGghZnoLk8hkiMPgur9RbXqcfE4tjTVduodZM
         /lnPAm7aiYnw8PAXtoDupmwtwziC+NO+rHy5ybTAXlPp6dAnq9/OQ3UaSVZlCI7oyK
         egmpTPUwbhtBBUStmTALpEjuX23EhnHWIpR26ZSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 001/177] ALSA: hda/realtek: Headphone volume is controlled by Front mixer
Date:   Mon, 31 May 2021 15:12:38 +0200
Message-Id: <20210531130647.939696226@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 119b75c150773425a89033215eab4d15d4198f8b upstream.

On some ASUS and MSI machines, the audio codec is alc1220 and the
Headphone is connected to audio mixer 0xf and DAC 0x5, in theory
the Headphone volume is controlled by DAC 0x5 (Heapdhone Playback
Volume), but somehow it is controlled by DAC 0x2 (Front Playback
Volume), maybe this is a defect on the codec alc1220.

Because of this issue, the PA couldn't switch the headphone and
Lineout correctly, If we apply the quirk CLEVO_P950 to those machines,
the Lineout and Headphone will share the audio mixer 0xc and DAC 0x2,
and generate Headphone+LO mixer, then PA could handle them when
switching between them.

BugLink: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/1206
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20210522034741.13415-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2593,6 +2593,28 @@ static const struct hda_model_fixup alc8
 	{}
 };
 
+static const struct snd_hda_pin_quirk alc882_pin_fixup_tbl[] = {
+	SND_HDA_PIN_QUIRK(0x10ec1220, 0x1043, "ASUS", ALC1220_FIXUP_CLEVO_P950,
+		{0x14, 0x01014010},
+		{0x15, 0x01011012},
+		{0x16, 0x01016011},
+		{0x18, 0x01a19040},
+		{0x19, 0x02a19050},
+		{0x1a, 0x0181304f},
+		{0x1b, 0x0221401f},
+		{0x1e, 0x01456130}),
+	SND_HDA_PIN_QUIRK(0x10ec1220, 0x1462, "MS-7C35", ALC1220_FIXUP_CLEVO_P950,
+		{0x14, 0x01015010},
+		{0x15, 0x01011012},
+		{0x16, 0x01011011},
+		{0x18, 0x01a11040},
+		{0x19, 0x02a19050},
+		{0x1a, 0x0181104f},
+		{0x1b, 0x0221401f},
+		{0x1e, 0x01451130}),
+	{}
+};
+
 /*
  * BIOS auto configuration
  */
@@ -2634,6 +2656,7 @@ static int patch_alc882(struct hda_codec
 
 	snd_hda_pick_fixup(codec, alc882_fixup_models, alc882_fixup_tbl,
 		       alc882_fixups);
+	snd_hda_pick_pin_fixup(codec, alc882_pin_fixup_tbl, alc882_fixups, true);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
 
 	alc_auto_parse_customize_define(codec);


