Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081B66C6474
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 11:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCWKJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 06:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCWKJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 06:09:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C261B9
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 03:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679566117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RLBcg29XUCu1+kYYG+PtK55vjaoLFQBbgTgfCZzS4Vs=;
        b=Tzwt3T94YRSE0mRHwH8dfoRumeZVl6LLuEnnZbisCl54aP9rygE2Boxc4NhDRpGcne19TQ
        XSvmRpxRAdLv3dkzVvVNUp2JC7INHk1iJYl8eUdz0aoQZfGhzbutfP4hj7L9ZlvVn05W1t
        kRv/Gp7ZvOo3EPkAf6+FOnqHaoXtqFw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-tcdaA4gAP-m3SRaThI7Wgw-1; Thu, 23 Mar 2023 06:08:36 -0400
X-MC-Unique: tcdaA4gAP-m3SRaThI7Wgw-1
Received: by mail-wm1-f69.google.com with SMTP id m5-20020a05600c4f4500b003ee8db23ef9so588829wmq.8
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 03:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679566115;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RLBcg29XUCu1+kYYG+PtK55vjaoLFQBbgTgfCZzS4Vs=;
        b=M0rt0vyGove3GmgpvtDczamZkgyLVetBfyohFW9FXzEPdhdovfsPWLSA6Vz0gf/iAf
         NjGsuPwgcNm4wBLOrAyuyg4aoP5l7m99D7lzUHZKtVVNTM3XssWUSJkwcMrrlFf8en67
         gbPkxkAow5AP0GMeMdvZG7caV4EsXsjC6HAX9u5gbbf8s+3ZYEklpRGl+uXxN0/YJD46
         HBvQJWPIJeWUL3fQgDJLUQANnn/TBRuTLJNUPer0VvSg3DnCRuYl+aONh5yJie33ZuVO
         uIJfN2oJL3yTzsJjpZ8fz5VyX5fniFaBo6OAABOG0/8r36z0qnq3OIBGok07EjZDRTsI
         DxKw==
X-Gm-Message-State: AO0yUKXx3+Zu43rWQEOk6cp9dIrw3eAuO+jzAhMtrxfxYau6bSx4hIBN
        JpOzp2sj+PgJ9U64sOqEsSeUuonKpuCBb6kaqVIsgflTyvzeTbzla9XFVB12ezx3HmJerkXkghy
        K/UXInXEiOPyc0awY
X-Received: by 2002:a1c:7c18:0:b0:3ed:8bef:6a04 with SMTP id x24-20020a1c7c18000000b003ed8bef6a04mr1883869wmc.27.1679566115196;
        Thu, 23 Mar 2023 03:08:35 -0700 (PDT)
X-Google-Smtp-Source: AK7set9bc21wrJK7xQQoRd4pawnIt9I/cVi1HljMz2Obi1RCPQ6qGXT37FPjPQ9kjIcu56uWiTFHcQ==
X-Received: by 2002:a1c:7c18:0:b0:3ed:8bef:6a04 with SMTP id x24-20020a1c7c18000000b003ed8bef6a04mr1883855wmc.27.1679566114864;
        Thu, 23 Mar 2023 03:08:34 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id be6-20020a05600c1e8600b003e7f1086660sm1415780wmb.15.2023.03.23.03.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 03:08:34 -0700 (PDT)
Message-ID: <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com>
Date:   Thu, 23 Mar 2023 11:08:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>,
        kirill.shutemov@linux.intel.com, jannh@google.com,
        willy@infradead.org, akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220203182641.824731-1-shy828301@gmail.com>
 <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration
 entry
In-Reply-To: <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.03.23 10:52, Vlastimil Babka wrote:
> On 2/3/22 19:26, Yang Shi wrote:
>> The syzbot reported the below BUG:
>>
>> kernel BUG at include/linux/page-flags.h:785!
>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>> CPU: 1 PID: 4392 Comm: syz-executor560 Not tainted 5.16.0-rc6-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
>> RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
>> Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
>> RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
>> RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
>> R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
>> R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
>> FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   <TASK>
>>   page_mapcount include/linux/mm.h:837 [inline]
>>   smaps_account+0x470/0xb10 fs/proc/task_mmu.c:466
>>   smaps_pte_entry fs/proc/task_mmu.c:538 [inline]
>>   smaps_pte_range+0x611/0x1250 fs/proc/task_mmu.c:601
>>   walk_pmd_range mm/pagewalk.c:128 [inline]
>>   walk_pud_range mm/pagewalk.c:205 [inline]
>>   walk_p4d_range mm/pagewalk.c:240 [inline]
>>   walk_pgd_range mm/pagewalk.c:277 [inline]
>>   __walk_page_range+0xe23/0x1ea0 mm/pagewalk.c:379
>>   walk_page_vma+0x277/0x350 mm/pagewalk.c:530
>>   smap_gather_stats.part.0+0x148/0x260 fs/proc/task_mmu.c:768
>>   smap_gather_stats fs/proc/task_mmu.c:741 [inline]
>>   show_smap+0xc6/0x440 fs/proc/task_mmu.c:822
>>   seq_read_iter+0xbb0/0x1240 fs/seq_file.c:272
>>   seq_read+0x3e0/0x5b0 fs/seq_file.c:162
>>   vfs_read+0x1b5/0x600 fs/read_write.c:479
>>   ksys_read+0x12d/0x250 fs/read_write.c:619
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x7faa2af6c969
>> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007faa2aefd288 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>> RAX: ffffffffffffffda RBX: 00007faa2aff4418 RCX: 00007faa2af6c969
>> RDX: 0000000000002025 RSI: 0000000020000100 RDI: 0000000000000003
>> RBP: 00007faa2aff4410 R08: 00007faa2aefd700 R09: 0000000000000000
>> R10: 00007faa2aefd700 R11: 0000000000000246 R12: 00007faa2afc20ac
>> R13: 00007fff7e6632bf R14: 00007faa2aefd400 R15: 0000000000022000
>>   </TASK>
>> Modules linked in:
>> ---[ end trace 24ec93ff95e4ac3d ]---
>> RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
>> RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
>> Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
>> RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
>> RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
>> R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
>> R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
>> FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>
>> The reproducer was trying to reading /proc/$PID/smaps when calling
>> MADV_FREE at the mean time.  MADV_FREE may split THPs if it is called
>> for partial THP.  It may trigger the below race:
>>
>>           CPU A                         CPU B
>>           -----                         -----
>> smaps walk:                      MADV_FREE:
>> page_mapcount()
>>    PageCompound()
>>                                   split_huge_page()
>>    page = compound_head(page)
>>    PageDoubleMap(page)
>>
>> When calling PageDoubleMap() this page is not a tail page of THP anymore
>> so the BUG is triggered.
>>
>> This could be fixed by elevated refcount of the page before calling
>> mapcount, but it prevents from counting migration entries, and it seems
>> overkilling because the race just could happen when PMD is split so all
>> PTE entries of tail pages are actually migration entries, and
>> smaps_account() does treat migration entries as mapcount == 1 as Kirill
>> pointed out.
>>
>> Add a new parameter for smaps_account() to tell this entry is migration
>> entry then skip calling page_mapcount().  Don't skip getting mapcount for
>> device private entries since they do track references with mapcount.
>>
>> Pagemap also has the similar issue although it was not reported.  Fixed
>> it as well.
>>
>> Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
>> Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Yang Shi <shy828301@gmail.com>
>> ---
>> v4: * s/Treated/Treat per David
>>      * Collected acked-by tag from David
>> v3: * Fixed the fix tag, the one used by v2 was not accurate
>>      * Added comment about the risk calling page_mapcount() per David
>>      * Fix pagemap
>> v2: * Added proper fix tag per Jann Horn
>>      * Rebased to the latest linus's tree
>>
>>   fs/proc/task_mmu.c | 38 ++++++++++++++++++++++++++++++--------
>>   1 file changed, 30 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 18f8c3acbb85..bc2f46033231 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -440,7 +440,8 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
>>   }
>>   
>>   static void smaps_account(struct mem_size_stats *mss, struct page *page,
>> -		bool compound, bool young, bool dirty, bool locked)
>> +		bool compound, bool young, bool dirty, bool locked,
>> +		bool migration)
>>   {
>>   	int i, nr = compound ? compound_nr(page) : 1;
>>   	unsigned long size = nr * PAGE_SIZE;
>> @@ -467,8 +468,15 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
>>   	 * page_count(page) == 1 guarantees the page is mapped exactly once.
>>   	 * If any subpage of the compound page mapped with PTE it would elevate
>>   	 * page_count().
>> +	 *
>> +	 * The page_mapcount() is called to get a snapshot of the mapcount.
>> +	 * Without holding the page lock this snapshot can be slightly wrong as
>> +	 * we cannot always read the mapcount atomically.  It is not safe to
>> +	 * call page_mapcount() even with PTL held if the page is not mapped,
>> +	 * especially for migration entries.  Treat regular migration entries
>> +	 * as mapcount == 1.
>>   	 */
>> -	if (page_count(page) == 1) {
>> +	if ((page_count(page) == 1) || migration) {
> 
> Since this is now apparently a CVE-2023-1582 for whatever RHeasons...
> 
> wonder if the patch actually works as intended when
> (page_count() || migration) is in this particular order and not the other one?

Only the page_mapcount() call to a page that should be problematic, not 
the page_count() call. There might be the rare chance of the page 
getting remove due to memory offlining... but we're still holding the 
page table lock with the migration entry, so we should be protected 
against that.

Regarding the CVE, IIUC the main reason for the CVE should be 
RHEL-specific -- which behaves differently than other code bases; for 
other code bases, it's just a way to trigger a BUG_ON as described here.

-- 
Thanks,

David / dhildenb

