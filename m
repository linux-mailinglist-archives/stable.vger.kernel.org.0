Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095E0452490
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239725AbhKPBji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242007AbhKOScU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:32:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C6763453;
        Mon, 15 Nov 2021 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999166;
        bh=SEzyjq6agc0osw1GnbYwXxUbrYZZGzLnvMTNPjg3T8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlgZVy6M0TtlksPPCiJ4luYHOufMirLrZw5Fz8TZB1WBBXGWoNUUcW1KUusc8JmVP
         TdRQ1pRxonl/jM3CVlITSgjiTtriLa5tmSm55ZmOdJPPUrWPSaXh/Z35VK6g4WsFrD
         Pw8s7ZVZtjT0k4lYlMn9jL8+ES0ZNXbXLSf6alsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.14 200/849] most: fix control-message timeouts
Date:   Mon, 15 Nov 2021 17:54:43 +0100
Message-Id: <20211115165426.961511814@linuxfoundation.org>
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

commit 63b3e810eff65fb8587fcb26fa0b56802be12dcf upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout defines for the five-second
timeouts.

Fixes: 97a6f772f36b ("drivers: most: add USB adapter driver")
Cc: stable@vger.kernel.org      # 5.9
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211025115811.5410-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/most/most_usb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/most/most_usb.c
+++ b/drivers/most/most_usb.c
@@ -149,7 +149,8 @@ static inline int drci_rd_reg(struct usb
 	retval = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 				 DRCI_READ_REQ, req_type,
 				 0x0000,
-				 reg, dma_buf, sizeof(*dma_buf), 5 * HZ);
+				 reg, dma_buf, sizeof(*dma_buf),
+				 USB_CTRL_GET_TIMEOUT);
 	*buf = le16_to_cpu(*dma_buf);
 	kfree(dma_buf);
 
@@ -176,7 +177,7 @@ static inline int drci_wr_reg(struct usb
 			       reg,
 			       NULL,
 			       0,
-			       5 * HZ);
+			       USB_CTRL_SET_TIMEOUT);
 }
 
 static inline int start_sync_ep(struct usb_device *usb_dev, u16 ep)


