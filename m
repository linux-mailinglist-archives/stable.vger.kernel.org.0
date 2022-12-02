Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D92640980
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 16:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiLBPlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 10:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbiLBPln (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 10:41:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114F9C0542
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 07:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669995651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ukZurXWBYF9XacBE0s0LYySmWKNtgdpXiH8C9SL7Axg=;
        b=fVNlgw8LliFz07cPxPWzMVZE4/FnWOFrOLlG5aNNyBd1h6l6n8XzcixTR/NeUXLP9bK6nE
        1Ix6j8oVxUY/MbQCukojIhDTu7O/C4jjXTkBZGIYIjuAT5kuIYhQDjSTQCqeLN9M+kkKiu
        tcG6pVgzPD0h7EUsaDoJRFHSmVoGMls=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-401-GItMQcG_Om6OJuZecBuaYQ-1; Fri, 02 Dec 2022 10:40:50 -0500
X-MC-Unique: GItMQcG_Om6OJuZecBuaYQ-1
Received: by mail-wm1-f71.google.com with SMTP id j2-20020a05600c1c0200b003cf7397fc9bso2671007wms.5
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 07:40:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ukZurXWBYF9XacBE0s0LYySmWKNtgdpXiH8C9SL7Axg=;
        b=SpEQu0MqGH44rflw72Qluq46LmFrVJtrdOHHcx8cqHqlppUr8bC5yo2hWzRbX3VHOl
         V6bBo6o+gAJoZRgti+d/qCMJKittNrpaxTYHDr8NV7awqnDz7X3Z4a2tz2pY7UVa7ziW
         oAF/50n26/MMyDkb1DKT6Zm8WQaIU/AxXymlVbH5IdK69wzFiiFoNEJwq8/dx3wPrm8K
         zoXobFrNgk91F7LSfKhav+VuyRdjJtLbwY3w9jO1+RK85gZUZkQ6x4VMrVUti7knF7lf
         sGU1C0uRFXaN7HTa3MPpyYvNcmcWjE57MvF/1/Ws7C+plwDViAaUEa3wijFAPG4nT6uW
         4gKg==
X-Gm-Message-State: ANoB5pkm+lrk1pK+09yauv/Ac0FCz3cG3oUwhyTVPM0OrcI6am7gGEk/
        IZ0I+AGztxiJ/SsI/M4rS3WFnVqYJ5Xj4jtB3LdBqUrcin4pYyl8uRiKCP1A5CfcbJ8bHalO2zM
        ZKymBvxsyGxI08LD1
X-Received: by 2002:a1c:f015:0:b0:3cf:7818:b123 with SMTP id a21-20020a1cf015000000b003cf7818b123mr56155919wmb.8.1669995648914;
        Fri, 02 Dec 2022 07:40:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6XWXVf4E+myn6zx3UJjMA1ITegc4vnWDGw2UgAobBJt+oz3eX0LXIw1B+lzdUlHUDFdcID6w==
X-Received: by 2002:a1c:f015:0:b0:3cf:7818:b123 with SMTP id a21-20020a1cf015000000b003cf7818b123mr56155902wmb.8.1669995648619;
        Fri, 02 Dec 2022 07:40:48 -0800 (PST)
Received: from ?IPV6:2003:cb:c703:7a00:852e:72cd:ed76:d72f? (p200300cbc7037a00852e72cded76d72f.dip0.t-ipconnect.de. [2003:cb:c703:7a00:852e:72cd:ed76:d72f])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c4f5500b003b4fe03c881sm14181214wmq.48.2022.12.02.07.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 07:40:48 -0800 (PST)
Message-ID: <0e864a86-040b-810d-86ee-f702604e7f5f@redhat.com>
Date:   Fri, 2 Dec 2022 16:40:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
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
 <fc3e3497-053d-8e50-a504-764317b6a49a@redhat.com>
 <222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com> <Y4oWOqgqmv1BFAFx@x1n>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
In-Reply-To: <Y4oWOqgqmv1BFAFx@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>>>
>>>> David, do you feel that the proposed fix will at least address the bug
>>>> without adverse side-effects?
>>>
>>> Usually, when I suspect something is dodgy I unconsciously push back
>>> harder than I usually would.
> 
> Please consider using unconsciousness only for self guidance, figuring out
> directions, or making decisions on one's own.

Yeah, sorry about my communication. I expressed that this approach felt 
wrong to me, I just wasn't able to phrase exactly why I thought 
migration is doing the right thing and didn't have a lot of time to look 
into the details.

Now I dedicated some time and realized that mproctect() is doing the 
exact same thing, it became clearer to me why migration code wasn't 
broken before.

> 
> For discussions on the list which can get more than one person involved, we
> do need consciousness and reasonings.

Yeah, I need vacation.

> 
> Thanks for the reproducer, that's definitely good reasonings.  Do you have
> other reproducer that can trigger an issue without mprotect()?

As noted in the RFC patch I sent, I suspect NUMA hinting page remapping 
might similarly trigger it. I did not try reproducing it, though.

> 
> As I probably mentioned before in other threads mprotect() is IMHO
> conceptually against uffd-wp and I don't yet figured out how to use them
> all right.  For example, we can uffd-wr-protect a pte in uffd-wp range,
> then if we do "mprotect(RW)" it's hard to tell whether the user wants it
> write or not.  E.g., using mprotect(RW) to resolve page faults should be
> wrong because it'll not touch the uffd-wp bit at all.  I confess I never
> thought more on how we should define the interactions between uffd-wp and
> mprotect.
> 
> In short, it'll be great if you have other reproducers for any uffd-wp
> issues other than mprotect().
> 
> I said that also because I just got another message from Ives privately
> that there _seems_ to have yet another even harder to reproduce bug here
> (Ives, feel free to fill in any more information if you got it).  So if you
> can figure out what's missing and already write a reproducer, that'll be
> perfect.

Maybe NUMA hitning on the fallback path, when we didn't migrate or 
migration failed?

-- 
Thanks,

David / dhildenb

