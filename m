Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAF331883B
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBKKdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:33:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhBKKbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 05:31:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFF4364E8B;
        Thu, 11 Feb 2021 10:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613039428;
        bh=FcaC4nxaKBww9Lq6SxIfe0UDsVCRuQsNertYtG+FJgY=;
        h=Subject:To:From:Date:From;
        b=1nk/wzL41BcB4yRdXFbGeb/6CMZEmhJnz/OjSO5g0eQd2T/tO0e7g31YxJ1YJ+F6X
         i9Hf9XFcnQVjDQ4hLKo3vkBCFMUXYQ7CjUlE/f4cbVQsPAMUMmyyry0noSkgPgV/FQ
         IYyzXb+UoXmYGTuec8ccl2VbEjTTG7+QxZjh/QpY=
Subject: patch "staging: gdm724x: Fix DMA from stack" added to staging-testing
To:     ameynarkhede03@gmail.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Feb 2021 11:30:24 +0100
Message-ID: <16130394240142@kroah.com>
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
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

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


