Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FDF4F37CB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359538AbiDELT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349136AbiDEJtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5502D119;
        Tue,  5 Apr 2022 02:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02636B818F3;
        Tue,  5 Apr 2022 09:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68818C385A3;
        Tue,  5 Apr 2022 09:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151678;
        bh=68/DhO5dODneTJ5vXxjoSOTJudPdbEsjy/axiEHdOHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2Epm4jX+KeQZ6zOwxwuoyXi3Y7JG8L2Y5VozBzIr0e//9S89PJVfQbJz5m1uS1g2
         856+oudDueaiUX54PULLI/SeYQCXZpc+WRce5u/AnXtfFBR38kO6IwdmX3YUw6JmXg
         gfkniZ4EBtxGZceew028i5VHSVYCDrfDp34+GFvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 503/913] RDMA/irdma: Fix Passthrough mode in VM
Date:   Tue,  5 Apr 2022 09:26:05 +0200
Message-Id: <20220405070354.931496945@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit b200189626b5cefbaf8be9cadd7a28215e065bb9 ]

Using PCI_FUNC macro in a VM, when the device is in passthrough mode does
not provide the real function instance. This means that currently, devices
will not probe unless the instance in the VM matches the instance in the
host.

Fix this by getting the pf_id from the LAN during the probe.

Fixes: 8498a30e1b94 ("RDMA/irdma: Register auxiliary driver and implement private channel OPs")
Link: https://lore.kernel.org/r/20220225163211.127-3-shiraz.saleem@intel.com
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c       | 2 +-
 drivers/infiniband/hw/irdma/i40iw_if.c | 1 +
 drivers/infiniband/hw/irdma/main.c     | 1 +
 drivers/infiniband/hw/irdma/main.h     | 1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index aa119441eb45..4f763e552eae 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -1608,7 +1608,7 @@ static enum irdma_status_code irdma_initialize_dev(struct irdma_pci_f *rf)
 	info.fpm_commit_buf = mem.va;
 
 	info.bar0 = rf->hw.hw_addr;
-	info.hmc_fn_id = PCI_FUNC(rf->pcidev->devfn);
+	info.hmc_fn_id = rf->pf_id;
 	info.hw = &rf->hw;
 	status = irdma_sc_dev_init(rf->rdma_ver, &rf->sc_dev, &info);
 	if (status)
diff --git a/drivers/infiniband/hw/irdma/i40iw_if.c b/drivers/infiniband/hw/irdma/i40iw_if.c
index d219f64b2c3d..a6f758b61b0c 100644
--- a/drivers/infiniband/hw/irdma/i40iw_if.c
+++ b/drivers/infiniband/hw/irdma/i40iw_if.c
@@ -77,6 +77,7 @@ static void i40iw_fill_device_info(struct irdma_device *iwdev, struct i40e_info
 	rf->rdma_ver = IRDMA_GEN_1;
 	rf->gen_ops.request_reset = i40iw_request_reset;
 	rf->pcidev = cdev_info->pcidev;
+	rf->pf_id = cdev_info->fid;
 	rf->hw.hw_addr = cdev_info->hw_addr;
 	rf->cdev = cdev_info;
 	rf->msix_count = cdev_info->msix_count;
diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
index 51a41359e0b4..c556a36e7670 100644
--- a/drivers/infiniband/hw/irdma/main.c
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -226,6 +226,7 @@ static void irdma_fill_device_info(struct irdma_device *iwdev, struct ice_pf *pf
 	rf->hw.hw_addr = pf->hw.hw_addr;
 	rf->pcidev = pf->pdev;
 	rf->msix_count =  pf->num_rdma_msix;
+	rf->pf_id = pf->hw.pf_id;
 	rf->msix_entries = &pf->msix_entries[pf->rdma_base_vector];
 	rf->default_vsi.vsi_idx = vsi->vsi_num;
 	rf->protocol_used = IRDMA_ROCE_PROTOCOL_ONLY;
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index 8b215f3cee89..454b4b370386 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -257,6 +257,7 @@ struct irdma_pci_f {
 	u8 *mem_rsrc;
 	u8 rdma_ver;
 	u8 rst_to;
+	u8 pf_id;
 	enum irdma_protocol_used protocol_used;
 	u32 sd_type;
 	u32 msix_count;
-- 
2.34.1



