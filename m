Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F05387525
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 11:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbhERJby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 05:31:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20952 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240100AbhERJbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 05:31:53 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14I92ovB060806;
        Tue, 18 May 2021 05:30:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+73G4iYiJwotX63fMRiCMOVJPpMNf7eP+rGiJGZlsJ4=;
 b=p/Me31qq6Qwfpa0q9svke6AGZOXda5Eq5v2Kr1vYMOxjL4zlbruk02UGcdTP6pn3W/4Z
 plZ9fNnv6vI0ek+yQ3efKFegHopVDBwLrS0hRNVmNbmPlCL27tpy18QsmDUzhClifRez
 0wfH/Pn8KZWEvnO+tkKCJjHztjGzii7hSJa6PKPSju/vA80Ij0vQmQRQGp1JVmPWyux7
 vW6jUUYrT5/crYyrtVvU/gHBmpekdhsrXkQm1/Vxyjw+awT3FbI+VvWAkCJdbcdPvnhZ
 BvVVBuIP3tvTXhHAHMviKWPdchbyFl1onrCf1WxaJpAFmKo8j7UujIked8mF2DmZxatm KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38m8uvkr4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 05:30:34 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14I944Kv065504;
        Tue, 18 May 2021 05:30:34 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38m8uvkr3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 05:30:33 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14I9RhsS002084;
        Tue, 18 May 2021 09:30:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 38j5jh0r6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 09:30:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14I9USp024772888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 09:30:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE92E4C04E;
        Tue, 18 May 2021 09:30:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36EBA4C044;
        Tue, 18 May 2021 09:30:28 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.42.71])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 09:30:28 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
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
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <966a60ad-bdde-68d0-ae2f-06121c6ad970@de.ibm.com>
Date:   Tue, 18 May 2021 11:30:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210517211030.368ca64b.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TQwsr9HUi8vLd4mSM0Rv1rBj9m5TBD3W
X-Proofpoint-GUID: QaWeeB09EWreJr9ayiND5uz2uhmDgFEj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_04:2021-05-17,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180066
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 17.05.21 21:10, Halil Pasic wrote:
> On Mon, 17 May 2021 09:37:42 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>>>
>>> Because of this, I don't think the rest of your argument is valid.
>>
>> Okay, so your concern is that between the point in time the
>> vcpu->kvm->arch.crypto.pqap_hook pointer is checked in
>> priv.c and the point in time the handle_pqap() function
>> in vfio_ap_ops.c is called, the memory allocated for the
>> matrix_mdev containing the struct kvm_s390_module_hook
>> may get freed, thus rendering the function pointer invalid.
>> While not impossible, that seems extremely unlikely to
>> happen. Can you articulate a scenario where that could
>> even occur?
> 
> Malicious userspace. We tend to do the pqap aqic just once
> in the guest right after the queue is detected. I do agree
> it ain't very likely to happen during normal operation. But why are
> you asking?

Would it help, if the code in priv.c would read the hook once
and then only work on the copy? We could protect that with rcu
and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
unsetting the pointer?
> 
> I'm not sure I understood correctly what kind of a scenario are
> you asking for. PQAP AQIC and mdev remove are independent
> events originated in userspace, so AFAIK we may not assume
> that the execution of two won't overlap, nor are we allowed
> to make assumptions on how does the execution of these two
> overlap (except for the things we explicitly ensure -- e.g.
> some parts are made mutually exclusive using the matrix_dev->lock
> lock).
> 
> Regards,
> Halil
> 
