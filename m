Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A9FF7E18
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbfKKTBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:01:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730016AbfKKSvn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:51:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 844DB204FD;
        Mon, 11 Nov 2019 18:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498302;
        bh=nM7RnI1Z5B37uWPgxQCYD8WHOZu8Y0IwH5A3Zre6NCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnAw4ul2fRSkDh1Oxq5AOfNmEdQISiozr0MuxCG43Mr5NNmjiaJu3fS6DmuF3zjmM
         fpRE0ilpv9KrEmWWxiuCUXE/zwtukaIaj3l8f1XJ69qoAXtRRqOFxuIN0VlfSCRk1F
         YrdDfvxn+TAoYAWD0swho8QkDh/tlcw0T2btYWg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 082/193] ALSA: usb-audio: More validations of descriptor units
Date:   Mon, 11 Nov 2019 19:27:44 +0100
Message-Id: <20191111181507.204965938@linuxfoundation.org>
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

commit 57f8770620e9b51c61089751f0b5ad3dbe376ff2 upstream.

Introduce a new helper to validate each audio descriptor unit before
and check the unit before actually accessing it.  This should harden
against the OOB access cases with malformed descriptors that have been
recently frequently reported by fuzzers.

The existing descriptor checks are still kept although they become
superfluous after this patch.  They'll be cleaned up eventually
later.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/Makefile   |    3 
 sound/usb/helper.h   |    4 
 sound/usb/mixer.c    |   10 +
 sound/usb/power.c    |    2 
 sound/usb/quirks.c   |    3 
 sound/usb/stream.c   |   25 +--
 sound/usb/validate.c |  332 +++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 366 insertions(+), 13 deletions(-)

--- a/sound/usb/Makefile
+++ b/sound/usb/Makefile
@@ -16,7 +16,8 @@ snd-usb-audio-objs := 	card.o \
 			power.o \
 			proc.o \
 			quirks.o \
-			stream.o
+			stream.o \
+			validate.o
 
 snd-usb-audio-$(CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER) += media.o
 
--- a/sound/usb/helper.h
+++ b/sound/usb/helper.h
@@ -31,4 +31,8 @@ static inline int snd_usb_ctrl_intf(stru
 	return get_iface_desc(chip->ctrl_intf)->bInterfaceNumber;
 }
 
+/* in validate.c */
+bool snd_usb_validate_audio_desc(void *p, int protocol);
+bool snd_usb_validate_midi_desc(void *p);
+
 #endif /* __USBAUDIO_HELPER_H */
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -785,6 +785,8 @@ static int __check_input_term(struct mix
 		p1 = find_audio_control_unit(state, id);
 		if (!p1)
 			break;
+		if (!snd_usb_validate_audio_desc(p1, protocol))
+			break; /* bad descriptor */
 
 		hdr = p1;
 		term->id = id;
@@ -2775,6 +2777,11 @@ static int parse_audio_unit(struct mixer
 		return -EINVAL;
 	}
 
+	if (!snd_usb_validate_audio_desc(p1, protocol)) {
+		usb_audio_dbg(state->chip, "invalid unit %d\n", unitid);
+		return 0; /* skip invalid unit */
+	}
+
 	if (protocol == UAC_VERSION_1 || protocol == UAC_VERSION_2) {
 		switch (p1[2]) {
 		case UAC_INPUT_TERMINAL:
@@ -3145,6 +3152,9 @@ static int snd_usb_mixer_controls(struct
 	while ((p = snd_usb_find_csint_desc(mixer->hostif->extra,
 					    mixer->hostif->extralen,
 					    p, UAC_OUTPUT_TERMINAL)) != NULL) {
+		if (!snd_usb_validate_audio_desc(p, mixer->protocol))
+			continue; /* skip invalid descriptor */
+
 		if (mixer->protocol == UAC_VERSION_1) {
 			struct uac1_output_terminal_descriptor *desc = p;
 
--- a/sound/usb/power.c
+++ b/sound/usb/power.c
@@ -31,6 +31,8 @@ snd_usb_find_power_domain(struct usb_hos
 		struct uac3_power_domain_descriptor *pd_desc = p;
 		int i;
 
+		if (!snd_usb_validate_audio_desc(p, UAC_VERSION_3))
+			continue;
 		for (i = 0; i < pd_desc->bNrEntities; i++) {
 			if (pd_desc->baEntityID[i] == id) {
 				pd->pd_id = pd_desc->bPowerDomainID;
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -248,6 +248,9 @@ static int create_yamaha_midi_quirk(stru
 					NULL, USB_MS_MIDI_OUT_JACK);
 	if (!injd && !outjd)
 		return -ENODEV;
+	if (!snd_usb_validate_midi_desc(injd) ||
+	    !snd_usb_validate_midi_desc(outjd))
+		return -ENODEV;
 	if (injd && (injd->bLength < 5 ||
 		     (injd->bJackType != USB_MS_EMBEDDED &&
 		      injd->bJackType != USB_MS_EXTERNAL)))
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -627,16 +627,14 @@ static int parse_uac_endpoint_attributes
  */
 static void *
 snd_usb_find_input_terminal_descriptor(struct usb_host_interface *ctrl_iface,
-				       int terminal_id, bool uac23)
+				       int terminal_id, int protocol)
 {
 	struct uac2_input_terminal_descriptor *term = NULL;
-	size_t minlen = uac23 ? sizeof(struct uac2_input_terminal_descriptor) :
-		sizeof(struct uac_input_terminal_descriptor);
 
 	while ((term = snd_usb_find_csint_desc(ctrl_iface->extra,
 					       ctrl_iface->extralen,
 					       term, UAC_INPUT_TERMINAL))) {
-		if (term->bLength < minlen)
+		if (!snd_usb_validate_audio_desc(term, protocol))
 			continue;
 		if (term->bTerminalID == terminal_id)
 			return term;
@@ -647,7 +645,7 @@ snd_usb_find_input_terminal_descriptor(s
 
 static void *
 snd_usb_find_output_terminal_descriptor(struct usb_host_interface *ctrl_iface,
-					int terminal_id)
+					int terminal_id, int protocol)
 {
 	/* OK to use with both UAC2 and UAC3 */
 	struct uac2_output_terminal_descriptor *term = NULL;
@@ -655,8 +653,9 @@ snd_usb_find_output_terminal_descriptor(
 	while ((term = snd_usb_find_csint_desc(ctrl_iface->extra,
 					       ctrl_iface->extralen,
 					       term, UAC_OUTPUT_TERMINAL))) {
-		if (term->bLength >= sizeof(*term) &&
-		    term->bTerminalID == terminal_id)
+		if (!snd_usb_validate_audio_desc(term, protocol))
+			continue;
+		if (term->bTerminalID == terminal_id)
 			return term;
 	}
 
@@ -731,7 +730,7 @@ snd_usb_get_audioformat_uac12(struct snd
 
 		iterm = snd_usb_find_input_terminal_descriptor(chip->ctrl_intf,
 							       as->bTerminalLink,
-							       false);
+							       protocol);
 		if (iterm) {
 			num_channels = iterm->bNrChannels;
 			chconfig = le16_to_cpu(iterm->wChannelConfig);
@@ -767,7 +766,7 @@ snd_usb_get_audioformat_uac12(struct snd
 		 */
 		input_term = snd_usb_find_input_terminal_descriptor(chip->ctrl_intf,
 								    as->bTerminalLink,
-								    true);
+								    protocol);
 		if (input_term) {
 			clock = input_term->bCSourceID;
 			if (!chconfig && (num_channels == input_term->bNrChannels))
@@ -776,7 +775,8 @@ snd_usb_get_audioformat_uac12(struct snd
 		}
 
 		output_term = snd_usb_find_output_terminal_descriptor(chip->ctrl_intf,
-								      as->bTerminalLink);
+								      as->bTerminalLink,
+								      protocol);
 		if (output_term) {
 			clock = output_term->bCSourceID;
 			goto found_clock;
@@ -1002,14 +1002,15 @@ snd_usb_get_audioformat_uac3(struct snd_
 	 */
 	input_term = snd_usb_find_input_terminal_descriptor(chip->ctrl_intf,
 							    as->bTerminalLink,
-							    true);
+							    UAC_VERSION_3);
 	if (input_term) {
 		clock = input_term->bCSourceID;
 		goto found_clock;
 	}
 
 	output_term = snd_usb_find_output_terminal_descriptor(chip->ctrl_intf,
-							     as->bTerminalLink);
+							      as->bTerminalLink,
+							      UAC_VERSION_3);
 	if (output_term) {
 		clock = output_term->bCSourceID;
 		goto found_clock;
--- /dev/null
+++ b/sound/usb/validate.c
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+//
+// Validation of USB-audio class descriptors
+//
+
+#include <linux/init.h>
+#include <linux/usb.h>
+#include <linux/usb/audio.h>
+#include <linux/usb/audio-v2.h>
+#include <linux/usb/audio-v3.h>
+#include <linux/usb/midi.h>
+#include "usbaudio.h"
+#include "helper.h"
+
+struct usb_desc_validator {
+	unsigned char protocol;
+	unsigned char type;
+	bool (*func)(const void *p, const struct usb_desc_validator *v);
+	size_t size;
+};
+
+#define UAC_VERSION_ALL		(unsigned char)(-1)
+
+/* UAC1 only */
+static bool validate_uac1_header(const void *p,
+				 const struct usb_desc_validator *v)
+{
+	const struct uac1_ac_header_descriptor *d = p;
+
+	return d->bLength >= sizeof(*d) &&
+		d->bLength >= sizeof(*d) + d->bInCollection;
+}
+
+/* for mixer unit; covering all UACs */
+static bool validate_mixer_unit(const void *p,
+				const struct usb_desc_validator *v)
+{
+	const struct uac_mixer_unit_descriptor *d = p;
+	size_t len;
+
+	if (d->bLength < sizeof(*d) || !d->bNrInPins)
+		return false;
+	len = sizeof(*d) + d->bNrInPins;
+	/* We can't determine the bitmap size only from this unit descriptor,
+	 * so just check with the remaining length.
+	 * The actual bitmap is checked at mixer unit parser.
+	 */
+	switch (v->protocol) {
+	case UAC_VERSION_1:
+	default:
+		len += 2 + 1; /* wChannelConfig, iChannelNames */
+		/* bmControls[n*m] */
+		len += 1; /* iMixer */
+		break;
+	case UAC_VERSION_2:
+		len += 4 + 1; /* bmChannelConfig, iChannelNames */
+		/* bmMixerControls[n*m] */
+		len += 1 + 1; /* bmControls, iMixer */
+		break;
+	case UAC_VERSION_3:
+		len += 2; /* wClusterDescrID */
+		/* bmMixerControls[n*m] */
+		break;
+	}
+	return d->bLength >= len;
+}
+
+/* both for processing and extension units; covering all UACs */
+static bool validate_processing_unit(const void *p,
+				     const struct usb_desc_validator *v)
+{
+	const struct uac_processing_unit_descriptor *d = p;
+	const unsigned char *hdr = p;
+	size_t len, m;
+
+	if (d->bLength < sizeof(*d))
+		return false;
+	len = d->bLength < sizeof(*d) + d->bNrInPins;
+	if (d->bLength < len)
+		return false;
+	switch (v->protocol) {
+	case UAC_VERSION_1:
+	default:
+		/* bNrChannels, wChannelConfig, iChannelNames, bControlSize */
+		len += 1 + 2 + 1 + 1;
+		if (d->bLength < len) /* bControlSize */
+			return false;
+		m = hdr[len];
+		len += 1 + m + 1; /* bControlSize, bmControls, iProcessing */
+		break;
+	case UAC_VERSION_2:
+		/* bNrChannels, bmChannelConfig, iChannelNames */
+		len += 1 + 4 + 1;
+		if (v->type == UAC2_PROCESSING_UNIT_V2)
+			len += 2; /* bmControls -- 2 bytes for PU */
+		else
+			len += 1; /* bmControls -- 1 byte for EU */
+		len += 1; /* iProcessing */
+		break;
+	case UAC_VERSION_3:
+		/* wProcessingDescrStr, bmControls */
+		len += 2 + 4;
+		break;
+	}
+	if (d->bLength < len)
+		return false;
+
+	switch (v->protocol) {
+	case UAC_VERSION_1:
+	default:
+		if (v->type == UAC1_EXTENSION_UNIT)
+			return true; /* OK */
+		switch (d->wProcessType) {
+		case UAC_PROCESS_UP_DOWNMIX:
+		case UAC_PROCESS_DOLBY_PROLOGIC:
+			if (d->bLength < len + 1) /* bNrModes */
+				return false;
+			m = hdr[len];
+			len += 1 + m * 2; /* bNrModes, waModes(n) */
+			break;
+		default:
+			break;
+		}
+		break;
+	case UAC_VERSION_2:
+		if (v->type == UAC2_EXTENSION_UNIT_V2)
+			return true; /* OK */
+		switch (d->wProcessType) {
+		case UAC2_PROCESS_UP_DOWNMIX:
+		case UAC2_PROCESS_DOLBY_PROLOCIC: /* SiC! */
+			if (d->bLength < len + 1) /* bNrModes */
+				return false;
+			m = hdr[len];
+			len += 1 + m * 4; /* bNrModes, daModes(n) */
+			break;
+		default:
+			break;
+		}
+		break;
+	case UAC_VERSION_3:
+		if (v->type == UAC3_EXTENSION_UNIT) {
+			len += 2; /* wClusterDescrID */
+			break;
+		}
+		switch (d->wProcessType) {
+		case UAC3_PROCESS_UP_DOWNMIX:
+			if (d->bLength < len + 1) /* bNrModes */
+				return false;
+			m = hdr[len];
+			len += 1 + m * 2; /* bNrModes, waClusterDescrID(n) */
+			break;
+		case UAC3_PROCESS_MULTI_FUNCTION:
+			len += 2 + 4; /* wClusterDescrID, bmAlgorighms */
+			break;
+		default:
+			break;
+		}
+		break;
+	}
+	if (d->bLength < len)
+		return false;
+
+	return true;
+}
+
+/* both for selector and clock selector units; covering all UACs */
+static bool validate_selector_unit(const void *p,
+				   const struct usb_desc_validator *v)
+{
+	const struct uac_selector_unit_descriptor *d = p;
+	size_t len;
+
+	if (d->bLength < sizeof(*d))
+		return false;
+	len = sizeof(*d) + d->bNrInPins;
+	switch (v->protocol) {
+	case UAC_VERSION_1:
+	default:
+		len += 1; /* iSelector */
+		break;
+	case UAC_VERSION_2:
+		len += 1 + 1; /* bmControls, iSelector */
+		break;
+	case UAC_VERSION_3:
+		len += 4 + 2; /* bmControls, wSelectorDescrStr */
+		break;
+	}
+	return d->bLength >= len;
+}
+
+static bool validate_uac1_feature_unit(const void *p,
+				       const struct usb_desc_validator *v)
+{
+	const struct uac_feature_unit_descriptor *d = p;
+
+	if (d->bLength < sizeof(*d) || !d->bControlSize)
+		return false;
+	/* at least bmaControls(0) for master channel + iFeature */
+	return d->bLength >= sizeof(*d) + d->bControlSize + 1;
+}
+
+static bool validate_uac2_feature_unit(const void *p,
+				       const struct usb_desc_validator *v)
+{
+	const struct uac2_feature_unit_descriptor *d = p;
+
+	if (d->bLength < sizeof(*d))
+		return false;
+	/* at least bmaControls(0) for master channel + iFeature */
+	return d->bLength >= sizeof(*d) + 4 + 1;
+}
+
+static bool validate_uac3_feature_unit(const void *p,
+				       const struct usb_desc_validator *v)
+{
+	const struct uac3_feature_unit_descriptor *d = p;
+
+	if (d->bLength < sizeof(*d))
+		return false;
+	/* at least bmaControls(0) for master channel + wFeatureDescrStr */
+	return d->bLength >= sizeof(*d) + 4 + 2;
+}
+
+static bool validate_midi_out_jack(const void *p,
+				   const struct usb_desc_validator *v)
+{
+	const struct usb_midi_out_jack_descriptor *d = p;
+
+	return d->bLength >= sizeof(*d) &&
+		d->bLength >= sizeof(*d) + d->bNrInputPins * 2;
+}
+
+#define FIXED(p, t, s) { .protocol = (p), .type = (t), .size = sizeof(s) }
+#define FUNC(p, t, f) { .protocol = (p), .type = (t), .func = (f) }
+
+static struct usb_desc_validator audio_validators[] = {
+	/* UAC1 */
+	FUNC(UAC_VERSION_1, UAC_HEADER, validate_uac1_header),
+	FIXED(UAC_VERSION_1, UAC_INPUT_TERMINAL,
+	      struct uac_input_terminal_descriptor),
+	FIXED(UAC_VERSION_1, UAC_OUTPUT_TERMINAL,
+	      struct uac1_output_terminal_descriptor),
+	FUNC(UAC_VERSION_1, UAC_MIXER_UNIT, validate_mixer_unit),
+	FUNC(UAC_VERSION_1, UAC_SELECTOR_UNIT, validate_selector_unit),
+	FUNC(UAC_VERSION_1, UAC_FEATURE_UNIT, validate_uac1_feature_unit),
+	FUNC(UAC_VERSION_1, UAC1_PROCESSING_UNIT, validate_processing_unit),
+	FUNC(UAC_VERSION_1, UAC1_EXTENSION_UNIT, validate_processing_unit),
+
+	/* UAC2 */
+	FIXED(UAC_VERSION_2, UAC_HEADER, struct uac2_ac_header_descriptor),
+	FIXED(UAC_VERSION_2, UAC_INPUT_TERMINAL,
+	      struct uac2_input_terminal_descriptor),
+	FIXED(UAC_VERSION_2, UAC_OUTPUT_TERMINAL,
+	      struct uac2_output_terminal_descriptor),
+	FUNC(UAC_VERSION_2, UAC_MIXER_UNIT, validate_mixer_unit),
+	FUNC(UAC_VERSION_2, UAC_SELECTOR_UNIT, validate_selector_unit),
+	FUNC(UAC_VERSION_2, UAC_FEATURE_UNIT, validate_uac2_feature_unit),
+	/* UAC_VERSION_2, UAC2_EFFECT_UNIT: not implemented yet */
+	FUNC(UAC_VERSION_2, UAC2_PROCESSING_UNIT_V2, validate_processing_unit),
+	FUNC(UAC_VERSION_2, UAC2_EXTENSION_UNIT_V2, validate_processing_unit),
+	FIXED(UAC_VERSION_2, UAC2_CLOCK_SOURCE,
+	      struct uac_clock_source_descriptor),
+	FUNC(UAC_VERSION_2, UAC2_CLOCK_SELECTOR, validate_selector_unit),
+	FIXED(UAC_VERSION_2, UAC2_CLOCK_MULTIPLIER,
+	      struct uac_clock_multiplier_descriptor),
+	/* UAC_VERSION_2, UAC2_SAMPLE_RATE_CONVERTER: not implemented yet */
+
+	/* UAC3 */
+	FIXED(UAC_VERSION_2, UAC_HEADER, struct uac3_ac_header_descriptor),
+	FIXED(UAC_VERSION_3, UAC_INPUT_TERMINAL,
+	      struct uac3_input_terminal_descriptor),
+	FIXED(UAC_VERSION_3, UAC_OUTPUT_TERMINAL,
+	      struct uac3_output_terminal_descriptor),
+	/* UAC_VERSION_3, UAC3_EXTENDED_TERMINAL: not implemented yet */
+	FUNC(UAC_VERSION_3, UAC3_MIXER_UNIT, validate_mixer_unit),
+	FUNC(UAC_VERSION_3, UAC3_SELECTOR_UNIT, validate_selector_unit),
+	FUNC(UAC_VERSION_3, UAC_FEATURE_UNIT, validate_uac3_feature_unit),
+	/*  UAC_VERSION_3, UAC3_EFFECT_UNIT: not implemented yet */
+	FUNC(UAC_VERSION_3, UAC3_PROCESSING_UNIT, validate_processing_unit),
+	FUNC(UAC_VERSION_3, UAC3_EXTENSION_UNIT, validate_processing_unit),
+	FIXED(UAC_VERSION_3, UAC3_CLOCK_SOURCE,
+	      struct uac3_clock_source_descriptor),
+	FUNC(UAC_VERSION_3, UAC3_CLOCK_SELECTOR, validate_selector_unit),
+	FIXED(UAC_VERSION_3, UAC3_CLOCK_MULTIPLIER,
+	      struct uac3_clock_multiplier_descriptor),
+	/* UAC_VERSION_3, UAC3_SAMPLE_RATE_CONVERTER: not implemented yet */
+	/* UAC_VERSION_3, UAC3_CONNECTORS: not implemented yet */
+	{ } /* terminator */
+};
+
+static struct usb_desc_validator midi_validators[] = {
+	FIXED(UAC_VERSION_ALL, USB_MS_HEADER,
+	      struct usb_ms_header_descriptor),
+	FIXED(UAC_VERSION_ALL, USB_MS_MIDI_IN_JACK,
+	      struct usb_midi_in_jack_descriptor),
+	FUNC(UAC_VERSION_ALL, USB_MS_MIDI_OUT_JACK,
+	     validate_midi_out_jack),
+	{ } /* terminator */
+};
+
+
+/* Validate the given unit descriptor, return true if it's OK */
+static bool validate_desc(unsigned char *hdr, int protocol,
+			  const struct usb_desc_validator *v)
+{
+	if (hdr[1] != USB_DT_CS_INTERFACE)
+		return true; /* don't care */
+
+	for (; v->type; v++) {
+		if (v->type == hdr[2] &&
+		    (v->protocol == UAC_VERSION_ALL ||
+		     v->protocol == protocol)) {
+			if (v->func)
+				return v->func(hdr, v);
+			/* check for the fixed size */
+			return hdr[0] >= v->size;
+		}
+	}
+
+	return true; /* not matching, skip validation */
+}
+
+bool snd_usb_validate_audio_desc(void *p, int protocol)
+{
+	return validate_desc(p, protocol, audio_validators);
+}
+
+bool snd_usb_validate_midi_desc(void *p)
+{
+	return validate_desc(p, UAC_VERSION_1, midi_validators);
+}
+


