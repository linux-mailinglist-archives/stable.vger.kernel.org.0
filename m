Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DEA6DA7A8
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 04:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240527AbjDGCUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 22:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240502AbjDGCUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 22:20:54 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559A0A9;
        Thu,  6 Apr 2023 19:20:53 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=rongwei.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VfUplq7_1680834049;
Received: from 30.221.130.130(mailfrom:rongwei.wang@linux.alibaba.com fp:SMTPD_---0VfUplq7_1680834049)
          by smtp.aliyun-inc.com;
          Fri, 07 Apr 2023 10:20:50 +0800
Message-ID: <97551857-b2fe-eb26-88a0-780951b873d7@linux.alibaba.com>
Date:   Fri, 7 Apr 2023 10:20:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff and
 get_swap_pages()
Content-Language: en-US
To:     Aaron Lu <aaron.lu@intel.com>
Cc:     akpm@linux-foundation.org, bagasdotme@gmail.com,
        willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
 <20230406140416.GA415291@ziqianlu-desk2>
 <20230406145754.GA440657@ziqianlu-desk2>
From:   Rongwei Wang <rongwei.wang@linux.alibaba.com>
In-Reply-To: <20230406145754.GA440657@ziqianlu-desk2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2023/4/6 22:57, Aaron Lu wrote:
> On Thu, Apr 06, 2023 at 10:04:16PM +0800, Aaron Lu wrote:
>> On Tue, Apr 04, 2023 at 11:47:16PM +0800, Rongwei Wang wrote:
>>> The si->lock must be held when deleting the si from
>>> the available list.  Otherwise, another thread can
>>> re-add the si to the available list, which can lead
>>> to memory corruption. The only place we have found
>>> where this happens is in the swapoff path. This case
>>> can be described as below:
>>>
>>> core 0                       core 1
>>> swapoff
>>>
>>> del_from_avail_list(si)      waiting
>>>
>>> try lock si->lock            acquire swap_avail_lock
>>>                               and re-add si into
>>>                               swap_avail_head
>>                                 confused here.
>>
>> If del_from_avail_list(si) finished in swaoff path, then this si should
>> not exist in any of the per-node avail list and core 1 should not be
>> able to re-add it.
> I think a possible sequence could be like this:
>
> cpuX                             cpuY
> swapoff                          put_swap_folio()
>
> del_from_avail_list(si)
>                                   taken si->lock
> spin_lock(&si->lock);
>
> 				 swap_range_free()
> 				 was_full && SWP_WRITEOK -> re-add!
> 				 drop si->lock
>
> taken si->lock
> proceed removing si
>
> End result: si left on avail_list after being swapped off.
>
> The problem is, in add_to_avail_list(), it has no idea this si is being
> swapped off and taking si->lock then del_from_avail_list() could avoid
> this problem, so I think this patch did the right thing but the
> changelog about how this happened needs updating and after that:

Hi Aaron

That's my fault. Actually, I don't refers specifically to 
swap_range_free() path in commit, mainly because cpuY can stand all 
threads which is waiting swap_avail_lock, then to call 
add_to_avail_list(), not only swap_range_free(), e.g. maybe swapon().

>
> Reviewed-by: Aaron Lu <aaron.lu@intel.com>

Thanks for your time.

-wrw

>
> Thanks,
> Aaron
>
