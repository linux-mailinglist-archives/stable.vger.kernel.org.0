Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF43F1183
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 09:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfKFIze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 03:55:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:55186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726830AbfKFIze (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 03:55:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 07C3AABBD;
        Wed,  6 Nov 2019 08:55:32 +0000 (UTC)
Subject: Re: [PATCH v2 6/8] mm: prevent get_user_pages() from overflowing page
 refcount
To:     Ajay Kaher <akaher@vmware.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "punit.agrawal@arm.com" <punit.agrawal@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mszeredi@redhat.com" <mszeredi@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Vikash Bansal <bvikas@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Steven Rostedt <srostedt@vmware.com>,
        "stable@kernel.org" <stable@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
References: <1570581863-12090-1-git-send-email-akaher@vmware.com>
 <1570581863-12090-7-git-send-email-akaher@vmware.com>
 <f899be71-4bc0-d07b-f650-d85a335cdebb@suse.cz>
 <BF0587E3-D104-4DB2-B972-9BC4FD4CA014@vmware.com>
 <0E5175FB-7058-4211-9AA4-9D5E2F6A30B9@vmware.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <35d74931-2c18-00ff-7622-522a79be9103@suse.cz>
Date:   Wed, 6 Nov 2019 09:55:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <0E5175FB-7058-4211-9AA4-9D5E2F6A30B9@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/19 8:18 AM, Ajay Kaher wrote:
> ﻿On 17/10/19, 9:58 PM, "Ajay Kaher" <akaher@vmware.com> wrote:
>     
>> > This seems to have the same issue as the 4.9 stable version [1], in not
>> > touching the arch-specific gup.c variants.
>> >    
>> > [1]
>> > https://lore.kernel.org/lkml/6650323f-dbc9-f069-000b-f6b0f941a065@suse.cz/
>>    
>> Thanks Vlastimil for highlighting this here.
>> 
>> Yes, arch-specific gup.c variants also need to handle not only for 4.4.y,
>> however it should be handled till 4.19.y. I believe it's better to start
>> from 4.19.y and then backport those changes till 4.4.y.
>>    
>> Affected areas of gup.c (where page->count have been used) are:
>> #1: get_page() used in these files and this is safe as
>>        it's defined in mm.h (here it's already taken care of)
>> #2: get_head_page_multiple() has following:
>>               VM_BUG_ON_PAGE(page_count(page) == 0, page);
>>          Need to change this to:
>>               VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(page), page);
>> #3: Some of the files have used page_cache_get_speculative(),
>>        page_cache_add_speculative() with combination of compound_head(),
>>        this scenario needs to be handled as it was handled here:
>>            https://lore.kernel.org/stable/1570581863-12090-7-git-send-email-akaher@vmware.com/
>>    
>> Please share with me any suggestions or patches if you have already  
>> worked on this.
>>    
>> Could we handle arch-specific gup.c in different patch sets and 
>> let these patches to merge to 4.4.y?
>   
> Vlastimil, please suggest if it's fine to merge these patches to 4.4.y

I'm not sure if it makes much sense to merge them without the arch-specific gup
support, when we're aware that it's missing.

> and handle arch-specific gup.c in different patch sets starts from 4.19.y,

Actually arch-specific gup.c were removed in 4.13, so it's enough to start from
4.9.y, which I'm going to finally look into.

> then backport all the way to 4.4.y. 
> 
> Greg, any suggestion from your side.
> 
>>    - Ajay
>     
>     
>     
> 

