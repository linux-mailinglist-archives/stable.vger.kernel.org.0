Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B0619620E
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 00:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgC0Xcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 19:32:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12206 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbgC0Xcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 19:32:41 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4DCD976769C895C2FE5A;
        Sat, 28 Mar 2020 07:32:38 +0800 (CST)
Received: from [10.173.228.124] (10.173.228.124) by smtp.huawei.com
 (10.3.19.207) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sat, 28 Mar
 2020 07:32:27 +0800
Subject: Re: [PATCH v3] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>, <arei.gonglei@huawei.com>,
        <weidong.huang@huawei.com>, <weifuqiang@huawei.com>,
        <kirill.shutemov@linux.intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox" <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        <stable@vger.kernel.org>
References: <20200327014007.1915-1-longpeng2@huawei.com>
 <20200327121100.GR20941@ziepe.ca>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <0d8771ec-9661-9ef4-0972-4dadf548487b@huawei.com>
Date:   Sat, 28 Mar 2020 07:32:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200327121100.GR20941@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.228.124]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/3/27 20:11, Jason Gunthorpe wrote:
> On Fri, Mar 27, 2020 at 09:40:07AM +0800, Longpeng(Mike) wrote:
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index dd8737a..d4fab68 100644
>> +++ b/mm/hugetlb.c
>> @@ -4909,29 +4909,33 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
>>  		       unsigned long addr, unsigned long sz)
>>  {
>>  	pgd_t *pgd;
>> -	p4d_t *p4d;
>> -	pud_t *pud;
>> -	pmd_t *pmd;
>> +	p4d_t *p4g, p4d_entry;
>> +	pud_t *pud, pud_entry;
>> +	pmd_t *pmd, pmd_entry;
>>  
>>  	pgd = pgd_offset(mm, addr);
>>  	if (!pgd_present(*pgd))
>>  		return NULL;
>> -	p4d = p4d_offset(pgd, addr);
>> -	if (!p4d_present(*p4d))
>> +
>> +	p4g = p4d_offset(pgd, addr);
> 
> Why p4g here? Shouldn't it be p4d?
> 
Sorry, it's a typo, I'll send v4

> Jason
> .
> 

---
Regards,
Longpeng(Mike)
