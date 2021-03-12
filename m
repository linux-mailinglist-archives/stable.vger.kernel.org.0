Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF9C338496
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 05:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCLEOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 23:14:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54274 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbhCLEOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 23:14:15 -0500
Received: from [103.229.218.199] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1lKZBl-0000MM-8E; Fri, 12 Mar 2021 04:14:13 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda: generic: Fix the micmute led init state
Date:   Fri, 12 Mar 2021 12:14:08 +0800
Message-Id: <20210312041408.3776-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recently we found the micmute led init state is not correct after
freshly installing the ubuntu linux on a Lenovo AIO machine. The
internal mic is not muted, but the micmute led is on and led mode is
'follow mute'. If we mute internal mic, the led is keeping on, then
unmute the internal mic, the led is off. And from then on, the
micmute led will work correctly.

So the micmute led init state is not correct. The led is controlled
by codec gpio (ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY), in the
patch_realtek, the gpio data is set to 0x4 initially and the led is
on with this data. In the hda_generic, the led_value is set to
0 initially, suppose users set the 'capture switch' to on from
user space and the micmute led should change to be off with this
operation, but the check "if (val == spec->micmute_led.led_value)" in
the call_micmute_led_update() will skip the led setting.

To guarantee the led state will be set by the 1st time of changing
"Capture Switch", set -1 to the init led_value.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/hda_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 8b7c5508f368..f5cba7afd1c6 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -4065,7 +4065,7 @@ static int add_micmute_led_hook(struct hda_codec *codec)
 
 	spec->micmute_led.led_mode = MICMUTE_LED_FOLLOW_MUTE;
 	spec->micmute_led.capture = 0;
-	spec->micmute_led.led_value = 0;
+	spec->micmute_led.led_value = -1;
 	spec->micmute_led.old_hook = spec->cap_sync_hook;
 	spec->cap_sync_hook = update_micmute_led;
 	if (!snd_hda_gen_add_kctl(spec, NULL, &micmute_led_mode_ctl))
-- 
2.25.1

