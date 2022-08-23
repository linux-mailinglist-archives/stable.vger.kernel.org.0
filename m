Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAA459D9F4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243567AbiHWKEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352435AbiHWKBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9786B640;
        Tue, 23 Aug 2022 01:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DE4FB81C1C;
        Tue, 23 Aug 2022 08:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DDFC433D7;
        Tue, 23 Aug 2022 08:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243727;
        bh=feQFNZ1S7BhDIdTLYLh+/Cpkv2mdA7IxHtZ5KdwUEPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwF//Reg6Tc+JIlUe/l7o7kNtaA9i8I7v09dyiStBEhSkr//TfIqe9OsXBq2a9skO
         FDlT4EkIHt1ZL/dKcm34Sq3kNVzDaOCvuphK2UY+V81nnVloZjnclQjDq6GYNXxo7z
         nRSzrAU0qUN/fwgkpJ89FtZOfGHWm+isZoHz+a3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 338/365] ALSA: hda/realtek: Enable speaker and mute LEDs for HP laptops
Date:   Tue, 23 Aug 2022 10:03:59 +0200
Message-Id: <20220823080132.356410307@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
index 09d97a8afdda..1ae9674fa8a3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9234,6 +9234,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
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



