Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DDC340C2F
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 18:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCRRyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 13:54:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20560 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231701AbhCRRyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 13:54:12 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IHYGmd110707;
        Thu, 18 Mar 2021 13:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qLCwOqi9nd43vs0sC/0uaogdbKlQGtsnrdpGyMt5BJs=;
 b=isZDdiLBECrzDrBfVyYWnCyjmp7QYlffD7yjzpfqfI75oPT3bfQKDV3pUwIWqzSQAjeL
 xF2H5wUrhb9TCx+bLH1FFXq+5bQEuL6iUHr4IrCU6vGiscHx6WdwHDJkZeICaqsyQKf8
 IvmhU/r9xPdPT9Z7QhOMWDKSDswBqELWT99REn1BNy4k3UuaW80lok3cguXpmscYqCMN
 0/Xtg18FkFBVZV9uj8y7hCqGzu93bIzI58n62/m+FUS+j3mjBbAPt38p42KDV7uImWjx
 omds7FNgzJqZIcSdQRhQfrU9OGa2pJL3oo/GlYhewWchBIPGUobWZ7TayC5qvKdtGjJy ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37by16g5us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 13:54:10 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12IHYjXl112318;
        Thu, 18 Mar 2021 13:54:10 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37by16g5uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 13:54:10 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IHq5xV006661;
        Thu, 18 Mar 2021 17:54:09 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 378n19gekv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 17:54:09 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IHs8tN32637184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 17:54:09 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E298FAE05F;
        Thu, 18 Mar 2021 17:54:08 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E19CAE05C;
        Thu, 18 Mar 2021 17:54:07 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.150.254])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 17:54:07 +0000 (GMT)
Subject: Re: [PATCH v4 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20210310150559.8956-1-akrowiak@linux.ibm.com>
 <20210310150559.8956-2-akrowiak@linux.ibm.com>
 <20210318001729.06cdb8d6.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <d98ab0e1-dca3-0ea7-2478-387e3698900e@linux.ibm.com>
Date:   Thu, 18 Mar 2021 13:54:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210318001729.06cdb8d6.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_09:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180124
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/17/21 7:17 PM, Halil Pasic wrote:
> On Wed, 10 Mar 2021 10:05:59 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> -		ret = vfio_ap_mdev_reset_queues(mdev);
>> +		matrix_mdev = mdev_get_drvdata(mdev);
> Is it guaranteed that matrix_mdev can't be NULL here? If yes, please
> remind me of the mechanism that ensures this.

The matrix_mdev is set as drvdata when the mdev is created and
is only cleared when the mdev is removed. Likewise, this function
is a callback defined by by vfio in the vfio_ap_matrix_ops structure
when the matrix_dev is registered and is intended to handle ioctl
calls from userspace during the lifetime of the mdev. While I can't
speak definitively to the guarantee, I think it is extremely unlikely
that matrix_mdev would be NULL at this point. On the other hand,
it wouldn't hurt to check for NULL and log an error or warning
message (I prefer an error here) if NULL.

>
>> +
>> +		/*
>> +		 * If the KVM pointer is in the process of being set, wait until
>> +		 * the process has completed.
>> +		 */
>> +		wait_event_cmd(matrix_mdev->wait_for_kvm,
>> +			       matrix_mdev->kvm_busy == false,
>> +			       mutex_unlock(&matrix_dev->lock),
>> +			       mutex_lock(&matrix_dev->lock));
>> +
>> +		if (matrix_mdev->kvm)
>> +			ret = vfio_ap_mdev_reset_queues(mdev);
>> +		else
>> +			ret = -ENODEV;
> Didn't we agree to make the call to vfio_ap_mdev_reset_queues()
> unconditional again (for reference please take look at
> Message-ID: <64afa72c-2d6a-2ca1-e576-34e15fa579ed@linux.ibm.com>)?

Yes, we did agree to that and I changed it at the time. That change
got lost somehow; I'll reinstate it.

>
> Regards,
> Halil

