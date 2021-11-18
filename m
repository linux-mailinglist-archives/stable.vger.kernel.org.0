Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F652455714
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244656AbhKRIjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:39:05 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54480 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244722AbhKRIic (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 03:38:32 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B434A1FD35;
        Thu, 18 Nov 2021 08:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637224530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FD94QdcVS8s3Ogz1ge3REQoKg7gxIQqOlza6TNdJrPI=;
        b=OA7wgulOUrcOv5qwO4a+RjaWY4uDPt8N9xTjIxVuH5my7tyscaTqk+OW5XFq64bO3iDN7z
        YCLua1H3RKk2WEzm3KciLrWy2q6vHniqoblJjZkF8aAAdusJizLjTbZx0bl1AeucaqdnN9
        GYeQhQNDBFLatH/ffpq17Y5LQ5MBJPY=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 803BAA3B83;
        Thu, 18 Nov 2021 08:35:30 +0000 (UTC)
Date:   Thu, 18 Nov 2021 09:35:30 +0100
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
Message-ID: <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
References: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
 <20211108202325.20304-1-amakhalov@vmware.com>
 <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz>
 <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 16-11-21 20:22:49, Alexey Makhalov wrote:
> 
> 
> > On Nov 16, 2021, at 1:17 AM, Michal Hocko <mhocko@suse.com> wrote:
> > 
> > On Tue 16-11-21 01:31:44, Alexey Makhalov wrote:
> > [...]
> >> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> >> index 6737b1cbf..bbc1a70d5 100644
> >> --- a/drivers/acpi/acpi_processor.c
> >> +++ b/drivers/acpi/acpi_processor.c
> >> @@ -200,6 +200,10 @@ static int acpi_processor_hotadd_init(struct acpi_processor *pr)
> >>        * gets online for the first time.
> >>        */
> >>       pr_info("CPU%d has been hot-added\n", pr->id);
> >> +       {
> >> +               int nid = cpu_to_node(pr->id);
> >> +               printk("%s:%d cpu %d, node %d, online %d, ndata %p\n", __FUNCTION__, __LINE__, pr->id, nid, node_online(nid), NODE_DATA(nid));
> >> +       }
> >>       pr->flags.need_hotplug_init = 1;
> > 
> > OK, IIUC you are adding a processor which is outside of
> > possible_cpu_mask and that means that the node is not allocated for such
> > a future to be hotplugged cpu and its memory node. init_cpu_to_node
> > would have done that initialization otherwise.
> It is not correct.
> 
> possible_cpus is 128 for this VM. Look at SRAT and percpu output for proof.
> [    0.085524] SRAT: PXM 127 -> APIC 0xfe -> Node 127
> [    0.118928] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:128 nr_node_ids:128

OK, I see. I have missed that when looking at the boot log you have
sent.

> It is impossible to add processor outside of possible_cpu_mask. possible_cpus is absolute maximum
> that system can support. See Documentation/core-api/cpu_hotplug.rst

That was my understanding hence the suspicion you might be doing
something that is not really supported.

> Number of present and onlined CPUs (and nodes) is 4. Other 124 CPUs (and nodes) are not present, but can
> be potentially hot added.

Yes this is a configuration I have already seen. The cpu->node binding
was configured during the boot time though IIRC.

> Number of initialized nodes is 4, as init_cpu_to_node() will skip not yet present nodes,
> see arch/x86/mm/numa.c:798 (numa_cpu_node(CPU #4) == NUMA_NO_NODE)

Isn't this the problem? Why is the cpu->node association missing here? 

> 788 void __init init_cpu_to_node(void)
> 789 {
> 790         int cpu;
> 791         u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
> 792
> 793         BUG_ON(cpu_to_apicid == NULL);
> 794
> 795         for_each_possible_cpu(cpu) {
> 796                 int node = numa_cpu_node(cpu);
> 797
> 798                 if (node == NUMA_NO_NODE)
> 799                         continue;
> 800
> 
> After CPU (and node) hot plug:
> - CPU 4 is marker as present, but not yet online
> - New node got ID 4. numa_cpu_node(CPU #4) returns 4
> - node_online(4) == 0 and NODE_DATA(4) == NULL, but it will be accessed inside
> for_each_possible_cpu loop in percpu allocation.
> 
> Digging further.
> Even if x86/CPU hot add maintainers decide to clean up memoryless node hot add code to initialize the node on time of
> attaching it (to be aligned with mm node while memory hot add), this percpu fix is still needed as it is used during
> the node onlining, See chicken and egg problem that I described above.

I have to say I do not see the chicken and egg problem. As long as
init_cpu_to_node initializes the memoryless node for the cpu properly
then the pcp allocator doesn't really have to care as the page allocator
falls back to to first populated node in a distance order. So I believe
the whole issue boils down to addressing why init_cpu_to_node doesn't
see a proper cpu->node association.

> Or as 2nd option, numa_cpu_node(4) should return NUMA_NO_NODE until node 4 get fully initialized.
-- 
Michal Hocko
SUSE Labs
