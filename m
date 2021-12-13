Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85ED472653
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbhLMJuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:50:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33790 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbhLMJsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:48:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54621B80CAB;
        Mon, 13 Dec 2021 09:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968BCC00446;
        Mon, 13 Dec 2021 09:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388901;
        bh=hmy33GyCJFjXIFWfOy8wJbuQLqmC0WISoCvlQnbGFdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DM0mQdn64f6Y/V6/Jo50G/k0EqavTLVVwy9Ll+RmGFtloolHTO+4KY1I3UphTrBhc
         Dq385O4WoLxG//Pk4xuKoJ3YdXd4agg69C1dXoFa5xpIVcOotgcd8Npzcb+5HdmtpC
         heusQ+x/Jj7ZQelVyGN+UbAwc29zzVp0zE08qdlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 016/132] IB/hfi1: Fix leak of rcvhdrtail_dummy_kvaddr
Date:   Mon, 13 Dec 2021 10:29:17 +0100
Message-Id: <20211213092939.641828114@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

commit 60a8b5a1611b4a26de4839ab9c1fc2a9cf3e17c1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/init.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -916,18 +916,6 @@ int hfi1_init(struct hfi1_devdata *dd, i
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
@@ -1241,6 +1229,11 @@ void hfi1_free_devdata(struct hfi1_devda
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
@@ -1338,6 +1331,15 @@ static struct hfi1_devdata *hfi1_alloc_d
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
 
@@ -1545,13 +1547,6 @@ static void cleanup_device_data(struct h
 
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


