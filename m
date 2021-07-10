Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EC43C3784
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhGJXwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232168AbhGJXwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1355610D2;
        Sat, 10 Jul 2021 23:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960968;
        bh=o3QZXxVhxZeYBKkHIcEnwADUskqo2AUKgGixgFjWpJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYJFwUQHtpyuC6XcI8h5vCsLrBgedqoqfyL5kWotnB6DK2LuBPsjtR+AvDGveZ/hJ
         lTKCFERWy6x/S7G7mojCL7IrsHgcwv28I08WG8lY4wOpi5xKMHihjtU0tgDx5jGzXx
         m9iMj8F56yISdArIG71w2fll09RCqonflJb581LXmLKJGrm26H0XuobP29g6rXVeM8
         UyIRvdbf+iu8jeXNlEQ8DPe6z+wovxYBtD4xyGnmxtZC/vqaVzVIc9z0yYUy3VtUW9
         PyzmYSgKJZjc+ua5e/heon74rKwLd5g/9pPF6joVIF+vxxe30sYXavjdJJi2LUooz8
         ikRozDECw0sdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 07/43] PCI: hv: Fix a race condition when removing the device
Date:   Sat, 10 Jul 2021 19:48:39 -0400
Message-Id: <20210710234915.3220342-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

[ Upstream commit 94d22763207ac6633612b8d8e0ca4fba0f7aa139 ]

On removing the device, any work item (hv_pci_devices_present() or
hv_pci_eject_device()) scheduled on workqueue hbus->wq may still be running
and race with hv_pci_remove().

This can happen because the host may send PCI_EJECT or PCI_BUS_RELATIONS(2)
and decide to rescind the channel immediately after that.

Fix this by flushing/destroying the workqueue of hbus before doing hbus remove.

Link: https://lore.kernel.org/r/1620806800-30983-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 30 ++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 27a17a1e4a7c..c6122a1b0c46 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -444,7 +444,6 @@ enum hv_pcibus_state {
 	hv_pcibus_probed,
 	hv_pcibus_installed,
 	hv_pcibus_removing,
-	hv_pcibus_removed,
 	hv_pcibus_maximum
 };
 
@@ -3247,8 +3246,9 @@ static int hv_pci_bus_exit(struct hv_device *hdev, bool keep_devs)
 		struct pci_packet teardown_packet;
 		u8 buffer[sizeof(struct pci_message)];
 	} pkt;
-	struct hv_dr_state *dr;
 	struct hv_pci_compl comp_pkt;
+	struct hv_pci_dev *hpdev, *tmp;
+	unsigned long flags;
 	int ret;
 
 	/*
@@ -3260,9 +3260,16 @@ static int hv_pci_bus_exit(struct hv_device *hdev, bool keep_devs)
 
 	if (!keep_devs) {
 		/* Delete any children which might still exist. */
-		dr = kzalloc(sizeof(*dr), GFP_KERNEL);
-		if (dr && hv_pci_start_relations_work(hbus, dr))
-			kfree(dr);
+		spin_lock_irqsave(&hbus->device_list_lock, flags);
+		list_for_each_entry_safe(hpdev, tmp, &hbus->children, list_entry) {
+			list_del(&hpdev->list_entry);
+			if (hpdev->pci_slot)
+				pci_destroy_slot(hpdev->pci_slot);
+			/* For the two refs got in new_pcichild_device() */
+			put_pcichild(hpdev);
+			put_pcichild(hpdev);
+		}
+		spin_unlock_irqrestore(&hbus->device_list_lock, flags);
 	}
 
 	ret = hv_send_resources_released(hdev);
@@ -3305,13 +3312,23 @@ static int hv_pci_remove(struct hv_device *hdev)
 
 	hbus = hv_get_drvdata(hdev);
 	if (hbus->state == hv_pcibus_installed) {
+		tasklet_disable(&hdev->channel->callback_event);
+		hbus->state = hv_pcibus_removing;
+		tasklet_enable(&hdev->channel->callback_event);
+		destroy_workqueue(hbus->wq);
+		hbus->wq = NULL;
+		/*
+		 * At this point, no work is running or can be scheduled
+		 * on hbus-wq. We can't race with hv_pci_devices_present()
+		 * or hv_pci_eject_device(), it's safe to proceed.
+		 */
+
 		/* Remove the bus from PCI's point of view. */
 		pci_lock_rescan_remove();
 		pci_stop_root_bus(hbus->pci_bus);
 		hv_pci_remove_slots(hbus);
 		pci_remove_root_bus(hbus->pci_bus);
 		pci_unlock_rescan_remove();
-		hbus->state = hv_pcibus_removed;
 	}
 
 	ret = hv_pci_bus_exit(hdev, false);
@@ -3326,7 +3343,6 @@ static int hv_pci_remove(struct hv_device *hdev)
 	irq_domain_free_fwnode(hbus->sysdata.fwnode);
 	put_hvpcibus(hbus);
 	wait_for_completion(&hbus->remove_event);
-	destroy_workqueue(hbus->wq);
 
 	hv_put_dom_num(hbus->sysdata.domain);
 
-- 
2.30.2

