Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F91330E71
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhCHMhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:37:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232547AbhCHMgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5FE6651DC;
        Mon,  8 Mar 2021 12:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615207010;
        bh=tpFSMrChHSCE+hN7NBVzg/f77Qh37HgaqH1j8aeAYJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PF/pyIQMG9iMvS8zTAuzRn2bepLq2tPdL1uaRHSVy6grpPUOOf63uUgS2Uq2Wtssp
         edui+UcMp86AzW4ya5tl1tZHPNSp0X/gWEwS35VSmwquBuuuxp/56YeNp0nntnWLmf
         CNiEkbUL6Q2Wwq5gjEutInrz+ltcZfskAERbGTzA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 39/44] iommu/tegra-smmu: Fix mc errors on tegra124-nyan
Date:   Mon,  8 Mar 2021 13:35:17 +0100
Message-Id: <20210308122720.461227515@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Nicolin Chen <nicoleotsuka@gmail.com>

[ Upstream commit 765a9d1d02b2f5996b05f5f65faa8a634adbe763 ]

Commit 25938c73cd79 ("iommu/tegra-smmu: Rework tegra_smmu_probe_device()")
removed certain hack in the tegra_smmu_probe() by relying on IOMMU core to
of_xlate SMMU's SID per device, so as to get rid of tegra_smmu_find() and
tegra_smmu_configure() that are typically done in the IOMMU core also.

This approach works for both existing devices that have DT nodes and other
devices (like PCI device) that don't exist in DT, on Tegra210 and Tegra3
upon testing. However, Page Fault errors are reported on tegra124-Nyan:

  tegra-mc 70019000.memory-controller: display0a: read @0xfe056b40:
	 EMEM address decode error (SMMU translation error [--S])
  tegra-mc 70019000.memory-controller: display0a: read @0xfe056b40:
	 Page fault (SMMU translation error [--S])

After debugging, I found that the mentioned commit changed some function
callback sequence of tegra-smmu's, resulting in enabling SMMU for display
client before display driver gets initialized. I couldn't reproduce exact
same issue on Tegra210 as Tegra124 (arm-32) differs at arch-level code.

Actually this Page Fault is a known issue, as on most of Tegra platforms,
display gets enabled by the bootloader for the splash screen feature, so
it keeps filling the framebuffer memory. A proper fix to this issue is to
1:1 linear map the framebuffer memory to IOVA space so the SMMU will have
the same address as the physical address in its page table. Yet, Thierry
has been working on the solution above for a year, and it hasn't merged.

Therefore, let's partially revert the mentioned commit to fix the errors.

The reason why we do a partial revert here is that we can still set priv
in ->of_xlate() callback for PCI devices. Meanwhile, devices existing in
DT, like display, will go through tegra_smmu_configure() at the stage of
bus_set_iommu() when SMMU gets probed(), as what it did before we merged
the mentioned commit.

Once we have the linear map solution for framebuffer memory, this change
can be cleaned away.

[Big thank to Guillaume who reported and helped debugging/verification]

Fixes: 25938c73cd79 ("iommu/tegra-smmu: Rework tegra_smmu_probe_device()")
Reported-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
Tested-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20210218220702.1962-1-nicoleotsuka@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/tegra-smmu.c | 72 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 4a3f095a1c26..97eb62f667d2 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -798,10 +798,70 @@ static phys_addr_t tegra_smmu_iova_to_phys(struct iommu_domain *domain,
 	return SMMU_PFN_PHYS(pfn) + SMMU_OFFSET_IN_PAGE(iova);
 }
 
+static struct tegra_smmu *tegra_smmu_find(struct device_node *np)
+{
+	struct platform_device *pdev;
+	struct tegra_mc *mc;
+
+	pdev = of_find_device_by_node(np);
+	if (!pdev)
+		return NULL;
+
+	mc = platform_get_drvdata(pdev);
+	if (!mc)
+		return NULL;
+
+	return mc->smmu;
+}
+
+static int tegra_smmu_configure(struct tegra_smmu *smmu, struct device *dev,
+				struct of_phandle_args *args)
+{
+	const struct iommu_ops *ops = smmu->iommu.ops;
+	int err;
+
+	err = iommu_fwspec_init(dev, &dev->of_node->fwnode, ops);
+	if (err < 0) {
+		dev_err(dev, "failed to initialize fwspec: %d\n", err);
+		return err;
+	}
+
+	err = ops->of_xlate(dev, args);
+	if (err < 0) {
+		dev_err(dev, "failed to parse SW group ID: %d\n", err);
+		iommu_fwspec_free(dev);
+		return err;
+	}
+
+	return 0;
+}
+
 static struct iommu_device *tegra_smmu_probe_device(struct device *dev)
 {
-	struct tegra_smmu *smmu = dev_iommu_priv_get(dev);
+	struct device_node *np = dev->of_node;
+	struct tegra_smmu *smmu = NULL;
+	struct of_phandle_args args;
+	unsigned int index = 0;
+	int err;
+
+	while (of_parse_phandle_with_args(np, "iommus", "#iommu-cells", index,
+					  &args) == 0) {
+		smmu = tegra_smmu_find(args.np);
+		if (smmu) {
+			err = tegra_smmu_configure(smmu, dev, &args);
+			of_node_put(args.np);
 
+			if (err < 0)
+				return ERR_PTR(err);
+
+			break;
+		}
+
+		of_node_put(args.np);
+		index++;
+	}
+
+	smmu = dev_iommu_priv_get(dev);
 	if (!smmu)
 		return ERR_PTR(-ENODEV);
 
@@ -1028,6 +1088,16 @@ struct tegra_smmu *tegra_smmu_probe(struct device *dev,
 	if (!smmu)
 		return ERR_PTR(-ENOMEM);
 
+	/*
+	 * This is a bit of a hack. Ideally we'd want to simply return this
+	 * value. However the IOMMU registration process will attempt to add
+	 * all devices to the IOMMU when bus_set_iommu() is called. In order
+	 * not to rely on global variables to track the IOMMU instance, we
+	 * set it here so that it can be looked up from the .probe_device()
+	 * callback via the IOMMU device's .drvdata field.
+	 */
+	mc->smmu = smmu;
+
 	size = BITS_TO_LONGS(soc->num_asids) * sizeof(long);
 
 	smmu->asids = devm_kzalloc(dev, size, GFP_KERNEL);
-- 
2.30.1



