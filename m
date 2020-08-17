Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1711F246A80
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgHQPh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730188AbgHQPhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:37:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E12BE23120;
        Mon, 17 Aug 2020 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678639;
        bh=RPEiQDy6a3Jp0/Ow1vYnPqNQ//IIH6hyciHaIjsqhoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avsa6ZDi/p0b8Vzaeo3rD4HYjxsNNfwo9SNa4kLqHtuqzM8s1AmyFlERjRVJQ+Wze
         m3Ul3ibg3XlHJuWj6qMNVEz7dZw0ozbyPp7B0GsT6y0J8sZrQOt6IpL6joxFCObCdk
         4I6xu8edythlOJ60c4AY12p1J+01NBf2NFmJzu8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 5.8 403/464] ALSA: hda - reverse the setting value in the micmute_led_set
Date:   Mon, 17 Aug 2020 17:15:56 +0200
Message-Id: <20200817143853.084754257@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 404690649e6a52ee39817168f2d984726412e091 upstream.

Before the micmute_led_set() is introduced, the function of
alc_gpio_micmute_update() will set the gpio value with the
!micmute_led.led_value, and the machines have the correct micmute led
status. After the micmute_led_set() is introduced, it sets the gpio
value with !!micmute_led.led_value, so the led status is not correct
anymore, we need to set micmute_led_polarity = 1 to workaround it.

Now we fix the micmute_led_set() and remove micmute_led_polarity = 1.

Fixes: 87dc36482cab ("ALSA: hda/realtek - Add LED class support for micmute LED")
Reported-and-suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200811122430.6546-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4118,7 +4118,7 @@ static int micmute_led_set(struct led_cl
 	struct alc_spec *spec = codec->spec;
 
 	alc_update_gpio_led(codec, spec->gpio_mic_led_mask,
-			    spec->micmute_led_polarity, !!brightness);
+			    spec->micmute_led_polarity, !brightness);
 	return 0;
 }
 
@@ -4173,8 +4173,6 @@ static void alc285_fixup_hp_gpio_led(str
 {
 	struct alc_spec *spec = codec->spec;
 
-	spec->micmute_led_polarity = 1;
-
 	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x01);
 }
 
@@ -4426,7 +4424,6 @@ static void alc233_fixup_lenovo_line2_mi
 {
 	struct alc_spec *spec = codec->spec;
 
-	spec->micmute_led_polarity = 1;
 	alc_fixup_hp_gpio_led(codec, action, 0, 0x04);
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->init_amp = ALC_INIT_DEFAULT;


