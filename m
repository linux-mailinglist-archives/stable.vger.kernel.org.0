Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB722F3978
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbhALTDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:03:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49560 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406508AbhALTDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 14:03:24 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CIsxP1031755;
        Tue, 12 Jan 2021 14:02:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wgt5iAjT3dQ4/lFwAY3eQTk2ZLrzz5N5osAZFQK7Pjw=;
 b=kGmmErgax4hA67K4zsa69ctfyq0zFFmqR14DN8lJhmddYev3bFDJ9VdZQPqv3HtqfDj2
 Ogp1DcwqJa8M+VI+RG6Ke83+/BLXglzlgqSPhO1qgU5MlyVlE293EVJD/dbhyn0k+9vk
 X/5Bb77VuLnKHsTE0NVMjOY0v77LcmvbQ2HQHL1Hwds8BT5RCXdENpnaXpZjg40H9p4q
 s3s7MsiOx53OWX/suzh0YmvjUAG4RwaSp9aKqKWfrjqnAJIi/uWqoYTmtZoKngFbdQxk
 OzUypc0eb7yUPcEMZkVLJ6n8Jpp4oMwjPAGSyzTa9Sormi1jCopNWvXiG3CfTICABGw9 /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361hfg06nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 14:02:30 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CItVKr033448;
        Tue, 12 Jan 2021 14:02:29 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361hfg06mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 14:02:29 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CJ2N03003589;
        Tue, 12 Jan 2021 19:02:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448c20c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 19:02:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CJ2K0T31850854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 19:02:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3197552050;
        Tue, 12 Jan 2021 19:02:25 +0000 (GMT)
Received: from pomme.local (unknown [9.145.179.152])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 903B852059;
        Tue, 12 Jan 2021 19:02:24 +0000 (GMT)
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>, Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>, surenb@google.com
References: <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
From:   Laurent Dufour <ldufour@linux.vnet.ibm.com>
Message-ID: <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
Date:   Tue, 12 Jan 2021 20:02:24 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_15:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=978 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120108
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 12/01/2021 à 17:57, Peter Zijlstra a écrit :
> On Tue, Jan 12, 2021 at 04:47:17PM +0100, Laurent Dufour wrote:
>> Le 12/01/2021 à 12:43, Vinayak Menon a écrit :
> 
>>> Possibility of race against other PTE modifiers
>>>
>>> 1) Fork - We have seen a case of SPF racing with fork marking PTEs RO and that
>>> is described and fixed here https://lore.kernel.org/patchwork/patch/1062672/
> 
> Right, that's exactly the kind of thing I was worried about.
> 
>>> 2) mprotect - change_protection in mprotect which does the deferred flush is
>>> marked under vm_write_begin/vm_write_end, thus SPF bails out on faults
>>> on those VMAs.
> 
> Sure, mprotect also changes vm_flags, so it really needs that anyway.
> 
>>> 3) userfaultfd - mwriteprotect_range is not protected unlike in (2) above.
>>> But SPF does not take UFFD faults.
>>> 4) hugetlb - hugetlb_change_protection - called from mprotect and covered by
>>> (2) above.
> 
>>> 5) Concurrent faults - SPF does not handle all faults. Only anon page faults.
> 
> What happened to shared/file-backed stuff? ISTR I had that working.

File-backed mappings are not processed in a speculative way, there were options 
to manage some of them depending on the underlying file system but that's still 
not done.

Shared anonymous mapping, are also not yet handled in a speculative way (vm_ops 
is not null).

>>> Of which do_anonymous_page and do_swap_page are NONE/NON-PRESENT->PRESENT
>>> transitions without tlb flush. And I hope do_wp_page with RO->RW is fine as well.
> 
> The tricky one is demotion, specifically write to non-write.
> 
>>> I could not see a case where speculative path cannot see a PTE update done via
>>> a fault on another CPU.
> 
> One you didn't mention is the NUMA balancing scanning crud; although I
> think that's fine, loosing a PTE update there is harmless. But I've not
> thought overly hard on it.

That's a good point, I need to double check on that side.

>> You explained it fine. Indeed SPF is handling deferred TLB invalidation by
>> marking the VMA through vm_write_begin/end(), as for the fork case you
>> mentioned. Once the PTL is held, and the VMA's seqcount is checked, the PTE
>> values read are valid.
> 
> That should indeed work, but are we really sure we covered them all?
> Should we invest in better TLBI APIs to make sure we can't get this
> wrong?

That may be a good option to identify deferred TLB invalidation but I've no clue 
on what this API would look like.
