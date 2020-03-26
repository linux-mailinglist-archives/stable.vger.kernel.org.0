Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8314A193FE7
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 14:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgCZNjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 09:39:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:31486 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgCZNjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 09:39:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585229946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wr4jPDIMj1FqtFxJaJjCDHQzG5brlUS2imDNvMHzjUo=;
        b=PryVeClDEOqLWZBwkCQnyqS1dnDPoBcMqhRqjL4B53ddOm8GDFj4FaXZmOG02PcgVidNbj
        T20BMmD8lwESub1mNox+SgsHcKiCTIlEcEf7YPbZ+vJPDQUCZ8PjYyNL77/7UpGleR9LPA
        KmaAf4CSoyQDAhG2To4Pn40tfwETayk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-pO3scfLXNkiI0KRJArO-Ow-1; Thu, 26 Mar 2020 09:39:02 -0400
X-MC-Unique: pO3scfLXNkiI0KRJArO-Ow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C567800D4E;
        Thu, 26 Mar 2020 13:39:00 +0000 (UTC)
Received: from localhost (ovpn-12-117.pek2.redhat.com [10.72.12.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A727360C18;
        Thu, 26 Mar 2020 13:38:56 +0000 (UTC)
Date:   Thu, 26 Mar 2020 21:38:53 +0800
From:   Baoquan He <bhe@redhat.com>
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org,
        Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Wei Yang <richardw.yang@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/sparse: Fix kernel crash with pfn_section_valid
 check
Message-ID: <20200326133853.GF9942@MiWiFi-R3L-srv>
References: <20200326133235.343616-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326133235.343616-1-aneesh.kumar@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/26/20 at 07:02pm, Aneesh Kumar K.V wrote:
> Fixes the below crash
> 
> BUG: Kernel NULL pointer dereference on read at 0x00000000
> Faulting instruction address: 0xc000000000c3447c
> Oops: Kernel access of bad area, sig: 11 [#1]
> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> CPU: 11 PID: 7519 Comm: lt-ndctl Not tainted 5.6.0-rc7-autotest #1
> ...
> NIP [c000000000c3447c] vmemmap_populated+0x98/0xc0
> LR [c000000000088354] vmemmap_free+0x144/0x320
> Call Trace:
>  section_deactivate+0x220/0x240
>  __remove_pages+0x118/0x170
>  arch_remove_memory+0x3c/0x150
>  memunmap_pages+0x1cc/0x2f0
>  devm_action_release+0x30/0x50
>  release_nodes+0x2f8/0x3e0
>  device_release_driver_internal+0x168/0x270
>  unbind_store+0x130/0x170
>  drv_attr_store+0x44/0x60
>  sysfs_kf_write+0x68/0x80
>  kernfs_fop_write+0x100/0x290
>  __vfs_write+0x3c/0x70
>  vfs_write+0xcc/0x240
>  ksys_write+0x7c/0x140
>  system_call+0x5c/0x68
> 
> The crash is due to NULL dereference at
> 
> test_bit(idx, ms->usage->subsection_map); due to ms->usage = NULL; in pfn_section_valid()
> 
> With commit: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
> section_mem_map is set to NULL after depopulate_section_mem(). This
> was done so that pfn_page() can work correctly with kernel config that disables
> SPARSEMEM_VMEMMAP. With that config pfn_to_page does
> 
> 	__section_mem_map_addr(__sec) + __pfn;
> where
> 
> static inline struct page *__section_mem_map_addr(struct mem_section *section)
> {
> 	unsigned long map = section->section_mem_map;
> 	map &= SECTION_MAP_MASK;
> 	return (struct page *)map;
> }
> 
> Now with SPASEMEM_VMEMAP enabled, mem_section->usage->subsection_map is used to
> check the pfn validity (pfn_valid()). Since section_deactivate release
> mem_section->usage if a section is fully deactivated, pfn_valid() check after
> a subsection_deactivate cause a kernel crash.
> 
> static inline int pfn_valid(unsigned long pfn)
> {
> ...
> 	return early_section(ms) || pfn_section_valid(ms, pfn);
> }
> 
> where
> 
> static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
> {
> 	int idx = subsection_map_index(pfn);
> 
> 	return test_bit(idx, ms->usage->subsection_map);
> }
> 
> Avoid this by clearing SECTION_HAS_MEM_MAP when mem_section->usage is freed.
> For architectures like ppc64 where large pages are used for vmmemap mapping (16MB),
> a specific vmemmap mapping can cover multiple sections. Hence before a vmemmap
> mapping page can be freed, the kernel needs to make sure there are no valid sections
> within that mapping. Clearing the section valid bit before
> depopulate_section_memap enables this.
> 
> Fixes: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
> Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
> Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Wei Yang <richardw.yang@linux.intel.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  mm/sparse.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index aadb7298dcef..65599e8bd636 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -781,6 +781,12 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>  			ms->usage = NULL;
>  		}
>  		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
> +		/*
> +		 * Mark the section invalid so that valid_section()
> +		 * return false. This prevents code from dereferencing
> +		 * ms->usage array.
> +		 */
> +		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
>  	}

Reviewed-by: Baoquan He <bhe@redhat.com>

