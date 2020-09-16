Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C70E26C900
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgIPTCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 15:02:06 -0400
Received: from linux.microsoft.com ([13.77.154.182]:42102 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgIPTCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 15:02:04 -0400
Received: from [192.168.0.121] (unknown [209.134.121.133])
        by linux.microsoft.com (Postfix) with ESMTPSA id C893820B7178;
        Wed, 16 Sep 2020 12:02:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C893820B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1600282922;
        bh=GJZCIFFbV+G3fGXxdDrAP4Tr8M8bZGG2RDqHfdqx+bM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=JNRW4+Xkd/YPU2ClS8TSZ2up2ik/1McVBujsi5MiGh3mlaE3LQgHdFqUCftKKzMmv
         NCR1Xby4buUMKQt3LPJX7F6FiLROzU2mKtAEMw4ht5YTpKBZkV81/FnRO/fOXjRxQC
         xBIJG0l7Rwmk7l9g8a6yIFevlkeHbG2K23R8Bf2w=
Subject: Re: +
 mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch
 added to -mm tree
To:     Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songliubraving@fb.com, pasha.tatashin@soleen.com, oleg@redhat.com,
        kirill.shutemov@linux.intel.com, apais@microsoft.com,
        aarcange@redhat.com
References: <20200916000948.N0vvr%akpm@linux-foundation.org>
 <20200916073345.GC18998@dhcp22.suse.cz>
From:   Vijay Balakrishna <vijayb@linux.microsoft.com>
Message-ID: <24a3b0e1-f0a6-c0b1-2fc4-a1ca6248858f@linux.microsoft.com>
Date:   Wed, 16 Sep 2020 12:02:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200916073345.GC18998@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/16/2020 12:33 AM, Michal Hocko wrote:
> On Tue 15-09-20 17:09:48, Andrew Morton wrote:
>> From: Vijay Balakrishna <vijayb@linux.microsoft.com>
>> Subject: mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged
>>
>> When memory is hotplug added or removed the min_free_kbytes must be
>> recalculated based on what is expected by khugepaged.  Currently after
>> hotplug, min_free_kbytes will be set to a lower default and higher default
>> set when THP enabled is lost.  This leaves the system with small
>> min_free_kbytes which isn't suitable for systems especially with network
>> intensive loads.  Typical failure symptoms include HW WATCHDOG reset, soft
>> lockup hang notices, NETDEVICE WATCHDOG timeouts, and OOM process kills.
>>
>> Link: https://lkml.kernel.org/r/1600204258-13683-1-git-send-email-vijayb@linux.microsoft.com
>> Fixes: f000565adb77 ("thp: set recommended min free kbytes")
>> Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
>> Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
>> Cc: Allen Pais <apais@microsoft.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> Cc: Song Liu <songliubraving@fb.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> The patch has been explicitly nacked by Kirill IIRC. I am also not happy
> about it because the changelog doesn't really explain the problem and
> the follow up discussion didn't drill down to the underlying problem
> either.
> 
> Maybe we want to make the min_free_kbytes udpate consistent with the
> boot but the current changelog is incomplete and this shouldn't have
> been added yet.

Let me modify changelog to remove references symptoms mentioned.

Thanks,
Vijay

> 
>> ---
>>
>>   include/linux/khugepaged.h |    5 +++++
>>   mm/khugepaged.c            |   13 +++++++++++--
>>   mm/memory_hotplug.c        |    3 +++
>>   3 files changed, 19 insertions(+), 2 deletions(-)
>>
>> --- a/include/linux/khugepaged.h~mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged
>> +++ a/include/linux/khugepaged.h
>> @@ -15,6 +15,7 @@ extern int __khugepaged_enter(struct mm_
>>   extern void __khugepaged_exit(struct mm_struct *mm);
>>   extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
>>   				      unsigned long vm_flags);
>> +extern void khugepaged_min_free_kbytes_update(void);
>>   #ifdef CONFIG_SHMEM
>>   extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr);
>>   #else
>> @@ -85,6 +86,10 @@ static inline void collapse_pte_mapped_t
>>   					   unsigned long addr)
>>   {
>>   }
>> +
>> +static inline void khugepaged_min_free_kbytes_update(void)
>> +{
>> +}
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>   
>>   #endif /* _LINUX_KHUGEPAGED_H */
>> --- a/mm/khugepaged.c~mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged
>> +++ a/mm/khugepaged.c
>> @@ -56,6 +56,9 @@ enum scan_result {
>>   #define CREATE_TRACE_POINTS
>>   #include <trace/events/huge_memory.h>
>>   
>> +static struct task_struct *khugepaged_thread __read_mostly;
>> +static DEFINE_MUTEX(khugepaged_mutex);
>> +
>>   /* default scan 8*512 pte (or vmas) every 30 second */
>>   static unsigned int khugepaged_pages_to_scan __read_mostly;
>>   static unsigned int khugepaged_pages_collapsed;
>> @@ -2292,8 +2295,6 @@ static void set_recommended_min_free_kby
>>   
>>   int start_stop_khugepaged(void)
>>   {
>> -	static struct task_struct *khugepaged_thread __read_mostly;
>> -	static DEFINE_MUTEX(khugepaged_mutex);
>>   	int err = 0;
>>   
>>   	mutex_lock(&khugepaged_mutex);
>> @@ -2320,3 +2321,11 @@ fail:
>>   	mutex_unlock(&khugepaged_mutex);
>>   	return err;
>>   }
>> +
>> +void khugepaged_min_free_kbytes_update(void)
>> +{
>> +	mutex_lock(&khugepaged_mutex);
>> +	if (khugepaged_enabled() && khugepaged_thread)
>> +		set_recommended_min_free_kbytes();
>> +	mutex_unlock(&khugepaged_mutex);
>> +}
>> --- a/mm/memory_hotplug.c~mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged
>> +++ a/mm/memory_hotplug.c
>> @@ -36,6 +36,7 @@
>>   #include <linux/memblock.h>
>>   #include <linux/compaction.h>
>>   #include <linux/rmap.h>
>> +#include <linux/khugepaged.h>
>>   
>>   #include <asm/tlbflush.h>
>>   
>> @@ -857,6 +858,7 @@ int __ref online_pages(unsigned long pfn
>>   	zone_pcp_update(zone);
>>   
>>   	init_per_zone_wmark_min();
>> +	khugepaged_min_free_kbytes_update();
>>   
>>   	kswapd_run(nid);
>>   	kcompactd_run(nid);
>> @@ -1614,6 +1616,7 @@ static int __ref __offline_pages(unsigne
>>   	pgdat_resize_unlock(zone->zone_pgdat, &flags);
>>   
>>   	init_per_zone_wmark_min();
>> +	khugepaged_min_free_kbytes_update();
>>   
>>   	if (!populated_zone(zone)) {
>>   		zone_pcp_reset(zone);
>> _
>>
>> Patches currently in -mm which might be from vijayb@linux.microsoft.com are
>>
>> mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch
>> mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch
> 
