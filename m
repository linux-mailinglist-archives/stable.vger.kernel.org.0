Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A265D4F702D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiDGBRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237302AbiDGBQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:16:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610CF1925BD;
        Wed,  6 Apr 2022 18:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45DCFB8268A;
        Thu,  7 Apr 2022 01:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542DEC385A3;
        Thu,  7 Apr 2022 01:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293936;
        bh=zYBeZSmWVUsvZOrwcGFWfuK0yc2qJdKqXYxquMyxDZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3AaJzLM/kaxiiyvX83swa6VtRe903nJeBnNMuitKiQ27TEhWyQt64+7dB95sAE/L
         9EqbJ/bggihVqHY8rfp2Wv0ry68hVlZ0/2X7J6y92vgGAo2mhVZlFNcod8IfRqxdAu
         fWnPYFmaPeMbbQ6cfXFbEFmfzYqCqw2LWnCIBLYhor2QnXQ34zHKhUs4AD1Sr1n6dq
         SEpNf4P+Bc7LGmSPUwstEyAsWaRh8UO8W6D4PWOgWA8B7IFOjmocxxODDG3OxsxYIF
         NfVybfH2Hq3wLI+8xPSQpK3AlJkLznfBVvVBgtdcWEhNb2+r6CrvwfPPasi732nS/n
         k9Bzp3t4A2f7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, jeremy.szu@canonical.com,
        wse@tuxedocomputers.com, hui.wang@canonical.com,
        tanureal@opensource.cirrus.com, cam@neo-zeon.de,
        kailang@realtek.com, sami@loone.fi, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 16/30] ALSA: hda/realtek: Enable headset mic on Lenovo P360
Date:   Wed,  6 Apr 2022 21:11:26 -0400
Message-Id: <20220407011140.113856-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011140.113856-1-sashal@kernel.org>
References: <20220407011140.113856-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 5a8738571747c1e275a40b69a608657603867b7e ]

Lenovo P360 is another platform equipped with ALC897, and it needs
ALC897_FIXUP_HEADSET_MIC_PIN quirk to make its headset mic work.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20220325160501.705221-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 08bf8a77a3e4..31228896638f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10931,6 +10931,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
+	SND_PCI_QUIRK(0x17aa, 0x1057, "Lenovo P360", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32ca, "Lenovo ThinkCentre M80", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cb, "Lenovo ThinkCentre M70", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cf, "Lenovo ThinkCentre M950", ALC897_FIXUP_HEADSET_MIC_PIN),
-- 
2.35.1

