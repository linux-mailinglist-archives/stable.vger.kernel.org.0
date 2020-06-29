Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D49620E644
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404100AbgF2Vps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbgF2Sfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E334124631;
        Mon, 29 Jun 2020 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443960;
        bh=suxS3uWxS2tL0+jBGETGD3bqF3me5u0sGxXU3krztR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwhDBbYqRZLBankpXnjMkSpwct+wj0CD+OfSJa9F6WywnjZNO32/vO1BCzJzs5mNE
         I84Z82YQYGoj+iZZWYFHoiPYGz629v0ePy6Ex+PfsiEOAAoFcP/W6iRkwUZKZ0fWh4
         H+jdemzfs5+jb82fwouH8kckX5SGE5JQm8jiia78=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 063/265] USB: ohci-sm501: Add missed iounmap() in remove
Date:   Mon, 29 Jun 2020 11:14:56 -0400
Message-Id: <20200629151818.2493727-64-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit 07c112fb09c86c0231f6ff0061a000ffe91c8eb9 upstream.

This driver misses calling iounmap() in remove to undo the ioremap()
called in probe.
Add the missed call to fix it.

Fixes: f54aab6ebcec ("usb: ohci-sm501 driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200610024844.3628408-1-hslester96@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-sm501.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
index cff9652403270..b91d50da6127f 100644
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -191,6 +191,7 @@ static int ohci_hcd_sm501_drv_remove(struct platform_device *pdev)
 	struct resource	*mem;
 
 	usb_remove_hcd(hcd);
+	iounmap(hcd->regs);
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-- 
2.25.1

