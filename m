Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCFF252C4A
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 13:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgHZLOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 07:14:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728668AbgHZLOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 07:14:31 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07QB3IIM112212;
        Wed, 26 Aug 2020 07:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TusebNyuzSZj6zQ1qcq5fCJU7Qk0mlvSif7um9HzO9I=;
 b=NQSsqa27uQfGSHl+6tFWbHyHia+PmDtjkmPoXRg20wlXf3gMnRaye48i44VnECKaaFZL
 mXSObA0Lh9jhK0js2Xx07hKPtRrC/qtisDnye3DjV+qH71/t82w88RyYed1+GH6rbyXm
 +HdbdyPyLa2wFBXk3LHHHv5zZ6DtIh6qbh55+PEId0zzVtrxkM4BDhKAPYznqv1lKhBh
 1uYNNtWNMFHS1xTNEPrBM8e+6V16NHUzbD7eHnZ2ggEL2txwFmvVYMuj1gGqFRRWmOOo
 xWP4sm75+C0e5H0EDSJpu0A7Y85PFazG9ectbhoQu3xVfNr4zHE1rHZR3fbqp1to16wf VQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 335pfn8cxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Aug 2020 07:14:19 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07QBBZ28000618;
        Wed, 26 Aug 2020 11:14:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 33498uadc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Aug 2020 11:14:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07QBEEE349545564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 11:14:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82C98A405F;
        Wed, 26 Aug 2020 11:14:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D56CA405B;
        Wed, 26 Aug 2020 11:14:13 +0000 (GMT)
Received: from [9.199.33.201] (unknown [9.199.33.201])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Aug 2020 11:14:13 +0000 (GMT)
Subject: Re: [PATCH 4.19 65/71] powerpc/pseries: Do not initiate shutdown when
 system is running on UPS
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20200824082355.848475917@linuxfoundation.org>
 <20200824082359.202438041@linuxfoundation.org>
 <20200825195620.GB27453@duo.ucw.cz>
From:   Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Message-ID: <268a861f-59ac-679c-7507-d685d059a2ab@linux.vnet.ibm.com>
Date:   Wed, 26 Aug 2020 16:44:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200825195620.GB27453@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_08:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260089
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/26/20 1:26 AM, Pavel Machek wrote:
> Hi!
> 

Hi Pavel,

>> We have a user space tool (rtas_errd) on LPAR to monitor for
>> EPOW_SHUTDOWN_ON_UPS. Once it gets an event it initiates shutdown
>> after predefined time. It also starts monitoring for any new EPOW
> 
> Yeah, so there's userspace tool, and currently systems _with_ that
> tool work poorly with UPS.
> 
> So you have fixed that, and now, systems _without_ that tool will work
> poorly.

User space tool exists for long long time (more than decade) and its default tool
on pseries system. Also user space tool behavior is not changed for long time.

The original design was to forward UPS event to userspace and let user space wait
for predefined time and then initiate shutdown.

Previous fix accidentally initiated shutdown as soon as system switch to UPS power.

> 
> That's not a fix for serious bug, that's behaviour change. You are
> fixing one set of systems and breaking another.

Without fix, as soon as system switches to UPS power supply, kernel will start 
shutdown process. which is not correct. Its actually impacting customers running 
Linux on pseries LPAR mode. Hence I have requested this fix for stable tree.

Hope this clarifies your concern.

-Vasant


> 
> I don't believe it is suitable for stable.
> 
> 								Pavel
> 
>> @@ -118,7 +118,6 @@ static void handle_system_shutdown(char
>>   	case EPOW_SHUTDOWN_ON_UPS:
>>   		pr_emerg("Loss of system power detected. System is running on"
>>   			 " UPS/battery. Check RTAS error log for details\n");
>> -		orderly_poweroff(true);
>>   		break;
>>   
>>   	case EPOW_SHUTDOWN_LOSS_OF_CRITICAL_FUNCTIONS:
>>
> 

