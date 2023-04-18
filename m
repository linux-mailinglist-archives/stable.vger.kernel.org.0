Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2F66E639F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjDRMmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjDRMmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:42:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61346146D3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E76826331B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B286C4339C;
        Tue, 18 Apr 2023 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821714;
        bh=bDeK0m9SNktXyIdbP6hPB19l6qsk7ey/Kphqh7REGSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxYmNA+SeauZxO6MLSxbS8ALzibOGmPP8RJiCxZ73iMAy7UD1UabfnzQFNA8amb8E
         onjXRbdZpcz2xGfxqJ7mYY/JfeVI//WTehF8l8Bbj2NBeU/3Ef0I4WcMBWwkEXwCX1
         Wi4fhzK4S36JLSkW7MQyURg3f2N/2eBx7bsWDE9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Erik Brakkee <erik@brakkee.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 006/134] ALSA: hda: patch_realtek: add quirk for Asus N7601ZM
Date:   Tue, 18 Apr 2023 14:21:02 +0200
Message-Id: <20230418120313.236055585@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit e959f2beec8e655dba79c5a7111beedae5e757e0 upstream.

Add pins and verbs needed to enable speakers and jack.

The pins and verbs configurations were identified by snooping the
Windows driver commands, with a nice write-up here:
https://brakkee.org/site/2023/02/07/fixing-sound-on-the-asus-n7601zm/

Reported-by: Erik Brakkee <erik@brakkee.org>
Link: https://github.com/thesofproject/linux/issues/4176
Tested-by: Erik Brakkee <erik@brakkee.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230406152725.15191-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6960,6 +6960,8 @@ enum {
 	ALC269_FIXUP_DELL_M101Z,
 	ALC269_FIXUP_SKU_IGNORE,
 	ALC269_FIXUP_ASUS_G73JW,
+	ALC269_FIXUP_ASUS_N7601ZM_PINS,
+	ALC269_FIXUP_ASUS_N7601ZM,
 	ALC269_FIXUP_LENOVO_EAPD,
 	ALC275_FIXUP_SONY_HWEQ,
 	ALC275_FIXUP_SONY_DISABLE_AAMIX,
@@ -7256,6 +7258,29 @@ static const struct hda_fixup alc269_fix
 			{ }
 		}
 	},
+	[ALC269_FIXUP_ASUS_N7601ZM_PINS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x03A11050 },
+			{ 0x1a, 0x03A11C30 },
+			{ 0x21, 0x03211420 },
+			{ }
+		}
+	},
+	[ALC269_FIXUP_ASUS_N7601ZM] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{0x20, AC_VERB_SET_COEF_INDEX, 0x62},
+			{0x20, AC_VERB_SET_PROC_COEF, 0xa007},
+			{0x20, AC_VERB_SET_COEF_INDEX, 0x10},
+			{0x20, AC_VERB_SET_PROC_COEF, 0x8420},
+			{0x20, AC_VERB_SET_COEF_INDEX, 0x0f},
+			{0x20, AC_VERB_SET_PROC_COEF, 0x7774},
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_ASUS_N7601ZM_PINS,
+	},
 	[ALC269_FIXUP_LENOVO_EAPD] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -9465,6 +9490,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1271, "ASUS X430UN", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1290, "ASUS X441SA", ALC233_FIXUP_EAPD_COEF_AND_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x12a0, "ASUS X441UV", ALC233_FIXUP_EAPD_COEF_AND_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x12a3, "Asus N7691ZM", ALC269_FIXUP_ASUS_N7601ZM),
 	SND_PCI_QUIRK(0x1043, 0x12af, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x12e0, "ASUS X541SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x12f0, "ASUS X541UV", ALC256_FIXUP_ASUS_MIC),


