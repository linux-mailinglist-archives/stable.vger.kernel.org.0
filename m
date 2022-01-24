Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802C2499608
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443702AbiAXU6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:58:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48474 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442567AbiAXUyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:54:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9AC360B03;
        Mon, 24 Jan 2022 20:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9B0C340E5;
        Mon, 24 Jan 2022 20:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057690;
        bh=oj5Je4hEdh8UvrPiv7Hw9okiM1qi3n2AsOBeJ6hgeSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtHEGWajK4DjqRe9rNJoSHNxGRWI52ihBw2ANc7uK96kIlILfmNKNacZ9/W+6OYmq
         Af6KjUg56tPpn6nyNK/m+4vZ3n3wwaDf9pPAXOHRzYxWin0S8G+JbmSWdNMGuLExma
         WIpDIk5biCDuH2k7FaWOof/e7hUXNf6GjgXIrlAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.16 0046/1039] media: mceusb: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:30:35 +0100
Message-Id: <20220124184126.692326982@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 16394e998cbb050730536bdf7e89f5a70efbd974 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 66e89522aff7 ("V4L/DVB: IR: add mceusb IR receiver driver")
Cc: stable@vger.kernel.org      # 2.6.36
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/mceusb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1430,7 +1430,7 @@ static void mceusb_gen1_init(struct mceu
 	 */
 	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
-			      data, USB_CTRL_MSG_SZ, HZ * 3);
+			      data, USB_CTRL_MSG_SZ, 3000);
 	dev_dbg(dev, "set address - ret = %d", ret);
 	dev_dbg(dev, "set address - data[0] = %d, data[1] = %d",
 						data[0], data[1]);
@@ -1438,20 +1438,20 @@ static void mceusb_gen1_init(struct mceu
 	/* set feature: bit rate 38400 bps */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
-			      0xc04e, 0x0000, NULL, 0, HZ * 3);
+			      0xc04e, 0x0000, NULL, 0, 3000);
 
 	dev_dbg(dev, "set feature - ret = %d", ret);
 
 	/* bRequest 4: set char length to 8 bits */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      4, USB_TYPE_VENDOR,
-			      0x0808, 0x0000, NULL, 0, HZ * 3);
+			      0x0808, 0x0000, NULL, 0, 3000);
 	dev_dbg(dev, "set char length - retB = %d", ret);
 
 	/* bRequest 2: set handshaking to use DTR/DSR */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      2, USB_TYPE_VENDOR,
-			      0x0000, 0x0100, NULL, 0, HZ * 3);
+			      0x0000, 0x0100, NULL, 0, 3000);
 	dev_dbg(dev, "set handshake  - retC = %d", ret);
 
 	/* device resume */


