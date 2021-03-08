Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2B033109C
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 15:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCHOSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 09:18:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhCHORv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 09:17:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74C1A651DC;
        Mon,  8 Mar 2021 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615213071;
        bh=bbJ8xQ3WsjO8SPu1v/qIq8sFj3R7RRhcRN2GqnIJC6k=;
        h=Subject:To:From:Date:From;
        b=Kbh+4wvdJZYVRBEV6vdB/aBwvruP7oNQqh/xeqpBtfbGOR5rQwiDpcHyQ1xSMzTyf
         k2ictShWj3Jtgg6Hr9MUwUbhsZWjn9NKSlwE2R6YyRg/5nnmF7Hg0q6rkbYiGA4d2I
         xNF4TqD8h9vRhqqdsDj0D1Sdn+bwld2NASGAl6Qc=
Subject: patch "usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other" added to usb-linus
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Mar 2021 15:17:38 +0100
Message-ID: <16152130589320@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 25af815a5e7369ff592812907c83d8ca435fc1ed Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Mon, 8 Mar 2021 10:55:38 +0900
Subject: usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other
 EPNUM

According to the datasheet, this controller has a restriction
which "set an endpoint number so that combinations of the DIR bit and
the EPNUM bits do not overlap.". However, since the udc core driver is
possible to assign a bulk pipe as an interrupt endpoint, an endpoint
number may not match the pipe number. After that, when user rebinds
another gadget driver, this driver broke the restriction because
the driver didn't clear any configuration in usb_ep_disable().

Example:
 # modprobe g_ncm
 Then, EP3 = pipe 3, EP4 = pipe 4, EP5 = pipe 6
 # rmmod g_ncm
 # modprobe g_hid
 Then, EP3 = pipe 6, EP4 = pipe 7.
 So, pipe 3 and pipe 6 are set as EP3.

So, clear PIPECFG register in usbhs_pipe_free().

Fixes: dfb87b8bfe09 ("usb: renesas_usbhs: gadget: fix re-enabling pipe without re-connecting")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1615168538-26101-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/pipe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/renesas_usbhs/pipe.c b/drivers/usb/renesas_usbhs/pipe.c
index e7334b7fb3a6..75fff2e4cbc6 100644
--- a/drivers/usb/renesas_usbhs/pipe.c
+++ b/drivers/usb/renesas_usbhs/pipe.c
@@ -746,6 +746,8 @@ struct usbhs_pipe *usbhs_pipe_malloc(struct usbhs_priv *priv,
 
 void usbhs_pipe_free(struct usbhs_pipe *pipe)
 {
+	usbhsp_pipe_select(pipe);
+	usbhsp_pipe_cfg_set(pipe, 0xFFFF, 0);
 	usbhsp_put_pipe(pipe);
 }
 
-- 
2.30.1


