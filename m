Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E63A318D52
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 15:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBKOY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 09:24:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13614 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232049AbhBKOWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 09:22:20 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BEIn2U090013;
        Thu, 11 Feb 2021 09:21:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EAAc7sdZKM0yLOqqzwJP9hBT4juqLsOq6INyrlL5lOg=;
 b=Kahj3gTL9vz0pJH29yiXQ4jTonpWklA/4S9yUMwxT/C0zan74uR8+86G4Lkvebzbr6HV
 6ez31bQkYUVbE9j6Ecxiq4DaiB3IAHACh6RGLdKleHMhmjRGSaJXaaDK8P2ro4tkN7PX
 sgztiw2PLOh6ydTQrVN+sCifC+fFa93Wv+hItaHO1dBuNV+ok2mE57bwN4cPR3RCGPW2
 nZACxrNVgsSAP3u9/blZb8ZgpCSKxJ+nBOKsTcuhXVGCpEbmfQTFV1MpZzW6KyugjlUl
 rr9mJOZwHhLih2bPuZqk0VEuC9792tnrvylcCbJcqimihdqUDYbm7Ce8rt+XlFkhof5s cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36n67ur1sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 09:21:28 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11BEJSsQ091786;
        Thu, 11 Feb 2021 09:21:28 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36n67ur1s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 09:21:28 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BEHWnt001605;
        Thu, 11 Feb 2021 14:21:27 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 36hjr9p5qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 14:21:27 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BELRRB28770654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 14:21:27 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34DFC112066;
        Thu, 11 Feb 2021 14:21:27 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98D31112062;
        Thu, 11 Feb 2021 14:21:26 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.203.235])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 14:21:26 +0000 (GMT)
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, borntraeger@de.ibm.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
 <20210209194830.20271-2-akrowiak@linux.ibm.com>
 <20210210115334.46635966.cohuck@redhat.com>
 <20210210162429.261fc17c.pasic@linux.ibm.com>
 <20210210163237.315d9a68.pasic@linux.ibm.com>
 <59e8f084-c9ec-ce25-2326-b206e30d04d0@linux.ibm.com>
 <20210210234606.1d0dbdec.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8c461602-8c2c-4dd9-1d2b-5e424fc701f8@linux.ibm.com>
Date:   Thu, 11 Feb 2021 09:21:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210210234606.1d0dbdec.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_06:2021-02-10,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110118
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/10/21 5:46 PM, Halil Pasic wrote:
> On Wed, 10 Feb 2021 17:05:48 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 2/10/21 10:32 AM, Halil Pasic wrote:
>>> On Wed, 10 Feb 2021 16:24:29 +0100
>>> Halil Pasic <pasic@linux.ibm.com> wrote:
>>>   
>>>>> Maybe you could
>>>>> - grab a reference to kvm while holding the lock
>>>>> - call the mask handling functions with that kvm reference
>>>>> - lock again, drop the reference, and do the rest of the processing?
>>>> I agree, matrix_mdev->kvm can go NULL any time and we are risking
>>>> a null pointer dereference here.
>>>>
>>>> Another idea would be to do
>>>>
>>>>
>>>> static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>>>> {
>>>>           struct kvm *kvm;
>>>>                                                           
>>>>           mutex_lock(&matrix_dev->lock);
>>>>           if (matrix_mdev->kvm) {
>>>>                   kvm = matrix_mdev->kvm;
>>>>                   matrix_mdev->kvm = NULL;
>>>>                   mutex_unlock(&matrix_dev->lock);
>>>>                   kvm_arch_crypto_clear_masks(kvm);
>>>>                   mutex_lock(&matrix_dev->lock);
>>>>                   matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>>> s/matrix_mdev->kvm/kvm
>>>>                   vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>>>>                   kvm_put_kvm(kvm);
>>>>           }
>>>>           mutex_unlock(&matrix_dev->lock);
>>>> }
>>>>
>>>> That way only one unset would actually do the unset and cleanup
>>>> and every other invocation would bail out with only checking
>>>> matrix_mdev->kvm.
>>> But the problem with that is that we enable the the assign/unassign
>>> prematurely, which could interfere wit reset_queues(). Forget about
>>> it.
>> Not sure what you mean by this.
>>
>>
> I mean because above I first do
> (1) matrix_mdev->kvm = NULL;
> and then do
> (2) vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> another thread could do
> static ssize_t unassign_adapter_store(struct device *dev,
>                                        struct device_attribute *attr,
>                                        const char *buf, size_t count)
> {
>          int ret;
>          unsigned long apid;
>          struct mdev_device *mdev = mdev_from_dev(dev);
>          struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>                                                                                  
>          /* If the guest is running, disallow un-assignment of adapter */
>          if (matrix_mdev->kvm)
>                  return -EBUSY;
> ...
> }
> between (1) and (2), and we would not bail out with -EBUSY because !!kvm
> because of (1). That means we would change matrix_mdev->matrix and we
> would not reset the queues that correspond to the apid that was just
> removed, because by the time we do the reset_queues, the queues are
> not in the matrix_mdev->matrix any more.
>
> Does that make sense?

Yes, it makes sense. I guess I didn't look closely at your
suggestion when I said it was exactly what I implemented
after agreeing with Connie. I had a slight difference in
my implementation:

static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
{
     struct kvm *kvm;

     mutex_lock(&matrix_dev->lock);

     if (matrix_mdev->kvm) {
         kvm = matrix_mdev->kvm;
         mutex_unlock(&matrix_dev->lock);
         kvm_arch_crypto_clear_masks(kvm);
         mutex_lock(&matrix_dev->lock);
         kvm->arch.crypto.pqap_hook = NULL;
         vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
         matrix_mdev->kvm = NULL;
         kvm_put_kvm(kvm);
     }

     mutex_unlock(&matrix_dev->lock);
}

In your scenario, the unassignment would fail with -EBUSY because
the matrix_mdev->kvm pointer would not have yet been
cleared. The other problem with your implementation is that
IRQ resources would not get cleared after the reset because
the matrix_mdev->kvm pointer would be NULL at that time.
