Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C312037A7E8
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 15:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhEKNnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 09:43:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229921AbhEKNnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 09:43:08 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BDY0MW157156;
        Tue, 11 May 2021 09:41:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5is8Ja6YGuL4EdHfuVUjJgVeVj5+3qVvOSQni4Lopdk=;
 b=Kqwh2kT3iadK2h4K42QfvNNx00c2ke6YeBlciTnDdYnCZG+aGtH9+OYPo3GnvmPmPw/F
 Vlf0gMpnQ/X2t4fID2lZBZyeTUC3/Yc32/H80+zigCuolVaxXBu3+5jJvcQm4SzMkmll
 1JrdgfwKfyoWnW9usrYc6gxz0N8oWAJ/FOacISa66B7HcJVrFB+Ao04kvq7zvMxVru6+
 w2+L9LPaElAYQeeJevSKeM15Q2P9xlMLVuFg5ZeAcVoc2XgNHaClfCHkl/t6tpMPpA9Y
 6it3ts8yky8kpLSkh7uq9LGSnaZx6SyvNjgCmU7MPrYfgTXOm4+olM3cQ+DdIJzeuoKe zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38ft9m9n4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 09:41:57 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BDaUq0167071;
        Tue, 11 May 2021 09:41:57 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38ft9m9n32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 09:41:56 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BDcJwJ008616;
        Tue, 11 May 2021 13:41:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 38dhwh9q0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 13:41:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BDfqL936635118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 13:41:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95CA15204E;
        Tue, 11 May 2021 13:41:52 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.116.76])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2108552050;
        Tue, 11 May 2021 13:41:50 +0000 (GMT)
Message-ID: <6f5603489b16918de5d3cbb73c1a7c0e835f0671.camel@linux.ibm.com>
Subject: Re: [PATCH v6 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if
 an HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 11 May 2021 09:41:50 -0400
In-Reply-To: <20210505112935.1410679-4-roberto.sassu@huawei.com>
References: <20210505112935.1410679-1-roberto.sassu@huawei.com>
         <20210505112935.1410679-4-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZP8V75Pkq3nYBFkdWj9OXWQ4OmQ0yKh6
X-Proofpoint-ORIG-GUID: LZS6JOxmSTN6da4DcJqZyK8Wf4i9neXh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_02:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110104
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-05-05 at 13:29 +0200, Roberto Sassu wrote:
> EVM_ALLOW_METADATA_WRITES is an EVM initialization flag that can be set to
> temporarily disable metadata verification until all xattrs/attrs necessary
> to verify an EVM portable signature are copied to the file. This flag is
> cleared when EVM is initialized with an HMAC key, to avoid that the HMAC is
> calculated on unverified xattrs/attrs.
> 
> Currently EVM unnecessarily denies setting this flag if EVM is initialized
> with a public key, which is not a concern as it cannot be used to trust
> xattrs/attrs updates. This patch removes this limitation.
> 
> Cc: stable@vger.kernel.org # 4.16.x
> Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Once the comments below are addressed, 

Reviewed-by:  Mimi Zohar <zohar@linux.ibm.com>

> ---
>  Documentation/ABI/testing/evm      | 5 +++--
>  security/integrity/evm/evm_secfs.c | 5 ++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/evm b/Documentation/ABI/testing/evm
> index 3c477ba48a31..eb6d70fd6fa2 100644
> --- a/Documentation/ABI/testing/evm
> +++ b/Documentation/ABI/testing/evm
> @@ -49,8 +49,9 @@ Description:
>  		modification of EVM-protected metadata and
>  		disable all further modification of policy
>  
> -		Note that once a key has been loaded, it will no longer be
> -		possible to enable metadata modification.
> +		Note that once an HMAC key has been loaded, it will no longer
> +		be possible to enable metadata modification and, if it is
> +		already enabled, it will be disabled.

It's worth mentioning that echo'ing a new value is additive.  Once EVM
metadata modification is enabled, the only way of disabling it is by
enabling an HMAC key.  It's also worth mentioning that metadata writes
are only permitted once further changes to the EVM policy are disabled.
Perhaps the best way of explaining this is by including a new example -
echo 6> <securityfs>/evm.

>  
>  		Until key loading has been signaled EVM can not create
>  		or validate the 'security.evm' xattr, but returns
> diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
> index bbc85637e18b..860c48b9a0c3 100644
> --- a/security/integrity/evm/evm_secfs.c
> +++ b/security/integrity/evm/evm_secfs.c
> @@ -81,11 +81,10 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
>  		return -EINVAL;
>  
>  	/* Don't allow a request to freshly enable metadata writes if
> -	 * keys are loaded.
> +	 * an HMAC key is loaded.
>  	 */

Please drop the word "freshly".  While updating the comment, please
move the sentence starting with "Don't" to a new line.

>  	if ((i & EVM_ALLOW_METADATA_WRITES) &&
> -	    ((evm_initialized & EVM_KEY_MASK) != 0) &&
> -	    !(evm_initialized & EVM_ALLOW_METADATA_WRITES))
> +	    (evm_initialized & EVM_INIT_HMAC) != 0)
>  		return -EPERM;
>  
>  	if (i & EVM_INIT_HMAC) {


