Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBACF20E82C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731084AbgF2WD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgF2SfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDFDD24658;
        Mon, 29 Jun 2020 15:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443970;
        bh=uOIerWNxr3amIWYSQ8f1i8k0cU06ZCo/aaSinvlZEE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzClul7BLgGshIQ425oHQ/9pTdm2OGAt5QRD+I4nOGbblmzYFeRrc23t4J+oQmo1x
         Q/f6fa813MOMHkp0WO0klqxmkcGiK6Xxow9svMtIuUeDEzIyckmMnIK7SbvIkpOW1Q
         d61c8wm26JKvRDWPdKFIH/i+pD0n+pv+J8U+4tP8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christopher Swenson <swenson@swenson.io>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 074/265] ALSA: usb-audio: Set 48 kHz rate for Rodecaster
Date:   Mon, 29 Jun 2020 11:15:07 -0400
Message-Id: <20200629151818.2493727-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christopher Swenson <swenson@swenson.io>

commit 8abf41dcd1bcdda0d09905fb59d18f45c035c752 upstream.

Like the Line6 devices, the Rode Rodecaster Pro does not support
UAC2_CS_RANGE and only supports a sample rate of 48 kHz.

Tested against a Rode Rodecaster Pro.

Tested-by: Christopher Swenson <swenson@swenson.io>
Signed-off-by: Christopher Swenson <swenson@swenson.io>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/ebdb9e72-9649-0b5e-b9b9-d757dbf26927@swenson.io
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/format.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 5ffb457cc88cf..1b28d01d1f4cd 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -394,8 +394,9 @@ skip_rate:
 	return nr_rates;
 }
 
-/* Line6 Helix series don't support the UAC2_CS_RANGE usb function
- * call. Return a static table of known clock rates.
+/* Line6 Helix series and the Rode Rodecaster Pro don't support the
+ * UAC2_CS_RANGE usb function call. Return a static table of known
+ * clock rates.
  */
 static int line6_parse_audio_format_rates_quirk(struct snd_usb_audio *chip,
 						struct audioformat *fp)
@@ -408,6 +409,7 @@ static int line6_parse_audio_format_rates_quirk(struct snd_usb_audio *chip,
 	case USB_ID(0x0e41, 0x4248): /* Line6 Helix >= fw 2.82 */
 	case USB_ID(0x0e41, 0x4249): /* Line6 Helix Rack >= fw 2.82 */
 	case USB_ID(0x0e41, 0x424a): /* Line6 Helix LT >= fw 2.82 */
+	case USB_ID(0x19f7, 0x0011): /* Rode Rodecaster Pro */
 		return set_fixed_rate(fp, 48000, SNDRV_PCM_RATE_48000);
 	}
 
-- 
2.25.1

