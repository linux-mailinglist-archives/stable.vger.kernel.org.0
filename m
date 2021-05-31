Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B5A395FBA
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhEaOP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233289AbhEaOMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11F8F61460;
        Mon, 31 May 2021 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468492;
        bh=vWzu84KDPR4m9KQqki4TpwcoGMXj2QMHBkh1UmR+CQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lo02YeEVf5SLwTtwwJUiKyF8QplkTYrv+SAoO3eZo0HOsPVgGVbWyaPj/HBtTkm6h
         OtFzM4cq9o5rrlTdrXSHCFMVSZTfgCrj42jNbp0+7tzLkSwmfZC7uIjRDMnqVmLB4B
         QYHGfYmUOFr/76l1w0YeqsIeb5U1P7JgKNXHor+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Geoffrey D. Bennett" <g@b4.vu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 002/177] ALSA: usb-audio: scarlett2: Fix device hang with ehci-pci
Date:   Mon, 31 May 2021 15:12:39 +0200
Message-Id: <20210531130647.977054036@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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


