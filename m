Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC904F70E7
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbiDGBXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240350AbiDGBT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:19:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B828182AD9;
        Wed,  6 Apr 2022 18:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B8F9B8261D;
        Thu,  7 Apr 2022 01:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B17C385A1;
        Thu,  7 Apr 2022 01:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294146;
        bh=cgsJW/lQPZmV/rD41uAn4aKxYHvrVPnYbrDnAmwpIEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m64ieoaHyxpBVVZq0O1VOrFS9maaPDnKn9mjNv4XDxKDZy3y0W8L+XHmoY5pe4O1E
         DXMtl6kpeDoXFbU0TkGdIwpi+9Q3hppzO8aTSKteiYwsc3R926Gkbaj8k1tLlN4NOG
         bz8t9sYN979YC3MdWRF5ytZCys+5zcA11bb8YBCd1hzVCT1tJS+BnvhbnLomfNBw0R
         5Z+i0isf6Re/CG4HafpmraBQeUONf1zYHTAQRlyk+Yu31OjkmrC4pA0rIXvdnYAdfr
         matVd/ZclebBVMFehrHKKxgDt/OLgLatOn4qQBxFIgSrkJaAssuGWV3MUtLREHtLbA
         3oKni8AyaFl7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, jeremy.szu@canonical.com,
        wse@tuxedocomputers.com, hui.wang@canonical.com,
        tanureal@opensource.cirrus.com, cam@neo-zeon.de,
        kailang@realtek.com, sami@loone.fi, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 09/17] ALSA: hda/realtek: Enable headset mic on Lenovo P360
Date:   Wed,  6 Apr 2022 21:15:13 -0400
Message-Id: <20220407011521.115014-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011521.115014-1-sashal@kernel.org>
References: <20220407011521.115014-1-sashal@kernel.org>
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
index d201043d661c..4bcf833781bd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10221,6 +10221,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
+	SND_PCI_QUIRK(0x17aa, 0x1057, "Lenovo P360", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32ca, "Lenovo ThinkCentre M80", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cb, "Lenovo ThinkCentre M70", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cf, "Lenovo ThinkCentre M950", ALC897_FIXUP_HEADSET_MIC_PIN),
-- 
2.35.1

