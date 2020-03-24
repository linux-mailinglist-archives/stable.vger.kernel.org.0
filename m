Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC3619161E
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 17:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgCXQUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 12:20:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgCXQUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 12:20:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OGEe2o178890;
        Tue, 24 Mar 2020 16:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8+/c9w3BgxRJLSrj2uF9AmceMm8c9V83O9Cmas+6qpw=;
 b=r2u8CeTqtFkN2tBlnu64WUaXJv8VkQH2VTfXx7kCYGVemUCoz6Dl3XQVQpEYpTzXPqoo
 KQU5r/lfIJLCpdXfNuvR2j+Jvx6QAWFncs4keyDbOtjXja4HZVht0ckCecUcp6pZcSfM
 H7zRqz5F2HadZRnH6zsx+kAmglRI1zxkSZBKJAcT55fPgoJK2ocBq/L2URhduLlwsBGB
 h9iqo7yYppWkIHeP1uSzUidUehGKJ3jKA2eucbquHTP16FRRs/wMHykjIsr+JYFm3QD/
 FxzlFVtjd58/y6ISSFeVYMzCQ6HK+Xenb4Xa0DYUARFzP9SI49hT+QlLcUSGzy622IV5 xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yx8ac293t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 16:19:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OGJhPk185489;
        Tue, 24 Mar 2020 16:19:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yxw6n17rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 16:19:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02OGJVTZ018297;
        Tue, 24 Mar 2020 16:19:31 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 09:19:31 -0700
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
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <20200323160955.GY20941@ziepe.ca>
 <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
 <20200323180706.GC20941@ziepe.ca>
 <88698dd7-eb87-4b0b-7ba7-44ef6eab6a6c@oracle.com>
 <20200323225225.GF20941@ziepe.ca>
 <e8e71ba4-d609-269a-6160-153e373e7563@huawei.com>
 <20200324115541.GH20941@ziepe.ca>
 <98d35563-8af0-2693-7e76-e6435da0bbee@oracle.com>
 <20200324155552.GK20941@ziepe.ca>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <66583587-ca4f-9847-c173-4a3d7938fec6@oracle.com>
Date:   Tue, 24 Mar 2020 09:19:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200324155552.GK20941@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240087
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/20 8:55 AM, Jason Gunthorpe wrote:
> On Tue, Mar 24, 2020 at 08:25:09AM -0700, Mike Kravetz wrote:
>> On 3/24/20 4:55 AM, Jason Gunthorpe wrote:
>>> Also, since CH moved all the get_user_pages_fast code out of the
>>> arch's many/all archs can drop their arch specific version of this
>>> routine. This is really just a specialized version of gup_fast's
>>> algorithm..
>>>
>>> (also the arch versions seem different, why do some return actual
>>>  ptes, not null?)
>>
>> Not sure I understand that last question.  The return value should be
>> a *pte or null.
> 
> I mean the common code ends like this:
> 
> 	pmd = pmd_offset(pud, addr);
> 	if (sz != PMD_SIZE && pmd_none(*pmd))
> 		return NULL;
> 	/* hugepage or swap? */
> 	if (pmd_huge(*pmd) || !pmd_present(*pmd))
> 		return (pte_t *)pmd;
> 
> 	return NULL;
> 
> So it always returns a pointer into a PUD or PMD, while say, ppc
> in __find_linux_pte() ends like:
> 
> 	return pte_offset_kernel(&pmd, ea);
> 
> Which is pointing to a PTE

Ok, now I understand the question.  huge_pte_offset will/should only be
called for addresses that are in a vma backed by hugetlb pages.  So,
pte_offset_kernel() will only return page table type (PUD/PMD/etc) associated
with a huge page supported by the particular arch.

> So does sparc:
> 
>         pmd = pmd_offset(pud, addr);
>         if (pmd_none(*pmd))
>                 return NULL;
>         if (is_hugetlb_pmd(*pmd))
>                 return (pte_t *)pmd;
>         return pte_offset_map(pmd, addr);
> 
> Which is even worse because it is leaking a kmap..
> 
> etc
> 
>> /*
>>  * huge_pte_offset() - Walk the page table to resolve the hugepage
>>  * entry at address @addr
>>  *
>>  * Return: Pointer to page table or swap entry (PUD or PMD) for
>                                               ^^^^^^^^^^^^^^^^^^^
> 
> Ie the above is not followed by the archs
> 
> I'm also scratching my head that a function that returns a pte_t *
> always returns a PUD or PMD. Strange bit of type casting..

Yes, the casting is curious.  The casting continues in potential subsequent
calls to huge_pte_alloc().
-- 
Mike Kravetz
