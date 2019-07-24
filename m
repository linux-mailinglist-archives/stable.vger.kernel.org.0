Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A53973976
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387860AbfGXTk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390010AbfGXTkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:40:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFBD8214AF;
        Wed, 24 Jul 2019 19:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997223;
        bh=c/YUiKX7SRfLLU+Th0LnAaFxq3iMI4jBQ6r9jQYjmKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qn4+dm48ocb+KjqQnVDq9yHvQj4dF287lHwvHNycqSQTKm3r76VG8VN6Xl3oK4sNh
         GDZy2/+eUX6DUeh3y0Rf5a1lVuVhFeWiD+r0oFZE7vXm8zPxFtPkqQ6MSbzZmv0AsU
         yUQhuH7rN4CNVxVJhocapTrtzIlOrpEGNquFoUyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 5.2 364/413] PCI: hv: Fix a use-after-free bug in hv_eject_device_work()
Date:   Wed, 24 Jul 2019 21:20:55 +0200
Message-Id: <20190724191801.511334259@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 4df591b20b80cb77920953812d894db259d85bd7 upstream.

Fix a use-after-free in hv_eject_device_work().

Fixes: 05f151a73ec2 ("PCI: hv: Fix a memory leak in hv_eject_device_work()")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/pci-hyperv.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1875,6 +1875,7 @@ static void hv_pci_devices_present(struc
 static void hv_eject_device_work(struct work_struct *work)
 {
 	struct pci_eject_response *ejct_pkt;
+	struct hv_pcibus_device *hbus;
 	struct hv_pci_dev *hpdev;
 	struct pci_dev *pdev;
 	unsigned long flags;
@@ -1885,6 +1886,7 @@ static void hv_eject_device_work(struct
 	} ctxt;
 
 	hpdev = container_of(work, struct hv_pci_dev, wrk);
+	hbus = hpdev->hbus;
 
 	WARN_ON(hpdev->state != hv_pcichild_ejecting);
 
@@ -1895,8 +1897,7 @@ static void hv_eject_device_work(struct
 	 * because hbus->pci_bus may not exist yet.
 	 */
 	wslot = wslot_to_devfn(hpdev->desc.win_slot.slot);
-	pdev = pci_get_domain_bus_and_slot(hpdev->hbus->sysdata.domain, 0,
-					   wslot);
+	pdev = pci_get_domain_bus_and_slot(hbus->sysdata.domain, 0, wslot);
 	if (pdev) {
 		pci_lock_rescan_remove();
 		pci_stop_and_remove_bus_device(pdev);
@@ -1904,9 +1905,9 @@ static void hv_eject_device_work(struct
 		pci_unlock_rescan_remove();
 	}
 
-	spin_lock_irqsave(&hpdev->hbus->device_list_lock, flags);
+	spin_lock_irqsave(&hbus->device_list_lock, flags);
 	list_del(&hpdev->list_entry);
-	spin_unlock_irqrestore(&hpdev->hbus->device_list_lock, flags);
+	spin_unlock_irqrestore(&hbus->device_list_lock, flags);
 
 	if (hpdev->pci_slot)
 		pci_destroy_slot(hpdev->pci_slot);
@@ -1915,7 +1916,7 @@ static void hv_eject_device_work(struct
 	ejct_pkt = (struct pci_eject_response *)&ctxt.pkt.message;
 	ejct_pkt->message_type.type = PCI_EJECTION_COMPLETE;
 	ejct_pkt->wslot.slot = hpdev->desc.win_slot.slot;
-	vmbus_sendpacket(hpdev->hbus->hdev->channel, ejct_pkt,
+	vmbus_sendpacket(hbus->hdev->channel, ejct_pkt,
 			 sizeof(*ejct_pkt), (unsigned long)&ctxt.pkt,
 			 VM_PKT_DATA_INBAND, 0);
 
@@ -1924,7 +1925,9 @@ static void hv_eject_device_work(struct
 	/* For the two refs got in new_pcichild_device() */
 	put_pcichild(hpdev);
 	put_pcichild(hpdev);
-	put_hvpcibus(hpdev->hbus);
+	/* hpdev has been freed. Do not use it any more. */
+
+	put_hvpcibus(hbus);
 }
 
 /**


