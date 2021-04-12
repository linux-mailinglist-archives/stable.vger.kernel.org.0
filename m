Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E76D35BA58
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 08:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhDLGxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 02:53:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9946 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231175AbhDLGxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 02:53:17 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13C6XOkY037291;
        Mon, 12 Apr 2021 02:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=d2Mc6tbA+Dusk8jcIThE9LuWzrhnwf4JCSq+9vYv25s=;
 b=bHUXNVen6cvbCJyX8pKe+yZVmwWLV5ESShCvc1xduSWjFfcCuJ51GBcU95wi1pQ+eVe5
 Y3Fl1g14lXfgtWUAiLAzo4+kTNGHARboYITikBvXNN/JsWhBhZ6oaSAdKFtUCzgDSx1Z
 tQCnrzKD8svhSrSqeBc5WcjMfI8Kebc4PdjqNtFTYoVA+NZUZPr/+QRkM1Nq0naNC3gY
 6b8pjUQO8hlg2dXNolkI2g8Os4s4KUS1A4cP3hCE1fQQiUNIsU1NEqSOz3O5/9iAsAxH
 gyv+ytYs3d9ygVQMomv687gUVMaC9a/EtSzBsG4IKV0uVkhb7FujCS5Zc7gAMEnNDdeJ IA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37usk9evsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 02:52:53 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13C6ls5e026733;
        Mon, 12 Apr 2021 06:52:52 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 37u3n9p2ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 06:52:52 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13C6qqp329688088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 06:52:52 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A136B2068;
        Mon, 12 Apr 2021 06:52:52 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 988B1B2065;
        Mon, 12 Apr 2021 06:52:49 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.85.72.239])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Apr 2021 06:52:49 +0000 (GMT)
X-Mailer: emacs 27.2 (via feedmail 11-beta-1 I)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>, linux-nvdimm@lists.01.org,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: Re: [PATCH v3] libnvdimm/region: Update nvdimm_has_flush() to
 handle explicit 'flush' callbacks
In-Reply-To: <20210408104622.943843-1-vaibhav@linux.ibm.com>
References: <20210408104622.943843-1-vaibhav@linux.ibm.com>
Date:   Mon, 12 Apr 2021 12:22:47 +0530
Message-ID: <87blakuh8g.fsf@linux.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2oaITbKzgQ63sWWEnRNEcNVRIXCX_ZNj
X-Proofpoint-GUID: 2oaITbKzgQ63sWWEnRNEcNVRIXCX_ZNj
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_04:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120042
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> In case a platform doesn't provide explicit flush-hints but provides an
> explicit flush callback, then nvdimm_has_flush() still returns '0'
> indicating that writes do not require flushing. This happens on PPC64
> with patch at [1] applied, where 'deep_flush' of a region was denied
> even though an explicit flush function was provided.
>
> Similar problem is also seen with virtio-pmem where the 'deep_flush'
> sysfs attribute is not visible as in absence of any registered nvdimm,
> 'nd_region->ndr_mappings == 0'.
>
> Fix this by updating nvdimm_has_flush() adding a condition to
> nvdimm_has_flush() to test if a 'region->flush' callback is
> assigned. Also remove explicit test for 'nd_region->ndr_mapping' since
> regions may need 'flush' without any explicit mappings as in case of
> virtio-pmem.
>
> References:
> [1] "powerpc/papr_scm: Implement support for H_SCM_FLUSH hcall"
> https://lore.kernel.org/linux-nvdimm/161703936121.36.7260632399582101498.stgit@e1fbed493c87
>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

> Cc: <stable@vger.kernel.org>
> Fixes: c5d4355d10d4 ("libnvdimm: nd_region flush callback support")
> Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
> Changelog:
>
> v3:
> * Removed the test for ND_REGION_SYNC to handle case where a
>   synchronous region still wants to expose a deep-flush function.
>   [ Aneesh ]
> * Updated patch title and description from previous patch
>   https://lore.kernel.org/linux-nvdimm/5e64778d-bf48-9f10-7d3d-5e530e5db590@linux.ibm.com
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
> index ef23119db574..c4b17bdd527f 100644
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
> +	if (nd_region->flush)
> +		return 1;
> +
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
