Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BCF14A827
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 17:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgA0Qef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 11:34:35 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:43478 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbgA0Qef (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 11:34:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TocDDoG_1580142868;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TocDDoG_1580142868)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Jan 2020 00:34:30 +0800
Subject: Re: [v2 PATCH] mm: move_pages: report the number of non-attempted
 pages
To:     Michal Hocko <mhocko@kernel.org>
Cc:     richardw.yang@linux.intel.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200127095533.GD1183@dhcp22.suse.cz>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <0190d084-5295-83c3-98e7-eceae1b45c89@linux.alibaba.com>
Date:   Mon, 27 Jan 2020 08:34:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200127095533.GD1183@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/27/20 1:55 AM, Michal Hocko wrote:
> On Thu 23-01-20 07:38:51, Yang Shi wrote:
>> Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
>> the semantic of move_pages() was changed to return the number of
>> non-migrated pages (failed to migration) and the call would be aborted
>> immediately if migrate_pages() returns positive value.  But it didn't
>> report the number of pages that we even haven't attempted to migrate.
>> So, fix it by including non-attempted pages in the return value.
> I would rephrased the changelog like this
> "
> Since commit 49bd4d71637 ("mm, numa: rework do_pages_move"),
> the semantic of move_pages() has changed to return the number of
> non-migrated pages if they were result of a non-fatal reasons (usually a
> busy page). This was an unintentional change that hasn't been noticed
> except for LTP tests which checked for the documented behavior.
>
> There are two ways to go around this change. We can even get back to the
> original behavior and return -EAGAIN whenever migrate_pages is not able
> to migrate pages due to non-fatal reasons. Another option would be to
> simply continue with the changed semantic and extend move_pages
> documentation to clarify that -errno is returned on an invalid input or
> when migration simply cannot succeed (e.g. -ENOMEM, -EBUSY) or the
> number of pages that couldn't have been migrated due to ephemeral
> reasons (e.g. page is pinned or locked for other reasons).
>
> This patch implements the second option because this behavior is in
> place for some time without anybody complaining and possibly new users
> depending on it. Also it allows to have a slightly easier error handling
> as the caller knows that it is worth to retry when err > 0.
> "
>
>> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>> Suggested-by: Michal Hocko <mhocko@suse.com>
>> Cc: Wei Yang <richardw.yang@linux.intel.com>
>> Cc: <stable@vger.kernel.org>    [4.17+]
>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> With a more clarification, feel free to add
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks. Will post v3 with the rephrased commit log.

>
>> ---
>> v2: Rebased on top of the latest mainline kernel per Andrew
>>
>>   mm/migrate.c | 24 ++++++++++++++++++++++--
>>   1 file changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 86873b6..9b8eb5d 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1627,8 +1627,18 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>>   			start = i;
>>   		} else if (node != current_node) {
>>   			err = do_move_pages_to_node(mm, &pagelist, current_node);
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
>>   				goto out;
>> +			}
>>   			err = store_status(status, start, current_node, i - start);
>>   			if (err)
>>   				goto out;
>> @@ -1659,8 +1669,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>>   			goto out_flush;
>>   
>>   		err = do_move_pages_to_node(mm, &pagelist, current_node);
>> -		if (err)
>> +		if (err) {
>> +			if (err > 0)
>> +				err += nr_pages - i - 1;
>>   			goto out;
>> +		}
>>   		if (i > start) {
>>   			err = store_status(status, start, current_node, i - start);
>>   			if (err)
>> @@ -1674,6 +1687,13 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>>   
>>   	/* Make sure we do not overwrite the existing error */
>>   	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
>> +	/*
>> +	 * Don't have to report non-attempted pages here since:
>> +	 *     - If the above loop is done gracefully there is not non-attempted
>> +	 *       page.
>> +	 *     - If the above loop is aborted to it means more fatal error
>> +	 *       happened, should return err.
>> +	 */
>>   	if (!err1)
>>   		err1 = store_status(status, start, current_node, i - start);
>>   	if (!err)
>> -- 
>> 1.8.3.1

