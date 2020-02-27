Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCE7171D14
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbgB0ORj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:17:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389739AbgB0ORh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:17:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B129524697;
        Thu, 27 Feb 2020 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813057;
        bh=olQspT26Sz3U/qdOKRzl0GLxkS06gPYTh0YSj+Nn+Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiVMPMUIyCEJ7AgBIOcUoNzie1wF0iKNASeJskmk/UKmUGy/8ET12CkmhE66ZJwtU
         lQyJNzUYBY/wW4frCY4NHBofOOnJ5bB/r6YGY3JdDIA9RU9ArBPmHCpzuPiBick7Ui
         WoiaziB51pPUArDLto3revYsNfUIX7yDM2UkW1bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <jackp@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.5 121/150] usb: gadget: composite: Fix bMaxPower for SuperSpeedPlus
Date:   Thu, 27 Feb 2020 14:37:38 +0100
Message-Id: <20200227132250.510284281@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

commit c724417baf162bd3e035659e22cdf990cfb0d917 upstream.

SuperSpeedPlus peripherals must report their bMaxPower of the
configuration descriptor in units of 8mA as per the USB 3.2
specification. The current switch statement in encode_bMaxPower()
only checks for USB_SPEED_SUPER but not USB_SPEED_SUPER_PLUS so
the latter falls back to USB 2.0 encoding which uses 2mA units.
Replace the switch with a simple if/else.

Fixes: eae5820b852f ("usb: gadget: composite: Write SuperSpeedPlus config descriptors")
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/composite.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -437,12 +437,10 @@ static u8 encode_bMaxPower(enum usb_devi
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


