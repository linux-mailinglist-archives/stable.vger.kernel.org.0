Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851CE248ECA
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 21:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgHRTfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 15:35:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726632AbgHRTfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 15:35:43 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IJX6gH153708;
        Tue, 18 Aug 2020 15:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BmZYRBo3PHKnq3q3M77l5z9qUuO7WfnTs/9pmsKCUuo=;
 b=I8XGIaUgl6tf8J+sfdxUd1CMUVAz0RclejOHbklwwL5KONvEgwWFUfiRsACQtI9Q4eUj
 Mlbm5Qx0CQSVHqg1sdsyAvNsUb/5Unvx67XUs5UEUcEI+J5/ylR3KD7I0W0jFsDhAS1Q
 gmnZJ7Ruz0QYnXP0adeDnW4xkQnlOlknvFxjpPDp1Spfphn6uJvLVGChxRjsfwo2jM7G
 /VjUY4Z067MmO8alziwUuCYaWg7LI51CfxT9W2WdwhFPgPfJAeJjTgvLwkzz1pQTZsV/
 9XqMog7IJf9+zUG2pV4Ul6zy8mJgUUZ50aEqM8C6GCkimnABzmNAX3wa8NbtPY1Led0w tw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 330ccaftnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 15:35:39 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07IJTaDm015778;
        Tue, 18 Aug 2020 19:35:38 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3304ccg29a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 19:35:38 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07IJZbaI63701502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 19:35:37 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 614B1C605B;
        Tue, 18 Aug 2020 19:35:37 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5669EC6055;
        Tue, 18 Aug 2020 19:35:36 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.67.173])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 19:35:36 +0000 (GMT)
Subject: Re: [PATCH] powerpc/pseries: Do not initiate shutdown when system is
 running on UPS
To:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org
References: <20200818105424.234108-1-hegdevasant@linux.vnet.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <1e80a259-fc81-e7f9-8cd9-165e4bb9069a@linux.ibm.com>
Date:   Tue, 18 Aug 2020 12:35:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200818105424.234108-1-hegdevasant@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_14:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 clxscore=1011 phishscore=0 priorityscore=1501 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180135
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/18/20 3:54 AM, Vasant Hegde wrote:
> As per PAPR specification whenever system is running on UPS we have to
> wait for predefined time (default 10mins) before initiating shutdown.

The wording in PAPR seems a little unclear. It states for an
EPOW_SYSTEM_SHUTDOWN action code that an EPOW error should be logged followed by
scheduling a shutdown to begin after an OS defined delay interval (with 10
minutes the suggested default).

However, the modifier code descriptions seems to imply that a normal shutdown is
the only one that should happen with no additional delay.

For EPOW sensor value = 3 (EPOW_SYSTEM_SHUTDOWN)
0x01 = Normal system shutdown with no additional delay
0x02 = Loss of utility power, system is running on UPS/Battery
0x03 = Loss of system critical functions, system should be shutdown
0x04 = Ambient temperature too high

For 0x03-0x04 we also do an orderly_poweroff().

Not sure if it really matters, but I was curious and this is just what I gleaned
from glancing at PAPR.

-Tyrel

> 
> We have user space tool (rtas_errd) to monitor for EPOW events and
> initiate shutdown after predefined time. Hence do not initiate shutdown
> whenever we get EPOW_SHUTDOWN_ON_UPS event.
> 
> Fixes: 79872e35 (powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must initiate shutdown)
> Cc: stable@vger.kernel.org # v4.0+
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/ras.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
> index f3736fcd98fc..13c86a292c6d 100644
> --- a/arch/powerpc/platforms/pseries/ras.c
> +++ b/arch/powerpc/platforms/pseries/ras.c
> @@ -184,7 +184,6 @@ static void handle_system_shutdown(char event_modifier)
>  	case EPOW_SHUTDOWN_ON_UPS:
>  		pr_emerg("Loss of system power detected. System is running on"
>  			 " UPS/battery. Check RTAS error log for details\n");
> -		orderly_poweroff(true);
>  		break;
> 
>  	case EPOW_SHUTDOWN_LOSS_OF_CRITICAL_FUNCTIONS:
> 

