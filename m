Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A14344126
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhCVMbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231181AbhCVMar (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F238D619A0;
        Mon, 22 Mar 2021 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416247;
        bh=6Odjv0BGUfVmqIuSNmD1m0vv9DcjMHPVid+ivTgBQ60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhNLCTJ3S8k1EQl38kl9cIe+ZFR6B8bEavmWpjddrPdYyRru6MJ/DZsFp7gRdWlqk
         a6OwdABXNzps2p+OGtVyGFymDpzWtfdBYHjPk4VgScrIamjRtnTgXtDRYvcYL/b4hs
         yMFBb3RDjQE1pq+dZjfRsZqGeRWfoP+s3/Mx5xxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 006/120] ALSA: hda: generic: Fix the micmute led init state
Date:   Mon, 22 Mar 2021 13:26:29 +0100
Message-Id: <20210322121929.876223206@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 2bf44e0ee95f39cc54ea1b942f0a027e0181ca4e upstream.

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
Link: https://lore.kernel.org/r/20210312041408.3776-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -4065,7 +4065,7 @@ static int add_micmute_led_hook(struct h
 
 	spec->micmute_led.led_mode = MICMUTE_LED_FOLLOW_MUTE;
 	spec->micmute_led.capture = 0;
-	spec->micmute_led.led_value = 0;
+	spec->micmute_led.led_value = -1;
 	spec->micmute_led.old_hook = spec->cap_sync_hook;
 	spec->cap_sync_hook = update_micmute_led;
 	if (!snd_hda_gen_add_kctl(spec, NULL, &micmute_led_mode_ctl))


