Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F5F355272
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 13:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbhDFLiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 07:38:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237938AbhDFLiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 07:38:11 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136BXqiV094482;
        Tue, 6 Apr 2021 07:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=6FhOHENgjSCBnpnNXq4GLsOGvoRCKRNUEsPyd9gy5A0=;
 b=VTcT6kPQr0crLQo1T6q7SxJLVYJ6DMJRvwfOP1Jt1GckVn8mN2NXNQlZ1Jo+zymDEJon
 JImpZoL37hv1oZRwIZS2qwu6Oqc1HgjRDMhRfr4CVsH70UkHozSHeZR+A+C2aQm/GcB2
 chSh8YxYjX9FxOOIo558fav+CO9kxt4Axsa4VUWQbWz0adUPJNqS6isjoS2m4UZDOH3R
 mDf1q0M3zdEwfylOLuZC7EmXM2t6xpZH8V/WaeMuVTJwrTOUUBFmYTiqKSnlvbvcctIQ
 2R+rP+31wdlFnV+4MD3QTstQB4K0PzIEKCSuMWXqW4KtvLZVLx4T9lmFYjDWtbU6PswT Yw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5byxxy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:38:00 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 136BWtx4020239;
        Tue, 6 Apr 2021 11:37:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 37q2n2t3x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:37:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 136BbYMi24248716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 11:37:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64D39A4055;
        Tue,  6 Apr 2021 11:37:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CEE4A4051;
        Tue,  6 Apr 2021 11:37:53 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.74.34])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  6 Apr 2021 11:37:53 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 06 Apr 2021 17:07:52 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        linux-nvdimm@lists.01.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] libnvdimm/region: Update nvdimm_has_flush() to
 handle ND_REGION_ASYNC
In-Reply-To: <874kgk6lnn.fsf@linux.ibm.com>
References: <20210406032233.490596-1-vaibhav@linux.ibm.com>
 <874kgk6lnn.fsf@linux.ibm.com>
Date:   Tue, 06 Apr 2021 17:07:52 +0530
Message-ID: <87wntfhcdr.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ylw8S7OQS24Fs7iUj2QlgXaFMv5PHTGh
X-Proofpoint-ORIG-GUID: Ylw8S7OQS24Fs7iUj2QlgXaFMv5PHTGh
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_02:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060080
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Aneesh,
Thanks for looking into this patch.

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> Vaibhav Jain <vaibhav@linux.ibm.com> writes:
>
>> In case a platform doesn't provide explicit flush-hints but provides an
>> explicit flush callback via ND_REGION_ASYNC region flag, then
>> nvdimm_has_flush() still returns '0' indicating that writes do not
>> require flushing. This happens on PPC64 with patch at [1] applied,
>> where 'deep_flush' of a region was denied even though an explicit
>> flush function was provided.
>>
>> Similar problem is also seen with virtio-pmem where the 'deep_flush'
>> sysfs attribute is not visible as in absence of any registered nvdimm,
>> 'nd_region->ndr_mappings == 0'.
>>
>> Fix this by updating nvdimm_has_flush() adding a condition to
>> nvdimm_has_flush() testing for ND_REGION_ASYNC flag on the region
>> and see if a 'region->flush' callback is assigned. Also remove
>> explicit test for 'nd_region->ndr_mapping' since regions can be marked
>> 'ND_REGION_SYNC' without any explicit mappings as in case of
>> virtio-pmem.
>
> Do we need to check for ND_REGION_ASYNC? What if the backend wants to
> provide a synchronous dax region but with different deep flush semantic
> than writing to wpq flush address? 
> ie,

For a synchronous dax region, writes arent expected to require any
flushing (or deep-flush) so this function should ideally return '0' in
such a case. Hence I had added the test for ND_REGION_ASYNC region flag.

>
>>
>> References:
>> [1] "powerpc/papr_scm: Implement support for H_SCM_FLUSH hcall"
>> https://lore.kernel.org/linux-nvdimm/161703936121.36.7260632399	582101498.stgit@e1fbed493c87
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: c5d4355d10d4 ("libnvdimm: nd_region flush callback support")
>> Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> ---
>> Changelog:
>>
>> v2:
>> * Added the fixes tag and addressed the patch to stable tree [ Aneesh ]
>> * Updated patch description to address the virtio-pmem case.
>> * Removed test for 'nd_region->ndr_mappings' from beginning of
>>   nvdimm_has_flush() to handle the virtio-pmem case.
>> ---
>>  drivers/nvdimm/region_devs.c | 14 +++++++++-----
>>  1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
>> index ef23119db574..cdf5eb6fa425 100644
>> --- a/drivers/nvdimm/region_devs.c
>> +++ b/drivers/nvdimm/region_devs.c
>> @@ -1234,11 +1234,15 @@ int nvdimm_has_flush(struct nd_region *nd_region)
>>  {
>>  	int i;
>>  
>> -	/* no nvdimm or pmem api == flushing capability unknown */
>> -	if (nd_region->ndr_mappings == 0
>> -			|| !IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
>> +	/* no pmem api == flushing capability unknown */
>> +	if (!IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
>>  		return -ENXIO;
>>  
>> +	/* Test if an explicit flush function is defined */
>> +	if (test_bit(ND_REGION_ASYNC, &nd_region->flags) && nd_region->flush)
>> +		return 1;
>> +
>
>
>         if (nd_region->flush)
>                 return 1
>
>
>> +	/* Test if any flush hints for the region are available */
>>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>>  		struct nvdimm *nvdimm = nd_mapping->nvdimm;
>> @@ -1249,8 +1253,8 @@ int nvdimm_has_flush(struct nd_region *nd_region)
>>  	}
>>  
>>  	/*
>> -	 * The platform defines dimm devices without hints, assume
>> -	 * platform persistence mechanism like ADR
>> +	 * The platform defines dimm devices without hints nor explicit flush,
>> +	 * assume platform persistence mechanism like ADR
>>  	 */
>>  	return 0;
>>  }
>> -- 
>> 2.30.2
>> _______________________________________________
>> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
>> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

-- 
Cheers
~ Vaibhav
