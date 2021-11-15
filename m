Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9912451448
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhKOUHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344514AbhKOTYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F3BB63277;
        Mon, 15 Nov 2021 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002739;
        bh=M2YtDN5c5DMIpf+rhEpGDTps8TZEA1RWaTDBl5L9Ey8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxo3yBfld2S2bzRhgBEwjap5koQJxj3MhAq1/5W9vM3s9dHLFwYjMz/hbh7c5hcqU
         ELdN2qkxzdnoAQA3xYYRvknMCektGyVxhx9hPbEjDGvfvcZzMZwxoemPBPSe0xCkwj
         CHbUpqgIiknGi0/Y+s7QreDAtvY57aY5DPxBxWrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 680/917] ALSA: oxfw: fix functional regression for Mackie Onyx 1640i in v5.14 or later
Date:   Mon, 15 Nov 2021 18:02:55 +0100
Message-Id: <20211115165451.955543607@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit cddcd5472abb7b8a9c37ccbcf0908b79740a01b5 ]

A user reports functional regression for Mackie Onyx 1640i that the device
generates slow sound with ALSA oxfw driver which supports media clock
recovery. Although the device is based on OXFW971 ASIC, it does not
transfer isochronous packet with own event frequency as expected. The
device seems to adjust event frequency according to events in received
isochronous packets in the beginning of packet streaming. This is
unknown quirk.

This commit fixes the regression to turn the recovery off in driver
side. As a result, nominal frequency is used in duplex packet streaming
between device and driver. For stability of sampling rate in events of
transferred isochronous packet, 4,000 isochronous packets are skipped
in the beginning of packet streaming.

Reference: https://github.com/takaswie/snd-firewire-improve/issues/38
Fixes: 029ffc429440 ("ALSA: oxfw: perform sequence replay for media clock recovery")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20211028130325.45772-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/oxfw/oxfw-stream.c | 7 ++++++-
 sound/firewire/oxfw/oxfw.c        | 8 ++++++++
 sound/firewire/oxfw/oxfw.h        | 5 +++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/sound/firewire/oxfw/oxfw-stream.c b/sound/firewire/oxfw/oxfw-stream.c
index fff18b5d4e052..f4a702def3979 100644
--- a/sound/firewire/oxfw/oxfw-stream.c
+++ b/sound/firewire/oxfw/oxfw-stream.c
@@ -9,7 +9,7 @@
 #include <linux/delay.h>
 
 #define AVC_GENERIC_FRAME_MAXIMUM_BYTES	512
-#define READY_TIMEOUT_MS	200
+#define READY_TIMEOUT_MS	600
 
 /*
  * According to datasheet of Oxford Semiconductor:
@@ -367,6 +367,11 @@ int snd_oxfw_stream_start_duplex(struct snd_oxfw *oxfw)
 				// Just after changing sampling transfer frequency, many cycles are
 				// skipped for packet transmission.
 				tx_init_skip_cycles = 400;
+			} else if (oxfw->quirks & SND_OXFW_QUIRK_VOLUNTARY_RECOVERY) {
+				// It takes a bit time for target device to adjust event frequency
+				// according to nominal event frequency in isochronous packets from
+				// ALSA oxfw driver.
+				tx_init_skip_cycles = 4000;
 			} else {
 				replay_seq = true;
 			}
diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index daf731364695b..b496f87841aec 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -25,6 +25,7 @@
 #define MODEL_SATELLITE		0x00200f
 #define MODEL_SCS1M		0x001000
 #define MODEL_DUET_FW		0x01dddd
+#define MODEL_ONYX_1640I	0x001640
 
 #define SPECIFIER_1394TA	0x00a02d
 #define VERSION_AVC		0x010001
@@ -192,6 +193,13 @@ static int detect_quirks(struct snd_oxfw *oxfw, const struct ieee1394_device_id
 		// OXFW971-based models may transfer events by blocking method.
 		if (!(oxfw->quirks & SND_OXFW_QUIRK_JUMBO_PAYLOAD))
 			oxfw->quirks |= SND_OXFW_QUIRK_BLOCKING_TRANSMISSION;
+
+		if (model == MODEL_ONYX_1640I) {
+			//Unless receiving packets without NOINFO packet, the device transfers
+			//mostly half of events in packets than expected.
+			oxfw->quirks |= SND_OXFW_QUIRK_IGNORE_NO_INFO_PACKET |
+					SND_OXFW_QUIRK_VOLUNTARY_RECOVERY;
+		}
 	}
 
 	return 0;
diff --git a/sound/firewire/oxfw/oxfw.h b/sound/firewire/oxfw/oxfw.h
index c13034f6c2ca5..d728e451a25c6 100644
--- a/sound/firewire/oxfw/oxfw.h
+++ b/sound/firewire/oxfw/oxfw.h
@@ -47,6 +47,11 @@ enum snd_oxfw_quirk {
 	// the device to process audio data even if the value is invalid in a point of
 	// IEC 61883-1/6.
 	SND_OXFW_QUIRK_IGNORE_NO_INFO_PACKET = 0x10,
+	// Loud Technologies Mackie Onyx 1640i seems to configure OXFW971 ASIC so that it decides
+	// event frequency according to events in received isochronous packets. The device looks to
+	// performs media clock recovery voluntarily. In the recovery, the packets with NO_INFO
+	// are ignored, thus driver should transfer packets with timestamp.
+	SND_OXFW_QUIRK_VOLUNTARY_RECOVERY = 0x20,
 };
 
 /* This is an arbitrary number for convinience. */
-- 
2.33.0



