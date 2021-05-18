Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE54387A34
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 15:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhERNnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 09:43:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32662 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231718AbhERNnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 09:43:00 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IDX03t044105;
        Tue, 18 May 2021 09:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pOIHMhFzCXCPWmC6yM0WDfHScvMC60L69Vu1xZDuV+k=;
 b=buOqMCqUbs05ypERFCytSfHKY8NvqNnh64Ow+u3cB3i0gsQxycTGJubcIwiwthFmDcFN
 yaub+ZhiAQREogTHB0aTYDvPxsZY4PT6IFHVXlHE7+LPvSlAHi/HuRKKoaWFL2C3ZJW9
 Ld5Wl4gGfSTxHx9F/s/kzccsY23ZCsXglZ30BoDVd+wLwfyROjvYeFIvO0Fe2k8MwX46
 K6sv56gqKtAkUN+jam5Oti3HuvcjIpsv4NhMs4oLP05XPBz6SOgDixM98O0GrbGTXGXV
 B3JZusbfl+VDqH36ka2vCnBKfBfejgwO6x4y0A0yHaoU4Yq07Jt7KSPbmp/6ix85eb8A 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mc33w0ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 09:41:38 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IDYK7Z051492;
        Tue, 18 May 2021 09:41:37 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mc33w0nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 09:41:37 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IDcl03021963;
        Tue, 18 May 2021 13:41:37 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 38j7taxw9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 13:41:37 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IDfaAU31260994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 13:41:36 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63AF8AC075;
        Tue, 18 May 2021 13:41:36 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF779AC068;
        Tue, 18 May 2021 13:41:35 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 13:41:35 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512203536.4209c29c.pasic@linux.ibm.com>
 <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
 <20210513194541.58d1628a.pasic@linux.ibm.com>
 <243086e2-08a0-71ed-eb7e-618a62b007e4@linux.ibm.com>
 <20210514021500.60ad2a22.pasic@linux.ibm.com>
 <594374f6-8cf6-4c22-0bac-3b224c55bbb6@linux.ibm.com>
 <20210517211030.368ca64b.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <f9785365-0269-c22e-f9b1-c261a15dad23@linux.ibm.com>
Date:   Tue, 18 May 2021 09:41:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210517211030.368ca64b.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jei_MJs9UKrk_-BTfg_EgVxlxWZhhFex
X-Proofpoint-ORIG-GUID: tPi5cajfSfIEV8GjPca5OHFx9Kz7Wr-S
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_04:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 mlxscore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180096
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/17/21 3:10 PM, Halil Pasic wrote:
> On Mon, 17 May 2021 09:37:42 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>> Because of this, I don't think the rest of your argument is valid.
>> Okay, so your concern is that between the point in time the
>> vcpu->kvm->arch.crypto.pqap_hook pointer is checked in
>> priv.c and the point in time the handle_pqap() function
>> in vfio_ap_ops.c is called, the memory allocated for the
>> matrix_mdev containing the struct kvm_s390_module_hook
>> may get freed, thus rendering the function pointer invalid.
>> While not impossible, that seems extremely unlikely to
>> happen. Can you articulate a scenario where that could
>> even occur?
> Malicious userspace. We tend to do the pqap aqic just once
> in the guest right after the queue is detected. I do agree
> it ain't very likely to happen during normal operation. But why are
> you asking?

I'm just trying to wrap my head around how this can
happen given the incredibly small window between
access to the pointer to the structure containing the
function pointer and access to the function pointer
itself.

>
> I'm not sure I understood correctly what kind of a scenario are
> you asking for. PQAP AQIC and mdev remove are independent
> events originated in userspace, so AFAIK we may not assume
> that the execution of two won't overlap, nor are we allowed
> to make assumptions on how does the execution of these two
> overlap (except for the things we explicitly ensure -- e.g.
> some parts are made mutually exclusive using the matrix_dev->lock
> lock).

It looks like we need a way to control access to the
struct kvm_s390_module_hook. I'm looking into
Christian's suggestion for using RCU as well as other
solutions.

>
> Regards,
> Halil
>

