Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8E718FB74
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 18:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgCWR2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 13:28:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50022 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgCWR2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 13:28:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NHOM0A135226;
        Mon, 23 Mar 2020 17:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0W36mKXR8dI8W6580WJSeXTMIu4rnf7ZVMgMB4QK/yA=;
 b=nlvazGfwrgieAp50GxGSPba1CgOnLmgI32F+ViNfApFCZweBCh2Ky/DZi0rhjippPRX5
 IxqbvNJD6bjZAtSmxBbNtC+vUWIU313nPgImQ2uJQXtGfJ6lt45XvzK27xm+O2frN2It
 WtKyjy6JSzJHOi/JZ+KvdpTCsEEh164PvarY9j99CccKghMEJYPma/ZKzd5yYokz/nRA
 Gb+/nFuREBQemarlXWr9cq3PkA9jpFMFTo7HmMOKIgeUvMBxd5WSsDjhlHbdmp6Ocia8
 Jrk/uTBuLZSA12Ev5HKUHlPUt6jIO9ui5m1bU1P7FnSyY8zDZ1o7EBZR2A7vbV/MvUkV TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yx8abvwtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 17:27:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NHLO5q003163;
        Mon, 23 Mar 2020 17:27:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yxw915dxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 17:27:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02NHRnYS000750;
        Mon, 23 Mar 2020 17:27:50 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Mar 2020 10:27:49 -0700
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
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
Date:   Mon, 23 Mar 2020 10:27:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200323160955.GY20941@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=942 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003230091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=981
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230091
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/23/20 9:09 AM, Jason Gunthorpe wrote:
> On Sat, Mar 21, 2020 at 04:38:19PM -0700, Mike Kravetz wrote:
> 
>> Andrew dropped this patch from his tree which caused me to go back and
>> look at the status of this patch/issue.
>>
>> It is pretty obvious that code in the current huge_pte_offset routine
>> is racy.  I checked out the assembly code produced by my compiler and
>> verified that the line,
>>
>> 	if (pud_huge(*pud) || !pud_present(*pud))
>>
>> does actually dereference *pud twice.  So, the value could change between
>> those two dereferences.   Longpeng (Mike) could easlily recreate the issue
>> if he put a delay between the two dereferences.  I believe the only
>> reservations/concerns about the patch below was the use of READ_ONCE().
>> Is that correct?
> 
> I'm looking at a similar situation in pagewalk.c right now with PUD,
> and it is very confusing to see that locks are being held, memory
> accessed without READ_ONCE, but actually it has concurrent writes.
> 
> I think it is valuable to annotate with READ_ONCE when the author
> knows this is an unlocked data access, regardless of what the compiler
> does.
> 
> pagewalk probably has the same racy bug you show here, I'm going to
> send a very similar looking patch to pagewalk hopefully soon.

Thanks Jason.

Unfortunately, I replied to the thread without full context for the discussion
we were having.  The primary objection to this patch was the use of READ_ONCE
in these two instances:

>  	pgd = pgd_offset(mm, addr);
> -	if (!pgd_present(*pgd))
> +	if (!pgd_present(READ_ONCE(*pgd)))
>  		return NULL;
>  	p4d = p4d_offset(pgd, addr);
> -	if (!p4d_present(*p4d))
> +	if (!p4d_present(READ_ONCE(*p4d)))
>  		return NULL;
>  
>       pud = pud_offset(p4d, addr);

One would argue that pgd and p4d can not change from present to !present
during the execution of this code.  To me, that seems like the issue which
would cause an issue.  Of course, I could be missing something.

> Also, the remark about pmd_offset() seems accurate. The
> get_user_fast_pages() pattern seems like the correct one to emulate:
> 
>   pud = READ_ONCE(*pudp);
>   if (pud_none(pud)) 
>      ..
>   if (!pud_'is a pmd pointer')
>      ..
>   pmdp = pmd_offset(&pud, address);
>   pmd = READ_ONCE(*pmd);
>   [...]
> 
> Passing &pud in avoids another de-reference of the pudp. Honestly all
> these APIs that take in page table pointers and internally
> de-reference them seem very hard to use correctly when the page table
> access isn't fully locked against write.
> 
> This also relies on 'some kind of locking' to prevent the pmdp from
> becoming freed concurrently while this is running.
> 
> .. also this only works if READ_ONCE() is atomic, ie the pud can't be
> 64 bit on a 32 bit platform. At least pmd has this problem, I haven't
> figured out if pud does??
> 
>> Are there any objections to the patch if the READ_ONCE() calls are removed?
> 
> I think if we know there is no concurrent data access then it makes
> sense to keep the READ_ONCE.
> 
> It looks like at least the p4d read from the pgd is also unlocked here
> as handle_mm_fault() writes to it??

Yes, there is no locking required to call huge_pte_offset().

-- 
Mike Kravetz
