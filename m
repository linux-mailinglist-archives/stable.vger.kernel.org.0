Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727CF2FB33
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 13:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfE3Lx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 07:53:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727020AbfE3Lx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 07:53:57 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4UBq1uQ059616
        for <stable@vger.kernel.org>; Thu, 30 May 2019 07:53:55 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2stdknugae-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 30 May 2019 07:53:55 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 30 May 2019 12:53:53 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 May 2019 12:53:50 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4UBrnTI44499030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 11:53:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B872A405F;
        Thu, 30 May 2019 11:53:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B2E8A4055;
        Thu, 30 May 2019 11:53:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.109])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 May 2019 11:53:47 +0000 (GMT)
Subject: Re: [PATCH v2 1/3] evm: check hash algorithm passed to init_desc()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Thu, 30 May 2019 07:53:37 -0400
In-Reply-To: <20190529133035.28724-2-roberto.sassu@huawei.com>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
         <20190529133035.28724-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19053011-0012-0000-0000-00000320F03F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19053011-0013-0000-0000-00002159BF13
Message-Id: <1559217217.4008.3.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-30_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905300090
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-05-29 at 15:30 +0200, Roberto Sassu wrote:
> This patch prevents memory access beyond the evm_tfm array by checking the
> validity of the index (hash algorithm) passed to init_desc(). The hash
> algorithm can be arbitrarily set if the security.ima xattr type is not
> EVM_XATTR_HMAC.
> 
> Fixes: 5feeb61183dde ("evm: Allow non-SHA1 digital signatures")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Cc: stable@vger.kernel.org

Thanks, queued.

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

