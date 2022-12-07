Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2A264644B
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 23:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiLGWwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 17:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLGWw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 17:52:29 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F012685662;
        Wed,  7 Dec 2022 14:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670453549; x=1701989549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EHXrUzFqhtjrtp+2R9Fafu9ntu7u1UaPLUSfczdzlWE=;
  b=DClaJA0v7HFjSN6HKpvW/VK4O6LjOB9I+4aLVx/TRXAiBPaoANbEFI0C
   VCbQ2DhNeEMXvSfpsAZgk9DhN+qXRKsD8O+h5mihcjgQfBullDQkNr1II
   qQuy0+WSu5ulYiqTzaFxYG3a1jX8amIcOnLyIM1mRZs1MjiSpQ/xE3HdA
   3UMcksGv5ECPBJsMpXi0OHjNvQmdQE1Stssgg4n7YNL62UXE1C5x/2cdb
   FqoiS7/36yPQzwKkt/7M1EGd7ReDXZyQbHrRktmgikYmTuWUWJhJOvWdB
   7MTTndxNIB7Trt8I72fCoOiGLiC2NF0MXpNJ+hihzRTanQHbiJxTig7df
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="300439516"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="300439516"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 14:52:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="646781161"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="646781161"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 14:52:27 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     fenghua.yu@intel.com, dave.jiang@intel.com, vkoul@kernel.org,
        dmaengine@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH V2 2/3] dmaengine: idxd: Prevent use after free on completion memory
Date:   Wed,  7 Dec 2022 14:52:21 -0800
Message-Id: <6c4657d9cff0a0a00501a7b928297ac966e9ec9d.1670452419.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1670452419.git.reinette.chatre@intel.com>
References: <cover.1670452419.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On driver unload any pending descriptors are flushed at the
time the interrupt is freed:
idxd_dmaengine_drv_remove() ->
	drv_disable_wq() ->
		idxd_wq_free_irq() ->
			idxd_flush_pending_descs().

If there are any descriptors present that need to be flushed this
flow triggers a "not present" page fault as below:

 BUG: unable to handle page fault for address: ff391c97c70c9040
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page

The address that triggers the fault is the address of the
descriptor that was freed moments earlier via:
drv_disable_wq()->idxd_wq_free_resources()

Fix the use after free by freeing the descriptors after any possible
usage. This is done after idxd_wq_reset() to ensure that the memory
remains accessible during possible completion writes by the device.

Fixes: 63c14ae6c161 ("dmaengine: idxd: refactor wq driver enable/disable operations")
Suggested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: stable@vger.kernel.org
---
Changes since V1:
- Add Dave and Fenghua's Reviewed-by tags.
- cc stable team (Fenghua).

 drivers/dma/idxd/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index fcd03d29a941..b4d7bb923a40 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1408,11 +1408,11 @@ void drv_disable_wq(struct idxd_wq *wq)
 		dev_warn(dev, "Clients has claim on wq %d: %d\n",
 			 wq->id, idxd_wq_refcount(wq));
 
-	idxd_wq_free_resources(wq);
 	idxd_wq_unmap_portal(wq);
 	idxd_wq_drain(wq);
 	idxd_wq_free_irq(wq);
 	idxd_wq_reset(wq);
+	idxd_wq_free_resources(wq);
 	percpu_ref_exit(&wq->wq_active);
 	wq->type = IDXD_WQT_NONE;
 	wq->client_count = 0;
-- 
2.34.1

