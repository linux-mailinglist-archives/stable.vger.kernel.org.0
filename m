Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20F838C856
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 15:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbhEUNj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 09:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236214AbhEUNjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 09:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 218C3610CB;
        Fri, 21 May 2021 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621604272;
        bh=Iyc54z2GL+y1O/CEr+PlPVkGPRLHa2YqH4M20ibrNpo=;
        h=From:To:Cc:Subject:Date:From;
        b=s6SEzprvCGMKKMNV6Q8mk1MmEvbc0U5Dy4KNagStbTUmpirTUiuXaYeWlXOL2hIe/
         +1gJImR5q0D7msX4YN+/IXgkMCe8ke3dHBraCC1omlrE9UwcVsc/TKojXUtM9YChNg
         8QekZeLdXWNuEaPit5s9efY89T6TLbL2QXVCZ4hDFnvSXxvadVT0gtkAOOtRxSenkP
         xrNzKMxszjeoZxGRrSrOCzRUeepn5S4Fbg5Mc2F3yB4Sa7ORv7jxFMFT97T03DVgpC
         0UFX0yragJgGvh5ZxDr3rG4l8RxSim7uvdvpI5k3DREYAZavJC1ObN4bWQPXw5qqI9
         /D9eJStattLgw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lk5Ld-0004ig-5f; Fri, 21 May 2021 15:37:53 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Takashi Iwai <tiwai@suse.com>
Cc:     Jaroslav Kysela <perex@perex.cz>, "Geoffrey D. Bennett" <g@b4.vu>,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: usb-audio: fix control-request direction
Date:   Fri, 21 May 2021 15:37:42 +0200
Message-Id: <20210521133742.18098-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the UAC2_CS_CUR request which erroneously used usb_sndctrlpipe().

Fixes: 93db51d06b32 ("ALSA: usb-audio: Check valid altsetting at parsing rates for UAC2/3")
Cc: stable@vger.kernel.org      # 5.10
Signed-off-by: Johan Hovold <johan@kernel.org>
---

There's a related bug in sound/usb/mixer_scarlett_gen2.c, which
Geoffrey reported and said he was preparing a patch for here:

	https://lore.kernel.org/r/20210520180819.GA95348@m.b4.vu

Johan


 sound/usb/format.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index e6ff317a6785..2287f8c65315 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -436,7 +436,7 @@ static bool check_valid_altsetting_v2v3(struct snd_usb_audio *chip, int iface,
 	if (snd_BUG_ON(altsetting >= 64 - 8))
 		return false;
 
-	err = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), UAC2_CS_CUR,
+	err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0), UAC2_CS_CUR,
 			      USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
 			      UAC2_AS_VAL_ALT_SETTINGS << 8,
 			      iface, &raw_data, sizeof(raw_data));
-- 
2.26.3

