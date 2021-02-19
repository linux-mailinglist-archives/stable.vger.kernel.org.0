Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420E3320001
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 21:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBSUun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 15:50:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60656 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229620AbhBSUum (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 15:50:42 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11JKW7XO097860;
        Fri, 19 Feb 2021 15:50:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IADvMw5EkLNvVCZI6eQLEJk0jPkK8tm9MArQxptSjos=;
 b=ZklpezGsdKtJHtIZrmdSk57DzVWWhmXKKWdq+BbUB8W1/eS/Nzc7QwIKFMrzzrsEZXiq
 uB4V2Yu0JQYbrTLpSebv271mytM8LuH+n8Kw3MF9vPaiAmgagyQNe1IFc/Hn18A6Qf+F
 1uuQZxbCeBtF1bDTrowjZR0HW7YgJy4I5v82+AnudjFg3TisqjZ41/GnZQstYbZCmHoT
 GTm/bXt9o1ujm/PEerYehpZSDl9ySODorA/aWDLzyK0dLhHxlDjkcrgQoS2dtXy06Kgk
 tc8i14+GTmCzK6Jnb3veTmXl6I65OGPQz1KhsG3JJzT5iFP73GJnDp9YTPuCRR/Nnrnh Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36tm9jgw1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 15:50:01 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11JKfVfv137795;
        Fri, 19 Feb 2021 15:50:01 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36tm9jgw13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 15:50:00 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11JKnKPY010073;
        Fri, 19 Feb 2021 20:49:59 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 36p6d9g41c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 20:49:59 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11JKnwaI28705188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 20:49:58 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C829BC6055;
        Fri, 19 Feb 2021 20:49:58 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5D34C6057;
        Fri, 19 Feb 2021 20:49:57 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.198.77])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 19 Feb 2021 20:49:57 +0000 (GMT)
Subject: Re: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20210216011547.22277-1-akrowiak@linux.ibm.com>
 <20210216011547.22277-2-akrowiak@linux.ibm.com>
 <20210219144554.3857a034.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <567bb57c-1b3d-721e-b622-4026a8df2d31@linux.ibm.com>
Date:   Fri, 19 Feb 2021 15:49:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210219144554.3857a034.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-19_08:2021-02-18,2021-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102190160
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/19/21 8:45 AM, Cornelia Huck wrote:
> On Mon, 15 Feb 2021 20:15:47 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> This patch fixes a circular locking dependency in the CI introduced by
>> commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
>> pointer invalidated"). The lockdep only occurs when starting a Secure
>> Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
>> SE guests; however, in order to avoid CI errors, this fix is being
>> provided.
>>
>> The circular lockdep was introduced when the masks in the guest's APCB
>> were taken under the matrix_dev->lock. While the lock is definitely
>> needed to protect the setting/unsetting of the KVM pointer, it is not
>> necessarily critical for setting the masks, so this will not be done under
>> protection of the matrix_dev->lock.
>>
>> Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 119 +++++++++++++++++++++---------
>>   1 file changed, 84 insertions(+), 35 deletions(-)
> I've been looking at the patch for a bit now and tried to follow down
> the various paths; and while I think it's ok, I do not really have
> enough confidence about that for a R-b. But have an
>
> Acked-by: Cornelia Huck <cohuck@redhat.com>

Thanks for the review.

>

