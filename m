Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD0C1BCAEF
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgD1SfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbgD1SfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:35:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B43C20B80;
        Tue, 28 Apr 2020 18:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098900;
        bh=0zZaLPEJ3+DySS51ULVXOOgWh6RmzLyuCVpFFrFyOY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/N5JgwqkIdaB3Ev1tiD3jtuuFzvr5REt3jfPWtIFnou/2NN1opJw7zAAl3JK7QVX
         Pvk6zdCNM1O5mqBPHUHaCmQdz1DK5gK2zQNfQ1x+OnljgTG/+PiF/pgDuXme1423JZ
         H0jVfwjV8f5rFEdMdXKmKUM7qZYlMChOMjtt7LLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Skobkin <skobkin-ru@ya.ru>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 108/167] ALSA: usb-audio: Filter out unsupported sample rates on Focusrite devices
Date:   Tue, 28 Apr 2020 20:24:44 +0200
Message-Id: <20200428182238.832691458@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
@@ -248,6 +248,52 @@ static int parse_audio_format_rates_v1(s
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
@@ -283,6 +329,11 @@ static int parse_uac2_sample_rate_range(
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
@@ -297,6 +348,7 @@ static int parse_uac2_sample_rate_range(
 				break;
 			}
 
+skip_rate:
 			/* avoid endless loop */
 			if (res == 0)
 				break;


