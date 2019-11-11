Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EF0F7D01
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfKKSwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:52:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbfKKSwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:52:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B80204EC;
        Mon, 11 Nov 2019 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498320;
        bh=6hGA38c7/YNQMCU7HCMiUt64iZzrTIF/x5N97/VWHSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0Oz2jn2bi7YTZEk6Eky9JwsBmdE4SuSwsPDAbrqvYaxk6UwVlKrizEoph6nGyutX
         K0L/Xy6/qQSNimD71Vt/VIckfWaF49L02rV2vNBQNvqiqoDmCylNK2E9N2CWq3I7wI
         nkhYOazZAzv6av/DFEjMnBNJlUrZYPJMPAcBJTWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 086/193] ALSA: usb-audio: Clean up check_input_term()
Date:   Mon, 11 Nov 2019 19:27:48 +0100
Message-Id: <20191111181507.495683346@linuxfoundation.org>
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

commit e0ccdef92653f8867e2d1667facfd3c23699f540 upstream.

The primary changes in this patch are cleanups of __check_input_term()
and move to a non-nested switch-case block by evaluating the pair of
UAC version and the unit type, as we've done for parse_audio_unit().
Also each parser is split into the function for readability.

Now, a slight behavior change by this cleanup is the handling of
processing and extension units.  Formerly we've dealt with them
differently between UAC1/2 and UAC3; the latter returns an error if no
input sources are available, while the former continues to parse.

In this patch, unify the behavior in all cases: when input sources are
available, it parses recursively, then override the type and the id,
as well as channel information if not provided yet.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |  407 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 212 insertions(+), 195 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -758,224 +758,242 @@ static int uac_mixer_unit_get_channels(s
 }
 
 /*
- * parse the source unit recursively until it reaches to a terminal
- * or a branched unit.
+ * Parse Input Terminal Unit
  */
 static int __check_input_term(struct mixer_build *state, int id,
-			    struct usb_audio_term *term)
+			      struct usb_audio_term *term);
+
+static int parse_term_uac1_iterm_unit(struct mixer_build *state,
+				      struct usb_audio_term *term,
+				      void *p1, int id)
+{
+	struct uac_input_terminal_descriptor *d = p1;
+
+	term->type = le16_to_cpu(d->wTerminalType);
+	term->channels = d->bNrChannels;
+	term->chconfig = le16_to_cpu(d->wChannelConfig);
+	term->name = d->iTerminal;
+	return 0;
+}
+
+static int parse_term_uac2_iterm_unit(struct mixer_build *state,
+				      struct usb_audio_term *term,
+				      void *p1, int id)
 {
-	int protocol = state->mixer->protocol;
+	struct uac2_input_terminal_descriptor *d = p1;
 	int err;
-	void *p1;
-	unsigned char *hdr;
 
-	memset(term, 0, sizeof(*term));
-	for (;;) {
-		/* a loop in the terminal chain? */
-		if (test_and_set_bit(id, state->termbitmap))
-			return -EINVAL;
+	/* call recursively to verify the referenced clock entity */
+	err = __check_input_term(state, d->bCSourceID, term);
+	if (err < 0)
+		return err;
 
-		p1 = find_audio_control_unit(state, id);
-		if (!p1)
-			break;
-		if (!snd_usb_validate_audio_desc(p1, protocol))
-			break; /* bad descriptor */
+	/* save input term properties after recursion,
+	 * to ensure they are not overriden by the recursion calls
+	 */
+	term->id = id;
+	term->type = le16_to_cpu(d->wTerminalType);
+	term->channels = d->bNrChannels;
+	term->chconfig = le32_to_cpu(d->bmChannelConfig);
+	term->name = d->iTerminal;
+	return 0;
+}
 
-		hdr = p1;
-		term->id = id;
+static int parse_term_uac3_iterm_unit(struct mixer_build *state,
+				      struct usb_audio_term *term,
+				      void *p1, int id)
+{
+	struct uac3_input_terminal_descriptor *d = p1;
+	int err;
 
-		if (protocol == UAC_VERSION_1 || protocol == UAC_VERSION_2) {
-			switch (hdr[2]) {
-			case UAC_INPUT_TERMINAL:
-				if (protocol == UAC_VERSION_1) {
-					struct uac_input_terminal_descriptor *d = p1;
-
-					term->type = le16_to_cpu(d->wTerminalType);
-					term->channels = d->bNrChannels;
-					term->chconfig = le16_to_cpu(d->wChannelConfig);
-					term->name = d->iTerminal;
-				} else { /* UAC_VERSION_2 */
-					struct uac2_input_terminal_descriptor *d = p1;
-
-					/* call recursively to verify that the
-					 * referenced clock entity is valid */
-					err = __check_input_term(state, d->bCSourceID, term);
-					if (err < 0)
-						return err;
-
-					/* save input term properties after recursion,
-					 * to ensure they are not overriden by the
-					 * recursion calls */
-					term->id = id;
-					term->type = le16_to_cpu(d->wTerminalType);
-					term->channels = d->bNrChannels;
-					term->chconfig = le32_to_cpu(d->bmChannelConfig);
-					term->name = d->iTerminal;
-				}
-				return 0;
-			case UAC_FEATURE_UNIT: {
-				/* the header is the same for v1 and v2 */
-				struct uac_feature_unit_descriptor *d = p1;
+	/* call recursively to verify the referenced clock entity */
+	err = __check_input_term(state, d->bCSourceID, term);
+	if (err < 0)
+		return err;
 
-				id = d->bSourceID;
-				break; /* continue to parse */
-			}
-			case UAC_MIXER_UNIT: {
-				struct uac_mixer_unit_descriptor *d = p1;
+	/* save input term properties after recursion,
+	 * to ensure they are not overriden by the recursion calls
+	 */
+	term->id = id;
+	term->type = le16_to_cpu(d->wTerminalType);
 
-				term->type = UAC3_MIXER_UNIT << 16; /* virtual type */
-				term->channels = uac_mixer_unit_bNrChannels(d);
-				term->chconfig = uac_mixer_unit_wChannelConfig(d, protocol);
-				term->name = uac_mixer_unit_iMixer(d);
-				return 0;
-			}
-			case UAC_SELECTOR_UNIT:
-			case UAC2_CLOCK_SELECTOR: {
-				struct uac_selector_unit_descriptor *d = p1;
-				/* call recursively to retrieve the channel info */
-				err = __check_input_term(state, d->baSourceID[0], term);
-				if (err < 0)
-					return err;
-				term->type = UAC3_SELECTOR_UNIT << 16; /* virtual type */
-				term->id = id;
-				term->name = uac_selector_unit_iSelector(d);
-				return 0;
-			}
-			case UAC1_PROCESSING_UNIT:
-			/* UAC2_EFFECT_UNIT */
-				if (protocol == UAC_VERSION_1)
-					term->type = UAC3_PROCESSING_UNIT << 16; /* virtual type */
-				else /* UAC_VERSION_2 */
-					term->type = UAC3_EFFECT_UNIT << 16; /* virtual type */
-				/* fall through */
-			case UAC1_EXTENSION_UNIT:
-			/* UAC2_PROCESSING_UNIT_V2 */
-				if (protocol == UAC_VERSION_1 && !term->type)
-					term->type = UAC3_EXTENSION_UNIT << 16; /* virtual type */
-				else if (protocol == UAC_VERSION_2 && !term->type)
-					term->type = UAC3_PROCESSING_UNIT << 16; /* virtual type */
-				/* fall through */
-			case UAC2_EXTENSION_UNIT_V2: {
-				struct uac_processing_unit_descriptor *d = p1;
-
-				if (protocol == UAC_VERSION_2 &&
-					hdr[2] == UAC2_EFFECT_UNIT) {
-					/* UAC2/UAC1 unit IDs overlap here in an
-					 * uncompatible way. Ignore this unit for now.
-					 */
-					return 0;
-				}
+	err = get_cluster_channels_v3(state, le16_to_cpu(d->wClusterDescrID));
+	if (err < 0)
+		return err;
+	term->channels = err;
 
-				if (d->bNrInPins) {
-					id = d->baSourceID[0];
-					break; /* continue to parse */
-				}
-				if (!term->type)
-					term->type = UAC3_EXTENSION_UNIT << 16; /* virtual type */
+	/* REVISIT: UAC3 IT doesn't have channels cfg */
+	term->chconfig = 0;
 
-				term->channels = uac_processing_unit_bNrChannels(d);
-				term->chconfig = uac_processing_unit_wChannelConfig(d, protocol);
-				term->name = uac_processing_unit_iProcessing(d, protocol);
-				return 0;
-			}
-			case UAC2_CLOCK_SOURCE: {
-				struct uac_clock_source_descriptor *d = p1;
+	term->name = le16_to_cpu(d->wTerminalDescrStr);
+	return 0;
+}
 
-				term->type = UAC3_CLOCK_SOURCE << 16; /* virtual type */
-				term->id = id;
-				term->name = d->iClockSource;
-				return 0;
-			}
-			default:
-				return -ENODEV;
-			}
-		} else { /* UAC_VERSION_3 */
-			switch (hdr[2]) {
-			case UAC_INPUT_TERMINAL: {
-				struct uac3_input_terminal_descriptor *d = p1;
-
-				/* call recursively to verify that the
-				 * referenced clock entity is valid */
-				err = __check_input_term(state, d->bCSourceID, term);
-				if (err < 0)
-					return err;
-
-				/* save input term properties after recursion,
-				 * to ensure they are not overriden by the
-				 * recursion calls */
-				term->id = id;
-				term->type = le16_to_cpu(d->wTerminalType);
-
-				err = get_cluster_channels_v3(state, le16_to_cpu(d->wClusterDescrID));
-				if (err < 0)
-					return err;
-				term->channels = err;
+static int parse_term_mixer_unit(struct mixer_build *state,
+				 struct usb_audio_term *term,
+				 void *p1, int id)
+{
+	struct uac_mixer_unit_descriptor *d = p1;
+	int protocol = state->mixer->protocol;
+	int err;
 
-				/* REVISIT: UAC3 IT doesn't have channels cfg */
-				term->chconfig = 0;
+	err = uac_mixer_unit_get_channels(state, d);
+	if (err <= 0)
+		return err;
 
-				term->name = le16_to_cpu(d->wTerminalDescrStr);
-				return 0;
-			}
-			case UAC3_FEATURE_UNIT: {
-				struct uac3_feature_unit_descriptor *d = p1;
+	term->type = UAC3_MIXER_UNIT << 16; /* virtual type */
+	term->channels = err;
+	if (protocol != UAC_VERSION_3) {
+		term->chconfig = uac_mixer_unit_wChannelConfig(d, protocol);
+		term->name = uac_mixer_unit_iMixer(d);
+	}
+	return 0;
+}
 
-				id = d->bSourceID;
-				break; /* continue to parse */
-			}
-			case UAC3_CLOCK_SOURCE: {
-				struct uac3_clock_source_descriptor *d = p1;
+static int parse_term_selector_unit(struct mixer_build *state,
+				    struct usb_audio_term *term,
+				    void *p1, int id)
+{
+	struct uac_selector_unit_descriptor *d = p1;
+	int err;
 
-				term->type = UAC3_CLOCK_SOURCE << 16; /* virtual type */
-				term->id = id;
-				term->name = le16_to_cpu(d->wClockSourceStr);
-				return 0;
-			}
-			case UAC3_MIXER_UNIT: {
-				struct uac_mixer_unit_descriptor *d = p1;
+	/* call recursively to retrieve the channel info */
+	err = __check_input_term(state, d->baSourceID[0], term);
+	if (err < 0)
+		return err;
+	term->type = UAC3_SELECTOR_UNIT << 16; /* virtual type */
+	term->id = id;
+	if (state->mixer->protocol != UAC_VERSION_3)
+		term->name = uac_selector_unit_iSelector(d);
+	return 0;
+}
 
-				err = uac_mixer_unit_get_channels(state, d);
-				if (err <= 0)
-					return err;
+static int parse_term_proc_unit(struct mixer_build *state,
+				struct usb_audio_term *term,
+				void *p1, int id, int vtype)
+{
+	struct uac_processing_unit_descriptor *d = p1;
+	int protocol = state->mixer->protocol;
+	int err;
 
-				term->channels = err;
-				term->type = UAC3_MIXER_UNIT << 16; /* virtual type */
+	if (d->bNrInPins) {
+		/* call recursively to retrieve the channel info */
+		err = __check_input_term(state, d->baSourceID[0], term);
+		if (err < 0)
+			return err;
+	}
 
-				return 0;
-			}
-			case UAC3_SELECTOR_UNIT:
-			case UAC3_CLOCK_SELECTOR: {
-				struct uac_selector_unit_descriptor *d = p1;
-				/* call recursively to retrieve the channel info */
-				err = __check_input_term(state, d->baSourceID[0], term);
-				if (err < 0)
-					return err;
-				term->type = UAC3_SELECTOR_UNIT << 16; /* virtual type */
-				term->id = id;
-				term->name = 0; /* TODO: UAC3 Class-specific strings */
+	term->type = vtype << 16; /* virtual type */
+	term->id = id;
 
-				return 0;
-			}
-			case UAC3_PROCESSING_UNIT: {
-				struct uac_processing_unit_descriptor *d = p1;
+	if (protocol == UAC_VERSION_3)
+		return 0;
 
-				if (!d->bNrInPins)
-					return -EINVAL;
+	if (!term->channels) {
+		term->channels = uac_processing_unit_bNrChannels(d);
+		term->chconfig = uac_processing_unit_wChannelConfig(d, protocol);
+	}
+	term->name = uac_processing_unit_iProcessing(d, protocol);
+	return 0;
+}
+
+static int parse_term_uac2_clock_source(struct mixer_build *state,
+					struct usb_audio_term *term,
+					void *p1, int id)
+{
+	struct uac_clock_source_descriptor *d = p1;
+
+	term->type = UAC3_CLOCK_SOURCE << 16; /* virtual type */
+	term->id = id;
+	term->name = d->iClockSource;
+	return 0;
+}
 
-				/* call recursively to retrieve the channel info */
-				err = __check_input_term(state, d->baSourceID[0], term);
-				if (err < 0)
-					return err;
-
-				term->type = UAC3_PROCESSING_UNIT << 16; /* virtual type */
-				term->id = id;
-				term->name = 0; /* TODO: UAC3 Class-specific strings */
+static int parse_term_uac3_clock_source(struct mixer_build *state,
+					struct usb_audio_term *term,
+					void *p1, int id)
+{
+	struct uac3_clock_source_descriptor *d = p1;
+
+	term->type = UAC3_CLOCK_SOURCE << 16; /* virtual type */
+	term->id = id;
+	term->name = le16_to_cpu(d->wClockSourceStr);
+	return 0;
+}
 
-				return 0;
-			}
-			default:
-				return -ENODEV;
-			}
+#define PTYPE(a, b)	((a) << 8 | (b))
+
+/*
+ * parse the source unit recursively until it reaches to a terminal
+ * or a branched unit.
+ */
+static int __check_input_term(struct mixer_build *state, int id,
+			      struct usb_audio_term *term)
+{
+	int protocol = state->mixer->protocol;
+	void *p1;
+	unsigned char *hdr;
+
+	for (;;) {
+		/* a loop in the terminal chain? */
+		if (test_and_set_bit(id, state->termbitmap))
+			return -EINVAL;
+
+		p1 = find_audio_control_unit(state, id);
+		if (!p1)
+			break;
+		if (!snd_usb_validate_audio_desc(p1, protocol))
+			break; /* bad descriptor */
+
+		hdr = p1;
+		term->id = id;
+
+		switch (PTYPE(protocol, hdr[2])) {
+		case PTYPE(UAC_VERSION_1, UAC_FEATURE_UNIT):
+		case PTYPE(UAC_VERSION_2, UAC_FEATURE_UNIT):
+		case PTYPE(UAC_VERSION_3, UAC3_FEATURE_UNIT): {
+			/* the header is the same for all versions */
+			struct uac_feature_unit_descriptor *d = p1;
+
+			id = d->bSourceID;
+			break; /* continue to parse */
+		}
+		case PTYPE(UAC_VERSION_1, UAC_INPUT_TERMINAL):
+			return parse_term_uac1_iterm_unit(state, term, p1, id);
+		case PTYPE(UAC_VERSION_2, UAC_INPUT_TERMINAL):
+			return parse_term_uac2_iterm_unit(state, term, p1, id);
+		case PTYPE(UAC_VERSION_3, UAC_INPUT_TERMINAL):
+			return parse_term_uac3_iterm_unit(state, term, p1, id);
+		case PTYPE(UAC_VERSION_1, UAC_MIXER_UNIT):
+		case PTYPE(UAC_VERSION_2, UAC_MIXER_UNIT):
+		case PTYPE(UAC_VERSION_3, UAC3_MIXER_UNIT):
+			return parse_term_mixer_unit(state, term, p1, id);
+		case PTYPE(UAC_VERSION_1, UAC_SELECTOR_UNIT):
+		case PTYPE(UAC_VERSION_2, UAC_SELECTOR_UNIT):
+		case PTYPE(UAC_VERSION_2, UAC2_CLOCK_SELECTOR):
+		case PTYPE(UAC_VERSION_3, UAC3_SELECTOR_UNIT):
+		case PTYPE(UAC_VERSION_3, UAC3_CLOCK_SELECTOR):
+			return parse_term_selector_unit(state, term, p1, id);
+		case PTYPE(UAC_VERSION_1, UAC1_PROCESSING_UNIT):
+		case PTYPE(UAC_VERSION_2, UAC2_PROCESSING_UNIT_V2):
+		case PTYPE(UAC_VERSION_3, UAC3_PROCESSING_UNIT):
+			return parse_term_proc_unit(state, term, p1, id,
+						    UAC3_PROCESSING_UNIT);
+		case PTYPE(UAC_VERSION_2, UAC2_EFFECT_UNIT):
+		case PTYPE(UAC_VERSION_3, UAC3_EFFECT_UNIT):
+			return parse_term_proc_unit(state, term, p1, id,
+						    UAC3_EFFECT_UNIT);
+		case PTYPE(UAC_VERSION_1, UAC1_EXTENSION_UNIT):
+		case PTYPE(UAC_VERSION_2, UAC2_EXTENSION_UNIT_V2):
+		case PTYPE(UAC_VERSION_3, UAC3_EXTENSION_UNIT):
+			return parse_term_proc_unit(state, term, p1, id,
+						    UAC3_EXTENSION_UNIT);
+		case PTYPE(UAC_VERSION_2, UAC2_CLOCK_SOURCE):
+			return parse_term_uac2_clock_source(state, term, p1, id);
+		case PTYPE(UAC_VERSION_3, UAC3_CLOCK_SOURCE):
+			return parse_term_uac3_clock_source(state, term, p1, id);
+		default:
+			return -ENODEV;
 		}
 	}
 	return -ENODEV;
@@ -2712,7 +2730,6 @@ static int parse_audio_unit(struct mixer
 		return 0; /* skip invalid unit */
 	}
 
-#define PTYPE(a, b)	((a) << 8 | (b))
 	switch (PTYPE(protocol, p1[2])) {
 	case PTYPE(UAC_VERSION_1, UAC_INPUT_TERMINAL):
 	case PTYPE(UAC_VERSION_2, UAC_INPUT_TERMINAL):


