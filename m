Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0883172E1
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 23:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhBJWGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 17:06:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52848 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232208AbhBJWGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 17:06:37 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AM2Qne012745;
        Wed, 10 Feb 2021 17:05:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C3bPQy/OSUk1u8psXEfmJeN79nY5kVLMYm5xeQvoZbY=;
 b=HJNazYLfjQsmdrL06Z2e/NfzdPW1OkSB8DE+8z8e7DsBkt7II0/n3OIRuLwLeHfF1432
 9jJ8hh2DpmHy0Ppd9lkF6MJSCBJQVvjRtojekteZzCBbpLo6xGT1SZHLquuNjfu2i+xH
 XF67YvQhSXV4j5SGOa3wyZYbJXbAcE9HKxZ2aRjGDBJ2ht30DTW7MZcYt/EhApM+/Pe5
 qc7/lgiAyLEmAEaQXsxsEBf1Ytd6igirNn5hxbex1eWyf7eqMiKtX1y+98/vJ1XrnNHe
 /OciZCCH45M4mDxGIFcd3mFOjKQ/jEHwtVYpF3VALrLJjQwFVjsGlLlU4lZ9UZ1NsAF8 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mqew8t6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:05:55 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AM2dSx013148;
        Wed, 10 Feb 2021 17:05:54 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mqew8t4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:05:54 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11AM3CXs025484;
        Wed, 10 Feb 2021 22:05:51 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 36hjr9s4yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 22:05:51 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11AM5obD20513076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 22:05:50 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09C026E08F;
        Wed, 10 Feb 2021 22:05:50 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2C646E092;
        Wed, 10 Feb 2021 22:05:48 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.203.235])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 22:05:48 +0000 (GMT)
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
 <20210209194830.20271-2-akrowiak@linux.ibm.com>
 <20210210115334.46635966.cohuck@redhat.com>
 <20210210162429.261fc17c.pasic@linux.ibm.com>
 <20210210163237.315d9a68.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <59e8f084-c9ec-ce25-2326-b206e30d04d0@linux.ibm.com>
Date:   Wed, 10 Feb 2021 17:05:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210210163237.315d9a68.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_10:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 phishscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100188
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/10/21 10:32 AM, Halil Pasic wrote:
> On Wed, 10 Feb 2021 16:24:29 +0100
> Halil Pasic <pasic@linux.ibm.com> wrote:
>
>>> Maybe you could
>>> - grab a reference to kvm while holding the lock
>>> - call the mask handling functions with that kvm reference
>>> - lock again, drop the reference, and do the rest of the processing?
>> I agree, matrix_mdev->kvm can go NULL any time and we are risking
>> a null pointer dereference here.
>>
>> Another idea would be to do
>>
>>
>> static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>> {
>>          struct kvm *kvm;
>>                                                          
>>          mutex_lock(&matrix_dev->lock);
>>          if (matrix_mdev->kvm) {
>>                  kvm = matrix_mdev->kvm;
>>                  matrix_mdev->kvm = NULL;
>>                  mutex_unlock(&matrix_dev->lock);
>>                  kvm_arch_crypto_clear_masks(kvm);
>>                  mutex_lock(&matrix_dev->lock);
>>                  matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> s/matrix_mdev->kvm/kvm
>>                  vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>>                  kvm_put_kvm(kvm);
>>          }
>>          mutex_unlock(&matrix_dev->lock);
>> }
>>
>> That way only one unset would actually do the unset and cleanup
>> and every other invocation would bail out with only checking
>> matrix_mdev->kvm.
> But the problem with that is that we enable the the assign/unassign
> prematurely, which could interfere wit reset_queues(). Forget about
> it.

Not sure what you mean by this.


