Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41686E24CA
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 22:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391478AbfJWUuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 16:50:23 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:40569 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390611AbfJWUuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 16:50:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07486;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Tg.Zevt_1571863816;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tg.Zevt_1571863816)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Oct 2019 04:50:19 +0800
Subject: Re: [v2 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
To:     Hugh Dickins <hughd@google.com>
Cc:     aarcange@redhat.com, kirill.shutemov@linux.intel.com,
        gavin.dg@linux.alibaba.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com>
 <alpine.LSU.2.11.1910231157570.1088@eggly.anvils>
 <4d3c14ef-ee86-2719-70d6-68f1a8b42c28@linux.alibaba.com>
 <alpine.LSU.2.11.1910231250260.1794@eggly.anvils>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <d500d98e-3577-ced1-9614-7aa5e09e6dbe@linux.alibaba.com>
Date:   Wed, 23 Oct 2019 13:50:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1910231250260.1794@eggly.anvils>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/23/19 1:00 PM, Hugh Dickins wrote:
> On Wed, 23 Oct 2019, Yang Shi wrote:
>> On 10/23/19 12:28 PM, Hugh Dickins wrote:
>>>> +	return map_count >= 0 &&
>>> You have added a map_count >= 0 test there. Okay, not wrong, but not
>>> necessary, and not consistent with what's returned in the PageAnon
>>> case (if this were called for an unmapped page).
>> I was thinking about this too. I'm wondering there might be a case that the
>> PMD is split and it was the last PMD map, in this case subpage's _mapcount is
>> also equal to compound_mapcount (both is -1). So, it would return true, then
>> KVM may setup PMD map in EPT, but it might be PTE mapped later on the host.
>> But, I'm not quite sure if this is really possible or if this is really a
>> integrity problem. So, I thought it might be safer to add this check.
> The mmu_notifier_invalidate_range_start.._end() in __split_huge_pmd(),
> with KVM's locking and sequence counting, is required to protect
> against such races.

OK, it sounds safe. Thanks for confirming. Will post v4 soon.

>
> Hugh

