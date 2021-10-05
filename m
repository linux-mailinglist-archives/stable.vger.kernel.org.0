Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CAC4225B4
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 13:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbhJELw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 07:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhJELw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 07:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA97461216;
        Tue,  5 Oct 2021 11:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633434638;
        bh=qCZsoiGSjMxYKFZL1lUKhtRqisvbsLub7fwNLsS+/cg=;
        h=Subject:To:From:Date:From;
        b=jHIMmCtJUbMAFriNi4p3Pw7dX304zysJoojkbdJN2fl3oMmJiaAaSM6qJNpUdhxSM
         j6CKCmBzYDD1idscj4u2SYMVLA2VLGJcYtwOizTaP0rLW4nu+jUCdIHoF2MmRb7o1O
         Hxzd+Cfp6InzBksp4GbRB7wsyuMs3wUOwhCECbDY=
Subject: patch "usb: gadget: f_uac2: fixed EP-IN wMaxPacketSize" added to usb-linus
To:     pavel.hofman@ivitera.com, gregkh@linuxfoundation.org,
        henrik.enquist@gmail.com, jackp@codeaurora.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 13:50:36 +0200
Message-ID: <163343463622069@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_uac2: fixed EP-IN wMaxPacketSize

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0560c9c552c1815e7b480bc11fd785fefc82bb27 Mon Sep 17 00:00:00 2001
From: Pavel Hofman <pavel.hofman@ivitera.com>
Date: Fri, 24 Sep 2021 10:00:27 +0200
Subject: usb: gadget: f_uac2: fixed EP-IN wMaxPacketSize

Async feedback patches broke enumeration on Windows 10 previously fixed
by commit 789ea77310f0 ("usb: gadget: f_uac2: always increase endpoint
max_packet_size by one audio slot").

While the existing calculation for EP OUT capture for async mode yields
size+1 frame due to uac2_opts->fb_max > 0, playback side lost the +1
feature.  Therefore the +1 frame addition must be re-introduced for
playback. Win10 enumerates the device only when both EP IN and EP OUT
max packet sizes are (at least) +1 frame.

Fixes: e89bb4288378 ("usb: gadget: u_audio: add real feedback implementation")
Cc: stable <stable@vger.kernel.org>
Tested-by: Henrik Enquist <henrik.enquist@gmail.com>
Tested-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Link: https://lore.kernel.org/r/20210924080027.5362-1-pavel.hofman@ivitera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index be864560bfea..ef55b8bb5870 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -674,11 +674,17 @@ static int set_ep_max_packet_size(const struct f_uac2_opts *uac2_opts,
 		ssize = uac2_opts->c_ssize;
 	}
 
-	if (!is_playback && (uac2_opts->c_sync == USB_ENDPOINT_SYNC_ASYNC))
+	if (!is_playback && (uac2_opts->c_sync == USB_ENDPOINT_SYNC_ASYNC)) {
+	  // Win10 requires max packet size + 1 frame
 		srate = srate * (1000 + uac2_opts->fb_max) / 1000;
-
-	max_size_bw = num_channels(chmask) * ssize *
-		DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1)));
+		// updated srate is always bigger, therefore DIV_ROUND_UP always yields +1
+		max_size_bw = num_channels(chmask) * ssize *
+			(DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1))));
+	} else {
+		// adding 1 frame provision for Win10
+		max_size_bw = num_channels(chmask) * ssize *
+			(DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1))) + 1);
+	}
 	ep_desc->wMaxPacketSize = cpu_to_le16(min_t(u16, max_size_bw,
 						    max_size_ep));
 
-- 
2.33.0


