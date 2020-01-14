Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994F613A6AE
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgANKMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbgANKMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:12:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FE252467D;
        Tue, 14 Jan 2020 10:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996773;
        bh=la7x7aFzLjJ5M5bG0q9rlD8zmmIiYStPzsQN80+IsqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnzTnC5+AMbcAA0S4icA/ZNni6sXWXGxeTLq+VmIh8OCXZl0gBaU+kfSNpGhLa+A4
         wnNXj2KfffJkchtcyjdQkBx1vOviaBx7xJVYT9gLFWbi6pc/II71+52Nyfw4Uh8Sbb
         JMST/RbGlpMeBxxc6zS1P06SIXdATwxhD1WrgpUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 12/28] can: gs_usb: gs_usb_probe(): use descriptors of current altsetting
Date:   Tue, 14 Jan 2020 11:02:14 +0100
Message-Id: <20200114094341.890032359@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.845958665@linuxfoundation.org>
References: <20200114094336.845958665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 2f361cd9474ab2c4ab9ac8db20faf81e66c6279b upstream.

Make sure to always use the descriptors of the current alternate setting
to avoid future issues when accessing fields that may differ between
settings.

Signed-off-by: Johan Hovold <johan@kernel.org>
Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/gs_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -847,7 +847,7 @@ static int gs_usb_probe(struct usb_inter
 			     GS_USB_BREQ_HOST_FORMAT,
 			     USB_DIR_OUT|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
 			     1,
-			     intf->altsetting[0].desc.bInterfaceNumber,
+			     intf->cur_altsetting->desc.bInterfaceNumber,
 			     hconf,
 			     sizeof(*hconf),
 			     1000);
@@ -870,7 +870,7 @@ static int gs_usb_probe(struct usb_inter
 			     GS_USB_BREQ_DEVICE_CONFIG,
 			     USB_DIR_IN|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
 			     1,
-			     intf->altsetting[0].desc.bInterfaceNumber,
+			     intf->cur_altsetting->desc.bInterfaceNumber,
 			     dconf,
 			     sizeof(*dconf),
 			     1000);


