Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072A36E2BAC
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjDNVWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 17:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjDNVWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 17:22:04 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9994E7DAF;
        Fri, 14 Apr 2023 14:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681507323; x=1713043323;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h4QT2TCucN3DcvYd9iVAV4FdFkHnHklt2ir45vfPYAQ=;
  b=GENkCXlxLo7+iOmaZfCcwvTy6Xoh5a4FpcJ/S+Vm18vjWIvoC9Svs4op
   H8bDQJxYt0J3tcphqI9KERrKwh8eNfNadniAQ/vxi3zzH9CN4Dmw/oAhl
   EYn9AO0n4ppmKaVPv2AE9FmYu1y/jm25pl+WV+2NlABWOOngWIAVPVCl3
   bBdGD0mABgTf/eSp52UNg6xVgZ5zIsAEVNQcj5/THJn1GjzWCfzUPw4CT
   zXhZXeyHl+k2LSAR5IKgSdVofffsoadn9LHf7OyhYEB1PcCKV+VrOf+Ri
   WzGiSiKVy+kprC1njt/et48qWR5rI96wYodBxUlE1xHLGT8syitJQhyVW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="346416104"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="346416104"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 14:22:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="689963192"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="689963192"
Received: from tpattadx-mobl1.amr.corp.intel.com (HELO [10.212.122.87]) ([10.212.122.87])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 14:22:02 -0700
Message-ID: <eec990c8-7996-9fd9-5a16-4cde97961ce0@intel.com>
Date:   Fri, 14 Apr 2023 14:22:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH 2/5] cxl/hdm: Use 4-byte reads to retrieve HDM decoder
 base+limit
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <168149842935.792294.13212627946146993066.stgit@dwillia2-xfh.jf.intel.com>
 <168149844056.792294.8224490474529733736.stgit@dwillia2-xfh.jf.intel.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <168149844056.792294.8224490474529733736.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/14/23 11:54 AM, Dan Williams wrote:
> The CXL specification mandates that 4-byte registers must be accessed
> with 4-byte access cycles. CXL 3.0 8.2.3 "Component Register Layout and
> Definition" states that the behavior is undefined if (2) 32-bit
> registers are accessed as an 8-byte quantity. It turns out that at least
> one hardware implementation is sensitive to this in practice. The @size
> variable results in zero with:
> 
>      size = readq(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
> 
> ...and the correct size with:
> 
>      lo = readl(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
>      hi = readl(hdm + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(which));
>      size = (hi << 32) + lo;
> 
> Fixes: d17d0540a0db ("cxl/core/hdm: Add CXL standard decoder enumeration to the core")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/core/hdm.c |   20 +++++++++++++-------
>   1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 35b338b716fe..6fdf7981ddc7 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -1,6 +1,5 @@
>   // SPDX-License-Identifier: GPL-2.0-only
>   /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
> -#include <linux/io-64-nonatomic-hi-lo.h>
>   #include <linux/seq_file.h>
>   #include <linux/device.h>
>   #include <linux/delay.h>
> @@ -785,8 +784,8 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
>   			    int *target_map, void __iomem *hdm, int which,
>   			    u64 *dpa_base, struct cxl_endpoint_dvsec_info *info)
>   {
> +	u64 size, base, skip, dpa_size, lo, hi;
>   	struct cxl_endpoint_decoder *cxled;
> -	u64 size, base, skip, dpa_size;
>   	bool committed;
>   	u32 remainder;
>   	int i, rc;
> @@ -801,8 +800,12 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
>   							which, info);
>   
>   	ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(which));
> -	base = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(which));
> -	size = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
> +	lo = readl(hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(which));
> +	hi = readl(hdm + CXL_HDM_DECODER0_BASE_HIGH_OFFSET(which));
> +	base = (hi << 32) + lo;
> +	lo = readl(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
> +	hi = readl(hdm + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(which));
> +	size = (hi << 32) + lo;
>   	committed = !!(ctrl & CXL_HDM_DECODER0_CTRL_COMMITTED);
>   	cxld->commit = cxl_decoder_commit;
>   	cxld->reset = cxl_decoder_reset;
> @@ -865,8 +868,9 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
>   		return rc;
>   
>   	if (!info) {
> -		target_list.value =
> -			ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
> +		lo = readl(hdm + CXL_HDM_DECODER0_TL_LOW(which));
> +		hi = readl(hdm + CXL_HDM_DECODER0_TL_HIGH(which));
> +		target_list.value = (hi << 32) + lo;
>   		for (i = 0; i < cxld->interleave_ways; i++)
>   			target_map[i] = target_list.target_id[i];
>   
> @@ -883,7 +887,9 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
>   			port->id, cxld->id, size, cxld->interleave_ways);
>   		return -ENXIO;
>   	}
> -	skip = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_SKIP_LOW(which));
> +	lo = readl(hdm + CXL_HDM_DECODER0_SKIP_LOW(which));
> +	hi = readl(hdm + CXL_HDM_DECODER0_SKIP_HIGH(which));
> +	skip = (hi << 32) + lo;
>   	cxled = to_cxl_endpoint_decoder(&cxld->dev);
>   	rc = devm_cxl_dpa_reserve(cxled, *dpa_base + skip, dpa_size, skip);
>   	if (rc) {
> 
