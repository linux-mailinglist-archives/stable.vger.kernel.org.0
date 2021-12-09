Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEF946E607
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 10:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhLIKAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 05:00:17 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:34742 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhLIKAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 05:00:17 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D57B921100;
        Thu,  9 Dec 2021 09:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639043802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xvK0zEhdT3BGuGPYsomWUv27uncl6IYRPmZgV1UM2iE=;
        b=t2mU/b5XSu4nCv5+rI1Yx2Zqnp7Wg0PNsgR6XXRTYPBtiIktV/9wtZPF2QC3/42EbLcnCB
        D+Ma4XkRUQdK12zz6Gk87BfJ9OAoBntBxter9ncPIrKG0hARhz5jZsOa+MPDSQRYzs8Abi
        mduQaMBsaSNxn256SVyiYyl1SZSSCw4=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A2D7AA3B81;
        Thu,  9 Dec 2021 09:56:42 +0000 (UTC)
Date:   Thu, 9 Dec 2021 10:56:42 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
References: <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
 <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 09-12-21 09:28:55, Alexey Makhalov wrote:
> 
> 
> > On Dec 9, 2021, at 12:46 AM, Michal Hocko <mhocko@suse.com> wrote:
> > 
> > On Thu 09-12-21 02:16:17, Alexey Makhalov wrote:
> >> This patch calls alloc_percpu() from setup_arch() while percpu
> >> allocator is not yet initialized (before setup_per_cpu_areas()).
> > 
> > Yeah, I haven't realized the pcp is not available. I was not really sure
> > about that. Could you try with the alloc_percpu dropped?
> > 
> > Thanks for testing!
> > -- 
> > Michal Hocko
> > SUSE Labs
> 
> It boots now. dmesg has these new messages:
> 
> [    0.081777] Node 4 uninitialized by the platform. Please report with boot dmesg.
> [    0.081790] Initmem setup node 4 [mem 0x0000000000000000-0x0000000000000000]
> ...
> [    0.086441] Node 127 uninitialized by the platform. Please report with boot dmesg.
> [    0.086454] Initmem setup node 127 [mem 0x0000000000000000-0x0000000000000000]

Interesting that only those two didn't get a proper arch specific
initialization. Could you check why? I assume init_cpu_to_node
doesn't see any CPU pointing at this node. Wondering why that would be
the case but that can be a bug in the affinity tables.

> vCPU/node hot add works.
> Onlining works as well, but with warning. I do not think it is related to the patch:
> [   36.838838] CPU4 has been hot-added
> [   36.838987] acpi_processor_hotadd_init:205 cpu 4, node 4, online 0, ndata 00000000e9c7f79b
> [   48.480498] Built 4 zonelists, mobility grouping on.  Total pages: 961440
> [   48.480508] Policy zone: Normal
> [   48.508318] smpboot: Booting Node 4 Processor 4 APIC 0x8
> [   48.509255] Disabled fast string operations
> [   48.509807] smpboot: CPU 4 Converting physical 8 to logical package 4
> [   48.509825] smpboot: CPU 4 Converting physical 0 to logical die 4
> [   48.510040] WARNING: workqueue cpumask: online intersect > possible intersect

I will double check. There are changes required on the hotplug side. I
would like to see that this one doesn't blow up before diving there.

> [   48.510324] vmware: vmware-stealtime: cpu 4, pa 3e667000
> [   48.511311] Will online and init hotplugged CPU: 4
> 
> Hot remove does not quite work. It might be issue in ACPI/Firmware code or Hypervisor. Debugging…
> 
> Do you want me to perform any specific tests?

No, not really. AFAIU your issue has been reproducible during boot and
that seems to be fixed. I will work on the hotplug side of the things
and post something resembling a real patch soon. That would require also
memory hotplug testing.

Thanks for your help!
-- 
Michal Hocko
SUSE Labs
