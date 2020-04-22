Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED0F1B467D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 15:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgDVNpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 09:45:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726802AbgDVNpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 09:45:12 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MDXDNA142174
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 09:45:11 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30gc2ybtdv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 09:45:10 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 22 Apr 2020 14:44:14 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 14:44:11 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03MDj4OJ52691146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 13:45:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11BA9AE065;
        Wed, 22 Apr 2020 13:45:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30EBFAE059;
        Wed, 22 Apr 2020 13:45:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.220.15])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 13:45:03 +0000 (GMT)
Subject: Re: [PATCH 2/5] evm: Check also if *tfm is an error pointer in
 init_desc()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, krzysztof.struczynski@huawei.com,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org
Date:   Wed, 22 Apr 2020 09:45:02 -0400
In-Reply-To: <20200325161116.7082-2-roberto.sassu@huawei.com>
References: <20200325161116.7082-1-roberto.sassu@huawei.com>
         <20200325161116.7082-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042213-0020-0000-0000-000003CC8FC6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042213-0021-0000-0000-000022258C03
Message-Id: <1587563102.5738.32.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_06:2020-04-22,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220109
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto, Krzysztof,

On Wed, 2020-03-25 at 17:11 +0100, Roberto Sassu wrote:
> The mutex in init_desc(), introduced by commit 97426f985729 ("evm: prevent
> racing during tfm allocation") prevents two tasks to concurrently set *tfm.
> However, checking if *tfm is NULL is not enough, as crypto_alloc_shash()
> can return an error pointer. The following sequence can happen:
> 
> Task A: *tfm = crypto_alloc_shash() <= error pointer
> Task B: if (*tfm == NULL) <= *tfm is not NULL, use it
> Task B: rc = crypto_shash_init(desc) <= panic
> Task A: *tfm = NULL
> 
> This patch uses the IS_ERR_OR_NULL macro to determine whether or not a new
> crypto context must be created.
> 
> Cc: stable@vger.kernel.org
> Fixes: 97426f985729 ("evm: prevent racing during tfm allocation")

Thank you.  True, this commit introduced the mutex, but the actual
problem is most likely the result of a crypto algorithm not being
configured.  Depending on the kernel and which crypto algorithms are
enabled, verifying an EVM signature might not be possible.  In the
embedded environment, where the entire filesystem is updated, there
shouldn't be any unknown EVM signature algorithms.

In case Greg or Sasha decide this patch should be backported,
including the context/motivation in the patch description (first
paragraph) would be helpful.

Mimi

> Co-developed-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
> Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/evm/evm_crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
> index 35682852ddea..77ad1e5a93e4 100644
> --- a/security/integrity/evm/evm_crypto.c
> +++ b/security/integrity/evm/evm_crypto.c
> @@ -91,7 +91,7 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
>  		algo = hash_algo_name[hash_algo];
>  	}
>  
> -	if (*tfm == NULL) {
> +	if (IS_ERR_OR_NULL(*tfm)) {
>  		mutex_lock(&mutex);
>  		if (*tfm)
>  			goto out;

