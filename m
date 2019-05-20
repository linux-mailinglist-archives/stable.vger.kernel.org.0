Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5FD242A2
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 23:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfETVTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 17:19:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726833AbfETVTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 17:19:24 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4KL1wPA115227
        for <stable@vger.kernel.org>; Mon, 20 May 2019 17:19:23 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sm1ken8xq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 20 May 2019 17:19:22 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 20 May 2019 22:19:20 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 May 2019 22:19:16 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4KLJF2158130518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 21:19:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E4E6AE051;
        Mon, 20 May 2019 21:19:15 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44269AE045;
        Mon, 20 May 2019 21:19:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.109])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 May 2019 21:19:14 +0000 (GMT)
Subject: Re: [PATCH 1/4] evm: check hash algorithm passed to init_desc()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Mon, 20 May 2019 17:19:03 -0400
In-Reply-To: <20190516161257.6640-1-roberto.sassu@huawei.com>
References: <20190516161257.6640-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052021-0028-0000-0000-0000036FBB40
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052021-0029-0000-0000-0000242F6259
Message-Id: <1558387143.4039.74.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-20_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905200132
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-05-16 at 18:12 +0200, Roberto Sassu wrote:
> This patch prevents memory access beyond the evm_tfm array by checking the
> validity of the index (hash algorithm) passed to init_desc(). The hash
> algorithm can be arbitrarily set if the security.ima xattr type is not
> EVM_XATTR_HMAC.
> 
> Fixes: 5feeb61183dde ("evm: Allow non-SHA1 digital signatures")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Cc: stable@vger.kernel.org

Thanks!

> ---
>  security/integrity/evm/evm_crypto.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
> index e11564eb645b..82a38e801ee4 100644
> --- a/security/integrity/evm/evm_crypto.c
> +++ b/security/integrity/evm/evm_crypto.c
> @@ -89,6 +89,9 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
>  		tfm = &hmac_tfm;
>  		algo = evm_hmac;
>  	} else {
> +		if (hash_algo >= HASH_ALGO__LAST)
> +			return ERR_PTR(-EINVAL);
> +
>  		tfm = &evm_tfm[hash_algo];
>  		algo = hash_algo_name[hash_algo];
>  	}

