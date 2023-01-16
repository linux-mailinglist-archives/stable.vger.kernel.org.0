Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865A766CBE2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbjAPRTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbjAPRTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1998F2CC74
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C63BBB80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7F0C433EF;
        Mon, 16 Jan 2023 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888303;
        bh=pkc3/pYeap73gdwbwh8uw9wC+prxCa443T0/SP7EDIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHh4EEXbf8nYONFrz4jkr8vWKn4CRf+k4OR4COUmluFDGYaGqkucgmPcm6CNxHgg/
         YfsJrjoMAHorTp09BJhanc9kB4NTO0FSCMor9ng/pW/TQVCEFdFKTYqjixHD0KYwA3
         Z1A5al/BEAIi9B9XpRDo0ulC5DtkkgKpa+atZPpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jian-Hong Pan <jian-hong@endlessm.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 477/521] ALSA: hda/realtek - Enable headset mic of Acer X2660G with ALC662
Date:   Mon, 16 Jan 2023 16:52:19 +0100
Message-Id: <20230116154908.522954302@linuxfoundation.org>
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

From: Jian-Hong Pan <jian-hong@endlessm.com>

[ Upstream commit d858c706bdca97698752bd26b60c21ec07ef04f2 ]

The Acer desktop X2660G with ALC662 can't detect the headset microphone
until ALC662_FIXUP_ACER_X2660G_HEADSET_MODE quirk applied.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200317082806.73194-2-jian-hong@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 4bf5bf54476d ("ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 375493d3807f..024a7e473e11 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8647,6 +8647,7 @@ enum {
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
 	ALC671_FIXUP_HP_HEADSET_MIC2,
+	ALC662_FIXUP_ACER_X2660G_HEADSET_MODE,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -9004,6 +9005,15 @@ static const struct hda_fixup alc662_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc671_fixup_hp_headset_mic2,
 	},
+	[ALC662_FIXUP_ACER_X2660G_HEADSET_MODE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1a, 0x02a1113c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC662_FIXUP_USI_FUNC
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -9015,6 +9025,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x0349, "eMachines eM250", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
+	SND_PCI_QUIRK(0x1025, 0x124e, "Acer 2660G", ALC662_FIXUP_ACER_X2660G_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1028, 0x05d8, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x05db, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x05fe, "Dell XPS 15", ALC668_FIXUP_DELL_XPS13),
-- 
2.35.1



