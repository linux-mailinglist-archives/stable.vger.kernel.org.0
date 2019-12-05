Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C611148F7
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 23:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLEWAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 17:00:02 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60978 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729708AbfLEWAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 17:00:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Tk42G0I_1575583184;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tk42G0I_1575583184)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Dec 2019 05:59:53 +0800
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     Christopher Lameter <cl@linux.com>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
 <alpine.DEB.2.21.1912051944030.10280@www.lameter.com>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <9731e7ff-6c0c-419f-5237-decf9a54e8f3@linux.alibaba.com>
Date:   Thu, 5 Dec 2019 13:59:44 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1912051944030.10280@www.lameter.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/5/19 11:45 AM, Christopher Lameter wrote:
> On Fri, 6 Dec 2019, Yang Shi wrote:
>
>> Felix Abecassis reports move_pages() would return random status if the
>> pages are already on the target node by the below test program:
> Looks ok.
>
> Acked-by: Christoph Lameter <cl@linux.com>
>
> Nitpicks:
>
>> @@ -1553,7 +1555,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>>   	if (PageHuge(page)) {
>>   		if (PageHead(page)) {
>>   			isolate_huge_page(page, pagelist);
>> -			err = 0;
>> +			err = 1;
> Add a meaningful constant instead of 1?

Since it just returns errno, 0 and 1 it sounds not worth a constant or enum.

>
>>   out:
>>   	up_read(&mm->mmap_sem);
>> +
>>   	return err;
> Dont do that.

Yes, my fat finger.


