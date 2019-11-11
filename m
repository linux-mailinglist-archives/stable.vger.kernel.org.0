Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C52F6EF1
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 08:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfKKHRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 02:17:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726360AbfKKHRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 02:17:39 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAB7HWox075411
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 02:17:38 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w70gwd2tg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 02:17:37 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 11 Nov 2019 07:17:36 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 11 Nov 2019 07:17:33 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAB7HWtv59703336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 07:17:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 598B652054;
        Mon, 11 Nov 2019 07:17:32 +0000 (GMT)
Received: from [9.145.15.79] (unknown [9.145.15.79])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2A06E5205F;
        Mon, 11 Nov 2019 07:17:32 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 4.19 204/205] s390/qeth: limit csum offload
 erratum to L3 devices
To:     David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-s390@vger.kernel.org
References: <20191108120025.GM4787@sasha-vm>
 <4d8f1938-af6e-7e0e-4085-2f7c53390b2d@linux.ibm.com>
 <20191108123416.GA732985@kroah.com>
 <20191108.113527.2242883926552730503.davem@davemloft.net>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Date:   Mon, 11 Nov 2019 08:17:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191108.113527.2242883926552730503.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19111107-0020-0000-0000-000003851A30
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111107-0021-0000-0000-000021DB1B6E
Message-Id: <29d7a908-10af-a83a-df2f-05cf1facf82c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-11_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1031 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911110071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.11.19 20:35, David Miller wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Fri, 8 Nov 2019 13:34:16 +0100
> 
>> On Fri, Nov 08, 2019 at 01:16:26PM +0100, Julian Wiedmann wrote:
>>> On 08.11.19 13:00, Sasha Levin wrote:
>>>> On Fri, Nov 08, 2019 at 12:50:24PM +0100, Julian Wiedmann wrote:
>>>>> On 08.11.19 12:37, Sasha Levin wrote:
>>>>>> From: Julian Wiedmann <jwi@linux.ibm.com>
>>>>>>
>>>>>> [ Upstream commit f231dc9dbd789b0f98a15941e3cebedb4ad72ad5 ]
>>>>>>
>>>>>> Combined L3+L4 csum offload is only required for some L3 HW. So for
>>>>>> L2 devices, don't offload the IP header csum calculation.
>>>>>>
>>>>>
>>>>> NACK, this has no relevance for stable.
>>>>
>>>> Sure, I'll drop it.
>>>>
>>>> Do you have an idea why the centos and ubuntu folks might have
>>>> backported this commit into their kernels?
>>>>
>>>
>>> No clue, I trust they have their own reasons.
>>>
>>
>> I cant see centos backporting anything unless they were asked to do so.
>> And this really looks like a "bugfix" to me, why isn't this relevant for
>> any older kernel versions?
> 
> Yeah seriously, this looks entirely legit.
> 

I can assure you this doesn't fix any actual bug, and there's zero user
impact from _not_ having this patch.

