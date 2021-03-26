Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F48434A810
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 14:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhCZNZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 09:25:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3104 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229744AbhCZNZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Mar 2021 09:25:18 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12QD4s0u037376;
        Fri, 26 Mar 2021 09:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yTEHzE0d5rgCp5gfrs++sWR+G5T0kyGFfT/9zOOv+eY=;
 b=L8FQb0MJS+XH/1+GrR1Czz5RuaQic/+eJFEv/iENx0UqGKtmJc7CWcTPlq3jKjjkdMpv
 Sq2TmbbGMt2vWa1pLT8p6wq6ZyOExi/KnRTSh83k7us64XiVDJ0XhTGvS2GJGGSGVrvn
 sRqlM7JvsLnsdS2+8/sI16SO+aYWraDq1Xm1tBvUebikVglhe/yS3jpzVOABsg5qvZw+
 JIPwuhhU/zKWtJc8TKs5Q2d9/mPStAsfEpzP0NDNPO1yMvd/uGUrgocWjuz+1uOC1oBG
 qcMyQGJ4GXgb43hyNex0xDU+yO165BCT8xNcJeb2arOr0SfP79UjJAcAeQloXiHZLsXI pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37h75dp1yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 09:25:16 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12QDJkD9115413;
        Fri, 26 Mar 2021 09:25:16 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37h75dp1y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 09:25:15 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12QDGWZ2014330;
        Fri, 26 Mar 2021 13:25:15 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04wdc.us.ibm.com with ESMTP id 37h14h5ckp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 13:25:15 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12QDPEec33227262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 13:25:15 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E204D112062;
        Fri, 26 Mar 2021 13:25:14 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FA78112065;
        Fri, 26 Mar 2021 13:25:14 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.149.97])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 26 Mar 2021 13:25:14 +0000 (GMT)
Subject: Re: [PATCH v5 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20210325124640.23995-1-akrowiak@linux.ibm.com>
 <20210325124640.23995-2-akrowiak@linux.ibm.com>
 <20210325213210.62cb11b9.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <4973feca-4eee-7139-26e6-1b926c017263@linux.ibm.com>
Date:   Fri, 26 Mar 2021 09:25:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210325213210.62cb11b9.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CDWOdLx8MJgpB0FOURAFBtbTSM4jko47
X-Proofpoint-ORIG-GUID: MANubsScoTQwJ0YObvjP5J89Ayk0dy7Q
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_06:2021-03-26,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/25/21 4:32 PM, Halil Pasic wrote:
> On Thu, 25 Mar 2021 08:46:40 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> This patch fixes a lockdep splat introduced by commit f21916ec4826
>> ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated").
>> The lockdep splat only occurs when starting a Secure Execution guest.
>> Crypto virtualization (vfio_ap) is not yet supported for SE guests;
>> however, in order to avoid this problem when support becomes available,
>> this fix is being provided.
>>
>> The circular locking dependency was introduced when the setting of the
>> masks in the guest's APCB was executed while holding the matrix_dev->lock.
>> While the lock is definitely needed to protect the setting/unsetting of the
>> matrix_mdev->kvm pointer, it is not necessarily critical for setting the
>> masks; so, the matrix_dev->lock will be released while the masks are being
>> set or cleared.
>>
>> Keep in mind, however, that another process that takes the matrix_dev->lock
>> can get control while the masks in the guest's APCB are being set or
>> cleared as a result of the driver being notified that the KVM pointer
>> has been set or unset. This could result in invalid access to the
>> matrix_mdev->kvm pointer by the intervening process. To avoid this
>> scenario, two new fields are being added to the ap_matrix_mdev struct:
>>
>> struct ap_matrix_mdev {
>> 	...
>> 	bool kvm_busy;
>> 	wait_queue_head_t wait_for_kvm;
>>     ...
>> };
>>
>> The functions that handle notification that the KVM pointer value has
>> been set or cleared will set the kvm_busy flag to true until they are done
>> processing at which time they will set it to false and wake up the tasks on
>> the matrix_mdev->wait_for_kvm wait queue. Functions that require
>> access to matrix_mdev->kvm will sleep on the wait queue until they are
>> awakened at which time they can safely access the matrix_mdev->kvm
>> field.
>>
>> Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
>
> I intend to give a couple of work-days to others, and if nobody objects
> merge this. (I will wait till Tuesday.)

Thanks Halil.

>
> I've tested it and it does silence the lockdep splat.
>
> Regards,
> Halil

