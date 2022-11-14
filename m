Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244CD6280A4
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiKNNHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237873AbiKNNHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EA52B24F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBD52B80EC1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B31C433C1;
        Mon, 14 Nov 2022 13:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431256;
        bh=2Z5DT0l2Ybuj7Mjpp/EgPb+QS7b+F3uqRm1/xs/ZNb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqTGHd8q5/0PcVk9KHV79G1/VpAVwE4Uz+OzpJjzEgvddXMwJm3mgQLhMWUssjjoF
         BewbOUjtfEzaPwi/oZI1+i0oeP4Z67PxliSXLlHGdSHwbOe9jGMwy42/8Wr0k8qNUh
         XETt/L4xnuf0/Ww3h+8iB4LUFwpPM97isGOqY+k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 158/190] dmaengine: idxd: Do not enable user type Work Queue without Shared Virtual Addressing
Date:   Mon, 14 Nov 2022 13:46:22 +0100
Message-Id: <20221114124505.726145509@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

commit 0ec8ce07394442d722806fe61b901a5b2b17249d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/cdev.c   |   18 ++++++++++++++++++
 include/uapi/linux/idxd.h |    1 +
 2 files changed, 19 insertions(+)

--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -312,6 +312,24 @@ static int idxd_user_drv_probe(struct id
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
--- a/include/uapi/linux/idxd.h
+++ b/include/uapi/linux/idxd.h
@@ -29,6 +29,7 @@ enum idxd_scmd_stat {
 	IDXD_SCMD_WQ_NO_SIZE = 0x800e0000,
 	IDXD_SCMD_WQ_NO_PRIV = 0x800f0000,
 	IDXD_SCMD_WQ_IRQ_ERR = 0x80100000,
+	IDXD_SCMD_WQ_USER_NO_IOMMU = 0x80110000,
 };
 
 #define IDXD_SCMD_SOFTERR_MASK	0x80000000


