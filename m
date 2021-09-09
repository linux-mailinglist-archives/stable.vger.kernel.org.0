Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5F9405450
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356005AbhIIM6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354797AbhIIMxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:53:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7724F63248;
        Thu,  9 Sep 2021 11:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188663;
        bh=ptQjnL0kBIp8Ti1DizB+0MUMdyYYKhAhFSwz+ynAHDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMaPK4nMSRwoNd2MC1Z8lyxpmhpz2vD4kw0qmrCs3VyDQnZpCD+w+r+GhgRivhiQO
         0X008j3jHBI3h+54atYCttmTjoNbNLVwQnSRTn5WqDvNCqpgM2ZNyj6Tj8Z6g5nnO3
         pvSUPgmhQJqatpKd4uYNe50Ien9YVDr0a9TeZ7JspTpm8MA1zMpbO4qdKGOAJTLQ9f
         7cF+fEvtXy1A5q5WWb0uXP3Dckd+sVmoKR0MrGfbSvKUuybG7gzvOz8qwPWgisoroh
         J7Vmw/dh4WfJXbXiWAzIBQh36OefBL9ukKPj93B8jocmlNlhfV3JvqfwpQwW+5L2nD
         kv40mvz+CtvnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Pham <jackp@codeaurora.org>,
        Ronak Vijay Raheja <rraheja@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/74] usb: gadget: composite: Allow bMaxPower=0 if self-powered
Date:   Thu,  9 Sep 2021 07:56:25 -0400
Message-Id: <20210909115726.149004-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

[ Upstream commit bcacbf06c891374e7fdd7b72d11cda03b0269b43 ]

Currently the composite driver encodes the MaxPower field of
the configuration descriptor by reading the c->MaxPower of the
usb_configuration only if it is non-zero, otherwise it falls back
to using the value hard-coded in CONFIG_USB_GADGET_VBUS_DRAW.
However, there are cases when a configuration must explicitly set
bMaxPower to 0, particularly if its bmAttributes also has the
Self-Powered bit set, which is a valid combination.

This is specifically called out in the USB PD specification section
9.1, in which a PDUSB device "shall report zero in the bMaxPower
field after negotiating a mutually agreeable Contract", and also
verified by the USB Type-C Functional Test TD.4.10.2 Sink Power
Precedence Test.

The fix allows the c->MaxPower to be used for encoding the bMaxPower
even if it is 0, if the self-powered bit is also set.  An example
usage of this would be for a ConfigFS gadget to be dynamically
updated by userspace when the Type-C connection is determined to be
operating in Power Delivery mode.

Co-developed-by: Ronak Vijay Raheja <rraheja@codeaurora.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Ronak Vijay Raheja <rraheja@codeaurora.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210720080907.30292-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index d85bb3ba8263..a76ed4acb570 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -481,7 +481,7 @@ static u8 encode_bMaxPower(enum usb_device_speed speed,
 {
 	unsigned val;
 
-	if (c->MaxPower)
+	if (c->MaxPower || (c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
 		val = c->MaxPower;
 	else
 		val = CONFIG_USB_GADGET_VBUS_DRAW;
@@ -891,7 +891,11 @@ static int set_config(struct usb_composite_dev *cdev,
 	}
 
 	/* when we return, be sure our power usage is valid */
-	power = c->MaxPower ? c->MaxPower : CONFIG_USB_GADGET_VBUS_DRAW;
+	if (c->MaxPower || (c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
+		power = c->MaxPower;
+	else
+		power = CONFIG_USB_GADGET_VBUS_DRAW;
+
 	if (gadget->speed < USB_SPEED_SUPER)
 		power = min(power, 500U);
 	else
-- 
2.30.2

