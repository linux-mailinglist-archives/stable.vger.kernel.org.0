Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34427262BEA
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 11:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgIIJeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 05:34:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727113AbgIIJeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 05:34:00 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0899X4bm015662;
        Wed, 9 Sep 2020 05:33:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1c4mbqTzqzCmgGuR4293Re4zs3byhVY8MStQAuq9a+U=;
 b=Jrfn9/c4nSkWpgl3ijTVc4PMqgCkGwt4GUamCF9hP3X3I+yM45EudqNNgJgQh2tY7i4Z
 cUgT7v1oiCn5e8L45RbvzgFaynD/8vj+C1/kCKKzH1Wz5P5d0aTBPY0ZWWfMQKOYlIjz
 TBZNDYY1VD723eswPgJcDpXgy7/3Sd/rtoUpb1oNL5bcQ/Qgzq6PYicirPWm8BSIo8HS
 3elGlHI7vnQY9zcnyi/9rpyZqHy3dZE3yH0pFKR/cf5k2TMdIROOdiQDR8I4yuY1+8qj
 CVeG6kKtaS/L/jrQcM+flX53VjG/ICg3prXj6XH1tu3YNqOgKda6DlFptw7thrLmLgJt CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33eq25t87k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 05:33:49 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0899X88s016233;
        Wed, 9 Sep 2020 05:33:08 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33eq25t7ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 05:33:08 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0899RBB3011790;
        Wed, 9 Sep 2020 09:32:47 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8cbe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 09:32:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0899Winf27591064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Sep 2020 09:32:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86A9F4C04E;
        Wed,  9 Sep 2020 09:32:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7DF44C046;
        Wed,  9 Sep 2020 09:32:43 +0000 (GMT)
Received: from pomme.local (unknown [9.145.19.60])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Sep 2020 09:32:43 +0000 (GMT)
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
To:     David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>
Cc:     akpm@linux-foundation.org, Oscar Salvador <osalvador@suse.de>,
        rafael@kernel.org, nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <5cbd92e1-c00a-4253-0119-c872bfa0f2bc@redhat.com>
 <20200908170835.85440-1-ldufour@linux.ibm.com>
 <20200909074011.GD7348@dhcp22.suse.cz>
 <9faac1ce-c02d-7dbc-f79a-4aaaa5a73d28@linux.ibm.com>
 <20200909090953.GE7348@dhcp22.suse.cz>
 <4cdb54be-1a92-4ba4-6fee-3b415f3468a9@linux.ibm.com>
 <9ad553f2-ebbf-cae5-5570-f60d2c965c41@redhat.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <23a9ab54-a7bf-5bc2-2a60-e8a1246ed537@linux.ibm.com>
Date:   Wed, 9 Sep 2020 11:32:43 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <9ad553f2-ebbf-cae5-5570-f60d2c965c41@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_03:2020-09-08,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090081
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 09/09/2020 à 11:24, David Hildenbrand a écrit :
>>> I am not sure an enum is going to make the existing situation less
>>> messy. Sure we somehow have to distinguish boot init and runtime hotplug
>>> because they have different constrains. I am arguing that a) we should
>>> have a consistent way to check for those and b) we shouldn't blow up
>>> easily just because sysfs infrastructure has failed to initialize.
>>
>> For the point a, using the enum allows to know in register_mem_sect_under_node()
>> if the link operation is due to a hotplug operation or done at boot time.
>>
>> For the point b, one option would be ignore the link error in the case the link
>> is already existing, but that BUG_ON() had the benefit to highlight the root issue.
>>
> 
> WARN_ON_ONCE() would be preferred  - not crash the system but still
> highlight the issue.

Indeed, calling sysfs_create_link() instead of sysfs_create_link_nowarn() in 
register_mem_sect_under_node() and ignoring EEXIST returned value should do the job.

I'll do that in a separate patch.
