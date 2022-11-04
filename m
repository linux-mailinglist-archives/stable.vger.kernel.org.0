Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8560618D34
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 01:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiKDAak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 20:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiKDAaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 20:30:39 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402BA22532;
        Thu,  3 Nov 2022 17:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667521838; x=1699057838;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RdTAViVJPqdEA/VFQjJvGq2X3cTDZ5Sh9s1xwwqbDO8=;
  b=USx/P+PvRE3pp/M4wZkPYo1WKewdXGLrgY7LReVYM0KeSV+VVrck1yQs
   RE2AAFdp58T8a+UMQ8begmd/c0zF/o5Df90rCbCbfm14q6QsUxkNLnSHo
   PBwwvQnCNfL9+q3EqZzownK9ut8D60Xi3GwUkTvRdRi+kxgpzi/UeRQq8
   nLvOuXxzrPz/6GR4gV4HTA0+r7cUYocso+wO8R4MB+ijGjCLIb/6WoeID
   7q5Ea/2hdX+FtbLhq+CBLrEnsax42cc0djbNzdvsVVcYq1e4P3IdJEn1o
   ezTmXpP9vJ+VxdSZ0kjQl4b/bD6OC/GYDokXU5cR1CGkkx3D+AihOTB1p
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="297304868"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="297304868"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:37 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="964151663"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="964151663"
Received: from arunvasu-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.53.48])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:37 -0700
Subject: [PATCH 3/7] cxl/pmem: Fix cxl_pmem_region and cxl_memdev leak
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        vishal.l.verma@intel.com, alison.schofield@intel.com,
        ira.weiny@intel.com, dave.jiang@intel.com
Date:   Thu, 03 Nov 2022 17:30:36 -0700
Message-ID: <166752183647.947915.2045230911503793901.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/pmem.c |    2 +
 drivers/cxl/cxl.h       |    2 -
 drivers/cxl/pmem.c      |  100 ++++++++++++++++++++++++++++++-----------------
 3 files changed, 67 insertions(+), 37 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 1d12a8206444..36aa5070d902 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -188,6 +188,7 @@ static void cxl_nvdimm_release(struct device *dev)
 {
 	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
 
+	xa_destroy(&cxl_nvd->pmem_regions);
 	kfree(cxl_nvd);
 }
 
@@ -230,6 +231,7 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
 
 	dev = &cxl_nvd->dev;
 	cxl_nvd->cxlmd = cxlmd;
+	xa_init(&cxl_nvd->pmem_regions);
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_nvdimm_key);
 	device_set_pm_not_required(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f680450f0b16..1164ad49f3d3 100644
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
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 0bac05d804bc..c98ff5eb85a6 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -30,17 +30,20 @@ static void unregister_nvdimm(void *nvdimm)
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
@@ -366,25 +369,48 @@ static int match_cxl_nvdimm(struct device *dev, void *data)
 
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
+static void cxl_nvdimm_del_region(struct cxl_nvdimm *cxl_nvd, struct cxl_pmem_region *cxlr_pmem)
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
@@ -422,7 +448,7 @@ static int cxl_pmem_region_probe(struct device *dev)
 	if (!cxl_nvb->nvdimm_bus) {
 		dev_dbg(dev, "nvdimm bus not found\n");
 		rc = -ENXIO;
-		goto err;
+		goto out_nvb;
 	}
 
 	memset(&mappings, 0, sizeof(mappings));
@@ -431,7 +457,7 @@ static int cxl_pmem_region_probe(struct device *dev)
 	res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
 	if (!res) {
 		rc = -ENOMEM;
-		goto err;
+		goto out_nvb;
 	}
 
 	res->name = "Persistent Memory";
@@ -442,11 +468,11 @@ static int cxl_pmem_region_probe(struct device *dev)
 
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
@@ -462,7 +488,7 @@ static int cxl_pmem_region_probe(struct device *dev)
 	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
 	if (!nd_set) {
 		rc = -ENOMEM;
-		goto err;
+		goto out_nvb;
 	}
 
 	ndr_desc.memregion = cxlr->id;
@@ -472,9 +498,13 @@ static int cxl_pmem_region_probe(struct device *dev)
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
@@ -486,7 +516,7 @@ static int cxl_pmem_region_probe(struct device *dev)
 			dev_dbg(dev, "[%d]: %s: no cxl_nvdimm found\n", i,
 				dev_name(&cxlmd->dev));
 			rc = -ENODEV;
-			goto err;
+			goto out_nvd;
 		}
 
 		/* safe to drop ref now with bridge lock held */
@@ -498,10 +528,17 @@ static int cxl_pmem_region_probe(struct device *dev)
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
@@ -527,27 +564,18 @@ static int cxl_pmem_region_probe(struct device *dev)
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

