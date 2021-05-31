Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808B739610E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhEaOf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233958AbhEaOdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2D116162E;
        Mon, 31 May 2021 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468982;
        bh=vWzu84KDPR4m9KQqki4TpwcoGMXj2QMHBkh1UmR+CQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=If5PGxTjD0+H0/QBmHlXNj8+1YUTEYoOUujgex+WWoVZcuKM9sGhGPVllXPcAfbHe
         mf5Zbx99zWdswXSkjftOdh46JWBKtM4O9u6B7Hoq/i5I6g7LakcKQ9D84li63ux31h
         YaugPRbjlsaq9hFRTkquoLRrm1DRZPNGtyfywHH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Geoffrey D. Bennett" <g@b4.vu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 009/296] ALSA: usb-audio: scarlett2: Fix device hang with ehci-pci
Date:   Mon, 31 May 2021 15:11:04 +0200
Message-Id: <20210531130704.079909413@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoffrey D. Bennett <g@b4.vu>

commit 764fa6e686e0107c0357a988d193de04cf047583 upstream.

Use usb_rcvctrlpipe() not usb_sndctrlpipe() for USB control input in
the Scarlett Gen 2 mixer driver. This fixes the device hang during
initialisation when used with the ehci-pci host driver.

Fixes: 9e4d5c1be21f ("ALSA: usb-audio: Scarlett Gen 2 mixer interface")
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/66a3d05dac325d5b53e4930578e143cef1f50dbe.1621584566.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett_gen2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -635,7 +635,7 @@ static int scarlett2_usb(
 	/* send a second message to get the response */
 
 	err = snd_usb_ctl_msg(mixer->chip->dev,
-			usb_sndctrlpipe(mixer->chip->dev, 0),
+			usb_rcvctrlpipe(mixer->chip->dev, 0),
 			SCARLETT2_USB_VENDOR_SPECIFIC_CMD_RESP,
 			USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
 			0,


