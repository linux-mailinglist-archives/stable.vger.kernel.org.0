Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5E33192F1
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 20:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhBKTT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 14:19:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23532 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBKTT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 14:19:27 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BJDZPR172473;
        Thu, 11 Feb 2021 14:18:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XygTai7ZhjE5apnzyxrtZi8mhqFyWr/G+yX5QKTv8fA=;
 b=Rwu5ZTCNknxsc6TNaie+FrAhhP98iySHSDlUDZ+ScTJA/9UGQB6T5KP+PrEzJ2n6spMX
 Z7pEZ/vURJLc8Hg5Wpyk4/Ev63QRoy3CyQXIXnbAlAXLvVLw6rJ4JWJurRji5lUeqwIp
 szTy/IA3lTSxc2DjNhH9pwdiVFzzW2JF9pY8tdow0s0VBDwCexz8iEQbrJkJaNqTWwB4
 6iUUAEkJuKcjeaaxCW5zlBALZYCpZr9mOSTh9EkjcOJtjPabm9oOs0hptrqoHWVJU7tp
 8YLznYRcO5qNLURxunfLpocUB69iHU2vVmKeQwcu17RK6Vxua3kNDgwJSEL0OhburJ6L uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36naj08472-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 14:18:46 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11BJEvPe176596;
        Thu, 11 Feb 2021 14:18:45 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36naj0846m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 14:18:45 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BJBSXq013400;
        Thu, 11 Feb 2021 19:18:44 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 36hjr9qw8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 19:18:44 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BJIiv128836102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 19:18:44 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF62F112063;
        Thu, 11 Feb 2021 19:18:43 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 524A9112061;
        Thu, 11 Feb 2021 19:18:43 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.203.235])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 19:18:43 +0000 (GMT)
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
 <8c461602-8c2c-4dd9-1d2b-5e424fc701f8@linux.ibm.com>
 <20210211174750.24d91a65.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <39ee96d0-1a5a-ec4b-4816-2caf619d47be@linux.ibm.com>
Date:   Thu, 11 Feb 2021 14:18:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210211174750.24d91a65.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=985 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110151
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/11/21 11:47 AM, Halil Pasic wrote:
> On Thu, 11 Feb 2021 09:21:26 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Yes, it makes sense. I guess I didn't look closely at your
>> suggestion when I said it was exactly what I implemented
>> after agreeing with Connie. I had a slight difference in
>> my implementation:
>>
>> static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>> {
>>       struct kvm *kvm;
>>
>>       mutex_lock(&matrix_dev->lock);
>>
>>       if (matrix_mdev->kvm) {
>>           kvm = matrix_mdev->kvm;
>>           mutex_unlock(&matrix_dev->lock);
> The problem with this one is that as soon as we drop
> the lock here, another thread can in theory execute
> the critical section below, which drops our reference
> to kvm via kvm_put_kvm(kvm). Thus when we enter
> kvm_arch_crypto_clear_mask(), even if we are guaranteed
> to have a non-null pointer, the pointee is not guaranteed
> to be around. So like Connie suggested, you better take
> another reference to kvm in the first critical section.

Sure.

>
> Regards,
> Halil
>
>>           kvm_arch_crypto_clear_masks(kvm);
>>           mutex_lock(&matrix_dev->lock);
>>           kvm->arch.crypto.pqap_hook = NULL;
>>           vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>>           matrix_mdev->kvm = NULL;
>>           kvm_put_kvm(kvm);
>>       }
>>
>>       mutex_unlock(&matrix_dev->lock);
>> }

