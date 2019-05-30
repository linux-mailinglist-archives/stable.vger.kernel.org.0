Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571792FB50
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 14:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfE3MAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 08:00:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726991AbfE3MAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 08:00:43 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4UBw234003331
        for <stable@vger.kernel.org>; Thu, 30 May 2019 08:00:41 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2stcedf39c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 30 May 2019 08:00:40 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 30 May 2019 13:00:37 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 May 2019 13:00:34 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4UC0Yn961341902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 12:00:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C9EE52071;
        Thu, 30 May 2019 12:00:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.109])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E8D9952050;
        Thu, 30 May 2019 12:00:31 +0000 (GMT)
Subject: Re: [PATCH v2 2/3] ima: don't ignore INTEGRITY_UNKNOWN EVM status
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Thu, 30 May 2019 08:00:21 -0400
In-Reply-To: <20190529133035.28724-3-roberto.sassu@huawei.com>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
         <20190529133035.28724-3-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19053012-0020-0000-0000-00000341F4A4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19053012-0021-0000-0000-00002194F9B8
Message-Id: <1559217621.4008.7.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-30_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905300091
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-05-29 at 15:30 +0200, Roberto Sassu wrote:
> Currently, ima_appraise_measurement() ignores the EVM status when
> evm_verifyxattr() returns INTEGRITY_UNKNOWN. If a file has a valid
> security.ima xattr with type IMA_XATTR_DIGEST or IMA_XATTR_DIGEST_NG,
> ima_appraise_measurement() returns INTEGRITY_PASS regardless of the EVM
> status. The problem is that the EVM status is overwritten with the
> > appraisal statu

Roberto, your framing of this problem is harsh and misleading.  IMA
and EVM are intentionally independent of each other and can be
configured independently of each other.  The intersection of the two
is the call to evm_verifyxattr().  INTEGRITY_UNKNOWN is returned for a
number of reasons - when EVM is not configured, the EVM hmac key has
not yet been loaded, the protected security attribute is unknown, or
the file is not in policy.

This patch does not differentiate between any of the above cases,
requiring mutable files to always be protected by EVM, when specified
as an "ima_appraise=" option on the boot command line.

IMA could be extended to require EVM on a per IMA policy rule basis.  
Instead of framing allowing IMA file hashes without EVM as a bug that
has existed from the very beginning, now that IMA/EVM have matured and
is being used, you could frame it as extending IMA or hardening.

> 
> This patch mitigates the issue by selecting signature verification as the
> only method allowed for appraisal when EVM is not initialized. Since the
> new behavior might break user space, it must be turned on by adding the
> '-evm' suffix to the value of the ima_appraise= kernel option.
> 
> Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Cc: stable@vger.kernel.org
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 3 ++-
>  security/integrity/ima/ima_appraise.c           | 8 ++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 138f6664b2e2..d84a2e612b93 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1585,7 +1585,8 @@
>  			Set number of hash buckets for inode cache.
>  
>  	ima_appraise=	[IMA] appraise integrity measurements
> -			Format: { "off" | "enforce" | "fix" | "log" }
> +			Format: { "off" | "enforce" | "fix" | "log" |
> +				  "enforce-evm" | "log-evm" } 

Is it necessary to define both "enforce-evm" and "log-evm"?  Perhaps
defining "require-evm" is sufficient.

Mimi

>  			default: "enforce"
>  
>  	ima_appraise_tcb [IMA] Deprecated.  Use ima_policy= instead.
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 5fb7127bbe68..afef06e10fb9 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -18,6 +18,7 @@
>  
>  #include "ima.h"
>  
> +static bool ima_appraise_req_evm __ro_after_init;
>  static int __init default_appraise_setup(char *str)
>  {
>  #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
> @@ -28,6 +29,9 @@ static int __init default_appraise_setup(char *str)
>  	else if (strncmp(str, "fix", 3) == 0)
>  		ima_appraise = IMA_APPRAISE_FIX;
>  #endif
> +	if (strcmp(str, "enforce-evm") == 0 ||
> +	    strcmp(str, "log-evm") == 0)
> +		ima_appraise_req_evm = true;
>  	return 1;
>  }
>  
> @@ -245,7 +249,11 @@ int ima_appraise_measurement(enum ima_hooks func,
>  	switch (status) {
>  	case INTEGRITY_PASS:
>  	case INTEGRITY_PASS_IMMUTABLE:
> +		break;
>  	case INTEGRITY_UNKNOWN:
> +		if (ima_appraise_req_evm &&
> +		    xattr_value->type != EVM_IMA_XATTR_DIGSIG)
> +			goto out;
>  		break;
>  	case INTEGRITY_NOXATTRS:	/* No EVM protected xattrs. */
>  	case INTEGRITY_NOLABEL:		/* No security.evm xattr. */

