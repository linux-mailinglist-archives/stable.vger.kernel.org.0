Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8D4CDC2
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 14:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfFTMan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 08:30:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731682AbfFTMak (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 08:30:40 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KCItFH045292
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 08:30:39 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t89md1q6y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 08:30:38 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <aneesh.kumar@linux.ibm.com>;
        Thu, 20 Jun 2019 13:30:35 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Jun 2019 13:30:29 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5KCUSMK19595406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 12:30:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE50F4C04E;
        Thu, 20 Jun 2019 12:30:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9FED4C052;
        Thu, 20 Jun 2019 12:30:24 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.199.52.129])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Jun 2019 12:30:24 +0000 (GMT)
X-Mailer: emacs 26.2 (via feedmail 11-beta-1 I)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc:     David Hildenbrand <david@redhat.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Jane Chu <jane.chu@oracle.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Jonathan Corbet <corbet@lwn.net>, Qian Cai <cai@lca.pw>,
        Logan Gunthorpe <logang@deltatee.com>,
        Toshi Kani <toshi.kani@hpe.com>,
        Oscar Salvador <osalvador@suse.de>,
        Jeff Moyer <jmoyer@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org,
        Wei Yang <richardw.yang@linux.intel.com>, linux-mm@kvack.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 00/13] mm: Sub-section memory hotplug support
In-Reply-To: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
Date:   Thu, 20 Jun 2019 18:00:23 +0530
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
x-cbid: 19062012-0008-0000-0000-000002F57E05
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062012-0009-0000-0000-000022629E8E
Message-Id: <874l4kjv6o.fsf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200091
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> Changes since v9 [1]:
> - Fix multiple issues related to the fact that pfn_valid() has
>   traditionally returned true for any pfn in an 'early' (onlined at
>   boot) section regardless of whether that pfn represented 'System RAM'.
>   Teach pfn_valid() to maintain its traditional behavior in the presence
>   of subsections. Specifically, subsection precision for pfn_valid() is
>   only considered for non-early / hot-plugged sections. (Qian)
>
> - Related to the first item introduce a SECTION_IS_EARLY
>   (->section_mem_map flag) to remove the existing hacks for determining
>   an early section by looking at whether the usemap was allocated from the
>   slab.
>
> - Kill off the EEXIST hackery in __add_pages(). It breaks
>   (arch_add_memory() false-positive) the detection of subsection
>   collisions reported by section_activate(). It is also obviated by
>   David's recent reworks to move the 'System RAM' request_region() earlier
>   in the add_memory() sequence().
>
> - Switch to an arch-independent / static subsection-size of 2MB.
>   Otherwise, a per-arch subsection-size is a roadblock on the path to
>   persistent memory namespace compatibility across archs. (Jeff)
>
> - Update the changelog for "libnvdimm/pfn: Fix fsdax-mode namespace
>   info-block zero-fields" to clarify that the "Cc: stable" is only there
>   as safety measure for a distro that decides to backport "libnvdimm/pfn:
>   Stop padding pmem namespaces to section alignment", otherwise there is
>   no known bug exposure in older kernels. (Andrew)
>   
> - Drop some redundant subsection checks (Oscar)
>
> - Collect some reviewed-bys
>
> [1]: https://lore.kernel.org/lkml/155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com/


You can add Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
for ppc64.

BTW even after this series we have the kernel crash mentioned in the
below email on reconfigure. 

https://lore.kernel.org/linux-mm/20190514025354.9108-1-aneesh.kumar@linux.ibm.com

I guess we need to conclude how the reserve space struct page should be
initialized ?

>
> ---
>
> The memory hotplug section is an arbitrary / convenient unit for memory
> hotplug. 'Section-size' units have bled into the user interface
> ('memblock' sysfs) and can not be changed without breaking existing
> userspace. The section-size constraint, while mostly benign for typical
> memory hotplug, has and continues to wreak havoc with 'device-memory'
> use cases, persistent memory (pmem) in particular. Recall that pmem uses
> devm_memremap_pages(), and subsequently arch_add_memory(), to allocate a
> 'struct page' memmap for pmem. However, it does not use the 'bottom
> half' of memory hotplug, i.e. never marks pmem pages online and never
> exposes the userspace memblock interface for pmem. This leaves an
> opening to redress the section-size constraint.
>
> To date, the libnvdimm subsystem has attempted to inject padding to
> satisfy the internal constraints of arch_add_memory(). Beyond
> complicating the code, leading to bugs [2], wasting memory, and limiting
> configuration flexibility, the padding hack is broken when the platform
> changes this physical memory alignment of pmem from one boot to the
> next. Device failure (intermittent or permanent) and physical
> reconfiguration are events that can cause the platform firmware to
> change the physical placement of pmem on a subsequent boot, and device
> failure is an everyday event in a data-center.
>
> It turns out that sections are only a hard requirement of the
> user-facing interface for memory hotplug and with a bit more
> infrastructure sub-section arch_add_memory() support can be added for
> kernel internal usages like devm_memremap_pages(). Here is an analysis
> of the current design assumptions in the current code and how they are
> addressed in the new implementation:
>
> Current design assumptions:
>
> - Sections that describe boot memory (early sections) are never
>   unplugged / removed.
>
> - pfn_valid(), in the CONFIG_SPARSEMEM_VMEMMAP=y, case devolves to a
>   valid_section() check
>
> - __add_pages() and helper routines assume all operations occur in
>   PAGES_PER_SECTION units.
>
> - The memblock sysfs interface only comprehends full sections
>
> New design assumptions:
>
> - Sections are instrumented with a sub-section bitmask to track (on x86)
>   individual 2MB sub-divisions of a 128MB section.
>
> - Partially populated early sections can be extended with additional
>   sub-sections, and those sub-sections can be removed with
>   arch_remove_memory(). With this in place we no longer lose usable memory
>   capacity to padding.
>
> - pfn_valid() is updated to look deeper than valid_section() to also check the
>   active-sub-section mask. This indication is in the same cacheline as
>   the valid_section() so the performance impact is expected to be
>   negligible. So far the lkp robot has not reported any regressions.
>
> - Outside of the core vmemmap population routines which are replaced,
>   other helper routines like shrink_{zone,pgdat}_span() are updated to
>   handle the smaller granularity. Core memory hotplug routines that deal
>   with online memory are not touched.
>
> - The existing memblock sysfs user api guarantees / assumptions are
>   not touched since this capability is limited to !online
>   !memblock-sysfs-accessible sections.
>
> Meanwhile the issue reports continue to roll in from users that do not
> understand when and how the 128MB constraint will bite them. The current
> implementation relied on being able to support at least one misaligned
> namespace, but that immediately falls over on any moderately complex
> namespace creation attempt. Beyond the initial problem of 'System RAM'
> colliding with pmem, and the unsolvable problem of physical alignment
> changes, Linux is now being exposed to platforms that collide pmem
> ranges with other pmem ranges by default [3]. In short,
> devm_memremap_pages() has pushed the venerable section-size constraint
> past the breaking point, and the simplicity of section-aligned
> arch_add_memory() is no longer tenable.
>
> These patches are exposed to the kbuild robot on a subsection-v10 branch
> [4], and a preview of the unit test for this functionality is available
> on the 'subsection-pending' branch of ndctl [5].
>
> [2]: https://lore.kernel.org/r/155000671719.348031.2347363160141119237.stgit@dwillia2-desk3.amr.corp.intel.com
> [3]: https://github.com/pmem/ndctl/issues/76
> [4]: https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=subsection-v10
> [5]: https://github.com/pmem/ndctl/commit/7c59b4867e1c
>
> ---
>
> Dan Williams (13):
>       mm/sparsemem: Introduce struct mem_section_usage
>       mm/sparsemem: Introduce a SECTION_IS_EARLY flag
>       mm/sparsemem: Add helpers track active portions of a section at boot
>       mm/hotplug: Prepare shrink_{zone,pgdat}_span for sub-section removal
>       mm/sparsemem: Convert kmalloc_section_memmap() to populate_section_memmap()
>       mm/hotplug: Kill is_dev_zone() usage in __remove_pages()
>       mm: Kill is_dev_zone() helper
>       mm/sparsemem: Prepare for sub-section ranges
>       mm/sparsemem: Support sub-section hotplug
>       mm: Document ZONE_DEVICE memory-model implications
>       mm/devm_memremap_pages: Enable sub-section remap
>       libnvdimm/pfn: Fix fsdax-mode namespace info-block zero-fields
>       libnvdimm/pfn: Stop padding pmem namespaces to section alignment
>
>
>  Documentation/vm/memory-model.rst |   39 ++++
>  arch/x86/mm/init_64.c             |    4 
>  drivers/nvdimm/dax_devs.c         |    2 
>  drivers/nvdimm/pfn.h              |   15 --
>  drivers/nvdimm/pfn_devs.c         |   95 +++-------
>  include/linux/memory_hotplug.h    |    7 -
>  include/linux/mm.h                |    4 
>  include/linux/mmzone.h            |   84 +++++++--
>  kernel/memremap.c                 |   61 +++----
>  mm/memory_hotplug.c               |  173 +++++++++----------
>  mm/page_alloc.c                   |   16 +-
>  mm/sparse-vmemmap.c               |   21 ++
>  mm/sparse.c                       |  335 ++++++++++++++++++++++++-------------
>  13 files changed, 494 insertions(+), 362 deletions(-)

