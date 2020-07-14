Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DFB21FA5E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgGNSwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbgGNSv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:51:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC0E22B3B;
        Tue, 14 Jul 2020 18:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752718;
        bh=I70nf84rWZrSCLQ2NFeB75EIdPZPnGNrLbNIid3wd1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/dkTnwpe40p6KDVBXvCr4DjHEBy+1swiDschdbHXB+bmqFarXBzOSg2CQlmV0SDB
         nRNQjd7IosL3sgAWHQNwFf0AyZvb7O7RXzcWNpTCOXsaKWC6IvS0dqavyJ7B5pffn5
         KWZGSs2GBi7pCm8/vcmD1h1zaDmMPH9hptx/NQaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Kailang Yang <kailang@realtek.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Even Brenden <evenbrenden@gmail.com>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 076/109] ALSA: hda/realtek - Fix Lenovo Thinkpad X1 Carbon 7th quirk subdevice id
Date:   Tue, 14 Jul 2020 20:44:19 +0200
Message-Id: <20200714184109.182219719@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Poirier <benjamin.poirier@gmail.com>

commit 9774dc218bb628974dcbc76412f970e9258e5f27 upstream.

1)
In snd_hda_pick_fixup(), quirks are first matched by PCI SSID and then, if
there is no match, by codec SSID. The Lenovo "ThinkPad X1 Carbon 7th" has
an audio chip with PCI SSID 0x2292 and codec SSID 0x2293[1]. Therefore, fix
the quirk meant for that device to match on .subdevice == 0x2292.

2)
The "Thinkpad X1 Yoga 7th" does not exist. The companion product to the
Carbon 7th is the Yoga 4th. That device has an audio chip with PCI SSID
0x2292 and codec SSID 0x2292[2]. Given the behavior of
snd_hda_pick_fixup(), it is not possible to have a separate quirk for the
Yoga based on SSID. Therefore, merge the quirks meant for the Carbon and
Yoga. This preserves the current behavior for the Yoga.

[1] This is the case on my own machine and can also be checked here
https://github.com/linuxhw/LsPCI/tree/master/Notebook/Lenovo/ThinkPad
https://gist.github.com/hamidzr/dd81e429dc86f4327ded7a2030e7d7d9#gistcomment-3225701
[2]
https://github.com/linuxhw/LsPCI/tree/master/Convertible/Lenovo/ThinkPad
https://gist.github.com/hamidzr/dd81e429dc86f4327ded7a2030e7d7d9#gistcomment-3176355

Fixes: d2cd795c4ece ("ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen")
Fixes: 54a6a7dc107d ("ALSA: hda/realtek - Add quirk for the bass speaker on Lenovo Yoga X1 7th gen")
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Kailang Yang <kailang@realtek.com>
Tested-by: Vincent Bernat <vincent@bernat.ch>
Tested-by: Even Brenden <evenbrenden@gmail.com>
Signed-off-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200703080005.8942-2-benjamin.poirier@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7536,8 +7536,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x224c, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x224d, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x225d, "Thinkpad T480", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Yoga 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
-	SND_PCI_QUIRK(0x17aa, 0x2293, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
+	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x22be, "Thinkpad X1 Carbon 8th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x30bb, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x30e2, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),


