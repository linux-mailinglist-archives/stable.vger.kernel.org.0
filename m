Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D828710BBFD
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732959AbfK0VMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732768AbfK0VMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:12:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49BA72176D;
        Wed, 27 Nov 2019 21:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889150;
        bh=29b7VrHROTMlit8ERvOnu2DmGqWVGdm3/WYYa9MMMK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GM1xUhjP8SUBqc1cILdIpDGVFMKph66tzBFcLcUxBBr+fX8+gcAKmOiY+vUJyzFMy
         /TOFWGv4ZZYPIAsL09g+z4Hc9d4RgUERnriouonmDK3Xtd/aGFbeGykSW7tYQEYq/R
         Rra3aSCCCBU9ZhuSGQdpMjPQq3cRvvoFhyvBQix4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 88/95] USB: serial: mos7720: fix remote wakeup
Date:   Wed, 27 Nov 2019 21:32:45 +0100
Message-Id: <20191127202957.096500648@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit ea422312a462696093b5db59d294439796cba4ad upstream.

The driver was setting the device remote-wakeup feature during probe in
violation of the USB specification (which says it should only be set
just prior to suspending the device). This could potentially waste
power during suspend as well as lead to spurious wakeups.

Note that USB core would clear the remote-wakeup feature at first
resume.

Fixes: 0f64478cbc7a ("USB: add USB serial mos7720 driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7720.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1833,10 +1833,6 @@ static int mos7720_startup(struct usb_se
 	product = le16_to_cpu(serial->dev->descriptor.idProduct);
 	dev = serial->dev;
 
-	/* setting configuration feature to one */
-	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
-
 	if (product == MOSCHIP_DEVICE_ID_7715) {
 		struct urb *urb = serial->port[0]->interrupt_in_urb;
 


