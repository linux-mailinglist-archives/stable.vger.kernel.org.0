Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9562102263
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 11:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfKSK5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 05:57:14 -0500
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:42508
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbfKSK5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 05:57:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574161033;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=xfDtV50w7tZiUC3kp+koTJ74nvTkxuOuaJRy67IFzAQ=;
        b=cb086TmMPc4zbmS11My0oSHkx/EVr6X3IXSvQOuURw2o63/IpP9wc/lWBEKe/AEG
        VjrflqjrlhobS4qqdYOkdElp768bl5vN/sN3bkX3ed+cepXUYgKhfC4k+x+ADaSGOL3
        vjNfp2lIqJ3bJbCKOalDixQnFyH340yn1PXW619M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574161033;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=xfDtV50w7tZiUC3kp+koTJ74nvTkxuOuaJRy67IFzAQ=;
        b=Ad2DReIuIUhNfwJ30p7lhAoDqG+6WOkmyn5OAfrk8m8cz+M42LfXiZ/PMdqLrfhu
        EhHCgZDk1VscXLSsrsruCuuebtn2Nv8V1I1d0r4mL033ySzuahJC0HvB8xP3doJMMhg
        lMZyjVdKxy5BSID9pIqXZNcyu9Oudjcj+eX5zlA8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EEA28C447A0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=vinmenon@codeaurora.org
Subject: Re: FAILED: patch "[PATCH] mm/page_io.c: do not free shared swap
 slots" failed to apply to 4.19-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>, akpm@linux-foundation.org,
        hughd@google.com, mhocko@suse.com, minchan@google.com,
        minchan@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
References: <1574095036140231@kroah.com> <20191118164038.GA595410@kroah.com>
From:   Vinayak Menon <vinmenon@codeaurora.org>
Message-ID: <0101016e834f2833-62565910-1153-4759-bed3-4779158dc514-000000@us-west-2.amazonses.com>
Date:   Tue, 19 Nov 2019 10:57:13 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191118164038.GA595410@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-SES-Outgoing: 2019.11.19-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/18/2019 10:10 PM, Greg KH wrote:
> On Mon, Nov 18, 2019 at 05:37:16PM +0100, gregkh@linuxfoundation.org wrote:
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> Note, this applies, but just breaks the build, so it needs a backport
> for 4.19 if people want to see it there.

The version below fixes the build on 4.19.

>
> thanks,
>
> greg k-h

From 3745cc4bb5cddbc1058889e4f779492060d5e550 Mon Sep 17 00:00:00 2001
From: Vinayak Menon <vinmenon@codeaurora.org>
Date: Fri, 15 Nov 2019 17:35:00 -0800
Subject: [PATCH] mm/page_io.c: do not free shared swap slots

commit 5df373e95689b9519b8557da7c5bd0db0856d776 upstream.

The following race is observed due to which a processes faulting on a
swap entry, finds the page neither in swapcache nor swap.  This causes
zram to give a zero filled page that gets mapped to the process,
resulting in a user space crash later.

Consider parent and child processes Pa and Pb sharing the same swap slot
with swap_count 2.  Swap is on zram with SWP_SYNCHRONOUS_IO set.
Virtual address 'VA' of Pa and Pb points to the shared swap entry.

Pa                                       Pb

fault on VA                              fault on VA
do_swap_page                             do_swap_page
lookup_swap_cache fails                  lookup_swap_cache fails
                                         Pb scheduled out
swapin_readahead (deletes zram entry)
swap_free (makes swap_count 1)
                                         Pb scheduled in
                                         swap_readpage (swap_count == 1)
                                         Takes SWP_SYNCHRONOUS_IO path
                                         zram enrty absent
                                         zram gives a zero filled page

Fix this by making sure that swap slot is freed only when swap count
drops down to one.

Link: http://lkml.kernel.org/r/1571743294-14285-1-git-send-email-vinmenon@codeaurora.org
Fixes: aa8d22a11da9 ("mm: swap: SWP_SYNCHRONOUS_IO: skip swapcache only if swapped page has no other reference")
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Suggested-by: Minchan Kim <minchan@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_io.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index abc1466..e763047 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -77,6 +77,7 @@ static void swap_slot_free_notify(struct page *page)
 {
        struct swap_info_struct *sis;
        struct gendisk *disk;
+       swp_entry_t entry;

        /*
         * There is no guarantee that the page is in swap cache - the software
@@ -108,11 +109,11 @@ static void swap_slot_free_notify(struct page *page)
         * we again wish to reclaim it.
         */
        disk = sis->bdev->bd_disk;
-       if (disk->fops->swap_slot_free_notify) {
-               swp_entry_t entry;
+       entry.val = page_private(page);
+       if (disk->fops->swap_slot_free_notify &&
+                       __swap_count(sis, entry) == 1) {
                unsigned long offset;

-               entry.val = page_private(page);
                offset = swp_offset(entry);

                SetPageDirty(page);
--
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

>
>> ------------------ original commit in Linus's tree ------------------
>>
>> >From 5df373e95689b9519b8557da7c5bd0db0856d776 Mon Sep 17 00:00:00 2001
>> From: Vinayak Menon <vinmenon@codeaurora.org>
>> Date: Fri, 15 Nov 2019 17:35:00 -0800
>> Subject: [PATCH] mm/page_io.c: do not free shared swap slots
>>
>> The following race is observed due to which a processes faulting on a
>> swap entry, finds the page neither in swapcache nor swap.  This causes
>> zram to give a zero filled page that gets mapped to the process,
>> resulting in a user space crash later.
>>
>> Consider parent and child processes Pa and Pb sharing the same swap slot
>> with swap_count 2.  Swap is on zram with SWP_SYNCHRONOUS_IO set.
>> Virtual address 'VA' of Pa and Pb points to the shared swap entry.
>>
>> Pa                                       Pb
>>
>> fault on VA                              fault on VA
>> do_swap_page                             do_swap_page
>> lookup_swap_cache fails                  lookup_swap_cache fails
>>                                          Pb scheduled out
>> swapin_readahead (deletes zram entry)
>> swap_free (makes swap_count 1)
>>                                          Pb scheduled in
>>                                          swap_readpage (swap_count == 1)
>>                                          Takes SWP_SYNCHRONOUS_IO path
>>                                          zram enrty absent
>>                                          zram gives a zero filled page
>>
>> Fix this by making sure that swap slot is freed only when swap count
>> drops down to one.
>>
>> Link: http://lkml.kernel.org/r/1571743294-14285-1-git-send-email-vinmenon@codeaurora.org
>> Fixes: aa8d22a11da9 ("mm: swap: SWP_SYNCHRONOUS_IO: skip swapcache only if swapped page has no other reference")
>> Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
>> Suggested-by: Minchan Kim <minchan@google.com>
>> Acked-by: Minchan Kim <minchan@kernel.org>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Hugh Dickins <hughd@google.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> diff --git a/mm/page_io.c b/mm/page_io.c
>> index 24ee600f9131..60a66a58b9bf 100644
>> --- a/mm/page_io.c
>> +++ b/mm/page_io.c
>> @@ -73,6 +73,7 @@ static void swap_slot_free_notify(struct page *page)
>>  {
>>  	struct swap_info_struct *sis;
>>  	struct gendisk *disk;
>> +	swp_entry_t entry;
>>  
>>  	/*
>>  	 * There is no guarantee that the page is in swap cache - the software
>> @@ -104,11 +105,10 @@ static void swap_slot_free_notify(struct page *page)
>>  	 * we again wish to reclaim it.
>>  	 */
>>  	disk = sis->bdev->bd_disk;
>> -	if (disk->fops->swap_slot_free_notify) {
>> -		swp_entry_t entry;
>> +	entry.val = page_private(page);
>> +	if (disk->fops->swap_slot_free_notify && __swap_count(entry) == 1) {
>>  		unsigned long offset;
>>  
>> -		entry.val = page_private(page);
>>  		offset = swp_offset(entry);
>>  
>>  		SetPageDirty(page);
>>
