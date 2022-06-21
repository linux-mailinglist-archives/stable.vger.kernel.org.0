Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6842552D53
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 10:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348251AbiFUIpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 04:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346674AbiFUIpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 04:45:40 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F59625EAF;
        Tue, 21 Jun 2022 01:45:38 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VH0dWR7_1655801131;
Received: from 30.97.48.73(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0VH0dWR7_1655801131)
          by smtp.aliyun-inc.com;
          Tue, 21 Jun 2022 16:45:32 +0800
Message-ID: <f79ad32f-50a3-be1a-0cac-d00f579e7077@linux.alibaba.com>
Date:   Tue, 21 Jun 2022 16:45:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] mm/damon: Use set_huge_pte_at() to make huge pte old
To:     SeongJae Park <sj@kernel.org>
Cc:     akpm@linux-foundation.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220620172742.48766-1-sj@kernel.org>
From:   Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20220620172742.48766-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi SeongJae,

On 6/21/2022 1:27 AM, SeongJae Park wrote:
> Hi Baolin,
> 
> On Mon, 20 Jun 2022 10:34:42 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> 
>> The huge_ptep_set_access_flags() can not make the huge pte old according
>> to the discussion [1], that means we will always mornitor the young state
>> of the hugetlb though we stopped accessing the hugetlb, as a result DAMON
>> will get inaccurate accessing statistics.
>>
>> So changing to use set_huge_pte_at() to make the huge pte old to fix this
>> issue.
>>
>> [1] https://lore.kernel.org/all/Yqy97gXI4Nqb7dYo@arm.com/
>>
>> Fixes: 49f4203aae06 ("mm/damon: add access checking for hugetlb pages")
> 
> As the commit has merged in from v5.17, I guess it would be better to do below?
> 
> Cc: <stable@vger.kernel.org>

Yes, thanks for reminding. Hope Andrew can help to add the stable tag 
when picking up this patch.

> 
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Other than that,
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thanks.
