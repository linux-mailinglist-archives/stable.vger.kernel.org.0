Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4E519145B
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 16:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgCXPZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 11:25:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50918 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbgCXPZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 11:25:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OFOEua049070;
        Tue, 24 Mar 2020 15:25:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wmt/AtPlazx7PxA08PU/xQuPcDJRywUgyLYzzhVKDWo=;
 b=HlxHhAZeFJAYDCA5fPvZT0XyZk1LtJIZKbYOmph4L9nsYBamLDoD/tnnT7M3MY8LWWjW
 Y0ed+dfyRQ+D7Aqj2BxzqWWyCnlmK87v7Ni2SZxdHuzm1rC1rIe293zxj8WmxRXnxqyW
 5RJZ4Rv4+Plpi8RrD2WqK9xxzLs+0wFCIVTT7i/TVb5JAukeNu+INHfKC3Od9RBx3RWR
 cvCp1lRb1xwZV/8qd5wg+5aFNN79N9U2Zbro/l2gwWi/z4rdPS9u0RQ3wB5aaove+jJp
 C8VjRV7+tgNiC6j2sIPomHakY/vxF1EZnZGOxIwd+w9mfZNUOwwFs+uu4iGwiTSLVfCa 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yx8ac1x7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 15:25:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OFMCS3150028;
        Tue, 24 Mar 2020 15:25:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yxw4pg9dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 15:25:15 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02OFPCct026939;
        Tue, 24 Mar 2020 15:25:12 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 08:25:12 -0700
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kvm@vger.kernel.org, linux-mm@kvack.org,
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
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <98d35563-8af0-2693-7e76-e6435da0bbee@oracle.com>
Date:   Tue, 24 Mar 2020 08:25:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200324115541.GH20941@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=856 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=880
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240085
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/20 4:55 AM, Jason Gunthorpe wrote:
> Also, since CH moved all the get_user_pages_fast code out of the
> arch's many/all archs can drop their arch specific version of this
> routine. This is really just a specialized version of gup_fast's
> algorithm..
> 
> (also the arch versions seem different, why do some return actual
>  ptes, not null?)

Not sure I understand that last question.  The return value should be
a *pte or null.

/*
 * huge_pte_offset() - Walk the page table to resolve the hugepage
 * entry at address @addr
 *
 * Return: Pointer to page table or swap entry (PUD or PMD) for
 * address @addr, or NULL if a p*d_none() entry is encountered and the
 * size @sz doesn't match the hugepage size at this level of the page
 * table.
 */
-- 
Mike Kravetz
