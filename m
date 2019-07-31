Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4227B7B8
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 03:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfGaBo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 21:44:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725209AbfGaBo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 21:44:56 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V1fhj3138393
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 21:44:55 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u2wp3ym9h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 21:44:55 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ajd@linux.ibm.com>;
        Wed, 31 Jul 2019 02:44:53 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 31 Jul 2019 02:44:50 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6V1inxV43122688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 01:44:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD9A252054;
        Wed, 31 Jul 2019 01:44:49 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6AB3B52050;
        Wed, 31 Jul 2019 01:44:49 +0000 (GMT)
Received: from [10.61.2.125] (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 7F0F8A0224;
        Wed, 31 Jul 2019 11:44:47 +1000 (AEST)
Subject: Re: [PATCH v2] powerpc/powernv: Restrict OPAL symbol map to only be
 readable by root
From:   Andrew Donnellan <ajd@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org, Stewart Smith <stewart@linux.ibm.com>,
        Jordan Niethe <jniethe5@gmail.com>
References: <20190503075253.22798-1-ajd@linux.ibm.com>
Date:   Wed, 31 Jul 2019 11:44:47 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190503075253.22798-1-ajd@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19073101-0012-0000-0000-00000337D446
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19073101-0013-0000-0000-000021717B5B
Message-Id: <2a934abd-07c0-2741-8f2e-b9224abde005@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310015
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/5/19 5:52 pm, Andrew Donnellan wrote:
> Currently the OPAL symbol map is globally readable, which seems bad as it
> contains physical addresses.
> 
> Restrict it to root.
> 
> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Jordan Niethe <jniethe5@gmail.com>
> Cc: Stewart Smith <stewart@linux.ibm.com>
> Fixes: c8742f85125d ("powerpc/powernv: Expose OPAL firmware symbol map")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>

mpe: ping?

> 
> ---
> 
> v1->v2:
> 
> - fix tabs vs spaces (Greg)
> ---
>   arch/powerpc/platforms/powernv/opal.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
> index 2b0eca104f86..0582a02623d0 100644
> --- a/arch/powerpc/platforms/powernv/opal.c
> +++ b/arch/powerpc/platforms/powernv/opal.c
> @@ -681,7 +681,10 @@ static ssize_t symbol_map_read(struct file *fp, struct kobject *kobj,
>   				       bin_attr->size);
>   }
>   
> -static BIN_ATTR_RO(symbol_map, 0);
> +static struct bin_attribute symbol_map_attr = {
> +	.attr = {.name = "symbol_map", .mode = 0400},
> +	.read = symbol_map_read
> +};
>   
>   static void opal_export_symmap(void)
>   {
> @@ -698,10 +701,10 @@ static void opal_export_symmap(void)
>   		return;
>   
>   	/* Setup attributes */
> -	bin_attr_symbol_map.private = __va(be64_to_cpu(syms[0]));
> -	bin_attr_symbol_map.size = be64_to_cpu(syms[1]);
> +	symbol_map_attr.private = __va(be64_to_cpu(syms[0]));
> +	symbol_map_attr.size = be64_to_cpu(syms[1]);
>   
> -	rc = sysfs_create_bin_file(opal_kobj, &bin_attr_symbol_map);
> +	rc = sysfs_create_bin_file(opal_kobj, &symbol_map_attr);
>   	if (rc)
>   		pr_warn("Error %d creating OPAL symbols file\n", rc);
>   }
> 

-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited

