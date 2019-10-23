Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F3DE128E
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 08:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388235AbfJWG6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 02:58:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfJWG6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 02:58:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2793260953; Wed, 23 Oct 2019 06:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571813903;
        bh=+hzEqxCEYvcdF/No3YZxkQWkuQuIhHUAdKzKseRXV2s=;
        h=From:To:Cc:Subject:Date:From;
        b=ozvC85jRr3A5VhNEUBQMoD2RNgdBgwwWIWChgogF5Y7fDCle6HabTIPOCLoIjAbBI
         XxgJMI4CgdL9GiSM9UqHue5sZeySLNu3JYzRM4GQFSo2noAnSx7hB0+5UbDIMj4Umb
         qgLqGIA646GZGrDpFYcs91PhgyZeN9uXoK2fkiK8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5666D60271;
        Wed, 23 Oct 2019 06:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571813902;
        bh=+hzEqxCEYvcdF/No3YZxkQWkuQuIhHUAdKzKseRXV2s=;
        h=From:To:Cc:Subject:Date:From;
        b=kySIwxPa9tT8/Ra1GT8VkB6FrBPGGcV6Jz/blmWRDzEzc80fyIxAod6OogjOviYBq
         xGEsrjeaipWSa6c1p0Z/S9KPECFfE8p0QpwGAnARMm7cmelKoSqdVXLpToTuw8zyai
         iDdPAmARpFasfQg/54ci3KS0jbC+kzSa5/T9HoJE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5666D60271
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jackp@codeaurora.org
From:   Jack Pham <jackp@codeaurora.org>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Jack Pham <jackp@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] usb: gadget: composite: Fix bMaxPower for SuperSpeedPlus
Date:   Tue, 22 Oct 2019 23:57:52 -0700
Message-Id: <20191023065753.32722-1-jackp@codeaurora.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SuperSpeedPlus peripherals must report their bMaxPower of the
configuration descriptor in units of 8mA as per the USB 3.2
specification. The current switch statement in encode_bMaxPower()
only checks for USB_SPEED_SUPER but not USB_SPEED_SUPER_PLUS so
the latter falls back to USB 2.0 encoding which uses 2mA units.
Replace the switch with a simple if/else.

Fixes: eae5820b852f ("usb: gadget: composite: Write SuperSpeedPlus config descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Jack Pham <jackp@codeaurora.org>
---
 drivers/usb/gadget/composite.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index d516e8d6cd7f..e1db94d1fe2e 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -437,12 +437,10 @@ static u8 encode_bMaxPower(enum usb_device_speed speed,
 		val = CONFIG_USB_GADGET_VBUS_DRAW;
 	if (!val)
 		return 0;
-	switch (speed) {
-	case USB_SPEED_SUPER:
-		return DIV_ROUND_UP(val, 8);
-	default:
+	if (speed < USB_SPEED_SUPER)
 		return DIV_ROUND_UP(val, 2);
-	}
+	else
+		return DIV_ROUND_UP(val, 8);
 }
 
 static int config_buf(struct usb_configuration *config,
-- 
2.21.0

