Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA538592446
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241827AbiHNQaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242353AbiHNQ3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:29:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE1F1EEC6;
        Sun, 14 Aug 2022 09:24:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1FA85CE0B5E;
        Sun, 14 Aug 2022 16:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5984C433D6;
        Sun, 14 Aug 2022 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494262;
        bh=50LxYaW0s6g5aawYlGxNMapMzOAnUzrDRFZi2x4260w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXiHmAQs8urpssHs3nrztG5eWZyd1sNsiqFz8u3HWdiso3Qgowwra89UCEVOZSP+M
         m97JzU3OBUf4owUlFrwT55DbCGmDWgO0UbfQ7I0xReFzOAROANQFZyfchqX+mahmLy
         jY+8JvYBHg2is52C2z26KESSFwZ1iNkd3abbBxrNggRiT5pObFiFuboqWNwhvQxuDy
         E8+Fei6GQ5x8bs5CTuxb5adLIyxPRcU5nwcQUavVze0K85SmrYhdksjtklKdVh2uLE
         N777ldpdSn8ugApf9CHa5osP8SP3Dg8dLNACvxnjgESl89Hi7ccjVQcZyb8Ju92Kmu
         GCB6y3HBvahTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, tcrawford@system76.com,
        wse@tuxedocomputers.com, tangmeng@uniontech.com, cam@neo-zeon.de,
        kailang@realtek.com, sbinding@opensource.cirrus.com,
        yong.wu@mediatek.com, andy.chi@canonical.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 16/39] ALSA: hda/realtek: Enable speaker and mute LEDs for HP laptops
Date:   Sun, 14 Aug 2022 12:23:05 -0400
Message-Id: <20220814162332.2396012-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit c578d5da10dc429c6676ab09f3fec0b79b31633a ]

Two more HP laptops that use cs35l41 AMP for speaker and GPIO for mute
LEDs.

So use the existing quirk to enable them accordingly.

[ Sort the entries at the SSID order by tiwai ]

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220719142015.244426-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b7f1f2fb60cb..ebd970961e00 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9166,6 +9166,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.35.1

