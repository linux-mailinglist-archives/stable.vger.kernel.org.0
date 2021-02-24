Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC64C324796
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 00:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhBXXpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 18:45:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232929AbhBXXpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 18:45:23 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11ONWlNE120212;
        Wed, 24 Feb 2021 18:44:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NN4jfYvyRSWFGnlFke7guafjERw9ajAyWEwiI3jDW1s=;
 b=HQz+1ZhpSFnjVOC+ZN2OCaQJOuJYJhtjI3XiWSfzrB8O5DEfifgsE7g77UTpEYZXz5ZZ
 zCXtqJmZybFsXFum6N/yvGoHX97DvDm8kZ6HquaxtRkqFhU1fjOxzE3DRnXkvpKJTpre
 MTaN8vlNi1+Veha0zcnW+LIORRnXU3pC4O7exC9qf8ffWvi2PE4TSKCGfHR9QS6LQUNr
 2RQhp478Zxr5qD8E7YC01QqO1YfvBWdWu8Z0FyyRXwjNwbSwuvSFYr5uul+z4JvmahOc
 wH2dNtYFuYpN37NnnaZVxrOti78uZBmaO073UWkuuXrHdlZ3xp7r4rxJ8LMq3EH1/2nt +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36wwv9vsqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 18:44:42 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11ONZ8KG130317;
        Wed, 24 Feb 2021 18:44:42 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36wwv9vsqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 18:44:42 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11ONg9gA012741;
        Wed, 24 Feb 2021 23:44:41 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 36tt29tftc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 23:44:41 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11ONieLl38207838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 23:44:40 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81E92112063;
        Wed, 24 Feb 2021 23:44:40 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3714112062;
        Wed, 24 Feb 2021 23:44:39 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.150.254])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 24 Feb 2021 23:44:39 +0000 (GMT)
Subject: Re: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20210216011547.22277-1-akrowiak@linux.ibm.com>
 <20210216011547.22277-2-akrowiak@linux.ibm.com>
 <20210223104805.6a8d1872.pasic@linux.ibm.com>
 <e07d6f8e-f29e-7c4e-4226-5a5c072e7ae6@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <358b4b68-1bfb-4a5c-960d-d442271c5852@linux.ibm.com>
Date:   Wed, 24 Feb 2021 18:44:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e07d6f8e-f29e-7c4e-4226-5a5c072e7ae6@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-24_13:2021-02-24,2021-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240184
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/24/21 11:10 AM, Christian Borntraeger wrote:
>
> On 23.02.21 10:48, Halil Pasic wrote:
>> On Mon, 15 Feb 2021 20:15:47 -0500
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>> This patch fixes a circular locking dependency in the CI introduced by
>>> commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
>>> pointer invalidated"). The lockdep only occurs when starting a Secure
>>> Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
>>> SE guests; however, in order to avoid CI errors, this fix is being
>>> provided.
>>>
>>> The circular lockdep was introduced when the masks in the guest's APCB
>>> were taken under the matrix_dev->lock. While the lock is definitely
>>> needed to protect the setting/unsetting of the KVM pointer, it is not
>>> necessarily critical for setting the masks, so this will not be done under
>>> protection of the matrix_dev->lock.
>>
>>
>> With the one little thing I commented on below addressed:
>> Acked-by: Halil Pasic <pasic@linux.ibm.com>
> Tony, can you comment on Halils comment or send a v3 right away?

I was locked out of email due to expiration of my w3 password.
I am working on the response now.


