Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687D868CAE8
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 01:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjBGAAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 19:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBGAAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 19:00:47 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D659A144AB;
        Mon,  6 Feb 2023 16:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675728047; x=1707264047;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kkLcdkLbgrI5YKBaLZkFwa+BwQtczIIiGVCz48/U8EA=;
  b=hw52/wMbyBsRN9EBtSPHEbprx72zopdV7KogkLK5n4EHwWszvCrRH0A9
   M0Jg2vYUR129Rn5AyosOOGCF0LKKbQz+RcqqTPTLH/V7v+IC+Oazv5JIC
   G6RUp+3mRo0V8H88FH1yl0rUMuIitRGwVUeeY6IGoQQDQI+fcazQeB6do
   FOkKVusVkvOfJUt4vPalC2/c4ciYzgJVCowtiauGTW7RNUhPCo98BnOai
   UNplIZRZ6BjKgma80JsRnrUXg57UIRoHicHdqjU0i3l05jBOtxB88EqBU
   H+SQl2sACOdnl6Pod7vHRpsFjKazaHiViw1HbHm4o07A+8DPtLXxs2QEG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="327986268"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="327986268"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 16:00:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="660004882"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="660004882"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.111.195]) ([10.212.111.195])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 16:00:14 -0800
Message-ID: <4db0288f-09a7-5b60-899c-c6f555e1c55e@intel.com>
Date:   Mon, 6 Feb 2023 17:00:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH 10/18] cxl/region: Fix passthrough-decoder detection
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, dave.hansen@linux.intel.com,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/5/23 6:03 PM, Dan Williams wrote:
> A passthrough decoder is a decoder that maps only 1 target. It is a
> special case because it does not impose any constraints on the
> interleave-math as compared to a decoder with multiple targets. Extend
> the passthrough case to multi-target-capable decoders that only have one
> target selected. I.e. the current code was only considering passthrough
> *ports* which are only a subset of the potential passthrough decoder
> scenarios.
> 
> Fixes: e4f6dfa9ef75 ("cxl/region: Fix 'distance' calculation with passthrough ports")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/core/region.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index c82d3b6f3d1f..34cf95217901 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -1019,10 +1019,10 @@ static int cxl_port_setup_targets(struct cxl_port *port,
>   		int i, distance;
>   
>   		/*
> -		 * Passthrough ports impose no distance requirements between
> +		 * Passthrough decoders impose no distance requirements between
>   		 * peers
>   		 */
> -		if (port->nr_dports == 1)
> +		if (cxl_rr->nr_targets == 1)
>   			distance = 0;
>   		else
>   			distance = p->nr_targets / cxl_rr->nr_targets;
> 
