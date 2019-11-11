Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D629DF7E10
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbfKKSvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:51:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730049AbfKKSvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:51:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C800D21655;
        Mon, 11 Nov 2019 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498305;
        bh=cV4ASttvrsQRUy7oNIRhY6d7FnOWA1nyPWs+2IdOglk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhI7ZyJLw7891MLWy/6Kl8OCXbNlBjkJOZkOhmMCV0YtDBYEFkFqygAhr5Eg4CydA
         hbH2W7IufFeKk5M+X0HvxgruP8BUugUEfCFtgU1LgF9Nu+7NpzNJx5aDuaVdW1Z3et
         CMuZpj39sPQxzaasGyLDZSDl/jr2DZxSCO2GScaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 083/193] ALSA: usb-audio: Simplify parse_audio_unit()
Date:   Mon, 11 Nov 2019 19:27:45 +0100
Message-Id: <20191111181507.284332505@linuxfoundation.org>
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

commit 68e9fde245591d18200f8a9054cac22339437adb upstream.

Minor code refactoring by combining the UAC version and the type in
the switch-case flow, so that we reduce the indentation and
redundancy.  One good bonus is that the duplicated definition of the
same type value (e.g. UAC2_EFFECT_UNIT) can be handled more cleanly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |   95 ++++++++++++++++++++++--------------------------------
 1 file changed, 39 insertions(+), 56 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2782,62 +2782,45 @@ static int parse_audio_unit(struct mixer
 		return 0; /* skip invalid unit */
 	}
 
-	if (protocol == UAC_VERSION_1 || protocol == UAC_VERSION_2) {
-		switch (p1[2]) {
-		case UAC_INPUT_TERMINAL:
-			return parse_audio_input_terminal(state, unitid, p1);
-		case UAC_MIXER_UNIT:
-			return parse_audio_mixer_unit(state, unitid, p1);
-		case UAC2_CLOCK_SOURCE:
-			return parse_clock_source_unit(state, unitid, p1);
-		case UAC_SELECTOR_UNIT:
-		case UAC2_CLOCK_SELECTOR:
-			return parse_audio_selector_unit(state, unitid, p1);
-		case UAC_FEATURE_UNIT:
-			return parse_audio_feature_unit(state, unitid, p1);
-		case UAC1_PROCESSING_UNIT:
-		/*   UAC2_EFFECT_UNIT has the same value */
-			if (protocol == UAC_VERSION_1)
-				return parse_audio_processing_unit(state, unitid, p1);
-			else
-				return 0; /* FIXME - effect units not implemented yet */
-		case UAC1_EXTENSION_UNIT:
-		/*   UAC2_PROCESSING_UNIT_V2 has the same value */
-			if (protocol == UAC_VERSION_1)
-				return parse_audio_extension_unit(state, unitid, p1);
-			else /* UAC_VERSION_2 */
-				return parse_audio_processing_unit(state, unitid, p1);
-		case UAC2_EXTENSION_UNIT_V2:
-			return parse_audio_extension_unit(state, unitid, p1);
-		default:
-			usb_audio_err(state->chip,
-				"unit %u: unexpected type 0x%02x\n", unitid, p1[2]);
-			return -EINVAL;
-		}
-	} else { /* UAC_VERSION_3 */
-		switch (p1[2]) {
-		case UAC_INPUT_TERMINAL:
-			return parse_audio_input_terminal(state, unitid, p1);
-		case UAC3_MIXER_UNIT:
-			return parse_audio_mixer_unit(state, unitid, p1);
-		case UAC3_CLOCK_SOURCE:
-			return parse_clock_source_unit(state, unitid, p1);
-		case UAC3_SELECTOR_UNIT:
-		case UAC3_CLOCK_SELECTOR:
-			return parse_audio_selector_unit(state, unitid, p1);
-		case UAC3_FEATURE_UNIT:
-			return parse_audio_feature_unit(state, unitid, p1);
-		case UAC3_EFFECT_UNIT:
-			return 0; /* FIXME - effect units not implemented yet */
-		case UAC3_PROCESSING_UNIT:
-			return parse_audio_processing_unit(state, unitid, p1);
-		case UAC3_EXTENSION_UNIT:
-			return parse_audio_extension_unit(state, unitid, p1);
-		default:
-			usb_audio_err(state->chip,
-				"unit %u: unexpected type 0x%02x\n", unitid, p1[2]);
-			return -EINVAL;
-		}
+#define PTYPE(a, b)	((a) << 8 | (b))
+	switch (PTYPE(protocol, p1[2])) {
+	case PTYPE(UAC_VERSION_1, UAC_INPUT_TERMINAL):
+	case PTYPE(UAC_VERSION_2, UAC_INPUT_TERMINAL):
+	case PTYPE(UAC_VERSION_3, UAC_INPUT_TERMINAL):
+		return parse_audio_input_terminal(state, unitid, p1);
+	case PTYPE(UAC_VERSION_1, UAC_MIXER_UNIT):
+	case PTYPE(UAC_VERSION_2, UAC_MIXER_UNIT):
+	case PTYPE(UAC_VERSION_3, UAC3_MIXER_UNIT):
+		return parse_audio_mixer_unit(state, unitid, p1);
+	case PTYPE(UAC_VERSION_2, UAC2_CLOCK_SOURCE):
+	case PTYPE(UAC_VERSION_3, UAC3_CLOCK_SOURCE):
+		return parse_clock_source_unit(state, unitid, p1);
+	case PTYPE(UAC_VERSION_1, UAC_SELECTOR_UNIT):
+	case PTYPE(UAC_VERSION_2, UAC_SELECTOR_UNIT):
+	case PTYPE(UAC_VERSION_3, UAC3_SELECTOR_UNIT):
+	case PTYPE(UAC_VERSION_2, UAC2_CLOCK_SELECTOR):
+	case PTYPE(UAC_VERSION_3, UAC3_CLOCK_SELECTOR):
+		return parse_audio_selector_unit(state, unitid, p1);
+	case PTYPE(UAC_VERSION_1, UAC_FEATURE_UNIT):
+	case PTYPE(UAC_VERSION_2, UAC_FEATURE_UNIT):
+	case PTYPE(UAC_VERSION_3, UAC3_FEATURE_UNIT):
+		return parse_audio_feature_unit(state, unitid, p1);
+	case PTYPE(UAC_VERSION_1, UAC1_PROCESSING_UNIT):
+	case PTYPE(UAC_VERSION_2, UAC2_PROCESSING_UNIT_V2):
+	case PTYPE(UAC_VERSION_3, UAC3_PROCESSING_UNIT):
+		return parse_audio_processing_unit(state, unitid, p1);
+	case PTYPE(UAC_VERSION_1, UAC1_EXTENSION_UNIT):
+	case PTYPE(UAC_VERSION_2, UAC2_EXTENSION_UNIT_V2):
+	case PTYPE(UAC_VERSION_3, UAC3_EXTENSION_UNIT):
+		return parse_audio_extension_unit(state, unitid, p1);
+	case PTYPE(UAC_VERSION_2, UAC2_EFFECT_UNIT):
+	case PTYPE(UAC_VERSION_3, UAC3_EFFECT_UNIT):
+		return 0; /* FIXME - effect units not implemented yet */
+	default:
+		usb_audio_err(state->chip,
+			      "unit %u: unexpected type 0x%02x\n",
+			      unitid, p1[2]);
+		return -EINVAL;
 	}
 }
 


