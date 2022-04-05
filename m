Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323214F28F2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbiDEIYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237586AbiDEISH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961786BDC5;
        Tue,  5 Apr 2022 01:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 095AA617F4;
        Tue,  5 Apr 2022 08:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137B0C385A0;
        Tue,  5 Apr 2022 08:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146022;
        bh=ruQ+tn/XcqaS9HpzdIkqsuCVFDvfI/j5VZCGzVgqnCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hm5tuqRPjzDYZpazs7sBYWxoE0yaZEZDyz8ZG94ARerCcTZIVzQMsxDzl7bAUry9N
         Nke4gVWa6QphzeRaqCq3t5HvmKkmhUnQCG/DZFfKtSWhESoODz/tL4YxY+0JQwKVzy
         wEGrzot4lx/wC1lZOsZTrVIgf6rFgYwyK1vNwbUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0614/1126] RDMA/irdma: Fix Passthrough mode in VM
Date:   Tue,  5 Apr 2022 09:22:41 +0200
Message-Id: <20220405070425.657598256@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 89234d04cc65..e46e3240cc9f 100644
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
index 43e962b97d6a..0886783db647 100644
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
index 9fab29039f1c..5e8e8860686d 100644
--- a/drivers/infiniband/hw/irdma/main.c
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -226,6 +226,7 @@ static void irdma_fill_device_info(struct irdma_device *iwdev, struct ice_pf *pf
 	rf->hw.hw_addr = pf->hw.hw_addr;
 	rf->pcidev = pf->pdev;
 	rf->msix_count =  pf->num_rdma_msix;
+	rf->pf_id = pf->hw.pf_id;
 	rf->msix_entries = &pf->msix_entries[pf->rdma_base_vector];
 	rf->default_vsi.vsi_idx = vsi->vsi_num;
 	rf->protocol_used = pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2 ?
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index cb218cab79ac..fb7faa85e4c9 100644
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



