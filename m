Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC5227C66F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgI2LpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730681AbgI2LpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8294C206F7;
        Tue, 29 Sep 2020 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379911;
        bh=wE7g3lASwSKxTuhQWL+5oICRP/xl1sIjNRZaIz3PN84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yW7I0jlOiZhbXCUjeXqebH1i8L67gHUC8wBo0J3c6f5FVxQ9dg6EX+iynRner4zBp
         eXPur+lEzdxS5leo+tN7vKcjq00FwbyfW7u/zhTT9SDqU0vNlgFPRMmQ3+0Av3utXh
         1VGRZ/lD1fXZl8aXffrM8rhPkEa5ZDTe01mXvI80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 371/388] ALSA: hda/realtek - Couldnt detect Mic if booting with headset plugged
Date:   Tue, 29 Sep 2020 13:01:42 +0200
Message-Id: <20200929110028.426039763@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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
@@ -3418,7 +3418,11 @@ static void alc256_shutup(struct hda_cod
 
 	/* 3k pull low control for Headset jack. */
 	/* NOTE: call this before clearing the pin, otherwise codec stalls */
-	alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
+	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
+	 * when booting with headset plugged. So skip setting it for the codec alc257
+	 */
+	if (codec->core.vendor_id != 0x10ec0257)
+		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	if (!spec->no_shutup_pins)
 		snd_hda_codec_write(codec, hp_pin, 0,


