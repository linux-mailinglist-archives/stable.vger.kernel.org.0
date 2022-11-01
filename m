Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80992614270
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 01:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiKAAyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 20:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKAAyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 20:54:06 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF1E388;
        Mon, 31 Oct 2022 17:54:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d10so12138250pfh.6;
        Mon, 31 Oct 2022 17:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fq59yWSLafAiwk54zqJ+kxPVtmYjp0IhMh7ZZqtSKsc=;
        b=Jn71qW/dsPMLnTWj9wU/Ls18emsiyQ1X+GccfVRr/xSW0gRq46YTl3ULVWDjIMdCP1
         CIk5RxhNNCOpSGzyan2Y/nxQIz5XtRVYqIc0AuiNxZaXrcqZ+V8Sp/cI9vLwqwjv2uvu
         yUX3ipqNmjK8EMCNDGENmJXEseW4mu3TpD5ZoYysP0blrkJnFXEdyS0x+OicQhHu61cA
         RDllDlQf4qZBf2hRFtAXLWngwf4Xwn+qmDofXgsWdRWBf7zrWTlabDroQ3wRDD7AXzJm
         7DOFxQ3t32omDbfMvmjtjBAfYcpkBM/oiRGeK/f+a5E2DyVhW6aCdP0IZ1kNNGT6gi1b
         q/DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fq59yWSLafAiwk54zqJ+kxPVtmYjp0IhMh7ZZqtSKsc=;
        b=beyp5LFqGOBPrxMOG055SNafOGq/ISl6lsSh219m9rNbgXmksb54dF1T4HQewUc9w6
         DrtC3IWQ7bYhzcuUscsHmrptiJff+KM00WjDAUUxsq4n7ek6buHkt0XlMCFqp/F0uJrK
         +57He51LrzSPqhE07nyBxi+KpLaPUbZdTZEyBf7N4OtxZqt9yhuit3KOXsg3i2qSOvcD
         e9rcmnrn8iGDeNavCD2vlMTMJ2/KTTbMIEyIC0YwaQe3Izc4D8GDPsXm3RD5pcZnx2h7
         +S1qu7/ng+dX9N+XRPgm+SN45yTcBbm+nMwxsWGpNaKLwQRPAvibshgwV9xhJLVj+9Ie
         Os3A==
X-Gm-Message-State: ACrzQf0GycPY4us5fLZU7Cbh0pHXxBNpkHoNi5x8rvkuBZOxWTzfuAkv
        pFunvV/ryP2o+p3fiGGp5zc=
X-Google-Smtp-Source: AMsMyM68v+SPLmdGRHXnn8XITjdXmScdbfcMceoqHO21dZYPGTJifMObb5NEhCgwPfvq90nPbsftgQ==
X-Received: by 2002:a63:5d12:0:b0:46e:cd38:3f76 with SMTP id r18-20020a635d12000000b0046ecd383f76mr14639852pgb.64.1667264043742;
        Mon, 31 Oct 2022 17:54:03 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 17-20020a17090a19d100b002036006d65bsm4795469pjj.39.2022.10.31.17.54.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Oct 2022 17:54:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v6] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20221031223440.285187-1-mike.kravetz@oracle.com>
Date:   Mon, 31 Oct 2022 17:54:01 -0700
Cc:     Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>,
        "# 5 . 10+" <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8D2D2F0F-9A53-42B5-8A9D-936E06E4A4E9@gmail.com>
References: <20221031223440.285187-1-mike.kravetz@oracle.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Oct 31, 2022, at 3:34 PM, Mike Kravetz <mike.kravetz@oracle.com> =
wrote:

> madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear the =
page
> tables associated with the address range.  For hugetlb vmas,
> zap_page_range will call __unmap_hugepage_range_final.  However,
> __unmap_hugepage_range_final assumes the passed vma is about to be =
removed
> and deletes the vma_lock to prevent pmd sharing as the vma is on the =
way
> out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
> missing vma_lock prevents pmd sharing and could potentially lead to =
issues
> with truncation/fault races.
>=20

[snip]

> index 978c17df053e..517c8cc8ccb9 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3464,4 +3464,7 @@ madvise_set_anon_name(struct mm_struct *mm, =
unsigned long start,
>  */
> #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
>=20
> +/* Set in unmap_vmas() to indicate an unmap call.  Only used by =
hugetlb */
> +#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))

PeterZ wants to add ZAP_FLAG_FORCE_FLUSH that would be set on
zap_pte_range(). Not sure you would want to combine them both together, =
but
at least be aware of potential conflict.

=
https://lore.kernel.org/all/Y1f7YvKuwOl1XEwU@hirez.programming.kicks-ass.n=
et/

[snip]

> +#ifdef CONFIG_ADVISE_SYSCALLS
> +/*
> + * Similar setup as in zap_page_range().  madvise(MADV_DONTNEED) can =
not call
> + * zap_page_range for hugetlb vmas as __unmap_hugepage_range_final =
will delete
> + * the associated vma_lock.
> + */
> +void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned =
long start,
> +				unsigned long end)
> +{
> +	struct mmu_notifier_range range;
> +	struct mmu_gather tlb;
> +
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, =
vma->vm_mm,
> +				start, end);
> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, =
&range.end);
> +	tlb_gather_mmu(&tlb, vma->vm_mm);
> +	update_hiwater_rss(vma->vm_mm);
> +	mmu_notifier_invalidate_range_start(&range);
> +
> +	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0);
> +
> +	mmu_notifier_invalidate_range_end(&range);
> +	tlb_finish_mmu(&tlb);
> }
> +#endif

I hate ifdef=E2=80=99s. And the second definition of =
clear_hugetlb_page_range() is
confusing since it does not have an ifdef at all. . How about moving the
ifdef=E2=80=99s into the function like being done in io_madvise_prep()? =
I think it
is less confusing.

[ snip ]

>=20
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1671,7 +1671,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct =
maple_tree *mt,
> {
> 	struct mmu_notifier_range range;
> 	struct zap_details details =3D {
> -		.zap_flags =3D ZAP_FLAG_DROP_MARKER,
> +		.zap_flags =3D ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
> 		/* Careful - we need to zap private pages too! */
> 		.even_cows =3D true,
> 	};
> @@ -1704,15 +1704,21 @@ void zap_page_range(struct vm_area_struct =
*vma, unsigned long start,
> 	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
>=20
> 	lru_add_drain();
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, =
vma->vm_mm,
> -				start, start + size);
> 	tlb_gather_mmu(&tlb, vma->vm_mm);
> 	update_hiwater_rss(vma->vm_mm);
> -	mmu_notifier_invalidate_range_start(&range);
> 	do {
> -		unmap_single_vma(&tlb, vma, start, range.end, NULL);
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, =
vma,
> +				vma->vm_mm,
> +				max(start, vma->vm_start),
> +				min(start + size, vma->vm_end));
> +		if (is_vm_hugetlb_page(vma))
> +			adjust_range_if_pmd_sharing_possible(vma,
> +				&range.start,
> +				&range.end);
> +		mmu_notifier_invalidate_range_start(&range);
> +		unmap_single_vma(&tlb, vma, start, start + size, NULL);

Is there a reason that you wouldn=E2=80=99t use range.start and =
range.end here?
At least for consistency.

