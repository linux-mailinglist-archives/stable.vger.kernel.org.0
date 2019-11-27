Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBED10BF6D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfK0Uiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbfK0Uit (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:38:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCA8021555;
        Wed, 27 Nov 2019 20:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887129;
        bh=5dB7ozyKoi/M5ntKoqDhWKGmzdvlVlMFbQ5HSRIXi3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+npvHSryn9x190Ni+IrU6TYZXMU4BSAadaPyV9ZXO00eZuIEtuSLLdpKoeKzNKre
         EWr0+gzHo/zWAM3anCzIXVqK7mzoVeno5o1ByKCu3rrEjlqOiwTNHB1zuHF0FkJn8A
         ryz1qxeDWXQj7KQJTRy05h5w6uVOFuryhfEyEuzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 125/132] USB: serial: mos7720: fix remote wakeup
Date:   Wed, 27 Nov 2019 21:31:56 +0100
Message-Id: <20191127203033.186728038@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
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
@@ -1941,10 +1941,6 @@ static int mos7720_startup(struct usb_se
 		}
 	}
 
-	/* setting configuration feature to one */
-	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
-
 #ifdef CONFIG_USB_SERIAL_MOS7715_PARPORT
 	if (product == MOSCHIP_DEVICE_ID_7715) {
 		ret_val = mos7715_parport_init(serial);


