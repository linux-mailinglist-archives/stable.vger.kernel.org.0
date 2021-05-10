Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA27D3788C3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhEJLXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237292AbhEJLLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E07736191B;
        Mon, 10 May 2021 11:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644924;
        bh=dRcBh40usbpUAMrJQwi6LYe34sL2xU+NSNEIES2cWn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtR+UV/lOppiIWyJBHI346NEwL7kFppofYHCX89uybS665dgMKvYYAJXPV0lv5ya/
         CIUfRueA+KZ1pgU5qi7o0wy1F3yeKODu7w/GNLENFQILVYMqZxiuuEJocz8G9xxNTa
         a7volYni0WeDP/jakiZoYLOBARcvV0k0NWjc4Wak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Loone <sami@loone.fi>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 280/384] ALSA: hda/realtek: fix static noise on ALC285 Lenovo laptops
Date:   Mon, 10 May 2021 12:21:09 +0200
Message-Id: <20210510102024.053423408@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Loone <sami@loone.fi>

commit 9bbb94e57df135ef61bef075d9c99b8d9e89e246 upstream.

Remove a duplicate vendor+subvendor pin fixup entry as one is masking
the other and making it unreachable. Consider the more specific newcomer
as a second chance instead.

The generic entry is made less strict to also match for laptops with
slightly different 0x12 pin configuration. Tested on Lenovo Yoga 6 (AMD)
where 0x12 is 0x40000000.

Fixes: 607184cb1635 ("ALSA: hda/realtek - Add supported for more Lenovo ALC285 Headset Button")
Signed-off-by: Sami Loone <sami@loone.fi>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YIXS+GT/dGI/LtK6@yoga
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8774,12 +8774,7 @@ static const struct snd_hda_pin_quirk al
 		{0x12, 0x90a60130},
 		{0x19, 0x03a11020},
 		{0x21, 0x0321101f}),
-	SND_HDA_PIN_QUIRK(0x10ec0285, 0x17aa, "Lenovo", ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
-		{0x14, 0x90170110},
-		{0x19, 0x04a11040},
-		{0x21, 0x04211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0285, 0x17aa, "Lenovo", ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
-		{0x12, 0x90a60130},
 		{0x14, 0x90170110},
 		{0x19, 0x04a11040},
 		{0x21, 0x04211020}),
@@ -8950,6 +8945,10 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1028, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
 		{0x19, 0x40000000},
 		{0x1a, 0x40000000}),
+	SND_HDA_PIN_QUIRK(0x10ec0285, 0x17aa, "Lenovo", ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
+		{0x14, 0x90170110},
+		{0x19, 0x04a11040},
+		{0x21, 0x04211020}),
 	{}
 };
 


