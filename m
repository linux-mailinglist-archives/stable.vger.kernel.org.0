Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6576531F1CD
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 22:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhBRVod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 16:44:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40620 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBRVob (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 16:44:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ILNggE152465;
        Thu, 18 Feb 2021 21:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9bDhzuwtJydPK3jDTF/9/JzVxW4gyP+1o+FR3dSelLo=;
 b=J91JPmuyCRWzpLsM7aly31rH1+URGwKo/4oqM1Mc2cPGXcJsON58KKnLyQfqf/F7rcLN
 4/GfcBLWXN5BiToGIKlgRzI5x+Ebnu9oGGpurWeqBVwz7zM1hDcW7vbDukma7Hc2JCbG
 UYWhYHeB0T7lkKNl5yQ4U4XzMqwvRwZrwgZ5qMWiimuRxlvJt0qmV7PfsznUl7BAgOR5
 BGTg/Re1clzYA9BaVwLlTKrC8/Y8HE7EKnOQHoOZknJCtDaqe66sccsdE3ZzA0y4G4qE
 IAbJAEq7HwSSReSHtiUx7b3tS+Wjf04d+IpLpIrvIGCxivshfolcNDF+0vqTp5FuWps1 ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9af0pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 21:43:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ILeBH9008615;
        Thu, 18 Feb 2021 21:43:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 36prq129m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 21:43:32 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11ILhRxe006761;
        Thu, 18 Feb 2021 21:43:27 GMT
Received: from [192.168.2.112] (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Feb 2021 13:43:26 -0800
Subject: Re: [PATCH 1/2] hugetlb: fix update_and_free_page contig page struct
 assumption
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        stable@vger.kernel.org
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
 <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
 <20210218144554.GS2858050@casper.infradead.org>
 <20210218172500.GA4718@ziepe.ca>
 <cc94992a-0eff-bf5e-d904-b23d5facfca3@oracle.com>
Message-ID: <b7f5944f-c4dd-53d7-2613-1f2f891968e9@oracle.com>
Date:   Thu, 18 Feb 2021 13:43:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <cc94992a-0eff-bf5e-d904-b23d5facfca3@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180179
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180178
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/21 9:34 AM, Mike Kravetz wrote:
> On 2/18/21 9:25 AM, Jason Gunthorpe wrote:
>> On Thu, Feb 18, 2021 at 02:45:54PM +0000, Matthew Wilcox wrote:
>>> On Wed, Feb 17, 2021 at 11:02:52AM -0800, Andrew Morton wrote:
>>>> On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>>>> page structs are not guaranteed to be contiguous for gigantic pages.  The
>>>>
>>>> June 2014.  That's a long lurk time for a bug.  I wonder if some later
>>>> commit revealed it.
>>>
>>> I would suggest that gigantic pages have not seen much use.  Certainly
>>> performance with Intel CPUs on benchmarks that I've been involved with
>>> showed lower performance with 1GB pages than with 2MB pages until quite
>>> recently.
>>
>> I suggested in another thread that maybe it is time to consider
>> dropping this "feature"
>>
>> If it has been slightly broken for 7 years it seems a good bet it
>> isn't actually being used.
>>
>> The cost to fix GUP to be compatible with this will hurt normal
>> GUP performance - and again, that nobody has hit this bug in GUP
>> further suggests the feature isn't used..
> 
> I was thinking that we could detect these 'unusual' configurations and only
> do the slower page struct walking in those cases.  However, we would need to
> do some research to make sure we have taken into account all possible config
> options which can produce non-contiguous page structs.  That should have zero
> performance impact in the 'normal' cases.

What about something like the following patch, and making all code that
wants to scan gigantic page subpages use mem_map_next()?

From 95b0384bd5d7f0435546bdd3c01c478724ae0166 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Thu, 18 Feb 2021 13:35:02 -0800
Subject: [PATCH] mm: define PFN_PAGE_MAP_LINEAR to optimize gigantic page
 scans

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 arch/ia64/include/asm/page.h       | 1 +
 arch/m68k/include/asm/page_no.h    | 1 +
 include/asm-generic/memory_model.h | 2 ++
 mm/internal.h                      | 2 ++
 4 files changed, 6 insertions(+)

diff --git a/arch/ia64/include/asm/page.h b/arch/ia64/include/asm/page.h
index b69a5499d75b..8f4288862ec8 100644
--- a/arch/ia64/include/asm/page.h
+++ b/arch/ia64/include/asm/page.h
@@ -106,6 +106,7 @@ extern struct page *vmem_map;
 #ifdef CONFIG_DISCONTIGMEM
 # define page_to_pfn(page)	((unsigned long) (page - vmem_map))
 # define pfn_to_page(pfn)	(vmem_map + (pfn))
+# define PFN_PAGE_MAP_LINEAR
 # define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
 #else
 # include <asm-generic/memory_model.h>
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index 6bbe52025de3..cafc0731a42c 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -28,6 +28,7 @@ extern unsigned long memory_end;
 
 #define pfn_to_page(pfn)	virt_to_page(pfn_to_virt(pfn))
 #define page_to_pfn(page)	virt_to_pfn(page_to_virt(page))
+#define PFN_PAGE_MAP_LINEAR
 #define pfn_valid(pfn)	        ((pfn) < max_mapnr)
 
 #define	virt_addr_valid(kaddr)	(((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index 7637fb46ba4f..8ac4c48dbf22 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -33,6 +33,7 @@
 #define __pfn_to_page(pfn)	(mem_map + ((pfn) - ARCH_PFN_OFFSET))
 #define __page_to_pfn(page)	((unsigned long)((page) - mem_map) + \
 				 ARCH_PFN_OFFSET)
+#define PFN_PAGE_MAP_LINEAR
 #elif defined(CONFIG_DISCONTIGMEM)
 
 #define __pfn_to_page(pfn)			\
@@ -53,6 +54,7 @@
 /* memmap is virtually contiguous.  */
 #define __pfn_to_page(pfn)	(vmemmap + (pfn))
 #define __page_to_pfn(page)	(unsigned long)((page) - vmemmap)
+#define PFN_PAGE_MAP_LINEAR
 
 #elif defined(CONFIG_SPARSEMEM)
 /*
diff --git a/mm/internal.h b/mm/internal.h
index 25d2b2439f19..64cc5069047c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -454,12 +454,14 @@ static inline struct page *mem_map_offset(struct page *base, int offset)
 static inline struct page *mem_map_next(struct page *iter,
 						struct page *base, int offset)
 {
+#ifndef PFN_PAGE_MAP_LINEAR
 	if (unlikely((offset & (MAX_ORDER_NR_PAGES - 1)) == 0)) {
 		unsigned long pfn = page_to_pfn(base) + offset;
 		if (!pfn_valid(pfn))
 			return NULL;
 		return pfn_to_page(pfn);
 	}
+#endif
 	return iter + 1;
 }
 
-- 
2.29.2

