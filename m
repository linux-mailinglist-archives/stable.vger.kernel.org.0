Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD28429012
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbhJKOEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238327AbhJKOCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:02:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6BAE611BF;
        Mon, 11 Oct 2021 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960685;
        bh=Tj7sLuridhwWepG5JvXi+SbE7as1HZoyo8i1lx/lhzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fK7tdbu/FmHjyPV/j+JT1aSd9Ha86zOzpX8tI+9tFpjUYVwIKOAO/Pf7zJsnIz0q+
         ncT2C0C7cpDuhmGddUVIBMIstte1e9HCLoZuQ4CQVPC2PLYa9RpYHdss92WvlwDVuj
         wzfhl6pWwpPWmBtfOOsuq/8j/0tEgGAcNLRdi+Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Long Li <longli@microsoft.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 046/151] PCI: hv: Fix sleep while in non-sleep context when removing child devices from the bus
Date:   Mon, 11 Oct 2021 15:45:18 +0200
Message-Id: <20211011134519.333377318@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

[ Upstream commit 41608b64b10b80fe00dd253cd8326ec8ad85930f ]

In hv_pci_bus_exit, the code is holding a spinlock while calling
pci_destroy_slot(), which takes a mutex.

This is not safe for spinlock. Fix this by moving the children to be
deleted to a list on the stack, and removing them after spinlock is
released.

Fixes: 94d22763207a ("PCI: hv: Fix a race condition when removing the device")

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Rob Herring <robh@kernel.org>
Cc: "Krzysztof Wilczyński" <kw@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/linux-hyperv/20210823152130.GA21501@kili/
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Link: https://lore.kernel.org/r/1630365207-20616-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index a53bd8728d0d..fc1a29acadbb 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3229,9 +3229,17 @@ static int hv_pci_bus_exit(struct hv_device *hdev, bool keep_devs)
 		return 0;
 
 	if (!keep_devs) {
-		/* Delete any children which might still exist. */
+		struct list_head removed;
+
+		/* Move all present children to the list on stack */
+		INIT_LIST_HEAD(&removed);
 		spin_lock_irqsave(&hbus->device_list_lock, flags);
-		list_for_each_entry_safe(hpdev, tmp, &hbus->children, list_entry) {
+		list_for_each_entry_safe(hpdev, tmp, &hbus->children, list_entry)
+			list_move_tail(&hpdev->list_entry, &removed);
+		spin_unlock_irqrestore(&hbus->device_list_lock, flags);
+
+		/* Remove all children in the list */
+		list_for_each_entry_safe(hpdev, tmp, &removed, list_entry) {
 			list_del(&hpdev->list_entry);
 			if (hpdev->pci_slot)
 				pci_destroy_slot(hpdev->pci_slot);
@@ -3239,7 +3247,6 @@ static int hv_pci_bus_exit(struct hv_device *hdev, bool keep_devs)
 			put_pcichild(hpdev);
 			put_pcichild(hpdev);
 		}
-		spin_unlock_irqrestore(&hbus->device_list_lock, flags);
 	}
 
 	ret = hv_send_resources_released(hdev);
-- 
2.33.0



