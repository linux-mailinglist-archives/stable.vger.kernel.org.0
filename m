Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9031B677B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgDWXGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50056 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728505AbgDWXGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkva-0004nQ-Rd; Fri, 24 Apr 2020 00:06:43 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvW-00E6wQ-BW; Fri, 24 Apr 2020 00:06:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>, "Takashi Iwai" <tiwai@suse.de>
Date:   Fri, 24 Apr 2020 00:06:49 +0100
Message-ID: <lsq.1587683028.231757896@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 182/245] ALSA: usb-audio: fix sync-ep altsetting
 sanity check
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20200114083953.1106-1-johan@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -368,7 +368,7 @@ static int set_sync_ep_implicit_fb_quirk
 add_sync_ep_from_ifnum:
 	iface = usb_ifnum_to_if(dev, ifnum);
 
-	if (!iface || iface->num_altsetting == 0)
+	if (!iface || iface->num_altsetting < 2)
 		return -EINVAL;
 
 	alts = &iface->altsetting[1];

