Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F172004E2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 11:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgFSJVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 05:21:42 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:44113 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFSJVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 05:21:41 -0400
Received: by mail-ej1-f67.google.com with SMTP id gl26so9431450ejb.11
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 02:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KL+ndhO0kfyOLwFeHwdQcM1iXptREPKRwxWtQPH/dYg=;
        b=Y7/WxoJuLE5NK1+L3HxsOjhs4WGkky9ZubiukAxAEVM+6NqKPbmLGq2qwWYCmfeF74
         290gHGF8owDO90VrGVxMQYS/xmxq6elWqPpJXYLXySBEuWGucl+rqpLAtvJBdvgTUTpz
         LrRU4l56Sx5Z8SVzAD+k/hOY6m2GxHYBTgG+2vCLt4zeKM3+MUnYmp4ChxUTbC/kOVNO
         y80XDGWMjxANncg3Xd6MLrerbfa1BHKNwVlJnCQ+todjLFK+PEagKUyiv45OF7iNth+/
         3DoT2Get/T+i72T0L2fJHGsemh3WKGIEHP1w3XlxtLZYznna48KV+N/nYBV892M6Cetv
         kjxA==
X-Gm-Message-State: AOAM530FpWeWX/RA/HqrrA96jQkgqkoR35f7m0AkLfDylxlb6lXvTmiJ
        kN74q2vZv24DNhu7C7qq4MU=
X-Google-Smtp-Source: ABdhPJx6jrC598uJ4b8zRkO+dOTU+oOUUC+9WGz4iq5QgBoUBhF8FzczV1RyamoCf6wPb9R9QJQmag==
X-Received: by 2002:a17:907:4096:: with SMTP id nm6mr2776415ejb.4.1592558499399;
        Fri, 19 Jun 2020 02:21:39 -0700 (PDT)
Received: from localhost (ip-37-188-189-34.eurotel.cz. [37.188.189.34])
        by smtp.gmail.com with ESMTPSA id k2sm4385926ejc.20.2020.06.19.02.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 02:21:38 -0700 (PDT)
Date:   Fri, 19 Jun 2020 11:21:37 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org, dan.j.williams@intel.com,
        daniel.m.jordan@oracle.com, david@redhat.com, jmorris@namei.org,
        ktkhai@virtuozzo.com, pankaj.gupta.linux@gmail.com,
        shile.zhang@linux.alibaba.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, yiwei@redhat.com
Subject: Re: FAILED: patch "[PATCH] mm: call cond_resched() from
 deferred_init_memmap()" failed to apply to 5.7-stable tree
Message-ID: <20200619092137.GB12177@dhcp22.suse.cz>
References: <15924957437531@kroah.com>
 <20200618162649.GA250996@kroah.com>
 <20200619022822.GV1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619022822.GV1931@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 18-06-20 22:28:22, Sasha Levin wrote:
> On Thu, Jun 18, 2020 at 06:26:49PM +0200, Greg KH wrote:
> > On Thu, Jun 18, 2020 at 05:55:43PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.7-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > Oops, I applied things out of order, I've queued this and the 5.4
> > version up, but 4.19 doesn't apply as the dependant patch does not
> > apply.
> 
> Something like this should work?

Nope. Unless I am misreading the old code you are udner
pgdat_resize_lock. Or is there any other change queued before this
backport to remove the lock? (I didn't get to check more closely but it
would be 3d060856adfc5 IIRC).

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7181dfe76440..b7905a075e79 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1611,11 +1611,13 @@ static int __init deferred_init_memmap(void *data)
> 		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
> 		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
> 		nr_pages += deferred_init_pages(nid, zid, spfn, epfn);
> +		cond_resched();
> 	}
> 	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
> 		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
> 		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
> 		deferred_free_pages(nid, zid, spfn, epfn);
> +		cond_resched();
> 	}
> 
> 	/* Sanity check that the next zone really is unpopulated */
> 
> -- 
> Thanks,
> Sasha

-- 
Michal Hocko
SUSE Labs
