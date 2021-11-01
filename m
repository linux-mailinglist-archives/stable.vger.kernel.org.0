Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71205441689
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhKAJ03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232650AbhKAJYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EFF861205;
        Mon,  1 Nov 2021 09:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758480;
        bh=dxWCpeC257qELOOsTKiKYGOm24lYGntSVC67WrQwO8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgp6RgkBCu8G9OWfgYcrSZ89iw9bZ7PAPfOhWz3sxjVNH6y5g7XLRddLclLMdkBIR
         Pr4gWvT5yaXKgd6JtVz0CsOfHHn+6d9DAs6hNscGSoIhETsmxvfrGzkIAZuAclMaZJ
         IZeZimq03cQOfrHKDXrlgmtYk3NEL4gnuf3TNXzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 08/35] usbnet: sanity check for maxpacket
Date:   Mon,  1 Nov 2021 10:17:20 +0100
Message-Id: <20211101082453.476997836@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
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
@@ -1784,6 +1784,10 @@ usbnet_probe (struct usb_interface *udev
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	if (dev->maxpacket == 0) {
+		/* that is a broken device */
+		goto out4;
+	}
 
 	/* let userspace know we have a random address */
 	if (ether_addr_equal(net->dev_addr, node_id))


