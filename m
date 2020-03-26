Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1848D1943F6
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 17:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgCZQFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 12:05:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55550 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgCZQFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 12:05:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id z5so7037044wml.5;
        Thu, 26 Mar 2020 09:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jWhswxN9HQxV0nCCW/ijA/LKBxQbID7mVe37gnQPitw=;
        b=dqwJ3vnz7U9zrvNqIgM2MDrOPkPRJntsqjaUCmayPiZXmgOePCAwQg68NmMORGrzvp
         7VjndEdtlEs+VOWlBovC+Na0ujFud/i42W2fKEqCuQXj3iBBtyYtgBYZXtyakEPHwrh9
         nOtf7SN6f/bFWtl9cyF7qnc0F+rFjpBMyceLyPWmVaOzRb+90/p7c+HCv/FQTk5l2iDt
         +MRM4AimWwn4DUObLtVRGdbBTCWmcPeeO/hEUHji22d3rK9fKhFQoEtWHn1IpGWP9TYZ
         SSxxE5u4B1fvpCxrojfEMZoq9rnzFJrO5l8/DeLc4q1/3UPYTxlZywbgf8d6zwqoNIIn
         aWnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jWhswxN9HQxV0nCCW/ijA/LKBxQbID7mVe37gnQPitw=;
        b=FMZ4zH6lKFNlqi3cvPsB4P7u1rpHCZ88SgwqcqP4JAbQP/WXnQON4GrSVOkDUyxd0t
         EyBGbBM0hrKtLR2Ol255dL3MPgsH0MXyMr/9S9m2Wcbe0wAHBntOuimlbs0oMrz+O9DG
         MhiawK7KETQqkyjn3K6dzcbpxxSJIy0B3GCLL3G+zBax70pnJL3/APEuYCHeytreCt62
         gHsCcb6905RQaa//YOU8Zwji/lv+qMoXz+teGKuj3r5NcvSLqV1eEXyz6eLglktlTixI
         IjHUQ6IJ4rHsuVyf0G6vaj+UYke7s1wWClyDMkG35sKfvVobgBitKuvinX5Cd5OlPIX0
         G9cg==
X-Gm-Message-State: ANhLgQ3ZOWmVo/VhGn9zowYtxJG4ThPvm1m8GLMpdXrFLXZ1vcmlX6P8
        ROPX2ME2nEhE6ecvkMbTBKYNIkJV1gBZFMz7hhI=
X-Google-Smtp-Source: ADFU+vtaOxhcczxMAOz9StdZVZLixx/TTBbQdMAPFVdjZvzd+1/+U/20Y3/RjtNPR7fcn8ajcWhgZEzfyIZ2bGxXIZI=
X-Received: by 2002:a1c:5506:: with SMTP id j6mr623256wmb.127.1585238699504;
 Thu, 26 Mar 2020 09:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200326133235.343616-1-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20200326133235.343616-1-aneesh.kumar@linux.ibm.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 26 Mar 2020 17:04:47 +0100
Message-ID: <CAM9Jb+h+pZMQ_9W8Qm=6MSOdRDPaMpc0izTKUFMSR-kW1A-EaA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/sparse: Fix kernel crash with pfn_section_valid check
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org,
        Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Wei Yang <richardw.yang@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
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
>         __section_mem_map_addr(__sec) + __pfn;
> where
>
> static inline struct page *__section_mem_map_addr(struct mem_section *section)
> {
>         unsigned long map = section->section_mem_map;
>         map &= SECTION_MAP_MASK;
>         return (struct page *)map;
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
>         return early_section(ms) || pfn_section_valid(ms, pfn);
> }
>
> where
>
> static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
> {
>         int idx = subsection_map_index(pfn);
>
>         return test_bit(idx, ms->usage->subsection_map);
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
>                         ms->usage = NULL;
>                 }
>                 memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
> +               /*
> +                * Mark the section invalid so that valid_section()
> +                * return false. This prevents code from dereferencing
> +                * ms->usage array.
> +                */
> +               ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
>         }
>
>         if (section_is_early && memmap)
> --
Agree with Michal, comment for clearing the section would be nicer.

Fix looks good to me.
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>

> 2.25.1
>
