Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7782182A0D
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 05:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfHFDem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 23:34:42 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43663 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729170AbfHFDek (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 23:34:40 -0400
Received: by mail-ot1-f68.google.com with SMTP id j11so31743304otp.10
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 20:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EDNp+Ta6gMJd0qC2k/c4bi4bSV6V5T/LLbiFwKzHxR8=;
        b=nn0bwJ1RnVN1nEe84bPQ5rDHBY+AzXx+HWUuwzICcqVcJMeHxe5JqmfezZ9ENy7151
         Y7XfozR3s+z3o+1SRpCsIomH1I4/71dbKwluj9hzrMZyxVP3siXr/DLPk19bCB90fuA/
         qssGAnfVRmjZGh6GbUrbI8oZt2qbUBTNNFqPhuHXyMm+dxjj2uBM9rCAxNF9agh/21dg
         C77KxXfM3Fc0f/OfI7WA2fvrGVG8Fm81ayptDyCEw6yMpkdYqjXDGix+3TGUdQCX15yG
         SokJgfKMpMpLVDI79V5B6WUZ4ftPcLroIKg5CXmUyqP9tOlfE7DT1mBtI7Bpa+SaP9x9
         ngtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EDNp+Ta6gMJd0qC2k/c4bi4bSV6V5T/LLbiFwKzHxR8=;
        b=rDDLwEwIKmB1aXMNbMTUH7nIeOOvueDkAo3I4W0UpMcIkACfNbeVvj/y6AoSN6lsJ7
         OrguQ6h9RG5sXXF8Ua8JYTkMPlaoUXObfqHTb2cTPMtoGM0JmcVV0MZkxRvCT98izolo
         Ipa74lPW16VU+RFdxQFC1ReOVXPHS2T0atiiTNk6/NcKLwghS8Y8Hi7QaQxAG9rxREDp
         RQ5LxV7ECrG3Bp/ChG8dqu2iD9AgzG3st4eljB6tRiyX2g71moIVWH7NQSWPwf+6QWgj
         unxDX6I3BAjFXn6RFnnTa5oP5Q95nKk605l43lQlLPgKB4D6FLLlBs53YFA3J8O2wDeB
         oAtA==
X-Gm-Message-State: APjAAAU0g8fcMYusdweW1t5UniMrgUnM9J8WVJvO13N9xrW8LkkZLEyw
        ZTEbIb4k/cDgNdnFTPKJ8NQqUIj8vuD4x+W0ZDKq6g==
X-Google-Smtp-Source: APXvYqyk7Z6pXQU/U/Aq1loGZvmfCCCy0tb/anU7jipDeMdIHPjvkC9zTXxSnuSL/q3ljtFTcXRuSPhHRCUnbxEi7Ew=
X-Received: by 2002:a9d:7a8b:: with SMTP id l11mr1016089otn.247.1565062478674;
 Mon, 05 Aug 2019 20:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190725023100.31141-1-t-fukasawa@vx.jp.nec.com> <20190725023100.31141-3-t-fukasawa@vx.jp.nec.com>
In-Reply-To: <20190725023100.31141-3-t-fukasawa@vx.jp.nec.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 5 Aug 2019 20:34:27 -0700
Message-ID: <CAPcyv4iRQqfJXr1pe5XXPZ2sQrYbL8qAShgOQ+cBDiEVxWUZPA@mail.gmail.com>
Subject: Re: [PATCH 2/2] /proc/kpageflags: do not use uninitialized struct pages
To:     Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>
Cc:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
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

On Wed, Jul 24, 2019 at 7:46 PM Toshiki Fukasawa
<t-fukasawa@vx.jp.nec.com> wrote:
>
> A kernel panic was observed during reading /proc/kpageflags for
> first few pfns allocated by pmem namespace:
>
> BUG: unable to handle page fault for address: fffffffffffffffe
> [  114.495280] #PF: supervisor read access in kernel mode
> [  114.495738] #PF: error_code(0x0000) - not-present page
> [  114.496203] PGD 17120e067 P4D 17120e067 PUD 171210067 PMD 0
> [  114.496713] Oops: 0000 [#1] SMP PTI
> [  114.497037] CPU: 9 PID: 1202 Comm: page-types Not tainted 5.3.0-rc1 #1
> [  114.497621] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
> [  114.498706] RIP: 0010:stable_page_flags+0x27/0x3f0
> [  114.499142] Code: 82 66 90 66 66 66 66 90 48 85 ff 0f 84 d1 03 00 00 41 54 55 48 89 fd 53 48 8b 57 08 48 8b 1f 48 8d 42 ff 83 e2 01 48 0f 44 c7 <48> 8b 00 f6 c4 02 0f 84 57 03 00 00 45 31 e4 48 8b 55 08 48 89 ef
> [  114.500788] RSP: 0018:ffffa5e601a0fe60 EFLAGS: 00010202
> [  114.501373] RAX: fffffffffffffffe RBX: ffffffffffffffff RCX: 0000000000000000
> [  114.502009] RDX: 0000000000000001 RSI: 00007ffca13a7310 RDI: ffffd07489000000
> [  114.502637] RBP: ffffd07489000000 R08: 0000000000000001 R09: 0000000000000000
> [  114.503270] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000240000
> [  114.503896] R13: 0000000000080000 R14: 00007ffca13a7310 R15: ffffa5e601a0ff08
> [  114.504530] FS:  00007f0266c7f540(0000) GS:ffff962dbbac0000(0000) knlGS:0000000000000000
> [  114.505245] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  114.505754] CR2: fffffffffffffffe CR3: 000000023a204000 CR4: 00000000000006e0
> [  114.506401] Call Trace:
> [  114.506660]  kpageflags_read+0xb1/0x130
> [  114.507051]  proc_reg_read+0x39/0x60
> [  114.507387]  vfs_read+0x8a/0x140
> [  114.507686]  ksys_pread64+0x61/0xa0
> [  114.508021]  do_syscall_64+0x5f/0x1a0
> [  114.508372]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  114.508844] RIP: 0033:0x7f0266ba426b
>
> The reason for the panic is that stable_page_flags() which parses
> the page flags uses uninitialized struct pages reserved by the
> ZONE_DEVICE driver.
>
> Earlier approach to fix this was discussed here:
> https://marc.info/?l=linux-mm&m=152964770000672&w=2
>
> This is another approach. To avoid using the uninitialized struct page,
> immediately return with KPF_RESERVED at the beginning of
> stable_page_flags() if the page is reserved by ZONE_DEVICE driver.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>
> ---
>  fs/proc/page.c           |  3 +++
>  include/linux/memremap.h |  6 ++++++
>  kernel/memremap.c        | 20 ++++++++++++++++++++
>  3 files changed, 29 insertions(+)
>
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 69064ad..decd3fe 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -97,6 +97,9 @@ u64 stable_page_flags(struct page *page)
>         if (!page)
>                 return BIT_ULL(KPF_NOPAGE);
>
> +       if (pfn_zone_device_reserved(page_to_pfn(page)))
> +               return BIT_ULL(KPF_RESERVED);

I think this should be KPF_NOPAGE. KPF_RESERVED implies a page is present.

> +
>         k = page->flags;
>         u = 0;
>
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index f8a5b2a..2cfc3c2 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -124,6 +124,7 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
>  }
>
>  #ifdef CONFIG_ZONE_DEVICE
> +bool pfn_zone_device_reserved(unsigned long pfn);
>  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
>  void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
>  struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
> @@ -132,6 +133,11 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
>  unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
>  void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
>  #else
> +static inline bool pfn_zone_device_reserved(unsigned long pfn)
> +{
> +       return false;
> +}
> +
>  static inline void *devm_memremap_pages(struct device *dev,
>                 struct dev_pagemap *pgmap)
>  {
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 6ee03a8..bc3471c 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -72,6 +72,26 @@ static unsigned long pfn_next(unsigned long pfn)
>         return pfn + 1;
>  }
>
> +/*
> + * This returns true if the page is reserved by ZONE_DEVICE driver.
> + */
> +bool pfn_zone_device_reserved(unsigned long pfn)
> +{
> +       struct dev_pagemap *pgmap;
> +       struct vmem_altmap *altmap;
> +       bool ret = false;
> +
> +       pgmap = get_dev_pagemap(pfn, NULL);

Ugh this will drastically slow down kpageflags_read() for all other
pfn ranges. What about burning another section flag to indicate
'device' sections so that we have a quick lookup for
pfn_is_zone_device()?

> +       if (!pgmap)
> +               return ret;

If pfn_is_zone_device() returns true than a failure to retrieve the
dev_pagemap should result in this routine returning true as well
because it means the driver hosting the device is in the process of
tearing down the mapping.

> +       altmap = pgmap_altmap(pgmap);
> +       if (altmap && pfn < (altmap->base_pfn + altmap->reserve))
> +               ret = true;
> +       put_dev_pagemap(pgmap);
> +
> +       return ret;
> +}
> +
>  #define for_each_device_pfn(pfn, map) \
>         for (pfn = pfn_first(map); pfn < pfn_end(map); pfn = pfn_next(pfn))
>
> --
> 1.8.3.1
>
