Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3717E46CF7
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 01:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfFNXeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 19:34:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44682 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFNXeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 19:34:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5ENXaBH134612;
        Fri, 14 Jun 2019 23:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=xC57jn87JyXy7UEJGYT3I0BpBDnQuaSrP5i3P1QlI6I=;
 b=fteRuujufu3CmIQ0hpxr3+DyF3Am163I32ktIzUzd9sOepWWRmqepsAtq8Gxt4y4VAog
 LM2vzoQo1R5A/xCc7g6UYg0Q4MATHrE8QxJ6wLY2uu5nhFEZ/G/LZOgDkYOMtF7OFpZ9
 1ixxkQkAA0WPyqDBLwCYi0TktWyxmkGyOhPBL2JbS142d+gNM+gVbRvH2zIMyW3c1S01
 oQFRK0HZS3jkXyMKG4wQjuSD2eOZoUx5c+PvJXBvlxFZYpjdzHUq52EZYK6QaurDHB5h
 0vd5nkpD5p4NYWyj4QcAjFe30PQNSHNx/1oFZuDMchT0o+UNU6VZGKOZp8BWI/1PzvWw Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t04eu9srg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jun 2019 23:33:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5ENWsED162221;
        Fri, 14 Jun 2019 23:33:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2t0p9t7n0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jun 2019 23:33:56 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5ENXtO0029569;
        Fri, 14 Jun 2019 23:33:55 GMT
Received: from [192.168.1.222] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 14 Jun 2019 16:33:55 -0700
Subject: Re: [PATCH 2/3] hugetlbfs: Use i_mmap_rwsem to fix page
 fault/truncate race
To:     Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Michal Hocko <mhocko@kernel.org>, Hugh Dickins <hughd@google.com>,
        stable@vger.kernel.org
References: <20181203200850.6460-3-mike.kravetz@oracle.com>
 <20190614215632.BF5F721473@mail.kernel.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <f8cea651-8052-4109-ea9b-dee3fbfc81d1@oracle.com>
Date:   Fri, 14 Jun 2019 16:33:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190614215632.BF5F721473@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9288 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906140187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9288 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906140187
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/19 2:56 PM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: ebed4bfc8da8 [PATCH] hugetlb: fix absurd HugePages_Rsvd.
<snip>
> 
> How should we proceed with this patch?
> 

I hope you do nothing with this as the patch is not upstream.

-- 
Mike Kravetz
