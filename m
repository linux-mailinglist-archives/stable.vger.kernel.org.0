Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F755B73EE
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiIMPO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiIMPMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:12:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA43642ED;
        Tue, 13 Sep 2022 07:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECDF4614AD;
        Tue, 13 Sep 2022 14:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1838CC433D6;
        Tue, 13 Sep 2022 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078582;
        bh=JdyY+3rs1YcamYFY6HEViqccXIHq0b/i1cdsWROpoBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTCDZUiznssSRVZ5t5z46Nm+HIlqdV9mRulm7S2UI8i/Uhea6Yg/DJQA5WXeUC/PR
         za0enx5H3UFHI31hh7QrIHOR15eeZuDrq4nzXu9biDi78XYNpuBdTFpf+68C+XqQ47
         usWZODV8z7HXohDgqAaQwyawbpQruGV2Dls5v/Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.19 189/192] iommu/virtio: Fix interaction with VFIO
Date:   Tue, 13 Sep 2022 16:04:55 +0200
Message-Id: <20220913140419.484866059@linuxfoundation.org>
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

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

commit 91c98fe7941499e4127cdc359c30841b873dd43a upstream.

Commit e8ae0e140c05 ("vfio: Require that devices support DMA cache
coherence") requires IOMMU drivers to advertise
IOMMU_CAP_CACHE_COHERENCY, in order to be used by VFIO. Since VFIO does
not provide to userspace the ability to maintain coherency through cache
invalidations, it requires hardware coherency. Advertise the capability
in order to restore VFIO support.

The meaning of IOMMU_CAP_CACHE_COHERENCY also changed from "IOMMU can
enforce cache coherent DMA transactions" to "IOMMU_CACHE is supported".
While virtio-iommu cannot enforce coherency (of PCIe no-snoop
transactions), it does support IOMMU_CACHE.

We can distinguish different cases of non-coherent DMA:

(1) When accesses from a hardware endpoint are not coherent. The host
    would describe such a device using firmware methods ('dma-coherent'
    in device-tree, '_CCA' in ACPI), since they are also needed without
    a vIOMMU. In this case mappings are created without IOMMU_CACHE.
    virtio-iommu doesn't need any additional support. It sends the same
    requests as for coherent devices.

(2) When the physical IOMMU supports non-cacheable mappings. Supporting
    those would require a new feature in virtio-iommu, new PROBE request
    property and MAP flags. Device drivers would use a new API to
    discover this since it depends on the architecture and the physical
    IOMMU.

(3) When the hardware supports PCIe no-snoop. It is possible for
    assigned PCIe devices to issue no-snoop transactions, and the
    virtio-iommu specification is lacking any mention of this.

    Arm platforms don't necessarily support no-snoop, and those that do
    cannot enforce coherency of no-snoop transactions. Device drivers
    must be careful about assuming that no-snoop transactions won't end
    up cached; see commit e02f5c1bb228 ("drm: disable uncached DMA
    optimization for ARM and arm64"). On x86 platforms, the host may or
    may not enforce coherency of no-snoop transactions with the physical
    IOMMU. But according to the above commit, on x86 a driver which
    assumes that no-snoop DMA is compatible with uncached CPU mappings
    will also work if the host enforces coherency.

    Although these issues are not specific to virtio-iommu, it could be
    used to facilitate discovery and configuration of no-snoop. This
    would require a new feature bit, PROBE property and ATTACH/MAP
    flags.

Cc: stable@vger.kernel.org
Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20220825154622.86759-1-jean-philippe@linaro.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/virtio-iommu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 08eeafc9529f..80151176ba12 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1006,7 +1006,18 @@ static int viommu_of_xlate(struct device *dev, struct of_phandle_args *args)
 	return iommu_fwspec_add_ids(dev, args->args, 1);
 }
 
+static bool viommu_capable(enum iommu_cap cap)
+{
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static struct iommu_ops viommu_ops = {
+	.capable		= viommu_capable,
 	.domain_alloc		= viommu_domain_alloc,
 	.probe_device		= viommu_probe_device,
 	.probe_finalize		= viommu_probe_finalize,
-- 
2.37.3



