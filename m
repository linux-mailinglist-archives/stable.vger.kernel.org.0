Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC323318EC8
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhBKPdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231289AbhBKPbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:31:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD52764E9C;
        Thu, 11 Feb 2021 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613057458;
        bh=9+DzES7+wmzyfIDycjBZRQiZdVPHPrvrWvKtPT/o9Qs=;
        h=Subject:To:From:Date:From;
        b=wKF4viEvDgjwR8INxloxTrgWONI5I2ceAM96khH52FRV2Uw0gP8h8UAI1beMRdhkM
         cO8+bFn6mM0yi8Mk3RJ7tLXNu4ZrqA5uwqIoBmGYY9IrP4SlESf7xmqDrHUyslhrJL
         QGIPABUWlP9TpxUcWxZbSS0Ri50GfGQPXWexYv8c=
Subject: patch "staging: gdm724x: Fix DMA from stack" added to staging-next
To:     ameynarkhede03@gmail.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Feb 2021 16:30:55 +0100
Message-ID: <161305745545233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: gdm724x: Fix DMA from stack

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 7c3a0635cd008eaca9a734dc802709ee0b81cac5 Mon Sep 17 00:00:00 2001
From: Amey Narkhede <ameynarkhede03@gmail.com>
Date: Thu, 11 Feb 2021 11:08:19 +0530
Subject: staging: gdm724x: Fix DMA from stack

Stack allocated buffers cannot be used for DMA
on all architectures so allocate hci_packet buffer
using kmalloc.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Amey Narkhede <ameynarkhede03@gmail.com>
Link: https://lore.kernel.org/r/20210211053819.34858-1-ameynarkhede03@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gdm724x/gdm_usb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_usb.c b/drivers/staging/gdm724x/gdm_usb.c
index dc4da66c3695..54bdb64f52e8 100644
--- a/drivers/staging/gdm724x/gdm_usb.c
+++ b/drivers/staging/gdm724x/gdm_usb.c
@@ -56,20 +56,24 @@ static int gdm_usb_recv(void *priv_dev,
 
 static int request_mac_address(struct lte_udev *udev)
 {
-	u8 buf[16] = {0,};
-	struct hci_packet *hci = (struct hci_packet *)buf;
+	struct hci_packet *hci;
 	struct usb_device *usbdev = udev->usbdev;
 	int actual;
 	int ret = -1;
 
+	hci = kmalloc(struct_size(hci, data, 1), GFP_KERNEL);
+	if (!hci)
+		return -ENOMEM;
+
 	hci->cmd_evt = gdm_cpu_to_dev16(udev->gdm_ed, LTE_GET_INFORMATION);
 	hci->len = gdm_cpu_to_dev16(udev->gdm_ed, 1);
 	hci->data[0] = MAC_ADDRESS;
 
-	ret = usb_bulk_msg(usbdev, usb_sndbulkpipe(usbdev, 2), buf, 5,
+	ret = usb_bulk_msg(usbdev, usb_sndbulkpipe(usbdev, 2), hci, 5,
 			   &actual, 1000);
 
 	udev->request_mac_addr = 1;
+	kfree(hci);
 
 	return ret;
 }
-- 
2.30.1


