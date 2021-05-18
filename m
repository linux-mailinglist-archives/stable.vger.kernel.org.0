Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FD7387A3D
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 15:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhERNna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 09:43:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230217AbhERNn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 09:43:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IDXX7v128662;
        Tue, 18 May 2021 09:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wrCmGTA3qV1P4OBAi41PqexRyVV215cQoS1i46SG2TY=;
 b=WID3jdexlsL5dZpe9hlpJNDcAgh4+h0dDv25dDXaBLtw7KlHFpxKGG2pKQeFhkh6GgTd
 ZRrfYCuqIzspz79frBxOok+J9Rz/H3p2kcCjw7Iln1Pse+MpZEjs3V74U8jD5qklQBDt
 G4Mhyk8hniGM9gcK/wLyRLv49kENIbdDanTxoDJrmEFane0l0BzO3Xaq3aUQJt+xyxen
 TrwUQHg/XRSSpQpZxp6oQUPDTS95H8okeT1eAjX7fXOSVdcGHtl3AaT6gRhSTWsfYk3U
 KJ9G086SnxphmPM9oVmRdNcYQdu/kfbeTP6RVo47z5QsjQsfOBCCb3QOCGr7BYQoJtHR qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mc9vcugn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 09:42:08 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IDYia6135192;
        Tue, 18 May 2021 09:42:07 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mc9vcug1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 09:42:07 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IDawON009278;
        Tue, 18 May 2021 13:42:06 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 38j5x9d6fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 13:42:06 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IDg5oS28312052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 13:42:05 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8B79AC069;
        Tue, 18 May 2021 13:42:05 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59C1DAC06D;
        Tue, 18 May 2021 13:42:05 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 13:42:05 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        jgg@nvidia.com, alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512203536.4209c29c.pasic@linux.ibm.com>
 <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
 <20210513194541.58d1628a.pasic@linux.ibm.com>
 <243086e2-08a0-71ed-eb7e-618a62b007e4@linux.ibm.com>
 <20210514021500.60ad2a22.pasic@linux.ibm.com>
 <594374f6-8cf6-4c22-0bac-3b224c55bbb6@linux.ibm.com>
 <20210517211030.368ca64b.pasic@linux.ibm.com>
 <966a60ad-bdde-68d0-ae2f-06121c6ad970@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <9ebd5fd8-b093-e5bc-e680-88fa7a9b085c@linux.ibm.com>
Date:   Tue, 18 May 2021 09:42:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <966a60ad-bdde-68d0-ae2f-06121c6ad970@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BDl3obggwP77k2A2gDiCvZ7Cq3D47TiJ
X-Proofpoint-GUID: opj8dfyHcutsGLgKwZeBn8590IoVbS4_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_04:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105180096
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/18/21 5:30 AM, Christian Borntraeger wrote:
>
>
> On 17.05.21 21:10, Halil Pasic wrote:
>> On Mon, 17 May 2021 09:37:42 -0400
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>>>
>>>> Because of this, I don't think the rest of your argument is valid.
>>>
>>> Okay, so your concern is that between the point in time the
>>> vcpu->kvm->arch.crypto.pqap_hook pointer is checked in
>>> priv.c and the point in time the handle_pqap() function
>>> in vfio_ap_ops.c is called, the memory allocated for the
>>> matrix_mdev containing the struct kvm_s390_module_hook
>>> may get freed, thus rendering the function pointer invalid.
>>> While not impossible, that seems extremely unlikely to
>>> happen. Can you articulate a scenario where that could
>>> even occur?
>>
>> Malicious userspace. We tend to do the pqap aqic just once
>> in the guest right after the queue is detected. I do agree
>> it ain't very likely to happen during normal operation. But why are
>> you asking?
>
> Would it help, if the code in priv.c would read the hook once
> and then only work on the copy? We could protect that with rcu
> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
> unsetting the pointer?

I'll look into this.

>>
>> I'm not sure I understood correctly what kind of a scenario are
>> you asking for. PQAP AQIC and mdev remove are independent
>> events originated in userspace, so AFAIK we may not assume
>> that the execution of two won't overlap, nor are we allowed
>> to make assumptions on how does the execution of these two
>> overlap (except for the things we explicitly ensure -- e.g.
>> some parts are made mutually exclusive using the matrix_dev->lock
>> lock).
>>
>> Regards,
>> Halil
>>

