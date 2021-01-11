Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AB22F24D9
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390474AbhALAZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:25:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59750 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403789AbhAKXGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 18:06:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BMx6fb141323;
        Mon, 11 Jan 2021 23:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dcOf8/3HyGRDDIM8oEls4ruaz1euZ2/0IkDYmsCtANM=;
 b=ReDIvZTb7bpsQ4oUVRI1HZ0VymQTV4eOSh8XVIno0+y/NGuWN25iriRfs4cfHoNsabw9
 Fi8eThoenuFojfPvDg6Cvop+TP4+njl8Wlf1mtUEl/BNo1M59uXZ/slfA++m4I+6NBVS
 qATQu6dkV6k7/2lL+fZrlEL65Q3tzptDoU78CJYX/oCCTXOZqCbmGDToVe4NOPSRl8lq
 zuVYXJNrysw7XYtlMnZLyGwxIIJG7LS0ecgH0Y2bbdCQhBKmSDp9+m2oNI08Z5YRg5x8
 +YHTLyqgSf3jP19R7arT1AgqxhBAX3p44w7Z5t+HLjdSy6R/XtECkpHQI6Cd+g4Cy3XX Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 360kvjumfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Jan 2021 23:04:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BN0USs061107;
        Mon, 11 Jan 2021 23:04:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 360kefvh2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 23:04:48 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10BN4jZO016433;
        Mon, 11 Jan 2021 23:04:45 GMT
Received: from [192.168.2.112] (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Jan 2021 15:04:45 -0800
Subject: Re: [PATCH v3 2/6] mm: hugetlbfs: fix cannot migrate the fallocated
 HugeTLB page
To:     Muchun Song <songmuchun@bytedance.com>, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210110124017.86750-1-songmuchun@bytedance.com>
 <20210110124017.86750-3-songmuchun@bytedance.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <3ee2bcf5-35cf-1062-433d-56b4c7f011a0@oracle.com>
Date:   Mon, 11 Jan 2021 15:04:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20210110124017.86750-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/21 4:40 AM, Muchun Song wrote:
> If a new hugetlb page is allocated during fallocate it will not be
> marked as active (set_page_huge_active) which will result in a later
> isolate_huge_page failure when the page migration code would like to
> move that page. Such a failure would be unexpected and wrong.
> 
> Only export set_page_huge_active, just leave clear_page_huge_active
> as static. Because there are no external users.
> 
> Fixes: 70c3547e36f5 (hugetlbfs: add hugetlbfs_fallocate())
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/hugetlbfs/inode.c    | 3 ++-
>  include/linux/hugetlb.h | 2 ++
>  mm/hugetlb.c            | 2 +-
>  3 files changed, 5 insertions(+), 2 deletions(-)

Thanks.

Although page_huge_active is declared in page-flags.h, I much prefer the
declaration of set_page_huge_active to be in hugetlb.c.

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz
