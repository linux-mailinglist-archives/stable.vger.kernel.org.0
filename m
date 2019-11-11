Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E96F7CFF
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfKKSv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbfKKSv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:51:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3A2A204EC;
        Mon, 11 Nov 2019 18:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498316;
        bh=bzQqbUGu+CUfzFAe2p826YJsRVCnakkpSzjsJHM7Xdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6z4q2svr2B/4f8habbH5fZsKHftWcvwd6q8mE4Md5A0FjzqXP3a8ifhRrAWt30Bf
         KAArIkoQtk1eibqXyCTA2/0Iea5scS11xYPF1CSrqnbZsSoFwxuZeg6TY2iz5lzSNx
         k8WSgWms8KWIwvbXqCG7DaNCDCPNeVk+m5vZZih0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 085/193] ALSA: usb-audio: Remove superfluous bLength checks
Date:   Mon, 11 Nov 2019 19:27:47 +0100
Message-Id: <20191111181507.426215111@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b8e4f1fdfa422398c2d6c47bfb7d1feb3046d70a upstream.

Now that we got the more comprehensive validation code for USB-audio
descriptors, the check of overflow in each descriptor unit parser
became superfluous.  Drop some of the obvious cases.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/clock.c |   14 +++------
 sound/usb/mixer.c |   84 ------------------------------------------------------
 2 files changed, 6 insertions(+), 92 deletions(-)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -38,39 +38,37 @@ static void *find_uac_clock_desc(struct
 static bool validate_clock_source_v2(void *p, int id)
 {
 	struct uac_clock_source_descriptor *cs = p;
-	return cs->bLength == sizeof(*cs) && cs->bClockID == id;
+	return cs->bClockID == id;
 }
 
 static bool validate_clock_source_v3(void *p, int id)
 {
 	struct uac3_clock_source_descriptor *cs = p;
-	return cs->bLength == sizeof(*cs) && cs->bClockID == id;
+	return cs->bClockID == id;
 }
 
 static bool validate_clock_selector_v2(void *p, int id)
 {
 	struct uac_clock_selector_descriptor *cs = p;
-	return cs->bLength >= sizeof(*cs) && cs->bClockID == id &&
-		cs->bLength == 7 + cs->bNrInPins;
+	return cs->bClockID == id;
 }
 
 static bool validate_clock_selector_v3(void *p, int id)
 {
 	struct uac3_clock_selector_descriptor *cs = p;
-	return cs->bLength >= sizeof(*cs) && cs->bClockID == id &&
-		cs->bLength == 11 + cs->bNrInPins;
+	return cs->bClockID == id;
 }
 
 static bool validate_clock_multiplier_v2(void *p, int id)
 {
 	struct uac_clock_multiplier_descriptor *cs = p;
-	return cs->bLength == sizeof(*cs) && cs->bClockID == id;
+	return cs->bClockID == id;
 }
 
 static bool validate_clock_multiplier_v3(void *p, int id)
 {
 	struct uac3_clock_multiplier_descriptor *cs = p;
-	return cs->bLength == sizeof(*cs) && cs->bClockID == id;
+	return cs->bClockID == id;
 }
 
 #define DEFINE_FIND_HELPER(name, obj, validator, type)		\
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -740,13 +740,6 @@ static int uac_mixer_unit_get_channels(s
 {
 	int mu_channels;
 
-	if (desc->bLength < sizeof(*desc))
-		return -EINVAL;
-	if (!desc->bNrInPins)
-		return -EINVAL;
-	if (desc->bLength < sizeof(*desc) + desc->bNrInPins)
-		return -EINVAL;
-
 	switch (state->mixer->protocol) {
 	case UAC_VERSION_1:
 	case UAC_VERSION_2:
@@ -1781,13 +1774,6 @@ static int parse_clock_source_unit(struc
 	if (state->mixer->protocol != UAC_VERSION_2)
 		return -EINVAL;
 
-	if (hdr->bLength != sizeof(*hdr)) {
-		usb_audio_dbg(state->chip,
-			      "Bogus clock source descriptor length of %d, ignoring.\n",
-			      hdr->bLength);
-		return 0;
-	}
-
 	/*
 	 * The only property of this unit we are interested in is the
 	 * clock source validity. If that isn't readable, just bail out.
@@ -1846,62 +1832,20 @@ static int parse_audio_feature_unit(stru
 	__u8 *bmaControls;
 
 	if (state->mixer->protocol == UAC_VERSION_1) {
-		if (hdr->bLength < 7) {
-			usb_audio_err(state->chip,
-				      "unit %u: invalid UAC_FEATURE_UNIT descriptor\n",
-				      unitid);
-			return -EINVAL;
-		}
 		csize = hdr->bControlSize;
-		if (!csize) {
-			usb_audio_dbg(state->chip,
-				      "unit %u: invalid bControlSize == 0\n",
-				      unitid);
-			return -EINVAL;
-		}
 		channels = (hdr->bLength - 7) / csize - 1;
 		bmaControls = hdr->bmaControls;
-		if (hdr->bLength < 7 + csize) {
-			usb_audio_err(state->chip,
-				      "unit %u: invalid UAC_FEATURE_UNIT descriptor\n",
-				      unitid);
-			return -EINVAL;
-		}
 	} else if (state->mixer->protocol == UAC_VERSION_2) {
 		struct uac2_feature_unit_descriptor *ftr = _ftr;
-		if (hdr->bLength < 6) {
-			usb_audio_err(state->chip,
-				      "unit %u: invalid UAC_FEATURE_UNIT descriptor\n",
-				      unitid);
-			return -EINVAL;
-		}
 		csize = 4;
 		channels = (hdr->bLength - 6) / 4 - 1;
 		bmaControls = ftr->bmaControls;
-		if (hdr->bLength < 6 + csize) {
-			usb_audio_err(state->chip,
-				      "unit %u: invalid UAC_FEATURE_UNIT descriptor\n",
-				      unitid);
-			return -EINVAL;
-		}
 	} else { /* UAC_VERSION_3 */
 		struct uac3_feature_unit_descriptor *ftr = _ftr;
 
-		if (hdr->bLength < 7) {
-			usb_audio_err(state->chip,
-				      "unit %u: invalid UAC3_FEATURE_UNIT descriptor\n",
-				      unitid);
-			return -EINVAL;
-		}
 		csize = 4;
 		channels = (ftr->bLength - 7) / 4 - 1;
 		bmaControls = ftr->bmaControls;
-		if (hdr->bLength < 7 + csize) {
-			usb_audio_err(state->chip,
-				      "unit %u: invalid UAC3_FEATURE_UNIT descriptor\n",
-				      unitid);
-			return -EINVAL;
-		}
 	}
 
 	/* parse the source unit */
@@ -2101,15 +2045,11 @@ static int parse_audio_input_terminal(st
 
 	if (state->mixer->protocol == UAC_VERSION_2) {
 		struct uac2_input_terminal_descriptor *d_v2 = raw_desc;
-		if (d_v2->bLength < sizeof(*d_v2))
-			return -EINVAL;
 		control = UAC2_TE_CONNECTOR;
 		term_id = d_v2->bTerminalID;
 		bmctls = le16_to_cpu(d_v2->bmControls);
 	} else if (state->mixer->protocol == UAC_VERSION_3) {
 		struct uac3_input_terminal_descriptor *d_v3 = raw_desc;
-		if (d_v3->bLength < sizeof(*d_v3))
-			return -EINVAL;
 		control = UAC3_TE_INSERTION;
 		term_id = d_v3->bTerminalID;
 		bmctls = le32_to_cpu(d_v3->bmControls);
@@ -2371,18 +2311,7 @@ static int build_audio_procunit(struct m
 	const char *name = extension_unit ?
 		"Extension Unit" : "Processing Unit";
 
-	if (desc->bLength < 13) {
-		usb_audio_err(state->chip, "invalid %s descriptor (id %d)\n", name, unitid);
-		return -EINVAL;
-	}
-
 	num_ins = desc->bNrInPins;
-	if (desc->bLength < 13 + num_ins ||
-	    desc->bLength < num_ins + uac_processing_unit_bControlSize(desc, state->mixer->protocol)) {
-		usb_audio_err(state->chip, "invalid %s descriptor (id %d)\n", name, unitid);
-		return -EINVAL;
-	}
-
 	for (i = 0; i < num_ins; i++) {
 		err = parse_audio_unit(state, desc->baSourceID[i]);
 		if (err < 0)
@@ -2637,13 +2566,6 @@ static int parse_audio_selector_unit(str
 	const struct usbmix_name_map *map;
 	char **namelist;
 
-	if (desc->bLength < 5 || !desc->bNrInPins ||
-	    desc->bLength < 5 + desc->bNrInPins) {
-		usb_audio_err(state->chip,
-			"invalid SELECTOR UNIT descriptor %d\n", unitid);
-		return -EINVAL;
-	}
-
 	for (i = 0; i < desc->bNrInPins; i++) {
 		err = parse_audio_unit(state, desc->baSourceID[i]);
 		if (err < 0)
@@ -3149,8 +3071,6 @@ static int snd_usb_mixer_controls(struct
 		if (mixer->protocol == UAC_VERSION_1) {
 			struct uac1_output_terminal_descriptor *desc = p;
 
-			if (desc->bLength < sizeof(*desc))
-				continue; /* invalid descriptor? */
 			/* mark terminal ID as visited */
 			set_bit(desc->bTerminalID, state.unitbitmap);
 			state.oterm.id = desc->bTerminalID;
@@ -3162,8 +3082,6 @@ static int snd_usb_mixer_controls(struct
 		} else if (mixer->protocol == UAC_VERSION_2) {
 			struct uac2_output_terminal_descriptor *desc = p;
 
-			if (desc->bLength < sizeof(*desc))
-				continue; /* invalid descriptor? */
 			/* mark terminal ID as visited */
 			set_bit(desc->bTerminalID, state.unitbitmap);
 			state.oterm.id = desc->bTerminalID;
@@ -3189,8 +3107,6 @@ static int snd_usb_mixer_controls(struct
 		} else {  /* UAC_VERSION_3 */
 			struct uac3_output_terminal_descriptor *desc = p;
 
-			if (desc->bLength < sizeof(*desc))
-				continue; /* invalid descriptor? */
 			/* mark terminal ID as visited */
 			set_bit(desc->bTerminalID, state.unitbitmap);
 			state.oterm.id = desc->bTerminalID;


