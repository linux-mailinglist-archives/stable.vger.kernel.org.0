Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5C382A00
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 05:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfHFD1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 23:27:17 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46643 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729999AbfHFD1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 23:27:16 -0400
Received: by mail-oi1-f194.google.com with SMTP id 65so64468022oid.13
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 20:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nxtz2kZ+l7OR4MFHv2stHBbHUHxdL1vfEFCmbcfh8CA=;
        b=J9nWhfi9ZP583VeloWxqen9o8Z08nPXCs2Mg+X3S6ICi4P0yXoDyV5Ww7hSDCD6rnq
         rGGBQ5hhMBUlQPbK8q1/eLX+2LSiqtTinvh2tgmcqMPjVlxIypXqVOv6omJUvp+VC6IP
         rMZ5pxEXcSZ35hDaCFpvOZd/Nk7N/K4dTb57qARzZp86bvb6ajq9SqGVJmDAjki99Zfn
         NnNWG45uHpYle+tuGgJ2aDK6SF3vuXxiMwdSi4HH7Hz2C+dev9gpTmTqtqzvnpxIjXy2
         1nlOjCSHfoswnQ1PsB7vf1rlohQoJrGyhchm4mBW7MjUJwYFeNCM/a4tpCfob5/lM/Lf
         jp5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nxtz2kZ+l7OR4MFHv2stHBbHUHxdL1vfEFCmbcfh8CA=;
        b=KRsgZd9KftYDfJoeeEN31QupFyc/MoKIks/2C2byLbkPt7toP7J7m+2iOKUXeYLUuE
         udvqSWiWFfWqZhQ+33egAfmY7+XtixDN0a9U/VpHbhfLXS69so7DJmMGPkGVBvLuDGA1
         ItV5JjCLTyiSsX1DYspuzRqd16otqqaX9cYcU/YLtW669I0d/4A+5V0V4SC7tBV/Ld+q
         0woCmML8g0X1ZkSkset+bjhR0dEtnRSwqdeAzVn29VkwP0S3+8sgJID0yPCDm0H33nTs
         M+UPyFafHRwkWnnGduxOKiy90yPeFLtgC1L3rO9pgT39NAawxPOFazVDC689zyeXZ+Y4
         Fytg==
X-Gm-Message-State: APjAAAVxNGcHS1886hBDFUsZsfWzxpYGjixNgzZRpmL4/z4FQ1TlxdJm
        bolQ4C7pWXeiZwuRaB/c3G1g/mW0tL1IZsOnHtJdVQ==
X-Google-Smtp-Source: APXvYqzqOFl+rejoEX8/ERi13dLIbgq21jpzsPxnsRuP8cMnosl8/EC6nixIh/y4rOGQU3UUzihpDdFgKpHGnTa/ZDA=
X-Received: by 2002:aca:ec82:: with SMTP id k124mr966027oih.73.1565062035500;
 Mon, 05 Aug 2019 20:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190725023100.31141-1-t-fukasawa@vx.jp.nec.com>
 <20190725023100.31141-3-t-fukasawa@vx.jp.nec.com> <20190725090341.GC13855@dhcp22.suse.cz>
 <40b3078e-fb8b-87ef-5c4e-6321956cc940@vx.jp.nec.com> <20190726070615.GB6142@dhcp22.suse.cz>
 <3a926ce5-75b9-ea94-d6e4-6888872e0dc4@vx.jp.nec.com>
In-Reply-To: <3a926ce5-75b9-ea94-d6e4-6888872e0dc4@vx.jp.nec.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 5 Aug 2019 20:27:03 -0700
Message-ID: <CAPcyv4iCXWgxkLi3eM_EaqD0cuzmRyg5k4c9CeS1TyN+bajXFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] /proc/kpageflags: do not use uninitialized struct pages
To:     Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>
Cc:     Michal Hocko <mhocko@kernel.org>,
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

On Sun, Aug 4, 2019 at 10:31 PM Toshiki Fukasawa
<t-fukasawa@vx.jp.nec.com> wrote:
>
> On 2019/07/26 16:06, Michal Hocko wrote:
> > On Fri 26-07-19 06:25:49, Toshiki Fukasawa wrote:
> >>
> >>
> >> On 2019/07/25 18:03, Michal Hocko wrote:
> >>> On Thu 25-07-19 02:31:18, Toshiki Fukasawa wrote:
> >>>> A kernel panic was observed during reading /proc/kpageflags for
> >>>> first few pfns allocated by pmem namespace:
> >>>>
> >>>> BUG: unable to handle page fault for address: fffffffffffffffe
> >>>> [  114.495280] #PF: supervisor read access in kernel mode
> >>>> [  114.495738] #PF: error_code(0x0000) - not-present page
> >>>> [  114.496203] PGD 17120e067 P4D 17120e067 PUD 171210067 PMD 0
> >>>> [  114.496713] Oops: 0000 [#1] SMP PTI
> >>>> [  114.497037] CPU: 9 PID: 1202 Comm: page-types Not tainted 5.3.0-rc1 #1
> >>>> [  114.497621] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
> >>>> [  114.498706] RIP: 0010:stable_page_flags+0x27/0x3f0
> >>>> [  114.499142] Code: 82 66 90 66 66 66 66 90 48 85 ff 0f 84 d1 03 00 00 41 54 55 48 89 fd 53 48 8b 57 08 48 8b 1f 48 8d 42 ff 83 e2 01 48 0f 44 c7 <48> 8b 00 f6 c4 02 0f 84 57 03 00 00 45 31 e4 48 8b 55 08 48 89 ef
> >>>> [  114.500788] RSP: 0018:ffffa5e601a0fe60 EFLAGS: 00010202
> >>>> [  114.501373] RAX: fffffffffffffffe RBX: ffffffffffffffff RCX: 0000000000000000
> >>>> [  114.502009] RDX: 0000000000000001 RSI: 00007ffca13a7310 RDI: ffffd07489000000
> >>>> [  114.502637] RBP: ffffd07489000000 R08: 0000000000000001 R09: 0000000000000000
> >>>> [  114.503270] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000240000
> >>>> [  114.503896] R13: 0000000000080000 R14: 00007ffca13a7310 R15: ffffa5e601a0ff08
> >>>> [  114.504530] FS:  00007f0266c7f540(0000) GS:ffff962dbbac0000(0000) knlGS:0000000000000000
> >>>> [  114.505245] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>> [  114.505754] CR2: fffffffffffffffe CR3: 000000023a204000 CR4: 00000000000006e0
> >>>> [  114.506401] Call Trace:
> >>>> [  114.506660]  kpageflags_read+0xb1/0x130
> >>>> [  114.507051]  proc_reg_read+0x39/0x60
> >>>> [  114.507387]  vfs_read+0x8a/0x140
> >>>> [  114.507686]  ksys_pread64+0x61/0xa0
> >>>> [  114.508021]  do_syscall_64+0x5f/0x1a0
> >>>> [  114.508372]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>>> [  114.508844] RIP: 0033:0x7f0266ba426b
> >>>>
> >>>> The reason for the panic is that stable_page_flags() which parses
> >>>> the page flags uses uninitialized struct pages reserved by the
> >>>> ZONE_DEVICE driver.
> >>>
> >>> Why pmem hasn't initialized struct pages?
> >>
> >> We proposed to initialize in previous approach but that wasn't merged.
> >> (See https://marc.info/?l=linux-mm&m=152964792500739&w=2)
> >>
> >>> Isn't that a bug that should be addressed rather than paper over it like this?
> >>
> >> I'm not sure. What do you think, Dan?
> >
> > Yeah, I am really curious about details. Why do we keep uninitialized
> > struct pages at all? What is a random pfn walker supposed to do? What
> > kind of metadata would be clobbered? In other words much more details
> > please.
> >
> I also want to know. I do not think that initializing struct pages will
> clobber any metadata.

The nvdimm implementation uses vmem_altmap to arrange for the 'struct
page' array to be allocated from a reservation of a pmem namespace. A
namespace in this mode contains an info-block that consumes the first
8K of the namespace capacity, capacity designated for page mapping,
capacity for padding the start of data to optionally 4K, 2MB, or 1GB
(on x86), and then the namespace data itself. The implementation
specifies a section aligned (now sub-section aligned) address to
arch_add_memory() to establish the linear mapping to map the metadata,
and then vmem_altmap indicates to memmap_init_zone() which pfns
represent data. The implementation only specifies enough 'struct page'
capacity for pfn_to_page() to operate on the data space, not the
namespace metadata space.

The proposal to validate ZONE_DEVICE pfns against the altmap seems the
right approach to me.
