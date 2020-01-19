Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E38C141C7F
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 06:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgASFrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 00:47:32 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:43848 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgASFrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 00:47:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04428;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0To3yRW-_1579412846;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0To3yRW-_1579412846)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 19 Jan 2020 13:47:29 +0800
Subject: Re: [PATCH] mm: move_pages: fix the return value if there are
 not-migrated pages
To:     Wei Yang <richardw.yang@linux.intel.com>
Cc:     mhocko@suse.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200119023720.GD9745@richard> <20200119025733.GG9745@richard>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <68d332f9-290d-3537-1691-bb4805573f3f@linux.alibaba.com>
Date:   Sat, 18 Jan 2020 21:47:22 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200119025733.GG9745@richard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/18/20 6:57 PM, Wei Yang wrote:
> On Sun, Jan 19, 2020 at 10:37:20AM +0800, Wei Yang wrote:
>> On Sat, Jan 18, 2020 at 01:26:43PM +0800, Yang Shi wrote:
>>> The do_move_pages_to_node() might return > 0 value, the number of pages
>>> that are not migrated, then the value will be returned to userspace
>>> directly.  But, move_pages() syscall would just return 0 or errno.  So,
>>> we need reset the return value to 0 for such case as what pre-v4.17 did.
>>>
>>> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Wei Yang <richardw.yang@linux.intel.com>
>>> Cc: <stable@vger.kernel.org>    [4.17+]
>>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>>> ---
>>> mm/migrate.c | 5 ++++-
>>> 1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 86873b6..3e75432 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -1659,8 +1659,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>>> 			goto out_flush;
>>>
>>> 		err = do_move_pages_to_node(mm, &pagelist, current_node);
>>> -		if (err)
>>> +		if (err) {
>>> +			if (err > 0)
>>> +				err = 0;
>>> 			goto out;
>>> +		}
>>> 		if (i > start) {
>>> 			err = store_status(status, start, current_node, i - start);
>>> 			if (err)
>>> -- 
>>> 1.8.3.1
>>
>> Hey, I am afraid you missed something. There are three calls of
>> do_move_pages_to_node() in do_pages_move(). Why you just handle one return
>> value? How about the other two?
>>
> Well, current logic in do_pages_move() is a little complicated to read.
>
> I did a cleanup to make it easy to read and also friendly to do this fix.
>
> If they look good to you, you could rebase your fix on top of them.

Regression fix typically has higher priority. Since we already spotted 
the regressions and proposed fixes, I'd suggest we fix them in 5.5-rc, 
then aim any cleanup for 5.6 or 5.7. This should also make review easier 
IMHO.

>
>> -- 
>> Wei Yang
>> Help you, Help me

