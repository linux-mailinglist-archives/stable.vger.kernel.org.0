Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E262964644E
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 23:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiLGWwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 17:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiLGWwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 17:52:30 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C7B5C76C;
        Wed,  7 Dec 2022 14:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670453549; x=1701989549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t2DafPPSBT9Ml5FRPIZEHIKvXe0wTNw4tCplQE2Vzac=;
  b=R4bj3/ty52OZ0gSGzG2PUAksCVSmcDe1ZLUUjxnSh63s2V3GTONwb8ZA
   gZEC7ZO7wYcMrvLGpjg1Sras81vy6WqryUFcZPPtfNBTU/grFTkdm2459
   HE6Xe1MNTHwPb88ppJ7V2hoSm2dYID0DSTaxPENIJlCuJhAZGdGymjo5d
   Rpa+eDYJpj4EEeaMqV7lfj6m9SDItyl8IavnmhQG0JmGIEyjZzo2ae3jC
   pevg2vv0PWgbcTUQDHkdAX15Q8aIyNHBaxMb2iM/AGMYS5+rC4PBkj00q
   Ul4sD8fBP/5HY6klauiHwAqJKMobO5KDpfqyvrIPpu6pDzwq0ADn15PDJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="300439518"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="300439518"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 14:52:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="646781163"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="646781163"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 14:52:27 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     fenghua.yu@intel.com, dave.jiang@intel.com, vkoul@kernel.org,
        dmaengine@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH V2 3/3] dmaengine: idxd: Do not call DMX TX callbacks during workqueue disable
Date:   Wed,  7 Dec 2022 14:52:22 -0800
Message-Id: <37d06b772aa7f8863ca50f90930ea2fd80b38fc3.1670452419.git.reinette.chatre@intel.com>
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

On driver unload any pending descriptors are flushed and pending
DMA descriptors are explicitly completed:
idxd_dmaengine_drv_remove() ->
	drv_disable_wq() ->
		idxd_wq_free_irq() ->
			idxd_flush_pending_descs() ->
				idxd_dma_complete_txd()

With this done during driver unload any remaining descriptor is
likely stuck and can be dropped. Even so, the descriptor may still
have a callback set that could no longer be accessible. An
example of such a problem is when the dmatest fails and the dmatest
module is unloaded. The failure of dmatest leaves descriptors with
dma_async_tx_descriptor::callback pointing to code that no longer
exist. This causes a page fault as below at the time the IDXD driver
is unloaded when it attempts to run the callback:
 BUG: unable to handle page fault for address: ffffffffc0665190
 #PF: supervisor instruction fetch in kernel mode
 #PF: error_code(0x0010) - not-present page

Fix this by clearing the callback pointers on the transmit
descriptors only when workqueue is disabled.

Fixes: 403a2e236538 ("dmaengine: idxd: change MSIX allocation based on per wq activation")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: stable@vger.kernel.org
---
Changes since V1:
- Add Dave and Fenghua's Reviewed-by tags.
- Cc stable team (Fenghua).
- Move declaration local to block needing it (Fenghua).
- Add appropriate Fixes tag (Fenghua).

 drivers/dma/idxd/device.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index b4d7bb923a40..6d8ff664fdfb 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1173,8 +1173,19 @@ static void idxd_flush_pending_descs(struct idxd_irq_entry *ie)
 	spin_unlock(&ie->list_lock);
 
 	list_for_each_entry_safe(desc, itr, &flist, list) {
+		struct dma_async_tx_descriptor *tx;
+
 		list_del(&desc->list);
 		ctype = desc->completion->status ? IDXD_COMPLETE_NORMAL : IDXD_COMPLETE_ABORT;
+		/*
+		 * wq is being disabled. Any remaining descriptors are
+		 * likely to be stuck and can be dropped. callback could
+		 * point to code that is no longer accessible, for example
+		 * if dmatest module has been unloaded.
+		 */
+		tx = &desc->txd;
+		tx->callback = NULL;
+		tx->callback_result = NULL;
 		idxd_dma_complete_txd(desc, ctype, true);
 	}
 }
-- 
2.34.1

