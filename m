Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA883B6E98
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 09:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhF2HSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 03:18:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30168 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232161AbhF2HSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 03:18:06 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T74OKE107562;
        Tue, 29 Jun 2021 03:15:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Z0tZN5Met1ZSQHDakvJhb1l7iLUwClOskU6tO9m9hTs=;
 b=YiEqGF2eUbf5Xr7JOd24BSQqPO6R2j2rby1k2o/Dt8IYikzoC0zny2KjfN8v/QRXfKIg
 ntdaPcWz7zTQCl/OhdWEATRODkGQy3UoyvHm0C18u9by9UWH8wnLnjV/GtZjv/lfIyug
 wvAVx9ndre0yyAG7EKjeR3xqBlfPCEYPK0Z2drZYKNHOJ8QZF8Of0FCH/QiOaL0bjGFm
 KmJrSjCxS/+Cp8Aa3bNaZsp7+ge+rp2661UsAbAOtQp4suqvvv7gGkYW1eYZC+kKHDFh
 NtrkF1g1IW/NNOn3CPYcmJ48AlSj2KEX51huz6F/Jr7K366sCPXHQz2IL+oEn9WO9Ybz Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39fxptrenm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 03:15:32 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15T75b0a114264;
        Tue, 29 Jun 2021 03:15:31 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39fxptren8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 03:15:31 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15T7CU68029602;
        Tue, 29 Jun 2021 07:15:30 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 39ekxb0pbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 07:15:30 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15T7FTmE32965020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 07:15:29 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1BB9BE06A;
        Tue, 29 Jun 2021 07:15:28 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4BB9BE05A;
        Tue, 29 Jun 2021 07:15:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.45.57])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 07:15:22 +0000 (GMT)
Subject: Re: [PATCH] fpga: dfl: fme: Fix cpu hotplug issue in performance
 reporting
To:     will@kernel.org, hao.wu@intel.com, mark.rutland@arm.com
Cc:     trix@redhat.com, yilun.xu@intel.com, mdf@kernel.org,
        linux-fpga@vger.kernel.org, maddy@linux.vnet.ibm.com,
        atrajeev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, rnsastry@linux.ibm.com,
        linux-perf-users@vger.kernel.org, stable@vger.kernel.org
References: <20210628101721.188991-1-kjain@linux.ibm.com>
From:   kajoljain <kjain@linux.ibm.com>
Message-ID: <adc3b013-d39b-a183-dfce-86ca857949b8@linux.ibm.com>
Date:   Tue, 29 Jun 2021 12:45:20 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210628101721.188991-1-kjain@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MXa6PHQqeRTXZFU0Y06Vj-7XCnRmD6M4
X-Proofpoint-GUID: 4JWqwjMAm7oDc5zMB0WVtk1e2LwS41GY
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_02:2021-06-25,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 clxscore=1011 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290050
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/28/21 3:47 PM, Kajol Jain wrote:
> The performance reporting driver added cpu hotplug
> feature but it didn't add pmu migration call in cpu
> offline function.
> This can create an issue incase the current designated
> cpu being used to collect fme pmu data got offline,
> as based on current code we are not migrating fme pmu to
> new target cpu. Because of that perf will still try to
> fetch data from that offline cpu and hence we will not
> get counter data.
> 
> Patch fixed this issue by adding pmu_migrate_context call
> in fme_perf_offline_cpu function.
> 

Adding stable@vger.kernel.org in cc list as suggested by Moritz Fischer.

Thanks,
Kajol Jain

> Fixes: 724142f8c42a ("fpga: dfl: fme: add performance reporting support")
> Tested-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> ---
>  drivers/fpga/dfl-fme-perf.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> ---
> Changelog:
> - Remove RFC tag
> - Did nits changes on subject and commit message as suggested by Xu Yilun
> - Added Tested-by tag
> - Link to rfc patch: https://lkml.org/lkml/2021/6/28/112
> ---
> diff --git a/drivers/fpga/dfl-fme-perf.c b/drivers/fpga/dfl-fme-perf.c
> index 4299145ef347..b9a54583e505 100644
> --- a/drivers/fpga/dfl-fme-perf.c
> +++ b/drivers/fpga/dfl-fme-perf.c
> @@ -953,6 +953,10 @@ static int fme_perf_offline_cpu(unsigned int cpu, struct hlist_node *node)
>  		return 0;
>  
>  	priv->cpu = target;
> +
> +	/* Migrate fme_perf pmu events to the new target cpu */
> +	perf_pmu_migrate_context(&priv->pmu, cpu, target);
> +
>  	return 0;
>  }
>  
> 
