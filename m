Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2893C2F65
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhGJCbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234511AbhGJC3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D53C9613EE;
        Sat, 10 Jul 2021 02:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883999;
        bh=zmj9WyXtSseTTgocPzLouGUl1hEY6kvuM9oHZQw1Zo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ux+AGM/Z1a/f058sCC2JKDfTVm/TfLnr3BXKa2cu8ovqQ3wn+HU9YHBFWcGzuhZ+l
         /1dDwkK+GiV4cwRwFi/LrsMcP7Jy845+Bgi2y3hgZjJz4QF7tOOcF17xhzxrhXHSN3
         YctEG+44V3F2KuWkmWN7jAG1g0ni/dwQyepb9l9O30UlToi0CNuM5xv4/wbTLzjwVE
         Gp92JLMQJVpJiKcdDh9TAKs6rI/GTXOqA7SCftLpBjIU5M0IXRL4ZVlIWR+I++aqfB
         1fpkr0gE2RyfVl92Ho0uxHo170XhPkLNiYCUaSCCw/U0yjsg5pOlN5rWbPiBJyXHTp
         Q8y5omZ95tKqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Daniel Jozsef <daniel.jozsef@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 74/93] ALSA: bebob: add support for ToneWeal FW66
Date:   Fri,  9 Jul 2021 22:24:08 -0400
Message-Id: <20210710022428.3169839-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 50ebe56222bfa0911a932930f9229ee5995508d9 ]

A user of FFADO project reported the issue of ToneWeal FW66. As a result,
the device is identified as one of applications of BeBoB solution.

I note that in the report the device returns contradictory result in plug
discovery process for audio subunit. Fortunately ALSA BeBoB driver doesn't
perform it thus it's likely to handle the device without issues.

I receive no reaction to test request for this patch yet, however it would
be worth to add support for it.

daniel@gibbonmoon:/sys/bus/firewire/devices/fw1$ grep -r . *
Binary file config_rom matches
dev:244:1
guid:0x0023270002000000
hardware_version:0x000002
is_local:0
model:0x020002
model_name:FW66
power/runtime_active_time:0
power/runtime_active_kids:0
power/runtime_usage:0
power/runtime_status:unsupported
power/async:disabled
power/runtime_suspended_time:0
power/runtime_enabled:disabled
power/control:auto
subsystem/drivers_autoprobe:1
uevent:MAJOR=244
uevent:MINOR=1
uevent:DEVNAME=fw1
units:0x00a02d:0x010001
vendor:0x002327
vendor_name:ToneWeal
fw1.0/uevent:MODALIAS=ieee1394:ven00002327mo00020002sp0000A02Dver00010001
fw1.0/power/runtime_active_time:0
fw1.0/power/runtime_active_kids:0
fw1.0/power/runtime_usage:0
fw1.0/power/runtime_status:unsupported
fw1.0/power/async:disabled
fw1.0/power/runtime_suspended_time:0
fw1.0/power/runtime_enabled:disabled
fw1.0/power/control:auto
fw1.0/model:0x020002
fw1.0/rom_index:15
fw1.0/specifier_id:0x00a02d
fw1.0/model_name:FW66
fw1.0/version:0x010001
fw1.0/modalias:ieee1394:ven00002327mo00020002sp0000A02Dver00010001

Cc: Daniel Jozsef <daniel.jozsef@gmail.com>
Reference: https://lore.kernel.org/alsa-devel/20200119164335.GA11974@workstation/
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210619083922.16060-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/Kconfig       | 1 +
 sound/firewire/bebob/bebob.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/sound/firewire/Kconfig b/sound/firewire/Kconfig
index def1f3d5ecf5..12664c3a1414 100644
--- a/sound/firewire/Kconfig
+++ b/sound/firewire/Kconfig
@@ -110,6 +110,7 @@ config SND_BEBOB
 	  * M-Audio Ozonic/NRV10/ProfireLightBridge
 	  * M-Audio FireWire 1814/ProjectMix IO
 	  * Digidesign Mbox 2 Pro
+	  * ToneWeal FW66
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-bebob.
diff --git a/sound/firewire/bebob/bebob.c b/sound/firewire/bebob/bebob.c
index 90e98a6d1546..67fa0f2178b0 100644
--- a/sound/firewire/bebob/bebob.c
+++ b/sound/firewire/bebob/bebob.c
@@ -59,6 +59,7 @@ static DECLARE_BITMAP(devices_used, SNDRV_CARDS);
 #define VEN_MAUDIO1	0x00000d6c
 #define VEN_MAUDIO2	0x000007f5
 #define VEN_DIGIDESIGN	0x00a07e
+#define OUI_SHOUYO	0x002327
 
 #define MODEL_FOCUSRITE_SAFFIRE_BOTH	0x00000000
 #define MODEL_MAUDIO_AUDIOPHILE_BOTH	0x00010060
@@ -486,6 +487,8 @@ static const struct ieee1394_device_id bebob_id_table[] = {
 			    &maudio_special_spec),
 	/* Digidesign Mbox 2 Pro */
 	SND_BEBOB_DEV_ENTRY(VEN_DIGIDESIGN, 0x0000a9, &spec_normal),
+	// Toneweal FW66.
+	SND_BEBOB_DEV_ENTRY(OUI_SHOUYO, 0x020002, &spec_normal),
 	/* IDs are unknown but able to be supported */
 	/*  Apogee, Mini-ME Firewire */
 	/*  Apogee, Mini-DAC Firewire */
-- 
2.30.2

