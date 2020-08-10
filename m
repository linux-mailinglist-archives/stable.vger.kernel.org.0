Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C0A2400C5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 04:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHJCRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 22:17:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38149 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgHJCRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Aug 2020 22:17:18 -0400
Received: from [114.253.245.60] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1k4xND-0004kJ-HA; Mon, 10 Aug 2020 02:17:16 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH] ALSA: hda - fix the micmute led status for Lenovo ThinkCentre AIO
Date:   Mon, 10 Aug 2020 10:16:59 +0800
Message-Id: <20200810021659.7429-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After installing the Ubuntu Linux, the micmute led status is not
correct. Users expect that the led is on if the capture is disabled,
but with the current kernel, the led is off with the capture disabled.

We tried the old linux kernel like linux-4.15, there is no this issue.
It looks like we introduced this issue when switching to the led_cdev.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index daedcc0adc21..09d93dd88713 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4414,6 +4414,7 @@ static void alc233_fixup_lenovo_line2_mic_hotkey(struct hda_codec *codec,
 {
 	struct alc_spec *spec = codec->spec;
 
+	spec->micmute_led_polarity = 1;
 	alc_fixup_hp_gpio_led(codec, action, 0, 0x04);
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->init_amp = ALC_INIT_DEFAULT;
-- 
2.17.1

