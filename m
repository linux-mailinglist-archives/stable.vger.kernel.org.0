Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701BB61A378
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 22:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiKDVib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 17:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiKDViS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 17:38:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD9150F39;
        Fri,  4 Nov 2022 14:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667597889; x=1699133889;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RGX/VYC6eYQHY/sc/WDnzutv8xr0MtTF+XVy8D/N/qc=;
  b=Ysdnp0BehIZ9XzoQ23LLrZEsP8pcy8Jvu11QB1FC1AlrWGzQU0jT5mX/
   CDqxip6FO5RTtaUvrxjUkJNDPmS92h/JkbMN095xhoPmivsS73A0YzBqh
   g13qiV0z1qtsN9Ikq4U3ZjydMFV63GpyKcosLy4zMY4DqfboNaswPbr+/
   a09Byif3Y2bRP9gA4nGqZZ7SLNsJothl/cyYWGLp7ILnzagtoyNUymsLS
   QVvlm7uEYf4qCp2dOF4aJFVr0SdBM1EpjZPWsjQnMOv8P8bMLkwb+nJqp
   6AM5sSEAQZoVom/URAYEszUOJNex8z6DtQ71F50rnol34krCF6GBVrSQj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="310079432"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="310079432"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 14:38:09 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="668497914"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="668497914"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.112.74]) ([10.212.112.74])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 14:38:08 -0700
Message-ID: <62d41753-0e05-9e8c-1e29-f04fb4a9b22d@intel.com>
Date:   Fri, 4 Nov 2022 14:38:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH 2/7] cxl/region: Fix cxl_region leak, cleanup targets at
 region delete
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, vishal.l.verma@intel.com,
        alison.schofield@intel.com, ira.weiny@intel.com
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
 <166752183055.947915.17681995648556534844.stgit@dwillia2-xfh.jf.intel.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166752183055.947915.17681995648556534844.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/3/2022 5:30 PM, Dan Williams wrote:
> When a region is deleted any targets that have been previously assigned
> to that region hold references to it. Trigger those references to
> drop by detaching all targets at unregister_region() time.
> 
> Otherwise that region object will leak as userspace has lost the ability
> to detach targets once region sysfs is torn down.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: b9686e8c8e39 ("cxl/region: Enable the assignment of endpoint decoders to regions")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/core/region.c |   11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index d26ca7a6beae..c52465e09f26 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -1557,8 +1557,19 @@ static struct cxl_region *to_cxl_region(struct device *dev)
>   static void unregister_region(void *dev)
>   {
>   	struct cxl_region *cxlr = to_cxl_region(dev);
> +	struct cxl_region_params *p = &cxlr->params;
> +	int i;
>   
>   	device_del(dev);
> +
> +	/*
> +	 * Now that region sysfs is shutdown, the parameter block is now
> +	 * read-only, so no need to hold the region rwsem to access the
> +	 * region parameters.
> +	 */
> +	for (i = 0; i < p->interleave_ways; i++)
> +		detach_target(cxlr, i);
> +
>   	cxl_region_iomem_release(cxlr);
>   	put_device(dev);
>   }
> 
