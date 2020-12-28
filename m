Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35B62E3FE1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506451AbgL1Ope (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:45:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503078AbgL1OYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5EA920791;
        Mon, 28 Dec 2020 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165454;
        bh=yL8ZHZoVvO8rzAeXC+96qAJNaHQRNIO6xL/3dhCPU7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQg2G0UgKNQW2G61yg2mMgmKFA0PyozmtEIHm4W+Po3Gac4wCZCRpVxYp6GuLsxwa
         V4yYIkmRqZbiISF2Jijnlfw23l+YoJu9Yy2Vw3FWR/s5/hppHR0HywMTGmQMnU8qaV
         D3KKJEvNyRfbHTP7ARX92+eMS/jtdihOr/Pfv9AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 537/717] ALSA: hda/realtek: make bass spk volume adjustable on a yoga laptop
Date:   Mon, 28 Dec 2020 13:48:55 +0100
Message-Id: <20201228125046.693352487@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit c72b9bfe0f914639cc475585f45722a3eb57a56d upstream.

This change could fix 2 issues on this machine:
 - the bass speaker's output volume can't be adjusted, that is because
   the bass speaker is routed to the DAC (Nid 0x6) which has no volume
   control.
 - after plugging a headset with vol+, vol- and pause buttons on it,
   press those buttons, nothing happens, this means those buttons
   don't work at all. This machine has alc287 codec, need to add the
   codec id to the disable/enable_headset_jack_key(), then the headset
   button could work.

The quirk of ALC285_FIXUP_THINKPAD_HEADSET_JACK could fix both of these
2 issues.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20201205051130.8122-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3104,6 +3104,7 @@ static void alc_disable_headset_jack_key
 	case 0x10ec0215:
 	case 0x10ec0225:
 	case 0x10ec0285:
+	case 0x10ec0287:
 	case 0x10ec0295:
 	case 0x10ec0289:
 	case 0x10ec0299:
@@ -3130,6 +3131,7 @@ static void alc_enable_headset_jack_key(
 	case 0x10ec0215:
 	case 0x10ec0225:
 	case 0x10ec0285:
+	case 0x10ec0287:
 	case 0x10ec0295:
 	case 0x10ec0289:
 	case 0x10ec0299:
@@ -8578,6 +8580,11 @@ static const struct snd_hda_pin_quirk al
 		{0x14, 0x90170110},
 		{0x19, 0x04a11040},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0287, 0x17aa, "Lenovo", ALC285_FIXUP_THINKPAD_HEADSET_JACK,
+		{0x14, 0x90170110},
+		{0x17, 0x90170111},
+		{0x19, 0x03a11030},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0286, 0x1025, "Acer", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE,
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},


