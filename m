Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 473B115ED07
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390789AbgBNRb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:31:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390227AbgBNQHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B553024676;
        Fri, 14 Feb 2020 16:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696425;
        bh=zCIYw9z1h9aAJIfGIBE8mP8Jq4/hNqd3Ryhiqlsldjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRyzvXF5QEBnNkCpzyUsEVU98+hlsb8QJB+o1jnuTarsMHmvRuPF62mge5W5flN4Z
         JYidV8ekCBOHFnr12BiqcrrOdffMrKGDuxQyQrjIaXTwLe6eLqb9jE6Y5dY+8uZmZ0
         E65JQirXEsDMA39US+KL2PlShWwBtK2rFXh+c0wI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 245/459] ALSA: hda/realtek - Apply mic mute LED quirk for Dell E7xx laptops, too
Date:   Fri, 14 Feb 2020 10:58:15 -0500
Message-Id: <20200214160149.11681-245-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5fab5829674c279839a7408ab30c71c6dfe726b9 ]

Dell E7xx laptops have also mic mute LED that is driven by the
dell-laptop platform driver.  Bind it with the capture control as
already done for other models.

A caveat is that the fixup hook for the mic mute LED has to be applied
at last, otherwise it results in the invalid override of the callback.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205529
Link: https://lore.kernel.org/r/20200105081119.21396-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 68832f52c1ad2..e8d5f6befa1f3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5848,6 +5848,7 @@ enum {
 	ALC288_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC288_FIXUP_DELL_XPS_13,
 	ALC288_FIXUP_DISABLE_AAMIX,
+	ALC292_FIXUP_DELL_E7X_AAMIX,
 	ALC292_FIXUP_DELL_E7X,
 	ALC292_FIXUP_DISABLE_AAMIX,
 	ALC293_FIXUP_DISABLE_AAMIX_MULTIJACK,
@@ -6543,12 +6544,19 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC293_FIXUP_DELL1_MIC_NO_PRESENCE
 	},
-	[ALC292_FIXUP_DELL_E7X] = {
+	[ALC292_FIXUP_DELL_E7X_AAMIX] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_dell_xps13,
 		.chained = true,
 		.chain_id = ALC292_FIXUP_DISABLE_AAMIX
 	},
+	[ALC292_FIXUP_DELL_E7X] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = snd_hda_gen_fixup_micmute_led,
+		/* micmute fixup must be applied at last */
+		.chained_before = true,
+		.chain_id = ALC292_FIXUP_DELL_E7X_AAMIX,
+	},
 	[ALC298_FIXUP_ALIENWARE_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
-- 
2.20.1

