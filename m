Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D802D66B20
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 12:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfGLKxu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 12 Jul 2019 06:53:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2420 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbfGLKxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 06:53:49 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id BF800D2E2BFB2E395BE4;
        Fri, 12 Jul 2019 18:53:46 +0800 (CST)
Received: from dggeme757-chm.china.huawei.com (10.3.19.103) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 12 Jul 2019 18:53:46 +0800
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 dggeme757-chm.china.huawei.com (10.3.19.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 12 Jul 2019 18:53:45 +0800
Received: from dggeme758-chm.china.huawei.com ([10.6.80.69]) by
 dggeme758-chm.china.huawei.com ([10.6.80.69]) with mapi id 15.01.1591.008;
 Fri, 12 Jul 2019 18:53:46 +0800
From:   "chenjianhong (A)" <chenjianhong2@huawei.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Michel Lespinasse <walken@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        "jannh@google.com" <jannh@google.com>,
        "steve.capper@arm.com" <steve.capper@arm.com>,
        "tiny.windzz@gmail.com" <tiny.windzz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "wangle (H)" <wangle6@huawei.com>,
        "Chengang (L)" <cg.chen@huawei.com>
Subject: RE: [PATCH] mm/mmap: fix the adjusted length error
Thread-Topic: [PATCH] mm/mmap: fix the adjusted length error
Thread-Index: AQHVDHYdPcl0kS4eg0Wb8Sh+xIS/waZvfcqAgADBHlCAVcHrAIAAiW9w
Date:   Fri, 12 Jul 2019 10:53:45 +0000
Message-ID: <71c4329e246344eeb38c8ac25c63c09d@huawei.com>
References: <1558073209-79549-1-git-send-email-chenjianhong2@huawei.com>
        <CANN689G6mGLSOkyj31ympGgnqxnJosPVc4EakW5gYGtA_45L7g@mail.gmail.com>
        <df001b6fbe2a4bdc86999c78933dab7f@huawei.com>
 <20190711182002.9bb943006da6b61ab66b95fd@linux-foundation.org>
In-Reply-To: <20190711182002.9bb943006da6b61ab66b95fd@linux-foundation.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.65.79.126]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thank you for your reply! 
> How significant is this problem in real-world use cases?  How much trouble is it causing?
   In my opinion, this problem is very rare in real-world use cases. In arm64
   or x86 environment, the virtual memory is enough. In arm32 environment,
   each process has only 3G or 4G or less, but we seldom use out all of the virtual memory,
   it only happens in some special environment. They almost use out all the virtual memory, and
   in some moment, they will change their working mode so they will release and allocate
   memory again. This current length limitation will cause this problem. I explain it's the memory
   length limitation. But they can't accept the reason, it is unreasonable that we fail to allocate
   memory even though the memory gap is enough.

> Have you looked further into this?  Michel is concerned about the performance cost of the current solution.
   The current algorithm(change before) is wonderful, and it has been used for a long time, I don't
   think it is worthy to change the whole algorithm in order to fix this problem. Therefore, I just
   adjust the gap_start and gap_end value in place of the length. My change really affects the
   performance because I calculate the gap_start and gap_end value again and again. Does it affect
   too much performance?  I have no complex environment, so I can't test it, but I don't think it will cause
   too much performance loss. First, I don't change the whole algorithm. Second, unmapped_area and
   unmapped_area_topdown function aren't used frequently. Maybe there are some big performance problems
   I'm not concerned about. But I think if that's not a problem, there should be a limitation description.

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Friday, July 12, 2019 9:20 AM
To: chenjianhong (A) <chenjianhong2@huawei.com>
Cc: Michel Lespinasse <walken@google.com>; Greg Kroah-Hartman <gregkh@linuxfoundation.org>; mhocko@suse.com; Vlastimil Babka <vbabka@suse.cz>; Kirill A. Shutemov <kirill.shutemov@linux.intel.com>; Yang Shi <yang.shi@linux.alibaba.com>; jannh@google.com; steve.capper@arm.com; tiny.windzz@gmail.com; LKML <linux-kernel@vger.kernel.org>; linux-mm <linux-mm@kvack.org>; stable@vger.kernel.org; willy@infradead.org
Subject: Re: [PATCH] mm/mmap: fix the adjusted length error

On Sat, 18 May 2019 07:05:07 +0000 "chenjianhong (A)" <chenjianhong2@huawei.com> wrote:

> I explain my test code and the problem in detail. This problem is 
> found in 32-bit user process, because its virtual is limited, 3G or 4G.
> 
> First, I explain the bug I found. Function unmapped_area and 
> unmapped_area_topdowns adjust search length to account for worst case 
> alignment overhead, the code is ' length = info->length + info->align_mask; '.
> The variable info->length is the length we allocate and the variable
> info->align_mask accounts for the alignment, because the gap_start  or 
> info->gap_end
> value also should be an alignment address, but we can't know the alignment offset.
> So in the current algorithm, it uses the max alignment offset, this 
> value maybe zero or other(0x1ff000 for shmat function).
> Is it reasonable way? The required value is longer than what I allocate.
> What's more,  why for the first time I can allocate the memory 
> successfully Via shmat, but after releasing the memory via shmdt and I 
> want to attach again, it fails. This is not acceptable for many people.
> 
> Second, I explain my test code. The code I have sent an email. The 
> following is the step. I don't think it's something unusual or 
> unreasonable, because the virtual memory space is enough, but the 
> process can allocate from it. And we can't pass explicit addresses to 
> function mmap or shmat, the address is getting from the left vma gap.
>  1, we allocat large virtual memory;
>  2, we allocate hugepage memory via shmat, and release one  of the 
> hugepage memory block;  3, we allocate hugepage memory by shmat again, 
> this will fail.

How significant is this problem in real-world use cases?  How much trouble is it causing?

> Third, I want to introduce my change in the current algorithm. I don't 
> change the current algorithm. Also, I think there maybe a better way 
> to fix this error. Nowadays, I can just adjust the gap_start value.

Have you looked further into this?  Michel is concerned about the performance cost of the current solution.

