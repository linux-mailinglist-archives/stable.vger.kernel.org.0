Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197038368D
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 18:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387588AbfHFQPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 12:15:39 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43340 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387493AbfHFQPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 12:15:39 -0400
Received: by mail-ot1-f68.google.com with SMTP id j11so36557389otp.10
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 09:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XmBWrF/l706tTfdjqSR6o57eiT2cKuc01B3zqvw2hyQ=;
        b=irgws0PHUZn4pJRAqbDrBGoE91h4tKEf578kGsM+bhYBlN6zwuD6eCoEh9iXCZaWgX
         jj7qvYikZUNeXPLxtdUYy81ZnldK54ER7B463rLo2I40Xv+1Elh0MRjmaliKPrSqg1BZ
         7Ar/Dl6ahyj1hhsKqwS5AkMp9ZYEqKFoEEjR0L9FJd5StW8e9YahlfT3s3GuWOQadX+a
         Q7YL8GSIzyttc14Y6B8Pdnrjx0OeGfTv51MuwzhtZRkBZNsuigWjWXh9XmyoWLwL5QDL
         WekEBBpKKvxaNdUJBsRNR7qdSORyORQv1GHPQvJVpWEeR7ZwNUPns20p+q+Ns+yixgKz
         2azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XmBWrF/l706tTfdjqSR6o57eiT2cKuc01B3zqvw2hyQ=;
        b=OeSH5R47AeCyMRMRu/kr0ZnFOY3IKOyRM9h+E/3Qf/TBAsfecliEL5cvgfS0KWGdYi
         KF/iAnKVQf4XVbvkTJ+Kv86jKCqdUijYl4Gp8BBW7FwfzxBEJVJIr9wIVeLbxD770UFQ
         sWyVejJAbJSZBYvCfEXXDdS6DqylFHo8ZfV5SViHCuX1FAIvwo3rc3a8aO7W98efQGNM
         vKfWgZBEoT4Nbqc1rDAHPEfwC10aDhtgcaotRsGKI03mzMWCNOMM0luQyVf5yHTM7dIt
         X1W+jfEztwwdh4wf/Wjl5PxzElaC+eFqLxVoT7EBLlN6ssf8oA6e32I0wh3wS8WJuPXC
         AnRQ==
X-Gm-Message-State: APjAAAXyv/3oFTGKOXKXlyJnDS4/EUOupMVrA4AlXh3GJGF+8QAl0cs4
        VPIeTLMAtuc9xpFfYwAlTTQbspy44KLkVETms4P08Q==
X-Google-Smtp-Source: APXvYqwyeSIhx1y4ui2pMFiAgfRnKRGa17W9CpGizynyyEF79cuw/8LleWldT3a5dd0HmWWGVR2QiMroX2nDRghDgeI=
X-Received: by 2002:a9d:7248:: with SMTP id a8mr4080253otk.363.1565108137806;
 Tue, 06 Aug 2019 09:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190725023100.31141-1-t-fukasawa@vx.jp.nec.com>
 <20190725023100.31141-3-t-fukasawa@vx.jp.nec.com> <20190725090341.GC13855@dhcp22.suse.cz>
 <40b3078e-fb8b-87ef-5c4e-6321956cc940@vx.jp.nec.com> <20190726070615.GB6142@dhcp22.suse.cz>
 <3a926ce5-75b9-ea94-d6e4-6888872e0dc4@vx.jp.nec.com> <CAPcyv4iCXWgxkLi3eM_EaqD0cuzmRyg5k4c9CeS1TyN+bajXFw@mail.gmail.com>
 <20190806064636.GU7597@dhcp22.suse.cz>
In-Reply-To: <20190806064636.GU7597@dhcp22.suse.cz>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 6 Aug 2019 09:15:25 -0700
Message-ID: <CAPcyv4i5FjTOnPbXNcTzvt+e6RQYow0JRQwSFuxaa62LSuvzHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] /proc/kpageflags: do not use uninitialized struct pages
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "hch@lst.de" <hch@lst.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 5, 2019 at 11:47 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 05-08-19 20:27:03, Dan Williams wrote:
> > On Sun, Aug 4, 2019 at 10:31 PM Toshiki Fukasawa
> > <t-fukasawa@vx.jp.nec.com> wrote:
> > >
> > > On 2019/07/26 16:06, Michal Hocko wrote:
> > > > On Fri 26-07-19 06:25:49, Toshiki Fukasawa wrote:
> > > >>
> > > >>
> > > >> On 2019/07/25 18:03, Michal Hocko wrote:
> > > >>> On Thu 25-07-19 02:31:18, Toshiki Fukasawa wrote:
> > > >>>> A kernel panic was observed during reading /proc/kpageflags for
> > > >>>> first few pfns allocated by pmem namespace:
> > > >>>>
> > > >>>> BUG: unable to handle page fault for address: fffffffffffffffe
> > > >>>> [  114.495280] #PF: supervisor read access in kernel mode
> > > >>>> [  114.495738] #PF: error_code(0x0000) - not-present page
> > > >>>> [  114.496203] PGD 17120e067 P4D 17120e067 PUD 171210067 PMD 0
> > > >>>> [  114.496713] Oops: 0000 [#1] SMP PTI
> > > >>>> [  114.497037] CPU: 9 PID: 1202 Comm: page-types Not tainted 5.3.0-rc1 #1
> > > >>>> [  114.497621] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
> > > >>>> [  114.498706] RIP: 0010:stable_page_flags+0x27/0x3f0
> > > >>>> [  114.499142] Code: 82 66 90 66 66 66 66 90 48 85 ff 0f 84 d1 03 00 00 41 54 55 48 89 fd 53 48 8b 57 08 48 8b 1f 48 8d 42 ff 83 e2 01 48 0f 44 c7 <48> 8b 00 f6 c4 02 0f 84 57 03 00 00 45 31 e4 48 8b 55 08 48 89 ef
> > > >>>> [  114.500788] RSP: 0018:ffffa5e601a0fe60 EFLAGS: 00010202
> > > >>>> [  114.501373] RAX: fffffffffffffffe RBX: ffffffffffffffff RCX: 0000000000000000
> > > >>>> [  114.502009] RDX: 0000000000000001 RSI: 00007ffca13a7310 RDI: ffffd07489000000
> > > >>>> [  114.502637] RBP: ffffd07489000000 R08: 0000000000000001 R09: 0000000000000000
> > > >>>> [  114.503270] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000240000
> > > >>>> [  114.503896] R13: 0000000000080000 R14: 00007ffca13a7310 R15: ffffa5e601a0ff08
> > > >>>> [  114.504530] FS:  00007f0266c7f540(0000) GS:ffff962dbbac0000(0000) knlGS:0000000000000000
> > > >>>> [  114.505245] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > >>>> [  114.505754] CR2: fffffffffffffffe CR3: 000000023a204000 CR4: 00000000000006e0
> > > >>>> [  114.506401] Call Trace:
> > > >>>> [  114.506660]  kpageflags_read+0xb1/0x130
> > > >>>> [  114.507051]  proc_reg_read+0x39/0x60
> > > >>>> [  114.507387]  vfs_read+0x8a/0x140
> > > >>>> [  114.507686]  ksys_pread64+0x61/0xa0
> > > >>>> [  114.508021]  do_syscall_64+0x5f/0x1a0
> > > >>>> [  114.508372]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > >>>> [  114.508844] RIP: 0033:0x7f0266ba426b
> > > >>>>
> > > >>>> The reason for the panic is that stable_page_flags() which parses
> > > >>>> the page flags uses uninitialized struct pages reserved by the
> > > >>>> ZONE_DEVICE driver.
> > > >>>
> > > >>> Why pmem hasn't initialized struct pages?
> > > >>
> > > >> We proposed to initialize in previous approach but that wasn't merged.
> > > >> (See https://marc.info/?l=linux-mm&m=152964792500739&w=2)
> > > >>
> > > >>> Isn't that a bug that should be addressed rather than paper over it like this?
> > > >>
> > > >> I'm not sure. What do you think, Dan?
> > > >
> > > > Yeah, I am really curious about details. Why do we keep uninitialized
> > > > struct pages at all? What is a random pfn walker supposed to do? What
> > > > kind of metadata would be clobbered? In other words much more details
> > > > please.
> > > >
> > > I also want to know. I do not think that initializing struct pages will
> > > clobber any metadata.
> >
> > The nvdimm implementation uses vmem_altmap to arrange for the 'struct
> > page' array to be allocated from a reservation of a pmem namespace. A
> > namespace in this mode contains an info-block that consumes the first
> > 8K of the namespace capacity, capacity designated for page mapping,
> > capacity for padding the start of data to optionally 4K, 2MB, or 1GB
> > (on x86), and then the namespace data itself. The implementation
> > specifies a section aligned (now sub-section aligned) address to
> > arch_add_memory() to establish the linear mapping to map the metadata,
> > and then vmem_altmap indicates to memmap_init_zone() which pfns
> > represent data. The implementation only specifies enough 'struct page'
> > capacity for pfn_to_page() to operate on the data space, not the
> > namespace metadata space.
>
> Maybe I am dense but I do not really understand what prevents those
> struct pages to be initialized to whatever state nvidimm subsystem
> expects them to be? Is that a initialization speed up optimization?

No, not an optimization. If anything a regrettable choice in the
initial implementation to not reserve struct page space for the
metadata area. Certainly the kernel could fix this going forward, and
there are some configurations where even the existing allocation could
store those pfns, but there are others that need that reservation. So
there is a regression risk for some currently working configurations.

As always we could try making the reservation change and fail to
instantiate old namespaces that don't reserve enough capacity to see
who screams. I think the risk is low, but non-zero. That makes my
first choice to teach kpageflags_read() about the constraint.

> > The proposal to validate ZONE_DEVICE pfns against the altmap seems the
> > right approach to me.
>
> This however means that all pfn walkers have to be aware of these
> special struct pages somehow and that is error prone.

True, but what other blind pfn walkers do we have besides
kpageflags_read()? I expect most other pfn_to_page() code paths are
constrained to known pfns and avoid this surprise, but yes I need to
go audit those.
