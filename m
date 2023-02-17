Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0362F69B151
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 17:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBQQs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 11:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjBQQs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 11:48:27 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B23135247;
        Fri, 17 Feb 2023 08:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676652506; x=1708188506;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IA/4PGmAd0XvHLM9zMNTVNpe5n5IqOeMbX/Eg/2FnWc=;
  b=iVFzEoTNe71wRK7mFbWRHP97VCXpQ9dhwaqn9+1b9DwtE1J7Ci7d8l86
   KdZeC0dOx/Q2GPcNH/ZEzhyD5xdH9UvzU3iAAZ1ERLdah3ni7JSAltZsE
   cp3wgUt3wKXDNR1KiBzVpiKKZk6US6hU0CmFIlm4bogpoSS7o9jfhZo9d
   CMN7fio/wTsE6PDUEyAwz3lKhe3swyU7InfmNCXw461KZabGh9HE3WePD
   C9bUZV++jtYGSFQt0QW3Gx0I/heH32GFBU8cDByPZtPnzbEov7soW29ek
   c+cFUREti6BQ+NH6xqWkm+edqAkCo4uU04K6UbPZkOyna0YztidEFXOmA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="334225268"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="334225268"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 08:48:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="734368678"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="734368678"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.187.252]) ([10.213.187.252])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 08:48:23 -0800
Message-ID: <b802de75-ba4e-a23a-88c6-9a51505202f1@intel.com>
Date:   Fri, 17 Feb 2023 09:48:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH] dax/kmem: Fix leak of memory-hotplug resources
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>, linux-mm@kvack.org
References: <167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com>
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



On 2/16/23 1:36 AM, Dan Williams wrote:
> While experimenting with CXL region removal the following corruption of
> /proc/iomem appeared.
> 
> Before:
> f010000000-f04fffffff : CXL Window 0
>    f010000000-f02fffffff : region4
>      f010000000-f02fffffff : dax4.0
>        f010000000-f02fffffff : System RAM (kmem)
> 
> After (modprobe -r cxl_test):
> f010000000-f02fffffff : **redacted binary garbage**
>    f010000000-f02fffffff : System RAM (kmem)
> 
> ...and testing further the same is visible with persistent memory
> assigned to kmem:
> 
> Before:
> 480000000-243fffffff : Persistent Memory
>    480000000-57e1fffff : namespace3.0
>    580000000-243fffffff : dax3.0
>      580000000-243fffffff : System RAM (kmem)
> 
> After (ndctl disable-region all):
> 480000000-243fffffff : Persistent Memory
>    580000000-243fffffff : ***redacted binary garbage***
>      580000000-243fffffff : System RAM (kmem)
> 
> The corrupted data is from a use-after-free of the "dax4.0" and "dax3.0"
> resources, and it also shows that the "System RAM (kmem)" resource is
> not being removed. The bug does not appear after "modprobe -r kmem", it
> requires the parent of "dax4.0" and "dax3.0" to be removed which
> re-parents the leaked "System RAM (kmem)" instances. Those in turn
> reference the freed resource as a parent.
> 
> First up for the fix is release_mem_region_adjustable() needs to
> reliably delete the resource inserted by add_memory_driver_managed().
> That is thwarted by a check for IORESOURCE_SYSRAM that predates the
> dax/kmem driver, from commit:
> 
> 65c78784135f ("kernel, resource: check for IORESOURCE_SYSRAM in release_mem_region_adjustable")
> 
> That appears to be working around the behavior of HMM's
> "MEMORY_DEVICE_PUBLIC" facility that has since been deleted. With that
> check removed the "System RAM (kmem)" resource gets removed, but
> corruption still occurs occasionally because the "dax" resource is not
> reliably removed.
> 
> The dax range information is freed before the device is unregistered, so
> the driver can not reliably recall (another use after free) what it is
> meant to release. Lastly if that use after free got lucky, the driver
> was covering up the leak of "System RAM (kmem)" due to its use of
> release_resource() which detaches, but does not free, child resources.
> The switch to remove_resource() forces remove_memory() to be responsible
> for the deletion of the resource added by add_memory_driver_managed().
> 
> Fixes: c2f3011ee697 ("device-dax: add an allocation interface for device-dax instances")
> Cc: <stable@vger.kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/dax/bus.c  |    2 +-
>   drivers/dax/kmem.c |    4 ++--
>   kernel/resource.c  |   14 --------------
>   3 files changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 012d576004e9..67a64f4c472d 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -441,8 +441,8 @@ static void unregister_dev_dax(void *dev)
>   	dev_dbg(dev, "%s\n", __func__);
>   
>   	kill_dev_dax(dev_dax);
> -	free_dev_dax_ranges(dev_dax);
>   	device_del(dev);
> +	free_dev_dax_ranges(dev_dax);
>   	put_device(dev);
>   }
>   
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 918d01d3fbaa..7b36db6f1cbd 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -146,7 +146,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   		if (rc) {
>   			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
>   					i, range.start, range.end);
> -			release_resource(res);
> +			remove_resource(res);
>   			kfree(res);
>   			data->res[i] = NULL;
>   			if (mapped)
> @@ -195,7 +195,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>   
>   		rc = remove_memory(range.start, range_len(&range));
>   		if (rc == 0) {
> -			release_resource(data->res[i]);
> +			remove_resource(data->res[i]);
>   			kfree(data->res[i]);
>   			data->res[i] = NULL;
>   			success++;
> diff --git a/kernel/resource.c b/kernel/resource.c
> index ddbbacb9fb50..b1763b2fd7ef 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1343,20 +1343,6 @@ void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
>   			continue;
>   		}
>   
> -		/*
> -		 * All memory regions added from memory-hotplug path have the
> -		 * flag IORESOURCE_SYSTEM_RAM. If the resource does not have
> -		 * this flag, we know that we are dealing with a resource coming
> -		 * from HMM/devm. HMM/devm use another mechanism to add/release
> -		 * a resource. This goes via devm_request_mem_region and
> -		 * devm_release_mem_region.
> -		 * HMM/devm take care to release their resources when they want,
> -		 * so if we are dealing with them, let us just back off here.
> -		 */
> -		if (!(res->flags & IORESOURCE_SYSRAM)) {
> -			break;
> -		}
> -
>   		if (!(res->flags & IORESOURCE_MEM))
>   			break;
>   
> 
