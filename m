Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2894748DF1C
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 21:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiAMUjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 15:39:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230515AbiAMUjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 15:39:44 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DJZiAx020950;
        Thu, 13 Jan 2022 20:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Z/NxvYLJ0R9maqs8jMyHv0ywql34gZYMeiU/jBwxQzA=;
 b=pGr6xSJPLLwa2GjSHQv3xmcAlyXAZep/36oi4KZFzqY6/YouLyCJRfmpBrA0Jp6tuQO4
 VqYwo3pJwruM72NTWTbunj/rPEDzeAtuZoPLoFliiP5YDB6ah8O4z3tTjTidoUeogFw0
 AnIKtH3UXimqc+lkrUpI7wjFWH2FABt1T6aD1KNawmtiqmN4CqcEACdgNJQfsa8MMBAP
 SoW72hooYyUe8M2a6myRR6oiC85QAl0a2jbzw03JeAG5En42FbQV5fbSqQCegd3s8HTk
 Q86AB472t96uiCFwsKmtGE3MYNo1hEsbuS6IvhwrNABE14/xI2qTBdHdCMUjhPBOxopg Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djt6msmpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 20:39:26 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DJaPRb024308;
        Thu, 13 Jan 2022 20:39:25 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djt6msmpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 20:39:25 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DKRsru020462;
        Thu, 13 Jan 2022 20:39:24 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3df28c2rtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 20:39:24 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DKdN3M6816544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 20:39:23 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D0182806A;
        Thu, 13 Jan 2022 20:39:23 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7692628064;
        Thu, 13 Jan 2022 20:39:23 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 20:39:23 +0000 (GMT)
Message-ID: <ef9da2e6-908b-a35f-7873-05cbd353be62@linux.ibm.com>
Date:   Thu, 13 Jan 2022 15:39:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] ima: fix reference leak in asymmetric_verify()
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
References: <20220113194438.69202-1-ebiggers@kernel.org>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220113194438.69202-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -iUbV7gQaLjWev4FHICoPUvb2mgjwei4
X-Proofpoint-GUID: UGv0B54m_1zwgVOain2YbwuYw9gWLb7S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_09,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 lowpriorityscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130127
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1/13/22 14:44, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Don't leak a reference to the key if its algorithm is unknown.
>
> Fixes: 947d70597236 ("ima: Support EC keys for signature verification")
> Cc: <stable@vger.kernel.org> # v5.13+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   security/integrity/digsig_asymmetric.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
> index 23240d793b07..895f4b9ce8c6 100644
> --- a/security/integrity/digsig_asymmetric.c
> +++ b/security/integrity/digsig_asymmetric.c
> @@ -109,22 +109,25 @@ int asymmetric_verify(struct key *keyring, const char *sig,
>   
>   	pk = asymmetric_key_public_key(key);
>   	pks.pkey_algo = pk->pkey_algo;
> -	if (!strcmp(pk->pkey_algo, "rsa"))
> +	if (!strcmp(pk->pkey_algo, "rsa")) {
>   		pks.encoding = "pkcs1";
> -	else if (!strncmp(pk->pkey_algo, "ecdsa-", 6))
> +	} else if (!strncmp(pk->pkey_algo, "ecdsa-", 6)) {
>   		/* edcsa-nist-p192 etc. */
>   		pks.encoding = "x962";
> -	else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
> -		   !strcmp(pk->pkey_algo, "sm2"))
> +	} else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
> +		   !strcmp(pk->pkey_algo, "sm2")) {
>   		pks.encoding = "raw";
> -	else
> -		return -ENOPKG;
> +	} else {
> +		ret = -ENOPKG;
> +		goto out;
> +	}
>   
>   	pks.digest = (u8 *)data;
>   	pks.digest_size = datalen;
>   	pks.s = hdr->sig;
>   	pks.s_size = siglen;
>   	ret = verify_signature(key, &pks);
> +out:
>   	key_put(key);
>   	pr_debug("%s() = %d\n", __func__, ret);
>   	return ret;
>
> base-commit: feb7a43de5ef625ad74097d8fd3481d5dbc06a59


Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

