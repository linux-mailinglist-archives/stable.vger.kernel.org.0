Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B8A144FEB
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387689AbgAVJmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:42:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387707AbgAVJmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94BE24680;
        Wed, 22 Jan 2020 09:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686143;
        bh=0Wy9QmnyEf2wGDNA62BLUT9kBGOueblak1F7BeV4wCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzkWbOj2XX0WUD4M9bYdCqNCl3REx/GzGmT4WxauE0MFNUYJpzq+HErzGWnoCgtvO
         kl7jDBhT8gfI2Vc1a5D2D5+dRWQHN+9G+KReSbMbnM70ZoGyDJYBiHdAdDNYwFRgRW
         wsMyAHKpEs0SrxanFSliodnTMzG3eeTyLlS5joZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 025/103] ALSA: usb-audio: fix sync-ep altsetting sanity check
Date:   Wed, 22 Jan 2020 10:28:41 +0100
Message-Id: <20200122092807.578377802@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 5d1b71226dc4d44b4b65766fa9d74492f9d4587b upstream.

The altsetting sanity check in set_sync_ep_implicit_fb_quirk() was
checking for there to be at least one altsetting but then went on to
access the second one, which may not exist.

This could lead to random slab data being used to initialise the sync
endpoint in snd_usb_add_endpoint().

Fixes: c75a8a7ae565 ("ALSA: snd-usb: add support for implicit feedback")
Fixes: ca10a7ebdff1 ("ALSA: usb-audio: FT C400 sync playback EP to capture EP")
Fixes: 5e35dc0338d8 ("ALSA: usb-audio: add implicit fb quirk for Behringer UFX1204")
Fixes: 17f08b0d9aaf ("ALSA: usb-audio: add implicit fb quirk for Axe-Fx II")
Fixes: 103e9625647a ("ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk")
Cc: stable <stable@vger.kernel.org>     # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20200114083953.1106-1-johan@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -377,7 +377,7 @@ static int set_sync_ep_implicit_fb_quirk
 add_sync_ep_from_ifnum:
 	iface = usb_ifnum_to_if(dev, ifnum);
 
-	if (!iface || iface->num_altsetting == 0)
+	if (!iface || iface->num_altsetting < 2)
 		return -EINVAL;
 
 	alts = &iface->altsetting[1];


