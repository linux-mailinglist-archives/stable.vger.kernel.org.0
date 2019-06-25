Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B3855680
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 19:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfFYR71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 13:59:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbfFYR71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 13:59:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PHwdNI155650;
        Tue, 25 Jun 2019 17:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=sgxyqaAPqaNsuffA1Qkzp8ASmBO8M5ibEKPcciwr5ms=;
 b=MivfJdCswvzPmAOZzO95vs0RjL9d/Mh1KanrrkM9WHHmVWABQ8dPTzLBZupQPNPnGLMp
 5oY0TqTtynb6Z5mv8w+B5i9ahEAGU5JVtJe4OTjLxa7UiyXpby1XlUD0tXQ338EQOnQn
 x52Q3gchsglV0ejB0lFyFx/fi8cs5eywMiI6oJO8WXvM43r5iYNSl2BSIfmNfRcdIFuY
 meiwHOxaU4WyxuMyZRVuhfris4hqnGd4SFcT0eLaCEFtpF00XI8YHxzkYDw5S6aSVUTu
 1qVnbWJd5ACQokBL9sd7DKra02JGfHRmN6WgxuQlsRzJC0DJrcgYlsDCxVrPpD9/qi4t RA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t9cyqdwby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 17:58:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PHwHK5129508;
        Tue, 25 Jun 2019 17:58:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t99f413we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 17:58:35 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5PHwWcm022239;
        Tue, 25 Jun 2019 17:58:33 GMT
Received: from [10.39.221.199] (/10.39.221.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 10:58:32 -0700
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even if
 host does not
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     mingo@redhat.com, bp@alien8.de, rkrcmar@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, stable <stable@vger.kernel.org>
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
 <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com>
 <alpine.DEB.2.21.1906251750140.32342@nanos.tec.linutronix.de>
From:   Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Organization: Oracle Corporation
Message-ID: <56fa2729-52a7-3994-5f7c-bc308da7d710@oracle.com>
Date:   Tue, 25 Jun 2019 13:58:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1906251750140.32342@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250136
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/25/2019 12:05 PM, Thomas Gleixner wrote:
> On Tue, 25 Jun 2019, Paolo Bonzini wrote:
>> On 10/06/19 19:20, Alejandro Jimenez wrote:
> Btw, the proper prefix is: x86/speculation: Allow guests ....
I'll correct it on the next iteration of the patch.

>>> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
>>> index 03b4cc0..66ca906 100644
>>> --- a/arch/x86/kernel/cpu/bugs.c
>>> +++ b/arch/x86/kernel/cpu/bugs.c
>>> @@ -836,6 +836,16 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
>>>   	}
>>>   
>>>   	/*
>>> +	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
>>> +	 * bit in the mask to allow guests to use the mitigation even in the
>>> +	 * case where the host does not enable it.
>>> +	 */
>>> +	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
>>> +	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
>>> +		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
> Well, yes. But that also allows the guest to turn off SSBD if the host has
> it disabled globally. So this needs to be conditional depending on the host
> mode. It affects two places:
>
>    1) If the host has it globally disabled then the mask needs to be clear.
>
>    2) If the host has it specifically disabled for the VCPU thread, then it
>       shouldn't be allowed to be cleared by the guest either.
I see the argument that the host must be able to enforce its security 
policies on the guests running on it. The guest OS would still be 
'lying' by reporting that is running with the mitigation turned off, but 
I suppose this is preferable to overriding the host's security policy.

I think that even with that approach there is still an unsolved problem, 
as I believe guests are allowed to write directly to SPEC_CTRL MSR 
without causing a VMEXIT, which bypasses the host masking entirely.  
e.g. a guest using IBRS writes frequently to SPEC_CTRL, and could turn 
off SSBD on the VPCU while is running after the first non-zero write to 
the MSR. Do you agree?

Thank you for the feedback,
Alejandro

>
> Thanks,
>
> 	tglx
>
>
>

