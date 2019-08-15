Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65618E655
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 10:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbfHOIaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 04:30:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35896 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730534AbfHOIaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 04:30:23 -0400
Received: from [114.252.209.139] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1hyB9H-0005Ya-A0; Thu, 15 Aug 2019 08:30:19 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] ALSA: hda - Add a new match function for only undef configurations
Date:   Thu, 15 Aug 2019 16:30:00 +0800
Message-Id: <20190815083001.3793-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With the existing pintbl, we already have many entries in it. it is
better to figure out a new match to reduce the size of the pintbl.

For example, there are over 10 entries in the pintbl for:
0x10ec0255, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE

If we define a new tbl like below, and with the new adding match
function, we can remove those over 10 entries:
SND_HDA_PIN_QUIRK(0x10ec0255, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
	{0x19, 0x40000000},
	{0x1a, 0x40000000},),

Here we put 0x19 and 0x1a in the tbl just because these two pins are
undefined on Dell laptops with the codec alc255, and these two pins
will be overwritten by ALC255_FIXUP_DELL1_MIC_NO_PRESENCE.

In summary: the new match will check vendor id and codec id first,
then check the pin_cfg defined in the tbl, only all pin_cfgs in the
tbl are undef and the corresponding pin_cfgs on the laptop are undef
too, this match returns true.

This new match function has lower priority than existing match
functions, so the existing tbls still work as before after applying this
patch.

My plan is to change the existing tbl to undef tbl for MIC_NO_PRESENCE
fixups gradually.

Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/hda_auto_parser.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_auto_parser.c b/sound/pci/hda/hda_auto_parser.c
index 92390d457567..cfada7401b86 100644
--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -915,6 +915,36 @@ static bool pin_config_match(struct hda_codec *codec,
 	return true;
 }
 
+/* match the pintbl which only contains specific pins with undef configuration */
+static bool pin_config_match_undef(struct hda_codec *codec,
+				   const struct hda_pintbl *pins)
+{
+	bool match = false;
+
+	for (; pins->nid; pins++) {
+		const struct hda_pincfg *pin;
+		int i;
+
+		if ((pins->val & 0xf0000000) != 0x40000000)
+			return false;
+
+		match = false;
+		snd_array_for_each(&codec->init_pins, i, pin) {
+			if (pin->nid != pins->nid)
+				continue;
+			if ((pin->cfg & 0xf0000000) != 0x40000000)
+				return false;
+			match = true;
+			break;
+		}
+
+		if (match == false)
+			return false;
+	}
+
+	return match;
+}
+
 /**
  * snd_hda_pick_pin_fixup - Pick up a fixup matching with the pin quirk list
  * @codec: the HDA codec
@@ -935,7 +965,7 @@ void snd_hda_pick_pin_fixup(struct hda_codec *codec,
 			continue;
 		if (codec->core.vendor_id != pq->codec)
 			continue;
-		if (pin_config_match(codec, pq->pins)) {
+		if (pin_config_match(codec, pq->pins) || pin_config_match_undef(codec, pq->pins)) {
 			codec->fixup_id = pq->value;
 #ifdef CONFIG_SND_DEBUG_VERBOSE
 			codec->fixup_name = pq->name;
-- 
2.17.1

