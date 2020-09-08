Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22BE261425
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbgIHQHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731219AbgIHQFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED1AD223C8;
        Tue,  8 Sep 2020 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579949;
        bh=/24qU1YF+DNhXqOglgtPE5LMLxhOMM44FY3ibsFAl5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDaNv/q9YzgrmApT9hROh+p7I6aRNlxNEg7Hkvg0ZbX6ay8fUwDiGdkeCHoisFnxu
         XlRmKzRaUqIzQGkkPM2WMnFB1yWm9RbmJWU0xEcsPI5aLPEWh7dSDFCPPTmPHBEjM/
         RA1Gv1IZP3sZYuSyoElpKnRfIWpWiTCESdpD81OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 098/129] ALSA: hda/realtek - Improved routing for Thinkpad X1 7th/8th Gen
Date:   Tue,  8 Sep 2020 17:25:39 +0200
Message-Id: <20200908152234.701976064@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 6a6660d049f88b89fd9a4b9db3581b245f7782fa upstream.

There've been quite a few regression reports about the lowered volume
(reduced to ca 65% from the previous level) on Lenovo Thinkpad X1
after the commit d2cd795c4ece ("ALSA: hda - fixup for the bass speaker
on Lenovo Carbon X1 7th gen").  Although the commit itself does the
right thing from HD-audio POV in order to have a volume control for
bass speakers, it seems that the machine has some secret recipe under
the hood.

Through experiments, Benjamin Poirier found out that the following
routing gives the best result:
* DAC1 (NID 0x02) -> Speaker pin (NID 0x14)
* DAC2 (NID 0x03) -> Shared by both Bass Speaker pin (NID 0x17) &
                     Headphone pin (0x21)
* DAC3 (NID 0x06) -> Unused

DAC1 seems to have some equalizer internally applied, and you'd get
again the output in a bad quality if you connect this to the
headphone pin.  Hence the headphone is connected to DAC2, which is now
shared with the bass speaker pin.  DAC3 has no volume amp, hence it's
not connected at all.

For achieving the routing above, this patch introduced a couple of
workarounds:

* The connection list of bass speaker pin (NID 0x17) is reduced not to
  include DAC3 (NID 0x06)
* Pass preferred_pairs array to specify the fixed connection

Here, both workarounds are needed because the generic parser prefers
the individual DAC assignment over others.

When the routing above is applied, the generic parser creates the two
volume controls "Front" and "Bass Speaker".  Since we have only two
DACs for three output pins, those are not fully controlling each
output individually, and it would confuse PulseAudio.  For avoiding
the pitfall, in this patch, we rename those volume controls to some
unique ones ("DAC1" and "DAC2").  Then PulseAudio ignore them and
concentrate only on the still good-working "Master" volume control.
If a user still wants to control each DAC volume, they can still
change manually via "DAC1" and "DAC2" volume controls.

Fixes: d2cd795c4ece ("ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen")
Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Tested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207407#c10
BugLink: https://gist.github.com/hamidzr/dd81e429dc86f4327ded7a2030e7d7d9#gistcomment-3214171
BugLink: https://gist.github.com/hamidzr/dd81e429dc86f4327ded7a2030e7d7d9#gistcomment-3276276
Link: https://lore/kernel.org/r/20200829112746.3118-1-benjamin.poirier@gmail.com
Link: https://lore.kernel.org/r/20200903083300.6333-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5850,6 +5850,39 @@ static void alc275_fixup_gpio4_off(struc
 	}
 }
 
+/* Quirk for Thinkpad X1 7th and 8th Gen
+ * The following fixed routing needed
+ * DAC1 (NID 0x02) -> Speaker (NID 0x14); some eq applied secretly
+ * DAC2 (NID 0x03) -> Bass (NID 0x17) & Headphone (NID 0x21); sharing a DAC
+ * DAC3 (NID 0x06) -> Unused, due to the lack of volume amp
+ */
+static void alc285_fixup_thinkpad_x1_gen7(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	static const hda_nid_t conn[] = { 0x02, 0x03 }; /* exclude 0x06 */
+	static const hda_nid_t preferred_pairs[] = {
+		0x14, 0x02, 0x17, 0x03, 0x21, 0x03, 0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+		spec->gen.preferred_dacs = preferred_pairs;
+		break;
+	case HDA_FIXUP_ACT_BUILD:
+		/* The generic parser creates somewhat unintuitive volume ctls
+		 * with the fixed routing above, and the shared DAC2 may be
+		 * confusing for PA.
+		 * Rename those to unique names so that PA doesn't touch them
+		 * and use only Master volume.
+		 */
+		rename_ctl(codec, "Front Playback Volume", "DAC1 Playback Volume");
+		rename_ctl(codec, "Bass Speaker Playback Volume", "DAC2 Playback Volume");
+		break;
+	}
+}
+
 static void alc233_alc662_fixup_lenovo_dual_codecs(struct hda_codec *codec,
 					 const struct hda_fixup *fix,
 					 int action)
@@ -6118,6 +6151,7 @@ enum {
 	ALC289_FIXUP_DUAL_SPK,
 	ALC294_FIXUP_SPK2_TO_DAC1,
 	ALC294_FIXUP_ASUS_DUAL_SPK,
+	ALC285_FIXUP_THINKPAD_X1_GEN7,
 	ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	ALC294_FIXUP_ASUS_HPE,
 	ALC294_FIXUP_ASUS_COEF_1B,
@@ -7263,11 +7297,17 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC294_FIXUP_SPK2_TO_DAC1
 	},
+	[ALC285_FIXUP_THINKPAD_X1_GEN7] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_thinkpad_x1_gen7,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_THINKPAD_ACPI
+	},
 	[ALC285_FIXUP_THINKPAD_HEADSET_JACK] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_headset_jack,
 		.chained = true,
-		.chain_id = ALC285_FIXUP_SPEAKER2_TO_DAC1
+		.chain_id = ALC285_FIXUP_THINKPAD_X1_GEN7
 	},
 	[ALC294_FIXUP_ASUS_HPE] = {
 		.type = HDA_FIXUP_VERBS,


