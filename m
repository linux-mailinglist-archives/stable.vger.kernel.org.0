Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4467363FA8E
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 23:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiLAWaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 17:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiLAWaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 17:30:06 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06CABE4FC;
        Thu,  1 Dec 2022 14:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669933804; x=1701469804;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OdAdHfZ73Vvc7oFOd9hHRaEFIXNYMPRhuTK4KYP9RJc=;
  b=Hwtij2J4kGPsFjG5YTvd0MjypuxEUdHF3Abf60SkWgExyyALQG2VgGj+
   1iE0t622KgVVTCIg76hdXeWrxwINC6CWVbbEwEVyO1R3YMBVlYBTK0Qn0
   4JQmnAZu/X1ippxjLrNHErT0GPVuc2YYFBJRR0YU2zkYm9d9Oc+0Mvtfl
   2PQmT+AxvcI/YS99lfgPcp5Md4mvKEGq9/zAEneINMeRzcVLcXf7YBraY
   gUubYZgOILeRKu39MFNzjlf+Aeuk/OqSh+J8CQeG+OHePfGbupTqlFEfG
   Eua8RjatthThs5e65hsNO/EvaZX4DJPqZmHYI157Zo7BrRS5CzDuK9Auk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="377971085"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="377971085"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:30:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="646932259"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="646932259"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.66.184]) ([10.212.66.184])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:30:03 -0800
Message-ID: <a08e121f-db70-fbaf-3cc4-62322f70ffa0@intel.com>
Date:   Thu, 1 Dec 2022 15:30:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH 2/5] cxl/region: Fix missing probe failure
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, Jonathan.Cameron@huawei.com,
        nvdimm@lists.linux.dev, dave@stgolabs.net
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/1/2022 3:03 PM, Dan Williams wrote:
> cxl_region_probe() allows for regions not in the 'commit' state to be
> enabled. Fail probe when the region is not committed otherwise the
> kernel may indicate that an address range is active when none of the
> decoders are active.
> 
> Fixes: 8d48817df6ac ("cxl/region: Add region driver boiler plate")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/core/region.c |    3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index f9ae5ad284ff..1bc2ebefa2a5 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -1923,6 +1923,9 @@ static int cxl_region_probe(struct device *dev)
>   	 */
>   	up_read(&cxl_region_rwsem);
>   
> +	if (rc)
> +		return rc;
> +
>   	switch (cxlr->mode) {
>   	case CXL_DECODER_PMEM:
>   		return devm_cxl_add_pmem_region(cxlr);
> 
