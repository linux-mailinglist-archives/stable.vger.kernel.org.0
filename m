Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB1E443088
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 15:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhKBOiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 10:38:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47262 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBOiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 10:38:08 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 01AD41FD4E;
        Tue,  2 Nov 2021 14:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635863733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PZOYwTcs/uRKNYMtgWTyKzvzPAmp2lHm06+rRoOs/v4=;
        b=vQq48Hi9tmkUX4nm9Wzk1Fq+ApGIlZIIZmmiD9SmLhgmExEVMaSiVApTakHz0HYqIqdy44
        Ot3l2rxUuQ7ce7mmLPELGfrb1s4WWwDEC6Qn5wpi/v7GoGi94FHMUVj3KQTFdyyJYzllRl
        zjCzO1aYk947DkoYQKmzAyuTUh3hwbM=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B4221A3B87;
        Tue,  2 Nov 2021 14:35:32 +0000 (UTC)
Date:   Tue, 2 Nov 2021 15:35:32 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Oscar Salvador <osalvador@suse.de>
Cc:     David Hildenbrand <david@redhat.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <YYFMtFwkKLUXaG/W@dhcp22.suse.cz>
References: <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
 <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
 <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
 <YYEun6s/mF9bE+rQ@dhcp22.suse.cz>
 <e7aed7c0-b7b1-4a94-f323-0bcde2f879d2@redhat.com>
 <YYE8L4gs8/+HH6bf@dhcp22.suse.cz>
 <20211102135201.GA4348@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102135201.GA4348@linux>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 02-11-21 14:52:01, Oscar Salvador wrote:
> On Tue, Nov 02, 2021 at 02:25:03PM +0100, Michal Hocko wrote:
> > I think we want to learn how exactly Alexey brought that cpu up. Because
> > his initial thought on add_cpu resp cpu_up doesn't seem to be correct.
> > Or I am just not following the code properly. Once we know all those
> > details we can get in touch with cpu hotplug maintainers and see what
> > can we do.
> 
> I am not really familiar with CPU hot-onlining, but I have been taking a look.
> As with memory, there are two different stages, hot-adding and onlining (and the
> counterparts).
> 
> Part of the hot-adding being:
> 
> acpi_processor_get_info
>  acpi_processor_hotadd_init
>   arch_register_cpu
>    register_cpu
> 
> One of the things that register_cpu() does is to set cpu->dev.bus pointing to
> &cpu_subsys, which is:
> 
> struct bus_type cpu_subsys = {
> 	.name = "cpu",
> 	.dev_name = "cpu",
> 	.match = cpu_subsys_match,
> #ifdef CONFIG_HOTPLUG_CPU
> 	.online = cpu_subsys_online,
> 	.offline = cpu_subsys_offline,
> #endif
> };
> 
> Then, the onlining part (in case of a udev rule or someone onlining the device)
> would be:
> 
> online_store
>  device_online
>   cpu_subsys_online
>    cpu_device_up
>     cpu_up
>      ...
>      online node
> 
> Since Alexey disabled the udev rule and no one onlined the CPU, online_store()->
> device_online() wasn't really called.
> 
> The following only applies to x86_64:
> I think we got confused because cpu_device_up() is also called from add_cpu(),
> but that is an exported function and x86 does not call add_cpu() unless for
> debugging purposes (check kernel/torture.c and arch/x86/kernel/topology.c).
> It does the onlining through online_store()...
> So we can take add_cpu() off the equation here.

Yes, so the real problem is (thanks for pointing me to the acpi code).
The cpu->node association is done in acpi_map_cpu2node and I suspect
this expects that the node is already present as it gets the information
from SRAT/PXM tables which are parsed during boot. But I might be just
confused or maybe just VMware inject new entries here somehow.

Another interesting thing is that acpi_map_cpu2node skips over
association if there is no node found in SRAT but that should only mean
it would use the default initialization which should be hopefuly 0.

Anyway, I have found in my notes
https://www.spinics.net/lists/kernel/msg3010886.html which is a slightly
different problem but it has some notes about how the initialization
mess works (that one was boot time though and hotplug might be different
actually).

I have ran out of time for this today so hopefully somebody can re-learn
that from there...

-- 
Michal Hocko
SUSE Labs
