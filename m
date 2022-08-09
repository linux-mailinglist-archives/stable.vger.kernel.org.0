Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B7C58E09A
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbiHIUGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346374AbiHIUGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:06:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80E161EAE0
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 13:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660075589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnFi6UtyTY9WNAK3ojJYdk14zblLhZ4ZNfoakUrtm+A=;
        b=FTExnaDtg0H7wCUAB0O5izMLmaE0iiT48FCuAG2gSijDPoIniQEPMUGx/jynTdFTccTleZ
        JWBJIj9+a8ZyUMRuzp3fOviNmIPRBkK+p5TNHWx8PAbLHj6VuHdyZV8wXomjFIW9QqRdem
        FvN/YEtRdrvdv1vr+BKr0lQ9WKt1Dug=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-fpQTx50vOkq6IHYG2NfV6A-1; Tue, 09 Aug 2022 16:06:28 -0400
X-MC-Unique: fpQTx50vOkq6IHYG2NfV6A-1
Received: by mail-wm1-f69.google.com with SMTP id r5-20020a1c4405000000b003a534ec2570so3501499wma.7
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=tnFi6UtyTY9WNAK3ojJYdk14zblLhZ4ZNfoakUrtm+A=;
        b=571ptU6+xUilF7EWsgl7v+8JUOByvwHSoyBMTl6Phhjpaejvg66aZhbnVObQZ0ofqQ
         ycKcO4+VF7MgzvsBeblUSOkprgJpWe900s9dhE6Ogy4hX5PGvMbhgmTRXrQkflgmUCF2
         GfXcjSTqkgZD1sf62F6Fb/Xl9QRvcmwsnSOW/FHVcj9P6xAn38WxGReiIFAzY5Up73oG
         emwTsBZZUugSSNuPrwuuRTbiMHEonqwD8Hd4c4l80mtj7UHCLhXrEtXta/4kBS/g2/D7
         r7BooEq7FkUqoa0SnQcSpQ5ZDs34IOGRKRkI8ttbpFTO9ylK2uz/xtCBuFP6qh8Xd+6a
         BJTA==
X-Gm-Message-State: ACgBeo2XdBbO47bAYmx5iBYeYrK7sa5VU59tec/sPpa7qmEt+bZwACaw
        ey3bRTnPIx32NoyBfgod2pPZ54AyPXUfHwi1fvrdNcv9S1/wPBWmUYyz1FJAsgv7pXoY1PpQyPj
        1MLT+7GQJkNK0ZPh6
X-Received: by 2002:a05:600c:1c83:b0:3a3:1f70:25a5 with SMTP id k3-20020a05600c1c8300b003a31f7025a5mr96411wms.54.1660075587259;
        Tue, 09 Aug 2022 13:06:27 -0700 (PDT)
X-Google-Smtp-Source: AA6agR66DZ40NogmO6UZUwoav9+z+Te4GfHYB3lGDXDsf01sUqvkBPwo8yj0Y6XaOnjGX9a867sFmQ==
X-Received: by 2002:a05:600c:1c83:b0:3a3:1f70:25a5 with SMTP id k3-20020a05600c1c8300b003a31f7025a5mr96390wms.54.1660075586937;
        Tue, 09 Aug 2022 13:06:26 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:3700:aed2:a0f8:c270:7f30? (p200300cbc7053700aed2a0f8c2707f30.dip0.t-ipconnect.de. [2003:cb:c705:3700:aed2:a0f8:c270:7f30])
        by smtp.gmail.com with ESMTPSA id a7-20020a056000100700b0021f0c0c62d1sm14231325wrx.13.2022.08.09.13.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:06:26 -0700 (PDT)
Message-ID: <92f5352e-c903-0413-6dea-9758222c79ad@redhat.com>
Date:   Tue, 9 Aug 2022 22:06:25 +0200
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAHk-=wgsDOz5MfYYS9mE7PvFn4kLhTFdBwXvN6HCEsw1kvJnRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.08.22 22:00, Linus Torvalds wrote:
> On Mon, Aug 8, 2022 at 12:32 AM David Hildenbrand <david@redhat.com> wrote:
>>
> 
> So I've read through the patch several times, and it seems fine, but
> this function (and the pmd version of it) just read oddly to me.
> 
>> +static inline bool can_follow_write_pte(pte_t pte, struct page *page,
>> +                                       struct vm_area_struct *vma,
>> +                                       unsigned int flags)
>> +{
>> +       if (pte_write(pte))
>> +               return true;
>> +       if (!(flags & FOLL_FORCE))
>> +               return false;
>> +
>> +       /*
>> +        * See check_vma_flags(): only COW mappings need that special
>> +        * "force" handling when they lack VM_WRITE.
>> +        */
>> +       if (vma->vm_flags & VM_WRITE)
>> +               return false;
>> +       VM_BUG_ON(!is_cow_mapping(vma->vm_flags));
> 
> So apart from the VM_BUG_ON(), this code just looks really strange -
> even despite the comment. Just conceptually, the whole "if it's
> writable, return that you cannot follow it for a write" just looks so
> very very strange.
> 
> That doesn't make the code _wrong_, but considering how many times
> this has had subtle bugs, let's not write code that looks strange.
> 
> So I would suggest that to protect against future bugs, we try to make
> it be fairly clear and straightforward, and maybe even a bit overly
> protective.
> 
> For example, let's kill the "shared mapping that you don't have write
> permissions to" very explicitly and without any subtle code at all.
> The vm_flags tests are cheap and easy, and we could very easily just
> add some core ones to make any mistakes much less critical.
> 
> Now, making that 'is_cow_mapping()' check explicit at the very top of
> this would already go a long way:
> 
>         /* FOLL_FORCE for writability only affects COW mappings */
>         if (!is_cow_mapping(vma->vm_flags))
>                 return false;

I actually put the is_cow_mapping() mapping check in there because
check_vma_flags() should make sure that we cannot possibly end up here
in that case. But we can spell it out with comments, doesn't hurt.

> 
> but I'd actually go even further: in this case that "is_cow_mapping()"
> helper to some degree actually hides what is going on.
> 
> So I'd actually prefer for that function to be written something like
> 
>         /* If the pte is writable, we can write to the page */
>         if (pte_write(pte))
>                 return true;
> 
>         /* Maybe FOLL_FORCE is set to override it? */
>         if (flags & FOLL_FORCE)
>                 return false;
> 
>         /* But FOLL_FORCE has no effect on shared mappings */
>         if (vma->vm_flags & MAP_SHARED)
>                 return false;
> 
>         /* .. or read-only private ones */
>         if (!(vma->vm_flags & MAP_MAYWRITE))
>                 return false;
> 
>         /* .. or already writable ones that just need to take a write fault */
>         if (vma->vm_flags & MAP_WRITE)
>                 return false;
> 
> and the two first vm_flags tests above are basically doing tat
> "is_cow_mapping()", and maybe we could even have a comment to that
> effect, but wouldn't it be nice to just write it out that way?
> 
> And after you've written it out like the above, now that
> 
>         if (!page || !PageAnon(page) || !PageAnonExclusive(page))
>                 return false;
> 
> makes you pretty safe from a data sharing perspective: it's most
> definitely not a shared page at that point.
> 
> So if you write it that way, the only remaining issues are the magic
> special soft-dirty and uffd ones, but at that point it's purely about
> the semantics of those features, no longer about any possible "oh, we
> fooled some shared page to be writable".
> 
> And I think the above is fairly legible without any subtle cases, and
> the one-liner comments make it all fairly clear that it's testing.
> 
> Is any of this in any _technical_ way different from what your patch
> did? No. It's literally just rewriting it to be a bit more explicit in
> what it is doing, I think, and it makes that odd "it's not writable if
> VM_WRITE is set" case a bit more explicit.
> 
> Hmm?

No strong opinion. I'm happy as long as it's fixed, and the fix is robust.


-- 
Thanks,

David / dhildenb

