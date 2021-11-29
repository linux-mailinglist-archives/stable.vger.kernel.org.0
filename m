Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BB746265C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbhK2WvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235495AbhK2WuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:50:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450A3C12BCF8;
        Mon, 29 Nov 2021 10:35:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD658CE13D0;
        Mon, 29 Nov 2021 18:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C79BC53FC7;
        Mon, 29 Nov 2021 18:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210919;
        bh=oERZ+XhVdy9MIofDfDCc5IbBXzVV6xOMy6toBBmDYs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4aRICvNU/nqB1DF5Dbas7mRzjLd8zu3s3ulNp4ctbw2Cp5GUChe3UU6PdWeJ2OsU
         AfDSdoFvd+YNufN3EA9+C9kpy0W7RvSiN0vB4/BOlLz0VoZdOjXTYZ5GHTqjDvJqk4
         ozZ1zgDaVuRVqvAiBFa/i2s+4CYyQl6opzlt+qoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 023/179] ALSA: hda/realtek: Add quirk for ASRock NUC Box 1100
Date:   Mon, 29 Nov 2021 19:16:57 +0100
Message-Id: <20211129181719.709205346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

commit 174a7fb3859ae75b0f0e35ef852459d8882b55b5 upstream.

This applies a SND_PCI_QUIRK(...) to the ASRock NUC Box 1100 series. This
fixes the issue of the headphone jack not being detected unless warm
rebooted from a certain other OS.

When booting a certain other OS some coeff settings are changed that enable
the audio jack. These settings are preserved on a warm reboot and can be
easily dumped.

The relevant indexes and values where gathered by naively diff-ing and
reading a working and a non-working coeff dump.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211112110704.1022501-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6521,6 +6521,27 @@ static void alc256_fixup_tongfang_reset_
 	alc_write_coef_idx(codec, 0x45, 0x5089);
 }
 
+static const struct coef_fw alc233_fixup_no_audio_jack_coefs[] = {
+	WRITE_COEF(0x1a, 0x9003), WRITE_COEF(0x1b, 0x0e2b), WRITE_COEF(0x37, 0xfe06),
+	WRITE_COEF(0x38, 0x4981), WRITE_COEF(0x45, 0xd489), WRITE_COEF(0x46, 0x0074),
+	WRITE_COEF(0x49, 0x0149),
+	{}
+};
+
+static void alc233_fixup_no_audio_jack(struct hda_codec *codec,
+				       const struct hda_fixup *fix,
+				       int action)
+{
+	/*
+	 * The audio jack input and output is not detected on the ASRock NUC Box
+	 * 1100 series when cold booting without this fix. Warm rebooting from a
+	 * certain other OS makes the audio functional, as COEF settings are
+	 * preserved in this case. This fix sets these altered COEF values as
+	 * the default.
+	 */
+	alc_process_coef_fw(codec, alc233_fixup_no_audio_jack_coefs);
+}
+
 enum {
 	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
@@ -6740,6 +6761,7 @@ enum {
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_TONGFANG_RESET_PERSISTENT_SETTINGS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
+	ALC233_FIXUP_NO_AUDIO_JACK,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8460,6 +8482,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC,
 	},
+	[ALC233_FIXUP_NO_AUDIO_JACK] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc233_fixup_no_audio_jack,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8894,6 +8920,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x511e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
+	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
 	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),


