Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F2BA8FE9
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389083AbfIDSGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388511AbfIDSGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2053B208E4;
        Wed,  4 Sep 2019 18:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620395;
        bh=Y3WTWkG85/3eRaBnKPhC5oucDyL+QcYVnYaPUi5pWaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9gDpulvItrcrU35YaG0j37brLd2IxGZFNpZIqt7r+K16h1QC+4cJvctGIOnVXvO8
         cMectUaNgPdxRiW4iVywJlIy67yYGF5mqLwKak7lZb6Cxjgd7ALer/AP6y2s7iR7PZ
         Kn97lnx1AM7/0J9ZK7imgXRi09BtzgUqxu71q7ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 40/93] ALSA: usb-audio: Check mixer unit bitmap yet more strictly
Date:   Wed,  4 Sep 2019 19:53:42 +0200
Message-Id: <20190904175306.656801287@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit f9f0e9ed350e15d51ad07364b4cf910de50c472a upstream.

The bmControls (for UAC1) or bmMixerControls (for UAC2/3) bitmap has a
variable size depending on both input and output pins.  Its size is to
fit with input * output bits.  The problem is that the input size
can't be determined simply from the unit descriptor itself but it
needs to parse the whole connected sources.  Although the
uac_mixer_unit_get_channels() tries to check some possible overflow of
this bitmap, it's incomplete due to the lack of the  evaluation of
input pins.

For covering possible overflows, this patch adds the bitmap overflow
check in the loop of input pins in parse_audio_mixer_unit().

Fixes: 0bfe5e434e66 ("ALSA: usb-audio: Check mixer unit descriptors more strictly")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -754,7 +754,6 @@ static int uac_mixer_unit_get_channels(s
 				       struct uac_mixer_unit_descriptor *desc)
 {
 	int mu_channels;
-	void *c;
 
 	if (desc->bLength < sizeof(*desc))
 		return -EINVAL;
@@ -777,13 +776,6 @@ static int uac_mixer_unit_get_channels(s
 		break;
 	}
 
-	if (!mu_channels)
-		return 0;
-
-	c = uac_mixer_unit_bmControls(desc, state->mixer->protocol);
-	if (c - (void *)desc + (mu_channels - 1) / 8 >= desc->bLength)
-		return 0; /* no bmControls -> skip */
-
 	return mu_channels;
 }
 
@@ -2028,6 +2020,31 @@ static int parse_audio_feature_unit(stru
  * Mixer Unit
  */
 
+/* check whether the given in/out overflows bmMixerControls matrix */
+static bool mixer_bitmap_overflow(struct uac_mixer_unit_descriptor *desc,
+				  int protocol, int num_ins, int num_outs)
+{
+	u8 *hdr = (u8 *)desc;
+	u8 *c = uac_mixer_unit_bmControls(desc, protocol);
+	size_t rest; /* remaining bytes after bmMixerControls */
+
+	switch (protocol) {
+	case UAC_VERSION_1:
+	default:
+		rest = 1; /* iMixer */
+		break;
+	case UAC_VERSION_2:
+		rest = 2; /* bmControls + iMixer */
+		break;
+	case UAC_VERSION_3:
+		rest = 6; /* bmControls + wMixerDescrStr */
+		break;
+	}
+
+	/* overflow? */
+	return c + (num_ins * num_outs + 7) / 8 + rest > hdr + hdr[0];
+}
+
 /*
  * build a mixer unit control
  *
@@ -2156,6 +2173,9 @@ static int parse_audio_mixer_unit(struct
 		if (err < 0)
 			return err;
 		num_ins += iterm.channels;
+		if (mixer_bitmap_overflow(desc, state->mixer->protocol,
+					  num_ins, num_outs))
+			break;
 		for (; ich < num_ins; ich++) {
 			int och, ich_has_controls = 0;
 


