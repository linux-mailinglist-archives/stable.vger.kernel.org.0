Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05CC0621592
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiKHONN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbiKHONI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCF757B4B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69AC0615C6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9E6C433D6;
        Tue,  8 Nov 2022 14:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916785;
        bh=rOzpADIXO8z0tLyBdhEKSW76j2qti28IBRL9K1wZ1QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pI+dw0AQRrDqTqPZy4Z4tTxU6ZlztIxddmt5ZQ6zOl/kifBFrA1EsmIJ+bI5hCV5x
         YFl/V4W1DI3kv3EBCOXV9E+jPy/rKjN59Z7motz9MZjbBrrxOFBYJtCDJzTz3syP0u
         i3G9gIweqmjpTZTfPeGKIZ8t6474zoULKn0Wak94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.0 133/197] cxl/pmem: Fix cxl_pmem_region and cxl_memdev leak
Date:   Tue,  8 Nov 2022 14:39:31 +0100
Message-Id: <20221108133400.999374743@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

commit 4d07ae22e79ebc2d7528bbc69daa53b86981cb3a upstream.

When a cxl_nvdimm object goes through a ->remove() event (device
physically removed, nvdimm-bridge disabled, or nvdimm device disabled),
then any associated regions must also be disabled. As highlighted by the
cxl-create-region.sh test [1], a single device may host multiple
regions, but the driver was only tracking one region at a time. This
leads to a situation where only the last enabled region per nvdimm
device is cleaned up properly. Other regions are leaked, and this also
causes cxl_memdev reference leaks.

Fix the tracking by allowing cxl_nvdimm objects to track multiple region
associations.

Cc: <stable@vger.kernel.org>
Link: https://github.com/pmem/ndctl/blob/main/test/cxl-create-region.sh [1]
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Fixes: 04ad63f086d1 ("cxl/region: Introduce cxl_pmem_region objects")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/166752183647.947915.2045230911503793901.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pmem.c |    2 
 drivers/cxl/cxl.h       |    2 
 drivers/cxl/pmem.c      |  101 ++++++++++++++++++++++++++++++------------------
 3 files changed, 68 insertions(+), 37 deletions(-)

--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -188,6 +188,7 @@ static void cxl_nvdimm_release(struct de
 {
 	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
 
+	xa_destroy(&cxl_nvd->pmem_regions);
 	kfree(cxl_nvd);
 }
 
@@ -230,6 +231,7 @@ static struct cxl_nvdimm *cxl_nvdimm_all
 
 	dev = &cxl_nvd->dev;
 	cxl_nvd->cxlmd = cxlmd;
+	xa_init(&cxl_nvd->pmem_regions);
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_nvdimm_key);
 	device_set_pm_not_required(dev);
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -423,7 +423,7 @@ struct cxl_nvdimm {
 	struct device dev;
 	struct cxl_memdev *cxlmd;
 	struct cxl_nvdimm_bridge *bridge;
-	struct cxl_pmem_region *region;
+	struct xarray pmem_regions;
 };
 
 struct cxl_pmem_region_mapping {
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -30,17 +30,20 @@ static void unregister_nvdimm(void *nvdi
 	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
 	struct cxl_nvdimm_bridge *cxl_nvb = cxl_nvd->bridge;
 	struct cxl_pmem_region *cxlr_pmem;
+	unsigned long index;
 
 	device_lock(&cxl_nvb->dev);
-	cxlr_pmem = cxl_nvd->region;
 	dev_set_drvdata(&cxl_nvd->dev, NULL);
-	cxl_nvd->region = NULL;
-	device_unlock(&cxl_nvb->dev);
+	xa_for_each(&cxl_nvd->pmem_regions, index, cxlr_pmem) {
+		get_device(&cxlr_pmem->dev);
+		device_unlock(&cxl_nvb->dev);
 
-	if (cxlr_pmem) {
 		device_release_driver(&cxlr_pmem->dev);
 		put_device(&cxlr_pmem->dev);
+
+		device_lock(&cxl_nvb->dev);
 	}
+	device_unlock(&cxl_nvb->dev);
 
 	nvdimm_delete(nvdimm);
 	cxl_nvd->bridge = NULL;
@@ -366,25 +369,49 @@ static int match_cxl_nvdimm(struct devic
 
 static void unregister_nvdimm_region(void *nd_region)
 {
-	struct cxl_nvdimm_bridge *cxl_nvb;
-	struct cxl_pmem_region *cxlr_pmem;
+	nvdimm_region_delete(nd_region);
+}
+
+static int cxl_nvdimm_add_region(struct cxl_nvdimm *cxl_nvd,
+				 struct cxl_pmem_region *cxlr_pmem)
+{
+	int rc;
+
+	rc = xa_insert(&cxl_nvd->pmem_regions, (unsigned long)cxlr_pmem,
+		       cxlr_pmem, GFP_KERNEL);
+	if (rc)
+		return rc;
+
+	get_device(&cxlr_pmem->dev);
+	return 0;
+}
+
+static void cxl_nvdimm_del_region(struct cxl_nvdimm *cxl_nvd,
+				  struct cxl_pmem_region *cxlr_pmem)
+{
+	/*
+	 * It is possible this is called without a corresponding
+	 * cxl_nvdimm_add_region for @cxlr_pmem
+	 */
+	cxlr_pmem = xa_erase(&cxl_nvd->pmem_regions, (unsigned long)cxlr_pmem);
+	if (cxlr_pmem)
+		put_device(&cxlr_pmem->dev);
+}
+
+static void release_mappings(void *data)
+{
 	int i;
+	struct cxl_pmem_region *cxlr_pmem = data;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlr_pmem->bridge;
 
-	cxlr_pmem = nd_region_provider_data(nd_region);
-	cxl_nvb = cxlr_pmem->bridge;
 	device_lock(&cxl_nvb->dev);
 	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
 		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
 		struct cxl_nvdimm *cxl_nvd = m->cxl_nvd;
 
-		if (cxl_nvd->region) {
-			put_device(&cxlr_pmem->dev);
-			cxl_nvd->region = NULL;
-		}
+		cxl_nvdimm_del_region(cxl_nvd, cxlr_pmem);
 	}
 	device_unlock(&cxl_nvb->dev);
-
-	nvdimm_region_delete(nd_region);
 }
 
 static void cxlr_pmem_remove_resource(void *res)
@@ -422,7 +449,7 @@ static int cxl_pmem_region_probe(struct
 	if (!cxl_nvb->nvdimm_bus) {
 		dev_dbg(dev, "nvdimm bus not found\n");
 		rc = -ENXIO;
-		goto err;
+		goto out_nvb;
 	}
 
 	memset(&mappings, 0, sizeof(mappings));
@@ -431,7 +458,7 @@ static int cxl_pmem_region_probe(struct
 	res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
 	if (!res) {
 		rc = -ENOMEM;
-		goto err;
+		goto out_nvb;
 	}
 
 	res->name = "Persistent Memory";
@@ -442,11 +469,11 @@ static int cxl_pmem_region_probe(struct
 
 	rc = insert_resource(&iomem_resource, res);
 	if (rc)
-		goto err;
+		goto out_nvb;
 
 	rc = devm_add_action_or_reset(dev, cxlr_pmem_remove_resource, res);
 	if (rc)
-		goto err;
+		goto out_nvb;
 
 	ndr_desc.res = res;
 	ndr_desc.provider_data = cxlr_pmem;
@@ -462,7 +489,7 @@ static int cxl_pmem_region_probe(struct
 	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
 	if (!nd_set) {
 		rc = -ENOMEM;
-		goto err;
+		goto out_nvb;
 	}
 
 	ndr_desc.memregion = cxlr->id;
@@ -472,9 +499,13 @@ static int cxl_pmem_region_probe(struct
 	info = kmalloc_array(cxlr_pmem->nr_mappings, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		rc = -ENOMEM;
-		goto err;
+		goto out_nvb;
 	}
 
+	rc = devm_add_action_or_reset(dev, release_mappings, cxlr_pmem);
+	if (rc)
+		goto out_nvd;
+
 	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
 		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
 		struct cxl_memdev *cxlmd = m->cxlmd;
@@ -486,7 +517,7 @@ static int cxl_pmem_region_probe(struct
 			dev_dbg(dev, "[%d]: %s: no cxl_nvdimm found\n", i,
 				dev_name(&cxlmd->dev));
 			rc = -ENODEV;
-			goto err;
+			goto out_nvd;
 		}
 
 		/* safe to drop ref now with bridge lock held */
@@ -498,10 +529,17 @@ static int cxl_pmem_region_probe(struct
 			dev_dbg(dev, "[%d]: %s: no nvdimm found\n", i,
 				dev_name(&cxlmd->dev));
 			rc = -ENODEV;
-			goto err;
+			goto out_nvd;
 		}
-		cxl_nvd->region = cxlr_pmem;
-		get_device(&cxlr_pmem->dev);
+
+		/*
+		 * Pin the region per nvdimm device as those may be released
+		 * out-of-order with respect to the region, and a single nvdimm
+		 * maybe associated with multiple regions
+		 */
+		rc = cxl_nvdimm_add_region(cxl_nvd, cxlr_pmem);
+		if (rc)
+			goto out_nvd;
 		m->cxl_nvd = cxl_nvd;
 		mappings[i] = (struct nd_mapping_desc) {
 			.nvdimm = nvdimm,
@@ -527,27 +565,18 @@ static int cxl_pmem_region_probe(struct
 		nvdimm_pmem_region_create(cxl_nvb->nvdimm_bus, &ndr_desc);
 	if (!cxlr_pmem->nd_region) {
 		rc = -ENOMEM;
-		goto err;
+		goto out_nvd;
 	}
 
 	rc = devm_add_action_or_reset(dev, unregister_nvdimm_region,
 				      cxlr_pmem->nd_region);
-out:
+out_nvd:
 	kfree(info);
+out_nvb:
 	device_unlock(&cxl_nvb->dev);
 	put_device(&cxl_nvb->dev);
 
 	return rc;
-
-err:
-	dev_dbg(dev, "failed to create nvdimm region\n");
-	for (i--; i >= 0; i--) {
-		nvdimm = mappings[i].nvdimm;
-		cxl_nvd = nvdimm_provider_data(nvdimm);
-		put_device(&cxl_nvd->region->dev);
-		cxl_nvd->region = NULL;
-	}
-	goto out;
 }
 
 static struct cxl_driver cxl_pmem_region_driver = {


