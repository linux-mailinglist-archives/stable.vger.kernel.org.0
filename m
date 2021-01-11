Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F872F158E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbhAKNMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:12:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731348AbhAKNMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:12:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73096227C3;
        Mon, 11 Jan 2021 13:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370685;
        bh=SuEabbIVXSYdhRm1lySB7vFdCV6L1oW/q2Y4Yjmad8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODaO7ftUZU506WsM8ywvNbHZ4FI9zci52mVXjc1fMo1u6E8wtb1ejBdzoMooy/UOq
         MrhCSZAxjZurYw1kQ9jFJxp9xt7qOJ2EpIncFdgp3VJrebxFHz4BnWLlnSLOgTQ6Hv
         MTdyihrQhgf4wXT7+YmKzSRFkU6i6FoYUa+URom4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        "taehyun.cho" <taehyun.cho@samsung.com>
Subject: [PATCH 5.4 53/92] usb: gadget: enable super speed plus
Date:   Mon, 11 Jan 2021 14:01:57 +0100
Message-Id: <20210111130041.698916509@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: taehyun.cho <taehyun.cho@samsung.com>

commit e2459108b5a0604c4b472cae2b3cb8d3444c77fb upstream.

Enable Super speed plus in configfs to support USB3.1 Gen2.
This ensures that when a USB gadget is plugged in, it is
enumerated as Gen 2 and connected at 10 Gbps if the host and
cable are capable of it.

Many in-tree gadget functions (fs, midi, acm, ncm, mass_storage,
etc.) already have SuperSpeed Plus support.

Tested: plugged gadget into Linux host and saw:
[284907.385986] usb 8-2: new SuperSpeedPlus Gen 2 USB device number 3 using xhci_hcd

Tested-by: Lorenzo Colitti <lorenzo@google.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: taehyun.cho <taehyun.cho@samsung.com>
Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
Link: https://lore.kernel.org/r/20210106154625.2801030-1-lorenzo@google.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/configfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1505,7 +1505,7 @@ static const struct usb_gadget_driver co
 	.suspend	= configfs_composite_suspend,
 	.resume		= configfs_composite_resume,
 
-	.max_speed	= USB_SPEED_SUPER,
+	.max_speed	= USB_SPEED_SUPER_PLUS,
 	.driver = {
 		.owner          = THIS_MODULE,
 		.name		= "configfs-gadget",
@@ -1545,7 +1545,7 @@ static struct config_group *gadgets_make
 	gi->composite.unbind = configfs_do_nothing;
 	gi->composite.suspend = NULL;
 	gi->composite.resume = NULL;
-	gi->composite.max_speed = USB_SPEED_SUPER;
+	gi->composite.max_speed = USB_SPEED_SUPER_PLUS;
 
 	spin_lock_init(&gi->spinlock);
 	mutex_init(&gi->lock);


