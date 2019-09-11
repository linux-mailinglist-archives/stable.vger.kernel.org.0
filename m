Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8B48AFC45
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 14:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfIKMKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 08:10:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:60261 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfIKMKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 08:10:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 05:10:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,493,1559545200"; 
   d="scan'208";a="185802869"
Received: from avrahamr-mobl1.ger.corp.intel.com (HELO [10.252.3.203]) ([10.252.3.203])
  by fmsmga007.fm.intel.com with ESMTP; 11 Sep 2019 05:10:53 -0700
Subject: Re: [Intel-gfx] [PATCH 1/5] drm/i915/userptr: Beware recursive
 lock_page()
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20190716124931.5870-1-chris@chris-wilson.co.uk>
 <156336944635.4375.7269371478914847980@skylake-alporthouse-com>
 <6038b21f-c052-36c5-2d56-72ddeb069097@linux.intel.com>
 <156337053617.4375.13675276970408492219@skylake-alporthouse-com>
 <951e2751-15d7-9ca8-ef6f-299ba59c47a6@linux.intel.com>
 <156337241401.4375.2377981562987470090@skylake-alporthouse-com>
 <d867c0e8-e2e1-fff6-d073-3d5d98335712@linux.intel.com>
 <4a90e8f9-694c-8dea-45b6-e5ea5677df64@intel.com>
 <156803716592.27961.18000112287811684297@skylake-alporthouse-com>
 <90d744ec-17ac-b8d1-e9c0-d34c16adcd4f@linux.intel.com>
 <156820191991.2643.4682362430205149096@skylake-alporthouse-com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <eeb4eda8-aa0d-bbae-16cc-4849bac28026@linux.intel.com>
Date:   Wed, 11 Sep 2019 13:10:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156820191991.2643.4682362430205149096@skylake-alporthouse-com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/09/2019 12:38, Chris Wilson wrote:
> Quoting Tvrtko Ursulin (2019-09-11 12:31:32)
>>
>> On 09/09/2019 14:52, Chris Wilson wrote:
>>> Quoting Lionel Landwerlin (2019-07-26 14:38:40)
>>>> On 17/07/2019 21:09, Tvrtko Ursulin wrote:
>>>>>
>>>>> On 17/07/2019 15:06, Chris Wilson wrote:
>>>>>> Quoting Tvrtko Ursulin (2019-07-17 14:46:15)
>>>>>>>
>>>>>>> On 17/07/2019 14:35, Chris Wilson wrote:
>>>>>>>> Quoting Tvrtko Ursulin (2019-07-17 14:23:55)
>>>>>>>>>
>>>>>>>>> On 17/07/2019 14:17, Chris Wilson wrote:
>>>>>>>>>> Quoting Tvrtko Ursulin (2019-07-17 14:09:00)
>>>>>>>>>>>
>>>>>>>>>>> On 16/07/2019 16:37, Chris Wilson wrote:
>>>>>>>>>>>> Quoting Tvrtko Ursulin (2019-07-16 16:25:22)
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 16/07/2019 13:49, Chris Wilson wrote:
>>>>>>>>>>>>>> Following a try_to_unmap() we may want to remove the userptr
>>>>>>>>>>>>>> and so call
>>>>>>>>>>>>>> put_pages(). However, try_to_unmap() acquires the page lock
>>>>>>>>>>>>>> and so we
>>>>>>>>>>>>>> must avoid recursively locking the pages ourselves -- which
>>>>>>>>>>>>>> means that
>>>>>>>>>>>>>> we cannot safely acquire the lock around set_page_dirty().
>>>>>>>>>>>>>> Since we
>>>>>>>>>>>>>> can't be sure of the lock, we have to risk skip dirtying the
>>>>>>>>>>>>>> page, or
>>>>>>>>>>>>>> else risk calling set_page_dirty() without a lock and so risk fs
>>>>>>>>>>>>>> corruption.
>>>>>>>>>>>>>
>>>>>>>>>>>>> So if trylock randomly fail we get data corruption in whatever
>>>>>>>>>>>>> data set
>>>>>>>>>>>>> application is working on, which is what the original patch
>>>>>>>>>>>>> was trying
>>>>>>>>>>>>> to avoid? Are we able to detect the backing store type so at
>>>>>>>>>>>>> least we
>>>>>>>>>>>>> don't risk skipping set_page_dirty with anonymous/shmemfs?
>>>>>>>>>>>>
>>>>>>>>>>>> page->mapping???
>>>>>>>>>>>
>>>>>>>>>>> Would page->mapping work? What is it telling us?
>>>>>>>>>>
>>>>>>>>>> It basically tells us if there is a fs around; anything that is
>>>>>>>>>> the most
>>>>>>>>>> basic of malloc (even tmpfs/shmemfs has page->mapping).
>>>>>>>>>
>>>>>>>>> Normal malloc so anonymous pages? Or you meant everything _apart_
>>>>>>>>> from
>>>>>>>>> the most basic malloc?
>>>>>>>>
>>>>>>>> Aye missed the not.
>>>>>>>>
>>>>>>>>>>>> We still have the issue that if there is a mapping we should be
>>>>>>>>>>>> taking
>>>>>>>>>>>> the lock, and we may have both a mapping and be inside
>>>>>>>>>>>> try_to_unmap().
>>>>>>>>>>>
>>>>>>>>>>> Is this a problem? On a path with mappings we trylock and so
>>>>>>>>>>> solve the
>>>>>>>>>>> set_dirty_locked and recursive deadlock issues, and with no
>>>>>>>>>>> mappings
>>>>>>>>>>> with always dirty the page and avoid data corruption.
>>>>>>>>>>
>>>>>>>>>> The problem as I see it is !page->mapping are likely an
>>>>>>>>>> insignificant
>>>>>>>>>> minority of userptr; as I think even memfd are essentially
>>>>>>>>>> shmemfs (or
>>>>>>>>>> hugetlbfs) and so have mappings.
>>>>>>>>>
>>>>>>>>> Better then nothing, no? If easy to do..
>>>>>>>>
>>>>>>>> Actually, I erring on the opposite side. Peeking at mm/ internals does
>>>>>>>> not bode confidence and feels indefensible. I'd much rather throw my
>>>>>>>> hands up and say "this is the best we can do with the API provided,
>>>>>>>> please tell us what we should have done." To which the answer is
>>>>>>>> probably to not have used gup in the first place :|
>>>>>>>
>>>>>>> """
>>>>>>> /*
>>>>>>>     * set_page_dirty() is racy if the caller has no reference against
>>>>>>>     * page->mapping->host, and if the page is unlocked. This is
>>>>>>> because another
>>>>>>>     * CPU could truncate the page off the mapping and then free the
>>>>>>> mapping.
>>>>>>>     *
>>>>>>>     * Usually, the page _is_ locked, or the caller is a user-space
>>>>>>> process which
>>>>>>>     * holds a reference on the inode by having an open file.
>>>>>>>     *
>>>>>>>     * In other cases, the page should be locked before running
>>>>>>> set_page_dirty().
>>>>>>>     */
>>>>>>> int set_page_dirty_lock(struct page *page)
>>>>>>> """
>>>>>>>
>>>>>>> Could we hold a reference to page->mapping->host while having pages
>>>>>>> and then would be okay to call plain set_page_dirty?
>>>>>>
>>>>>> We would then be hitting the warnings in ext4 for unlocked pages again.
>>>>>
>>>>> Ah true..
>>>>>
>>>>>> Essentially the argument is whether or not that warn is valid, to
>>>>>> which I
>>>>>> think requires inner knowledge of vfs + ext4. To hold a reference on the
>>>>>> host would require us tracking page->mapping (reasonable since we
>>>>>> already hooked into mmu and so will get an invalidate + fresh gup on
>>>>>> any changes), plus iterating over all to acquire the extra reference if
>>>>>> applicable -- and I have no idea what the side-effects of that would be.
>>>>>> Could well be positive side-effects. Just feels like wandering even
>>>>>> further off the beaten path without a map. Good news hmm is just around
>>>>>> the corner (which will probably prohibit this use-case) :|
>>>>>
>>>>> ... can we reach out to someone more knowledgeable in mm matters to
>>>>> recommend us what to do?
>>>>>
>>>>> Regards,
>>>>>
>>>>> Tvrtko
>>>>
>>>>
>>>> Just a reminder to not let this slip.
>>>> We run into userptr bugs in CI quite regularly.
>>>
>>> Remind away. Revert or trylock, there doesn't seem to be a good answer.
>>
>> Rock and a hard place. Data corruption for userptr users (with either
>> trylock or no lock) or a deadlock (with the lock). I honestly can't
>> decide what is worse. Tiny preference to deadlock rather than silent
>> corruption. Misguided? Don't know really..
> 
> The deadlock is pretty easy to hit as soon as the system is under
> mempressure and it tries to free pages as we do the userptr gup...
> (Hah, easy in theory, but not in CI.)

I know what's the answer! Push the policy to userspace! :D

echo 1 > /sys/class/drm/card0/userptr_corrupt_or_deadlock

Am I joking or not? Wish I knew! :)

Regards,

Tvrtko
