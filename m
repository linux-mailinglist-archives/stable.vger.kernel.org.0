Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714AB6D9074
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 09:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbjDFHbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 03:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjDFHbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 03:31:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B32EE;
        Thu,  6 Apr 2023 00:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF80461482;
        Thu,  6 Apr 2023 07:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FEDC4339B;
        Thu,  6 Apr 2023 07:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680766281;
        bh=ETbfyfCMDp3/1UzRk+wb1+5DWlQo/l40rg20m5e16cU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g+yqaDwXIWwFaaFSp/PkhyUZ4wki+zkdYZxgkWjkg69YT+maDEJCHKU2kZEAipH66
         moSHtF7o/YUJr24G1pN426d8u5xtTia7en25hlCc0bijtI+SJZcmiamJrhDU19BKa6
         lOPoYQhW5Ccy1iJaDvZjLogjiH3V48G5QYf8qHy/05HeBeTATj9aredUuXwPIKkRpj
         CNWLycNWFzIiAEiqS8h7NFZu9bsf8QaQ3wT3kGy1OCegcIHaHL0MU7qoD8QGJvuh0J
         or4ofV5F3twEEp8grfTAV1WzFvXdrCKlIn9d9hSXeBLPuTQcoxr+2fVUHDV4t0FqK7
         efMWOV280V5xg==
Received: by mail-lj1-f175.google.com with SMTP id z42so39771871ljq.13;
        Thu, 06 Apr 2023 00:31:21 -0700 (PDT)
X-Gm-Message-State: AAQBX9eCx+BTgYUOLHcp/8mlt1PbYgzz6BqUYUpCXSr9SxHgql2j6Kft
        CH7yz8sqgmLKhVz64pzbW+dKtKVQyKLCWUfib+E=
X-Google-Smtp-Source: AKy350bQNM+gUl6oQj2ADMATHsYFHDqbNQfOH6aDOcb3ZHj4ykvfAYvg5QVvyYoQEt59P3U63UrU1cj2BKR2Hk5kNsI=
X-Received: by 2002:a2e:93c3:0:b0:298:bddc:dbbf with SMTP id
 p3-20020a2e93c3000000b00298bddcdbbfmr3104529ljh.2.1680766279202; Thu, 06 Apr
 2023 00:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230406040515.383238-1-jhubbard@nvidia.com>
In-Reply-To: <20230406040515.383238-1-jhubbard@nvidia.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 6 Apr 2023 09:31:07 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHxyntweiq76CdW=ov2_CkEQUbdPekGNDtFp7rBCJJE2w@mail.gmail.com>
Message-ID: <CAMj1kXHxyntweiq76CdW=ov2_CkEQUbdPekGNDtFp7rBCJJE2w@mail.gmail.com>
Subject: Re: [PATCH] arm64/mm: don't WARN when alloc/free-ing device private pages
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello John,

On Thu, 6 Apr 2023 at 06:05, John Hubbard <jhubbard@nvidia.com> wrote:
>
> Although CONFIG_DEVICE_PRIVATE and hmm_range_fault() and related
> functionality was first developed on x86, it also works on arm64.
> However, when trying this out on an arm64 system, it turns out that
> there is a massive slowdown during the setup and teardown phases.
>
> This slowdown is due to lots of calls to WARN_ON()'s that are checking
> for pages that are out of the physical range for the CPU. However,
> that's a design feature of device private pages: they are specfically
> chosen in order to be outside of the range of the CPU's true physical
> pages.
>

Currently, the vmemmap region is dimensioned to only cover the PFN
range that backs the linear map. So the WARN() seems appropriate here:
you are mapping struct page[] ranges outside of the allocated window,
and afaict, you might actually wrap around and corrupt the linear map
at the start of the kernel VA space like this.


> x86 doesn't have this warning. It only checks that pages are properly
> aligned. I've shown a comparison below between x86 (which works well)
> and arm64 (which has these warnings).
>
> memunmap_pages()
>   pageunmap_range()
>     if (pgmap->type == MEMORY_DEVICE_PRIVATE)
>       __remove_pages()
>         __remove_section()
>           sparse_remove_section()
>             section_deactivate()
>               depopulate_section_memmap()
>                 /* arch/arm64/mm/mmu.c */
>                 vmemmap_free()
>                 {
>                   WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
>                   ...
>                 }
>
>                 /* arch/x86/mm/init_64.c */
>                 vmemmap_free()
>                 {
>                   VM_BUG_ON(!PAGE_ALIGNED(start));
>                   VM_BUG_ON(!PAGE_ALIGNED(end));
>                   ...
>                 }
>
> So, the warning is a false positive for this case. Therefore, skip the
> warning if CONFIG_DEVICE_PRIVATE is set.
>

I don't think this is a false positive. We'll need to adjust
VMEMMAP_SIZE to account for this.


> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> cc: <stable@vger.kernel.org>
> ---
>  arch/arm64/mm/mmu.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 6f9d8898a025..d5c9b611a8d1 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1157,8 +1157,10 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>                 struct vmem_altmap *altmap)
>  {
> +/* Device private pages are outside of the CPU's physical page range. */
> +#ifndef CONFIG_DEVICE_PRIVATE
>         WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
> -
> +#endif
>         if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES))
>                 return vmemmap_populate_basepages(start, end, node, altmap);
>         else
> @@ -1169,8 +1171,10 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  void vmemmap_free(unsigned long start, unsigned long end,
>                 struct vmem_altmap *altmap)
>  {
> +/* Device private pages are outside of the CPU's physical page range. */
> +#ifndef CONFIG_DEVICE_PRIVATE
>         WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
> -
> +#endif
>         unmap_hotplug_range(start, end, true, altmap);
>         free_empty_tables(start, end, VMEMMAP_START, VMEMMAP_END);
>  }
> --
> 2.40.0
>
