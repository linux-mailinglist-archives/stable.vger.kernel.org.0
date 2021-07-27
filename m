Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4013D757B
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhG0NAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:00:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232039AbhG0NAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 09:00:51 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RCfR5q099613;
        Tue, 27 Jul 2021 09:00:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cYDcRUM0j49OK05u3K73lNmH4W1h16Q4y2YGusMlONY=;
 b=gtkUjUjXpERWtWpFKAXlFyoooYvlRElADEs3AkrMkz9ZD6W1NsCoU7GR2yTy5kQBND+h
 algrvCqIJvzYe246NcXONwRgUEZehhv0c9zPqCpqB7XuJXwaovDEGfea1inn8JfoU/V6
 S/muNmqf3GfdpXdJl3oGECtBH5Vavodf9P5+6r2EkppoRhjpqNSHN+sARoI+GOJBzWhL
 J3H6QhbV5iBOafjwpxaHQdQDCicvfJgv0jkcPuzIxF2xIA/7YzATBsXLtFM60/I1RLxH
 8ddnKJ95d+un32zLDCQSSGZEjFz6Jzhma+Y+6ARdLUhLzRecV0N2SUpS/RvgbfIn8LR5 Dg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a2j2u138h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 09:00:12 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16RCuY6N004708;
        Tue, 27 Jul 2021 13:00:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3a235kr976-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 13:00:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16RD06c027918742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 13:00:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B333542041;
        Tue, 27 Jul 2021 13:00:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D59E24203F;
        Tue, 27 Jul 2021 13:00:05 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.165.137])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jul 2021 13:00:05 +0000 (GMT)
Subject: Re: [PATCH v2 1/1] s390/pv: fix the forcing of the swiotlb
To:     Will Deacon <will@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Heiko Carstens <hca@linux.ibm.com>, stable@vger.kernel.org,
        Claire Chang <tientzu@chromium.org>,
        Christoph Hellwig <hch@lst.de>,
        Guenter Roeck <linux@roeck-us.net>
References: <20210723231746.3964989-1-pasic@linux.ibm.com>
 <YPtejB62iu+iNrM+@fedora> <a89f1add-b0fb-1069-cb30-78864e399b19@de.ibm.com>
 <20210727125755.GA18586@willie-the-truck>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <827b1bd3-3245-fe0e-0066-cadf8cab432f@de.ibm.com>
Date:   Tue, 27 Jul 2021 15:00:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210727125755.GA18586@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -WU9DE8cYVVqtjJnpLTD-EVwUibAazyR
X-Proofpoint-ORIG-GUID: -WU9DE8cYVVqtjJnpLTD-EVwUibAazyR
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_07:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270073
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 27.07.21 14:57, Will Deacon wrote:
> On Tue, Jul 27, 2021 at 02:54:14PM +0200, Christian Borntraeger wrote:
>>
>> On 24.07.21 02:27, Konrad Rzeszutek Wilk wrote:
>>> On Sat, Jul 24, 2021 at 01:17:46AM +0200, Halil Pasic wrote:
>>>> Since commit 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for
>>>> swiotlb data bouncing") if code sets swiotlb_force it needs to do so
>>>> before the swiotlb is initialised. Otherwise
>>>> io_tlb_default_mem->force_bounce will not get set to true, and devices
>>>> that use (the default) swiotlb will not bounce despite switolb_force
>>>> having the value of SWIOTLB_FORCE.
>>>>
>>>> Let us restore swiotlb functionality for PV by fulfilling this new
>>>> requirement.
>>>>
>>>> This change addresses what turned out to be a fragility in
>>>> commit 64e1f0c531d1 ("s390/mm: force swiotlb for protected
>>>> virtualization"), which ain't exactly broken in its original context,
>>>> but could give us some more headache if people backport the broken
>>>> change and forget this fix.
>>>>
>>>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>>>> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> Fixes: 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for swiotlb data bouncing")
>>>> Fixes: 64e1f0c531d1 ("s390/mm: force swiotlb for protected virtualization")
>>>> Cc: stable@vger.kernel.org #5.3+
>>>>
>>>> ---
>>>
>>> Picked it up and stuck it in linux-next with the other set of patches (Will's fixes).
>>
>> Can you push out to kernel.org?
> 
> It's pushed to the swiotlb tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git/log/?h=devel/for-linus-5.15
> 
> Since none of the restricted DMA series is in mainline yet, I don't think
> it's needed anywhere else.

Ah right. It is not yet in todays next, so it might just be that yesterdays next pulled
from Konrad too early. Sorry for the noise.
