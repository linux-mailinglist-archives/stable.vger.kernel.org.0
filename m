Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D83E68365A
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 20:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjAaTVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 14:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjAaTU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 14:20:56 -0500
Received: from ovh.texitoi.eu (ovh.texitoi.eu [51.254.137.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117B159B7E
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 11:20:50 -0800 (PST)
Received: from book360.numericable.fr (55.174.26.93.rev.sfr.net [93.26.174.55])
        by ovh.texitoi.eu (OpenSMTPD) with ESMTPSA id c10cb12c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 31 Jan 2023 20:20:47 +0100 (CET)
From:   Guillaume Pinot <texitoi@texitoi.eu>
To:     alsa-devel@alsa-project.org
Cc:     Guillaume Pinot <texitoi@texitoi.eu>, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro 360
Date:   Tue, 31 Jan 2023 20:18:11 +0100
Message-Id: <20230131191809.24012-1-texitoi@texitoi.eu>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Samsung Galaxy Book2 Pro 360 (13" 2022 NP930QED-KA1FR) with codec SSID
144d:ca03 requires the same workaround for enabling the speaker amp
like other Samsung models with ALC298 codec.

Cc: <stable@vger.kernel.org>
Signed-off-by: Guillaume Pinot <texitoi@texitoi.eu>
---
I've tested this fix on my laptop with success. I've took "inspiration" from
https://lore.kernel.org/all/20221115170235.18875-1-tiwai@suse.de

This is my first contribution, so feel free to give me feedbacks!

Also, I've tried to send this patch a few days ago, but I forgot to subscribe
before, so the old submission might be lost in the moderation stack. I hope it
doesn't pose any problem.

 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6fab7c8fc19a..c4496206c3e7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9521,6 +9521,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
-- 
2.30.2

