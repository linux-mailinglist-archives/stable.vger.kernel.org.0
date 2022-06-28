Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DBE55F078
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 23:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiF1Vnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 17:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiF1Vnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 17:43:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338DA1A813;
        Tue, 28 Jun 2022 14:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656452619; x=1687988619;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=877yEAxaLt/FgfeCNRnVC7OgC3gK2oqMnJF8PqNmsHI=;
  b=mrZKbZ1TRv0+ZifucA5YmM8LJTovwFRPiA8AFOYtxvII1DcpZ52wEjA6
   3G1ahc2T+JgRZaE5JplAYrWZjDucjMXDysMDqGpRARsmu9hP6u6ClQV1T
   T9fdhxeqBY8g8y4mgVPjbYQxl9TSFGdgUtRsw98cUOfTwtJRHs12ZsdFN
   zvRGdIN4np2IBnXAhfucpftoLZsL0XQcM6XI2XHSL2AHN3ZuuYB+Te/8i
   D1HnStQEaye/DyTLA71fRwY5zEYrj917O7uO7ODCdo07EB15wLrhc4A/B
   jTzl4ilXesuQoxv+mj1KLyNaLb5NhZZ0KT79uwpH2AySQr2dDgGBH/clU
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="261656643"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="261656643"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 14:43:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="565206119"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 14:43:38 -0700
Date:   Tue, 28 Jun 2022 14:42:52 -0700
From:   Alison Schofield <alison.schofield@intel.com>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc:     "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "Cs, Abhi" <abhi.cs@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] cxl/mbox: Fix missing variable payload checks in cmd
 size validation
Message-ID: <20220628214252.GA1578802@alison-desk>
References: <20220628200427.601714-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628200427.601714-1-vishal.l.verma@intel.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 01:04:27PM -0700, Vishal Verma wrote:
> The conversion of command sizes to unsigned missed a couple of checks
> against variable size payloads during command validation, which made all
> variable payload commands unconditionally fail. Add the checks back using
> the new CXL_VARIABLE_PAYLOAD scheme.
> 
> Reported-by: Abhi Cs <abhi.cs@intel.com>
> Fixes: 26f89535a5bb ("cxl/mbox: Use type __u32 for mailbox payload sizes")
> Cc: <stable@vger.kernel.org>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

with one caveat below...
Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> ---
>  drivers/cxl/core/mbox.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 40e3ccb2bf3e..d929b89d12a7 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -355,12 +355,14 @@ static int cxl_to_mem_cmd(struct cxl_mem_command *mem_cmd,
>  		return -EBUSY;
>  
>  	/* Check the input buffer is the expected size */
> -	if (info->size_in != send_cmd->in.size)
> -		return -ENOMEM;
> +	if (info->size_in != CXL_VARIABLE_PAYLOAD)
> +		if (info->size_in != send_cmd->in.size)
> +			return -ENOMEM;

We can leave it to Dan to arbitrate, but I don't think nested
if's without brackets follow kernel coding style.

However, Dan didn't like my nested if's with brackets either.
He'd prefer using &&

>  
>  	/* Check the output buffer is at least large enough */
> -	if (send_cmd->out.size < info->size_out)
> -		return -ENOMEM;
> +	if (info->size_out != CXL_VARIABLE_PAYLOAD)
> +		if (send_cmd->out.size < info->size_out)
> +			return -ENOMEM;
>  
>  	*mem_cmd = (struct cxl_mem_command) {
>  		.info = {
> 
> base-commit: 1985cf58850562e4b960e19d46f0d8f19d6c7cbd
> -- 
> 2.36.1
> 
