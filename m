Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4CC1A7EBF
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 15:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388041AbgDNNsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 09:48:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19640 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388105AbgDNNso (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 09:48:44 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03EDYxZl062901
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:48:43 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30cw6qjnp8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:48:42 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Tue, 14 Apr 2020 14:48:00 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 14 Apr 2020 14:47:55 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03EDmY7P37028098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 13:48:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A1BCAE051;
        Tue, 14 Apr 2020 13:48:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67B60AE04D;
        Tue, 14 Apr 2020 13:48:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.236.92])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Apr 2020 13:48:33 +0000 (GMT)
Subject: Re: [PATCH] evm: Fix possible memory leak in evm_calc_hmac_or_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Tue, 14 Apr 2020 09:48:32 -0400
In-Reply-To: <20200414080131.29411-1-roberto.sassu@huawei.com>
References: <20200414080131.29411-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20041413-0020-0000-0000-000003C7B0C1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041413-0021-0000-0000-000022208C90
Message-Id: <1586872112.7311.194.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-14_06:2020-04-14,2020-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140112
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, Roberto.

Sorry for the delays in reviewing the miscellaneous set of IMA patches
you previously posted.  They're next on my "todo" list.

Mimi

On Tue, 2020-04-14 at 10:01 +0200, Roberto Sassu wrote:
> Don't immediately return if the signature is portable and security.ima is
> not present. Just set error so that memory allocated is freed before
> returning from evm_calc_hmac_or_hash().
> 
> Cc: stable@vger.kernel.org
> Fixes: 50b977481fce9 ("EVM: Add support for portable signature format")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/evm/evm_crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
> index 35682852ddea..499ea01b2edc 100644
> --- a/security/integrity/evm/evm_crypto.c
> +++ b/security/integrity/evm/evm_crypto.c
> @@ -241,7 +241,7 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
>  
>  	/* Portable EVM signatures must include an IMA hash */
>  	if (type == EVM_XATTR_PORTABLE_DIGSIG && !ima_present)
> -		return -EPERM;
> +		error = -EPERM;
>  out:
>  	kfree(xattr_value);
>  	kfree(desc);

