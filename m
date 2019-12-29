Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B9312C558
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbfL2Rff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:35:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbfL2Rfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FC3420722;
        Sun, 29 Dec 2019 17:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640932;
        bh=k1G97uRjPvuhi6Y6U7CBW8qO9foDWgD91zOWVaaeXG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljurYM23fH8BSCUfyq2AyU0E37YOt4WDnlN33yiMNE1Au/v33UnZ36AROo2ocKdq5
         wmhjFGuZ4iRuLibifxM90tzF7EjnDFwV9rB2J8vQQxWQ+LpvD6LoTOc6v8LT/Y/GSS
         g0tsgB2K60WGFrVARzX/xUEZl51kDiiUnwOTa7rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Suwan Kim <suwan.kim027@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.19 198/219] usbip: Fix error path of vhci_recv_ret_submit()
Date:   Sun, 29 Dec 2019 18:20:00 +0100
Message-Id: <20191229162539.850156847@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suwan Kim <suwan.kim027@gmail.com>

commit aabb5b833872524eaf28f52187e5987984982264 upstream.

If a transaction error happens in vhci_recv_ret_submit(), event
handler closes connection and changes port status to kick hub_event.
Then hub tries to flush the endpoint URBs, but that causes infinite
loop between usb_hub_flush_endpoint() and vhci_urb_dequeue() because
"vhci_priv" in vhci_urb_dequeue() was already released by
vhci_recv_ret_submit() before a transmission error occurred. Thus,
vhci_urb_dequeue() terminates early and usb_hub_flush_endpoint()
continuously calls vhci_urb_dequeue().

The root cause of this issue is that vhci_recv_ret_submit()
terminates early without giving back URB when transaction error
occurs in vhci_recv_ret_submit(). That causes the error URB to still
be linked at endpoint list without “vhci_priv".

So, in the case of transaction error in vhci_recv_ret_submit(),
unlink URB from the endpoint, insert proper error code in
urb->status and give back URB.

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20191213023055.19933-3-suwan.kim027@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/vhci_rx.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/usb/usbip/vhci_rx.c
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -77,16 +77,21 @@ static void vhci_recv_ret_submit(struct
 	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
 
 	/* recv transfer buffer */
-	if (usbip_recv_xbuff(ud, urb) < 0)
-		return;
+	if (usbip_recv_xbuff(ud, urb) < 0) {
+		urb->status = -EPROTO;
+		goto error;
+	}
 
 	/* recv iso_packet_descriptor */
-	if (usbip_recv_iso(ud, urb) < 0)
-		return;
+	if (usbip_recv_iso(ud, urb) < 0) {
+		urb->status = -EPROTO;
+		goto error;
+	}
 
 	/* restore the padding in iso packets */
 	usbip_pad_iso(ud, urb);
 
+error:
 	if (usbip_dbg_flag_vhci_rx)
 		usbip_dump_urb(urb);
 


