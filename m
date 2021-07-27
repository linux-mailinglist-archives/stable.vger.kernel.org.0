Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3AD3D7562
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbhG0MzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 08:55:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232039AbhG0MzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 08:55:03 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RCfO9H099539;
        Tue, 27 Jul 2021 08:54:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rW1zEUuKvDuL0Ee74R7Cv0tiXi3AGSCkEJMUa6cnGaw=;
 b=I5wY3Og6UlCtTShbC40RyfI0gg2xjyMFCI6qcvq1stGYAxUOCkU3L/bH/kY1SXZfHjdt
 sOepC0QG9OJEX0IQzH/B5ALqWoobawSNV1xcV1PkJDQeZYRambUzX49qGJKXCKENV7WM
 zbdIoeJ87IYf6kT+DkbeCZfRF3opCQWe8n9ZeJ2gqkZDNUPk7u/gbIUyA8KqlGSa4A0F
 2fufPpkH5/I6GYuH4WhcDgbp7O3n/ot9lc+/6ffSHowgsTJch5fmsRJqC13r/J0tkixt
 49BasgayhL/p0cNHQwp6wx3X6wE0PUXNtCQHM8g0uYwiqQKsbYBJQnnFv4yZckQ9UuOj jA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a2j2u0unp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 08:54:24 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16RCsBCA003378;
        Tue, 27 Jul 2021 12:54:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3a235kr951-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 12:54:22 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16RCsJre26280240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 12:54:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6150F42049;
        Tue, 27 Jul 2021 12:54:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D510042042;
        Tue, 27 Jul 2021 12:54:15 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.165.137])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jul 2021 12:54:15 +0000 (GMT)
Subject: Re: [PATCH v2 1/1] s390/pv: fix the forcing of the swiotlb
To:     Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Heiko Carstens <hca@linux.ibm.com>, stable@vger.kernel.org,
        Claire Chang <tientzu@chromium.org>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Guenter Roeck <linux@roeck-us.net>
References: <20210723231746.3964989-1-pasic@linux.ibm.com>
 <YPtejB62iu+iNrM+@fedora>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <a89f1add-b0fb-1069-cb30-78864e399b19@de.ibm.com>
Date:   Tue, 27 Jul 2021 14:54:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPtejB62iu+iNrM+@fedora>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i9Zr-lv1wBkQV6w9MJeAAPuwGQc_9CBR
X-Proofpoint-ORIG-GUID: i9Zr-lv1wBkQV6w9MJeAAPuwGQc_9CBR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_07:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1011 impostorscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270073
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24.07.21 02:27, Konrad Rzeszutek Wilk wrote:
> On Sat, Jul 24, 2021 at 01:17:46AM +0200, Halil Pasic wrote:
>> Since commit 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for
>> swiotlb data bouncing") if code sets swiotlb_force it needs to do so
>> before the swiotlb is initialised. Otherwise
>> io_tlb_default_mem->force_bounce will not get set to true, and devices
>> that use (the default) swiotlb will not bounce despite switolb_force
>> having the value of SWIOTLB_FORCE.
>>
>> Let us restore swiotlb functionality for PV by fulfilling this new
>> requirement.
>>
>> This change addresses what turned out to be a fragility in
>> commit 64e1f0c531d1 ("s390/mm: force swiotlb for protected
>> virtualization"), which ain't exactly broken in its original context,
>> but could give us some more headache if people backport the broken
>> change and forget this fix.
>>
>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> Fixes: 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for swiotlb data bouncing")
>> Fixes: 64e1f0c531d1 ("s390/mm: force swiotlb for protected virtualization")
>> Cc: stable@vger.kernel.org #5.3+
>>
>> ---
> 
> Picked it up and stuck it in linux-next with the other set of patches (Will's fixes).

Can you push out to kernel.org?
  
