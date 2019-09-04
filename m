Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF8A911A
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390292AbfIDSNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390700AbfIDSNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16E9B2341B;
        Wed,  4 Sep 2019 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620811;
        bh=I9c8+mI73wBB/l3wPqRLRS5mw5uBMutPW2XFFFwYECs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ka28y/ar0RCnu8rXb4eHQjRG76ABXnT+sl6sRjZxVVVvZvBa8f9hHZ76Dk4yoojuz
         m+Dhpl95JK//DR6IxMo1foWAsmb7DKKBF1Vd02iQjDIMbDJUILMm2WGnaXPnSiXFWD
         5ipbCtoag7f9MtjUk1+i9AlTGiKXGD4+wAFu3Yzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jeronimo Borque <jeronimo@borque.com.ar>
Subject: [PATCH 5.2 063/143] ALSA: hda - Fixes inverted Conexant GPIO mic mute led
Date:   Wed,  4 Sep 2019 19:53:26 +0200
Message-Id: <20190904175316.537139719@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
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
@@ -611,18 +611,20 @@ static void cxt_fixup_hp_gate_mic_jack(s
 
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
@@ -633,8 +635,8 @@ static void cxt_fixup_gpio_mute_hook(voi
 {
 	struct hda_codec *codec = private_data;
 	struct conexant_spec *spec = codec->spec;
-
-	cxt_update_gpio_led(codec, spec->gpio_mute_led_mask, enabled);
+	/* muted -> LED on */
+	cxt_update_gpio_led(codec, spec->gpio_mute_led_mask, !enabled);
 }
 
 /* turn on/off mic-mute LED via GPIO per capture hook */
@@ -656,7 +658,6 @@ static void cxt_fixup_mute_led_gpio(stru
 		{ 0x01, AC_VERB_SET_GPIO_DIRECTION, 0x03 },
 		{}
 	};
-	codec_info(codec, "action: %d gpio_led: %d\n", action, spec->gpio_led);
 
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->gen.vmaster_mute.hook = cxt_fixup_gpio_mute_hook;


