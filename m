Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82473328F0E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241755AbhCATmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:42:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242095AbhCATfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A079865273;
        Mon,  1 Mar 2021 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619809;
        bh=6jbua2UHxglhLLVTcJHBXmMy+TvtkbpIqWQxKJ7beZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joPQJVoZocI+paeqRobDxb0fqBGuP+ZFxzeoNWgv4UAz7kgCweSKBP41ICDY2HlcI
         FP4A3tV+swTPyACVGqr/701Mk+rh7DKbPP2FcKiV83dnWcqO6mPNUGaXU/5Mh+E1zx
         ms5UOT3+VVo4GtapOTHYOpHbe90RMCCazfNUhCV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Amey Narkhede <ameynarkhede03@gmail.com>
Subject: [PATCH 5.10 559/663] staging: gdm724x: Fix DMA from stack
Date:   Mon,  1 Mar 2021 17:13:27 +0100
Message-Id: <20210301161209.534644063@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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


