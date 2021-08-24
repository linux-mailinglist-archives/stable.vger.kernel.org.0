Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BAE3F6555
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239649AbhHXRME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240182AbhHXRKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B02261407;
        Tue, 24 Aug 2021 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824434;
        bh=s73NqyE/YVtreGzTT8CpCbgnPgnh21nkO3rOL7NR0j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzP1ruyJkJ8zr4i3dRwKQKJ3aBQX2U/coQ4iGC94F3gviNLfewnBec1X/mhvjBBad
         hUPxHfnlCIdMzxdDdm8IPZMYXsH6XcV+NKCx8iLl5c1uKU0T2ulEcVeWO7od6D+9AX
         8+CTHTSsMj/++mhvUxgtCiZrzHR//zM8Zehjitk/uY5py5gl5pdlIj5VSMIqXi6hlU
         nAj5Cp4lNZmB8Sr5Gu5LoRpprDkDl7xiDWUt9PVDjoAOfCpEoRB7I5ogTzGPW+eWd6
         FoYrT4MyEDIiVJQVJEiH/nFbY2jYpsFqPMeSPI2tGybdSsTElkS197mBRTAZPlak0T
         FuCptelXfBwXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kristin Paget <kristin@tombom.co.uk>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 85/98] ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9510 laptop
Date:   Tue, 24 Aug 2021 12:58:55 -0400
Message-Id: <20210824165908.709932-86-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristin Paget <kristin@tombom.co.uk>

[ Upstream commit da94692001ea45ffa1f5e9f17ecdef7aecd90c27 ]

The 2021-model XPS 15 appears to use the same 4-speakers-on-ALC289 audio
setup as the Precision models, so requires the same quirk to enable woofer
output. Tested on my own 9510.

Signed-off-by: Kristin Paget <kristin@tombom.co.uk>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/e1fc95c5-c10a-1f98-a5c2-dd6e336157e1@tombom.co.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index beb5fb03e388..de4cd91b9ba8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8258,6 +8258,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a58, "Dell", ALC255_FIXUP_DELL_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1028, 0x0a61, "Dell XPS 15 9510", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
-- 
2.30.2

