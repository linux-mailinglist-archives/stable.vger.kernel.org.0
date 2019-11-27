Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD2510BAE3
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbfK0VHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:07:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732246AbfK0VH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:07:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EB8F2176D;
        Wed, 27 Nov 2019 21:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888848;
        bh=WYLjzLJr4LJQ1JTM+hMm/fYTi2rQD3RG0X8a8GmwJMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyou0jx3yVtD3Ugii90Cw3nDqChiAdy+JtkqF6fYK8DnnQDb4YH6zDaRJZCTQGrUQ
         1DGJ074dp+m0R58TjLtdkqGXxcBMnvaya7LUoGpnuyuBl8Yy5QqAwXIw9c/8prU+dO
         sA1vBm5U4ROzQVwhxkMr0lw6hoGmhkqj5t8Tjizs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Suwan Kim <suwan.kim027@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.19 294/306] usbip: Fix uninitialized symbol nents in stub_recv_cmd_submit()
Date:   Wed, 27 Nov 2019 21:32:24 +0100
Message-Id: <20191127203136.223608358@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suwan Kim <suwan.kim027@gmail.com>

commit 2a9125317b247f2cf35c196f968906dcf062ae2d upstream.

Smatch reported that nents is not initialized and used in
stub_recv_cmd_submit(). nents is currently initialized by sgl_alloc()
and used to allocate multiple URBs when host controller doesn't
support scatter-gather DMA. The use of uninitialized nents means that
buf_len is zero and use_sg is true. But buffer length should not be
zero when an URB uses scatter-gather DMA.

To prevent this situation, add the conditional that checks buf_len
and use_sg. And move the use of nents right after the sgl_alloc() to
avoid the use of uninitialized nents.

If the error occurs, it adds SDEV_EVENT_ERROR_MALLOC and stub_priv
will be released by stub event handler and connection will be shut
down.

Fixes: ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub driver")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191111141035.27788-1-suwan.kim027@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/stub_rx.c |   50 ++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 18 deletions(-)

--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -470,18 +470,50 @@ static void stub_recv_cmd_submit(struct
 	if (pipe == -1)
 		return;
 
+	/*
+	 * Smatch reported the error case where use_sg is true and buf_len is 0.
+	 * In this case, It adds SDEV_EVENT_ERROR_MALLOC and stub_priv will be
+	 * released by stub event handler and connection will be shut down.
+	 */
 	priv = stub_priv_alloc(sdev, pdu);
 	if (!priv)
 		return;
 
 	buf_len = (unsigned long long)pdu->u.cmd_submit.transfer_buffer_length;
 
+	if (use_sg && !buf_len) {
+		dev_err(&udev->dev, "sg buffer with zero length\n");
+		goto err_malloc;
+	}
+
 	/* allocate urb transfer buffer, if needed */
 	if (buf_len) {
 		if (use_sg) {
 			sgl = sgl_alloc(buf_len, GFP_KERNEL, &nents);
 			if (!sgl)
 				goto err_malloc;
+
+			/* Check if the server's HCD supports SG */
+			if (!udev->bus->sg_tablesize) {
+				/*
+				 * If the server's HCD doesn't support SG, break
+				 * a single SG request into several URBs and map
+				 * each SG list entry to corresponding URB
+				 * buffer. The previously allocated SG list is
+				 * stored in priv->sgl (If the server's HCD
+				 * support SG, SG list is stored only in
+				 * urb->sg) and it is used as an indicator that
+				 * the server split single SG request into
+				 * several URBs. Later, priv->sgl is used by
+				 * stub_complete() and stub_send_ret_submit() to
+				 * reassemble the divied URBs.
+				 */
+				support_sg = 0;
+				num_urbs = nents;
+				priv->completed_urbs = 0;
+				pdu->u.cmd_submit.transfer_flags &=
+								~URB_DMA_MAP_SG;
+			}
 		} else {
 			buffer = kzalloc(buf_len, GFP_KERNEL);
 			if (!buffer)
@@ -489,24 +521,6 @@ static void stub_recv_cmd_submit(struct
 		}
 	}
 
-	/* Check if the server's HCD supports SG */
-	if (use_sg && !udev->bus->sg_tablesize) {
-		/*
-		 * If the server's HCD doesn't support SG, break a single SG
-		 * request into several URBs and map each SG list entry to
-		 * corresponding URB buffer. The previously allocated SG
-		 * list is stored in priv->sgl (If the server's HCD support SG,
-		 * SG list is stored only in urb->sg) and it is used as an
-		 * indicator that the server split single SG request into
-		 * several URBs. Later, priv->sgl is used by stub_complete() and
-		 * stub_send_ret_submit() to reassemble the divied URBs.
-		 */
-		support_sg = 0;
-		num_urbs = nents;
-		priv->completed_urbs = 0;
-		pdu->u.cmd_submit.transfer_flags &= ~URB_DMA_MAP_SG;
-	}
-
 	/* allocate urb array */
 	priv->num_urbs = num_urbs;
 	priv->urbs = kmalloc_array(num_urbs, sizeof(*priv->urbs), GFP_KERNEL);


