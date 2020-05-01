Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3391C15BC
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgEANc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730360AbgEANc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:32:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A238208D6;
        Fri,  1 May 2020 13:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339977;
        bh=N2g5AetZjjeqhnyaacK54kADqjcgydOL3a79SG4b514=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPtStm6Aj12IR87e0Kps8XFB1nKANkUQ0Gaf1iWwLBlHb8vOU0X+8aAdcg+dPmbrn
         sxM864PyFL33gdbqPk2CMmrWuym9IpUqDMTdk/NleYoZm8h59YiDP+yyNBPJ221wEb
         o1U7RIAv4p7mCL90nZsC18Th9iscBK/1qOuwMybg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Skobkin <skobkin-ru@ya.ru>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 056/117] ALSA: usb-audio: Filter out unsupported sample rates on Focusrite devices
Date:   Fri,  1 May 2020 15:21:32 +0200
Message-Id: <20200501131552.311815649@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

commit 1c826792586f526a5a5cd21d55aad388f5bb0b23 upstream.

Many Focusrite devices supports a limited set of sample rates per
altsetting. These includes audio interfaces with ADAT ports:
 - Scarlett 18i6, 18i8 1st gen, 18i20 1st gen;
 - Scarlett 18i8 2nd gen, 18i20 2nd gen;
 - Scarlett 18i8 3rd gen, 18i20 3rd gen;
 - Clarett 2Pre USB, 4Pre USB, 8Pre USB.

Maximum rate is exposed in the last 4 bytes of Format Type descriptor
which has a non-standard bLength = 10.

Tested-by: Alexey Skobkin <skobkin-ru@ya.ru>
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200418175815.12211-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/format.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -221,6 +221,52 @@ static int parse_audio_format_rates_v1(s
 }
 
 /*
+ * Many Focusrite devices supports a limited set of sampling rates per
+ * altsetting. Maximum rate is exposed in the last 4 bytes of Format Type
+ * descriptor which has a non-standard bLength = 10.
+ */
+static bool focusrite_valid_sample_rate(struct snd_usb_audio *chip,
+					struct audioformat *fp,
+					unsigned int rate)
+{
+	struct usb_interface *iface;
+	struct usb_host_interface *alts;
+	unsigned char *fmt;
+	unsigned int max_rate;
+
+	iface = usb_ifnum_to_if(chip->dev, fp->iface);
+	if (!iface)
+		return true;
+
+	alts = &iface->altsetting[fp->altset_idx];
+	fmt = snd_usb_find_csint_desc(alts->extra, alts->extralen,
+				      NULL, UAC_FORMAT_TYPE);
+	if (!fmt)
+		return true;
+
+	if (fmt[0] == 10) { /* bLength */
+		max_rate = combine_quad(&fmt[6]);
+
+		/* Validate max rate */
+		if (max_rate != 48000 &&
+		    max_rate != 96000 &&
+		    max_rate != 192000 &&
+		    max_rate != 384000) {
+
+			usb_audio_info(chip,
+				"%u:%d : unexpected max rate: %u\n",
+				fp->iface, fp->altsetting, max_rate);
+
+			return true;
+		}
+
+		return rate <= max_rate;
+	}
+
+	return true;
+}
+
+/*
  * Helper function to walk the array of sample rate triplets reported by
  * the device. The problem is that we need to parse whole array first to
  * get to know how many sample rates we have to expect.
@@ -256,6 +302,11 @@ static int parse_uac2_sample_rate_range(
 		}
 
 		for (rate = min; rate <= max; rate += res) {
+			/* Filter out invalid rates on Focusrite devices */
+			if (USB_ID_VENDOR(chip->usb_id) == 0x1235 &&
+			    !focusrite_valid_sample_rate(chip, fp, rate))
+				goto skip_rate;
+
 			if (fp->rate_table)
 				fp->rate_table[nr_rates] = rate;
 			if (!fp->rate_min || rate < fp->rate_min)
@@ -270,6 +321,7 @@ static int parse_uac2_sample_rate_range(
 				break;
 			}
 
+skip_rate:
 			/* avoid endless loop */
 			if (res == 0)
 				break;


