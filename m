Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F0563C16F
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 14:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiK2NuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 08:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiK2NuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 08:50:04 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6792A95B;
        Tue, 29 Nov 2022 05:50:03 -0800 (PST)
Received: from [192.168.10.37] (unknown [39.46.73.92])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 4A05F6602B10;
        Tue, 29 Nov 2022 13:49:57 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1669729802;
        bh=F14Rr+LWBBTNw3s/21ZJbAiRSOUPniBH84gNU7DoJIc=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=UMV5NV8V3v3vc2ZnxP8W2nUiVLngiPaZBh4IvHAtPkht+6MFajoM+/t0iamx/dRBj
         Rb3El31yPJiyf/ZwpDz+LSWCE5UQFj0OWCafl9M1RtHpUhaEx+8IJ/58MsWIELGwlk
         Wo19+zOhBGQHky3HRawXYmMCWL/c6KMxV/zwm6INkhUH4ChzVD7biA/hotIyeGsrT+
         QxX/P9aWFM+idJFCJHQpp8FBTjBW04hVy5rYqwkVN1GjXBaYTxL7wzwjXaxrm4X3vU
         8qmTmU0PIdSGYu0vsGQphiv2INgnTR3Xb3FS/SAYIU3BsufrFBDuMv0zHdTLziAXYb
         BZYtNV9Fx33bw==
Message-ID: <ecef5201-04d5-3618-a667-2e7c4770b908@collabora.com>
Date:   Tue, 29 Nov 2022 18:49:53 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Andrei Vagin <avagin@gmail.com>, kernel@collabora.com,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: set the vma flags dirty before testing if it is
 mergeable
To:     Cyrill Gorcunov <gorcunov@gmail.com>
References: <20221122115007.2787017-1-usama.anjum@collabora.com>
 <Y4W0axw0ZgORtfkt@grain>
Content-Language: en-US
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <Y4W0axw0ZgORtfkt@grain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/22 12:27 PM, Cyrill Gorcunov wrote:
> On Tue, Nov 22, 2022 at 04:50:07PM +0500, Muhammad Usama Anjum wrote:
>> The VM_SOFTDIRTY should be set in the vma flags to be tested if new
>> allocation should be merged in previous vma or not. With this patch,
>> the new allocations are merged in the previous VMAs.
> 
> Hi Muhammad! Thanks for the patch and sorry for late reply. Here is a moment
> I don't understand -- when we test for vma merge we use is_mergeable_vma() helper
> which excludes VM_SOFTDIRTY flag from comarision, so setting this flag earlier
> should not change the behaviour. Or I miss something obvious?
Yeah, it doesn't change the behavior until we also revert the 34228d473efe.
is_mergeable_vma() started ignoring VM_SOFTDIRTY flag when every new
allocation was creating a new VMA. So this patch proposes the correct fix
that instead of ignoring the VM_SOFTDIRTY, the newly allocated should be
marked VM_SOFTDIRTY and then is_mergeable_vma() should be called.

> 
>> I've tested it by reverting the commit 34228d473efe ("mm: ignore
>> VM_SOFTDIRTY on VMA merging") and after adding this following patch,
>> I'm seeing that all the new allocations done through mmap() are merged
>> in the previous VMAs. The number of VMAs doesn't increase drastically
>> which had contributed to the crash of gimp. If I run the same test after
>> reverting and not including this patch, the number of VMAs keep on
>> increasing with every mmap() syscall which proves this patch.
> 
> The is_mergeable_vma is key function here, either we should setup VM_SOFTDIRTY
> explicitly as your patch does and drop VM_SOFTDIRTY from is_mergeable_vma,
> or we continue excluding this flag in such low level helper as is.
Agreed.

> 
>> The commit 34228d473efe ("mm: ignore VM_SOFTDIRTY on VMA merging")
>> seems like a workaround. But it lets the soft-dirty and non-soft-dirty
>> VMA to get merged. It helps in avoiding the creation of too many VMAs.
>> But it creates the problem while adding the feature of clearing the
>> soft-dirty status of only a part of the memory region.
> 
> So you need an extended functionality, could you please put this
> changelog snippet somewhere on top? Otherwise srat reading this patch
> I simply didn't get what we're trying to achieve.
I'm referring to the changeset in [1]
(https://lore.kernel.org/all/20221109102303.851281-1-usama.anjum@collabora.com/)
which is trying to add the extended functionality.

>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: d9104d1ca966 ("mm: track vma changes with VM_SOFTDIRTY bit")
> 
> Wait, is there some critical bug or error that needs stable@ to be
> patched? The way softdirty has been implemented in first place is
No there is no bug or any thing. I've added fixes tag considering that the
original patch tracking vma changes was written such that every new
allocated VMA was not being merged in the previous one.

> to reach minimum needs for dirty page tracking. More precise tracking
> (such as partial cleanup of memory region) will require at least other
> structures to remember which part of vma is cleared and which one is
> dirty after their merge. And I don't think this is possible to implement
> without extending vma structure itself (which is big enough already).
We'll have to think about it if I'm unable to make the IOCTL work without
considering VM_SOFTDIRTY.

> 
> Or maybe I'm blind and not see obvious problem here, sorry then :)
> 
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>> ---
>> We need more testing of this patch.
>>
>> While implementing clear soft-dirty bit for a range of address space, I'm
>> facing an issue. The non-soft dirty VMA gets merged sometimes with the soft
>> dirty VMA. Thus the non-soft dirty VMA become dirty which is undesirable.
>>
>> When discussed with the some other developers they consider it the
>> regression. Why the non-soft dirty page should appear as soft dirty when it
>> isn't soft dirty in reality? I agree with them. Should we revert
>> 34228d473efe or find a workaround in the IOCTL?
> 
> Well, this is not the regression, it is been designed this way because
> there is no place to keep subflags on regions covered by one VMA and non
> merging them cause vma fragmentation (I've seen massive vma fragmentations
> especially in db engines). So no, reverting it is not an option but rather
> will cause problems in real applications I fear.
Yeah, makes sense.

> 
>>
>> * Revert may cause the VMAs to expand in uncontrollable situation where the
>> soft dirty bit of a lot of memory regions or the whole address space is
>> being cleared again and again. AFAIK normal process must either be only
>> clearing a few memory regions. So the applications should be okay. There is
>> still chance of regressions if some applications are already using the
>> soft-dirty bit. I'm not sure how to test it.
> 
> Main purpose of this dirty functionality came from containers c/r procedure.
> As far as I remember we've been clearing vmas for the whole container, though
> it's been a while and i'm not involved into c/r development right now so may
> miss something from my memory.
> 
>> * Add a flag in the IOCTL to ignore the dirtiness of VMA. The user will
>> surely lose the functionality to detect reused memory regions. But the
>> extraneous soft-dirty pages would not appear. I'm trying to do this in the
>> patch series [1]. Some discussion is going on that this fails with some
>> mprotect use case [2]. I still need to have a look at the mprotect selftest
>> to see how and why this fails. I think this can be implemented after some
>> more work probably in mprotect side.
> 
> ioctl might be an option indeed
Thank you for supporting this. I'll track down the issue caused by
remapping and mprotect mentioned here:
https://lore.kernel.org/all/bfcae708-db21-04b4-0bbe-712badd03071@redhat.com/
and we can proceed with this.

> 
>>
>> [1] https://lore.kernel.org/all/20221109102303.851281-1-usama.anjum@collabora.com/
>> [2] https://lore.kernel.org/all/bfcae708-db21-04b4-0bbe-712badd03071@redhat.com/

Thank you so much for the review.

-- 
BR,
Muhammad Usama Anjum
