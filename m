Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA4743956D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhJYMA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230058AbhJYMA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B74606103B;
        Mon, 25 Oct 2021 11:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163116;
        bh=NdQrCHEld9O16JXzrTFvX3WSjxD0Akvj+AI7iLRc4Bw=;
        h=From:To:Cc:Subject:Date:From;
        b=hceyHO2thvwzSGrq8FVgDrcs2Xlv5I2b4GJ+59arV5F1pNVGqTZF/JjMCcTqLNevm
         tHMyumqp0yBOAbCzHlZxxejPPr9HfuQD1CMqS/txB4K0VM6I3QXwepfDIyj8nXewZM
         jt1pYNEFezQgeYVEaRoeGnkSWsvO9zaox+exql457pHYG0au+ntFf+gaVMat6s2pmE
         3hKlfxnrirmcSg3V7uUWVi/Hc5jsK/1BH2TAQTMN82gbYmuNTziD6foFV06JyYXVZt
         CQJgUwMTjFDlbFI5NS5Rj6p2qnmZui1roHULGri/RROHhbhOkyZQwNIzo4rwza7mWD
         XKYWSRMIb1Beg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meycN-0001Q2-F5; Mon, 25 Oct 2021 13:58:19 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] most: fix control-message timeouts
Date:   Mon, 25 Oct 2021 13:58:11 +0200
Message-Id: <20211025115811.5410-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout defines for the five-second
timeouts.

Fixes: 97a6f772f36b ("drivers: most: add USB adapter driver")
Cc: stable@vger.kernel.org      # 5.9
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/most/most_usb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/most/most_usb.c b/drivers/most/most_usb.c
index 2640c5b326a4..acabb7715b42 100644
--- a/drivers/most/most_usb.c
+++ b/drivers/most/most_usb.c
@@ -149,7 +149,8 @@ static inline int drci_rd_reg(struct usb_device *dev, u16 reg, u16 *buf)
 	retval = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 				 DRCI_READ_REQ, req_type,
 				 0x0000,
-				 reg, dma_buf, sizeof(*dma_buf), 5 * HZ);
+				 reg, dma_buf, sizeof(*dma_buf),
+				 USB_CTRL_GET_TIMEOUT);
 	*buf = le16_to_cpu(*dma_buf);
 	kfree(dma_buf);
 
@@ -176,7 +177,7 @@ static inline int drci_wr_reg(struct usb_device *dev, u16 reg, u16 data)
 			       reg,
 			       NULL,
 			       0,
-			       5 * HZ);
+			       USB_CTRL_SET_TIMEOUT);
 }
 
 static inline int start_sync_ep(struct usb_device *usb_dev, u16 ep)
-- 
2.32.0

