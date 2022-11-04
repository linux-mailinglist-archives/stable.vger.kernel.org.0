Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CC361A384
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 22:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiKDVmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 17:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiKDVmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 17:42:50 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E332A45A02;
        Fri,  4 Nov 2022 14:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667598169; x=1699134169;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XFmKhWDiEblK1zZizT+FhottjvwuinVYK67JG6gNMsw=;
  b=KML9Nx36zN18iQwnXfEjssYb2RfeOIL36a5+hGzWIQvVRaQ0nWr576Lc
   P6b3oMTT+R1X1LKVZM3XuZAOuEKk4cyg2exDVWuNo3Ge/TePQfTBYDhVK
   wqq/K2u37Ri0kIPfozocnECMM1gDfDrCl2SftsGKsoHt7Tq8+SzhABfT7
   C0lmTFG4TMFJy1rz2B7cXGNVvucemwI/Ty6gyO+Sl2O5qtv6+MamYLLOB
   jj4frc1leT33nxwkJP3ykD7/9+YwP3wL/QnkcpsTGonzLI4sc3mvsu0Iz
   qcrB6xCF18QkRgdTYI21izljFK3drGn2/WUorb4TnCbsbHnNwzmWGMIby
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="311830587"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="311830587"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 14:42:48 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="635237084"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="635237084"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.112.74]) ([10.212.112.74])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 14:42:48 -0700
Message-ID: <f2d043bc-b2ec-e6a3-e5cf-f37fdee0fb37@intel.com>
Date:   Fri, 4 Nov 2022 14:42:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH 3/7] cxl/pmem: Fix cxl_pmem_region and cxl_memdev leak
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        alison.schofield@intel.com, ira.weiny@intel.com
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
 <166752183647.947915.2045230911503793901.stgit@dwillia2-xfh.jf.intel.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166752183647.947915.2045230911503793901.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/3/2022 5:30 PM, Dan Williams wrote:
> When a cxl_nvdimm object goes through a ->remove() event (device
> physically removed, nvdimm-bridge disabled, or nvdimm device disabled),
> then any associated regions must also be disabled. As highlighted by the
> cxl-create-region.sh test [1], a single device may host multiple
> regions, but the driver was only tracking one region at a time. This
> leads to a situation where only the last enabled region per nvdimm
> device is cleaned up properly. Other regions are leaked, and this also
> causes cxl_memdev reference leaks.
> 
> Fix the tracking by allowing cxl_nvdimm objects to track multiple region
> associations.
> 
> Cc: <stable@vger.kernel.org>
> Link: https://github.com/pmem/ndctl/blob/main/test/cxl-create-region.sh [1]
> Reported-by: Vishal Verma <vishal.l.verma@intel.com>
> Fixes: 04ad63f086d1 ("cxl/region: Introduce cxl_pmem_region objects")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/core/pmem.c |    2 +
>   drivers/cxl/cxl.h       |    2 -
>   drivers/cxl/pmem.c      |  100 ++++++++++++++++++++++++++++++-----------------
>   3 files changed, 67 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> index 1d12a8206444..36aa5070d902 100644
> --- a/drivers/cxl/core/pmem.c
> +++ b/drivers/cxl/core/pmem.c
> @@ -188,6 +188,7 @@ static void cxl_nvdimm_release(struct device *dev)
>   {
>   	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
>   
> +	xa_destroy(&cxl_nvd->pmem_regions);
>   	kfree(cxl_nvd);
>   }
>   
> @@ -230,6 +231,7 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
>   
>   	dev = &cxl_nvd->dev;
>   	cxl_nvd->cxlmd = cxlmd;
> +	xa_init(&cxl_nvd->pmem_regions);
>   	device_initialize(dev);
>   	lockdep_set_class(&dev->mutex, &cxl_nvdimm_key);
>   	device_set_pm_not_required(dev);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index f680450f0b16..1164ad49f3d3 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -423,7 +423,7 @@ struct cxl_nvdimm {
>   	struct device dev;
>   	struct cxl_memdev *cxlmd;
>   	struct cxl_nvdimm_bridge *bridge;
> -	struct cxl_pmem_region *region;
> +	struct xarray pmem_regions;
>   };
>   
>   struct cxl_pmem_region_mapping {
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 0bac05d804bc..c98ff5eb85a6 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -30,17 +30,20 @@ static void unregister_nvdimm(void *nvdimm)
>   	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
>   	struct cxl_nvdimm_bridge *cxl_nvb = cxl_nvd->bridge;
>   	struct cxl_pmem_region *cxlr_pmem;
> +	unsigned long index;
>   
>   	device_lock(&cxl_nvb->dev);
> -	cxlr_pmem = cxl_nvd->region;
>   	dev_set_drvdata(&cxl_nvd->dev, NULL);
> -	cxl_nvd->region = NULL;
> -	device_unlock(&cxl_nvb->dev);
> +	xa_for_each(&cxl_nvd->pmem_regions, index, cxlr_pmem) {
> +		get_device(&cxlr_pmem->dev);
> +		device_unlock(&cxl_nvb->dev);
>   
> -	if (cxlr_pmem) {
>   		device_release_driver(&cxlr_pmem->dev);
>   		put_device(&cxlr_pmem->dev);
> +
> +		device_lock(&cxl_nvb->dev);
>   	}
> +	device_unlock(&cxl_nvb->dev);
>   
>   	nvdimm_delete(nvdimm);
>   	cxl_nvd->bridge = NULL;
> @@ -366,25 +369,48 @@ static int match_cxl_nvdimm(struct device *dev, void *data)
>   
>   static void unregister_nvdimm_region(void *nd_region)
>   {
> -	struct cxl_nvdimm_bridge *cxl_nvb;
> -	struct cxl_pmem_region *cxlr_pmem;
> +	nvdimm_region_delete(nd_region);
> +}
> +
> +static int cxl_nvdimm_add_region(struct cxl_nvdimm *cxl_nvd,
> +				 struct cxl_pmem_region *cxlr_pmem)
> +{
> +	int rc;
> +
> +	rc = xa_insert(&cxl_nvd->pmem_regions, (unsigned long)cxlr_pmem,
> +		       cxlr_pmem, GFP_KERNEL);
> +	if (rc)
> +		return rc;
> +
> +	get_device(&cxlr_pmem->dev);
> +	return 0;
> +}
> +
> +static void cxl_nvdimm_del_region(struct cxl_nvdimm *cxl_nvd, struct cxl_pmem_region *cxlr_pmem)
> +{
> +	/*
> +	 * It is possible this is called without a corresponding
> +	 * cxl_nvdimm_add_region for @cxlr_pmem
> +	 */
> +	cxlr_pmem = xa_erase(&cxl_nvd->pmem_regions, (unsigned long)cxlr_pmem);
> +	if (cxlr_pmem)
> +		put_device(&cxlr_pmem->dev);
> +}
> +
> +static void release_mappings(void *data)
> +{
>   	int i;
> +	struct cxl_pmem_region *cxlr_pmem = data;
> +	struct cxl_nvdimm_bridge *cxl_nvb = cxlr_pmem->bridge;
>   
> -	cxlr_pmem = nd_region_provider_data(nd_region);
> -	cxl_nvb = cxlr_pmem->bridge;
>   	device_lock(&cxl_nvb->dev);
>   	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
>   		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
>   		struct cxl_nvdimm *cxl_nvd = m->cxl_nvd;
>   
> -		if (cxl_nvd->region) {
> -			put_device(&cxlr_pmem->dev);
> -			cxl_nvd->region = NULL;
> -		}
> +		cxl_nvdimm_del_region(cxl_nvd, cxlr_pmem);
>   	}
>   	device_unlock(&cxl_nvb->dev);
> -
> -	nvdimm_region_delete(nd_region);
>   }
>   
>   static void cxlr_pmem_remove_resource(void *res)
> @@ -422,7 +448,7 @@ static int cxl_pmem_region_probe(struct device *dev)
>   	if (!cxl_nvb->nvdimm_bus) {
>   		dev_dbg(dev, "nvdimm bus not found\n");
>   		rc = -ENXIO;
> -		goto err;
> +		goto out_nvb;
>   	}
>   
>   	memset(&mappings, 0, sizeof(mappings));
> @@ -431,7 +457,7 @@ static int cxl_pmem_region_probe(struct device *dev)
>   	res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
>   	if (!res) {
>   		rc = -ENOMEM;
> -		goto err;
> +		goto out_nvb;
>   	}
>   
>   	res->name = "Persistent Memory";
> @@ -442,11 +468,11 @@ static int cxl_pmem_region_probe(struct device *dev)
>   
>   	rc = insert_resource(&iomem_resource, res);
>   	if (rc)
> -		goto err;
> +		goto out_nvb;
>   
>   	rc = devm_add_action_or_reset(dev, cxlr_pmem_remove_resource, res);
>   	if (rc)
> -		goto err;
> +		goto out_nvb;
>   
>   	ndr_desc.res = res;
>   	ndr_desc.provider_data = cxlr_pmem;
> @@ -462,7 +488,7 @@ static int cxl_pmem_region_probe(struct device *dev)
>   	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
>   	if (!nd_set) {
>   		rc = -ENOMEM;
> -		goto err;
> +		goto out_nvb;
>   	}
>   
>   	ndr_desc.memregion = cxlr->id;
> @@ -472,9 +498,13 @@ static int cxl_pmem_region_probe(struct device *dev)
>   	info = kmalloc_array(cxlr_pmem->nr_mappings, sizeof(*info), GFP_KERNEL);
>   	if (!info) {
>   		rc = -ENOMEM;
> -		goto err;
> +		goto out_nvb;
>   	}
>   
> +	rc = devm_add_action_or_reset(dev, release_mappings, cxlr_pmem);
> +	if (rc)
> +		goto out_nvd;
> +
>   	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
>   		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
>   		struct cxl_memdev *cxlmd = m->cxlmd;
> @@ -486,7 +516,7 @@ static int cxl_pmem_region_probe(struct device *dev)
>   			dev_dbg(dev, "[%d]: %s: no cxl_nvdimm found\n", i,
>   				dev_name(&cxlmd->dev));
>   			rc = -ENODEV;
> -			goto err;
> +			goto out_nvd;
>   		}
>   
>   		/* safe to drop ref now with bridge lock held */
> @@ -498,10 +528,17 @@ static int cxl_pmem_region_probe(struct device *dev)
>   			dev_dbg(dev, "[%d]: %s: no nvdimm found\n", i,
>   				dev_name(&cxlmd->dev));
>   			rc = -ENODEV;
> -			goto err;
> +			goto out_nvd;
>   		}
> -		cxl_nvd->region = cxlr_pmem;
> -		get_device(&cxlr_pmem->dev);
> +
> +		/*
> +		 * Pin the region per nvdimm device as those may be released
> +		 * out-of-order with respect to the region, and a single nvdimm
> +		 * maybe associated with multiple regions
> +		 */
> +		rc = cxl_nvdimm_add_region(cxl_nvd, cxlr_pmem);
> +		if (rc)
> +			goto out_nvd;
>   		m->cxl_nvd = cxl_nvd;
>   		mappings[i] = (struct nd_mapping_desc) {
>   			.nvdimm = nvdimm,
> @@ -527,27 +564,18 @@ static int cxl_pmem_region_probe(struct device *dev)
>   		nvdimm_pmem_region_create(cxl_nvb->nvdimm_bus, &ndr_desc);
>   	if (!cxlr_pmem->nd_region) {
>   		rc = -ENOMEM;
> -		goto err;
> +		goto out_nvd;
>   	}
>   
>   	rc = devm_add_action_or_reset(dev, unregister_nvdimm_region,
>   				      cxlr_pmem->nd_region);
> -out:
> +out_nvd:
>   	kfree(info);
> +out_nvb:
>   	device_unlock(&cxl_nvb->dev);
>   	put_device(&cxl_nvb->dev);
>   
>   	return rc;
> -
> -err:
> -	dev_dbg(dev, "failed to create nvdimm region\n");
> -	for (i--; i >= 0; i--) {
> -		nvdimm = mappings[i].nvdimm;
> -		cxl_nvd = nvdimm_provider_data(nvdimm);
> -		put_device(&cxl_nvd->region->dev);
> -		cxl_nvd->region = NULL;
> -	}
> -	goto out;
>   }
>   
>   static struct cxl_driver cxl_pmem_region_driver = {
> 
