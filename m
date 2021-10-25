Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85512439529
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhJYLso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233250AbhJYLsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF2461073;
        Mon, 25 Oct 2021 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162381;
        bh=VpXDuc5ODD37c89+RKGeszqjBvCk2D5GP/X21UhgFC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phnnXdVJEPrhUoSVUAdSnVJSm+QykpAXYCVH9cjYbnX0ExfPHMb/gfJNxP9DBXDII
         CTUAW4lEJY32pZX6ENn3OfAFoxCmP7yHHmwOLGv+5ioF9X2NFpMLJG2n7plpNxTie8
         25GSduHAEiNqcZ4UJ/aqZ1ZQzRobM04KgvIu4s1FKUj0MxtscgpTLdTP/PEND7KhRM
         tnqrfswOIHhQZJHLn5yxqSxyEH73pj5DU6a5nZltvWcnA+zjThDjdWm08hadWlKUSh
         1CuQJQqlW9vcLaUXGfwwpdXc8H2JPvnrDg54SjxAlyjxDw7c+cCR4R/BDuJbO3b1h1
         pFShIeJdcyCEg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyQW-0001DI-Ac; Mon, 25 Oct 2021 13:46:04 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 3/5] comedi: vmk80xx: fix transfer-buffer overflows
Date:   Mon, 25 Oct 2021 13:45:30 +0200
Message-Id: <20211025114532.4599-4-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025114532.4599-1-johan@kernel.org>
References: <20211025114532.4599-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver uses endpoint-sized USB transfer buffers but up until
recently had no sanity checks on the sizes.

Commit e1f13c879a7c ("staging: comedi: check validity of wMaxPacketSize
of usb endpoints found") inadvertently fixed NULL-pointer dereferences
when accessing the transfer buffers in case a malicious device has a
zero wMaxPacketSize.

Make sure to allocate buffers large enough to handle also the other
accesses that are done without a size check (e.g. byte 18 in
vmk80xx_cnt_insn_read() for the VMK8061_MODEL) to avoid writing beyond
the buffers, for example, when doing descriptor fuzzing.

The original driver was for a low-speed device with 8-byte buffers.
Support was later added for a device that uses bulk transfers and is
presumably a full-speed device with a maximum 64-byte wMaxPacketSize.

Fixes: 985cafccbf9b ("Staging: Comedi: vmk80xx: Add k8061 support")
Cc: stable@vger.kernel.org      # 2.6.31
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/comedi/drivers/vmk80xx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
index 9f920819cd74..f2c1572d0cd7 100644
--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -90,6 +90,8 @@ enum {
 #define IC3_VERSION		BIT(0)
 #define IC6_VERSION		BIT(1)
 
+#define MIN_BUF_SIZE		64
+
 enum vmk80xx_model {
 	VMK8055_MODEL,
 	VMK8061_MODEL
@@ -678,12 +680,12 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
 	struct vmk80xx_private *devpriv = dev->private;
 	size_t size;
 
-	size = usb_endpoint_maxp(devpriv->ep_rx);
+	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
 	devpriv->usb_rx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = usb_endpoint_maxp(devpriv->ep_tx);
+	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;
-- 
2.32.0

