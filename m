Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7598A17EA74
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgCIUwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:52:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:60214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgCIUwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 16:52:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3DA3AD61;
        Mon,  9 Mar 2020 20:52:00 +0000 (UTC)
Subject: Re: Patch "mm, hotplug: fix page online with DEBUG_PAGEALLOC compiled
 but not enabled" has been added to the 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org, cai@lca.pw,
        david@redhat.com, gerald.schaefer@de.ibm.com,
        iamjoonsoo.kim@lge.com, torvalds@linux-foundation.org,
        stable-commits@vger.kernel.org
References: <1583781746100221@kroah.com>
 <4e806950-6fbc-9898-32a4-0309cc37bf7e@suse.cz>
 <20200309202118.GA714007@kroah.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <937bbd7a-f9fc-1fbf-53ef-38b6b605b754@suse.cz>
Date:   Mon, 9 Mar 2020 21:51:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309202118.GA714007@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/2020 9:21 PM, Greg KH wrote:
> On Mon, Mar 09, 2020 at 09:11:25PM +0100, Vlastimil Babka wrote:
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -598,7 +598,13 @@ EXPORT_SYMBOL_GPL(__online_page_free);
>>>  
>>>  static void generic_online_page(struct page *page, unsigned int order)
>>>  {
>>> -	kernel_map_pages(page, 1 << order, 1);
>>> +	/*
>>> +	 * Freeing the page with debug_pagealloc enabled will try to unmap it,
>>> +	 * so we should map it first. This is better than introducing a special
>>> +	 * case in page freeing fast path.
>>> +	 */
>>> +	if (debug_pagealloc_enabled_static())
>>
>> Won't build on 5.4, see in changelog "Backports for kernel before 5.5 should use
>> debug_pagealloc_enabled() instead."
> 
> Builds just fine for me here, are you _sure_ 5.4.y doesn't work?
> 
> 5.4.14 got debug_pagealloc_enabled_static() through the backport of
> 8e57f8acbbd1 ("mm, debug_pagealloc: don't rely on static keys too
> early") which you wrote :)

Ah ok, didn't realize that, I probably only checked the mainline :)

> Now if it still needs to be changed, let me know and I will do so.

Nothing needs to change then, sorry for the noise.

> thanks,
> 
> greg k-h
> 

