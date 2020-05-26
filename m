Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5561E2DC7
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391744AbgEZTHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391741AbgEZTHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:07:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC817208DB;
        Tue, 26 May 2020 19:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520073;
        bh=6LNzY0Vl6iJUSjmKIy/aIBiCGtpRDHKWJNqshSO9a1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nlil3N4NzSf03kSlHblBIY1yyDOpXBbjJsmgGjfbmGqv+ClH9przMHXVHMTCawQOu
         yHITPenVrDigGOwmhnmuVljtxicWSgWYCiYEKP+WdmKgnYlHknZSRrjWo/6qYXyKuf
         SbyG0gjDinLKBrHd4FFnuIf8rs/ka1GgGFnlAacs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/111] ALSA: hda - constify and cleanup static NodeID tables
Date:   Tue, 26 May 2020 20:53:06 +0200
Message-Id: <20200526183937.442950981@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit caf3c0437aaf2e63624c4aaf94c0dd38d1f897e3 ]

Make hda_nid_t tables static const, as they are not intended to be
modified by callees.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/5150c94101c9534f4c8e987324f6912c16d459f6.1578043216.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_generic.c    |  4 +--
 sound/pci/hda/patch_analog.c   |  6 ++--
 sound/pci/hda/patch_ca0132.c   | 12 +++----
 sound/pci/hda/patch_conexant.c |  6 ++--
 sound/pci/hda/patch_realtek.c  | 62 +++++++++++++++++-----------------
 sound/pci/hda/patch_sigmatel.c |  4 +--
 sound/pci/hda/patch_via.c      |  4 +--
 7 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 10d502328b76..fc001c64ef20 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -4401,7 +4401,7 @@ EXPORT_SYMBOL_GPL(snd_hda_gen_fix_pin_power);
  */
 
 /* check each pin in the given array; returns true if any of them is plugged */
-static bool detect_jacks(struct hda_codec *codec, int num_pins, hda_nid_t *pins)
+static bool detect_jacks(struct hda_codec *codec, int num_pins, const hda_nid_t *pins)
 {
 	int i;
 	bool present = false;
@@ -4420,7 +4420,7 @@ static bool detect_jacks(struct hda_codec *codec, int num_pins, hda_nid_t *pins)
 }
 
 /* standard HP/line-out auto-mute helper */
-static void do_automute(struct hda_codec *codec, int num_pins, hda_nid_t *pins,
+static void do_automute(struct hda_codec *codec, int num_pins, const hda_nid_t *pins,
 			int *paths, bool mute)
 {
 	struct hda_gen_spec *spec = codec->spec;
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index bc9dd8e6fd86..c64895f99299 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -389,7 +389,7 @@ static int patch_ad1986a(struct hda_codec *codec)
 {
 	int err;
 	struct ad198x_spec *spec;
-	static hda_nid_t preferred_pairs[] = {
+	static const hda_nid_t preferred_pairs[] = {
 		0x1a, 0x03,
 		0x1b, 0x03,
 		0x1c, 0x04,
@@ -519,9 +519,9 @@ static int ad1983_add_spdif_mux_ctl(struct hda_codec *codec)
 
 static int patch_ad1983(struct hda_codec *codec)
 {
+	static const hda_nid_t conn_0c[] = { 0x08 };
+	static const hda_nid_t conn_0d[] = { 0x09 };
 	struct ad198x_spec *spec;
-	static hda_nid_t conn_0c[] = { 0x08 };
-	static hda_nid_t conn_0d[] = { 0x09 };
 	int err;
 
 	err = alloc_ad_spec(codec);
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index adad3651889e..1e904dd15ab3 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -7803,23 +7803,23 @@ static void sbz_region2_exit(struct hda_codec *codec)
 
 static void sbz_set_pin_ctl_default(struct hda_codec *codec)
 {
-	hda_nid_t pins[5] = {0x0B, 0x0C, 0x0E, 0x12, 0x13};
+	static const hda_nid_t pins[] = {0x0B, 0x0C, 0x0E, 0x12, 0x13};
 	unsigned int i;
 
 	snd_hda_codec_write(codec, 0x11, 0,
 			AC_VERB_SET_PIN_WIDGET_CONTROL, 0x40);
 
-	for (i = 0; i < 5; i++)
+	for (i = 0; i < ARRAY_SIZE(pins); i++)
 		snd_hda_codec_write(codec, pins[i], 0,
 				AC_VERB_SET_PIN_WIDGET_CONTROL, 0x00);
 }
 
 static void ca0132_clear_unsolicited(struct hda_codec *codec)
 {
-	hda_nid_t pins[7] = {0x0B, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13};
+	static const hda_nid_t pins[] = {0x0B, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13};
 	unsigned int i;
 
-	for (i = 0; i < 7; i++) {
+	for (i = 0; i < ARRAY_SIZE(pins); i++) {
 		snd_hda_codec_write(codec, pins[i], 0,
 				AC_VERB_SET_UNSOLICITED_ENABLE, 0x00);
 	}
@@ -7843,10 +7843,10 @@ static void sbz_gpio_shutdown_commands(struct hda_codec *codec, int dir,
 
 static void zxr_dbpro_power_state_shutdown(struct hda_codec *codec)
 {
-	hda_nid_t pins[7] = {0x05, 0x0c, 0x09, 0x0e, 0x08, 0x11, 0x01};
+	static const hda_nid_t pins[] = {0x05, 0x0c, 0x09, 0x0e, 0x08, 0x11, 0x01};
 	unsigned int i;
 
-	for (i = 0; i < 7; i++)
+	for (i = 0; i < ARRAY_SIZE(pins); i++)
 		snd_hda_codec_write(codec, pins[i], 0,
 				AC_VERB_SET_POWER_STATE, 0x03);
 }
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 1e20e85e9b46..396b5503038a 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -116,7 +116,7 @@ static void cx_auto_parse_eapd(struct hda_codec *codec)
 }
 
 static void cx_auto_turn_eapd(struct hda_codec *codec, int num_pins,
-			      hda_nid_t *pins, bool on)
+			      const hda_nid_t *pins, bool on)
 {
 	int i;
 	for (i = 0; i < num_pins; i++) {
@@ -960,10 +960,10 @@ static const struct hda_model_fixup cxt5066_fixup_models[] = {
 static void add_cx5051_fake_mutes(struct hda_codec *codec)
 {
 	struct conexant_spec *spec = codec->spec;
-	static hda_nid_t out_nids[] = {
+	static const hda_nid_t out_nids[] = {
 		0x10, 0x11, 0
 	};
-	hda_nid_t *p;
+	const hda_nid_t *p;
 
 	for (p = out_nids; *p; p++)
 		snd_hda_override_amp_caps(codec, *p, HDA_OUTPUT,
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 004d2f638cf2..151099b8c394 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -465,10 +465,10 @@ static void set_eapd(struct hda_codec *codec, hda_nid_t nid, int on)
 static void alc_auto_setup_eapd(struct hda_codec *codec, bool on)
 {
 	/* We currently only handle front, HP */
-	static hda_nid_t pins[] = {
+	static const hda_nid_t pins[] = {
 		0x0f, 0x10, 0x14, 0x15, 0x17, 0
 	};
-	hda_nid_t *p;
+	const hda_nid_t *p;
 	for (p = pins; *p; p++)
 		set_eapd(codec, *p, on);
 }
@@ -1939,19 +1939,19 @@ static void alc889_fixup_dac_route(struct hda_codec *codec,
 {
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		/* fake the connections during parsing the tree */
-		hda_nid_t conn1[2] = { 0x0c, 0x0d };
-		hda_nid_t conn2[2] = { 0x0e, 0x0f };
-		snd_hda_override_conn_list(codec, 0x14, 2, conn1);
-		snd_hda_override_conn_list(codec, 0x15, 2, conn1);
-		snd_hda_override_conn_list(codec, 0x18, 2, conn2);
-		snd_hda_override_conn_list(codec, 0x1a, 2, conn2);
+		static const hda_nid_t conn1[] = { 0x0c, 0x0d };
+		static const hda_nid_t conn2[] = { 0x0e, 0x0f };
+		snd_hda_override_conn_list(codec, 0x14, ARRAY_SIZE(conn1), conn1);
+		snd_hda_override_conn_list(codec, 0x15, ARRAY_SIZE(conn1), conn1);
+		snd_hda_override_conn_list(codec, 0x18, ARRAY_SIZE(conn2), conn2);
+		snd_hda_override_conn_list(codec, 0x1a, ARRAY_SIZE(conn2), conn2);
 	} else if (action == HDA_FIXUP_ACT_PROBE) {
 		/* restore the connections */
-		hda_nid_t conn[5] = { 0x0c, 0x0d, 0x0e, 0x0f, 0x26 };
-		snd_hda_override_conn_list(codec, 0x14, 5, conn);
-		snd_hda_override_conn_list(codec, 0x15, 5, conn);
-		snd_hda_override_conn_list(codec, 0x18, 5, conn);
-		snd_hda_override_conn_list(codec, 0x1a, 5, conn);
+		static const hda_nid_t conn[] = { 0x0c, 0x0d, 0x0e, 0x0f, 0x26 };
+		snd_hda_override_conn_list(codec, 0x14, ARRAY_SIZE(conn), conn);
+		snd_hda_override_conn_list(codec, 0x15, ARRAY_SIZE(conn), conn);
+		snd_hda_override_conn_list(codec, 0x18, ARRAY_SIZE(conn), conn);
+		snd_hda_override_conn_list(codec, 0x1a, ARRAY_SIZE(conn), conn);
 	}
 }
 
@@ -1959,8 +1959,8 @@ static void alc889_fixup_dac_route(struct hda_codec *codec,
 static void alc889_fixup_mbp_vref(struct hda_codec *codec,
 				  const struct hda_fixup *fix, int action)
 {
+	static const hda_nid_t nids[] = { 0x14, 0x15, 0x19 };
 	struct alc_spec *spec = codec->spec;
-	static hda_nid_t nids[3] = { 0x14, 0x15, 0x19 };
 	int i;
 
 	if (action != HDA_FIXUP_ACT_INIT)
@@ -1996,7 +1996,7 @@ static void alc889_fixup_mac_pins(struct hda_codec *codec,
 static void alc889_fixup_imac91_vref(struct hda_codec *codec,
 				     const struct hda_fixup *fix, int action)
 {
-	static hda_nid_t nids[2] = { 0x18, 0x1a };
+	static const hda_nid_t nids[] = { 0x18, 0x1a };
 
 	if (action == HDA_FIXUP_ACT_INIT)
 		alc889_fixup_mac_pins(codec, nids, ARRAY_SIZE(nids));
@@ -2006,7 +2006,7 @@ static void alc889_fixup_imac91_vref(struct hda_codec *codec,
 static void alc889_fixup_mba11_vref(struct hda_codec *codec,
 				    const struct hda_fixup *fix, int action)
 {
-	static hda_nid_t nids[1] = { 0x18 };
+	static const hda_nid_t nids[] = { 0x18 };
 
 	if (action == HDA_FIXUP_ACT_INIT)
 		alc889_fixup_mac_pins(codec, nids, ARRAY_SIZE(nids));
@@ -2016,7 +2016,7 @@ static void alc889_fixup_mba11_vref(struct hda_codec *codec,
 static void alc889_fixup_mba21_vref(struct hda_codec *codec,
 				    const struct hda_fixup *fix, int action)
 {
-	static hda_nid_t nids[2] = { 0x18, 0x19 };
+	static const hda_nid_t nids[] = { 0x18, 0x19 };
 
 	if (action == HDA_FIXUP_ACT_INIT)
 		alc889_fixup_mac_pins(codec, nids, ARRAY_SIZE(nids));
@@ -2098,7 +2098,7 @@ static void alc1220_fixup_clevo_p950(struct hda_codec *codec,
 				     const struct hda_fixup *fix,
 				     int action)
 {
-	hda_nid_t conn1[1] = { 0x0c };
+	static const hda_nid_t conn1[] = { 0x0c };
 
 	if (action != HDA_FIXUP_ACT_PRE_PROBE)
 		return;
@@ -2107,8 +2107,8 @@ static void alc1220_fixup_clevo_p950(struct hda_codec *codec,
 	/* We therefore want to make sure 0x14 (front headphone) and
 	 * 0x1b (speakers) use the stereo DAC 0x02
 	 */
-	snd_hda_override_conn_list(codec, 0x14, 1, conn1);
-	snd_hda_override_conn_list(codec, 0x1b, 1, conn1);
+	snd_hda_override_conn_list(codec, 0x14, ARRAY_SIZE(conn1), conn1);
+	snd_hda_override_conn_list(codec, 0x1b, ARRAY_SIZE(conn1), conn1);
 }
 
 static void alc_fixup_headset_mode_no_hp_mic(struct hda_codec *codec,
@@ -5371,7 +5371,7 @@ static void alc_fixup_tpt470_dock(struct hda_codec *codec,
 	 * the speaker output becomes too low by some reason on Thinkpads with
 	 * ALC298 codec
 	 */
-	static hda_nid_t preferred_pairs[] = {
+	static const hda_nid_t preferred_pairs[] = {
 		0x14, 0x03, 0x17, 0x02, 0x21, 0x02,
 		0
 	};
@@ -5632,9 +5632,9 @@ static void alc290_fixup_mono_speakers(struct hda_codec *codec,
 		/* DAC node 0x03 is giving mono output. We therefore want to
 		   make sure 0x14 (front speaker) and 0x15 (headphones) use the
 		   stereo DAC, while leaving 0x17 (bass speaker) for node 0x03. */
-		hda_nid_t conn1[2] = { 0x0c };
-		snd_hda_override_conn_list(codec, 0x14, 1, conn1);
-		snd_hda_override_conn_list(codec, 0x15, 1, conn1);
+		static const hda_nid_t conn1[] = { 0x0c };
+		snd_hda_override_conn_list(codec, 0x14, ARRAY_SIZE(conn1), conn1);
+		snd_hda_override_conn_list(codec, 0x15, ARRAY_SIZE(conn1), conn1);
 	}
 }
 
@@ -5649,8 +5649,8 @@ static void alc298_fixup_speaker_volume(struct hda_codec *codec,
 		   Pin Complex), since Node 0x02 has Amp-out caps, we can adjust
 		   speaker's volume now. */
 
-		hda_nid_t conn1[1] = { 0x0c };
-		snd_hda_override_conn_list(codec, 0x17, 1, conn1);
+		static const hda_nid_t conn1[] = { 0x0c };
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn1), conn1);
 	}
 }
 
@@ -5659,8 +5659,8 @@ static void alc295_fixup_disable_dac3(struct hda_codec *codec,
 				      const struct hda_fixup *fix, int action)
 {
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
-		hda_nid_t conn[2] = { 0x02, 0x03 };
-		snd_hda_override_conn_list(codec, 0x17, 2, conn);
+		static const hda_nid_t conn[] = { 0x02, 0x03 };
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
 	}
 }
 
@@ -5669,8 +5669,8 @@ static void alc285_fixup_speaker2_to_dac1(struct hda_codec *codec,
 					  const struct hda_fixup *fix, int action)
 {
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
-		hda_nid_t conn[1] = { 0x02 };
-		snd_hda_override_conn_list(codec, 0x17, 1, conn);
+		static const hda_nid_t conn[] = { 0x02 };
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
 	}
 }
 
@@ -5757,7 +5757,7 @@ static void alc274_fixup_bind_dacs(struct hda_codec *codec,
 				    const struct hda_fixup *fix, int action)
 {
 	struct alc_spec *spec = codec->spec;
-	static hda_nid_t preferred_pairs[] = {
+	static const hda_nid_t preferred_pairs[] = {
 		0x21, 0x03, 0x1b, 0x03, 0x16, 0x02,
 		0
 	};
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 894f3f509e76..4b9300babc7d 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -795,7 +795,7 @@ static int find_mute_led_cfg(struct hda_codec *codec, int default_polarity)
 static bool has_builtin_speaker(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec = codec->spec;
-	hda_nid_t *nid_pin;
+	const hda_nid_t *nid_pin;
 	int nids, i;
 
 	if (spec->gen.autocfg.line_out_type == AUTO_PIN_SPEAKER_OUT) {
@@ -2182,7 +2182,7 @@ static void hp_envy_ts_fixup_dac_bind(struct hda_codec *codec,
 					    int action)
 {
 	struct sigmatel_spec *spec = codec->spec;
-	static hda_nid_t preferred_pairs[] = {
+	static const hda_nid_t preferred_pairs[] = {
 		0xd, 0x13,
 		0
 	};
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 29dcdb8b36db..b40d01e01832 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1038,8 +1038,8 @@ static const struct snd_pci_quirk vt2002p_fixups[] = {
  */
 static void fix_vt1802_connections(struct hda_codec *codec)
 {
-	static hda_nid_t conn_24[] = { 0x14, 0x1c };
-	static hda_nid_t conn_33[] = { 0x1c };
+	static const hda_nid_t conn_24[] = { 0x14, 0x1c };
+	static const hda_nid_t conn_33[] = { 0x1c };
 
 	snd_hda_override_conn_list(codec, 0x24, ARRAY_SIZE(conn_24), conn_24);
 	snd_hda_override_conn_list(codec, 0x33, ARRAY_SIZE(conn_33), conn_33);
-- 
2.25.1



