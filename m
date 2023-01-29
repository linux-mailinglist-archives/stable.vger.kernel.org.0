Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD45680064
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 18:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjA2RVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 12:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjA2RVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 12:21:01 -0500
X-Greylist: delayed 398 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 Jan 2023 09:20:58 PST
Received: from ovh.texitoi.eu (ovh.texitoi.eu [51.254.137.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8D011EB6
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 09:20:58 -0800 (PST)
Received: from book360.numericable.fr (55.174.26.93.rev.sfr.net [93.26.174.55])
        by ovh.texitoi.eu (OpenSMTPD) with ESMTPSA id 199205cf (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 29 Jan 2023 18:14:16 +0100 (CET)
From:   Guillaume Pinot <texitoi@texitoi.eu>
To:     alsa-devel@alsa-project.org
Cc:     Guillaume Pinot <texitoi@texitoi.eu>, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro 360
Date:   Sun, 29 Jan 2023 18:13:38 +0100
Message-Id: <20230129171338.17249-1-texitoi@texitoi.eu>
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
https://lore.kernel.org/all/20221115170235.18875-1-tiwai@suse.de/

This is my first contribution, so feel free to give me feedbacks!

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

