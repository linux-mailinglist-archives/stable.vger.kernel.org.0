Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628AD46FFD9
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhLJLdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:33:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54720 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240454AbhLJLdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:33:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22080B827CA
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3A0C00446;
        Fri, 10 Dec 2021 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639135805;
        bh=RzTHSroqdx0p/sjg+4zTxzn8l7XQ8bWGJIgjsLkos5w=;
        h=Subject:To:Cc:From:Date:From;
        b=qFnCFvVIPRiX1DSSZ0W0F59pFM+6IYkKz/np91RJ8ayTtdAsSejygwWopf9hMkjIO
         tUin7Pk/I8d5N9zwStW5yYM9zkvy7GmOk4i4oQidRig7K14gRvtGU/INmiR/wPxrX2
         1l9W7lbtkAFRzoCaexEORjRJcTtAATMp3evpgEIE=
Subject: FAILED: patch "[PATCH] IB/hfi1: Fix leak of rcvhdrtail_dummy_kvaddr" failed to apply to 4.9-stable tree
To:     mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 12:30:03 +0100
Message-ID: <163913580320121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 60a8b5a1611b4a26de4839ab9c1fc2a9cf3e17c1 Mon Sep 17 00:00:00 2001
From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Date: Mon, 29 Nov 2021 14:20:08 -0500
Subject: [PATCH] IB/hfi1: Fix leak of rcvhdrtail_dummy_kvaddr

This buffer is currently allocated in hfi1_init():

	if (reinit)
		ret = init_after_reset(dd);
	else
		ret = loadtime_init(dd);
	if (ret)
		goto done;

	/* allocate dummy tail memory for all receive contexts */
	dd->rcvhdrtail_dummy_kvaddr = dma_alloc_coherent(&dd->pcidev->dev,
							 sizeof(u64),
							 &dd->rcvhdrtail_dummy_dma,
							 GFP_KERNEL);

	if (!dd->rcvhdrtail_dummy_kvaddr) {
		dd_dev_err(dd, "cannot allocate dummy tail memory\n");
		ret = -ENOMEM;
		goto done;
	}

The reinit triggered path will overwrite the old allocation and leak it.

Fix by moving the allocation to hfi1_alloc_devdata() and the deallocation
to hfi1_free_devdata().

Link: https://lore.kernel.org/r/20211129192008.101968.91302.stgit@awfm-01.cornelisnetworks.com
Cc: stable@vger.kernel.org
Fixes: 46b010d3eeb8 ("staging/rdma/hfi1: Workaround to prevent corruption during packet delivery")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 6422dd6cae60..4436ed41547c 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -875,18 +875,6 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 	if (ret)
 		goto done;
 
-	/* allocate dummy tail memory for all receive contexts */
-	dd->rcvhdrtail_dummy_kvaddr = dma_alloc_coherent(&dd->pcidev->dev,
-							 sizeof(u64),
-							 &dd->rcvhdrtail_dummy_dma,
-							 GFP_KERNEL);
-
-	if (!dd->rcvhdrtail_dummy_kvaddr) {
-		dd_dev_err(dd, "cannot allocate dummy tail memory\n");
-		ret = -ENOMEM;
-		goto done;
-	}
-
 	/* dd->rcd can be NULL if early initialization failed */
 	for (i = 0; dd->rcd && i < dd->first_dyn_alloc_ctxt; ++i) {
 		/*
@@ -1200,6 +1188,11 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	dd->tx_opstats    = NULL;
 	kfree(dd->comp_vect);
 	dd->comp_vect = NULL;
+	if (dd->rcvhdrtail_dummy_kvaddr)
+		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
+				  (void *)dd->rcvhdrtail_dummy_kvaddr,
+				  dd->rcvhdrtail_dummy_dma);
+	dd->rcvhdrtail_dummy_kvaddr = NULL;
 	sdma_clean(dd, dd->num_sdma);
 	rvt_dealloc_device(&dd->verbs_dev.rdi);
 }
@@ -1297,6 +1290,15 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 		goto bail;
 	}
 
+	/* allocate dummy tail memory for all receive contexts */
+	dd->rcvhdrtail_dummy_kvaddr =
+		dma_alloc_coherent(&dd->pcidev->dev, sizeof(u64),
+				   &dd->rcvhdrtail_dummy_dma, GFP_KERNEL);
+	if (!dd->rcvhdrtail_dummy_kvaddr) {
+		ret = -ENOMEM;
+		goto bail;
+	}
+
 	atomic_set(&dd->ipoib_rsm_usr_num, 0);
 	return dd;
 
@@ -1504,13 +1506,6 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 
 	free_credit_return(dd);
 
-	if (dd->rcvhdrtail_dummy_kvaddr) {
-		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
-				  (void *)dd->rcvhdrtail_dummy_kvaddr,
-				  dd->rcvhdrtail_dummy_dma);
-		dd->rcvhdrtail_dummy_kvaddr = NULL;
-	}
-
 	/*
 	 * Free any resources still in use (usually just kernel contexts)
 	 * at unload; we do for ctxtcnt, because that's what we allocate.

