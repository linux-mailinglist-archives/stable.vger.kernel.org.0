Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6233645B02
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 14:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiLGNfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 08:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLGNe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 08:34:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FD42FC32
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 05:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670420045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PacGtqlFWYVFHK08vpyrRIk/v4jPepTFNKvA2M5ITow=;
        b=FYwyZsfJMFw96sYFVIA47h6npAmjz71TwjLRBaHqUQZpAavU+1RVTxFwI36x710mHizqdE
        NsM1OdsaCD2SRrL2RBS6zBtyeo620IkIllwIAHUogSv+TOuQzhSAiLmqSmDX/HJzrAmbb6
        zJpXeYQ0SDUxUgT1WJjO5cTW/vVY0dA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-Ccy9g5lxPGyBqclUthWrew-1; Wed, 07 Dec 2022 08:34:04 -0500
X-MC-Unique: Ccy9g5lxPGyBqclUthWrew-1
Received: by mail-wm1-f70.google.com with SMTP id r7-20020a1c4407000000b003d153a83d27so1471856wma.0
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 05:34:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PacGtqlFWYVFHK08vpyrRIk/v4jPepTFNKvA2M5ITow=;
        b=v9hcJOms4oU9tl5jR2mrNdO2faSNoSt+pq9fM2RS7ypempvgJnRce0fCe+KxTS82/j
         BHZri/mC22pCXxcgndve8VjK+eGbcvminoiPThipGHx3lSAiD6HTzrsw1MSk9FKaAwmH
         h/pj6E83U8s0MwxR/L2HS7C7DtdLbWYBiG7xL2ELYB1ATRbcq58Qve4uO3VElzsmfo/m
         CqUnttnCZmr0rFo/jI7KirQymaNv4zG8ug/XvGN+8No7YB3/6GFymOH/EOoqvkYXa8qQ
         ega5S1cvRD079/w8PPTqgEH9/AZx7MVLWvhKSxKgJ1uC8H/jz3tIA+TdxG0YU5vFmQoj
         TJkQ==
X-Gm-Message-State: ANoB5pmoamdQz6KWtsO40sQAzQcd1bFpZlx+blVAnLaALxJlwKpJbJ5a
        XcmZI5WJK7iWASMd0pxC2Sgnq2KPO5NtcHGpEEYeSMf80/hk49U5nSiOeEKsHXJKQo2EWlCb9bF
        xJgbmjFRfIe8hAkk9
X-Received: by 2002:a05:600c:1c1f:b0:3d1:e4eb:f10b with SMTP id j31-20020a05600c1c1f00b003d1e4ebf10bmr6109372wms.177.1670420043239;
        Wed, 07 Dec 2022 05:34:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4a2MUA3DcA1oUBjxiv78Kg8oZodekc9xEO92gstattJfwaiiWOBsV20RKSEATfQHIGCKb3zg==
X-Received: by 2002:a05:600c:1c1f:b0:3d1:e4eb:f10b with SMTP id j31-20020a05600c1c1f00b003d1e4ebf10bmr6109360wms.177.1670420042894;
        Wed, 07 Dec 2022 05:34:02 -0800 (PST)
Received: from ?IPV6:2003:cb:c702:2500:fe2d:7534:ffa4:c1e5? (p200300cbc7022500fe2d7534ffa4c1e5.dip0.t-ipconnect.de. [2003:cb:c702:2500:fe2d:7534:ffa4:c1e5])
        by smtp.gmail.com with ESMTPSA id m14-20020a5d624e000000b00241dd5de644sm19196977wrv.97.2022.12.07.05.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 05:34:00 -0800 (PST)
Message-ID: <5a626d30-ccc9-6be3-29f7-78f83afbe5c4@redhat.com>
Date:   Wed, 7 Dec 2022 14:33:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20221202122748.113774-1-david@redhat.com> <Y4oo6cN1a4Yz5prh@x1n>
 <690afe0f-c9a0-9631-b365-d11d98fdf56f@redhat.com>
 <19800718-9cb6-9355-da1c-c7961b01e922@redhat.com> <Y45duzmGGUT0+u8t@x1n>
 <92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com> <Y4+zw4JU7JMlDHbM@x1n>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH RFC] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
In-Reply-To: <Y4+zw4JU7JMlDHbM@x1n>
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

On 06.12.22 22:27, Peter Xu wrote:
> On Tue, Dec 06, 2022 at 05:28:07PM +0100, David Hildenbrand wrote:
>>> If no one is using mprotect() with uffd-wp like that, then the reproducer
>>> may not be valid - the reproducer is defining how it should work, but does
>>> that really stand?  That's why I said it's ambiguous, because the
>>> definition in this case is unclear.
>>
>> There are interesting variations like:
>>
>> mmap(PROT_READ, MAP_POPULATE|MAP_SHARED)
>> uffd_wp()
>> mprotect(PROT_READ|PROT_WRITE)
>>
>> Where we start out with all-write permissions before we enable selective
>> write permissions.
> 
> Could you elaborate what's the difference of above comparing to:
> 
> mmap(PROT_READ|PROT_WRITE, MAP_POPULATE|MAP_SHARED)
> uffd_wp()
> 
> ?

That mapping would temporarily allow write access. I'd imagine that 
something like that might be useful when atomically replacing an 
existing mapping (MAP_FIXED), and the VMA might already be in use by 
other threads. or when you really want to catch any possible write access.

For example, libvhost-user.c in QEMU uses for ordinary postcopy:

         /*
          * In postcopy we're using PROT_NONE here to catch anyone
          * accessing it before we userfault.
          */
         mmap_addr = mmap(0, dev_region->size + dev_region->mmap_offset,
                          PROT_NONE, MAP_SHARED | MAP_NORESERVE,
                          vmsg->fds[0], 0);

I'd imagine, when using uffd-wp (VM snapshotting with shmem?) one might 
use PROT_READ instead before the write-protection is properly set. 
Because read access would be fine in the meantime.

But I'm just pulling use cases out of my magic hat ;) Nothing stops user 
space from doing things that are not clearly forbidden (well, even then 
users might complain, but that's a different story).

[...]

>> Case (2) is rather a corner case, and unless people complain about it being
>> a real performance issue, it felt cleaner (less code) to not optimize for
>> that now.
> 
> As I didn't have a closer look on the savedwrite removal patchset so I may
> not speak anything sensible here..  What I hope is that we don't lose write
> bits easily, after all we tried to even safe the dirty and young bits to
> avoid the machine cycles in the MMUs.

Hopefully, someone will complain loudly if that corner case is relevant.

> 
>>
>> Again Peter, I am not against you, not at all. Sorry if I gave you the
>> impression. I highly appreciate your work and this discussion.
> 
> No worry on that part.  You're doing great in this email explaining things
> and write things up, especially I'm happy Hugh confirmed it so it's good to
> have those.  Let's start with something like this when you NAK something
> next time. :)

:)

-- 
Thanks,

David / dhildenb

