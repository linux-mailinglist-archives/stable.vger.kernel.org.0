Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25CE1692C8
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 02:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBWBYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 20:24:17 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10672 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726934AbgBWBYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 20:24:17 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D1DEDE6A910DC861A4E4;
        Sun, 23 Feb 2020 09:24:12 +0800 (CST)
Received: from [127.0.0.1] (10.177.246.209) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sun, 23 Feb 2020
 09:24:03 +0800
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
To:     Matthew Wilcox <willy@infradead.org>, Qian Cai <cai@lca.pw>
CC:     <akpm@linux-foundation.org>, <mike.kravetz@oracle.com>,
        <kirill.shutemov@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <weidong.huang@huawei.com>,
        <weifuqiang@huawei.com>, <kvm@vger.kernel.org>,
        <linux-mm@kvack.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        <stable@vger.kernel.org>
References: <C4ED630A-FAD8-4998-A0A3-9C36F3303379@lca.pw>
 <f274b368-6fdb-2ae3-160e-fd8b105b9ac4@huawei.com>
 <20200222170222.GJ24185@bombadil.infradead.org>
From:   "Longpeng (Mike)" <longpeng2@huawei.com>
Message-ID: <dfbfbf46-483a-808f-d197-388f75569d9c@huawei.com>
Date:   Sun, 23 Feb 2020 09:24:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200222170222.GJ24185@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.246.209]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2020/2/23 1:02, Matthew Wilcox 写道:
> On Sat, Feb 22, 2020 at 02:33:10PM +0800, Longpeng (Mike) wrote:
>> 在 2020/2/22 13:23, Qian Cai 写道:
>>>> On Feb 21, 2020, at 10:34 PM, Longpeng(Mike) <longpeng2@huawei.com> wrote:
>>>>
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index dd8737a..90daf37 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -4910,28 +4910,30 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
>>>> {
>>>>    pgd_t *pgd;
>>>>    p4d_t *p4d;
>>>> -    pud_t *pud;
>>>> -    pmd_t *pmd;
>>>> +    pud_t *pud, pud_entry;
>>>> +    pmd_t *pmd, pmd_entry;
>>>>
>>>>    pgd = pgd_offset(mm, addr);
>>>> -    if (!pgd_present(*pgd))
>>>> +    if (!pgd_present(READ_ONCE(*pgd)))
>>>>        return NULL;
>>>>    p4d = p4d_offset(pgd, addr);
>>>> -    if (!p4d_present(*p4d))
>>>> +    if (!p4d_present(READ_ONCE(*p4d)))
>>>>        return NULL;
>>>
>>> What’s the point of READ_ONCE() on those two places?
>>>
>> As explained in the commit messages, it's for safe(e.g. avoid the compilier
>> mischief). You can also find the same usage in the ARM64's huge_pte_offset() in
>> arch/arm64/mm/hugetlbpage.c
> 
> I rather agree with Qian; if we need something like READ_ONCE() here,
> why don't we always need it as part of pgd_present()?  It seems like an
> unnecessary burden for every user.
> 
Hi Matthew & Qian,

Firstly, this is NOT a 'blindly copy', it's an unwise words. I don't know
whether you read the commit message (commit 20a004e7) of ARM64's huge_pte_offset
? If you read, I think worry about the safe is necessary.

Secondly, huge_pte_offset in mm/hugetlb.c is for ARCH_WANT_GENERAL_HUGETLB, many
architectures use it, can you make sure there is no issue on all the
architectures using it with all the version of gcc ?

Thirdly, there are several places use READ_ONCE to access the page table in mm/*
(e.g. gup_pmd_range), they're also generical for all architectures, and they're
much more like unnecessary than here, so why there can use but not here? What's
more, you can read this commit 688272809.

-- 
Regards,
Longpeng(Mike)

