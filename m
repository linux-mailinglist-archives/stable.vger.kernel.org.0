Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDEA66CBE1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbjAPRTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbjAPRTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA37D23102
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:58:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6883661055
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE61C433EF;
        Mon, 16 Jan 2023 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888300;
        bh=nZlw1avROC0obsZlrsqqk24gqY/j05lHL6j0QRbY1Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7vXtIJOvZG5Nt7x5D7fZSukyTKrA+SD8rqerDtRE/pCe+8MktZwzCL3XVUnV01PO
         3Uj7Szy49al7HJEszrMRQRSNz13yZJntt4mkMvJAxXx+3rBio1Fa+O/a8dI6tYc3T1
         24pkiuzdWU1zkmDKz8THkCIcBF2Kx1Bph279LCuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 476/521] ALSA: hda/realtek - Add Headset Mic supported for HP cPC
Date:   Mon, 16 Jan 2023 16:52:18 +0100
Message-Id: <20230116154908.475302346@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 5af29028fd6db9438b5584ab7179710a0a22569d ]

HP ALC671 need to support Headset Mic.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/06a9d2b176e14706976d6584cbe2d92a@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 4bf5bf54476d ("ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 44 +++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3abe30eec49a..375493d3807f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8549,6 +8549,29 @@ static void alc662_fixup_aspire_ethos_hp(struct hda_codec *codec,
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
@@ -8623,6 +8646,7 @@ enum {
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
+	ALC671_FIXUP_HP_HEADSET_MIC2,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -8976,6 +9000,10 @@ static const struct hda_fixup alc662_fixups[] = {
 		.chained = true,
 		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER
 	},
+	[ALC671_FIXUP_HP_HEADSET_MIC2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc671_fixup_hp_headset_mic2,
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -9157,6 +9185,22 @@ static const struct snd_hda_pin_quirk alc662_pin_fixup_tbl[] = {
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
 
-- 
2.35.1



