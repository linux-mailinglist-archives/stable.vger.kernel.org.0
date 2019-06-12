Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5842148
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 11:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437379AbfFLJqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 05:46:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437399AbfFLJqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 05:46:01 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5C9h0W2053425
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 05:46:00 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2v4m73yu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 05:45:59 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <aneesh.kumar@linux.ibm.com>;
        Wed, 12 Jun 2019 10:45:57 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 10:45:53 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5C9jqEP39190948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 09:45:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B78B0AE045;
        Wed, 12 Jun 2019 09:45:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40B8AAE04D;
        Wed, 12 Jun 2019 09:45:51 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.124.35.98])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 09:45:51 +0000 (GMT)
X-Mailer: emacs 26.2 (via feedmail 11-beta-1 Q)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc:     mhocko@suse.com, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org, osalvador@suse.de
Subject: Re: [PATCH v9 11/12] libnvdimm/pfn: Fix fsdax-mode namespace info-block zero-fields
In-Reply-To: <155977193862.2443951.10284714500308539570.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com> <155977193862.2443951.10284714500308539570.stgit@dwillia2-desk3.amr.corp.intel.com>
Date:   Wed, 12 Jun 2019 15:11:46 +0530
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
x-cbid: 19061209-4275-0000-0000-000003419E4E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061209-4276-0000-0000-00003851B3FC
Message-Id: <87r27zi1id.fsf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120067
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> At namespace creation time there is the potential for the "expected to
> be zero" fields of a 'pfn' info-block to be filled with indeterminate
> data. While the kernel buffer is zeroed on allocation it is immediately
> overwritten by nd_pfn_validate() filling it with the current contents of
> the on-media info-block location. For fields like, 'flags' and the
> 'padding' it potentially means that future implementations can not rely
> on those fields being zero.
>
> In preparation to stop using the 'start_pad' and 'end_trunc' fields for
> section alignment, arrange for fields that are not explicitly
> initialized to be guaranteed zero. Bump the minor version to indicate it
> is safe to assume the 'padding' and 'flags' are zero. Otherwise, this
> corruption is expected to benign since all other critical fields are
> explicitly initialized.
>
> Fixes: 32ab0a3f5170 ("libnvdimm, pmem: 'struct page' for pmem")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/dax_devs.c |    2 +-
>  drivers/nvdimm/pfn.h      |    1 +
>  drivers/nvdimm/pfn_devs.c |   18 +++++++++++++++---
>  3 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
> index 0453f49dc708..326f02ffca81 100644
> --- a/drivers/nvdimm/dax_devs.c
> +++ b/drivers/nvdimm/dax_devs.c
> @@ -126,7 +126,7 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
>  	nvdimm_bus_unlock(&ndns->dev);
>  	if (!dax_dev)
>  		return -ENOMEM;
> -	pfn_sb = devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
>  	nd_pfn->pfn_sb = pfn_sb;
>  	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
>  	dev_dbg(dev, "dax: %s\n", rc == 0 ? dev_name(dax_dev) : "<none>");
> diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
> index dde9853453d3..e901e3a3b04c 100644
> --- a/drivers/nvdimm/pfn.h
> +++ b/drivers/nvdimm/pfn.h
> @@ -36,6 +36,7 @@ struct nd_pfn_sb {
>  	__le32 end_trunc;
>  	/* minor-version-2 record the base alignment of the mapping */
>  	__le32 align;
> +	/* minor-version-3 guarantee the padding and flags are zero */
>  	u8 padding[4000];
>  	__le64 checksum;
>  };
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 01f40672507f..a2406253eb70 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -420,6 +420,15 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
>  	return 0;
>  }
>  
> +/**
> + * nd_pfn_validate - read and validate info-block
> + * @nd_pfn: fsdax namespace runtime state / properties
> + * @sig: 'devdax' or 'fsdax' signature
> + *
> + * Upon return the info-block buffer contents (->pfn_sb) are
> + * indeterminate when validation fails, and a coherent info-block
> + * otherwise.
> + */
>  int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  {
>  	u64 checksum, offset;
> @@ -565,7 +574,7 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
>  	nvdimm_bus_unlock(&ndns->dev);
>  	if (!pfn_dev)
>  		return -ENOMEM;
> -	pfn_sb = devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
>  	nd_pfn = to_nd_pfn(pfn_dev);
>  	nd_pfn->pfn_sb = pfn_sb;
>  	rc = nd_pfn_validate(nd_pfn, PFN_SIG);
> @@ -702,7 +711,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  	u64 checksum;
>  	int rc;
>  
> -	pfn_sb = devm_kzalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	pfn_sb = devm_kmalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
>  	if (!pfn_sb)
>  		return -ENOMEM;
>  
> @@ -711,11 +720,14 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  		sig = DAX_SIG;
>  	else
>  		sig = PFN_SIG;
> +
>  	rc = nd_pfn_validate(nd_pfn, sig);
>  	if (rc != -ENODEV)
>  		return rc;
>  
>  	/* no info block, do init */;
> +	memset(pfn_sb, 0, sizeof(*pfn_sb));
> +
>  	nd_region = to_nd_region(nd_pfn->dev.parent);
>  	if (nd_region->ro) {
>  		dev_info(&nd_pfn->dev,
> @@ -768,7 +780,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
>  	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
>  	pfn_sb->version_major = cpu_to_le16(1);
> -	pfn_sb->version_minor = cpu_to_le16(2);
> +	pfn_sb->version_minor = cpu_to_le16(3);
>  	pfn_sb->start_pad = cpu_to_le32(start_pad);
>  	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
>  	pfn_sb->align = cpu_to_le32(nd_pfn->align);
>

How will this minor version 3 be used? If we are not having
start_pad/end_trunc updated in pfn_sb, how will the older kernel enable these namesapces?

Do we need a patch like
https://lore.kernel.org/linux-mm/20190604091357.32213-2-aneesh.kumar@linux.ibm.com

-aneesh

