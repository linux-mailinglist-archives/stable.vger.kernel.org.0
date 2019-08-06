Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03ED082BF4
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 08:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbfHFGql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 02:46:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:47612 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731731AbfHFGql (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 02:46:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1979AB602;
        Tue,  6 Aug 2019 06:46:39 +0000 (UTC)
Date:   Tue, 6 Aug 2019 08:46:36 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "hch@lst.de" <hch@lst.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] /proc/kpageflags: do not use uninitialized struct
 pages
Message-ID: <20190806064636.GU7597@dhcp22.suse.cz>
References: <20190725023100.31141-1-t-fukasawa@vx.jp.nec.com>
 <20190725023100.31141-3-t-fukasawa@vx.jp.nec.com>
 <20190725090341.GC13855@dhcp22.suse.cz>
 <40b3078e-fb8b-87ef-5c4e-6321956cc940@vx.jp.nec.com>
 <20190726070615.GB6142@dhcp22.suse.cz>
 <3a926ce5-75b9-ea94-d6e4-6888872e0dc4@vx.jp.nec.com>
 <CAPcyv4iCXWgxkLi3eM_EaqD0cuzmRyg5k4c9CeS1TyN+bajXFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iCXWgxkLi3eM_EaqD0cuzmRyg5k4c9CeS1TyN+bajXFw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 05-08-19 20:27:03, Dan Williams wrote:
> On Sun, Aug 4, 2019 at 10:31 PM Toshiki Fukasawa
> <t-fukasawa@vx.jp.nec.com> wrote:
> >
> > On 2019/07/26 16:06, Michal Hocko wrote:
> > > On Fri 26-07-19 06:25:49, Toshiki Fukasawa wrote:
> > >>
> > >>
> > >> On 2019/07/25 18:03, Michal Hocko wrote:
> > >>> On Thu 25-07-19 02:31:18, Toshiki Fukasawa wrote:
> > >>>> A kernel panic was observed during reading /proc/kpageflags for
> > >>>> first few pfns allocated by pmem namespace:
> > >>>>
> > >>>> BUG: unable to handle page fault for address: fffffffffffffffe
> > >>>> [  114.495280] #PF: supervisor read access in kernel mode
> > >>>> [  114.495738] #PF: error_code(0x0000) - not-present page
> > >>>> [  114.496203] PGD 17120e067 P4D 17120e067 PUD 171210067 PMD 0
> > >>>> [  114.496713] Oops: 0000 [#1] SMP PTI
> > >>>> [  114.497037] CPU: 9 PID: 1202 Comm: page-types Not tainted 5.3.0-rc1 #1
> > >>>> [  114.497621] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
> > >>>> [  114.498706] RIP: 0010:stable_page_flags+0x27/0x3f0
> > >>>> [  114.499142] Code: 82 66 90 66 66 66 66 90 48 85 ff 0f 84 d1 03 00 00 41 54 55 48 89 fd 53 48 8b 57 08 48 8b 1f 48 8d 42 ff 83 e2 01 48 0f 44 c7 <48> 8b 00 f6 c4 02 0f 84 57 03 00 00 45 31 e4 48 8b 55 08 48 89 ef
> > >>>> [  114.500788] RSP: 0018:ffffa5e601a0fe60 EFLAGS: 00010202
> > >>>> [  114.501373] RAX: fffffffffffffffe RBX: ffffffffffffffff RCX: 0000000000000000
> > >>>> [  114.502009] RDX: 0000000000000001 RSI: 00007ffca13a7310 RDI: ffffd07489000000
> > >>>> [  114.502637] RBP: ffffd07489000000 R08: 0000000000000001 R09: 0000000000000000
> > >>>> [  114.503270] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000240000
> > >>>> [  114.503896] R13: 0000000000080000 R14: 00007ffca13a7310 R15: ffffa5e601a0ff08
> > >>>> [  114.504530] FS:  00007f0266c7f540(0000) GS:ffff962dbbac0000(0000) knlGS:0000000000000000
> > >>>> [  114.505245] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >>>> [  114.505754] CR2: fffffffffffffffe CR3: 000000023a204000 CR4: 00000000000006e0
> > >>>> [  114.506401] Call Trace:
> > >>>> [  114.506660]  kpageflags_read+0xb1/0x130
> > >>>> [  114.507051]  proc_reg_read+0x39/0x60
> > >>>> [  114.507387]  vfs_read+0x8a/0x140
> > >>>> [  114.507686]  ksys_pread64+0x61/0xa0
> > >>>> [  114.508021]  do_syscall_64+0x5f/0x1a0
> > >>>> [  114.508372]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >>>> [  114.508844] RIP: 0033:0x7f0266ba426b
> > >>>>
> > >>>> The reason for the panic is that stable_page_flags() which parses
> > >>>> the page flags uses uninitialized struct pages reserved by the
> > >>>> ZONE_DEVICE driver.
> > >>>
> > >>> Why pmem hasn't initialized struct pages?
> > >>
> > >> We proposed to initialize in previous approach but that wasn't merged.
> > >> (See https://marc.info/?l=linux-mm&m=152964792500739&w=2)
> > >>
> > >>> Isn't that a bug that should be addressed rather than paper over it like this?
> > >>
> > >> I'm not sure. What do you think, Dan?
> > >
> > > Yeah, I am really curious about details. Why do we keep uninitialized
> > > struct pages at all? What is a random pfn walker supposed to do? What
> > > kind of metadata would be clobbered? In other words much more details
> > > please.
> > >
> > I also want to know. I do not think that initializing struct pages will
> > clobber any metadata.
> 
> The nvdimm implementation uses vmem_altmap to arrange for the 'struct
> page' array to be allocated from a reservation of a pmem namespace. A
> namespace in this mode contains an info-block that consumes the first
> 8K of the namespace capacity, capacity designated for page mapping,
> capacity for padding the start of data to optionally 4K, 2MB, or 1GB
> (on x86), and then the namespace data itself. The implementation
> specifies a section aligned (now sub-section aligned) address to
> arch_add_memory() to establish the linear mapping to map the metadata,
> and then vmem_altmap indicates to memmap_init_zone() which pfns
> represent data. The implementation only specifies enough 'struct page'
> capacity for pfn_to_page() to operate on the data space, not the
> namespace metadata space.

Maybe I am dense but I do not really understand what prevents those
struct pages to be initialized to whatever state nvidimm subsystem
expects them to be? Is that a initialization speed up optimization?
 
> The proposal to validate ZONE_DEVICE pfns against the altmap seems the
> right approach to me.

This however means that all pfn walkers have to be aware of these
special struct pages somehow and that is error prone.

-- 
Michal Hocko
SUSE Labs
