Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FAD12EF3C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgABWb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:31:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbgABWb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:31:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A1520866;
        Thu,  2 Jan 2020 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004316;
        bh=ZqH9QjOCHAhTEwl38Wj/iaO4Yw1aJbs3ttVWRw9aiX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqBnGd3uRCXjfqd/C8Xwuwosj25WaFpDAJrV41k0spNU3qFFE/+eX/3pqVeDqOm5R
         D/ikwlSpg5m6txm6oUlGPr2i+YLnP0Q9aot8D7xfoBK+7xwsb1XKuzLeeIvrm6Axzx
         vZ/7kdbdij4/0A31GuEgIuLYTNh+QVGvVKsfvyr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Suwan Kim <suwan.kim027@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.9 102/171] usbip: Fix error path of vhci_recv_ret_submit()
Date:   Thu,  2 Jan 2020 23:07:13 +0100
Message-Id: <20200102220601.334855271@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
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
@@ -90,16 +90,21 @@ static void vhci_recv_ret_submit(struct
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
 


