Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511502169B1
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 12:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgGGKGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 06:06:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43049 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGGKGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 06:06:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id j4so42099854wrp.10;
        Tue, 07 Jul 2020 03:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=23vy72E5orNjWgQ+h1yoOH9UAR+rJOK6XwpQtfEVuLc=;
        b=cM6Hk4G6jzpJ5zFxahoh6TPmcmrxFLaP5PsDQODAET9mLkjLnMBqYfH/2rQ9tsbEHi
         DkyD5yctBc9KqqsWoAhor8mMEvIS7VCm66+4suh22CUwqOGd6LNpVOyvBTD0yTgxsiq+
         bvfWvFggjV+W8byYu0TI/YJFYDmRoDQD+R1T3Py+fu8u2NWybY4YA5OT5jzuwRFYUz1o
         3NEYsYfQfSXpXldORMWjVTELS34OCBCPwkYtrBkgGG3sJnsCdyyuRJucRchTEjzM/16+
         biF6Po0/PRAt5UHYQvoddRzb+bcBXeeRNwtcHBMHZW6qr8brp6iOjcJbfgPReBx0y/eB
         iJuw==
X-Gm-Message-State: AOAM530I28oLydkuDKU+Mtsh46zQ4wCS8Co58SeJGZZuyJFjKftuVlPW
        u4cmUd41IIljJHlp5MMYpzw=
X-Google-Smtp-Source: ABdhPJx0BB5CJ8IRPP7wZcpFAKcEtqcXu8b2tEnM5FooOgxWlc7cYpH2HfZCoJcvFlnV/vCsrbagEg==
X-Received: by 2002:a5d:43d2:: with SMTP id v18mr52161392wrr.196.1594116379745;
        Tue, 07 Jul 2020 03:06:19 -0700 (PDT)
Received: from localhost (ip-37-188-179-51.eurotel.cz. [37.188.179.51])
        by smtp.gmail.com with ESMTPSA id d2sm279540wrs.95.2020.07.07.03.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 03:06:18 -0700 (PDT)
Date:   Tue, 7 Jul 2020 12:06:17 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Jia He <justin.he@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Chuhong Yuan <hslester96@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-nvdimm@lists.01.org,
        Kaly Xin <Kaly.Xin@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/memory_hotplug: fix unpaired
 mem_hotplug_begin/done
Message-ID: <20200707100617.GD5913@dhcp22.suse.cz>
References: <20200707055917.143653-1-justin.he@arm.com>
 <20200707055917.143653-4-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707055917.143653-4-justin.he@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-07-20 13:59:17, Jia He wrote:
> When check_memblock_offlined_cb() returns failed rc(e.g. the memblock is
> online at that time), mem_hotplug_begin/done is unpaired in such case.
> 
> Therefore a warning:
>  Call Trace:
>   percpu_up_write+0x33/0x40
>   try_remove_memory+0x66/0x120
>   ? _cond_resched+0x19/0x30
>   remove_memory+0x2b/0x40
>   dev_dax_kmem_remove+0x36/0x72 [kmem]
>   device_release_driver_internal+0xf0/0x1c0
>   device_release_driver+0x12/0x20
>   bus_remove_device+0xe1/0x150
>   device_del+0x17b/0x3e0
>   unregister_dev_dax+0x29/0x60
>   devm_action_release+0x15/0x20
>   release_nodes+0x19a/0x1e0
>   devres_release_all+0x3f/0x50
>   device_release_driver_internal+0x100/0x1c0
>   driver_detach+0x4c/0x8f
>   bus_remove_driver+0x5c/0xd0
>   driver_unregister+0x31/0x50
>   dax_pmem_exit+0x10/0xfe0 [dax_pmem]
> 
> Fixes: f1037ec0cc8a ("mm/memory_hotplug: fix remove_memory() lockdep splat")
> Cc: stable@vger.kernel.org # v5.6+
> Signed-off-by: Jia He <justin.he@arm.com>

Ups, I have missed that when reviewing that commit. Thanks for catching
this up!

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memory_hotplug.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index da374cd3d45b..76c75a599da3 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1742,7 +1742,7 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
>  	 */
>  	rc = walk_memory_blocks(start, size, NULL, check_memblock_offlined_cb);
>  	if (rc)
> -		goto done;
> +		return rc;
>  
>  	/* remove memmap entry */
>  	firmware_map_remove(start, start + size, "System RAM");
> @@ -1766,9 +1766,8 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
>  
>  	try_offline_node(nid);
>  
> -done:
>  	mem_hotplug_done();
> -	return rc;
> +	return 0;
>  }
>  
>  /**
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs
