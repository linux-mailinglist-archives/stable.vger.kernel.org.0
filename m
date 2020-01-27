Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE0714AABC
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 20:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgA0Tz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 14:55:57 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:48909 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbgA0Tz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 14:55:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04396;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TockCcP_1580154952;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TockCcP_1580154952)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Jan 2020 03:55:54 +0800
Subject: Re: [v3 PATCH] mm: move_pages: report the number of non-attempted
 pages
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mhocko@suse.com, richardw.yang@linux.intel.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1580144268-79620-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200127193546.GB8708@bombadil.infradead.org>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <a9a07fcb-0117-c995-0463-0afc3caa1cde@linux.alibaba.com>
Date:   Mon, 27 Jan 2020 11:55:48 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200127193546.GB8708@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/27/20 11:35 AM, Matthew Wilcox wrote:
>> @@ -1627,8 +1627,18 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>>   			start = i;
>>   		} else if (node != current_node) {
>>   			err = do_move_pages_to_node(mm, &pagelist, current_node);
>> -			if (err)
>> +			if (err) {
>> +				/*
>> +				 * Possitive err means the number of failed
> "positive"
>
>> +				 * pages to migrate.  Since we are going to
>> +				 * abort and return the number of non-migrated
>> +				 * pages, so need incude the rest of the
> "need to include"
>
>> +				 * nr_pages that have not attempted as well.
> "have not been attempted"
>
>> @@ -1674,6 +1687,13 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>>   
>>   	/* Make sure we do not overwrite the existing error */
>>   	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
>> +	/*
>> +	 * Don't have to report non-attempted pages here since:
>> +	 *     - If the above loop is done gracefully there is not non-attempted
> "all pages have been attempted"
>
>> +	 *       page.
>> +	 *     - If the above loop is aborted to it means more fatal error
> s/to// s/more/a/
>
>> +	 *       happened, should return err.
>> +	 */
> I'd also be tempted to rename "err" to "ret" since it has meanings beyond
> "error" now.

Thanks for catching these problems. Will fix in v4.
>

