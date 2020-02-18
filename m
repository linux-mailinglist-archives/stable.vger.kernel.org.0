Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6463F16320F
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgBRUF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgBRUBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:01:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BA0B24125;
        Tue, 18 Feb 2020 20:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056102;
        bh=l5lJEZkz51E19LU9MHHTVA8iChaAYWOmUBGzBZnmP/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aI1Mp0Wkk/T8eJDUT8q5li5HrCGReX4Rjn/3ZJ+NglpifbCFqRrrIeVYTXqQkLTYQ
         b5IQxEd7ZokQTi7YLl8aBbNiznO6hi+67E4Wa53ocJYxF/eQBrAcbM2R6ql3QTjvHk
         a20+8qZmyNpiz+SZaQ4z3P3MA5nmImTWEiRhTONk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Oszlanyi <toszlanyi@yahoo.de>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.5 06/80] ALSA: usb-audio: Add clock validity quirk for Denon MC7000/MCX8000
Date:   Tue, 18 Feb 2020 20:54:27 +0100
Message-Id: <20200218190432.665660777@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

commit 9f35a31283775e6f6af73fb2c95c686a4c0acac7 upstream.

It should be safe to ignore clock validity check result if the following
conditions are met:
 - only one single sample rate is supported;
 - the terminal is directly connected to the clock source;
 - the clock type is internal.

This is to deal with some Denon DJ controllers that always reports that
clock is invalid.

Tested-by: Tobias Oszlanyi <toszlanyi@yahoo.de>
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200212235450.697348-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/clock.c  |   91 ++++++++++++++++++++++++++++++++++++-----------------
 sound/usb/clock.h  |    4 +-
 sound/usb/format.c |    3 -
 3 files changed, 66 insertions(+), 32 deletions(-)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -151,8 +151,34 @@ static int uac_clock_selector_set_val(st
 	return ret;
 }
 
+/*
+ * Assume the clock is valid if clock source supports only one single sample
+ * rate, the terminal is connected directly to it (there is no clock selector)
+ * and clock type is internal. This is to deal with some Denon DJ controllers
+ * that always reports that clock is invalid.
+ */
+static bool uac_clock_source_is_valid_quirk(struct snd_usb_audio *chip,
+					    struct audioformat *fmt,
+					    int source_id)
+{
+	if (fmt->protocol == UAC_VERSION_2) {
+		struct uac_clock_source_descriptor *cs_desc =
+			snd_usb_find_clock_source(chip->ctrl_intf, source_id);
+
+		if (!cs_desc)
+			return false;
+
+		return (fmt->nr_rates == 1 &&
+			(fmt->clock & 0xff) == cs_desc->bClockID &&
+			(cs_desc->bmAttributes & 0x3) !=
+				UAC_CLOCK_SOURCE_TYPE_EXT);
+	}
+
+	return false;
+}
+
 static bool uac_clock_source_is_valid(struct snd_usb_audio *chip,
-				      int protocol,
+				      struct audioformat *fmt,
 				      int source_id)
 {
 	int err;
@@ -160,7 +186,7 @@ static bool uac_clock_source_is_valid(st
 	struct usb_device *dev = chip->dev;
 	u32 bmControls;
 
-	if (protocol == UAC_VERSION_3) {
+	if (fmt->protocol == UAC_VERSION_3) {
 		struct uac3_clock_source_descriptor *cs_desc =
 			snd_usb_find_clock_source_v3(chip->ctrl_intf, source_id);
 
@@ -194,10 +220,14 @@ static bool uac_clock_source_is_valid(st
 		return false;
 	}
 
-	return data ? true :  false;
+	if (data)
+		return true;
+	else
+		return uac_clock_source_is_valid_quirk(chip, fmt, source_id);
 }
 
-static int __uac_clock_find_source(struct snd_usb_audio *chip, int entity_id,
+static int __uac_clock_find_source(struct snd_usb_audio *chip,
+				   struct audioformat *fmt, int entity_id,
 				   unsigned long *visited, bool validate)
 {
 	struct uac_clock_source_descriptor *source;
@@ -217,7 +247,7 @@ static int __uac_clock_find_source(struc
 	source = snd_usb_find_clock_source(chip->ctrl_intf, entity_id);
 	if (source) {
 		entity_id = source->bClockID;
-		if (validate && !uac_clock_source_is_valid(chip, UAC_VERSION_2,
+		if (validate && !uac_clock_source_is_valid(chip, fmt,
 								entity_id)) {
 			usb_audio_err(chip,
 				"clock source %d is not valid, cannot use\n",
@@ -248,8 +278,9 @@ static int __uac_clock_find_source(struc
 		}
 
 		cur = ret;
-		ret = __uac_clock_find_source(chip, selector->baCSourceID[ret - 1],
-					       visited, validate);
+		ret = __uac_clock_find_source(chip, fmt,
+					      selector->baCSourceID[ret - 1],
+					      visited, validate);
 		if (!validate || ret > 0 || !chip->autoclock)
 			return ret;
 
@@ -260,8 +291,9 @@ static int __uac_clock_find_source(struc
 			if (i == cur)
 				continue;
 
-			ret = __uac_clock_find_source(chip, selector->baCSourceID[i - 1],
-				visited, true);
+			ret = __uac_clock_find_source(chip, fmt,
+						      selector->baCSourceID[i - 1],
+						      visited, true);
 			if (ret < 0)
 				continue;
 
@@ -281,14 +313,16 @@ static int __uac_clock_find_source(struc
 	/* FIXME: multipliers only act as pass-thru element for now */
 	multiplier = snd_usb_find_clock_multiplier(chip->ctrl_intf, entity_id);
 	if (multiplier)
-		return __uac_clock_find_source(chip, multiplier->bCSourceID,
-						visited, validate);
+		return __uac_clock_find_source(chip, fmt,
+					       multiplier->bCSourceID,
+					       visited, validate);
 
 	return -EINVAL;
 }
 
-static int __uac3_clock_find_source(struct snd_usb_audio *chip, int entity_id,
-				   unsigned long *visited, bool validate)
+static int __uac3_clock_find_source(struct snd_usb_audio *chip,
+				    struct audioformat *fmt, int entity_id,
+				    unsigned long *visited, bool validate)
 {
 	struct uac3_clock_source_descriptor *source;
 	struct uac3_clock_selector_descriptor *selector;
@@ -307,7 +341,7 @@ static int __uac3_clock_find_source(stru
 	source = snd_usb_find_clock_source_v3(chip->ctrl_intf, entity_id);
 	if (source) {
 		entity_id = source->bClockID;
-		if (validate && !uac_clock_source_is_valid(chip, UAC_VERSION_3,
+		if (validate && !uac_clock_source_is_valid(chip, fmt,
 								entity_id)) {
 			usb_audio_err(chip,
 				"clock source %d is not valid, cannot use\n",
@@ -338,7 +372,8 @@ static int __uac3_clock_find_source(stru
 		}
 
 		cur = ret;
-		ret = __uac3_clock_find_source(chip, selector->baCSourceID[ret - 1],
+		ret = __uac3_clock_find_source(chip, fmt,
+					       selector->baCSourceID[ret - 1],
 					       visited, validate);
 		if (!validate || ret > 0 || !chip->autoclock)
 			return ret;
@@ -350,8 +385,9 @@ static int __uac3_clock_find_source(stru
 			if (i == cur)
 				continue;
 
-			ret = __uac3_clock_find_source(chip, selector->baCSourceID[i - 1],
-				visited, true);
+			ret = __uac3_clock_find_source(chip, fmt,
+						       selector->baCSourceID[i - 1],
+						       visited, true);
 			if (ret < 0)
 				continue;
 
@@ -372,7 +408,8 @@ static int __uac3_clock_find_source(stru
 	multiplier = snd_usb_find_clock_multiplier_v3(chip->ctrl_intf,
 						      entity_id);
 	if (multiplier)
-		return __uac3_clock_find_source(chip, multiplier->bCSourceID,
+		return __uac3_clock_find_source(chip, fmt,
+						multiplier->bCSourceID,
 						visited, validate);
 
 	return -EINVAL;
@@ -389,18 +426,18 @@ static int __uac3_clock_find_source(stru
  *
  * Returns the clock source UnitID (>=0) on success, or an error.
  */
-int snd_usb_clock_find_source(struct snd_usb_audio *chip, int protocol,
-			      int entity_id, bool validate)
+int snd_usb_clock_find_source(struct snd_usb_audio *chip,
+			      struct audioformat *fmt, bool validate)
 {
 	DECLARE_BITMAP(visited, 256);
 	memset(visited, 0, sizeof(visited));
 
-	switch (protocol) {
+	switch (fmt->protocol) {
 	case UAC_VERSION_2:
-		return __uac_clock_find_source(chip, entity_id, visited,
+		return __uac_clock_find_source(chip, fmt, fmt->clock, visited,
 					       validate);
 	case UAC_VERSION_3:
-		return __uac3_clock_find_source(chip, entity_id, visited,
+		return __uac3_clock_find_source(chip, fmt, fmt->clock, visited,
 					       validate);
 	default:
 		return -EINVAL;
@@ -501,8 +538,7 @@ static int set_sample_rate_v2v3(struct s
 	 * automatic clock selection if the current clock is not
 	 * valid.
 	 */
-	clock = snd_usb_clock_find_source(chip, fmt->protocol,
-					  fmt->clock, true);
+	clock = snd_usb_clock_find_source(chip, fmt, true);
 	if (clock < 0) {
 		/* We did not find a valid clock, but that might be
 		 * because the current sample rate does not match an
@@ -510,8 +546,7 @@ static int set_sample_rate_v2v3(struct s
 		 * and we will do another validation after setting the
 		 * rate.
 		 */
-		clock = snd_usb_clock_find_source(chip, fmt->protocol,
-						  fmt->clock, false);
+		clock = snd_usb_clock_find_source(chip, fmt, false);
 		if (clock < 0)
 			return clock;
 	}
@@ -577,7 +612,7 @@ static int set_sample_rate_v2v3(struct s
 
 validation:
 	/* validate clock after rate change */
-	if (!uac_clock_source_is_valid(chip, fmt->protocol, clock))
+	if (!uac_clock_source_is_valid(chip, fmt, clock))
 		return -ENXIO;
 	return 0;
 }
--- a/sound/usb/clock.h
+++ b/sound/usb/clock.h
@@ -6,7 +6,7 @@ int snd_usb_init_sample_rate(struct snd_
 			     struct usb_host_interface *alts,
 			     struct audioformat *fmt, int rate);
 
-int snd_usb_clock_find_source(struct snd_usb_audio *chip, int protocol,
-			     int entity_id, bool validate);
+int snd_usb_clock_find_source(struct snd_usb_audio *chip,
+			      struct audioformat *fmt, bool validate);
 
 #endif /* __USBAUDIO_CLOCK_H */
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -322,8 +322,7 @@ static int parse_audio_format_rates_v2v3
 	struct usb_device *dev = chip->dev;
 	unsigned char tmp[2], *data;
 	int nr_triplets, data_size, ret = 0, ret_l6;
-	int clock = snd_usb_clock_find_source(chip, fp->protocol,
-					      fp->clock, false);
+	int clock = snd_usb_clock_find_source(chip, fp, false);
 
 	if (clock < 0) {
 		dev_err(&dev->dev,


