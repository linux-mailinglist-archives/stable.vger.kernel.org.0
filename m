Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1717F624D99
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 23:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiKJWWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 17:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiKJWWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 17:22:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9447954B2A;
        Thu, 10 Nov 2022 14:22:36 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so3137268pjk.1;
        Thu, 10 Nov 2022 14:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHY+kysMGJVbzbEObxWTInmf2L9+jpy/p2OFZ3375RI=;
        b=WiY7yFDacp64O2Pev/BvEetYI5+ndnbH/0mcVheO1p8LjNYBXlObMkB3N5dVhhoCU3
         y+oM+E/QNrEnRv5KY8crf7FtTr8HJj07UnqgLmh5FFixD8jaSWJYV8ScEy8d4zrHj3Zg
         Mq4anY97G7zF+Qd4O9xBCem99DiQgHh7OYvq5HRSFFQhLwYosO231Nj8+zdDAwXrokhS
         9oaqTShTMeMQpR6qiyXoWkE+tn/3/NYcKf/kP+7kz6TBuTMTy7SCdsP5CSi9eOZQTue3
         XZl1bp4H6FbFn2eHbkO7RaOCcwyfDw9GeI3ugQT6MEEA9HnF0DWHsQKl5EN2FI4bSdMb
         U2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHY+kysMGJVbzbEObxWTInmf2L9+jpy/p2OFZ3375RI=;
        b=OOySKm19pJMZZVfqIcuVRTl1bY+IBhc2D6f3c6bKffhc00C+8/R4zEOv4VSEkJl+0x
         CWWQvJv8Yqd7+08wABAHx7pS2l6DriHO4CxFuyCVJuvU359V9RFF5ZtEbC//c5AchBxL
         08AXgn+BcMDM5O53bcmmPBOYNMuMvvyob/M3jkPNna/QFi5nt9ag2UfZ0vbZRdXqSuYd
         Mk49i9bIRmkTLn3qm8h11DYmsH7eqwL3yedNbEHPTxqWCuGbGrOeuupuYFil34v/ZCM2
         DxrIu90ISLsLer9n0ru7FqXiC9w3CKVsCy2aEVjjB3vt7hYgjlralQV9suDKZp3KsbcQ
         KPGg==
X-Gm-Message-State: ACrzQf2pcAOKYU24pCC1bvoodlsJoS/CN/r6yhlrQN5gVO9IhfO4MdDO
        Q/td8hgVY2fTa5QzaTPQBt8=
X-Google-Smtp-Source: AMsMyM7L9IL8Dr3o5nnAwbYn8GCadJesXPPu6tT60qy6ClZN/5EgaIvOe6wmCYfzpHz9OxAlqB7M9g==
X-Received: by 2002:a17:90a:6846:b0:20a:c1bf:ad2d with SMTP id e6-20020a17090a684600b0020ac1bfad2dmr2363665pjm.112.1668118955878;
        Thu, 10 Nov 2022 14:22:35 -0800 (PST)
Received: from smtpclient.apple ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id y26-20020a63495a000000b0043941566481sm126737pgk.39.2022.11.10.14.22.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Nov 2022 14:22:35 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v8 1/2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <Y21xlgG6sxP6q5K9@monkey>
Date:   Thu, 10 Nov 2022 14:22:33 -0800
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
Message-Id: <05FB2C99-9141-4F2A-8664-31CA5587B310@gmail.com>
References: <20221108011910.350887-1-mike.kravetz@oracle.com>
 <20221108011910.350887-2-mike.kravetz@oracle.com>
 <9BB0EA0C-6E7C-462B-8374-5BFEC34E8415@gmail.com> <Y21xlgG6sxP6q5K9@monkey>
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

On Nov 10, 2022, at 1:48 PM, Mike Kravetz <mike.kravetz@oracle.com> =
wrote:

>>> void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long =
start,
>>> 			  unsigned long end, struct page *ref_page,
>>> 			  zap_flags_t zap_flags)
>>> {
>>> +	struct mmu_notifier_range range;
>>> 	struct mmu_gather tlb;
>>>=20
>>> +	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, =
vma->vm_mm,
>>> +				start, end);
>>> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, =
&range.end);
>>> 	tlb_gather_mmu(&tlb, vma->vm_mm);
>>> +
>>> 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, =
zap_flags);
>>=20
>> Is there a reason for not using range.start and range.end?
>=20
> After calling adjust_range_if_pmd_sharing_possible, range.start - =
range.end
> could be much greater than the range we actually want to unmap.  The =
range
> gets adjusted to account for pmd sharing if that is POSSIBLE.  It does =
not
> know for sure if we will actually 'unshare a pmd'.
>=20
> I suppose adjust_range_if_pmd_sharing_possible could be modified to =
actually
> check if unmapping will result in unsharing, but it does not do that =
today.

Thanks for the explanation. It=E2=80=99s probably me, but I am still not =
sure that I
understand the the different between __unmap_hugepage_range() using =
(start,
end) and __zap_page_range_single() using (address, range.end). Perhaps =
it
worth a comment in the code?

But anyhow=E2=80=A6 shouldn=E2=80=99t unmap_hugepage_range() call
mmu_notifier_invalidate_range_start()?

