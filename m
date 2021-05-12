Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B8937C5AB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbhELPmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50331 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234668AbhELPeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 11:34:09 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CF3fAt007735;
        Wed, 12 May 2021 11:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ng1J+lMiJe3sOK3DH3Ib75MLLnnHvxDE15y37rc9h1s=;
 b=Fb5XJI9Gft6YvCG6QTwydRVQsab6EtTl7MI24vbliFLtR2lutBTGuLNkdaf5mOpKy4wf
 XA1tpcj4ggbtUIIcKLaI/2r0skH0UG6owURg3eFhyDO/p+1nikqbGjLold6cabLghkGP
 UVKaQfhq/hRD9+8osXjx8QxbpiiCChirCQcpfYkuXImX11o4NLvMqCOJzvlGuz3Rhi12
 8aJmJ+G2vV6XG94tIQfCzh7feigxmq4JLyv9Sn1nxdo2cCxF/53gx7HU3USqr03c8U6N
 /1IgfxLA6m8Ny8a+Iq6m1seikfKtKPN/HMoRnr17+YobI7lK82zfCt381Z+sF6/ZzCL1 Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38gg8rjuy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 11:32:58 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14CF5Hkk024665;
        Wed, 12 May 2021 11:32:58 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38gg8rjuxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 11:32:58 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14CFNFrc003904;
        Wed, 12 May 2021 15:32:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 38fxx008dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 15:32:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14CFWrRS35848478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 15:32:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC02BAE051;
        Wed, 12 May 2021 15:32:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FED0AE058;
        Wed, 12 May 2021 15:32:52 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.73.206])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 May 2021 15:32:52 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512124120.GV1002214@nvidia.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <41f48d58-687f-289c-3eb0-ef4001d16ff6@de.ibm.com>
Date:   Wed, 12 May 2021 17:32:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210512124120.GV1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2zq0uZ4ZVjT7G47tykzawZZgk9_-hYmM
X-Proofpoint-GUID: T5FtJ3Dnm-3uZuBVXE6V5LZAuF2tzKXZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_07:2021-05-12,2021-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12.05.21 14:41, Jason Gunthorpe wrote:
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
> 
> Can you please ensure this goes to a -rc branch or through Alex's
> tree?

So you want this is 5.13-rc?
I can apply this to the s390 tree if that is ok.
