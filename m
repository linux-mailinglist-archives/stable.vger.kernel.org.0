Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0281450EE9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238856AbhKOSVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241342AbhKOSTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E16E163409;
        Mon, 15 Nov 2021 17:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998704;
        bh=x4gTGycKSpgXNJDhakoN3yJk+8xVdnyBfXkxFwTH7cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4XJH0KRxppsbbWHmP/NVwqMBVFmKivH8AnXC0baXH+XUN1sxHBwpOeFRqpj3M2Ok
         QvXzPLRBsnnGGfjA54Y9A8b+vu+2dJhpGhcuRpTMVWgKxQndm7DG6p/4bgXkaQe1Rv
         QPXRCWSns4qZRbP3Rk0Gpu2hH31Fz2B1WXscwg5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.14 003/849] Input: iforce - fix control-message timeout
Date:   Mon, 15 Nov 2021 17:51:26 +0100
Message-Id: <20211115165420.091770831@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 744d0090a5f6dfa4c81b53402ccdf08313100429 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 487358627825 ("Input: iforce - use DMA-safe buffer when getting IDs from USB")
Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org      # 5.3
Link: https://lore.kernel.org/r/20211025115501.5190-1-johan@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/iforce/iforce-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -92,7 +92,7 @@ static int iforce_usb_get_id(struct ifor
 				 id,
 				 USB_TYPE_VENDOR | USB_DIR_IN |
 					USB_RECIP_INTERFACE,
-				 0, 0, buf, IFORCE_MAX_LENGTH, HZ);
+				 0, 0, buf, IFORCE_MAX_LENGTH, 1000);
 	if (status < 0) {
 		dev_err(&iforce_usb->intf->dev,
 			"usb_submit_urb failed: %d\n", status);


