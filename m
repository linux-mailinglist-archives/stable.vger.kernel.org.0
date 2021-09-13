Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7F74091D0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244495AbhIMOFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343690AbhIMOD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:03:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC71661A52;
        Mon, 13 Sep 2021 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540320;
        bh=AUAOhTPFuebkOjhrDueU01s6CvNvMJpixVeNc8usw/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b177O5OSamiBA5JQyc63y9RcIJtaVRF8L6eY2nh0miWbkyuJOCSigilI8ggbCP/B+
         zGlhn8kTWZvwoeS8d9CeNZUoFPV1lnaAXv5VEwZkAd4JthkJu26ZQpeE0G1J1xBST3
         A5T77O9DK+Dv48ANSIDLVbptMMZmWDnprtUPiOQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 144/300] leds: trigger: audio: Add an activate callback to ensure the initial brightness is set
Date:   Mon, 13 Sep 2021 15:13:25 +0200
Message-Id: <20210913131114.259756912@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 64f67b5240db79eceb0bd57dae8e591fd3103ba0 ]

Some 2-in-1s with a detachable (USB) keyboard(dock) have mute-LEDs in
the speaker- and/or mic-mute keys on the keyboard.

Examples of this are the Lenovo Thinkpad10 tablet (with its USB kbd-dock)
and the HP x2 10 series.

The detachable nature of these keyboards means that the keyboard and
thus the mute LEDs may show up after the user (or userspace restoring
old mixer settings) has muted the speaker and/or mic.

Current LED-class devices with a default_trigger of "audio-mute" or
"audio-micmute" initialize the brightness member of led_classdev with
ledtrig_audio_get() before registering the LED.

This makes the software state after attaching the keyboard match the
actual audio mute state, e.g. cat /sys/class/leds/foo/brightness will
show the right value.

But before this commit nothing was actually calling the led_classdev's
brightness_set[_blocking] callback so the value returned by
ledtrig_audio_get() was never actually being sent to the hw, leading
to the mute LEDs staying in their default power-on state, after
attaching the keyboard, even if ledtrig_audio_get() returned a different
state.

This could be fixed by having the individual LED drivers call
brightness_set[_blocking] themselves after registering the LED,
but this really is something which should be done by a led-trigger
activate callback.

Add an activate callback for this, fixing the issue of the
mute LEDs being out of sync after (re)attaching the keyboard.

Cc: Takashi Iwai <tiwai@suse.de>
Fixes: faa2541f5b1a ("leds: trigger: Introduce audio mute LED trigger")
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/trigger/ledtrig-audio.c | 37 ++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-audio.c b/drivers/leds/trigger/ledtrig-audio.c
index f76621e88482..c6b437e6369b 100644
--- a/drivers/leds/trigger/ledtrig-audio.c
+++ b/drivers/leds/trigger/ledtrig-audio.c
@@ -6,10 +6,33 @@
 #include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/module.h>
+#include "../leds.h"
 
-static struct led_trigger *ledtrig_audio[NUM_AUDIO_LEDS];
 static enum led_brightness audio_state[NUM_AUDIO_LEDS];
 
+static int ledtrig_audio_mute_activate(struct led_classdev *led_cdev)
+{
+	led_set_brightness_nosleep(led_cdev, audio_state[LED_AUDIO_MUTE]);
+	return 0;
+}
+
+static int ledtrig_audio_micmute_activate(struct led_classdev *led_cdev)
+{
+	led_set_brightness_nosleep(led_cdev, audio_state[LED_AUDIO_MICMUTE]);
+	return 0;
+}
+
+static struct led_trigger ledtrig_audio[NUM_AUDIO_LEDS] = {
+	[LED_AUDIO_MUTE] = {
+		.name     = "audio-mute",
+		.activate = ledtrig_audio_mute_activate,
+	},
+	[LED_AUDIO_MICMUTE] = {
+		.name     = "audio-micmute",
+		.activate = ledtrig_audio_micmute_activate,
+	},
+};
+
 enum led_brightness ledtrig_audio_get(enum led_audio type)
 {
 	return audio_state[type];
@@ -19,24 +42,22 @@ EXPORT_SYMBOL_GPL(ledtrig_audio_get);
 void ledtrig_audio_set(enum led_audio type, enum led_brightness state)
 {
 	audio_state[type] = state;
-	led_trigger_event(ledtrig_audio[type], state);
+	led_trigger_event(&ledtrig_audio[type], state);
 }
 EXPORT_SYMBOL_GPL(ledtrig_audio_set);
 
 static int __init ledtrig_audio_init(void)
 {
-	led_trigger_register_simple("audio-mute",
-				    &ledtrig_audio[LED_AUDIO_MUTE]);
-	led_trigger_register_simple("audio-micmute",
-				    &ledtrig_audio[LED_AUDIO_MICMUTE]);
+	led_trigger_register(&ledtrig_audio[LED_AUDIO_MUTE]);
+	led_trigger_register(&ledtrig_audio[LED_AUDIO_MICMUTE]);
 	return 0;
 }
 module_init(ledtrig_audio_init);
 
 static void __exit ledtrig_audio_exit(void)
 {
-	led_trigger_unregister_simple(ledtrig_audio[LED_AUDIO_MUTE]);
-	led_trigger_unregister_simple(ledtrig_audio[LED_AUDIO_MICMUTE]);
+	led_trigger_unregister(&ledtrig_audio[LED_AUDIO_MUTE]);
+	led_trigger_unregister(&ledtrig_audio[LED_AUDIO_MICMUTE]);
 }
 module_exit(ledtrig_audio_exit);
 
-- 
2.30.2



