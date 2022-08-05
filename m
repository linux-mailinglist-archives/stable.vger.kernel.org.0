Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76B858AFAF
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 20:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241262AbiHESWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 14:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240487AbiHESWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 14:22:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88654E03B
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 11:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659723770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5p3/E3MKKChtQ+yJPQTq5w0X3LO2YWBfr+q1/W8OCSg=;
        b=fj+lO4Pgh2WtMTt9Tf9uiN0svBSKvcSiTNIjFeJFKbj7w6bS5ePgS8TgO3RNHpgxKoYyoo
        7NACRvXCWSXvT026BfYjF3bwirH5XCl9MbGnDWhx6H295qg67VF43Q5ja5j8lO3vMyTcFE
        MdZ2qDvN+euytw6lnnLx8VatVLRK2OE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-yrCPgDv8Mr6qoDZZEFjJCw-1; Fri, 05 Aug 2022 14:22:49 -0400
X-MC-Unique: yrCPgDv8Mr6qoDZZEFjJCw-1
Received: by mail-wm1-f71.google.com with SMTP id j22-20020a05600c485600b003a50fa6981bso2704230wmo.9
        for <stable@vger.kernel.org>; Fri, 05 Aug 2022 11:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=5p3/E3MKKChtQ+yJPQTq5w0X3LO2YWBfr+q1/W8OCSg=;
        b=qiSvRAb8pxmnrypxobhqJizEbmUPlyQeFjv5PkVOnfa/4xtrId1BxgyhkVGRKAQqij
         qWHwQrr1B+iXgTPlJE5w1O7pr5YoRXsEKoK+unfb1MBDT7cfkc9RuNPRZBPHqskAxPyw
         E72Dil1fSr65bf22Zwu0iyzH8F9WUPhp06PnnXfQX76zEIjmb250gtg+P/q1MIkI9YRc
         0Letb/Fy6L8x4g/JPSJxecpWkDZLyeznq+9pVZX3e2vdowmixOQNEWPvC3L5bv/Wk98y
         v0PEN1PkxTcbN86jJ5IhuR02L+7WoSUlHdBdw4HUU9VJvndWnwwiKZtb2Yj6il84F3kc
         uk5A==
X-Gm-Message-State: ACgBeo1zVTJQHiBD0MGSArx8ocanM2L0tir8WuIz64lOIq7DZ04QEjnQ
        XCnUZppFCdGQ6LYON9MVUYqNQpdomwyFZWg9tJ/I8NFWmwObNupSCdVO6mXX4T3jock6w+Ko21P
        JzIKMFsd0xz3ivYZ0
X-Received: by 2002:a05:600c:22d8:b0:3a5:1450:669e with SMTP id 24-20020a05600c22d800b003a51450669emr5040801wmg.102.1659723768159;
        Fri, 05 Aug 2022 11:22:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4pH623NdL7leuNH6oZdmjVJRAOBVTCO95WffXCQlv2dho7acCWovQ4knC3wfTsvFK8io5zOQ==
X-Received: by 2002:a05:600c:22d8:b0:3a5:1450:669e with SMTP id 24-20020a05600c22d800b003a51450669emr5040793wmg.102.1659723767924;
        Fri, 05 Aug 2022 11:22:47 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:fb00:f5c3:24b2:3d03:9d52? (p200300cbc706fb00f5c324b23d039d52.dip0.t-ipconnect.de. [2003:cb:c706:fb00:f5c3:24b2:3d03:9d52])
        by smtp.gmail.com with ESMTPSA id g6-20020a05600c4ec600b003a3199c243bsm14398006wmq.0.2022.08.05.11.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 11:22:47 -0700 (PDT)
Message-ID: <f0d1ebae-f518-9761-f39c-5c1b52f3eebf@redhat.com>
Date:   Fri, 5 Aug 2022 20:22:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com> <Yu1eCsMqa641zj5C@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Yu1eCsMqa641zj5C@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.08.22 20:14, Peter Xu wrote:
> On Fri, Aug 05, 2022 at 01:03:28PM +0200, David Hildenbrand wrote:
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index 61e6135c54ef..462a6b0344ac 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>>  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
>>  		return 0;
>>  
>> +	/*
>> +	 * Hugetlb does not require/support writenotify; especially, it does not
>> +	 * support softdirty tracking.
>> +	 */
>> +	if (is_vm_hugetlb_page(vma))
>> +		return 0;
> 
> I'm kind of confused here..  you seems to be fixing up soft-dirty for
> hugetlb but here it's explicitly forbidden.
> 
> Could you explain a bit more on why this patch is needed if (assume
> there'll be a working) patch 2 being provided?

I want something simple to backport. And even with patch #2 in place, as
long as we don't support softdirty tracking, it doesn't make sense to
enable it here as of now.

-- 
Thanks,

David / dhildenb

