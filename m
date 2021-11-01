Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDC744160F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhKAJV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231979AbhKAJVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F655610CA;
        Mon,  1 Nov 2021 09:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758341;
        bh=5+O5luxEq+ZJHTsBpfKr8ocub3IP1PsSW3FLEVO+9B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdF7OKrgBPsxrxmCP265eeCsT1eyQFNLn/c4EzV69vDJ0zIjmzAYIIESCz0/Qk6Io
         cErkpg8cHfkNf2aChbGkYduGvvgnFi0OiYh6m/59JfvknwRNkhM8GQczl0VejPsExg
         v1ZLdFi2tvJbEivMKbzKpisKmFWrsAW3lBUex3ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 05/17] usbnet: sanity check for maxpacket
Date:   Mon,  1 Nov 2021 10:17:08 +0100
Message-Id: <20211101082441.850736567@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082440.664392327@linuxfoundation.org>
References: <20211101082440.664392327@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 397430b50a363d8b7bdda00522123f82df6adc5e upstream.

maxpacket of 0 makes no sense and oopses as we need to divide
by it. Give up.

V2: fixed typo in log and stylistic issues

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211021122944.21816-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1730,6 +1730,10 @@ usbnet_probe (struct usb_interface *udev
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	if (dev->maxpacket == 0) {
+		/* that is a broken device */
+		goto out4;
+	}
 
 	/* let userspace know we have a random address */
 	if (ether_addr_equal(net->dev_addr, node_id))


