Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E6A633771
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 09:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiKVIt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 03:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKVIt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 03:49:56 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3402E6BA;
        Tue, 22 Nov 2022 00:49:55 -0800 (PST)
Received: from [192.168.10.9] (unknown [39.45.241.105])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 25D016602AC7;
        Tue, 22 Nov 2022 08:49:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1669106993;
        bh=gxGtso8urS9v036aECctUY/pCojYIygt2iX8izggUXw=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=SfZh7uKfDZP8QdS1RdFntHBU4FavTmrIg7bhwZqZ/fWrhFjz9HxwMCQ17sqBTvVF1
         TDFftCK4jmC9lLrS055nft6auPajg7/S4NMdDRWQeq43/RWFaGgD6cCSIvvnDH2Y7E
         Pmr4xoJY5iNMuAub45wAocvHqP8UR663357uI3+6jz561STjxdGbYh1IjWketIpDa5
         8beZwWZvQ+eh3a5fA7sOgsrhg3zjDwAbOWzCLDFwdm4VydX4iBLVoSfB6EhDCnkqsx
         I9Qecaz1QTZR5n3Lu314DZaS/dns4rFzHE7mikp04pijSsOMLxc94uWGJynISG2Ydv
         6vQTMtHYJM+og==
Message-ID: <4ebdbc0f-6352-5020-3f74-94e6c3743a1d@collabora.com>
Date:   Tue, 22 Nov 2022 13:49:45 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Mel Gorman <mgorman@suse.de>, Peter Xu <peterx@redhat.com>,
        Andrei Vagin <avagin@gmail.com>, kernel@collabora.com,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: set the vma flags dirty before testing if it is
 mergeable
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
References: <20221122082442.1938606-1-usama.anjum@collabora.com>
 <b1bc82e2-a789-85f4-d428-c5f1b451f4b7@redhat.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <b1bc82e2-a789-85f4-d428-c5f1b451f4b7@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/22/22 1:36 PM, David Hildenbrand wrote:
> On 22.11.22 09:24, Muhammad Usama Anjum wrote:
>> The VM_SOFTDIRTY should be set in the vma flags to be tested if new
>> allocation should be merged in previous vma or not. With this patch,
>> the new allocations are merged in the previous VMAs.
>>
>> I've tested it by reverting the commit 34228d473efe ("mm: ignore
>> VM_SOFTDIRTY on VMA merging") and after adding this following patch,
>> I'm seeing that all the new allocations done through mmap() are merged
>> in the previous VMAs. The number of VMAs doesn't increase drastically
>> which had contributed to the crash of gimp. If I run the same test after
>> reverting and not including this patch, the number of VMAs keep on
>> increasing with every mmap() syscall which proves this patch.
>>
>> The commit 34228d473efe ("mm: ignore VM_SOFTDIRTY on VMA merging")
>> seems like a workaround. But it lets the soft-dirty and non-soft-dirty
>> VMA to get merged. It helps in avoiding the creation of too many VMAs.
>> But it creates the problem while adding the feature of clearing the
>> soft-dirty status of only a part of the memory region.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: d9104d1ca966 ("mm: track vma changes with VM_SOFTDIRTY bit")
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>> ---
>> We need more testing of this patch.
>>
>> While implementing clear soft-dirty bit for a range of address space, I'm
>> facing an issue. The non-soft dirty VMA gets merged sometimes with the soft
>> dirty VMA. Thus the non-soft dirty VMA become dirty which is undesirable.
>> When discussed with the some other developers they consider it the
>> regression. Why the non-soft dirty page should appear as soft dirty when it
>> isn't soft dirty in reality? I agree with them. Should we revert
>> 34228d473efe or find a workaround in the IOCTL?
>>
>> * Revert may cause the VMAs to expand in uncontrollable situation where the
>> soft dirty bit of a lot of memory regions or the whole address space is
>> being cleared again and again. AFAIK normal process must either be only
>> clearing a few memory regions. So the applications should be okay. There is
>> still chance of regressions if some applications are already using the
>> soft-dirty bit. I'm not sure how to test it.
>>
>> * Add a flag in the IOCTL to ignore the dirtiness of VMA. The user will
>> surely lose the functionality to detect reused memory regions. But the
>> extraneous soft-dirty pages would not appear. I'm trying to do this in the
>> patch series [1]. Some discussion is going on that this fails with some
>> mprotect use case [2]. I still need to have a look at the mprotect selftest
>> to see how and why this fails. I think this can be implemented after some
>> more work probably in mprotect side.
>>
>> [1]
>> https://lore.kernel.org/all/20221109102303.851281-1-usama.anjum@collabora.com/
>> [2]
>> https://lore.kernel.org/all/bfcae708-db21-04b4-0bbe-712badd03071@redhat.com/
>> ---
>>   mm/mmap.c | 21 +++++++++++----------
>>   1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index f9b96b387a6f..6934b8f61fdc 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -1708,6 +1708,15 @@ unsigned long mmap_region(struct file *file,
>> unsigned long addr,
>>           vm_flags |= VM_ACCOUNT;
>>       }
>>   +    /*
>> +     * New (or expanded) vma always get soft dirty status.
>> +     * Otherwise user-space soft-dirty page tracker won't
>> +     * be able to distinguish situation when vma area unmapped,
>> +     * then new mapped in-place (which must be aimed as
>> +     * a completely new data area).
>> +     */
>> +    vm_flags |= VM_SOFTDIRTY;
>> +
>>       /*
>>        * Can we just expand an old mapping?
>>        */
>> @@ -1823,15 +1832,6 @@ unsigned long mmap_region(struct file *file,
>> unsigned long addr,
>>       if (file)
>>           uprobe_mmap(vma);
>>   -    /*
>> -     * New (or expanded) vma always get soft dirty status.
>> -     * Otherwise user-space soft-dirty page tracker won't
>> -     * be able to distinguish situation when vma area unmapped,
>> -     * then new mapped in-place (which must be aimed as
>> -     * a completely new data area).
>> -     */
>> -    vma->vm_flags |= VM_SOFTDIRTY;
>> -
>>       vma_set_page_prot(vma);
> 
> vma_set_page_prot(vma) has to be called after adjusting vma->vm_flags.
> 
> Did not look into the details here, but that jumped at me.
vma_set_page_prot() also needs to be removed from here as it was being
called after updating the vm_flags. I'll remove it. vma_set_page_prot() was
added in a separate commit 64e455079e1b. I'll send a v2 in a while.

-- 
BR,
Muhammad Usama Anjum
