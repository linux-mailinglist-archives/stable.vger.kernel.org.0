Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5717627AE2
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbiKNKqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbiKNKqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:46:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EB12BD
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:46:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70D97B80DD1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A4CC433C1;
        Mon, 14 Nov 2022 10:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668422802;
        bh=TrsEQUZbjwzFfD8ndegPBis4Yjwn6R/ylMvLjVIxYDE=;
        h=Subject:To:Cc:From:Date:From;
        b=oT9Bmpsci2G4PItFhvB0NGD58ZdgONgLqiNaNO+8She7iVdgH773OZ9MuTdwO0oj+
         ArM1HM2ifv5eV/2CRpmg22A95Ct0GEX8OWU+s4I8jHtuYAvRhYqhOVYRZyEdZA3JtY
         dyZB12PM0FeNs+deMFCE/Y8mhCdc7OwdPJFUlFMo=
Subject: FAILED: patch "[PATCH] dmaengine: idxd: Do not enable user type Work Queue without" failed to apply to 5.15-stable tree
To:     fenghua.yu@intel.com, arjan.van.de.ven@intel.com,
        dave.jiang@intel.com, jsnitsel@redhat.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:46:38 +0100
Message-ID: <16684227982172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0ec8ce073944 ("dmaengine: idxd: Do not enable user type Work Queue without Shared Virtual Addressing")
403a2e236538 ("dmaengine: idxd: change MSIX allocation based on per wq activation")
23a50c803565 ("dmaengine: idxd: fix descriptor flushing locking")
ec0d64231615 ("dmaengine: idxd: embed irq_entry in idxd_wq struct")
56fc39f5a367 ("dmaengine: idxd: handle interrupt handle revoked event")
f6d442f7088c ("dmaengine: idxd: handle invalid interrupt handle descriptors")
bd5970a0d01f ("dmaengine: idxd: create locked version of idxd_quiesce() call")
46c6df1c958e ("dmaengine: idxd: add helper for per interrupt handle drain")
eb0cf33a91b4 ("dmaengine: idxd: move interrupt handle assignment")
8b67426e0558 ("dmaengine: idxd: int handle management refactoring")
5d78abb6fbc9 ("dmaengine: idxd: rework descriptor free path on failure")
a3e340c1574b ("dmaengine: idxd: fix resource leak on dmaengine driver disable")
e530a9f3db41 ("dmaengine: idxd: reconfig device after device reset command")
88d97ea82cbe ("dmaengine: idxd: add halt interrupt support")
85f604af9c83 ("dmaengine: idxd: move out percpu_ref_exit() to ensure it's outside submission")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0ec8ce07394442d722806fe61b901a5b2b17249d Mon Sep 17 00:00:00 2001
From: Fenghua Yu <fenghua.yu@intel.com>
Date: Fri, 14 Oct 2022 15:25:41 -0700
Subject: [PATCH] dmaengine: idxd: Do not enable user type Work Queue without
 Shared Virtual Addressing

When the idxd_user_drv driver is bound to a Work Queue (WQ) device
without IOMMU or with IOMMU Passthrough without Shared Virtual
Addressing (SVA), the application gains direct access to physical
memory via the device by programming physical address to a submitted
descriptor. This allows direct userspace read and write access to
arbitrary physical memory. This is inconsistent with the security
goals of a good kernel API.

Unlike vfio_pci driver, the IDXD char device driver does not provide any
ways to pin user pages and translate the address from user VA to IOVA or
PA without IOMMU SVA. Therefore the application has no way to instruct the
device to perform DMA function. This makes the char device not usable for
normal application usage.

Since user type WQ without SVA cannot be used for normal application usage
and presents the security issue, bind idxd_user_drv driver and enable user
type WQ only when SVA is enabled (i.e. user PASID is enabled).

Fixes: 448c3de8ac83 ("dmaengine: idxd: create user driver for wq 'device'")
Cc: stable@vger.kernel.org
Suggested-by: Arjan Van De Ven <arjan.van.de.ven@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20221014222541.3912195-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index c2808fd081d6..a9b96b18772f 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -312,6 +312,24 @@ static int idxd_user_drv_probe(struct idxd_dev *idxd_dev)
 	if (idxd->state != IDXD_DEV_ENABLED)
 		return -ENXIO;
 
+	/*
+	 * User type WQ is enabled only when SVA is enabled for two reasons:
+	 *   - If no IOMMU or IOMMU Passthrough without SVA, userspace
+	 *     can directly access physical address through the WQ.
+	 *   - The IDXD cdev driver does not provide any ways to pin
+	 *     user pages and translate the address from user VA to IOVA or
+	 *     PA without IOMMU SVA. Therefore the application has no way
+	 *     to instruct the device to perform DMA function. This makes
+	 *     the cdev not usable for normal application usage.
+	 */
+	if (!device_user_pasid_enabled(idxd)) {
+		idxd->cmd_status = IDXD_SCMD_WQ_USER_NO_IOMMU;
+		dev_dbg(&idxd->pdev->dev,
+			"User type WQ cannot be enabled without SVA.\n");
+
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&wq->wq_lock);
 	wq->type = IDXD_WQT_USER;
 	rc = drv_enable_wq(wq);
diff --git a/include/uapi/linux/idxd.h b/include/uapi/linux/idxd.h
index 095299c75828..2b9e7feba3f3 100644
--- a/include/uapi/linux/idxd.h
+++ b/include/uapi/linux/idxd.h
@@ -29,6 +29,7 @@ enum idxd_scmd_stat {
 	IDXD_SCMD_WQ_NO_SIZE = 0x800e0000,
 	IDXD_SCMD_WQ_NO_PRIV = 0x800f0000,
 	IDXD_SCMD_WQ_IRQ_ERR = 0x80100000,
+	IDXD_SCMD_WQ_USER_NO_IOMMU = 0x80110000,
 };
 
 #define IDXD_SCMD_SOFTERR_MASK	0x80000000

