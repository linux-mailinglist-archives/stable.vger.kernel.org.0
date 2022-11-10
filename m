Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAC5624C43
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 21:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiKJU7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 15:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiKJU7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 15:59:49 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71175BF43;
        Thu, 10 Nov 2022 12:59:48 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id b62so2768371pgc.0;
        Thu, 10 Nov 2022 12:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ttnTp5vp2+AUQBRn+QGy/iRGXLK+0tabr5kkUXhWOgs=;
        b=V6Q9AJjq/+dmrcYI7h+aulvTykjmhLd1RDGvAX9rhCqLvMzcJiQ8Bq6I4O8Zo+KbBU
         v+S7axetyuIG5g85HmYt13h/reXa2j++X+JW5oqNALhMY7dxU1aadTzPRDRYCdqxNroz
         KOTp3OLn+73So8MdZWAfOvC0Vxjh2c1pzAjcR6F+7kVKThpzp7508UVq1YyfTJnRt8bK
         Z15Z8mnTMqIgtcmB5EwLk5l0oviHvJvodz4eh8a1vTrwnm3JUorhU+AHtzIoVbZ0aqQO
         MniReX3X8yEvtBqyzq2JoLwiotAOZUmLFZYvLFsqLciS3BrALwofpQSyBf+i/ZU/pA1r
         8bVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ttnTp5vp2+AUQBRn+QGy/iRGXLK+0tabr5kkUXhWOgs=;
        b=ARIRPI6zELJrNmX9vFMCNlnZcY2td0X8/2B5k+FfcbAupiDJOsPMWgyGPIosqdcR1m
         YjSULzqjLMlhENLCoooqE//fTm+acYFYB2ZGrWCvPmFFa4+WO7EkVoP8395Kvtmv4B1T
         C2goHy9VxtvdPlQ49sBavOyxQLBWrOS59bttJBReyT2OpvlQZzPRsSvbZ1dyvsZgzWT8
         wvmCL7NMSCT8i2L+a2s6NagEsVP8QHfJEOA9Pg0JD8/8IO7fwQtrYB1PO+23YGTclBXo
         PmAw4n+WL6aikLPJbmMed9SzvX4Gta6h9Ur8YhssEGE1xru8ZSoi2S5ZexvWsDCE9I+z
         lQpA==
X-Gm-Message-State: ACrzQf0HoP/INcO7gvyl9E+9k3pkuPoTy7L2cbkeqziV/d9aRYIrhvJC
        rd/6dU29AQOsct0kwZKqJd0=
X-Google-Smtp-Source: AMsMyM6EHzt5LxVevsndFmHExWuuCQcz+zx1M9l033QaIuOyzvy5wN/9s8a4u75MaKHlbgvIrK8GaQ==
X-Received: by 2002:aa7:9d02:0:b0:565:b4fe:de85 with SMTP id k2-20020aa79d02000000b00565b4fede85mr3495651pfp.81.1668113987711;
        Thu, 10 Nov 2022 12:59:47 -0800 (PST)
Received: from smtpclient.apple ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id n17-20020aa79851000000b0052d4b0d0c74sm94457pfq.70.2022.11.10.12.59.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Nov 2022 12:59:47 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v8 1/2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20221108011910.350887-2-mike.kravetz@oracle.com>
Date:   Thu, 10 Nov 2022 12:59:45 -0800
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
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9BB0EA0C-6E7C-462B-8374-5BFEC34E8415@gmail.com>
References: <20221108011910.350887-1-mike.kravetz@oracle.com>
 <20221108011910.350887-2-mike.kravetz@oracle.com>
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

On Nov 7, 2022, at 5:19 PM, Mike Kravetz <mike.kravetz@oracle.com> =
wrote:

> madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
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

I understand the problem in general. Please consider my feedback as =
partial
though.


> @@ -5203,32 +5194,50 @@ void __unmap_hugepage_range_final(struct =
mmu_gather *tlb,
> 			  unsigned long end, struct page *ref_page,
> 			  zap_flags_t zap_flags)
> {
> +	bool final =3D zap_flags & ZAP_FLAG_UNMAP;
> +

Not sure why caching final in local variable helps.

>=20
> void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long =
start,
> 			  unsigned long end, struct page *ref_page,
> 			  zap_flags_t zap_flags)
> {
> +	struct mmu_notifier_range range;
> 	struct mmu_gather tlb;
>=20
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, =
vma->vm_mm,
> +				start, end);
> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, =
&range.end);
> 	tlb_gather_mmu(&tlb, vma->vm_mm);
> +
> 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, =
zap_flags);

Is there a reason for not using range.start and range.end?

It is just that every inconsistency is worrying=E2=80=A6

>=20
> @@ -1734,6 +1734,9 @@ static void zap_page_range_single(struct =
vm_area_struct *vma, unsigned long addr
> 	lru_add_drain();
> 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, =
vma->vm_mm,
> 				address, address + size);
> +	if (is_vm_hugetlb_page(vma))
> +		adjust_range_if_pmd_sharing_possible(vma, &range.start,
> +							&range.end);
> 	tlb_gather_mmu(&tlb, vma->vm_mm);
> 	update_hiwater_rss(vma->vm_mm);
> 	mmu_notifier_invalidate_range_start(&range);
> @@ -1742,6 +1745,12 @@ static void zap_page_range_single(struct =
vm_area_struct *vma, unsigned long addr
> 	tlb_finish_mmu(&tlb);
> }
>=20
> +void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
> +		unsigned long size)
> +{
> +	__zap_page_range_single(vma, address, size, NULL);

Ugh. So zap_vma_range() would actually be emitted as a wrapper function =
that
only calls __zap_page_range_single() (or worse __zap_page_range_single()
which is large would be inlined), unless you use LTO.

Another option is to declare __zap_page_range_size() in the header and =
move
this one to the header as inline wrapper.

