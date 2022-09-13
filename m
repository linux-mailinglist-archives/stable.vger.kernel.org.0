Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF955B70C0
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiIMO3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbiIMO2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:28:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5515369F43;
        Tue, 13 Sep 2022 07:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66CA7614C9;
        Tue, 13 Sep 2022 14:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E03C433C1;
        Tue, 13 Sep 2022 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078584;
        bh=U8UxvLJjoGv1JsvME3fKk8Cxt4aR5PN71cGlnevRH3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8kv6MHR+x+Stuv/Ubg5/D9e+r+4Xe3a+L089Z0qTtUdOdBtxm4JualwKP3L77Mtn
         6IWsY9+zxr7/uQdknqGD4Nm3n4qM/mkyv5W1tvSSnqkZD8wn6sARCMcASwzvFGaXxb
         hLmJ1GAqpEU4O4BpOPSzyBkK2LEnvzRoEoo88gBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Takashi Iwai <tiwai@suse.de>, Jason Gunthorpe <jgg@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.19 190/192] iommu: Fix false ownership failure on AMD systems with PASID activated
Date:   Tue, 13 Sep 2022 16:04:56 +0200
Message-Id: <20220913140419.535249247@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit 2380f1e8195ef612deea1dc7a3d611c5d2b9b56a upstream.

The AMD IOMMU driver cannot activate PASID mode on a RID without the RID's
translation being set to IDENTITY. Further it requires changing the RID's
page table layout from the normal v1 IOMMU_DOMAIN_IDENTITY layout to a
different v2 layout.

It does this by creating a new iommu_domain, configuring that domain for
v2 identity operation and then attaching it to the group, from within the
driver. This logic assumes the group is already set to the IDENTITY domain
and is being used by the DMA API.

However, since the ownership logic is based on the group's domain pointer
equaling the default domain to detect DMA API ownership, this causes it to
look like the group is not attached to the DMA API any more. This blocks
attaching drivers to any other devices in the group.

In a real system this manifests itself as the HD-audio devices on some AMD
platforms losing their device drivers.

Work around this unique behavior of the AMD driver by checking for
equality of IDENTITY domains based on their type, not their pointer
value. This allows the AMD driver to have two IDENTITY domains for
internal purposes without breaking the check.

Have the AMD driver properly declare that the special domain it created is
actually an IDENTITY domain.

Cc: Robin Murphy <robin.murphy@arm.com>
Cc: stable@vger.kernel.org
Fixes: 512881eacfa7 ("bus: platform,amba,fsl-mc,PCI: Add device DMA ownership management")
Reported-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/0-v1-ea566e16b06b+811-amd_owner_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu_v2.c |    2 ++
 drivers/iommu/iommu.c        |   21 +++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -786,6 +786,8 @@ int amd_iommu_init_device(struct pci_dev
 	if (dev_state->domain == NULL)
 		goto out_free_states;
 
+	/* See iommu_is_default_domain() */
+	dev_state->domain->type = IOMMU_DOMAIN_IDENTITY;
 	amd_iommu_domain_direct_map(dev_state->domain);
 
 	ret = amd_iommu_domain_enable_v2(dev_state->domain, pasids);
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3089,6 +3089,24 @@ out:
 	return ret;
 }
 
+static bool iommu_is_default_domain(struct iommu_group *group)
+{
+	if (group->domain == group->default_domain)
+		return true;
+
+	/*
+	 * If the default domain was set to identity and it is still an identity
+	 * domain then we consider this a pass. This happens because of
+	 * amd_iommu_init_device() replacing the default idenytity domain with an
+	 * identity domain that has a different configuration for AMDGPU.
+	 */
+	if (group->default_domain &&
+	    group->default_domain->type == IOMMU_DOMAIN_IDENTITY &&
+	    group->domain && group->domain->type == IOMMU_DOMAIN_IDENTITY)
+		return true;
+	return false;
+}
+
 /**
  * iommu_device_use_default_domain() - Device driver wants to handle device
  *                                     DMA through the kernel DMA API.
@@ -3107,8 +3125,7 @@ int iommu_device_use_default_domain(stru
 
 	mutex_lock(&group->mutex);
 	if (group->owner_cnt) {
-		if (group->domain != group->default_domain ||
-		    group->owner) {
+		if (group->owner || !iommu_is_default_domain(group)) {
 			ret = -EBUSY;
 			goto unlock_out;
 		}


