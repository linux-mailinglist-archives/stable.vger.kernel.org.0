Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2901B54A3F7
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiFNCES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiFNCES (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:04:18 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138B530552;
        Mon, 13 Jun 2022 19:04:12 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VGKvHPB_1655172248;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VGKvHPB_1655172248)
          by smtp.aliyun-inc.com;
          Tue, 14 Jun 2022 10:04:09 +0800
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the
 migratetype
To:     Guo Ren <guoren@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, huanyi.xj@alibaba-inc.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <CAJF2gTQJZFfpSOx0yo3zJfECwpZR=79F5uLKVV_qqopS+F2PYA@mail.gmail.com>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <be463aaf-3cb0-f172-c09a-4bb810d564a1@linux.alibaba.com>
Date:   Tue, 14 Jun 2022 10:04:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAJF2gTQJZFfpSOx0yo3zJfECwpZR=79F5uLKVV_qqopS+F2PYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2022/6/14 上午12:08, Guo Ren 写道:
> On Mon, Jun 13, 2022 at 9:11 PM Xianting Tian
> <xianting.tian@linux.alibaba.com> wrote:
>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its migratetype.")
>> added buddy check code. But unfortunately, this fix isn't backported to
>> linux-5.17.y and the former stable branches. The reason is it added wrong
>> fixes message:
>>       Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackable
>>                             pageblocks with others")
>> Actually, this issue is involved by commit:
>>       commit d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
>>
>> For RISC-V arch, the first 2M is reserved for sbi, so the start PFN is 512,
>> but it got buddy PFN 0 for PFN 0x2000:
>>       0 = 0x2000 ^ (1 << 12)
> How did we get 0? （Try it in gdb)
> (gdb) p /x (0x2000 ^ (1<<12))
> $3 = 0x3000
>
> I think it got buddy PFN 0 for PFN 0x1000, right?
> (gdb) p /x (0x1000 ^ (1<<12))
> $4 = 0x0
Sorry, it is a typo, the order is 0xd = 13, not 12.
>> With the illegal buddy PFN 0, it got an illegal buddy page, which caused
>> crash in __get_pfnblock_flags_mask().
>>
>> With the patch, it can avoid the calling of get_pageblock_migratetype() if
>> it isn't buddy page.
>>
>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
>> Cc: stable@vger.kernel.org
>> Reported-by: zjb194813@alibaba-inc.com
>> Reported-by: tianhu.hh@alibaba-inc.com
>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>> ---
>>   mm/page_alloc.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index b1caa1c6c887..5b423caa68fd 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct page *page,
>>
>>                          buddy_pfn = __find_buddy_pfn(pfn, order);
>>                          buddy = page + (buddy_pfn - pfn);
>> +
>> +                       if (!page_is_buddy(page, buddy, order))
> Right, we need to check the buddy_pfn valid, because some SoCs would
> start dram address with an offset that has an order smaller than
> MAX_ORDER.
>
>> +                               goto done_merging;
>>                          buddy_mt = get_pageblock_migratetype(buddy);
>>
>>                          if (migratetype != buddy_mt
>> --
>> 2.17.1
>>
> Fixup the comment and
>
> Reviewed-by: Guo Ren <guoren@kernel.org>
>
