Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB5C37F998
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 16:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhEMOV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 10:21:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234391AbhEMOVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 10:21:08 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DE44bk019964;
        Thu, 13 May 2021 10:19:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Tpnn/rrkgwh0jH5Io3OmKyEjGAfVlXY+yiBh6ExLR9w=;
 b=jYH43MMXVw6bfx0GyEGlvowQk/ILOgTFOafPa6oVzmD2ayLAbjiKuhu/jVnT70AiuEFR
 nDkgcv35MCPANvHmoLL5AyVDNjy9xKcoXbWOTLk6ITgzOPZmAbwwk1FnXxpBP3UEl/rH
 hGHV5q0BHv5Jg1N8484hM5UZoaGUZbzRAX1QjhrHJzb5f9ZrltBj0h5CBz2CD8yLbImU
 zGaYxITNPpg+h8wmntQiQiaUIcmPL/Y2d/5eUgOE/DZLQ8439VA7j04IGSw6H6I8yJoU
 jcnwnTIYTIsN9rSctrKg+wZiTDB7kA1vzEe/rGnvkpkY3SbByxo6W3Fs/s5XYUseKFjF ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h5ef0m5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 10:19:52 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14DE43be019939;
        Thu, 13 May 2021 10:19:52 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h5ef0m4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 10:19:52 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14DEH8hl002908;
        Thu, 13 May 2021 14:19:51 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 38dj99xq5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 14:19:51 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14DEJoRl28901712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 14:19:50 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68020AC062;
        Thu, 13 May 2021 14:19:50 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD6A1AC059;
        Thu, 13 May 2021 14:19:49 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 May 2021 14:19:49 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512124120.GV1002214@nvidia.com>
 <41f48d58-687f-289c-3eb0-ef4001d16ff6@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <b7fc8184-8a51-9c7e-6ef5-aa245edb7b9d@linux.ibm.com>
Date:   Thu, 13 May 2021 10:19:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <41f48d58-687f-289c-3eb0-ef4001d16ff6@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QnPOPB-2aNsSsaZaq1MKNVV6g5M85Yzz
X-Proofpoint-ORIG-GUID: NdfL7TEdpRwUJ96w_sCDQbCowqojgzb8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_08:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130105
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/12/21 11:32 AM, Christian Borntraeger wrote:
>
>
> On 12.05.21 14:41, Jason Gunthorpe wrote:
>> On Mon, May 10, 2021 at 05:48:37PM -0400, Tony Krowiak wrote:
>>> The mdev remove callback for the vfio_ap device driver bails out with
>>> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
>>> to prevent the mdev from being removed while in use; however, 
>>> returning a
>>> non-zero rc does not prevent removal. This could result in a memory 
>>> leak
>>> of the resources allocated when the mdev was created. In addition, the
>>> KVM guest will still have access to the AP devices assigned to the mdev
>>> even though the mdev no longer exists.
>>>
>>> To prevent this scenario, cleanup will be done - including 
>>> unplugging the
>>> AP adapters, domains and control domains - regardless of whether the 
>>> mdev
>>> is in use by a KVM guest or not.
>>>
>>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open 
>>> callback")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
>>> ---
>>>   drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
>>>   1 file changed, 2 insertions(+), 11 deletions(-)
>>
>> Can you please ensure this goes to a -rc branch or through Alex's
>> tree?
>
> So you want this is 5.13-rc?
> I can apply this to the s390 tree if that is ok.

If it is in time for 5.13.-rc, then yes, go ahead and
apply it.

