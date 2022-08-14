Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AE85923A8
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbiHNQXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241275AbiHNQWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:22:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265F7F35;
        Sun, 14 Aug 2022 09:21:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B002860F49;
        Sun, 14 Aug 2022 16:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E469C433B5;
        Sun, 14 Aug 2022 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494072;
        bh=WKWA3UbghQorOkZYcUPew9I9PowLOt2UNz2dEBzlkn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0NKCGW6cf6MwE+NMh6X3mJgAcVnpBs3ru+eedJh60bU155M0570rLXY0cxUd0Foe
         mlI/Z8r32XTABSUMNLpGVseUCjc7sdYklzgUMW1VHwR1mdxK0AWHid3sc+/fh6URgt
         S0Q2fQENmEVfTSpVRKvNXj0Ose6VSVe45yIMJedu7PWdW1QMDoaDUAy1IxODWmBZzg
         qrC2sStO7hb5uP/+bBAYpg1ZUVhxqG4sCQWg4RcIszthGVJeltquP9tymPRUxdn7Fm
         usIjKNe10lwnaF1nzicKEcUUL9N3sPnHgqDjTnv8lBpEkKYeFoxE9tY5j8eW6ZsUwZ
         NGPkG79oyIhvA==
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
Subject: [PATCH AUTOSEL 5.19 23/48] ALSA: hda/realtek: Enable speaker and mute LEDs for HP laptops
Date:   Sun, 14 Aug 2022 12:19:16 -0400
Message-Id: <20220814161943.2394452-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
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
index 2f55bc43bfa9..8da712c5d743 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9114,6 +9114,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
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

