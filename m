Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D998D450D47
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbhKORxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238929AbhKORuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:50:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F93D63277;
        Mon, 15 Nov 2021 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997466;
        bh=SEzyjq6agc0osw1GnbYwXxUbrYZZGzLnvMTNPjg3T8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxmQ5iZFEouW0JIa/dP7IPIFh9RzplsYDjiw+Y3r8MT+Bb6bXd9+cCT4YLIcsZgY+
         oPoPa6x4Y2la6tksSSGVr04A/YTQI2TVbanmUHT8wCBqmAWjw0HuVma8VtKbbnTMMs
         v/tkHiqpykRXUeh/dG1VNzpzhI1FFk7h7xkeq1gM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 159/575] most: fix control-message timeouts
Date:   Mon, 15 Nov 2021 17:58:04 +0100
Message-Id: <20211115165349.198483555@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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


