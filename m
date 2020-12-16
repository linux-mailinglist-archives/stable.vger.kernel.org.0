Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE762DBE1F
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 11:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgLPJ7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 04:59:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgLPJ7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 04:59:43 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BG9ZnE9119310;
        Wed, 16 Dec 2020 04:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=+Ch0kvmh8WM3BN+PdWT2eAMfO/wmfKVj7HkwjL1Qf/M=;
 b=tNQQQ0j1zyN9DDC0c4Zhld6lElrWedeu4sG4aKDBuprCFePTyL4yX2ubjmNhev3Jpq2Y
 dp/IOraWCWK9noz3ULVUI87zMudyxq1WS1+lOl4T3aBMB/fiLiC0Z/OLgkYV9778E2qX
 CGv7wtPx/d9WIg9G/Uwggqb3GkChwZinfqE/SfKpV3Cjptjo4gI+AN9SxHlhrcmCvyn/
 WxpvM64uhH6G2xSaR+QJYC+Ur/WjapPI/qHKGI7TdmprW4BSN9I3bHTiPaanl0G76BEx
 RAfVSLEMmrYtUWP4su3o/CR3eduoGRvXPgytGpYWIdCf13lVx9upNu6F+25niccsRjOQ 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ffg10wda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 04:59:00 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BG9x08W005199;
        Wed, 16 Dec 2020 04:59:00 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ffg10wcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 04:59:00 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BG9s9JO005072;
        Wed, 16 Dec 2020 09:58:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 35cng8a5jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 09:58:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BG9wsom31654334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 09:58:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C84E111C052;
        Wed, 16 Dec 2020 09:58:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1441111C058;
        Wed, 16 Dec 2020 09:58:54 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.82.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 09:58:54 +0000 (GMT)
Subject: Re: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
 <20201215115746.3552e873.pasic@linux.ibm.com>
 <44ffb312-964a-95c3-d691-38221cee2c0a@de.ibm.com>
 <20201216022140.02741788.pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ae6e5c7a-0159-035e-2bd3-0a749f81a7c0@de.ibm.com>
Date:   Wed, 16 Dec 2020 10:58:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20201216022140.02741788.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_04:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.12.20 02:21, Halil Pasic wrote:
> On Tue, 15 Dec 2020 19:10:20 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>>
>>
>> On 15.12.20 11:57, Halil Pasic wrote:
>>> On Mon, 14 Dec 2020 11:56:17 -0500
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>
>>>> The vfio_ap device driver registers a group notifier with VFIO when the
>>>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>>>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>>>> event). When the KVM pointer is set, the vfio_ap driver takes the
>>>> following actions:
>>>> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>>>>    of the mediated device.
>>>> 2. Calls the kvm_get_kvm() function to increment its reference counter.
>>>> 3. Sets the function pointer to the function that handles interception of
>>>>    the instruction that enables/disables interrupt processing.
>>>> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>>>>    the guest.
>>>>
>>>> In order to avoid memory leaks, when the notifier is called to receive
>>>> notification that the KVM pointer has been set to NULL, the vfio_ap device
>>>> driver should reverse the actions taken when the KVM pointer was set.
>>>>
>>>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> ---
>>>>  drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
>>>>  1 file changed, 20 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>>> index e0bde8518745..cd22e85588e1 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>>> @@ -1037,8 +1037,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>>>  {
>>>>  	struct ap_matrix_mdev *m;
>>>>
>>>> -	mutex_lock(&matrix_dev->lock);
>>>> -
>>>>  	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>>>>  		if ((m != matrix_mdev) && (m->kvm == kvm)) {
>>>>  			mutex_unlock(&matrix_dev->lock);
>>>> @@ -1049,7 +1047,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>>>  	matrix_mdev->kvm = kvm;
>>>>  	kvm_get_kvm(kvm);
>>>>  	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
>>>> -	mutex_unlock(&matrix_dev->lock);
>>>>
>>>>  	return 0;
>>>>  }
>>>> @@ -1083,35 +1080,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>>>>  	return NOTIFY_DONE;
>>>>  }
>>>>
>>>> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>>>> +{
>>>> +	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>>>> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>>>
>>>
>>> This patch LGTM. The only concern I have with it is whether a
>>> different cpu is guaranteed to observe the above assignment as
>>> an atomic operation. I think we didn't finish this discussion
>>> at v1, or did we?
>>
>> You mean just this assigment:
>>>> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>> should either have the old or the new value, but not halve zero halve old?
>>
> 
> Yes that is the assignment I was referring to. Old value will work as well because
> kvm holds a reference to this module while in the pqap_hook.
>  
>> Normally this should be ok (and I would consider this a compiler bug if
>> this is split into 2 32 bit zeroes) But if you really want to be sure then we
>> can use WRITE_ONCE.
> 
> Just my curiosity: what would make this a bug? Is it the s390 elf ABI,
> or some gcc feature, or even the C standard? Also how exactly would
> WRITE_ONCE, also access via volatile help in this particular situation?

I think its a tricky things and not strictly guaranteed, but there is a lot
of code that relies on the atomicity of word sizes. see for example the discussion
here
https://lore.kernel.org/lkml/CAHk-=wgC4+kV9AiLokw7cPP429rKCU+vjA8cWAfyOjC3MtqC4A@mail.gmail.com/

WRITE_ONCE will not change the guarantees a lot, but it is mostly a documentation
that we assume atomic access here.


> 
> I agree, if the member is properly aligned, (which it is),
> normally/probably we are fine on s390x (which is also a given). 
> 
>> I think we take this via the s390 tree? I can add the WRITE_ONCE when applying?
> 
> Yes that works fine with me.
> 
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> 
