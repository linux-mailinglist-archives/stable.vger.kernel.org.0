Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD2465B117
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbjABLaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbjABL3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DD36467
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:29:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2E5BCE0E56
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51E6C433EF;
        Mon,  2 Jan 2023 11:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658951;
        bh=uE67fX6++AUoUcMeQtfMYz/Z7jd15Bz5ZGJmjvZ3WRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8ifWIBP/tvhU/VpOSbpSOK9423CgPlpUe1il7AWdbqQ0jSeViyke8Jr0F+2veT4O
         yfsDlhAzVkEGQ2VGYTjaPA4XBNxwXpEOstW+uPsNnkz7dZc3wv/47hsHT7K36ek3pA
         wU/gkLhC7/6z874W32csUUq5rECmISAp8SbMzwdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 61/74] ALSA: hda/hdmi: Static PCM mapping again with AMD HDMI codecs
Date:   Mon,  2 Jan 2023 12:22:34 +0100
Message-Id: <20230102110554.702479190@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 090ddad4c7a9fefd647c762093a555870a19c8b2 upstream.

The recent code refactoring for HD-audio HDMI codec driver caused a
regression on AMD/ATI HDMI codecs; namely, PulseAudioand pipewire
don't recognize HDMI outputs any longer while the direct output via
ALSA raw access still works.

The problem turned out that, after the code refactoring, the driver
assumes only the dynamic PCM assignment, and when a PCM stream that
still isn't assigned to any pin gets opened, the driver tries to
assign any free converter to the PCM stream.  This behavior is OK for
Intel and other codecs, as they have arbitrary connections between
pins and converters.  OTOH, on AMD chips that have a 1:1 mapping
between pins and converters, this may end up with blocking the open of
the next PCM stream for the pin that is tied with the formerly taken
converter.

Also, with the code refactoring, more PCM streams are exposed than
necessary as we assume all converters can be used, while this isn't
true for AMD case.  This may change the PCM stream assignment and
confuse users as well.

This patch fixes those problems by:

- Introducing a flag spec->static_pcm_mapping, and if it's set, the
  driver applies the static mapping between pins and converters at the
  probe time
- Limiting the number of PCM streams per pins, too; this avoids the
  superfluous PCM streams

Fixes: ef6f5494faf6 ("ALSA: hda/hdmi: Use only dynamic PCM device allocation")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216836
Co-developed-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20221228125714.16329-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -167,6 +167,7 @@ struct hdmi_spec {
 	struct hdmi_ops ops;
 
 	bool dyn_pin_out;
+	bool static_pcm_mapping;
 	/* hdmi interrupt trigger control flag for Nvidia codec */
 	bool hdmi_intr_trig_ctrl;
 	bool nv_dp_workaround; /* workaround DP audio infoframe for Nvidia */
@@ -1525,13 +1526,16 @@ static void update_eld(struct hda_codec
 	 */
 	pcm_jack = pin_idx_to_pcm_jack(codec, per_pin);
 
-	if (eld->eld_valid) {
-		hdmi_attach_hda_pcm(spec, per_pin);
-		hdmi_pcm_setup_pin(spec, per_pin);
-	} else {
-		hdmi_pcm_reset_pin(spec, per_pin);
-		hdmi_detach_hda_pcm(spec, per_pin);
+	if (!spec->static_pcm_mapping) {
+		if (eld->eld_valid) {
+			hdmi_attach_hda_pcm(spec, per_pin);
+			hdmi_pcm_setup_pin(spec, per_pin);
+		} else {
+			hdmi_pcm_reset_pin(spec, per_pin);
+			hdmi_detach_hda_pcm(spec, per_pin);
+		}
 	}
+
 	/* if pcm_idx == -1, it means this is in monitor connection event
 	 * we can get the correct pcm_idx now.
 	 */
@@ -2281,8 +2285,8 @@ static int generic_hdmi_build_pcms(struc
 	struct hdmi_spec *spec = codec->spec;
 	int idx, pcm_num;
 
-	/* limit the PCM devices to the codec converters */
-	pcm_num = spec->num_cvts;
+	/* limit the PCM devices to the codec converters or available PINs */
+	pcm_num = min(spec->num_cvts, spec->num_pins);
 	codec_dbg(codec, "hdmi: pcm_num set to %d\n", pcm_num);
 
 	for (idx = 0; idx < pcm_num; idx++) {
@@ -2379,6 +2383,11 @@ static int generic_hdmi_build_controls(s
 		struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
 		struct hdmi_eld *pin_eld = &per_pin->sink_eld;
 
+		if (spec->static_pcm_mapping) {
+			hdmi_attach_hda_pcm(spec, per_pin);
+			hdmi_pcm_setup_pin(spec, per_pin);
+		}
+
 		pin_eld->eld_valid = false;
 		hdmi_present_sense(per_pin, 0);
 	}
@@ -4419,6 +4428,8 @@ static int patch_atihdmi(struct hda_code
 
 	spec = codec->spec;
 
+	spec->static_pcm_mapping = true;
+
 	spec->ops.pin_get_eld = atihdmi_pin_get_eld;
 	spec->ops.pin_setup_infoframe = atihdmi_pin_setup_infoframe;
 	spec->ops.pin_hbr_setup = atihdmi_pin_hbr_setup;


