Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783C229B42A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784022AbgJ0O6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783999AbgJ0O6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 779A921527;
        Tue, 27 Oct 2020 14:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810728;
        bh=FATNVHPm99rro3GZKMTnOMG8Mf/AxyHQl51ekFCM3vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMoTMpd4ozuuRC/ZkutY2ylWI9uhYenkzz7FCujJ/ErO+LR40aPcVd7k62Msk4tK8
         RSui2GpFkXiUNgcYBZs+fp+RxWWSkQUFdVsVKp7pBxSpOj9R0X8pyBhx2hJhXlQjd6
         Oh4yavjPc+vrold/XruY9E/S3xPctaulO2KKLkaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 241/633] xhci: dont create endpoint debugfs entry before ring buffer is set.
Date:   Tue, 27 Oct 2020 14:49:44 +0100
Message-Id: <20201027135533.979231528@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 167657a1bb5fcde53ac304ce6c564bd90a2f9185 ]

Make sure xHC completes the configure endpoint command and xhci driver
sets the ring pointers correctly before we create the user readable
debugfs file.

In theory there was a small gap where a user could have read the
debugfs file and cause a NULL pointer dereference error as ring
pointer was not yet set, in practise we want this change to simplify
the upcoming streams debugfs support.

Fixes: 02b6fdc2a153 ("usb: xhci: Add debugfs interface for xHCI driver")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200918131752.16488-10-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 113ab5d3cbfe5..f665da34a8f73 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1915,8 +1915,6 @@ static int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	ep_ctx = xhci_get_ep_ctx(xhci, virt_dev->in_ctx, ep_index);
 	trace_xhci_add_endpoint(ep_ctx);
 
-	xhci_debugfs_create_endpoint(xhci, virt_dev, ep_index);
-
 	xhci_dbg(xhci, "add ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x\n",
 			(unsigned int) ep->desc.bEndpointAddress,
 			udev->slot_id,
@@ -2949,6 +2947,7 @@ static int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 		xhci_check_bw_drop_ep_streams(xhci, virt_dev, i);
 		virt_dev->eps[i].ring = virt_dev->eps[i].new_ring;
 		virt_dev->eps[i].new_ring = NULL;
+		xhci_debugfs_create_endpoint(xhci, virt_dev, i);
 	}
 command_cleanup:
 	kfree(command->completion);
-- 
2.25.1



