Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8871A6E90
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 23:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgDMVtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 17:49:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53344 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgDMVte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 17:49:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DLhGGM120617;
        Mon, 13 Apr 2020 21:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TjE48uLAAq9aDU+ochnPRAc0jmvakJU8GSuxF56pjkI=;
 b=B75LEcVdiNgZJdi669mmZipTKtQAhSNz/JrFW6BUL7vB5ttlKUa1dsarz8y9nPO+sPON
 zwN1xTOeXpl/bvKpb/bXnGhDjSj7OblgBhqN0ZKNgJWU8OqlqkPHzLarv4Ljflnbx4Eg
 6uM+xEvAo37yiSdjWI8uVBDgMxegasYxEeH/atOICGkWqdLxobLFgc1C0hbms67JaLZJ
 nULXu4eNsLNlCSwRp/eN4ExDbLRnKyFd9rdKVMNZTfEoXajG+4qrGqVWH1r/OfBXEo8a
 GzLu69sJDw5pxEaW24cjnu29+YoGezJI23F4P3MInHa4AMsOyw8wvfTcdiZw5v7W4Dpt CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30b6hph25h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 21:49:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DLksnV086018;
        Mon, 13 Apr 2020 21:47:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30bqkygj2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 21:47:08 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03DLl4kW001157;
        Mon, 13 Apr 2020 21:47:05 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 14:47:04 -0700
Subject: Re: [PATCH v5] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset
To:     "Longpeng (Mike)" <longpeng2@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
References: <20200413010342.771-1-longpeng2@huawei.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <9d32dc1b-4b94-c118-64cf-5ec47ccedbc1@oracle.com>
Date:   Mon, 13 Apr 2020 14:47:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200413010342.771-1-longpeng2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130158
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/20 6:03 PM, Longpeng(Mike) wrote:
> From: Longpeng <longpeng2@huawei.com>
> 
> Our machine encountered a panic(addressing exception) after run
> for a long time and the calltrace is:
> RIP: 0010:[<ffffffff9dff0587>]  [<ffffffff9dff0587>] hugetlb_fault+0x307/0xbe0
> RSP: 0018:ffff9567fc27f808  EFLAGS: 00010286
> RAX: e800c03ff1258d48 RBX: ffffd3bb003b69c0 RCX: e800c03ff1258d48
> RDX: 17ff3fc00eda72b7 RSI: 00003ffffffff000 RDI: e800c03ff1258d48
> RBP: ffff9567fc27f8c8 R08: e800c03ff1258d48 R09: 0000000000000080
> R10: ffffaba0704c22a8 R11: 0000000000000001 R12: ffff95c87b4b60d8
> R13: 00005fff00000000 R14: 0000000000000000 R15: ffff9567face8074
> FS:  00007fe2d9ffb700(0000) GS:ffff956900e40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffd3bb003b69c0 CR3: 000000be67374000 CR4: 00000000003627e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  [<ffffffff9df9b71b>] ? unlock_page+0x2b/0x30
>  [<ffffffff9dff04a2>] ? hugetlb_fault+0x222/0xbe0
>  [<ffffffff9dff1405>] follow_hugetlb_page+0x175/0x540
>  [<ffffffff9e15b825>] ? cpumask_next_and+0x35/0x50
>  [<ffffffff9dfc7230>] __get_user_pages+0x2a0/0x7e0
>  [<ffffffff9dfc648d>] __get_user_pages_unlocked+0x15d/0x210
>  [<ffffffffc068cfc5>] __gfn_to_pfn_memslot+0x3c5/0x460 [kvm]
>  [<ffffffffc06b28be>] try_async_pf+0x6e/0x2a0 [kvm]
>  [<ffffffffc06b4b41>] tdp_page_fault+0x151/0x2d0 [kvm]
>  ...
>  [<ffffffffc06a6f90>] kvm_arch_vcpu_ioctl_run+0x330/0x490 [kvm]
>  [<ffffffffc068d919>] kvm_vcpu_ioctl+0x309/0x6d0 [kvm]
>  [<ffffffff9deaa8c2>] ? dequeue_signal+0x32/0x180
>  [<ffffffff9deae34d>] ? do_sigtimedwait+0xcd/0x230
>  [<ffffffff9e03aed0>] do_vfs_ioctl+0x3f0/0x540
>  [<ffffffff9e03b0c1>] SyS_ioctl+0xa1/0xc0
>  [<ffffffff9e53879b>] system_call_fastpath+0x22/0x27
> 
> For 1G hugepages, huge_pte_offset() wants to return NULL or pudp, but it
> may return a wrong 'pmdp' if there is a race. Please look at the following
> code snippet:
>     ...
>     pud = pud_offset(p4d, addr);
>     if (sz != PUD_SIZE && pud_none(*pud))
>         return NULL;
>     /* hugepage or swap? */
>     if (pud_huge(*pud) || !pud_present(*pud))
>         return (pte_t *)pud;
> 
>     pmd = pmd_offset(pud, addr);
>     if (sz != PMD_SIZE && pmd_none(*pmd))
>         return NULL;
>     /* hugepage or swap? */
>     if (pmd_huge(*pmd) || !pmd_present(*pmd))
>         return (pte_t *)pmd;
>     ...
> 
> The following sequence would trigger this bug:
> 1. CPU0: sz = PUD_SIZE and *pud = 0 , continue
> 1. CPU0: "pud_huge(*pud)" is false
> 2. CPU1: calling hugetlb_no_page and set *pud to xxxx8e7(PRESENT)
> 3. CPU0: "!pud_present(*pud)" is false, continue
> 4. CPU0: pmd = pmd_offset(pud, addr) and maybe return a wrong pmdp
> However, we want CPU0 to return NULL or pudp in this case.
> 
> We must make sure there is exactly one dereference of pud and pmd.
> 
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Longpeng <longpeng2@huawei.com>

Thank you for continuing to work this!

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz
