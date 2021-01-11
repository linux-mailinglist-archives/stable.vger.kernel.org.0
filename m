Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A8F2F149D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbhAKN1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:27:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732438AbhAKNQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FBB82226A;
        Mon, 11 Jan 2021 13:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370955;
        bh=rLxzkPDJwXslXFR8rUQu937xdmA3ViEvFyIEy88lVsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9OPPvDGwiaewuxSRmnDCVcRx45VgC+YV6uqnDrX2a11vdMnizy5rEkMLfBBZdfmo
         tfrEofloIW+bHhupYrVR60HTfLKy57w6ysvHxO6vTBUPq62JK4BM1rNSh8KCapFGx4
         Bd4d/2fEeVIOZlINsiBBO/sQP1kGAMGUGOhm3oMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        "taehyun.cho" <taehyun.cho@samsung.com>
Subject: [PATCH 5.10 078/145] usb: gadget: enable super speed plus
Date:   Mon, 11 Jan 2021 14:01:42 +0100
Message-Id: <20210111130052.275899601@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
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
@@ -1536,7 +1536,7 @@ static const struct usb_gadget_driver co
 	.suspend	= configfs_composite_suspend,
 	.resume		= configfs_composite_resume,
 
-	.max_speed	= USB_SPEED_SUPER,
+	.max_speed	= USB_SPEED_SUPER_PLUS,
 	.driver = {
 		.owner          = THIS_MODULE,
 		.name		= "configfs-gadget",
@@ -1576,7 +1576,7 @@ static struct config_group *gadgets_make
 	gi->composite.unbind = configfs_do_nothing;
 	gi->composite.suspend = NULL;
 	gi->composite.resume = NULL;
-	gi->composite.max_speed = USB_SPEED_SUPER;
+	gi->composite.max_speed = USB_SPEED_SUPER_PLUS;
 
 	spin_lock_init(&gi->spinlock);
 	mutex_init(&gi->lock);


