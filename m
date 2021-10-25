Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DAC439FB9
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhJYTXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234937AbhJYTWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFE676108C;
        Mon, 25 Oct 2021 19:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189612;
        bh=RsDMZW4n7+Z30k1OBfySXl2xmRMbFiWRHcUn4mW6JWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shLEaX4FAyzI9xz0FBAe8VSSgHKJYVBucdbDtXToOnbQr7PSTLgVmf5O/fg2xQhxP
         xvvxDnNNYYtHYuc3Q1dB6Yx4l6ePJb9Ko2doNPLk1juaZtokd0VK5yEPBozAIFA+/8
         hDeUwSGVRWUSLL7ru4p6YzDwIu0NPiRYoLKoEUw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 47/50] usbnet: sanity check for maxpacket
Date:   Mon, 25 Oct 2021 21:14:34 +0200
Message-Id: <20211025190941.224545872@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
References: <20211025190932.542632625@linuxfoundation.org>
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
@@ -1740,6 +1740,10 @@ usbnet_probe (struct usb_interface *udev
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	if (dev->maxpacket == 0) {
+		/* that is a broken device */
+		goto out4;
+	}
 
 	/* let userspace know we have a random address */
 	if (ether_addr_equal(net->dev_addr, node_id))


