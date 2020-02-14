Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8243015F1B6
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbgBNPzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:55:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731677AbgBNPzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 200EE24681;
        Fri, 14 Feb 2020 15:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695701;
        bh=+lg7ncunAhWh6Y7acBocNv6D+2xu0CScvM3Nk5X6FjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OyCqizPgovmGpLs9anemav2f//76rsLSQqe70ZF9jeP3NabH16Zq8CceW8Ev1lZy7
         fDxclhoSiulLfFXaBgrGF2UoeNjUnfwM5MI/RK2VCf5HFE/A7Xr3h9cqL45LeBc3XV
         Kae1x6HbxEdzbJWeTSxhtvTb5FLzpgdk7UuNDRlo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.5 283/542] ALSA: hda/realtek - Apply mic mute LED quirk for Dell E7xx laptops, too
Date:   Fri, 14 Feb 2020 10:44:35 -0500
Message-Id: <20200214154854.6746-283-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
index f2ea3528bfb1d..f952df64d5302 100644
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

