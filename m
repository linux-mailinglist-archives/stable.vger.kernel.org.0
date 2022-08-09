Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C2158E0F0
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344914AbiHIUUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344572AbiHIUU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:20:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39FD426576
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 13:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660076426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcR+xwROcY1mQWTajdWclph8yvOYoZAKRICeYRXiSjg=;
        b=GxJZZ9/Fj9+4iO0v1HPTq/Upb9oBlBk9AS/TZEVFhZJZh2+A/RO0B6mP6/xYPlKsT8qXTH
        lfLdR1+TrNP6B6/xb8yX5dOIa+UD0mFcodoEoYY8tH7bLUKJJuVB6JHrykTGZF7oeaDHSj
        w8PTRu4MMMeurPTqlw2p4AtaEBoBh3E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-iady6rWtOcGpmEuTyeb3gA-1; Tue, 09 Aug 2022 16:20:25 -0400
X-MC-Unique: iady6rWtOcGpmEuTyeb3gA-1
Received: by mail-wm1-f69.google.com with SMTP id i65-20020a1c3b44000000b003a537031613so24407wma.2
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=WcR+xwROcY1mQWTajdWclph8yvOYoZAKRICeYRXiSjg=;
        b=Oo/pQF/BEj13NxnvBF/jMVGBmooOmIvf0boaUOEA7qi7cKeysKMzqRbyUSasf1dUK8
         JvsvwyGzQ+0eysn8D8GEf1FkHiFKdDnlaE6fW2sb3nlEJ3sp0brZt84H/4rqUb+LMbWE
         eAV8afhtSIN4B0cM5kpIQkbvHsCNOZuRLnUrOss2Z9R2ox2OLvgkFyaceTc5IlxNE+LP
         IDNs8hJ1Tnvj3Xe6aH4tic9dyV12KPcSOmS6HDjJmDEOwTFmRQ/y+Q7ZvQPzZbD+igJT
         3KS2JXJE5hUlb8M2maZZ3f9BmTSbyRfzmu69/bJazYTq9iXQT1tZw84GUxqVMLPbQg/k
         BKnw==
X-Gm-Message-State: ACgBeo2K+LsRw/a+onj6W6dEzeOzHLYT7f5WZvUePLcaCIqnX4Zfn2Vn
        pvLrVvJyXnP2ljIQ6qzivA22pDv+gZOyxJKIAp6ZY1R155ww6EWSom7GoVqFOrWLI6Uv1zKibWg
        Y0amR0kRMUKLNzv20
X-Received: by 2002:a05:6000:1f08:b0:21f:bbe:252c with SMTP id bv8-20020a0560001f0800b0021f0bbe252cmr15069295wrb.340.1660076423835;
        Tue, 09 Aug 2022 13:20:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7Zk/2i2sQWeAOcXQyBbElluR5dmTZ3mGZC6uzovtHrJmIzwfvv+RsxeehU4XAEb3CDzxc9Ew==
X-Received: by 2002:a05:6000:1f08:b0:21f:bbe:252c with SMTP id bv8-20020a0560001f0800b0021f0bbe252cmr15069286wrb.340.1660076423561;
        Tue, 09 Aug 2022 13:20:23 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:3700:aed2:a0f8:c270:7f30? (p200300cbc7053700aed2a0f8c2707f30.dip0.t-ipconnect.de. [2003:cb:c705:3700:aed2:a0f8:c270:7f30])
        by smtp.gmail.com with ESMTPSA id k12-20020adfb34c000000b002205df9ce16sm14294415wrd.97.2022.08.09.13.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:20:23 -0700 (PDT)
Message-ID: <c096cc82-60b4-9e75-06ad-156461292941@redhat.com>
Date:   Tue, 9 Aug 2022 22:20:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wgsDOz5MfYYS9mE7PvFn4kLhTFdBwXvN6HCEsw1kvJnRQ@mail.gmail.com>
 <91e18a2f-c93d-00b8-7c1b-6d8493c3b2d5@redhat.com>
 <CAHk-=whg0ddey-LqFAPfZJDXHMjaHJNojAV3q17yvjc6W8QRvQ@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAHk-=whg0ddey-LqFAPfZJDXHMjaHJNojAV3q17yvjc6W8QRvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.08.22 22:14, Linus Torvalds wrote:
> On Tue, Aug 9, 2022 at 1:07 PM David Hildenbrand <david@redhat.com> wrote:
>>
>>>         /* But FOLL_FORCE has no effect on shared mappings */
>>>         if (vma->vm_flags & MAP_SHARED)
>>>                 return false;
>>
>> I'd actually rather check for MAP_MAYSHARE here, which is even stronger.
>> Thoughts?
> 
> Hmm. Adding the test for both is basically free (all those vm_flags
> checks end up being a bit mask and compare), so no objections.
> 
> For some reason I though VM_SHARED and VM_MAYSHARE end up always being
> the same bits, and it was a mistake to make them two bits in the first
> place (unlike the read/write/exec bits that can are about mprotect),
> 
> But as there are two bits, I'm sure somebody ends up touching one and
> not the other.
> 
> So yeah, I don't see any downside to just checking both bits.
> 
> [ That said, is_cow_mapping() only checks VM_SHARED, so if they are
> ever different, that's a potential source of confusion ]

IIUC VM_MAYSHARE is always set in a MAP_SHARED mapping, but for file
mappings we only set VM_SHARED if the file allows for writes (and we can
set VM_MAYWRITE or even VM_WRITE). [don't ask me why, it's a steady
source of confusion]

That's why is_cow_mapping() works even due to the weird MAP_SHARED vs.
VM_MAYSHARE logic.


I'd actually only check for VM_MAYSHARE here, which implies MAP_SHARED.
If someone would ever mess that up, I guess we'd be in bigger trouble.

But whatever you prefer.

-- 
Thanks,

David / dhildenb

