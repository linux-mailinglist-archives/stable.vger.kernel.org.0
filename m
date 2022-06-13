Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8748549C6B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 20:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243903AbiFMS7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 14:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345723AbiFMS63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 14:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA662A96B;
        Mon, 13 Jun 2022 09:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D52E61517;
        Mon, 13 Jun 2022 16:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08465C341C4;
        Mon, 13 Jun 2022 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655136543;
        bh=bOQG7gHnDdMGBfklDl16uIKgl5y6vxCT/QANX4VnjVo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=r0oMkD6t6j9A8O1qWPidf3LYxVqoSuU0o6E93x93yd43BNTtaQO7RhJ/oaKyjVamT
         kSrjlVBDhwql3LmeyBRUD9gqXj6LNZvhfKfqHgcMnvI+XfXn7S5bpOoD9tmcCwPFq5
         JNuXjXdA4KrgUXSYioyJzF3PKs9FOUzHGRiMvewKoLmfw3V3rlq/Yo7/037S7wNx34
         0X0G1wDf8/EzUh6cyBfVz1699IWD2ahdXVxK3cQj/Uz6ucQ9j3/kshJKBGB0V+y03p
         sj6DTCVUCrFNkYW10n2QccfhJyEBo2pZFVfAag3vV/L8KD8roxg3DLfzKs1y1Z2TBL
         vgUL/0jE5LI0g==
Received: by mail-vs1-f48.google.com with SMTP id e20so6348838vso.4;
        Mon, 13 Jun 2022 09:09:02 -0700 (PDT)
X-Gm-Message-State: AJIora9Rqcdmyf6lHTwIcMw4036wPR4OG1KHJTlPYZhKrh2DEBCtYfrZ
        fWYXzLRjQ5OkVHVxcY+dHfUDbiAvEWbE6WcjJzM=
X-Google-Smtp-Source: AGRyM1vLi3E8SWmkdM9nCm5n2BpOcbavapE8yYOserlNgFyoFHEgZr/TUqEVQn9swzwoPnbDrMNvtR/KHlQJQK9KO84=
X-Received: by 2002:a05:6102:184:b0:34b:9e95:14cf with SMTP id
 r4-20020a056102018400b0034b9e9514cfmr31667vsq.59.1655136541881; Mon, 13 Jun
 2022 09:09:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
In-Reply-To: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 14 Jun 2022 00:08:50 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQJZFfpSOx0yo3zJfECwpZR=79F5uLKVV_qqopS+F2PYA@mail.gmail.com>
Message-ID: <CAJF2gTQJZFfpSOx0yo3zJfECwpZR=79F5uLKVV_qqopS+F2PYA@mail.gmail.com>
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the migratetype
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, huanyi.xj@alibaba-inc.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 9:11 PM Xianting Tian
<xianting.tian@linux.alibaba.com> wrote:
>
> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its mig=
ratetype.")
> added buddy check code. But unfortunately, this fix isn't backported to
> linux-5.17.y and the former stable branches. The reason is it added wrong
> fixes message:
>      Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackable
>                            pageblocks with others")
> Actually, this issue is involved by commit:
>      commit d9dddbf55667 ("mm/page_alloc: prevent merging between isolate=
d and other pageblocks")
>
> For RISC-V arch, the first 2M is reserved for sbi, so the start PFN is 51=
2,
> but it got buddy PFN 0 for PFN 0x2000:
>      0 =3D 0x2000 ^ (1 << 12)
How did we get 0? =EF=BC=88Try it in gdb)
(gdb) p /x (0x2000 ^ (1<<12))
$3 =3D 0x3000

I think it got buddy PFN 0 for PFN 0x1000, right?
(gdb) p /x (0x1000 ^ (1<<12))
$4 =3D 0x0

> With the illegal buddy PFN 0, it got an illegal buddy page, which caused
> crash in __get_pfnblock_flags_mask().
>
> With the patch, it can avoid the calling of get_pageblock_migratetype() i=
f
> it isn't buddy page.
>
> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and=
 other pageblocks")
> Cc: stable@vger.kernel.org
> Reported-by: zjb194813@alibaba-inc.com
> Reported-by: tianhu.hh@alibaba-inc.com
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  mm/page_alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b1caa1c6c887..5b423caa68fd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct page *pag=
e,
>
>                         buddy_pfn =3D __find_buddy_pfn(pfn, order);
>                         buddy =3D page + (buddy_pfn - pfn);
> +
> +                       if (!page_is_buddy(page, buddy, order))
Right, we need to check the buddy_pfn valid, because some SoCs would
start dram address with an offset that has an order smaller than
MAX_ORDER.

> +                               goto done_merging;
>                         buddy_mt =3D get_pageblock_migratetype(buddy);
>
>                         if (migratetype !=3D buddy_mt
> --
> 2.17.1
>

Fixup the comment and

Reviewed-by: Guo Ren <guoren@kernel.org>

--=20
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
