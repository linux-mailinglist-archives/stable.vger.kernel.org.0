Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82001232D50
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgG3IJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729190AbgG3IJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:09:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 746842074B;
        Thu, 30 Jul 2020 08:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096553;
        bh=V8sb+Ce93XA3sEtC6iO9cXOEDjRQ0Cy2PahiyiBhHLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=siWena3bu/bMBI3e8pq91f5GEBeHZmJSAdmkQ8MEZqc6r5XVNhsRNWyOqKtNs0oI3
         SuOgv4OAYwCpfNDz1hL4wtoOy6WR4a6WUvncaYzmTCu54TKzNSYRQO4JJXAHJEP72d
         ww3jbjbxPxU6w5KSq+tp6vNdKPgdH2XP0r8k/+cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        syzbot+c2a1fa67c02faa0de723@syzkaller.appspotmail.com
Subject: [PATCH 4.9 32/61] staging: wlan-ng: properly check endpoint types
Date:   Thu, 30 Jul 2020 10:04:50 +0200
Message-Id: <20200730074422.395105316@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

commit faaff9765664009c1c7c65551d32e9ed3b1dda8f upstream.

As syzkaller detected, wlan-ng driver does not do sanity check of
endpoints in prism2sta_probe_usb(), add check for xfer direction and type

Reported-and-tested-by: syzbot+c2a1fa67c02faa0de723@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c2a1fa67c02faa0de723
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722161052.999754-1-rkovhaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wlan-ng/prism2usb.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -60,11 +60,25 @@ static int prism2sta_probe_usb(struct us
 			       const struct usb_device_id *id)
 {
 	struct usb_device *dev;
-
+	const struct usb_endpoint_descriptor *epd;
+	const struct usb_host_interface *iface_desc = interface->cur_altsetting;
 	struct wlandevice *wlandev = NULL;
 	struct hfa384x *hw = NULL;
 	int result = 0;
 
+	if (iface_desc->desc.bNumEndpoints != 2) {
+		result = -ENODEV;
+		goto failed;
+	}
+
+	result = -EINVAL;
+	epd = &iface_desc->endpoint[1].desc;
+	if (!usb_endpoint_is_bulk_in(epd))
+		goto failed;
+	epd = &iface_desc->endpoint[2].desc;
+	if (!usb_endpoint_is_bulk_out(epd))
+		goto failed;
+
 	dev = interface_to_usbdev(interface);
 	wlandev = create_wlan();
 	if (!wlandev) {


