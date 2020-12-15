Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E390E2DB362
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 19:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgLOSMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 13:12:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729543AbgLOSMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 13:12:30 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BFI5snt112884;
        Tue, 15 Dec 2020 13:11:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FQb2/87IfrMSQ8h9JJ7+NwekAItOHcn2U0Ghsiz07tU=;
 b=JNRK57bVnCiS0aLyT9LaTF2jN6HamccjpjKAam3gIW2uq82+24NaFBgXoOUcvqZxThbA
 M+l7Z8uuykloMZbarY0NUNHlUtp81A1xjmzA51YYeIr0aQo5v0npFIwmUKraunv4h2uq
 qdW2PRLdqhU5NJ032s5uX4TRO70USRHqntLAuPbMz97QKt6TSTWCZx67lTdOxKzLUyUe
 qdvbzRbVtEbZQiYh8oYLHB6nprW5QnNjbY0K61pE2TL43LsWE7EDpr+mgVc6F3fLSnRv
 iEXQYgpEC/BcX1SF+e5Hc2+AWSji7Mo7TZMpimOfyqm6DloXPLofthncQnsrz71+VUXi eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35f1ar1uwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 13:11:42 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BFIAFZc129446;
        Tue, 15 Dec 2020 13:11:42 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35f1ar1uvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 13:11:42 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BFHv63o022104;
        Tue, 15 Dec 2020 18:11:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8d7ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 18:11:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BFIAMwu30736664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 18:10:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E32EFA406D;
        Tue, 15 Dec 2020 18:10:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5383DA4069;
        Tue, 15 Dec 2020 18:10:21 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.18.42])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Dec 2020 18:10:21 +0000 (GMT)
Subject: Re: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
To:     Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, sashal@kernel.org, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
 <20201215115746.3552e873.pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <44ffb312-964a-95c3-d691-38221cee2c0a@de.ibm.com>
Date:   Tue, 15 Dec 2020 19:10:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201215115746.3552e873.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1011 adultscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150118
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 15.12.20 11:57, Halil Pasic wrote:
> On Mon, 14 Dec 2020 11:56:17 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> The vfio_ap device driver registers a group notifier with VFIO when the
>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>> event). When the KVM pointer is set, the vfio_ap driver takes the
>> following actions:
>> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>>    of the mediated device.
>> 2. Calls the kvm_get_kvm() function to increment its reference counter.
>> 3. Sets the function pointer to the function that handles interception of
>>    the instruction that enables/disables interrupt processing.
>> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>>    the guest.
>>
>> In order to avoid memory leaks, when the notifier is called to receive
>> notification that the KVM pointer has been set to NULL, the vfio_ap device
>> driver should reverse the actions taken when the KVM pointer was set.
>>
>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>  drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
>>  1 file changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index e0bde8518745..cd22e85588e1 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1037,8 +1037,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>  {
>>  	struct ap_matrix_mdev *m;
>>
>> -	mutex_lock(&matrix_dev->lock);
>> -
>>  	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>>  		if ((m != matrix_mdev) && (m->kvm == kvm)) {
>>  			mutex_unlock(&matrix_dev->lock);
>> @@ -1049,7 +1047,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>  	matrix_mdev->kvm = kvm;
>>  	kvm_get_kvm(kvm);
>>  	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
>> -	mutex_unlock(&matrix_dev->lock);
>>
>>  	return 0;
>>  }
>> @@ -1083,35 +1080,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>>  	return NOTIFY_DONE;
>>  }
>>
>> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> 
> 
> This patch LGTM. The only concern I have with it is whether a
> different cpu is guaranteed to observe the above assignment as
> an atomic operation. I think we didn't finish this discussion
> at v1, or did we?

You mean just this assigment:
>> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
should either have the old or the new value, but not halve zero halve old?

Normally this should be ok (and I would consider this a compiler bug if
this is split into 2 32 bit zeroes) But if you really want to be sure then we
can use WRITE_ONCE.
I think we take this via the s390 tree? I can add the WRITE_ONCE when applying?
