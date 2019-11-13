Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B76EFBB03
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 22:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfKMVo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 16:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfKMVo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Nov 2019 16:44:28 -0500
Received: from localhost (unknown [61.58.47.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2687206EE;
        Wed, 13 Nov 2019 21:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573681469;
        bh=QmsYd+dzk6pjP168Xqtd2Sgqz8qrobVfdAKsIfYSSrk=;
        h=Subject:To:From:Date:From;
        b=S70z1huuPYZ2t67P9XJinnlBVKxsUcMdrX0odfuDNnOGcdYFyN86M9Thsp7tC2y4M
         w/HIkNHxD5SGB6cOmEWF55PswBX4axiMvnwPxEvKBp28MfY7xVkjeCamNv+uhTGWLY
         lg3tbcEXaOMX/1s0glhySMFr3cNPgT22hrjHMNo8=
Subject: patch "usbip: Fix uninitialized symbol 'nents' in stub_recv_cmd_submit()" added to usb-next
To:     suwan.kim027@gmail.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, lkp@intel.com,
        skhan@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 14 Nov 2019 05:43:39 +0800
Message-ID: <1573681419160131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbip: Fix uninitialized symbol 'nents' in stub_recv_cmd_submit()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 2a9125317b247f2cf35c196f968906dcf062ae2d Mon Sep 17 00:00:00 2001
From: Suwan Kim <suwan.kim027@gmail.com>
Date: Mon, 11 Nov 2019 23:10:35 +0900
Subject: usbip: Fix uninitialized symbol 'nents' in stub_recv_cmd_submit()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
 drivers/usb/usbip/stub_rx.c | 50 ++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index 66edfeea68fe..e2b019532234 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -470,18 +470,50 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
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
@@ -489,24 +521,6 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
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
-- 
2.24.0


