Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33C4549418
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345043AbiFMKuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347638AbiFMKtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:49:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DC52D1E0;
        Mon, 13 Jun 2022 03:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88D060F09;
        Mon, 13 Jun 2022 10:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C92C34114;
        Mon, 13 Jun 2022 10:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115990;
        bh=bvD7gg0RMkdgrITxYxdYRb0cjIy3W2dxLRH2AWu6i1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpd/O7v5D6OMCs/Tumun0dBaxJ0Hm6IPQiJVoNY+LP60kCE9r30DL8uuIUu3BuGuA
         w6+C2Cso8a+PTOcPdsk3hG14mEnp2mzel+DZTQ1/4nfzUbxrknnFSQ6zY25O5EeBzu
         KyBbvyygqjmCwjRGkm8TO7Pq4SAMP2M0F/ro3mRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marios Levogiannis <marios.levogiannis@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 002/411] ALSA: hda/realtek - Fix microphone noise on ASUS TUF B550M-PLUS
Date:   Mon, 13 Jun 2022 12:04:35 +0200
Message-Id: <20220613094928.563032897@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Levogiannis <marios.levogiannis@gmail.com>

commit 9bfa7b36343c7d84370bc61c9ed774635b05e4eb upstream.

Set microphone pins 0x18 (rear) and 0x19 (front) to VREF_50 to fix the
microphone noise on ASUS TUF B550M-PLUS which uses the ALCS1200A codec.
The initial value was VREF_80.

The same issue is also present on Windows using both the default Windows
driver and all tested Realtek drivers before version 6.0.9049.1. Comparing
Realtek driver 6.0.9049.1 (the first one without the microphone noise) to
Realtek driver 6.0.9047.1 (the last one with the microphone noise)
revealed that the fix is the result of setting pins 0x18 and 0x19 to
VREF_50.

This fix may also work for other boards that have been reported to have
the same microphone issue and use the ALC1150 and ALCS1200A codecs, since
these codecs are similar and the fix in the Realtek driver on Windows is
common for both. However, it is currently enabled only for ASUS TUF
B550M-PLUS as this is the only board that could be tested.

Signed-off-by: Marios Levogiannis <marios.levogiannis@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220530074131.12258-1-marios.levogiannis@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1932,6 +1932,7 @@ enum {
 	ALC1220_FIXUP_CLEVO_PB51ED_PINS,
 	ALC887_FIXUP_ASUS_AUDIO,
 	ALC887_FIXUP_ASUS_HMIC,
+	ALCS1200A_FIXUP_MIC_VREF,
 };
 
 static void alc889_fixup_coef(struct hda_codec *codec,
@@ -2477,6 +2478,14 @@ static const struct hda_fixup alc882_fix
 		.chained = true,
 		.chain_id = ALC887_FIXUP_ASUS_AUDIO,
 	},
+	[ALCS1200A_FIXUP_MIC_VREF] = {
+		.type = HDA_FIXUP_PINCTLS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x18, PIN_VREF50 }, /* rear mic */
+			{ 0x19, PIN_VREF50 }, /* front mic */
+			{}
+		}
+	},
 };
 
 static const struct snd_pci_quirk alc882_fixup_tbl[] = {
@@ -2514,6 +2523,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1043, 0x835f, "Asus Eee 1601", ALC888_FIXUP_EEE1601),
 	SND_PCI_QUIRK(0x1043, 0x84bc, "ASUS ET2700", ALC887_FIXUP_ASUS_BASS),
 	SND_PCI_QUIRK(0x1043, 0x8691, "ASUS ROG Ranger VIII", ALC882_FIXUP_GPIO3),
+	SND_PCI_QUIRK(0x1043, 0x8797, "ASUS TUF B550M-PLUS", ALCS1200A_FIXUP_MIC_VREF),
 	SND_PCI_QUIRK(0x104d, 0x9043, "Sony Vaio VGC-LN51JGB", ALC882_FIXUP_NO_PRIMARY_HP),
 	SND_PCI_QUIRK(0x104d, 0x9044, "Sony VAIO AiO", ALC882_FIXUP_NO_PRIMARY_HP),
 	SND_PCI_QUIRK(0x104d, 0x9047, "Sony Vaio TT", ALC889_FIXUP_VAIO_TT),


