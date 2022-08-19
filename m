Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BCD59A1B4
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349461AbiHSPsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349840AbiHSPrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:47:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABA674BB8;
        Fri, 19 Aug 2022 08:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B063616B5;
        Fri, 19 Aug 2022 15:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89686C433D6;
        Fri, 19 Aug 2022 15:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924015;
        bh=aRkqRWu1+a1Ngw+9SHEA4o4vtzGGVQTKJuGivNuYFlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhauswlCS7NU7L1mEora8wln7XZk7KDDwljX307vE5XQTb9f00zXYyN5/GfopnY+C
         DCsGlApSVVj0UZ/ECGgC/rgPMOyZ6ePdYVLFB48HAwAvMR1sP6PJrRXUUqoMfs4QYy
         g2eiScEmC26XS2bJrORMFi5C8vFQ/0zSg3HATA+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 027/545] ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model
Date:   Fri, 19 Aug 2022 17:36:37 +0200
Message-Id: <20220819153830.419447114@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Tang <tangmeng@uniontech.com>

commit f83bb2592482fe94c6eea07a8121763c80f36ce5 upstream.

There is another LENOVO 20149 (Type1Sku0) Notebook model with
CX20590, the device PCI SSID is 17aa:3977, which headphones are
not responding, that requires the quirk CXT_PINCFG_LENOVO_NOTEBOOK.
Add the corresponding entry to the quirk table.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220808073406.19460-1-tangmeng@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -215,6 +215,7 @@ enum {
 	CXT_PINCFG_LEMOTE_A1205,
 	CXT_PINCFG_COMPAQ_CQ60,
 	CXT_FIXUP_STEREO_DMIC,
+	CXT_PINCFG_LENOVO_NOTEBOOK,
 	CXT_FIXUP_INC_MIC_BOOST,
 	CXT_FIXUP_HEADPHONE_MIC_PIN,
 	CXT_FIXUP_HEADPHONE_MIC,
@@ -765,6 +766,14 @@ static const struct hda_fixup cxt_fixups
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_stereo_dmic,
 	},
+	[CXT_PINCFG_LENOVO_NOTEBOOK] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1a, 0x05d71030 },
+			{ }
+		},
+		.chain_id = CXT_FIXUP_STEREO_DMIC,
+	},
 	[CXT_FIXUP_INC_MIC_BOOST] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt5066_increase_mic_boost,
@@ -964,7 +973,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x17aa, 0x3905, "Lenovo G50-30", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x390b, "Lenovo G50-80", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
-	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
+	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_PINCFG_LENOVO_NOTEBOOK),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo G50-70", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", CXT_FIXUP_THINKPAD_ACPI),


