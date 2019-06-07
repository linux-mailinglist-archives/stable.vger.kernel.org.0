Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD377390B5
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731132AbfFGPrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731541AbfFGPrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:47:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D8B21479;
        Fri,  7 Jun 2019 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922430;
        bh=9Cr2eEImjg0qZSqiW4nAV3TcuXNzBTcC42JIUg/G0Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2MDz/v0JPpV1LYjVL8E2aqBBD1IUw5yP8NVVQji7HH27mWaIzkqYOGJ5PjovdLd/
         ErE6VBQZ5hJP0bfnDoXitz2gID4+xF/Kk3I6HNdzMZyToNuHQ5D6ZapNVoeq/dgc8l
         JIuOtl4cDTkupyg8IDcunxTwK61fY8AkljEan98c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>
Subject: [PATCH 5.1 11/85] USB: Add LPM quirk for Surface Dock GigE adapter
Date:   Fri,  7 Jun 2019 17:38:56 +0200
Message-Id: <20190607153850.522968995@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit ea261113385ac0a71c2838185f39e8452d54b152 upstream.

Without USB_QUIRK_NO_LPM ethernet will not work and rtl8152 will
complain with

    r8152 <device...>: Stop submitting intr, status -71

Adding the quirk resolves this. As the dock is externally powered, this
should not have any drawbacks.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -209,6 +209,9 @@ static const struct usb_device_id usb_qu
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Microsoft Surface Dock Ethernet (RTL8153 GigE) */
+	{ USB_DEVICE(0x045e, 0x07c6), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Cherry Stream G230 2.0 (G85-231) and 3.0 (G85-232) */
 	{ USB_DEVICE(0x046a, 0x0023), .driver_info = USB_QUIRK_RESET_RESUME },
 


