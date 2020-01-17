Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2AE814068B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgAQJmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:42:23 -0500
Received: from relay.sw.ru ([185.231.240.75]:50194 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgAQJmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 04:42:22 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1isO8k-0005zq-5i; Fri, 17 Jan 2020 12:42:06 +0300
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
To:     David Rientjes <rientjes@google.com>
Cc:     Michal Hocko <mhocko@kernel.org>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
 <20200117091002.GM19428@dhcp22.suse.cz>
 <b67fe2bb-e7a6-29fe-925e-dd1ae176cc4b@virtuozzo.com>
 <alpine.DEB.2.21.2001170132090.20618@chino.kir.corp.google.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <11ba0af7-c2b2-83f9-ac55-7793cedb8028@virtuozzo.com>
Date:   Fri, 17 Jan 2020 12:42:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2001170132090.20618@chino.kir.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.01.2020 12:32, David Rientjes wrote:
> On Fri, 17 Jan 2020, Kirill Tkhai wrote:
> 
>>>> I think that's a good point, especially considering that the current code 
>>>> appears to unconditionally place any compound page on the deferred split 
>>>> queue of the destination memcg.  The correct list that it should appear 
>>>> on, I believe, depends on whether the pmd has been split for the process 
>>>> being moved: note the MC_TARGET_PAGE caveat in 
>>>> mem_cgroup_move_charge_pte_range() that does not move the charge for 
>>>> compound pages with split pmds.  So when mem_cgroup_move_account() is 
>>>> called with compound == true, we're moving the charge of the entire 
>>>> compound page: why would it appear on that memcg's deferred split queue?
>>>
>>> I believe Kirill asked how do we know that the page should be actually
>>> added to the deferred list just from the list_empty check. In other
>>> words what if the page hasn't been split at all?
>>
>> Yes, I'm talking about this. Function mem_cgroup_move_account() adds every
>> huge page to the deferred list, while we need to do that only for pages,
>> which are queued for splitting...
>>
> 
> Yup, and that appears broken before Wei's patch.  Since we only migrate 
> charges of entire compound pages (we have a mapping pmd, the underlying 
> page cannot be split), it should not appear on the deferred split queue 
> for any memcg, right?

Hm. Can't a huge page be mapped in two tasks:

1)the first task unmapped a part of page and initiated splitting,
2)the second task still refers the whole page,

then we move account for the second task?
