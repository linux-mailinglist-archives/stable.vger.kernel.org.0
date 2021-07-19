Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751A53CE15F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349171AbhGSPZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346665AbhGSPRs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:17:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA03461351;
        Mon, 19 Jul 2021 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710274;
        bh=bokSFhtE64DNscl+L3fbLyFGcgNLs6XOG1XnZLEP0hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+lPKooqdAseWDaZcA6fnNwI/i2uSbtgIknVQjyoG1vu4vhzxMMKUYdnydA1qnc2T
         9XfkfzQKbyckDgSXhwx/O5nW7Ek6BPjswOzhqo6wARzoSiT9YpPrdoijcPB4LTm/6s
         gVCNOlcagUwFzuDgKGAKElkvuB8aQLVmNA23fqjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Long Li <longli@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/243] PCI: hv: Fix a race condition when removing the device
Date:   Mon, 19 Jul 2021 16:52:25 +0200
Message-Id: <20210719144944.654371841@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d57c538bbb2d..44e15f0e3a2e 100644
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



