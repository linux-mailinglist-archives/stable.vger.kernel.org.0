Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB3516887
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfEGQ6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbfEGQ6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 12:58:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AC28205C9;
        Tue,  7 May 2019 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557248281;
        bh=k0O6Zge2oYkJ/odPfWebdw/rC3Kt7k/XfPt85IyTuts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bxzD848w88aw9JlTkU1D/e4kM4RgnsvgrixKzJEpThPfyJCTdJ4fmEddixgchjZIv
         vJWsZ5ifLdYumEveNY7R7AK1YEVaPkjXKhwiP30AfFTWrrahCBv8ka1FCwffkp6/ef
         cM0tDcxxsP38LUAmlv8pQmg5aeclviHWWtHqKMH0=
Date:   Tue, 7 May 2019 12:58:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct
 pages for the full memory section
Message-ID: <20190507165800.GE1747@sasha-vm>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-62-sashal@kernel.org>
 <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 09:31:10AM -0700, Alexander Duyck wrote:
>On Mon, May 6, 2019 at 10:40 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>>
>> [ Upstream commit 2830bf6f05fb3e05bc4743274b806c821807a684 ]
>>
>> If memory end is not aligned with the sparse memory section boundary,
>> the mapping of such a section is only partly initialized.  This may lead
>> to VM_BUG_ON due to uninitialized struct page access from
>> is_mem_section_removable() or test_pages_in_a_zone() function triggered
>> by memory_hotplug sysfs handlers:
>>
>> Here are the the panic examples:
>>  CONFIG_DEBUG_VM=y
>>  CONFIG_DEBUG_VM_PGFLAGS=y
>>
>>  kernel parameter mem=2050M
>>  --------------------------
>>  page:000003d082008000 is uninitialized and poisoned
>>  page dumped because: VM_BUG_ON_PAGE(PagePoisoned(p))
>>  Call Trace:
>>  ( test_pages_in_a_zone+0xde/0x160)
>>    show_valid_zones+0x5c/0x190
>>    dev_attr_show+0x34/0x70
>>    sysfs_kf_seq_show+0xc8/0x148
>>    seq_read+0x204/0x480
>>    __vfs_read+0x32/0x178
>>    vfs_read+0x82/0x138
>>    ksys_read+0x5a/0xb0
>>    system_call+0xdc/0x2d8
>>  Last Breaking-Event-Address:
>>    test_pages_in_a_zone+0xde/0x160
>>  Kernel panic - not syncing: Fatal exception: panic_on_oops
>>
>>  kernel parameter mem=3075M
>>  --------------------------
>>  page:000003d08300c000 is uninitialized and poisoned
>>  page dumped because: VM_BUG_ON_PAGE(PagePoisoned(p))
>>  Call Trace:
>>  ( is_mem_section_removable+0xb4/0x190)
>>    show_mem_removable+0x9a/0xd8
>>    dev_attr_show+0x34/0x70
>>    sysfs_kf_seq_show+0xc8/0x148
>>    seq_read+0x204/0x480
>>    __vfs_read+0x32/0x178
>>    vfs_read+0x82/0x138
>>    ksys_read+0x5a/0xb0
>>    system_call+0xdc/0x2d8
>>  Last Breaking-Event-Address:
>>    is_mem_section_removable+0xb4/0x190
>>  Kernel panic - not syncing: Fatal exception: panic_on_oops
>>
>> Fix the problem by initializing the last memory section of each zone in
>> memmap_init_zone() till the very end, even if it goes beyond the zone end.
>>
>> Michal said:
>>
>> : This has alwways been problem AFAIU.  It just went unnoticed because we
>> : have zeroed memmaps during allocation before f7f99100d8d9 ("mm: stop
>> : zeroing memory during allocation in vmemmap") and so the above test
>> : would simply skip these ranges as belonging to zone 0 or provided a
>> : garbage.
>> :
>> : So I guess we do care for post f7f99100d8d9 kernels mostly and
>> : therefore Fixes: f7f99100d8d9 ("mm: stop zeroing memory during
>> : allocation in vmemmap")
>>
>> Link: http://lkml.kernel.org/r/20181212172712.34019-2-zaslonko@linux.ibm.com
>> Fixes: f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemmap")
>> Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>> Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
>> Suggested-by: Michal Hocko <mhocko@kernel.org>
>> Acked-by: Michal Hocko <mhocko@suse.com>
>> Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
>> Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
>> Cc: Dave Hansen <dave.hansen@intel.com>
>> Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>> Cc: Pasha Tatashin <Pavel.Tatashin@microsoft.com>
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
>> ---
>>  mm/page_alloc.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>
>Wasn't this patch reverted in Linus's tree for causing a regression on
>some platforms? If so I'm not sure we should pull this in as a
>candidate for stable should we, or am I missing something?

I saw a follow-up patch that should be queued too, but I didn't see that
this one got reverted.

--
Thanks,
Sasha
