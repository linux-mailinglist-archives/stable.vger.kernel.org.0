Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830B8CA934
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbfJCQiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403971AbfJCQiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09DD220830;
        Thu,  3 Oct 2019 16:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120734;
        bh=CLSXQfZvYt6Ci+WA241XbXt3ccOFeOoA5HxVZhc9aFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Era/tDDQ0/V2x6XqcI99duz8Pmcanxboo8tBBI2YUNOHB0PZyi98N4wn6NMaC1VYN
         o9lGQQAoSPfPvefY5Gt/Dx6P9KLybsRI+GbWPRcdPGZ82F3S6v/2FGJhbzaDB2BZMI
         au8ddEIw5Ez9U3LLEYTGZTB1PPbZKj+rSw4YjC3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 019/344] usbnet: sanity checking of packet sizes and device mtu
Date:   Thu,  3 Oct 2019 17:49:44 +0200
Message-Id: <20191003154541.970163635@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 280ceaed79f18db930c0cc8bb21f6493490bf29c ]

After a reset packet sizes and device mtu can change and need
to be reevaluated to calculate queue sizes.
Malicious devices can set this to zero and we divide by it.
Introduce sanity checking.

Reported-and-tested-by:  syzbot+6102c120be558c885f04@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -344,6 +344,8 @@ void usbnet_update_max_qlen(struct usbne
 {
 	enum usb_device_speed speed = dev->udev->speed;
 
+	if (!dev->rx_urb_size || !dev->hard_mtu)
+		goto insanity;
 	switch (speed) {
 	case USB_SPEED_HIGH:
 		dev->rx_qlen = MAX_QUEUE_MEMORY / dev->rx_urb_size;
@@ -360,6 +362,7 @@ void usbnet_update_max_qlen(struct usbne
 		dev->tx_qlen = 5 * MAX_QUEUE_MEMORY / dev->hard_mtu;
 		break;
 	default:
+insanity:
 		dev->rx_qlen = dev->tx_qlen = 4;
 	}
 }


