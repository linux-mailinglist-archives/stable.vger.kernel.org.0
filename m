Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAFD14610F
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 04:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAWD46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 22:56:58 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:44114 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbgAWD46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 22:56:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0ToNc5uW_1579751811;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0ToNc5uW_1579751811)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Jan 2020 11:56:54 +0800
Subject: Re: [v2 PATCH] mm: move_pages: report the number of non-attempted
 pages
To:     Wei Yang <richardw.yang@linux.intel.com>
Cc:     mhocko@suse.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200123032736.GA22196@richard>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <01fc1c6b-1cab-7f7e-7879-4fc7b0e4a231@linux.alibaba.com>
Date:   Wed, 22 Jan 2020 19:56:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200123032736.GA22196@richard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/22/20 7:27 PM, Wei Yang wrote:
> On Thu, Jan 23, 2020 at 07:38:51AM +0800, Yang Shi wrote:
>> Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
>> the semantic of move_pages() was changed to return the number of
>> non-migrated pages (failed to migration) and the call would be aborted
>> immediately if migrate_pages() returns positive value.  But it didn't
>> report the number of pages that we even haven't attempted to migrate.
>> So, fix it by including non-attempted pages in the return value.
>>
> First, we want to change the semantic of move_pages(2). The return value
> indicates the number of pages we didn't managed to migrate?

This is my understanding.

>
> Second, the return value from migrate_pages() doesn't mean the number of pages
> we failed to migrate. For example, one -ENOMEM is returned on the first page,
> migrate_pages() would return 1. But actually, no page successfully migrated.

This would not happen at all since migrate_pages() would just return 
-ENOMEM instead of a positive value, right?

>
> Third, even the migrate_pages() return the exact non-migrate page, we are not
> sure those non-migrated pages are at the tail of the list. Because in the last
> case in migrate_pages(), it just remove the page from list. It could be a page
> in the middle of the list. Then, in userspace, how the return value be
> leveraged to determine the valid status? Any page in the list could be the
> victim.

I think this problem has been discussed in another thread. Yes, the 
status may have non-valid value, but it is supposed to have valid value 
iff move_pages() return 0. Positive value is an error case, so the 
validity of status is not guaranteed.

>
> Sounds we need to think about this carefully.
>
>> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>> Suggested-by: Michal Hocko <mhocko@suse.com>
>> Cc: Wei Yang <richardw.yang@linux.intel.com>
>> Cc: <stable@vger.kernel.org>    [4.17+]
>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>> ---
>> v2: Rebased on top of the latest mainline kernel per Andrew
>>
>> mm/migrate.c | 24 ++++++++++++++++++++++--
>> 1 file changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 86873b6..9b8eb5d 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1627,8 +1627,18 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>> 			start = i;
>> 		} else if (node != current_node) {
>> 			err = do_move_pages_to_node(mm, &pagelist, current_node);
>> -			if (err)
>> +			if (err) {
>> +				/*
>> +				 * Positive err means the number of failed
>> +				 * pages to migrate.  Since we are going to
>> +				 * abort and return the number of non-migrated
>> +				 * pages, so need incude the rest of the
>> +				 * nr_pages that have not attempted as well.
>> +				 */
>> +				if (err > 0)
>> +					err += nr_pages - i - 1;
>> 				goto out;
>> +			}
>> 			err = store_status(status, start, current_node, i - start);
>> 			if (err)
>> 				goto out;
>> @@ -1659,8 +1669,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>> 			goto out_flush;
>>
>> 		err = do_move_pages_to_node(mm, &pagelist, current_node);
>> -		if (err)
>> +		if (err) {
>> +			if (err > 0)
>> +				err += nr_pages - i - 1;
>> 			goto out;
>> +		}
>> 		if (i > start) {
>> 			err = store_status(status, start, current_node, i - start);
>> 			if (err)
>> @@ -1674,6 +1687,13 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>>
>> 	/* Make sure we do not overwrite the existing error */
>> 	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
>> +	/*
>> +	 * Don't have to report non-attempted pages here since:
>> +	 *     - If the above loop is done gracefully there is not non-attempted
>> +	 *       page.
>> +	 *     - If the above loop is aborted to it means more fatal error
>> +	 *       happened, should return err.
>> +	 */
>> 	if (!err1)
>> 		err1 = store_status(status, start, current_node, i - start);
>> 	if (!err)
>> -- 
>> 1.8.3.1

