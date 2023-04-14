Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05956E258F
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 16:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjDNOYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 10:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDNOYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 10:24:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD822BB92
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 07:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681482206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hltDKbvNvHexES28VJ8PrHZ5axydk/DuBFAgC2CjweM=;
        b=DHF9Z/9pjh3gJsDuHGqCUbOjHxcASzA31LPB8ED1qECe6MFkRgaU/gTeJUgsuWUJ/+6FvH
        DK9Kzr62M2c1QWirXpLeCa66ZLFwD4jvSzRXhEqB7Cx8WhxZorD7Pl+N+TldLpqZMPRyEK
        nSI70batQq0cfTYe1N4XvpmLWXqoDL4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-WbWEUC5APDaSuh7Kxs4A3w-1; Fri, 14 Apr 2023 10:23:24 -0400
X-MC-Unique: WbWEUC5APDaSuh7Kxs4A3w-1
Received: by mail-lf1-f71.google.com with SMTP id e7-20020a196907000000b004db20d1cf7fso7227478lfc.18
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 07:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681482203; x=1684074203;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hltDKbvNvHexES28VJ8PrHZ5axydk/DuBFAgC2CjweM=;
        b=OWLPnvI2i/iQfFazATOnthU20YcA0V4mCpDvRcu+MetL/e7I2aB8y2yfbjAc3mKjFg
         oonbQdhN33bX9y735WaelBXJGGWM1p6Ta1sW2NJerBM/CZT1RhxtCvHL8go0b8RnyDLY
         DdmBN2JtbeKVPhaTNu/NHVv0/aFKryg66wmrhiIyX21MAOuWPklrqcfqy0SUM7y7bke/
         /tYV3LpYWTDkI808dnBJgv6pwir0zfND9X0RK+WIsWaUc2kM68GUk8ki40pXuxHymdMY
         g5mjK7vogwmmuoRBnjLQV3FAq5uf0eb9V0jGfC4KUiTkijKpYKCtgT5t4GQ1W0F4A8Lf
         G7aA==
X-Gm-Message-State: AAQBX9fxwpITQhN2QasmtMxNslgRgWBmOOqVfQgE0rh2n7uHjJ5SDcaC
        pLqod66EpwsA6FcbO37ObrwvM+NIfCarb98hR1pbmyc9v8CIX+kT5MRTowbKVE+D13/uk+XhcSn
        xncvHh9Alsg9QKtQ=
X-Received: by 2002:a2e:a792:0:b0:2a8:ac66:eeab with SMTP id c18-20020a2ea792000000b002a8ac66eeabmr768218ljf.0.1681482203011;
        Fri, 14 Apr 2023 07:23:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350b7VPoQO09O0c49XgZ4B2B4eCvIBorexhqlHcLjtGZkMsk2NCN98yoWaRivKxjs6AR2MoVjZw==
X-Received: by 2002:a2e:a792:0:b0:2a8:ac66:eeab with SMTP id c18-20020a2ea792000000b002a8ac66eeabmr768199ljf.0.1681482202680;
        Fri, 14 Apr 2023 07:23:22 -0700 (PDT)
Received: from [192.168.1.121] (85-23-48-202.bb.dnainternet.fi. [85.23.48.202])
        by smtp.gmail.com with ESMTPSA id v7-20020a2e87c7000000b002a2b9d9429esm832740ljj.117.2023.04.14.07.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 07:23:21 -0700 (PDT)
Message-ID: <d14ddbc6-5315-78a2-cdfa-72a77d3603dd@redhat.com>
Date:   Fri, 14 Apr 2023 17:23:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/6] mm/hugetlb: Fix uffd-wp during fork()
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-stable <stable@vger.kernel.org>
References: <20230413231120.544685-1-peterx@redhat.com>
 <20230413231120.544685-2-peterx@redhat.com>
 <9cb84b60-6b51-3117-27cb-a29b3bd9e741@mbosol.com> <ZDlet0+oZ2nrnUdu@x1n>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mpenttil@redhat.com>
In-Reply-To: <ZDlet0+oZ2nrnUdu@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 14.4.2023 17.09, Peter Xu wrote:
> On Fri, Apr 14, 2023 at 12:45:29PM +0300, Mika Penttilä wrote:
>>>    		} else if (unlikely(is_hugetlb_entry_migration(entry))) {
>>>    			swp_entry_t swp_entry = pte_to_swp_entry(entry);
>>> -			bool uffd_wp = huge_pte_uffd_wp(entry);
> 
> [1]
> 
>>>    			if (!is_readable_migration_entry(swp_entry) && cow) {
>>>    				/*
>>> @@ -5049,11 +5050,12 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>>>    				swp_entry = make_readable_migration_entry(
>>>    							swp_offset(swp_entry));
>>>    				entry = swp_entry_to_pte(swp_entry);
> 
> [2]
> 
>>> -				if (userfaultfd_wp(src_vma) && uffd_wp)
>>> -					entry = huge_pte_mkuffd_wp(entry);
>>> +				if (userfaultfd_wp(src_vma) &&
>>> +				    pte_swp_uffd_wp(entry))
>>> +					entry = pte_swp_mkuffd_wp(entry);
>>
>>
>> This looks interesting with pte_swp_uffd_wp and pte_swp_mkuffd_wp ?
> 
> Could you explain what do you mean?
> 

Yes like you noticed also you called pte_swp_mkuffd_wp(entry) iff 
pte_swp_uffd_wp(entry) which is of course a nop.

But the fixup not dropping the temp var should work.

> I think these helpers are the right ones to use, as afaict hugetlb
> migration should follow the same pte format with !hugetlb.  However, I
> noticed I did it wrong when dropping the temp var - when at [1], "entry"
> still points to the src entry, but at [2] it's already pointing to the
> newly created one..  so I think I can't drop the var, a fixup should like:
> 
> ===8<===
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 083aae35bff8..cd3a9d8f4b70 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5041,6 +5041,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>                          set_huge_pte_at(dst, addr, dst_pte, entry);
>                  } else if (unlikely(is_hugetlb_entry_migration(entry))) {
>                          swp_entry_t swp_entry = pte_to_swp_entry(entry);
> +                       bool uffd_wp = pte_swp_uffd_wp(entry);
> 
>                          if (!is_readable_migration_entry(swp_entry) && cow) {
>                                  /*
> @@ -5050,8 +5051,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>                                  swp_entry = make_readable_migration_entry(
>                                                          swp_offset(swp_entry));
>                                  entry = swp_entry_to_pte(swp_entry);
> -                               if (userfaultfd_wp(src_vma) &&
> -                                   pte_swp_uffd_wp(entry))
> +                               if (userfaultfd_wp(src_vma) && uffd_wp)
>                                          entry = pte_swp_mkuffd_wp(entry);
>                                  set_huge_pte_at(src, addr, src_pte, entry);
> ===8<===
> 
> Besides, did I miss something else?
> 
> Thanks,
> 

--Mika

