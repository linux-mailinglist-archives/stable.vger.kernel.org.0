Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9DC195B1
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 01:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfEIXcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 19:32:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45076 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfEIXcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 19:32:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49NOFCS051217;
        Thu, 9 May 2019 23:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=C9aIasraSha+Unahg2EAZJgXu4Vii1PBVVz7t26PHMo=;
 b=y2nCTlnf47trHDM7FlSPumjUEArfp40Mam9pSSNWxp9tuaJdDpHfRlBbsNprh6FslJfZ
 CvffXORALuUweL8ITV6SGhxWVWMt2j6NrHdSPkZHRCipnwSD3grZ15DUe+bjBfe5am5x
 SXCqanmEWrfk9VJwiMvC25XHGG7jzJ5zPOQdrVRqQR2/I/MnYgCPVdAPNy8tW/rq8+qW
 zmNbRVRI0WtRAy0cYaYpH9+07mv5C38mtNYXtZpE0xWroBvWiWhm4bTc0qSaeSW6kFI7
 7M2N6W29+txJqiVcRhJ0MTLSmTxAHH1heZY68DbVfcRUPRsENUrC7pbw8x18yZp0yV76 +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2s94b6e0e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 23:32:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49NVUVU125728;
        Thu, 9 May 2019 23:32:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2s94ah2qat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 23:32:05 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x49NW3rL010577;
        Thu, 9 May 2019 23:32:04 GMT
Received: from [192.168.1.222] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 May 2019 16:32:03 -0700
Subject: Re: [PATCH] hugetlbfs: always use address space in inode for resv_map
 pointer
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     yuyufen <yuyufen@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
References: <20190416065058.GB11561@dhcp22.suse.cz>
 <20190419204435.16984-1-mike.kravetz@oracle.com>
 <fafe9985-7db1-b65c-523d-875ab4b3b3b8@huawei.com>
 <5d7dc0d5-7cd3-eb95-a1e7-9c68fe393647@oracle.com>
 <20190509161135.00b542e5b4d0996b5089ea02@linux-foundation.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <31754605-5425-a2aa-b16f-ad89772c27b9@oracle.com>
Date:   Thu, 9 May 2019 16:32:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509161135.00b542e5b4d0996b5089ea02@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=735
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905090134
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=805 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905090134
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/9/19 4:11 PM, Andrew Morton wrote:
> On Wed, 8 May 2019 13:16:09 -0700 Mike Kravetz <mike.kravetz@oracle.com> wrote:
> 
>>> I think it is better to add fixes label, like:
>>> Fixes: 58b6e5e8f1ad ("hugetlbfs: fix memory leak for resv_map")
>>>
>>> Since the commit 58b6e5e8f1a has been merged to stable, this patch also be needed.
>>> https://www.spinics.net/lists/stable/msg298740.html
>>
>> It must have been the AI that decided 58b6e5e8f1a needed to go to stable.
> 
> grr.
> 
>> Even though this technically does not fix 58b6e5e8f1a, I'm OK with adding
>> the Fixes: to force this to go to the same stable trees.
> 
> Why are we bothering with any of this, given that
> 
> : Luckily, private_data is NULL for address spaces in all such cases
> : today but, there is no guarantee this will continue.
> 
> ?

You are right.  For stable releases, I do not see any way for this to
be an issue.  We are lucky today (and in the past).  The patch is there
to guard against code changes which may cause this condition to change
in the future.

Yufen Yu, do you see this actually fixing a problem in stable releases?
I believe you originally said this is not a problem today, which would
also imply older releases.  Just want to make sure I am not missing something.
-- 
Mike Kravetz

> Even though 58b6e5e8f1ad was inappropriately backported, the above
> still holds, so what problem does a backport of "hugetlbfs: always use
> address space in inode for resv_map pointer" actually solve?
> 
> And yes, some review of this would be nice
