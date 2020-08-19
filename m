Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AA1249460
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 07:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgHSFZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 01:25:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgHSFZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 01:25:33 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J53ae2092493;
        Wed, 19 Aug 2020 01:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fBDoJyx+5gzOBd1SZxoykqXHYuHqTa611gULpTyW53Q=;
 b=dNueLTpL76axwSjBd9q3sNdPXQJhs1PCh1DIun5JzooXVgqX1kLUBtgC5xZdPyaCyz0A
 rOQsjVWCGYaisyJ4ZYeAg7Q1ONPuquvu5QD0zPtKnGtY/1RMv3yMHrO8LOrOM6w8PMgw
 Y1IXihoqZ8UoJUJOW7aqNtddlRng9QPXJKkgdAX1cYoy1P/xh0GS2FPFuE3hnjGgu0U9
 hAAcwqovTMx2CIEueE/9SQ31TlCHh5t5s5X6On7cYT6SkgixPvBGsGnrzvIgetUfI/yV
 h0f5KbR71R6qpRJDhXqdCOX8AMLdOtpYLs0KUPBmVuy9PO2QBqKaVIfl2Ml425otjbJN BA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304scyu58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 01:25:26 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07J5GA0s029303;
        Wed, 19 Aug 2020 05:25:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 330tbvr62w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 05:25:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07J5NqlD61735300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 05:23:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E24B642045;
        Wed, 19 Aug 2020 05:25:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18B0142041;
        Wed, 19 Aug 2020 05:25:21 +0000 (GMT)
Received: from [9.77.204.68] (unknown [9.77.204.68])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 05:25:20 +0000 (GMT)
Subject: Re: [PATCH] powerpc/pseries: Do not initiate shutdown when system is
 running on UPS
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org
References: <20200818105424.234108-1-hegdevasant@linux.vnet.ibm.com>
 <1e80a259-fc81-e7f9-8cd9-165e4bb9069a@linux.ibm.com>
From:   Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Message-ID: <4168fe06-a649-f7b4-df4d-34803ac64238@linux.vnet.ibm.com>
Date:   Wed, 19 Aug 2020 10:55:20 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1e80a259-fc81-e7f9-8cd9-165e4bb9069a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_02:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 mlxscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190042
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/19/20 1:05 AM, Tyrel Datwyler wrote:
> On 8/18/20 3:54 AM, Vasant Hegde wrote:
>> As per PAPR specification whenever system is running on UPS we have to
>> wait for predefined time (default 10mins) before initiating shutdown.
> 
> The wording in PAPR seems a little unclear. It states for an
> EPOW_SYSTEM_SHUTDOWN action code that an EPOW error should be logged followed by
> scheduling a shutdown to begin after an OS defined delay interval (with 10
> minutes the suggested default).
> 
> However, the modifier code descriptions seems to imply that a normal shutdown is
> the only one that should happen with no additional delay.
> 
> For EPOW sensor value = 3 (EPOW_SYSTEM_SHUTDOWN)
> 0x01 = Normal system shutdown with no additional delay
> 0x02 = Loss of utility power, system is running on UPS/Battery
> 0x03 = Loss of system critical functions, system should be shutdown
> 0x04 = Ambient temperature too high
> 
> For 0x03-0x04 we also do an orderly_poweroff().
> 
> Not sure if it really matters, but I was curious and this is just what I gleaned
> from glancing at PAPR.

Correct. PAPR is bit confusing. But we know for sure that when running on UPS we 
don't need to shutdown immediately.

For values 0x03 and 0x04 I think its ok to initiate shutdown (that's the same 
behaviour exists for long time). I can double check with firmware folks.

-Vasant

> 
> -Tyrel
> 
>>
>> We have user space tool (rtas_errd) to monitor for EPOW events and
>> initiate shutdown after predefined time. Hence do not initiate shutdown
>> whenever we get EPOW_SHUTDOWN_ON_UPS event.
>>
>> Fixes: 79872e35 (powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must initiate shutdown)
>> Cc: stable@vger.kernel.org # v4.0+
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
>> ---
>>   arch/powerpc/platforms/pseries/ras.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
>> index f3736fcd98fc..13c86a292c6d 100644
>> --- a/arch/powerpc/platforms/pseries/ras.c
>> +++ b/arch/powerpc/platforms/pseries/ras.c
>> @@ -184,7 +184,6 @@ static void handle_system_shutdown(char event_modifier)
>>   	case EPOW_SHUTDOWN_ON_UPS:
>>   		pr_emerg("Loss of system power detected. System is running on"
>>   			 " UPS/battery. Check RTAS error log for details\n");
>> -		orderly_poweroff(true);
>>   		break;
>>
>>   	case EPOW_SHUTDOWN_LOSS_OF_CRITICAL_FUNCTIONS:
>>
> 

