Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347424D46A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 19:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFTRAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 13:00:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:59374 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbfFTRAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 13:00:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 89D3BAFC3;
        Thu, 20 Jun 2019 17:00:40 +0000 (UTC)
Date:   Thu, 20 Jun 2019 19:00:35 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Jane Chu <jane.chu@oracle.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Jonathan Corbet <corbet@lwn.net>, Qian Cai <cai@lca.pw>,
        Logan Gunthorpe <logang@deltatee.com>,
        Toshi Kani <toshi.kani@hpe.com>,
        Jeff Moyer <jmoyer@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org,
        Wei Yang <richardw.yang@linux.intel.com>, linux-mm@kvack.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 00/13] mm: Sub-section memory hotplug support
Message-ID: <20190620170027.GA7126@linux>
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 10:51:33PM -0700, Dan Williams wrote:
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

Hi Dan,

I am planning to give it a final review later tomorrow.
Now that this work is settled, I took the chance to dust off and push my
vmemmap-hotplug, and I am working on that right now.
But I would definetely come back to this tomorrow.

Thanks for the work

-- 
Oscar Salvador
SUSE L3
