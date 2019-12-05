Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4D3114617
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 18:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbfLERjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 12:39:41 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:51581 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729598AbfLERjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 12:39:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Tk3EpCO_1575567568;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tk3EpCO_1575567568)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Dec 2019 01:39:31 +0800
Subject: Re: [v2 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     Qian Cai <cai@lca.pw>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        cl@linux.com, vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1575519678-86510-1-git-send-email-yang.shi@linux.alibaba.com>
 <9E51ECF6-E9E8-4772-B7D8-7E528DD56A89@lca.pw>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <a16b53f9-92c9-ff01-06c1-530647ecaff1@linux.alibaba.com>
Date:   Thu, 5 Dec 2019 09:39:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <9E51ECF6-E9E8-4772-B7D8-7E528DD56A89@lca.pw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/5/19 1:42 AM, Qian Cai wrote:
>
>> On Dec 4, 2019, at 11:21 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>>
>> Felix Abecassis reports move_pages() would return random status if the
>> pages are already on the target node by the below test program:
>>
>> ---8<---
>>
>> int main(void)
>> {
>>     const long node_id = 1;
>>     const long page_size = sysconf(_SC_PAGESIZE);
>>     const int64_t num_pages = 8;
>>
>>     unsigned long nodemask =  1 << node_id;
>>     long ret = set_mempolicy(MPOL_BIND, &nodemask, sizeof(nodemask));
>>     if (ret < 0)
>>         return (EXIT_FAILURE);
>>
>>     void **pages = malloc(sizeof(void*) * num_pages);
>>     for (int i = 0; i < num_pages; ++i) {
>>         pages[i] = mmap(NULL, page_size, PROT_WRITE | PROT_READ,
>>                 MAP_PRIVATE | MAP_POPULATE | MAP_ANONYMOUS,
>>                 -1, 0);
>>         if (pages[i] == MAP_FAILED)
>>             return (EXIT_FAILURE);
>>     }
>>
>>     ret = set_mempolicy(MPOL_DEFAULT, NULL, 0);
>>     if (ret < 0)
>>         return (EXIT_FAILURE);
>>
>>     int *nodes = malloc(sizeof(int) * num_pages);
>>     int *status = malloc(sizeof(int) * num_pages);
>>     for (int i = 0; i < num_pages; ++i) {
>>         nodes[i] = node_id;
>>         status[i] = 0xd0; /* simulate garbage values */
>>     }
>>
>>     ret = move_pages(0, num_pages, pages, nodes, status, MPOL_MF_MOVE);
>>     printf("move_pages: %ld\n", ret);
>>     for (int i = 0; i < num_pages; ++i)
>>         printf("status[%d] = %d\n", i, status[i]);
>> }
>> ---8<---
>>
>> Then running the program would return nonsense status values:
>> $ ./move_pages_bug
>> move_pages: 0
>> status[0] = 208
>> status[1] = 208
>> status[2] = 208
>> status[3] = 208
>> status[4] = 208
>> status[5] = 208
>> status[6] = 208
>> status[7] = 208
>>
>> This is because the status is not set if the page is already on the
>> target node, but move_pages() should return valid status as long as it
>> succeeds.  The valid status may be errno or node id.
>>
>> We can't simply initialize status array to zero since the pages may be
>> not on node 0.  Fix it by updating status with node id which the page is
>> already on.  And, it looks we have to update the status inside
>> add_page_for_migration() since the page struct is not available outside
>> it.
>>
>> Make add_page_for_migration() return 1 if store_status() is failed in
>> order to not mix up the status value since -EFAULT is also a valid
>> status.
> Don’t really feel it is a bug after all. As you mentioned, the manpage was rather poorly written. Why it is not a good idea just update the manpage or/and code comments instead to document the current behavior?

There are definitely a few inconsistencies, but I think the manpage is 
quite clear for this specific case, which says "status is an array of 
integers that return the status of each page. The array contains valid 
values only if move_pages() did not return an error." And, it looks 
kernel just misbehaved since 4.17 due to the fixes commit, so it sounds 
like a regression too.


