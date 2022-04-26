Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2662F5105F7
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 19:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344515AbiDZR4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 13:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244145AbiDZR4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 13:56:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9811E3E9;
        Tue, 26 Apr 2022 10:53:23 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGwKW7003829;
        Tue, 26 Apr 2022 17:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=juCtkSXEZw5LHfimJHenTdoo3thJ7Vmt5MpxR+KgBH4=;
 b=dYwHVvWqFdFbUz4jyXAMcRj5iHOmYQLecwG5cDDEoCDrlezAN60xCsFWwZ1erdQVbrx5
 nmPLwcaJqZuYlI5eKdr6PfjygKapkDk5ExjLvRiLZCRJv1Y7y2ZMfCXBTq35y7x57hSZ
 pD41sFyhU7SrmDVSDcvUts7KwySwbFCyrHznEPM5ZacYBJeaa57Sb7qyjlfBrKMHtRV/
 KfMU/CWlYZjX0M+miDr19l3ir8iykivYwEsnjlBLCsqJP2ZqLkJaFKd8R1N0HF9CapeV
 U5Ib70ctNpdQXMEeMXluNHdzqml2VWBGxM2xT8cMTTo4yNavc/8jnJTW9K3u6yKMNc42 Cw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpmqqh1v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 17:53:18 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QHmLfF010162;
        Tue, 26 Apr 2022 17:53:18 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3fm93a4c61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 17:53:18 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QHrH5m13631800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 17:53:17 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60A91B2066;
        Tue, 26 Apr 2022 17:53:17 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31823B2065;
        Tue, 26 Apr 2022 17:53:17 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 17:53:17 +0000 (GMT)
Message-ID: <a22345e8-92a5-687e-4940-ac7b9dcc7c2f@linux.ibm.com>
Date:   Tue, 26 Apr 2022 13:53:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] ecdsa: Fix incorrect usage of vli_cmp
Content-Language: en-US
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220421185740.799271-1-stefanb@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220421185740.799271-1-stefanb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: usan4VokGuCJejTsu4ey3K-uVBkqhiaN
X-Proofpoint-ORIG-GUID: usan4VokGuCJejTsu4ey3K-uVBkqhiaN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260111
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/21/22 14:57, Stefan Berger wrote:
> Fix incorrect usage of vli_cmp when calculating the value of res.x. For
> signature verification to succeed, res.x must be the same as the r
> component of the signature which is in the range of [1..n-1] with 'n'
> being the order of the curve. Therefore, when res.x equals n calculate
> res.x = res.x - n as well. Signature verification could have previously
> unnecessarily failed in extremely rare cases.

Actually, I am withdrawing this patch. Before this patch res.x could 
equal 'n' and then wouldn't match r due to the range of r being 
[1..n-1]. Now if res.x equals 'n' then res.x - n will be 0 and again 
will not match 'r' due to the range of r being [1..n-1]. So it makes no 
difference whether vli_cmp() == 1 or vli_cmp() >= 1 and the concern 
above about rare cases not verifying the signature is wrong.

    Stefan

> 
> Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
> ---
>   crypto/ecdsa.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
> index b3a8a6b572ba..674ab9275366 100644
> --- a/crypto/ecdsa.c
> +++ b/crypto/ecdsa.c
> @@ -120,8 +120,8 @@ static int _ecdsa_verify(struct ecc_ctx *ctx, const u64 *hash, const u64 *r, con
>   	/* res = u1*G + u2 * pub_key */
>   	ecc_point_mult_shamir(&res, u1, &curve->g, u2, &ctx->pub_key, curve);
>   
> -	/* res.x = res.x mod n (if res.x > order) */
> -	if (unlikely(vli_cmp(res.x, curve->n, ndigits) == 1))
> +	/* res.x = res.x mod n (if res.x >= order) */
> +	if (unlikely(vli_cmp(res.x, curve->n, ndigits) >= 0))
>   		/* faster alternative for NIST p384, p256 & p192 */
>   		vli_sub(res.x, res.x, curve->n, ndigits);
>   
