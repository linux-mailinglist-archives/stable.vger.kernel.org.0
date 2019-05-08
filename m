Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88311180E4
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 22:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfEHUQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 16:16:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37404 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfEHUQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 16:16:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48KE7Sw139454;
        Wed, 8 May 2019 20:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=RNyiBPHYmMKPy9Ae5WLvwYN+r0cY1awKN5dSIQUf1PM=;
 b=y/TCL95Rml3dD4NpWNmcSltG1tNIp46T5O+MdFYvMJD9CGl0ObYJAHZ+EBHDVsfaoLxR
 HNuv4F9EbW+pwZ3JnWtmXK1IaBTnVvo0f5bZt3PKv8mi6LnvDz073Pe4CTHHYWXXw8bG
 8GDjv8SM8UXXY8bYJmV0Rbi6m8TAXJuHgCrnieYQbYrIbfoXJLRAgEHG0Zj8XqV1UhLx
 w+Rxq6LZ6j8pQiOP8jcrMHhECLb+xBSx7hlx+ptO9ACBfbgKblb5dQAcT+TAL41qfKSl
 D5SBBKtV7/kN2aG5rRydMzzAsCsy6liumZZhjKRGvxEQmj7wASMO7K05iqKQrNLE1Tlk Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2s94b66prj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 20:16:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48KF9SY093762;
        Wed, 8 May 2019 20:16:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2s94bac3s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 20:16:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x48KGIXK020586;
        Wed, 8 May 2019 20:16:18 GMT
Received: from [192.168.1.222] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 May 2019 13:16:17 -0700
Subject: Re: [PATCH] hugetlbfs: always use address space in inode for resv_map
 pointer
To:     yuyufen <yuyufen@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Michal Hocko <mhocko@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20190416065058.GB11561@dhcp22.suse.cz>
 <20190419204435.16984-1-mike.kravetz@oracle.com>
 <fafe9985-7db1-b65c-523d-875ab4b3b3b8@huawei.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <5d7dc0d5-7cd3-eb95-a1e7-9c68fe393647@oracle.com>
Date:   Wed, 8 May 2019 13:16:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <fafe9985-7db1-b65c-523d-875ab4b3b3b8@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=976
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905080124
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905080124
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/8/19 12:10 AM, yuyufen wrote:
> On 2019/4/20 4:44, Mike Kravetz wrote:
>> Continuing discussion about commit 58b6e5e8f1ad ("hugetlbfs: fix memory
>> leak for resv_map") brought up the issue that inode->i_mapping may not
>> point to the address space embedded within the inode at inode eviction
>> time.  The hugetlbfs truncate routine handles this by explicitly using
>> inode->i_data.  However, code cleaning up the resv_map will still use
>> the address space pointed to by inode->i_mapping.  Luckily, private_data
>> is NULL for address spaces in all such cases today but, there is no
>> guarantee this will continue.
>>
>> Change all hugetlbfs code getting a resv_map pointer to explicitly get
>> it from the address space embedded within the inode.  In addition, add
>> more comments in the code to indicate why this is being done.
>>
>> Reported-by: Yufen Yu <yuyufen@huawei.com>
>> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
...
> 
> Dose this patch have been applied?

Andrew has pulled it into his tree.  However, I do not believe there has
been an ACK or Review, so am not sure of the exact status.

> I think it is better to add fixes label, like:
> Fixes: 58b6e5e8f1ad ("hugetlbfs: fix memory leak for resv_map")
> 
> Since the commit 58b6e5e8f1a has been merged to stable, this patch also be needed.
> https://www.spinics.net/lists/stable/msg298740.html

It must have been the AI that decided 58b6e5e8f1a needed to go to stable.
Even though this technically does not fix 58b6e5e8f1a, I'm OK with adding
the Fixes: to force this to go to the same stable trees.

-- 
Mike Kravetz
