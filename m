Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697B83DD16F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 09:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhHBHpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 03:45:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232482AbhHBHp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 03:45:29 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1727Y5rd125744;
        Mon, 2 Aug 2021 03:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3GTKSoYuyeI7amyWljKoeZqQ+nHMylTD/J3zpAbpSkU=;
 b=opXA+N2F/OyCTrMckSbOQvv0dIelBOVELlf0qOm/01gfXdjEuvk6vCiHmojnt3SMYS8K
 bxW+LNNfiXRU7UgPKtR4usSebN/rk1tanddBuxxEMvc8FRtczuLXIVPnjwSFJgxozrim
 zD8r7WT5rh1J5mZs1h0CVY2lRQwX67Qo2K9kKqyBQp7M/LNmVWXi/5p3gxxnDiJaCLN9
 rZs1ekfust89aikdjGSboEL5x7zhilaaveAazi3oEk70xDpx1YXVJKNxQDDkLJ3jZa23
 DxTIk25KIE8o9mHofZKFkLQtN+Lxjp+q7mu/NEr2rJCrB2HANs6cVKDtn15Evjr5PfHQ iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a5kjutct4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Aug 2021 03:45:12 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1727cEhp137848;
        Mon, 2 Aug 2021 03:45:11 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a5kjutcs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Aug 2021 03:45:11 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1727bmXr009344;
        Mon, 2 Aug 2021 07:45:09 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 3a4x5a7t7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Aug 2021 07:45:09 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1727j9XO21889420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Aug 2021 07:45:09 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3602B2064;
        Mon,  2 Aug 2021 07:45:08 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09D95B2068;
        Mon,  2 Aug 2021 07:45:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.36.88])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  2 Aug 2021 07:45:03 +0000 (GMT)
Subject: Re: [PATCH v3] fpga: dfl: fme: Fix cpu hotplug issue in performance
 reporting
To:     will@kernel.org, hao.wu@intel.com, mark.rutland@arm.com
Cc:     trix@redhat.com, yilun.xu@intel.com, mdf@kernel.org,
        linux-fpga@vger.kernel.org, maddy@linux.ibm.com,
        atrajeev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, rnsastry@linux.ibm.com,
        linux-perf-users@vger.kernel.org, stable@vger.kernel.org
References: <20210713074216.208391-1-kjain@linux.ibm.com>
From:   kajoljain <kjain@linux.ibm.com>
Message-ID: <61495dc0-f496-992c-1d2a-9229a04e6e44@linux.ibm.com>
Date:   Mon, 2 Aug 2021 13:15:00 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210713074216.208391-1-kjain@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RyHz5855e0unzEdNSw03Cg5mCfzhtRmF
X-Proofpoint-GUID: W10U2EPBpxzuTFdcHfQHeMJ90pMtAAy-
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-02_01:2021-08-02,2021-08-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108020053
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/13/21 1:12 PM, Kajol Jain wrote:
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
> Fixes: 724142f8c42a ("fpga: dfl: fme: add performance reporting support")
> Tested-by: Xu Yilun <yilun.xu@intel.com>
> Acked-by: Wu Hao <hao.wu@intel.com>
> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> Cc: stable@vger.kernel.org
> ---

Any update on this patch? Please let me know if any changes required.

Thanks,
Kajol Jain

>  drivers/fpga/dfl-fme-perf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> ---
> Changelog:
> v2 -> v3:
> - Added Acked-by tag
> - Removed comment as suggested by Wu Hao
> - Link to patch v2: https://lkml.org/lkml/2021/7/9/143
> 
> v1 -> v2:
> - Add stable@vger.kernel.org in cc list
> - Link to patch v1: https://lkml.org/lkml/2021/6/28/275
> 
> RFC -> PATCH v1
> - Remove RFC tag
> - Did nits changes on subject and commit message as suggested by Xu Yilun
> - Added Tested-by tag
> - Link to rfc patch: https://lkml.org/lkml/2021/6/28/112
> ---
> 
> diff --git a/drivers/fpga/dfl-fme-perf.c b/drivers/fpga/dfl-fme-perf.c
> index 4299145ef347..587c82be12f7 100644
> --- a/drivers/fpga/dfl-fme-perf.c
> +++ b/drivers/fpga/dfl-fme-perf.c
> @@ -953,6 +953,8 @@ static int fme_perf_offline_cpu(unsigned int cpu, struct hlist_node *node)
>  		return 0;
>  
>  	priv->cpu = target;
> +	perf_pmu_migrate_context(&priv->pmu, cpu, target);
> +
>  	return 0;
>  }
>  
> 
