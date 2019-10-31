Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A43EB42D
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 16:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfJaPr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 11:47:29 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:49754 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727579AbfJaPr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 11:47:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0TgnKHgK_1572536841;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TgnKHgK_1572536841)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 31 Oct 2019 23:47:23 +0800
Subject: Re: [PATCH] mm: mempolicy: fix the wrong return value and potential
 pages leak of mbind
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     lixinhai.lxh@gmail.com, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1572454731-3925-1-git-send-email-yang.shi@linux.alibaba.com>
 <12ac5b41-27a6-5a5b-0d07-7e9cb847829d@linux.alibaba.com>
 <20191030213144.dd7cd8084d4171e29abba875@linux-foundation.org>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <5cc16fd6-dd63-6798-4e3e-5c3a6b731aa2@linux.alibaba.com>
Date:   Thu, 31 Oct 2019 08:47:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20191030213144.dd7cd8084d4171e29abba875@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/30/19 9:31 PM, Andrew Morton wrote:
> On Wed, 30 Oct 2019 11:14:58 -0700 Yang Shi <yang.shi@linux.alibaba.com> wrote:
>
>> On 10/30/19 9:58 AM, Yang Shi wrote:
>>> The commit d883544515aa ("mm: mempolicy: make the behavior consistent
>>> when MPOL_MF_MOVE* and MPOL_MF_STRICT were specified") fixed the return
>>> value of mbind() for a couple of corner cases.  But, it altered the
>>> errno for some other cases, for example, mbind() should return -EFAULT
>>> when part or all of the memory range specified by nodemask and maxnode
>>> points  outside your accessible address space, or there was an unmapped
>>> hole in the specified memory range specified by addr and len.
>>>
>>> Fixed this by preserving the errno returned by queue_pages_range().
>>> And, the pagelist may be not empty even though queue_pages_range()
>>> returns error, put the pages back to LRU since mbind_range() is not called
>>> to really apply the policy so those pages should not be migrated, this
>>> is also the old behavior before the problematic commit.
>> Forgot fixes tag.
>>
>> Fixes: d883544515aa ("mm: mempolicy: make the behavior consistent when
>> MPOL_MF_MOVE* and MPOL_MF_STRICT were specified")
> What's the relationship between this patch and
> http://lkml.kernel.org/r/201910291756045288126@gmail.com?

They are irrelevant. The commit d883544515aa ("mm: mempolicy: make the 
behavior consistent
when MPOL_MF_MOVE* and MPOL_MF_STRICT were specified") override the 
-EFAULT return value of queue_pages_range() by -EIO mistakenly and 
missed putting non-empty pagelist back, this patch is aimed to fix the 
two issues.

I think Li Xinhai found the return value override problem during 
debugging his patch.


