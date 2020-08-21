Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1F724DE5D
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgHUR3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgHUQO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:14:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B79208DB;
        Fri, 21 Aug 2020 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026468;
        bh=KXQV7iN6LfRHw4fLqfpnmxvNW34f/PK96F7lMXsjoCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hv7W/vIizXQxpqteMFQwNXpFg8sppcx4MvtwnUQZ1qOGmwkWxt1dOYwlvK/oOVqgl
         ns/8qwGAGlWdXotADZaQ6DWWp6Gao3P4ZMdFxP9D99VPR3XoFJropswSDl+VjgWzU5
         Ei2huTCDiuOiBOAJwppNkWosW2ok3GcX9fkZpjV0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.8 03/62] ALSA: hda/realtek: Fix pin default on Intel NUC 8 Rugged
Date:   Fri, 21 Aug 2020 12:13:24 -0400
Message-Id: <20200821161423.347071-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit e2d2fded6bdf3f7bb40718a208140dba8b4ec574 ]

The jack on Intel NUC 8 Rugged rear panel doesn't work.

The spec [1] states that the jack supports both headphone and
microphone, so override a Pin Complex which has both Amp-In and Amp-Out
to make the jack work.

Node 0x1b fits the requirement, and user confirmed the jack now works
with new pin config.

[1] https://www.intel.com/content/dam/support/us/en/documents/mini-pcs/NUC8CCH_TechProdSpec.pdf
BugLink: https://bugs.launchpad.net/bugs/1875199

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200807080514.15293-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 00d155b98c1d1..049a07447ba1a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6169,6 +6169,7 @@ enum {
 	ALC269_FIXUP_CZC_L101,
 	ALC269_FIXUP_LEMOTE_A1802,
 	ALC269_FIXUP_LEMOTE_A190X,
+	ALC256_FIXUP_INTEL_NUC8_RUGGED,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7490,6 +7491,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		},
 		.chain_id = ALC269_FIXUP_DMIC,
 	},
+	[ALC256_FIXUP_INTEL_NUC8_RUGGED] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1b, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7787,6 +7797,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
+	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
-- 
2.25.1

