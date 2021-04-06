Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C43354C28
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 07:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhDFFNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 01:13:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41886 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbhDFFNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 01:13:22 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136553AL029296;
        Tue, 6 Apr 2021 01:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=s82s0+sXgTlqUeexhZf9DrTLQmM2Ml3zVC2Ke7u8xEs=;
 b=pKAn0lTEBcnoTlHqe4rjYJGnAxc3UWFWZ/+n7hRrPQ8slr1SG9AlXgFhT44Hm9yB4B9e
 rZ1ulHmNJo1awVbXbjEHI/RUVWALFOJExzytQnr8EI6yqS0qlGsTtqvzi4wnnaQ3tH0O
 MbukwMnl6acvaf6bnJqzfP8uKlg8u9gutpixNuS+/2ZRxoSZSdqde58hh6vGMuRxgeRC
 Gv6rQIIieVS/J1ciPdcwlHdctMH+7WYbg6SyxaDu+k4ks0ZptF7hngXr/kut98fNkNm1
 y7oR3ArrYx7En8EPy2kwM5F2eX3qVGSnRAqOwzT3tXT7q0fRFdJECsprDQfrsf5HLVPc lA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5kxf6gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 01:13:07 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1365C42D013376;
        Tue, 6 Apr 2021 05:13:07 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 37q2q8wh19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 05:13:07 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1365D5Gg25559534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 05:13:05 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AE00C6055;
        Tue,  6 Apr 2021 05:13:05 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6511CC6057;
        Tue,  6 Apr 2021 05:13:03 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.102.1.249])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 05:13:02 +0000 (GMT)
X-Mailer: emacs 28.0.50 (via feedmail 11-beta-1 I)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>, linux-nvdimm@lists.01.org
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] libnvdimm/region: Update nvdimm_has_flush() to
 handle ND_REGION_ASYNC
In-Reply-To: <20210406032233.490596-1-vaibhav@linux.ibm.com>
References: <20210406032233.490596-1-vaibhav@linux.ibm.com>
Date:   Tue, 06 Apr 2021 10:43:00 +0530
Message-ID: <874kgk6lnn.fsf@linux.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q-omDbo3gGYKDEqzDlH-irVBIPiADIsr
X-Proofpoint-GUID: Q-omDbo3gGYKDEqzDlH-irVBIPiADIsr
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1011
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060033
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> In case a platform doesn't provide explicit flush-hints but provides an
> explicit flush callback via ND_REGION_ASYNC region flag, then
> nvdimm_has_flush() still returns '0' indicating that writes do not
> require flushing. This happens on PPC64 with patch at [1] applied,
> where 'deep_flush' of a region was denied even though an explicit
> flush function was provided.
>
> Similar problem is also seen with virtio-pmem where the 'deep_flush'
> sysfs attribute is not visible as in absence of any registered nvdimm,
> 'nd_region->ndr_mappings == 0'.
>
> Fix this by updating nvdimm_has_flush() adding a condition to
> nvdimm_has_flush() testing for ND_REGION_ASYNC flag on the region
> and see if a 'region->flush' callback is assigned. Also remove
> explicit test for 'nd_region->ndr_mapping' since regions can be marked
> 'ND_REGION_SYNC' without any explicit mappings as in case of
> virtio-pmem.

Do we need to check for ND_REGION_ASYNC? What if the backend wants to
provide a synchronous dax region but with different deep flush semantic
than writing to wpq flush address? 
ie,

>
> References:
> [1] "powerpc/papr_scm: Implement support for H_SCM_FLUSH hcall"
> https://lore.kernel.org/linux-nvdimm/161703936121.36.7260632399	582101498.stgit@e1fbed493c87
>
> Cc: <stable@vger.kernel.org>
> Fixes: c5d4355d10d4 ("libnvdimm: nd_region flush callback support")
> Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
> Changelog:
>
> v2:
> * Added the fixes tag and addressed the patch to stable tree [ Aneesh ]
> * Updated patch description to address the virtio-pmem case.
> * Removed test for 'nd_region->ndr_mappings' from beginning of
>   nvdimm_has_flush() to handle the virtio-pmem case.
> ---
>  drivers/nvdimm/region_devs.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index ef23119db574..cdf5eb6fa425 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -1234,11 +1234,15 @@ int nvdimm_has_flush(struct nd_region *nd_region)
>  {
>  	int i;
>  
> -	/* no nvdimm or pmem api == flushing capability unknown */
> -	if (nd_region->ndr_mappings == 0
> -			|| !IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
> +	/* no pmem api == flushing capability unknown */
> +	if (!IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
>  		return -ENXIO;
>  
> +	/* Test if an explicit flush function is defined */
> +	if (test_bit(ND_REGION_ASYNC, &nd_region->flags) && nd_region->flush)
> +		return 1;
> +


        if (nd_region->flush)
                return 1


> +	/* Test if any flush hints for the region are available */
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>  		struct nvdimm *nvdimm = nd_mapping->nvdimm;
> @@ -1249,8 +1253,8 @@ int nvdimm_has_flush(struct nd_region *nd_region)
>  	}
>  
>  	/*
> -	 * The platform defines dimm devices without hints, assume
> -	 * platform persistence mechanism like ADR
> +	 * The platform defines dimm devices without hints nor explicit flush,
> +	 * assume platform persistence mechanism like ADR
>  	 */
>  	return 0;
>  }
> -- 
> 2.30.2
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
