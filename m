Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F07D61A366
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 22:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiKDVgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 17:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiKDVga (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 17:36:30 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAAE45EEC;
        Fri,  4 Nov 2022 14:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667597789; x=1699133789;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uW0UoDlK6NeYqKsrQ4vkjqOMmoi22z2YFfsS3iHW1S8=;
  b=frF4DxKMScN2P3fxpcuQKAVO0j50w+5eQqTbDW8Foj3nQRm49vWc7XR4
   BkSg8pZJ1lsiyLQWtLYUdJeO5Q1Tun1DscJxg/YFSAege72I0GAz5gQnQ
   jjoT8nkaoyhtgQ/tmGSB7tJ+DwuF3gs6uEutPcDUMIVDEbdmxj3k+2swv
   4/sJF2Ab3L3dhqg/HOfjIDiIiMcdVtR14ohPfox5bIh3wZ4gOLYtB0coJ
   pHMyeAfh6gY2bn2cz8Y0MPb9eEOdra4E2LR5XqNTvWWnHF8028aWSjhjB
   KB4ACD4xOa9/8OsGq7Us9KSCznEzXiWstGcRCKhJ0PUyWUIsbdZSQXRZ4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="310079190"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="310079190"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 14:36:29 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="964490279"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="964490279"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.112.74]) ([10.212.112.74])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 14:36:29 -0700
Message-ID: <00353b48-7709-fbca-c261-ffb34a160ffa@intel.com>
Date:   Fri, 4 Nov 2022 14:36:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH 1/7] cxl/region: Fix region HPA ordering validation
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, vishal.l.verma@intel.com,
        alison.schofield@intel.com, ira.weiny@intel.com
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
 <166752182461.947915.497032805239915067.stgit@dwillia2-xfh.jf.intel.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166752182461.947915.497032805239915067.stgit@dwillia2-xfh.jf.intel.com>
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
> Some regions may not have any address space allocated. Skip them when
> validating HPA order otherwise a crash like the following may result:
> 
>   devm_cxl_add_region: cxl_acpi cxl_acpi.0: decoder3.4: created region9
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   [..]
>   RIP: 0010:store_targetN+0x655/0x1740 [cxl_core]
>   [..]
>   Call Trace:
>    <TASK>
>    kernfs_fop_write_iter+0x144/0x200
>    vfs_write+0x24a/0x4d0
>    ksys_write+0x69/0xf0
>    do_syscall_64+0x3a/0x90
> 
> store_targetN+0x655/0x1740:
> alloc_region_ref at drivers/cxl/core/region.c:676
> (inlined by) cxl_port_attach_region at drivers/cxl/core/region.c:850
> (inlined by) cxl_region_attach at drivers/cxl/core/region.c:1290
> (inlined by) attach_target at drivers/cxl/core/region.c:1410
> (inlined by) store_targetN at drivers/cxl/core/region.c:1453
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 384e624bb211 ("cxl/region: Attach endpoint decoders")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/core/region.c |    3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index bb6f4fc84a3f..d26ca7a6beae 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -658,6 +658,9 @@ static struct cxl_region_ref *alloc_region_ref(struct cxl_port *port,
>   	xa_for_each(&port->regions, index, iter) {
>   		struct cxl_region_params *ip = &iter->region->params;
>   
> +		if (!ip->res)
> +			continue;
> +
>   		if (ip->res->start > p->res->start) {
>   			dev_dbg(&cxlr->dev,
>   				"%s: HPA order violation %s:%pr vs %pr\n",
> 
