Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7AD1AC2EE
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897094AbgDPNfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897069AbgDPNfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:35:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF0C920732;
        Thu, 16 Apr 2020 13:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044111;
        bh=RlPp1iaNAIZtXV/7DCpgYxXxtz24O5yn7VLRupqjAtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gP55r7mXiORWciBv93JY6fi82dhNxsTkHNHxvB2ZQwzQiO8ZnTTRCTkeSlehvPGhB
         MbgAb8qiIS7Tyl4WeCz9N+nGsd8e4KB/5CRsGrMBY+JsmOB1jbLJPfmQZI8P5qLCkW
         hqfZclmJNdTd75p0z6DffN8fjIkiwMNHmNMGqs/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.5 086/257] usb: gadget: composite: Inform controller driver of self-powered
Date:   Thu, 16 Apr 2020 15:22:17 +0200
Message-Id: <20200416131336.722636172@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 5e5caf4fa8d3039140b4548b6ab23dd17fce9b2c upstream.

Different configuration/condition may draw different power. Inform the
controller driver of the change so it can respond properly (e.g.
GET_STATUS request). This fixes an issue with setting MaxPower from
configfs. The composite driver doesn't check this value when setting
self-powered.

Cc: stable@vger.kernel.org
Fixes: 88af8bbe4ef7 ("usb: gadget: the start of the configfs interface")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/composite.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -861,6 +861,11 @@ static int set_config(struct usb_composi
 	else
 		power = min(power, 900U);
 done:
+	if (power <= USB_SELF_POWER_VBUS_MAX_DRAW)
+		usb_gadget_set_selfpowered(gadget);
+	else
+		usb_gadget_clear_selfpowered(gadget);
+
 	usb_gadget_vbus_draw(gadget, power);
 	if (result >= 0 && cdev->delayed_status)
 		result = USB_GADGET_DELAYED_STATUS;
@@ -2279,6 +2284,7 @@ void composite_suspend(struct usb_gadget
 
 	cdev->suspended = 1;
 
+	usb_gadget_set_selfpowered(gadget);
 	usb_gadget_vbus_draw(gadget, 2);
 }
 
@@ -2307,6 +2313,9 @@ void composite_resume(struct usb_gadget
 		else
 			maxpower = min(maxpower, 900U);
 
+		if (maxpower > USB_SELF_POWER_VBUS_MAX_DRAW)
+			usb_gadget_clear_selfpowered(gadget);
+
 		usb_gadget_vbus_draw(gadget, maxpower);
 	}
 


