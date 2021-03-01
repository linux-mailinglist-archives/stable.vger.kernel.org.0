Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76821328759
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbhCARXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:23:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233061AbhCAROC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BEEC64F46;
        Mon,  1 Mar 2021 16:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617123;
        bh=6jbua2UHxglhLLVTcJHBXmMy+TvtkbpIqWQxKJ7beZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5tTZnnz5GA8SDsO32Blys/v1fUtm3L6zKSVoUZq1jZ817ICLqdJrfb0AftdxJXRw
         itbXbZVjN43tuSfIj8eMLzTMny9HEz7ErznRC6cMycXZoFv7OpiNYx1uQpIDOzPa3Z
         KLG1Rk2H+c4/Ys45mAsPP/x53HjPsF9ectPv9/vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Amey Narkhede <ameynarkhede03@gmail.com>
Subject: [PATCH 4.19 210/247] staging: gdm724x: Fix DMA from stack
Date:   Mon,  1 Mar 2021 17:13:50 +0100
Message-Id: <20210301161041.958899544@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amey Narkhede <ameynarkhede03@gmail.com>

commit 7c3a0635cd008eaca9a734dc802709ee0b81cac5 upstream.

Stack allocated buffers cannot be used for DMA
on all architectures so allocate hci_packet buffer
using kmalloc.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Amey Narkhede <ameynarkhede03@gmail.com>
Link: https://lore.kernel.org/r/20210211053819.34858-1-ameynarkhede03@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gdm724x/gdm_usb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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


