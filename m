Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2617D151D41
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 16:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBDP3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 10:29:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727319AbgBDP3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 10:29:30 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 014FP22G008385;
        Tue, 4 Feb 2020 10:29:19 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xxn922qba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Feb 2020 10:29:19 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 014FR05b017172;
        Tue, 4 Feb 2020 15:29:18 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 2xw0y6abnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Feb 2020 15:29:18 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 014FTHuE36045218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Feb 2020 15:29:17 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C09446E052;
        Tue,  4 Feb 2020 15:29:17 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E35F86E04C;
        Tue,  4 Feb 2020 15:29:15 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.85.122.237])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  4 Feb 2020 15:29:15 +0000 (GMT)
X-Mailer: emacs 27.0.60 (via feedmail 11-beta-1 I)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] libnvdimm/of_pmem: Fix leaking bus_desc.provider_name
 in some paths
In-Reply-To: <20200123031847.149325-1-vaibhav@linux.ibm.com>
References: <20200123031847.149325-1-vaibhav@linux.ibm.com>
Date:   Tue, 04 Feb 2020 20:59:13 +0530
Message-ID: <87k152fk1i.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-04_05:2020-02-04,2020-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=2
 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002040106
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> String 'bus_desc.provider_name' allocated inside
> of_pmem_region_probe() will leak in case call to nvdimm_bus_register()
> fails or when of_pmem_region_remove() is called.
>
> This minor patch ensures that 'bus_desc.provider_name' is freed in
> error path for of_pmem_region_probe() as well as in
> of_pmem_region_remove().
>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

> Cc: stable@vger.kernel.org
> Fixes:49bddc73d15c2("libnvdimm/of_pmem: Provide a unique name for bus provider")
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>  drivers/nvdimm/of_pmem.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> index 8224d1431ea9..9cb76f9837ad 100644
> --- a/drivers/nvdimm/of_pmem.c
> +++ b/drivers/nvdimm/of_pmem.c
> @@ -36,6 +36,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
>  
>  	priv->bus = bus = nvdimm_bus_register(&pdev->dev, &priv->bus_desc);
>  	if (!bus) {
> +		kfree(priv->bus_desc.provider_name);
>  		kfree(priv);
>  		return -ENODEV;
>  	}
> @@ -81,6 +82,7 @@ static int of_pmem_region_remove(struct platform_device *pdev)
>  	struct of_pmem_private *priv = platform_get_drvdata(pdev);
>  
>  	nvdimm_bus_unregister(priv->bus);
> +	kfree(priv->bus_desc.provider_name);
>  	kfree(priv);
>  
>  	return 0;
> -- 
> 2.24.1
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
