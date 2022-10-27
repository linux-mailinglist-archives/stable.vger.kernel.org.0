Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E0160F195
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 09:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbiJ0HyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 03:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiJ0HyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 03:54:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9593F1366B2
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 00:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666857245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J4kFI9ljKvGRq/5EreHjE5KW/a0OUIte2+2j8nIpgbs=;
        b=YavaMFVWH5hWzrquud5TZQfOADpg+Qwqcrwy1psSLwm1+ydPshEhB7RxKKlUIFQP+1NOy3
        mA0TIbJL9DaV5aQkLEpnvuHWuUgjdLvagHaipvsBiyYebsf8FHZEroHAy39fdi7ra5BfXS
        D+GjapvKoI06AQ4IC9jeXhUPVoxxGRM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-369-J-gP7BagNVSkmJr02TboPA-1; Thu, 27 Oct 2022 03:54:04 -0400
X-MC-Unique: J-gP7BagNVSkmJr02TboPA-1
Received: by mail-wr1-f70.google.com with SMTP id o13-20020adfa10d000000b00232c00377a0so120047wro.13
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 00:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J4kFI9ljKvGRq/5EreHjE5KW/a0OUIte2+2j8nIpgbs=;
        b=DBunaVB2SZzj7h118HGm2FZSD+krrEhcI6kL03ND+YwD3g9UEGtVGnqyWgOh1clvg3
         nMNaroRXOv5JYqZ52FicfDeR9BpGSSlxVc8hu0pdXLJkQ2NaOEdUtCALhgZBQMHHjnYM
         b1h+UCK8LujZ1rAISz/UQq70RRq6xKtTxUklR7lLAtj/N41pHOUyi0I2JYciFbTjee1i
         MLegQRfvYwdOvQYNuCn8BaOimgA5phMi8A+dbhUaSJMIL6aTCasAiEo5xpOgJ6GR0v/m
         rthHmmJxvaRbCd+Ve0v3J+hdev1uVlLhxrDPl9lXoUbGf6PwQTZVaxGPe+o7fOXfUL38
         T8+A==
X-Gm-Message-State: ACrzQf3QuJe1JyjURBgRnvl/nPSUow6oqbZZiIy2mCJAZb9R/OcpjAxT
        eUC08rLnjZqUMmSjnxkhyol+MPjwLYoM9eqLABUqm+yahM1dj7TE5ZPjSftWb5H3j1nFBgpvaX0
        AxMxjXuc6TVne9t+I
X-Received: by 2002:a05:600c:4f0f:b0:3ca:31ba:d77c with SMTP id l15-20020a05600c4f0f00b003ca31bad77cmr4967219wmq.36.1666857242916;
        Thu, 27 Oct 2022 00:54:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6dI3DpN4Kweq/8memP9hjDjT+gLVLUBb4naVMjs3gsZ7eCPmVgsWIspcBcvAK3cQV6zqfhZg==
X-Received: by 2002:a05:600c:4f0f:b0:3ca:31ba:d77c with SMTP id l15-20020a05600c4f0f00b003ca31bad77cmr4967192wmq.36.1666857242521;
        Thu, 27 Oct 2022 00:54:02 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:1400:56d0:60d4:f71c:2091? (p200300cbc707140056d060d4f71c2091.dip0.t-ipconnect.de. [2003:cb:c707:1400:56d0:60d4:f71c:2091])
        by smtp.gmail.com with ESMTPSA id t6-20020a5d6906000000b00231ed902a4esm520983wru.5.2022.10.27.00.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 00:54:02 -0700 (PDT)
Message-ID: <9ffe3cbf-98bb-f958-9c80-547ec217c32f@redhat.com>
Date:   Thu, 27 Oct 2022 09:54:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
To:     Hugh Dickins <hughd@google.com>,
        Yuanzheng Song <songyuanzheng@huawei.com>
Cc:     akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        peterx@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221024094911.3054769-1-songyuanzheng@huawei.com>
 <3823471f-6dda-256e-e082-718879c05449@google.com>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH STABLE 5.10] mm/memory: add non-anonymous page check in
 the copy_present_page()
In-Reply-To: <3823471f-6dda-256e-e082-718879c05449@google.com>
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

On 26.10.22 23:51, Hugh Dickins wrote:
> On Mon, 24 Oct 2022, Yuanzheng Song wrote:
> 
>> The vma->anon_vma of the child process may be NULL because
>> the entire vma does not contain anonymous pages. In this
>> case, a BUG will occur when the copy_present_page() passes
>> a copy of a non-anonymous page of that vma to the
>> page_add_new_anon_rmap() to set up new anonymous rmap.
>>
>> ------------[ cut here ]------------
>> kernel BUG at mm/rmap.c:1044!
>> Internal error: Oops - BUG: 0 [#1] SMP
>> Modules linked in:
>> CPU: 2 PID: 3617 Comm: test Not tainted 5.10.149 #1
>> Hardware name: linux,dummy-virt (DT)
>> pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
>> pc : __page_set_anon_rmap+0xbc/0xf8
>> lr : __page_set_anon_rmap+0xbc/0xf8
>> sp : ffff800014c1b870
>> x29: ffff800014c1b870 x28: 0000000000000001
>> x27: 0000000010100073 x26: ffff1d65c517baa8
>> x25: ffff1d65cab0f000 x24: ffff1d65c416d800
>> x23: ffff1d65cab5f248 x22: 0000000020000000
>> x21: 0000000000000001 x20: 0000000000000000
>> x19: fffffe75970023c0 x18: 0000000000000000
>> x17: 0000000000000000 x16: 0000000000000000
>> x15: 0000000000000000 x14: 0000000000000000
>> x13: 0000000000000000 x12: 0000000000000000
>> x11: 0000000000000000 x10: 0000000000000000
>> x9 : ffffc3096d5fb858 x8 : 0000000000000000
>> x7 : 0000000000000011 x6 : ffff5a5c9089c000
>> x5 : 0000000000020000 x4 : ffff5a5c9089c000
>> x3 : ffffc3096d200000 x2 : ffffc3096e8d0000
>> x1 : ffff1d65ca3da740 x0 : 0000000000000000
>> Call trace:
>>   __page_set_anon_rmap+0xbc/0xf8
>>   page_add_new_anon_rmap+0x1e0/0x390
>>   copy_pte_range+0xd00/0x1248
>>   copy_page_range+0x39c/0x620
>>   dup_mmap+0x2e0/0x5a8
>>   dup_mm+0x78/0x140
>>   copy_process+0x918/0x1a20
>>   kernel_clone+0xac/0x638
>>   __do_sys_clone+0x78/0xb0
>>   __arm64_sys_clone+0x30/0x40
>>   el0_svc_common.constprop.0+0xb0/0x308
>>   do_el0_svc+0x48/0xb8
>>   el0_svc+0x24/0x38
>>   el0_sync_handler+0x160/0x168
>>   el0_sync+0x180/0x1c0
>> Code: 97f8ff85 f9400294 17ffffeb 97f8ff82 (d4210000)
>> ---[ end trace a972347688dc9bd4 ]---
>> Kernel panic - not syncing: Oops - BUG: Fatal exception
>> SMP: stopping secondary CPUs
>> Kernel Offset: 0x43095d200000 from 0xffff800010000000
>> PHYS_OFFSET: 0xffffe29a80000000
>> CPU features: 0x08200022,61806082
>> Memory Limit: none
>> ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---
>>
>> This problem has been fixed by the fb3d824d1a46
>> ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()"),
>> but still exists in the linux-5.10.y branch.
>>
>> This patch is not applicable to this version because
>> of the large version differences. Therefore, fix it by
>> adding non-anonymous page check in the copy_present_page().
>>
>> Fixes: 70e806e4e645 ("mm: Do early cow for pinned pages during fork() for ptes")
>> Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
> 
> It's a good point, but this patch should not go into any stable release
> without an explicit Ack from either Peter Xu or David Hildenbrand.
> 
> To my eye, it's simply avoiding the issue, rather than fixing
> it properly; and even if the issue is so rare, and fixing properly
> too difficult or inefficent (a cached anon_vma?), that a workaround
> is good enough, it still looks like the wrong workaround (checking
> dst_vma->anon_vma instead of PageAnon seems more to the point, and
> less lenient).
> 
> But my eye on COW is very poor nowadays, and I may be plain wrong.

I am not aware of any reason for copying a !anon page during fork(). COW 
regrading fork() is all about sharing private (anon) pages between the 
parent and the child. The semantics of other pages are untouched.


Yes, I am working on reliable longterm R/O pinning improvements, whereby 
we never pin such pages in a MAP_PRIVATE mapping but instead break COW 
before pinning; but this only applies to longterm pinning 
(FOLL_LONGTERM) and is independent of fork() here.


Let me elaborate: if you have a pagecache page (or the shared zeropage) 
in a MAP_PRIVATE mapping pinned R/O, the next write fault will replace 
the page by a copy, *independent* of fork() or not: the page is already 
mapped write-protected into the page table.


IIUC, the problem here is that we have a writable private mapping (COW 
mapping) of, say, a file, whereby we never had to COW -- so no anon 
pages were mapped.

Then, we had the process pin some page (&src_mm->has_pinned) once and 
detect a pagecache page / shared zeropage as "maybe pinned" during 
fork(), which can happen easily, for example, due to other process' 
action, false positives, ... we end up duplicating a !anon page.

Restricting copying during fork() to anon pages is IMHO the right thing 
to do.

-- 
Thanks,

David / dhildenb

