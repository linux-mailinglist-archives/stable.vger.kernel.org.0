Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FE1452182
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhKPBFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245540AbhKOTUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40075632DC;
        Mon, 15 Nov 2021 18:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001399;
        bh=SEzyjq6agc0osw1GnbYwXxUbrYZZGzLnvMTNPjg3T8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlSQzV+XolT6Z3cP0ctGVqi64LEVExI5+4UHrI29YpL7tKSwz1+l9W9V3LvPHDpPN
         W7+TLreyo21NmClGhaf/Q3t0cGUuiwB5oCKCILaWWciOC79GmC/vdxYydD5mS7WJi4
         /t0jLF7kTHdnfSCVhrmspdDjaswJB9zmqhGqp5NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 177/917] most: fix control-message timeouts
Date:   Mon, 15 Nov 2021 17:54:32 +0100
Message-Id: <20211115165434.780643627@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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


