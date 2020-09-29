Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2378527CCEC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgI2Mka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729248AbgI2LOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A63B20848;
        Tue, 29 Sep 2020 11:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378090;
        bh=ZAE7QSARf1WPP7/bAdPuERVxfF2+6yJ1LQxVf2+g+40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwIae0jdNBRh7j6ft2acevEAWsHR4dZu0wctUpG2/k4SEqv4/jYRDV9MRfH5d4VJ5
         lWJvzSeFQAM82vYO/6ICsckjxNGJZwpTxwQBZlFLnEG2zgSvnT8dy5uCEGxVhytf7U
         0BY3mqb3ShtwFLoVYs0EEMTRAw0sX5cl95N2rgT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 027/166] ALSA: hda/realtek - Couldnt detect Mic if booting with headset plugged
Date:   Tue, 29 Sep 2020 12:58:59 +0200
Message-Id: <20200929105936.557926254@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 3f74249057827c5f6676c41c18f6be12ce1469ce upstream.

We found a Mic detection issue on many Lenovo laptops, those laptops
belong to differnt models and they have different audio design like
internal mic connects to the codec or PCH, they all have this problem,
the problem is if plugging a headset before powerup/reboot the
machine, after booting up, the headphone could be detected but Mic
couldn't. If we plug out and plug in the headset, both headphone and
Mic could be detected then.

Through debugging we found the codec on those laptops are same, it is
alc257, and if we don't disable the 3k pulldown in alc256_shutup(),
the issue will be fixed. So far there is no pop noise or power
consumption regression on those laptops after this change.

Cc: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200914065118.19238-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3154,7 +3154,11 @@ static void alc256_shutup(struct hda_cod
 
 	/* 3k pull low control for Headset jack. */
 	/* NOTE: call this before clearing the pin, otherwise codec stalls */
-	alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
+	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
+	 * when booting with headset plugged. So skip setting it for the codec alc257
+	 */
+	if (codec->core.vendor_id != 0x10ec0257)
+		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	snd_hda_codec_write(codec, hp_pin, 0,
 			    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);


