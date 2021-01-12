Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8F42F2539
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbhALBHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 20:07:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59594 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbhALBHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 20:07:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10C0tFqG123361;
        Tue, 12 Jan 2021 01:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mFqrnSeeppp4IlQAsxcEuSyGYMsDTE4txPRCpOR+hbY=;
 b=VMGVpGMlKHN8saPS3Iet2FkeYzteeqZ0bpLToxW6XwUeW+ppyQz1gsFjDi7InhSWTkGj
 wCdGg2Ie4w/xoqBvOq3ypy+snlFNc5vK88vxrygvReWfpC/bymOnj3S4Ji+n8wALB8lg
 NuPpgE4vjHmipW13vKb2sc0+G7WR/6VKLLeEvePR3BmRVVMpWwQJGUHkjy/w/15FRfJY
 HtehlDODxrVoM0/UOHsCYfjdPGAZyMRbKiuXIHjTAa23wb69V74cIeuKaQbnM71akMXC
 DTNJCJeofBdYNq6FiByw2kRHM2EaOrDVqaAutfrffykwW2XwG6nVkk1g0oDH73XwYoXj uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvjuvgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Jan 2021 01:06:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10C0tcOv025629;
        Tue, 12 Jan 2021 01:06:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 360ke5t8fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 01:06:21 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10C16Hm2017380;
        Tue, 12 Jan 2021 01:06:17 GMT
Received: from [192.168.2.112] (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Jan 2021 17:06:17 -0800
Subject: Re: [PATCH v3 3/6] mm: hugetlb: fix a race between freeing and
 dissolving the page
To:     Muchun Song <songmuchun@bytedance.com>, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210110124017.86750-1-songmuchun@bytedance.com>
 <20210110124017.86750-4-songmuchun@bytedance.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <5b4ccddf-d5f6-689d-5056-7ad4710792aa@oracle.com>
Date:   Mon, 11 Jan 2021 17:06:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20210110124017.86750-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120001
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/21 4:40 AM, Muchun Song wrote:
> There is a race condition between __free_huge_page()
> and dissolve_free_huge_page().
> 
> CPU0:                         CPU1:
> 
> // page_count(page) == 1
> put_page(page)
>   __free_huge_page(page)
>                               dissolve_free_huge_page(page)
>                                 spin_lock(&hugetlb_lock)
>                                 // PageHuge(page) && !page_count(page)
>                                 update_and_free_page(page)
>                                 // page is freed to the buddy
>                                 spin_unlock(&hugetlb_lock)
>     spin_lock(&hugetlb_lock)
>     clear_page_huge_active(page)
>     enqueue_huge_page(page)
>     // It is wrong, the page is already freed
>     spin_unlock(&hugetlb_lock)
> 
> The race windows is between put_page() and dissolve_free_huge_page().
> 
> We should make sure that the page is already on the free list
> when it is dissolved.
> 
> Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/hugetlb.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)

Thanks,

It is unfortunate that we have to add more huge page state information
to fix this issue.  However, I believe we have explored all other options.

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz
