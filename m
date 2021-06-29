Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C9E3B6F11
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 10:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhF2ILV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 04:11:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232272AbhF2ILV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 04:11:21 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T84FU4073675;
        Tue, 29 Jun 2021 04:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RsIMVnamhB6FYa7FfF0w4uQRw+Kcw3nQxnVdRE1/Fv4=;
 b=Lst/v2MLPzGLS81nSf7dPD3ptWkhy65uSDp30t/ejUH4GOrNf3Tvi2It5zcdul33J3TQ
 E+C3TN0yD3uFZfqIiVSqfrxEhhZTP3VS4xRkhxS/XobQeCqvLBx/OBv6KWqwOf0fAH4x
 E+uCcs7Wuqqu/R5RAbeW4fuENENIK29kDOJ4ZjomiTIv1KR3+naE8CFUgxXQItjajUTI
 3mX5bMkifhOgWjAmS4QEgjJfaWAq8IFYnX3t79wPYbP8PsYVNwDZlfld8gyNKGlH1acY
 yXEnQAQ08LPRi9TGOmx2sxVI9N2xSjTN1x5Ad1UCyY/0WS3bCMnQuccZAfz2OkdMfYkK mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39fv03wc34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 04:08:44 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15T869hB084165;
        Tue, 29 Jun 2021 04:08:43 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39fv03wc2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 04:08:43 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15T86NDG021853;
        Tue, 29 Jun 2021 08:08:42 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 39duvbwbpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 08:08:42 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15T88f1M27263300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 08:08:41 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 503996E090;
        Tue, 29 Jun 2021 08:08:41 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 828826E05B;
        Tue, 29 Jun 2021 08:08:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.45.57])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 08:08:35 +0000 (GMT)
Subject: Re: [PATCH] fpga: dfl: fme: Fix cpu hotplug issue in performance
 reporting
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     will@kernel.org, hao.wu@intel.com, mark.rutland@arm.com,
        trix@redhat.com, yilun.xu@intel.com, mdf@kernel.org,
        linux-fpga@vger.kernel.org, maddy@linux.vnet.ibm.com,
        atrajeev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, rnsastry@linux.ibm.com,
        linux-perf-users@vger.kernel.org, stable@vger.kernel.org
References: <20210628101721.188991-1-kjain@linux.ibm.com>
 <adc3b013-d39b-a183-dfce-86ca857949b8@linux.ibm.com>
 <YNrLRLyyUeDemxTS@kroah.com>
From:   kajoljain <kjain@linux.ibm.com>
Message-ID: <8a70f71a-f75c-427b-cf6a-b63bf7682f36@linux.ibm.com>
Date:   Tue, 29 Jun 2021 13:38:33 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <YNrLRLyyUeDemxTS@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hetGeLcYCXc8AdjqHgud-38bTHz1rVQn
X-Proofpoint-GUID: q5oo3cYrBGcZjkPfLbOJVvffHymg3jFJ
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_02:2021-06-25,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 mlxlogscore=914 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290056
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/29/21 12:57 PM, Greg KH wrote:
> On Tue, Jun 29, 2021 at 12:45:20PM +0530, kajoljain wrote:
>>
>>
>> On 6/28/21 3:47 PM, Kajol Jain wrote:
>>> The performance reporting driver added cpu hotplug
>>> feature but it didn't add pmu migration call in cpu
>>> offline function.
>>> This can create an issue incase the current designated
>>> cpu being used to collect fme pmu data got offline,
>>> as based on current code we are not migrating fme pmu to
>>> new target cpu. Because of that perf will still try to
>>> fetch data from that offline cpu and hence we will not
>>> get counter data.
>>>
>>> Patch fixed this issue by adding pmu_migrate_context call
>>> in fme_perf_offline_cpu function.
>>>
>>
>> Adding stable@vger.kernel.org in cc list as suggested by Moritz Fischer.
> 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.

Thanks Greg for pointing it, I will take care in my next version.

Thanks,
Kajol Jain

> 
> </formletter>
> 
