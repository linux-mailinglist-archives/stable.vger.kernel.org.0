Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9332ED1EA
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbhAGOTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729104AbhAGOR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2292123355;
        Thu,  7 Jan 2021 14:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029021;
        bh=0kSchLY9ai+cWrRhAzU1RAPj7dkBox3EXYv3kQH2Ohc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuH4cu+5k50MS14lzvDP9iJPOqSIJW6NlGOvRywr+6vG5Gh7sLptAGRN+a4FHkVrw
         Y5CVSICbZmuqOydsGrzqA+mRVeXMfP9y8PEWw6WPaxLBFq4Tia1ltTHhJIEFgyikLM
         PfsG4lBFhWAwMC9oM2zxdGeqZtV2YOQ7jwQpNQbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 04/32] ALSA: usb-audio: fix sync-ep altsetting sanity check
Date:   Thu,  7 Jan 2021 15:16:24 +0100
Message-Id: <20210107140828.071957192@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.866214702@linuxfoundation.org>
References: <20210107140827.866214702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 5d1b71226dc4d44b4b65766fa9d74492f9d4587b upstream

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
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -369,7 +369,7 @@ static int set_sync_ep_implicit_fb_quirk
 add_sync_ep_from_ifnum:
 	iface = usb_ifnum_to_if(dev, ifnum);
 
-	if (!iface || iface->num_altsetting == 0)
+	if (!iface || iface->num_altsetting < 2)
 		return -EINVAL;
 
 	alts = &iface->altsetting[1];


