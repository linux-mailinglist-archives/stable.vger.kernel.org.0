Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB2923B0A1
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 01:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgHCXBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 19:01:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgHCXBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 19:01:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 073MvwD1144602;
        Mon, 3 Aug 2020 23:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=E0GKLnLPkLgbmbdNCW1tpyfjn343QfKzawDvG83iUPQ=;
 b=ACOBYWjwRJYSLKMLuZAP6zOqGxzP313nnbnv1A3elKctp6Z/mGmfTWQd1LwMJZUvU8c2
 a2pvVUxl3TVbEHuQbw4f9Bm57dHOlLEDA2oNbXSnNILlfU05BA7lTtn0RfkAnlib5q0U
 eUN5KX/q9gLS1f8e2SuLVsczgTk8VfS42JzGM2ZvLyZ49iZeavkS3YLyL8s9slUrlQUj
 gTpyc6M8cHiKH0jQ/g/K0cMCJLbL8w//efpdZc41OBSM/brQNGgJH3xmcENYRsGWZgi5
 lhmW5u1jHweqGNiFBGBlDJjKQ4/8eE95h67hwlAidTqZGl7EuQuoBMgUuUBcvtYPiuyw 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32n11n151a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Aug 2020 23:00:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 073Mx5qK012948;
        Mon, 3 Aug 2020 23:00:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32p5grce4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Aug 2020 23:00:58 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 073N0suD006631;
        Mon, 3 Aug 2020 23:00:54 GMT
Received: from [192.168.2.112] (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Aug 2020 16:00:54 -0700
Subject: Re: [PATCH] hugetlbfs: remove call to huge_pte_alloc without
 i_mmap_rwsem
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A.Shutemov" <kirill.shutemov@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20200803224335.55794-1-mike.kravetz@oracle.com>
 <20200803225234.GD23808@casper.infradead.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <9072d352-7a07-aac7-3439-3f524fc465ed@oracle.com>
Date:   Mon, 3 Aug 2020 16:00:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803225234.GD23808@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9702 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008030158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9702 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008030158
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/20 3:52 PM, Matthew Wilcox wrote:
> On Mon, Aug 03, 2020 at 03:43:35PM -0700, Mike Kravetz wrote:
>> Commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
>> synchronization") requires callers of huge_pte_alloc to hold i_mmap_rwsem
>> in at least read mode.  This is because the explicit locking in
>> huge_pmd_share (called by huge_pte_alloc) was removed.  When restructuring
>> the code, the call to huge_pte_alloc in the else block at the beginning
>> of hugetlb_fault was missed.
> 
> Should we have a call to mmap_assert_locked() in huge_pte_alloc(),
> at least the generic one?

That is the wrong semaphore.

However, I was not aware of the checks for a semaphore being held as is
done in rwsem_is_locked().  That would have caught this when the original
code was changed.  Thanks for pointing this out.

Let me update the patch and add checks to huge_pmd_share().
-- 
Mike Kravetz
