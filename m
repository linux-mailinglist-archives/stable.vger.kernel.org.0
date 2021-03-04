Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C275132D7BF
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 17:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbhCDQZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 11:25:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236822AbhCDQZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 11:25:50 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 124GDuCT067189;
        Thu, 4 Mar 2021 11:25:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zocqs67l/MZY4ZkwtXWxHu4Wqu0Qn3ypuSqnvVRrCtQ=;
 b=ZiM0NvUXeL3/GTKLGhhXJaacdHt2gUBBFLahcQwDQqrs3pUWO7EvcrnrbYO6haPEGMn8
 F85DbgDWXxASWYrXIaDBaNuztkkUDcb++noj3PYZaX4p6D9crKxjWFFAfnPYbkEC7ZOk
 CnOzLG8EBSOUiy6BeZoNuiZGRcR2dpvkBQLjn2pIMv8+eCaF6RlrdD7naQQ6m5dbeHRC
 11qbSGU0WfeGp3KNqiPnYqVe6yESMLjxE5heUSOkgZMR+G42aAh/z7qU7ftKLMTzUp6P
 4mdKkImWskBM9Na/zPltZGqTBef+mig/1fVoMoMS6id7z0lZrxiTHk1xap8VgX4THw42 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3732vs0qb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 11:25:05 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 124GDw4T067469;
        Thu, 4 Mar 2021 11:23:17 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3732vs0pfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 11:23:17 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 124GI2RK018473;
        Thu, 4 Mar 2021 16:22:31 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 36ydq9g0fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 16:22:31 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 124GMUZP18219434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Mar 2021 16:22:30 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADE8F6E053;
        Thu,  4 Mar 2021 16:22:30 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AB4B6E052;
        Thu,  4 Mar 2021 16:22:29 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.150.254])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  4 Mar 2021 16:22:28 +0000 (GMT)
Subject: Re: [PATCH v3 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20210302204322.24441-1-akrowiak@linux.ibm.com>
 <20210302204322.24441-2-akrowiak@linux.ibm.com>
 <20210303162332.4d227dbe.pasic@linux.ibm.com>
 <e5cc2a81-7273-2b3e-0d4c-c6c17502bdae@linux.ibm.com>
 <20210303204211.4c021c25.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <c623c4d6-4cda-9521-ec5e-e4d6fd978a90@linux.ibm.com>
Date:   Thu, 4 Mar 2021 11:22:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210303204211.4c021c25.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-04_05:2021-03-03,2021-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040076
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/3/21 2:42 PM, Halil Pasic wrote:
> On Wed, 3 Mar 2021 11:41:22 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>> How do you exect userspace to react to this -ENODEV?
>> The VFIO_DEVICE_RESET ioctl expects a return code.
>> The vfio_ap_mdev_reset_queues() function can return -EIO or
>> -EBUSY, so I would expect userspace to handle -ENODEV
>> similarly to -EIO or any other non-zero return code. I also
>> looked at all of the VFIO_DEVICE_RESET calls from QEMU to see
>> how the return from the ioctl call is handled:
>>
>> * ap: reports the reset failed along with the rc
> And carries on as if nothing happened. There is not much smart
> userspace can do in such a situation. Therefore the reset really
> should not fail.

Regardless of what we decide to do here, there is the
possibility that the vfio_ap_mdev_reset_queues()
function will return an error, so your point is moot
and maybe should be brought up as a QEMU
implementation issue. I don't think it is encumbent
upon the KVM code to anticipate how userspace
will respond to a non-zero return code. I think the
pertinent question is what return code makes sense.
Having said that, I have other concerns which I
discussed below.

>
> Please note that in this particular case, if the userspace would
> opt for a retry, we would most likely end up in a retry loop.
>
>> * ccw: doesn't check the rc
>> * pci: kind of hard to follow without digging deep, but definitely
>>            handles non-zero rc.
>>
>> I think the caller should be notified whether the queues were
>> successfully reset or not, and why; in this case, the answer is
>> there are no devices to reset.
> That is the wrong answer. The ioctl is supposed to reset the
> ap_matrix_mdev device. The ap_matrix_mdev device still exists. Thus
> returning -ENODEV is bugous.

That makes sense and it begs the question, what does it mean to
reset the mdev? Is resetting the queues an appropriate response
to the VFIO_DEVICE_RESET ioctl call?

The purpose of the mdev is to supply the AP configuration to a KVM
guest. The queues themselves belong to the guest. If the guest enables
interrupts for a queue and vfio_ap does a reset in response to the ioctl
call, then the guest will be sitting there waiting for interrupts which
have been disabled by the reset. It seems that as long as a guest is
using the mdev, then management of its queues (i.e., reset) should be
left to the guest. Unless there is something to reset as far as the
mdev is concerned, maybe the response to the VFIO_RESET_DEVICE
ioctl ought to be a NOP regardless of the value of ->kvm.

>
> Regards,
> Halil

