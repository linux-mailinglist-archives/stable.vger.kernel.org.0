Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17B12F141B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732868AbhAKNUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732807AbhAKNSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 096572250F;
        Mon, 11 Jan 2021 13:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371047;
        bh=dSAyY5YQZ2k+3B7GRzaJh6FEdJUK+pijLdCsbNVqXhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itobrWwDO4v4euQZ3hCY451Y1ojobZk/ydugwJ8iEnnT18e/GmtsUlxOkouxiU2nn
         TrASn81uUQTJK1yAA3miY1CeqEPo4JOP8FnUHa73QcBQbTeX0Be9j5pxq/lfWLbm5L
         SQ4hCvOULWLaPiBwOdzidaMFk+VldrHLLtfw1kv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Labisch <clnetbox@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 118/145] ALSA: hda/via: Fix runtime PM for Clevo W35xSS
Date:   Mon, 11 Jan 2021 14:02:22 +0100
Message-Id: <20210111130054.200559808@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 4bfd6247fa9164c8e193a55ef9c0ea3ee22f82d8 upstream.

Clevo W35xSS_370SS with VIA codec has had the runtime PM problem that
looses the power state of some nodes after the runtime resume.  This
was worked around by disabling the default runtime PM via a denylist
entry.  Since 5.10.x made the runtime PM applied (casually) even
though it's disabled in the denylist, this problem was revisited.  The
result was that disabling power_save_node feature suffices for the
runtime PM problem.

This patch implements the disablement of power_save_node feature in
VIA codec for the device.  It also drops the former denylist entry,
too, as the runtime PM should work in the codec side properly now.

Fixes: b529ef2464ad ("ALSA: hda: Add Clevo W35xSS_370SS to the power_save blacklist")
Reported-by: Christian Labisch <clnetbox@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210104153046.19993-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    2 --
 sound/pci/hda/patch_via.c |   13 +++++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2220,8 +2220,6 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1849, 0x7662, "Asrock H81M-HDS", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
 	SND_PCI_QUIRK(0x1043, 0x8733, "Asus Prime X370-Pro", 0),
-	/* https://bugzilla.redhat.com/show_bug.cgi?id=1581607 */
-	SND_PCI_QUIRK(0x1558, 0x3501, "Clevo W35xSS_370SS", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
 	SND_PCI_QUIRK(0x1558, 0x6504, "Clevo W65_67SB", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1002,6 +1002,7 @@ static const struct hda_verb vt1802_init
 enum {
 	VIA_FIXUP_INTMIC_BOOST,
 	VIA_FIXUP_ASUS_G75,
+	VIA_FIXUP_POWER_SAVE,
 };
 
 static void via_fixup_intmic_boost(struct hda_codec *codec,
@@ -1011,6 +1012,13 @@ static void via_fixup_intmic_boost(struc
 		override_mic_boost(codec, 0x30, 0, 2, 40);
 }
 
+static void via_fixup_power_save(struct hda_codec *codec,
+				 const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		codec->power_save_node = 0;
+}
+
 static const struct hda_fixup via_fixups[] = {
 	[VIA_FIXUP_INTMIC_BOOST] = {
 		.type = HDA_FIXUP_FUNC,
@@ -1025,11 +1033,16 @@ static const struct hda_fixup via_fixups
 			{ }
 		}
 	},
+	[VIA_FIXUP_POWER_SAVE] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = via_fixup_power_save,
+	},
 };
 
 static const struct snd_pci_quirk vt2002p_fixups[] = {
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
+	SND_PCI_QUIRK(0x1558, 0x3501, "Clevo W35xSS_370SS", VIA_FIXUP_POWER_SAVE),
 	{}
 };
 


