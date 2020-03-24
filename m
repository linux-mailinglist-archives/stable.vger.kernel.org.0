Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9802191A44
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 20:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgCXTr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 15:47:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41980 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCXTr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 15:47:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OJiGco030029;
        Tue, 24 Mar 2020 19:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aH2gS92pizO8Ui8+GY3Utx9mk0wsuhwC71eXWonUlwo=;
 b=pC0tAQKy3mtbwgPKbDSmmFZYlsI+uBsK4T+u8zgUBplY9RZEfsJFKBCXYddayy9Qrjwh
 K9it2225dQPjjmnbjnxmVnwR9BIuPuHNYIki0TW2tdUhhoBUKqq77Gl31UQP2j+DZImJ
 SxUyEF/GshfoRMuRyoTGd0t3NvvmRT6hICW4mM+UkPHDOJGvsZTXxvxJgXWTsZl/nWhU
 hVcb8qj+2vVPkZKWkIqC+2DY/pmLGudj1qXcjT1pwK5fOI6qQg4KQPZxkld7HjYxp4n8
 nmKsUTIiuCWvP05WBV0E8EdACdR9fy7688Jflu+2DrzPiL6EBqjukdLSD9aPzLRwBG/+ gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yx8ac3avv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 19:47:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OJgLR3050472;
        Tue, 24 Mar 2020 19:47:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yxw4px6ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 19:47:12 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02OJl8qZ008773;
        Tue, 24 Mar 2020 19:47:08 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 12:47:08 -0700
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
References: <20200323160955.GY20941@ziepe.ca>
 <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
 <20200323180706.GC20941@ziepe.ca>
 <88698dd7-eb87-4b0b-7ba7-44ef6eab6a6c@oracle.com>
 <20200323225225.GF20941@ziepe.ca>
 <e8e71ba4-d609-269a-6160-153e373e7563@huawei.com>
 <20200324115541.GH20941@ziepe.ca>
 <98d35563-8af0-2693-7e76-e6435da0bbee@oracle.com>
 <20200324155552.GK20941@ziepe.ca>
 <66583587-ca4f-9847-c173-4a3d7938fec6@oracle.com>
 <20200324175918.GL20941@ziepe.ca>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <c47402fe-b873-2e52-52be-7f9cc9eef0a1@oracle.com>
Date:   Tue, 24 Mar 2020 12:47:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200324175918.GL20941@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=952 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240097
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/20 10:59 AM, Jason Gunthorpe wrote:
> On Tue, Mar 24, 2020 at 09:19:29AM -0700, Mike Kravetz wrote:
>> On 3/24/20 8:55 AM, Jason Gunthorpe wrote:
>>> On Tue, Mar 24, 2020 at 08:25:09AM -0700, Mike Kravetz wrote:
>>>> On 3/24/20 4:55 AM, Jason Gunthorpe wrote:
>>>>> Also, since CH moved all the get_user_pages_fast code out of the
>>>>> arch's many/all archs can drop their arch specific version of this
>>>>> routine. This is really just a specialized version of gup_fast's
>>>>> algorithm..
>>>>>
>>>>> (also the arch versions seem different, why do some return actual
>>>>>  ptes, not null?)
>>>>
>>>> Not sure I understand that last question.  The return value should be
>>>> a *pte or null.
>>>
>>> I mean the common code ends like this:
>>>
>>> 	pmd = pmd_offset(pud, addr);
>>> 	if (sz != PMD_SIZE && pmd_none(*pmd))
>>> 		return NULL;
>>> 	/* hugepage or swap? */
>>> 	if (pmd_huge(*pmd) || !pmd_present(*pmd))
>>> 		return (pte_t *)pmd;
>>>
>>> 	return NULL;
>>>
>>> So it always returns a pointer into a PUD or PMD, while say, ppc
>>> in __find_linux_pte() ends like:
>>>
>>> 	return pte_offset_kernel(&pmd, ea);
>>>
>>> Which is pointing to a PTE
>>
>> Ok, now I understand the question.  huge_pte_offset will/should only be
>> called for addresses that are in a vma backed by hugetlb pages.  So,
>> pte_offset_kernel() will only return page table type (PUD/PMD/etc) associated
>> with a huge page supported by the particular arch.
> 
> I thought pte_offset_kernel always returns PTEs (ie the 4k entries on
> x86), I suppose what you are saying is that since the caller knows
> this is always a PUD or PMD due to the VMA the pte_offset is dead code.

Yes, for x86 the address will correspond to a PUD or PMD or NULL.  For huge
page mappings/vmas on x86, there are no corresponding PTEs.
-- 
Mike Kravetz
