Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E26C646447
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 23:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLGWw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 17:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLGWw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 17:52:28 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8745C76C;
        Wed,  7 Dec 2022 14:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670453548; x=1701989548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XBZP11mNcHV2eBtHsZ9qvq9/eQYOQwTjDlrcdxglGFU=;
  b=d348RYJoGHoCttwwdMlqBuYzB8jeY3INmnhFyH43GOvdDQxJaKm7iSgp
   t99o0YWMrTBxFkYb84kAM7NV4H6UK3KfZw52zGK4bKh6tdteLL5iWJjLL
   RfuI8iLj3bJbQOm78wLEU4niKoPRhUMYqNiArEX4IzDTf2ReOe/1iMk0R
   vi9kRyo9SVOdg0R2kqjnmy2VfqzB1GlDN9v6nMcwqTQywzKpJMEopQUFs
   vk7FqV6jrIGRjeHR3UPYnBjElbwDETj0M70p9v3QIm44+eUSnZRMXtbhe
   aepUsmOFHyCMp6xuALLmtDO52/hkuGfuO5HXUZ27yJIjILDOkMVJKHHg2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="300439513"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="300439513"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 14:52:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="646781156"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="646781156"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 14:52:27 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     fenghua.yu@intel.com, dave.jiang@intel.com, vkoul@kernel.org,
        dmaengine@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH V2 1/3] dmaengine: idxd: Let probe fail when workqueue cannot be enabled
Date:   Wed,  7 Dec 2022 14:52:20 -0800
Message-Id: <e8d8116e5efa0fd14fadc5adae6ffd319f0e5ff1.1670452419.git.reinette.chatre@intel.com>
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

The workqueue is enabled when the appropriate driver is loaded and
disabled when the driver is removed. When the driver is removed it
assumes that the workqueue was enabled successfully and proceeds to
free allocations made during workqueue enabling.

Failure during workqueue enabling does not prevent the driver from
being loaded. This is because the error path within drv_enable_wq()
returns success unless a second failure is encountered
during the error path. By returning success it is possible to load
the driver even if the workqueue cannot be enabled and
allocations that do not exist are attempted to be freed during
driver remove.

Some examples of problematic flows:
(a)

 idxd_dmaengine_drv_probe() -> drv_enable_wq() -> idxd_wq_request_irq():
 In above flow, if idxd_wq_request_irq() fails then
 idxd_wq_unmap_portal() is called on error exit path, but
 drv_enable_wq() returns 0 because idxd_wq_disable() succeeds. The
 driver is thus loaded successfully.

 idxd_dmaengine_drv_remove()->drv_disable_wq()->idxd_wq_unmap_portal()
 Above flow on driver unload triggers the WARN in devm_iounmap() because
 the device resource has already been removed during error path of
 drv_enable_wq().

(b)

 idxd_dmaengine_drv_probe() -> drv_enable_wq() -> idxd_wq_request_irq():
 In above flow, if idxd_wq_request_irq() fails then
 idxd_wq_init_percpu_ref() is never called to initialize the percpu
 counter, yet the driver loads successfully because drv_enable_wq()
 returns 0.

 idxd_dmaengine_drv_remove()->__idxd_wq_quiesce()->percpu_ref_kill():
 Above flow on driver unload triggers a BUG when attempting to drop the
 initial ref of the uninitialized percpu ref:
 BUG: kernel NULL pointer dereference, address: 0000000000000010

Fix the drv_enable_wq() error path by returning the original error that
indicates failure of workqueue enabling. This ensures that the probe
fails when an error is encountered and the driver remove paths are only
attempted when the workqueue was enabled successfully.

Fixes: 1f2bb40337f0 ("dmaengine: idxd: move wq_enable() to device.c")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: stable@vger.kernel.org
---
Changes since V1:
- Add Dave and Fenghua's Reviewed-by tags.
- Cc to stable team (Fenghua).

 drivers/dma/idxd/device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 6f44fa8f78a5..fcd03d29a941 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1391,8 +1391,7 @@ int drv_enable_wq(struct idxd_wq *wq)
 err_irq:
 	idxd_wq_unmap_portal(wq);
 err_map_portal:
-	rc = idxd_wq_disable(wq, false);
-	if (rc < 0)
+	if (idxd_wq_disable(wq, false))
 		dev_dbg(dev, "wq %s disable failed\n", dev_name(wq_confdev(wq)));
 err:
 	return rc;
-- 
2.34.1

