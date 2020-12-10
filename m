Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0476D2D5E06
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391088AbgLJOhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391080AbgLJOh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:26 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 11/75] ALSA: hda/realtek: Fix bass speaker DAC assignment on Asus Zephyrus G14
Date:   Thu, 10 Dec 2020 15:26:36 +0100
Message-Id: <20201210142606.630405795@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c84bfedce60192c08455ee2d25dd13d19274a266 upstream.

ASUS Zephyrus G14 has two speaker pins, and the auto-parser tries to
assign an individual DAC to each pin as much as possible.
Unfortunately the third DAC has no volume control unlike the two DACs,
and this resulted in the inconsistent speaker volumes.

As a workaround, wire both speaker pins to the same DAC by modifying
the existing quirk (ALC289_FIXUP_ASUS_GA401) applied to this device.
Since this quirk entry is chained by another, we need to avoid
applying the DAC assignment change for it.  Luckily, there is another
quirk entry (ALC289_FIXUP_ASUS_GA502) doing the very same thing, so we
can chain to the GA502 quirk instead.

Note that this patch uses a new flag of the generic parser,
obey_preferred_dacs, for enforcing the DACs.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210359
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201127141104.11041-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6014,6 +6014,21 @@ static void alc274_fixup_bind_dacs(struc
 	codec->power_save_node = 0;
 }
 
+/* avoid DAC 0x06 for bass speaker 0x17; it has no volume control */
+static void alc289_fixup_asus_ga401(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	static const hda_nid_t preferred_pairs[] = {
+		0x14, 0x02, 0x17, 0x02, 0x21, 0x03, 0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->gen.preferred_dacs = preferred_pairs;
+		spec->gen.obey_preferred_dacs = 1;
+	}
+}
+
 /* The DAC of NID 0x3 will introduce click/pop noise on headphones, so invalidate it */
 static void alc285_fixup_invalidate_dacs(struct hda_codec *codec,
 			      const struct hda_fixup *fix, int action)
@@ -7569,11 +7584,10 @@ static const struct hda_fixup alc269_fix
 		.chain_id = ALC269_FIXUP_HEADSET_MIC
 	},
 	[ALC289_FIXUP_ASUS_GA401] = {
-		.type = HDA_FIXUP_PINS,
-		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x19, 0x03a11020 }, /* headset mic with jack detect */
-			{ }
-		},
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc289_fixup_asus_ga401,
+		.chained = true,
+		.chain_id = ALC289_FIXUP_ASUS_GA502,
 	},
 	[ALC289_FIXUP_ASUS_GA502] = {
 		.type = HDA_FIXUP_PINS,
@@ -7697,7 +7711,7 @@ static const struct hda_fixup alc269_fix
 			{ }
 		},
 		.chained = true,
-		.chain_id = ALC289_FIXUP_ASUS_GA401
+		.chain_id = ALC289_FIXUP_ASUS_GA502
 	},
 	[ALC274_FIXUP_HP_MIC] = {
 		.type = HDA_FIXUP_VERBS,


