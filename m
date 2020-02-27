Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910E3172A53
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 22:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgB0VmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 16:42:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729813AbgB0VmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 16:42:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RLdT9K001160;
        Thu, 27 Feb 2020 21:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sz3JDAysielxn6T2+wpmciuqWFvOq9Y62Xr0v5KTiNU=;
 b=pEp70LgOkQIQpH9jrE4EV/ydQ28ez2Ad/LN9TUPk8U/KBFMZEqF3Ak0oTaSJB7vYKCZ+
 gM/LDOj92TLG6QoF+SwNA2R8FAHs03C6gvKzFGO/S0FR4qkEZgWIMKvd0l/5/pPRQPqp
 cNXeYhLhicwdfFvaso2D+PPEjI/xdd97aN6Kd2sruSblD93yQZlw+W+4LeriwmdJcWCF
 VgmCIsWRuRZaLpzLNgXTEE1/EPXJ6qewz1HM3KnVYgPaC/gq0SthvRDDe91sejntZpKc
 88010j0vryi04DNt02JCqN3MwjKnoJuDJJLdAs9t7tuZR5br+rZ2psBOpqLlNHbxawmc EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ydcsnnuc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 21:41:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RLalCc131406;
        Thu, 27 Feb 2020 21:41:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ydcsdeqy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 21:41:55 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01RLfmSZ031235;
        Thu, 27 Feb 2020 21:41:49 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 13:41:48 -0800
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
To:     "Longpeng (Mike)" <longpeng2@huawei.com>,
        Matthew Wilcox <willy@infradead.org>, Qian Cai <cai@lca.pw>
Cc:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
References: <C4ED630A-FAD8-4998-A0A3-9C36F3303379@lca.pw>
 <f274b368-6fdb-2ae3-160e-fd8b105b9ac4@huawei.com>
 <20200222170222.GJ24185@bombadil.infradead.org>
 <dfbfbf46-483a-808f-d197-388f75569d9c@huawei.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <1b61f55a-d825-5721-2bfe-5e0efc9c9c2d@oracle.com>
Date:   Thu, 27 Feb 2020 13:41:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <dfbfbf46-483a-808f-d197-388f75569d9c@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=27 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=27 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270143
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/20 5:24 PM, Longpeng (Mike) wrote:
> 在 2020/2/23 1:02, Matthew Wilcox 写道:
>> On Sat, Feb 22, 2020 at 02:33:10PM +0800, Longpeng (Mike) wrote:
>>> 在 2020/2/22 13:23, Qian Cai 写道:
>>>>> On Feb 21, 2020, at 10:34 PM, Longpeng(Mike) <longpeng2@huawei.com> wrote:
>>>>>
>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>> index dd8737a..90daf37 100644
>>>>> --- a/mm/hugetlb.c
>>>>> +++ b/mm/hugetlb.c
>>>>> @@ -4910,28 +4910,30 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
>>>>> {
>>>>>    pgd_t *pgd;
>>>>>    p4d_t *p4d;
>>>>> -    pud_t *pud;
>>>>> -    pmd_t *pmd;
>>>>> +    pud_t *pud, pud_entry;
>>>>> +    pmd_t *pmd, pmd_entry;
>>>>>
>>>>>    pgd = pgd_offset(mm, addr);
>>>>> -    if (!pgd_present(*pgd))
>>>>> +    if (!pgd_present(READ_ONCE(*pgd)))
>>>>>        return NULL;
>>>>>    p4d = p4d_offset(pgd, addr);
>>>>> -    if (!p4d_present(*p4d))
>>>>> +    if (!p4d_present(READ_ONCE(*p4d)))
>>>>>        return NULL;
>>>>
>>>> What’s the point of READ_ONCE() on those two places?
>>>>
>>> As explained in the commit messages, it's for safe(e.g. avoid the compilier
>>> mischief). You can also find the same usage in the ARM64's huge_pte_offset() in
>>> arch/arm64/mm/hugetlbpage.c
>>
>> I rather agree with Qian; if we need something like READ_ONCE() here,
>> why don't we always need it as part of pgd_present()?  It seems like an
>> unnecessary burden for every user.
>>
> Hi Matthew & Qian,
> 
> Firstly, this is NOT a 'blindly copy', it's an unwise words. I don't know
> whether you read the commit message (commit 20a004e7) of ARM64's huge_pte_offset
> ? If you read, I think worry about the safe is necessary.
> 
> Secondly, huge_pte_offset in mm/hugetlb.c is for ARCH_WANT_GENERAL_HUGETLB, many
> architectures use it, can you make sure there is no issue on all the
> architectures using it with all the version of gcc ?
> 
> Thirdly, there are several places use READ_ONCE to access the page table in mm/*
> (e.g. gup_pmd_range), they're also generical for all architectures, and they're
> much more like unnecessary than here, so why there can use but not here? What's
> more, you can read this commit 688272809.

Apologies for the late reply.

In commit 20a004e7 the message says that "Whilst there are some scenarios
where this cannot happen ... the overhead of using READ_ONCE/WRITE_ONCE
everywhere is minimal and makes the code an awful lot easier to reason about."
Therefore, a decision was made to ALWAYS use READ_ONCE in the arm64 code
whether or not it was absolutely necessary.  Therefore, I do not think
we can assume all the READ_ONCE additions made in 20a004e7 are necessary.
Then the question remains, it it necessary in two statements above?
I do not believe it is necessary.  Why?  In the statements,
	if (!pgd_present(*pgd))
and
	if (!p4d_present(*p4d))
the variables are only accessed and dereferenced once.  I can not imagine
any way in which the compiler could perform multiple accesses of the variable.

I do believe the READ_ONCE in code accessing the pud and pmd is necessary.
This is because the variables (pud_entry or pmd_entry) are accessed more than
once.  And, I could imagine some strange compiler optimization where it would
dereference the pud or pmd pointer more than once.  For this same reason
(multiple accesses), I believe the READ_ONCE was added in commit 688272809.

I am no expert in this area, so corrections/comments appreciated.

BTW, I still think there may be races present in lookup_address_in_pgd().
Multiple dereferences of a p4d, pud and pmd are done.
-- 
Mike Kravetz
