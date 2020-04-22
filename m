Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11151B4EA4
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgDVU4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:56:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726183AbgDVU4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 16:56:37 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MKVmT9147217
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 16:56:36 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmvjhyn3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 16:56:36 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 22 Apr 2020 21:56:28 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 21:56:24 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03MKtL5c52822330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 20:55:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21CEEA405F;
        Wed, 22 Apr 2020 20:56:29 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 336BFA4054;
        Wed, 22 Apr 2020 20:56:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.162.195])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 20:56:28 +0000 (GMT)
Subject: Re: [PATCH 3/5] ima: Fix ima digest hash table key calculation
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, krzysztof.struczynski@huawei.com,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org
Date:   Wed, 22 Apr 2020 16:56:27 -0400
In-Reply-To: <20200325161116.7082-3-roberto.sassu@huawei.com>
References: <20200325161116.7082-1-roberto.sassu@huawei.com>
         <20200325161116.7082-3-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042220-0028-0000-0000-000003FD2B3B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042220-0029-0000-0000-000024C2F3C3
Message-Id: <1587588987.5165.20.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_06:2020-04-22,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220152
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto, Krsysztof,

On Wed, 2020-03-25 at 17:11 +0100, Roberto Sassu wrote:
> From: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
> 
> Function hash_long() accepts unsigned long, while currently only one byte
> is passed from ima_hash_key(), which calculates a key for ima_htable. Use
> more bytes to avoid frequent collisions.
> 
> Length of the buffer is not explicitly passed as a function parameter,
> because this function expects a digest whose length is greater than the
> size of unsigned long.

Somehow I missed the original report of this problem https://lore.kern
el.org/patchwork/patch/674684/.  This patch is definitely better, but
how many unique keys are actually being used?  Is it anywhere near
IMA_MEASURE_HTABLE_SIZE(512)?

Do we need a new securityfs entry to display the number used?

Mimi

> 
> Cc: stable@vger.kernel.org
> Fixes: 3323eec921ef ("integrity: IMA as an integrity service provider")
> Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
> ---
>  security/integrity/ima/ima.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 64317d95363e..cf0022c2bc14 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -177,7 +177,7 @@ extern struct ima_h_table ima_htable;
>  
>  static inline unsigned long ima_hash_key(u8 *digest)
>  {
> -	return hash_long(*digest, IMA_HASH_BITS);
> +	return hash_long(*((unsigned long *)digest), IMA_HASH_BITS);
>  }
>  
>  #define __ima_hooks(hook)		\

