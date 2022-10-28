Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DFC610942
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 06:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJ1E1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 00:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ1E1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 00:27:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB47713ECC9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 21:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666931178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cEAc7Hi237RKPiSEF0PtMgwXplwCqgvBPVDp1f9TTo=;
        b=Bh6n1VyjJDCMzEq14Yvmo8LpQMaAUEfQCR5sxboXPlw+Yo49/jX+t0sYOoH/6u8qevciSG
        Rb3jVCgDhKIUlQ99QijWx4AXF9F4c2cXYXWaoR1FQMYpTyGdZbC4PRSu2QwKm8WUS23v64
        MiuQOTNSjeSEpS3Nf0kNv6e4TwZivYU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-3933THe9M7eBtdrjhNXMiA-1; Fri, 28 Oct 2022 00:26:17 -0400
X-MC-Unique: 3933THe9M7eBtdrjhNXMiA-1
Received: by mail-wm1-f70.google.com with SMTP id c5-20020a1c3505000000b003c56da8e894so3827503wma.0
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 21:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cEAc7Hi237RKPiSEF0PtMgwXplwCqgvBPVDp1f9TTo=;
        b=tSayKgde7E+HH4GBU+hhfdSXh79bP2vEvADyA33d8dbGEsqHvUpixj+IQnifSOtczU
         otgl8dk9lBuMHtlMaNIw5n3H5pleE7aA1atCHYiC+R1wiSuFz6C2KLZmLSC8DevhT9u5
         3D/pN8Ls2fNRWCttlqQMSPH3XqQ95kthwbyc1yJaFX0vu0KEtXpw0kX8rnJsPrVttGRT
         DYeoZvXRxSCzH9QBmIqAAacQvOAMpbkEJBgMx9Pq1kycyrHzIBO9IWedkwr3fv2lFN4Q
         irtLJfUhwe1t5t0snBAi8jwDplhv47riMikEgertSoE/DbW1UDx/+xmbBgtOGVScN2nj
         /5LQ==
X-Gm-Message-State: ACrzQf0GBPMQBpKlBpsJ9Ut7y6/J9SNNUBbUAKe2ZV1wPwzQNfsRlC2n
        dGPRaU36hM8YN2AVUeQ3MzoZoEkGMRqG/s0J/UArlSpAtFJSAITu5lNiTZVR3MRJEGzA3TZUEoT
        ijeGlVTgzV4XJGFVz
X-Received: by 2002:a05:600c:474a:b0:3c8:3299:5ba9 with SMTP id w10-20020a05600c474a00b003c832995ba9mr8166642wmo.3.1666931176212;
        Thu, 27 Oct 2022 21:26:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Zv8+uSxnn7hDyJbhoEG4ao9e9S+br+6l/SCoLy9GsSBv11BVKx+wXcm58HTu4ykyFZ8UVxQ==
X-Received: by 2002:a05:600c:474a:b0:3c8:3299:5ba9 with SMTP id w10-20020a05600c474a00b003c832995ba9mr8166625wmo.3.1666931175905;
        Thu, 27 Oct 2022 21:26:15 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:c100:8448:bf98:23a4:ac94? (p200300cbc704c1008448bf9823a4ac94.dip0.t-ipconnect.de. [2003:cb:c704:c100:8448:bf98:23a4:ac94])
        by smtp.gmail.com with ESMTPSA id o12-20020a5d58cc000000b00236705daefesm2577551wrf.39.2022.10.27.21.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 21:26:15 -0700 (PDT)
Message-ID: <623247f8-6b1d-b517-2053-6d5fb2cb418c@redhat.com>
Date:   Fri, 28 Oct 2022 06:26:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH STABLE 5.10] mm/memory: add non-anonymous page check in
 the copy_present_page()
To:     Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>
Cc:     Yuanzheng Song <songyuanzheng@huawei.com>,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221024094911.3054769-1-songyuanzheng@huawei.com>
 <3823471f-6dda-256e-e082-718879c05449@google.com> <Y1nRiJ1LYB62uInn@x1n>
 <fffefe4-adce-a7d-23e0-9f8afc7ce6cf@google.com> <Y1qdY8oUlUvWl067@x1n>
 <8aad435-bdc6-816f-2fe4-efe53abd6e5@google.com> <Y1sMk30wS+1uH/hc@x1n>
 <432c4428-b6d4-f93-266-b920a854c3c@google.com>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <432c4428-b6d4-f93-266-b920a854c3c@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.10.22 03:32, Hugh Dickins wrote:
> Reinstating Cc stable, which I removed just before the discussion settled.

Sorry for not reading the full thread before and considering Peters 
mail; I had to take short cuts :)

> 
> On Thu, 27 Oct 2022, Peter Xu wrote:
>> ...
>>
>> After a re-read and 2nd thought, I think David has a valid point in that we
>> shouldn't have special handling of !anon pages on CoW during fork(),
>> because that seems to be against the fundamental concept of fork().
>>
>> So now I think I agree the !Anon original check does look a bit cleaner,
>> and also make fork() behavior matching with the old/new kernels, irrelevant
>> of the pin mess.
> 
> Thanks Peter.  So Yuanzheng's patch for 5.10 is exactly right.
> 
> Sorry for leading everyone astray: my mistake was to suppose that
> its !PageAnon check was simply to avoid the later BUG_ON(!anon_vma):
> whereas David and Peter now agree that it actually corrects the
> semantics for fork() on file pages.
> 
> I lift my hold on Yuanzheng's patch: nobody actually said "Acked-by",
> but I think the discussion and resolution have given better than that.
> (No 3rd thoughts please!)

Unless someone tells me why I am obviously wrong

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

