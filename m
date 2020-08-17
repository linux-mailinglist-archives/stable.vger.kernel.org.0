Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D71E246A3A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgHQPcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbgHQPcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C499220786;
        Mon, 17 Aug 2020 15:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678333;
        bh=gVKeEKKY+TbImxEgUxvijJBzrR3by6I8snMip+JEKHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lf4f76l1q/nQ6V1AfK4Vcp0pu4GMnrCYZrPzB5m6yFWpiKdxbCJsIuY11RSa/sj0k
         IJRHHRyUxnYGDQy4py3FpqdXPepEN1CyMe2I9iHBpk5KXifqwEELbZD6nVMDRxxcC8
         3K1FpKe1tnXFABNCVidM6M1p6uCMxTmcSK+Zy+GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Hu <weh@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 298/464] PCI: hv: Fix a timing issue which causes kdump to fail occasionally
Date:   Mon, 17 Aug 2020 17:14:11 +0200
Message-Id: <20200817143848.081418490@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Hu <weh@microsoft.com>

[ Upstream commit d6af2ed29c7c1c311b96dac989dcb991e90ee195 ]

Kdump could fail sometime on Hyper-V guest because the retry in
hv_pci_enter_d0() releases child device structures in hv_pci_bus_exit().

Although there is a second asynchronous device relations message sending
from the host, if this message arrives to the guest after
hv_send_resource_allocated() is called, the retry would fail.

Fix the problem by moving retry to hv_pci_probe() and start the retry
from hv_pci_query_relations() call.  This will cause a device relations
message to arrive to the guest synchronously; the guest would then be
able to rebuild the child device structures before calling
hv_send_resource_allocated().

Link: https://lore.kernel.org/r/20200727071731.18516-1-weh@microsoft.com
Fixes: c81992e7f4aa ("PCI: hv: Retry PCI bus D0 entry on invalid device state")
Signed-off-by: Wei Hu <weh@microsoft.com>
[lorenzo.pieralisi@arm.com: fixed a comment and commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 71 +++++++++++++++--------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index bf40ff09c99d6..d0033ff6c1437 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2759,10 +2759,8 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
 	struct pci_bus_d0_entry *d0_entry;
 	struct hv_pci_compl comp_pkt;
 	struct pci_packet *pkt;
-	bool retry = true;
 	int ret;
 
-enter_d0_retry:
 	/*
 	 * Tell the host that the bus is ready to use, and moved into the
 	 * powered-on state.  This includes telling the host which region
@@ -2789,38 +2787,6 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
 	if (ret)
 		goto exit;
 
-	/*
-	 * In certain case (Kdump) the pci device of interest was
-	 * not cleanly shut down and resource is still held on host
-	 * side, the host could return invalid device status.
-	 * We need to explicitly request host to release the resource
-	 * and try to enter D0 again.
-	 */
-	if (comp_pkt.completion_status < 0 && retry) {
-		retry = false;
-
-		dev_err(&hdev->device, "Retrying D0 Entry\n");
-
-		/*
-		 * Hv_pci_bus_exit() calls hv_send_resource_released()
-		 * to free up resources of its child devices.
-		 * In the kdump kernel we need to set the
-		 * wslot_res_allocated to 255 so it scans all child
-		 * devices to release resources allocated in the
-		 * normal kernel before panic happened.
-		 */
-		hbus->wslot_res_allocated = 255;
-
-		ret = hv_pci_bus_exit(hdev, true);
-
-		if (ret == 0) {
-			kfree(pkt);
-			goto enter_d0_retry;
-		}
-		dev_err(&hdev->device,
-			"Retrying D0 failed with ret %d\n", ret);
-	}
-
 	if (comp_pkt.completion_status < 0) {
 		dev_err(&hdev->device,
 			"PCI Pass-through VSP failed D0 Entry with status %x\n",
@@ -3058,6 +3024,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 	struct hv_pcibus_device *hbus;
 	u16 dom_req, dom;
 	char *name;
+	bool enter_d0_retry = true;
 	int ret;
 
 	/*
@@ -3178,11 +3145,47 @@ static int hv_pci_probe(struct hv_device *hdev,
 	if (ret)
 		goto free_fwnode;
 
+retry:
 	ret = hv_pci_query_relations(hdev);
 	if (ret)
 		goto free_irq_domain;
 
 	ret = hv_pci_enter_d0(hdev);
+	/*
+	 * In certain case (Kdump) the pci device of interest was
+	 * not cleanly shut down and resource is still held on host
+	 * side, the host could return invalid device status.
+	 * We need to explicitly request host to release the resource
+	 * and try to enter D0 again.
+	 * Since the hv_pci_bus_exit() call releases structures
+	 * of all its child devices, we need to start the retry from
+	 * hv_pci_query_relations() call, requesting host to send
+	 * the synchronous child device relations message before this
+	 * information is needed in hv_send_resources_allocated()
+	 * call later.
+	 */
+	if (ret == -EPROTO && enter_d0_retry) {
+		enter_d0_retry = false;
+
+		dev_err(&hdev->device, "Retrying D0 Entry\n");
+
+		/*
+		 * Hv_pci_bus_exit() calls hv_send_resources_released()
+		 * to free up resources of its child devices.
+		 * In the kdump kernel we need to set the
+		 * wslot_res_allocated to 255 so it scans all child
+		 * devices to release resources allocated in the
+		 * normal kernel before panic happened.
+		 */
+		hbus->wslot_res_allocated = 255;
+		ret = hv_pci_bus_exit(hdev, true);
+
+		if (ret == 0)
+			goto retry;
+
+		dev_err(&hdev->device,
+			"Retrying D0 failed with ret %d\n", ret);
+	}
 	if (ret)
 		goto free_irq_domain;
 
-- 
2.25.1



