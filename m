Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA5437F98D
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 16:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhEMOUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 10:20:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234416AbhEMOT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 10:19:59 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DE8IpG085410;
        Thu, 13 May 2021 10:18:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=D8GubXgvk3a14jGGH9ZcrPGCEvPl+rpj3xHeKnJoe40=;
 b=pvUXLAgvibUu99FhfGNttVA7b1lvaOX+UIWgy8seeMZ4RRkdqyPl746sX9mXrb1Ow12G
 9vcxyR9UBvadHFQosJQNuTASu1wnqW0JXY3Jt/1I6sHSGFaFScoLralWnLlNDFVfdd1/
 F1y3RnU76L8uU4WhtCwJNk6FBESes7AuY675UpW0whUEd3s3B58HXQWiNFDxrjb6Dr4x
 OurTXlDntEqPaNkw7FPh+KAdghRGHbcICZrobry3Z0C8Ju+QAzT/kFd6R6zWVdayTh40
 9px3kGZN6myDee71ZohohjX3QGeKMyifKzQh2wQjgEgaeykGA8uYMFdC0f3BdWZeke6d 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38gv83xmds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 10:18:47 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14DE9wBt087999;
        Thu, 13 May 2021 10:18:46 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38gv83xmd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 10:18:46 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14DEIPmP007221;
        Thu, 13 May 2021 14:18:46 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 38fu1y7a1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 14:18:46 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14DEIjis39387560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 14:18:45 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DAD4AC05B;
        Thu, 13 May 2021 14:18:45 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DAEBAC062;
        Thu, 13 May 2021 14:18:45 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 May 2021 14:18:44 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512124120.GV1002214@nvidia.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <759f8840-671a-446c-875b-798dceb10d0f@linux.ibm.com>
Date:   Thu, 13 May 2021 10:18:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512124120.GV1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3yiF0KWnIyI0fAnZuL05koT2Otxrbpng
X-Proofpoint-ORIG-GUID: sraGRDogNU8hh1HU-EFJbx-KLQxDWAbd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_08:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130105
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/12/21 8:41 AM, Jason Gunthorpe wrote:
> On Mon, May 10, 2021 at 05:48:37PM -0400, Tony Krowiak wrote:
>> The mdev remove callback for the vfio_ap device driver bails out with
>> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
>> to prevent the mdev from being removed while in use; however, returning a
>> non-zero rc does not prevent removal. This could result in a memory leak
>> of the resources allocated when the mdev was created. In addition, the
>> KVM guest will still have access to the AP devices assigned to the mdev
>> even though the mdev no longer exists.
>>
>> To prevent this scenario, cleanup will be done - including unplugging the
>> AP adapters, domains and control domains - regardless of whether the mdev
>> is in use by a KVM guest or not.
>>
>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
>>   1 file changed, 2 insertions(+), 11 deletions(-)
> Can you please ensure this goes to a -rc branch or through Alex's
> tree?

I'm sorry, I don't know what a -rc branch is nor how to push this
to Alex's tree, but I'd be happy to do so if you tell me now:)

>
> Thanks,
> Jason

