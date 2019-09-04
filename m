Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AFAA8FF7
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389543AbfIDSGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389530AbfIDSGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B47F222CF7;
        Wed,  4 Sep 2019 18:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620414;
        bh=sNp1iCWqqSjNHRiC6wD9vtQxe8Rg2SduOCPRQX4RkrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dY8CTduXzT/eWGEYP6qimZIvF5yAvjl4dzCt+E5yVtfd8rSgWA92fwEkiH78eo6YW
         p44dtz6bv+/Hql1+CQOeJfB/3aS/i2HfpmCJtu1Wbp9zE3zL1S0m6/pvgukUhcCp9p
         FhsDRmSmYLHWmu/3SEofwEzJfvAHK7+ACvgavEwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jeronimo Borque <jeronimo@borque.com.ar>
Subject: [PATCH 4.19 42/93] ALSA: hda - Fixes inverted Conexant GPIO mic mute led
Date:   Wed,  4 Sep 2019 19:53:44 +0200
Message-Id: <20190904175306.808754513@linuxfoundation.org>
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

From: Jeronimo Borque <jeronimo@borque.com.ar>

commit f9ef724d4896763479f3921afd1ee61552fc9836 upstream.

"enabled" parameter historically referred to the device input or
output, not to the led indicator. After the changes added with the led
helper functions the mic mute led logic refers to the led and not to
the mic input which caused led indicator to be negated.
Fixing logic in cxt_update_gpio_led and updated
cxt_fixup_gpio_mute_hook
Also updated debug messages to ease further debugging if necessary.

Fixes: 184e302b46c9 ("ALSA: hda/conexant - Use the mic-mute LED helper")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jeronimo Borque <jeronimo@borque.com.ar>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -624,18 +624,20 @@ static void cxt_fixup_hp_gate_mic_jack(s
 
 /* update LED status via GPIO */
 static void cxt_update_gpio_led(struct hda_codec *codec, unsigned int mask,
-				bool enabled)
+				bool led_on)
 {
 	struct conexant_spec *spec = codec->spec;
 	unsigned int oldval = spec->gpio_led;
 
 	if (spec->mute_led_polarity)
-		enabled = !enabled;
+		led_on = !led_on;
 
-	if (enabled)
-		spec->gpio_led &= ~mask;
-	else
+	if (led_on)
 		spec->gpio_led |= mask;
+	else
+		spec->gpio_led &= ~mask;
+	codec_dbg(codec, "mask:%d enabled:%d gpio_led:%d\n",
+			mask, led_on, spec->gpio_led);
 	if (spec->gpio_led != oldval)
 		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_DATA,
 				    spec->gpio_led);
@@ -646,8 +648,8 @@ static void cxt_fixup_gpio_mute_hook(voi
 {
 	struct hda_codec *codec = private_data;
 	struct conexant_spec *spec = codec->spec;
-
-	cxt_update_gpio_led(codec, spec->gpio_mute_led_mask, enabled);
+	/* muted -> LED on */
+	cxt_update_gpio_led(codec, spec->gpio_mute_led_mask, !enabled);
 }
 
 /* turn on/off mic-mute LED via GPIO per capture hook */
@@ -669,7 +671,6 @@ static void cxt_fixup_mute_led_gpio(stru
 		{ 0x01, AC_VERB_SET_GPIO_DIRECTION, 0x03 },
 		{}
 	};
-	codec_info(codec, "action: %d gpio_led: %d\n", action, spec->gpio_led);
 
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->gen.vmaster_mute.hook = cxt_fixup_gpio_mute_hook;


