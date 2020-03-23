Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE8A18FF9F
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 21:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgCWUg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 16:36:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60172 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgCWUg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 16:36:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NKSX6b149459;
        Mon, 23 Mar 2020 20:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wwxhSAMWDlm/98wU2yz/vgcA4Tu2rqqR726uLbXjGSU=;
 b=IPXt3lUWeX7PguP4B4RNX8E0aLvmJbb+o8spOITHl19aJbCc/DFJrYtt8VWX3eLH9008
 uv7yjmL/4JORhX5lFL9PYRXvxfJBlJIrrxiLoFsILlK3MFvM/MD72C3kKaZGps+J2LL2
 DamS/I+AMpjzsepJUFg1F3+9fauFAJKUHG1XdQ+95DmfAT2nNYeGAJ3K4bxW7E+w0IGe
 mgd9I8PWfhZxdHqaIUhcIeJCYWuRF974w/KgQ9H+hLENzYK+VluVGx2575jofgMskdx1
 8359XvYN3+f6YV+JbtnmmbYaWsGhH9+NC194tERPJ5/ELo6Uq0Tco903MBui5tSm+a+z WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yx8abwtqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 20:35:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NKRnhb033737;
        Mon, 23 Mar 2020 20:35:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yxw7gdcm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 20:35:11 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02NKZ9X1004980;
        Mon, 23 Mar 2020 20:35:09 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Mar 2020 13:35:08 -0700
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Longpeng (Mike)" <longpeng2@huawei.com>,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <20200323160955.GY20941@ziepe.ca>
 <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
 <20200323180706.GC20941@ziepe.ca>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <88698dd7-eb87-4b0b-7ba7-44ef6eab6a6c@oracle.com>
Date:   Mon, 23 Mar 2020 13:35:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200323180706.GC20941@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=821 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003230102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=860
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230102
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/23/20 11:07 AM, Jason Gunthorpe wrote:
> On Mon, Mar 23, 2020 at 10:27:48AM -0700, Mike Kravetz wrote:
> 
>>>  	pgd = pgd_offset(mm, addr);
>>> -	if (!pgd_present(*pgd))
>>> +	if (!pgd_present(READ_ONCE(*pgd)))
>>>  		return NULL;
>>>  	p4d = p4d_offset(pgd, addr);
>>> -	if (!p4d_present(*p4d))
>>> +	if (!p4d_present(READ_ONCE(*p4d)))
>>>  		return NULL;
>>>  
>>>       pud = pud_offset(p4d, addr);
>>
>> One would argue that pgd and p4d can not change from present to !present
>> during the execution of this code.  To me, that seems like the issue which
>> would cause an issue.  Of course, I could be missing something.
> 
> This I am not sure of, I think it must be true under the read side of
> the mmap_sem, but probably not guarenteed under RCU..
> 
> In any case, it doesn't matter, the fact that *p4d can change at all
> is problematic. Unwinding the above inlines we get:
> 
>   p4d = p4d_offset(pgd, addr)
>   if (!p4d_present(*p4d))
>       return NULL;
>   pud = (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
> 
> According to our memory model the compiler/CPU is free to execute this
> as:
> 
>   p4d = p4d_offset(pgd, addr)
>   p4d_for_vaddr = *p4d;
>   if (!p4d_present(*p4d))
>       return NULL;
>   pud = (pud_t *)p4d_page_vaddr(p4d_for_vaddr) + pud_index(address);
> 

Wow!  How do you know this?  You don't need to answer :)

> In the case where p4 goes from !present -> present (ie
> handle_mm_fault()):
> 
> p4d_for_vaddr == p4d_none, and p4d_present(*p4d) == true, meaning the
> p4d_page_vaddr() will crash.
> 
> Basically the problem here is not just missing READ_ONCE, but that the
> p4d is read multiple times at all. It should be written like gup_fast
> does, to guarantee a single CPU read of the unstable data:
> 
>   p4d = READ_ONCE(*p4d_offset(pgdp, addr));
>   if (!p4d_present(p4))
>       return NULL;
>   pud = pud_offset(&p4d, addr);
> 
> At least this is what I've been able to figure out :\

In that case, I believe there are a bunch of similar routines with this issue.

For this patch, I was primarily interested in seeing the obvious multiple
dereferences in C fixed up.  This is above and beyond that! :)

>>> Also, the remark about pmd_offset() seems accurate. The
>>> get_user_fast_pages() pattern seems like the correct one to emulate:
>>>
>>>   pud = READ_ONCE(*pudp);
>>>   if (pud_none(pud)) 
>>>      ..
>>>   if (!pud_'is a pmd pointer')
>>>      ..
>>>   pmdp = pmd_offset(&pud, address);
>>>   pmd = READ_ONCE(*pmd);
>>>   [...]
>>>
>>> Passing &pud in avoids another de-reference of the pudp. Honestly all
>>> these APIs that take in page table pointers and internally
>>> de-reference them seem very hard to use correctly when the page table
>>> access isn't fully locked against write.
> 
> And the same protocol for the PUD, etc.
> 
>>> It looks like at least the p4d read from the pgd is also unlocked here
>>> as handle_mm_fault() writes to it??
>>
>> Yes, there is no locking required to call huge_pte_offset().
> 
> None? Not RCU or read mmap_sem?

Yes, mmap_sem in read mode.
Sorry, I was confusing this with additional locking requirements for hugetlb
specific code.

-- 
Mike Kravetz
