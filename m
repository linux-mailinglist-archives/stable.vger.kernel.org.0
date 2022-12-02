Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96021640576
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 12:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiLBLEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 06:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbiLBLEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 06:04:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CB2BC58A
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 03:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669979035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cl9BjYb9f8vItMx0TFPNMbbgg++LcJpl4yIcLgyzCmw=;
        b=S2/S2EzxHXlNiZN9Dl4QyJLuMCyH7dSVwCJhpqYKFFjY600bBgSAWq5tVRRMOYOR+Hwkc9
        YKTHgD48QcVQda9RNEd/kuax2H2CE53vNLH/PuKTDHf2sOQ8KaIaraMiNlHzlwQfkAp6uY
        XQxrgjdscG8OgsoZYsWx97pqvtZQDuE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-591-59Jkf3X_P_Wpe6zQTB2n_A-1; Fri, 02 Dec 2022 06:03:54 -0500
X-MC-Unique: 59Jkf3X_P_Wpe6zQTB2n_A-1
Received: by mail-wr1-f70.google.com with SMTP id j29-20020adfb31d000000b0024237066261so1003229wrd.14
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 03:03:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cl9BjYb9f8vItMx0TFPNMbbgg++LcJpl4yIcLgyzCmw=;
        b=Io/htRvckgj07ycCT/jp9WrtJvp0bxzPHN4RS8FE+xDaxJLe4MmKMKQY0hQaYvz2Fz
         cdkAkoDZouQv4G79u7uawOz8uilAONB9d219QnoGIOQnMHmI9I5xW3YiybGI61ucFC3Y
         W49EEhEh13F8DHGBx0JUGzXoRa/q7nmkmDUV5jXOThP1jnMcXPN4DHH/ewGwOjuUFlQw
         Wxk2Wc2ls/LzDtcOim8xqx8es7KS0BD+M2lDlhNY6tOqYyTSoFd0XeRTqU+7ehMxcCHP
         Qe4N3buneesk1uOHbdtUuYSC1TOJDw+DP30HwLbIrON2VO+8gb18xkOjvb0QG8Z6tTBi
         cXyA==
X-Gm-Message-State: ANoB5plbXXfw7jgqR5fAL162M5PlZqbAAi20HOz9qVLMgnLpFwS+VGMo
        9W0lcMGN3Ys54qqGiIa/X+l0733xXIY9seSeFNCwkw0ZsVRtD2L6HiGeCy5m/4u9r6JVrUdJPsK
        3uWLxYj2XHPKOFNYg
X-Received: by 2002:a5d:4d51:0:b0:242:1bad:6f79 with SMTP id a17-20020a5d4d51000000b002421bad6f79mr14341715wru.342.1669979033601;
        Fri, 02 Dec 2022 03:03:53 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Z7CSJWV3aVGdFrhurXtg5Jl7JAd2UPh1oqFxa5cN4kxMH/tvksSMCkT/9ngAbabHuPc5XuA==
X-Received: by 2002:a5d:4d51:0:b0:242:1bad:6f79 with SMTP id a17-20020a5d4d51000000b002421bad6f79mr14341694wru.342.1669979033335;
        Fri, 02 Dec 2022 03:03:53 -0800 (PST)
Received: from ?IPV6:2003:cb:c703:7a00:852e:72cd:ed76:d72f? (p200300cbc7037a00852e72cded76d72f.dip0.t-ipconnect.de. [2003:cb:c703:7a00:852e:72cd:ed76:d72f])
        by smtp.gmail.com with ESMTPSA id f7-20020adffcc7000000b00236883f2f5csm6742721wrs.94.2022.12.02.03.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 03:03:52 -0800 (PST)
Message-ID: <fc3e3497-053d-8e50-a504-764317b6a49a@redhat.com>
Date:   Fri, 2 Dec 2022 12:03:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Alistair Popple <apopple@nvidia.com>, stable@vger.kernel.org
References: <20221114000447.1681003-1-peterx@redhat.com>
 <20221114000447.1681003-2-peterx@redhat.com>
 <5ddf1310-b49f-6e66-a22a-6de361602558@redhat.com>
 <20221130142425.6a7fdfa3e5954f3c305a77ee@linux-foundation.org>
 <Y4jIHureiOd8XjDX@x1n> <a215fe2f-ef9b-1a15-f1c2-2f0bb5d5f490@redhat.com>
 <20221201143058.80296541cc6802d1e5990033@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
In-Reply-To: <20221201143058.80296541cc6802d1e5990033@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01.12.22 23:30, Andrew Morton wrote:
> On Thu, 1 Dec 2022 16:42:52 +0100 David Hildenbrand <david@redhat.com> wrote:
> 
>> On 01.12.22 16:28, Peter Xu wrote:
>>>
>>> I didn't reply here because I have already replied with the question in
>>> previous version with a few attempts.  Quotting myself:
>>>
>>> https://lore.kernel.org/all/Y3KgYeMTdTM0FN5W@x1n/
>>>
>>>           The thing is recovering the pte into its original form is the
>>>           safest approach to me, so I think we need justification on why it's
>>>           always safe to set the write bit.
>>>
>>> I've also got another longer email trying to explain why I think it's the
>>> other way round to be justfied, rather than justifying removal of the write
>>> bit for a read migration entry, here:
>>>
>>
>> And I disagree for this patch that is supposed to fix this hunk:
>>
>>
>> @@ -243,11 +243,15 @@ static bool remove_migration_pte(struct page *page, struct vm_area_struct *vma,
>>                   entry = pte_to_swp_entry(*pvmw.pte);
>>                   if (is_write_migration_entry(entry))
>>                           pte = maybe_mkwrite(pte, vma);
>> +               else if (pte_swp_uffd_wp(*pvmw.pte))
>> +                       pte = pte_mkuffd_wp(pte);
>>    
>>                   if (unlikely(is_zone_device_page(new))) {
>>                           if (is_device_private_page(new)) {
>>                                   entry = make_device_private_entry(new, pte_write(pte));
>>                                   pte = swp_entry_to_pte(entry);
>> +                               if (pte_swp_uffd_wp(*pvmw.pte))
>> +                                       pte = pte_mkuffd_wp(pte);
>>                           }
>>                   }
> 
> David, I'm unclear on what you mean by the above.  Can you please
> expand?
> 
>>
>> There is really nothing to justify the other way around here.
>> If it's broken fix it independently and properly backport it independenty.
>>
>> But we don't know about any such broken case.
>>
>> I have no energy to spare to argue further ;)
> 
> This is a silent data loss bug, which is about as bad as it gets.
> Under obscure conditions, fortunately.  But please let's keep working
> it.  Let's aim for something minimal for backporting purposes.  We can
> revisit any cleanliness issues later.

Okay, you activated my energy reserves.

> 
> David, do you feel that the proposed fix will at least address the bug
> without adverse side-effects?

Usually, when I suspect something is dodgy I unconsciously push back 
harder than I usually would.

I just looked into the issue once again and realized that this patch 
here (and also my alternative proposal) most likely tackles the 
more-generic issue from the wrong direction. I found yet another such 
bug (most probably two, just too lazy to write another reproducer). 
Migration code does the right thing here -- IMHO -- and the issue should 
be fixed differently.

I'm testing an alternative patch right now and will share it later 
today, along with a reproducer.

-- 
Thanks,

David / dhildenb

