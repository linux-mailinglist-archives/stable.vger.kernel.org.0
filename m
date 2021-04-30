Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA3F370207
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 22:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhD3U3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 16:29:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5986 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231325AbhD3U3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 16:29:05 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13UKF2OB109712;
        Fri, 30 Apr 2021 16:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=pxiRmky6ur7sUT82EcQQsIfV75IKw/jYxavOQF/kgck=;
 b=khzwySDheuFHlkaKsRyq2era6MP8PJe0978H0RFvdeclCNL2oI9wPZ3qxKu0Vs1ZT8x9
 cr44Bq7HxeiJwx+2dhgyPCdsPJPi+DwSod4yKo7nUtrT80+hyFJeSTqyzgOvbd9pdoEr
 7ZY62dBVWzWxd7c8jeOizFY6PXxMca0zrliI7lgefqesgXjjlH4568G09k8DVUYEPwx2
 XUWiKrcvz1WOJsHJl6an2o9U5E1qLwqMNjwNv+ByNWrBlTXnF2X+IcAqflR2YwUN/Rda
 AAaYBCTH20tBK5ODSmZtKaM1a7zofukk2GaanD6KadQP3+MNoRubOxsOvoTfTT7sM3un 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 388rrsg832-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Apr 2021 16:28:12 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13UKGXCm117187;
        Fri, 30 Apr 2021 16:28:12 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 388rrsg82k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Apr 2021 16:28:12 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13UKSAwL009267;
        Fri, 30 Apr 2021 20:28:10 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 384gjxsurv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Apr 2021 20:28:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13UKS7S431785316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 20:28:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C89B3AE04D;
        Fri, 30 Apr 2021 20:28:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7285DAE053;
        Fri, 30 Apr 2021 20:28:05 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.211.32.5])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Apr 2021 20:28:05 +0000 (GMT)
Message-ID: <48beadc5561f1c0d697be322bc347ebeea37503d.camel@linux.ibm.com>
Subject: Re: [PATCH v5 03/12] evm: Refuse EVM_ALLOW_METADATA_WRITES only if
 an HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com,
        ericchiang@google.com, bweeks@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Fri, 30 Apr 2021 16:28:04 -0400
In-Reply-To: <20210407105252.30721-4-roberto.sassu@huawei.com>
References: <20210407105252.30721-1-roberto.sassu@huawei.com>
         <20210407105252.30721-4-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ScSj7frOsZQorSSHi6ZIesLfcqL4iOkE
X-Proofpoint-ORIG-GUID: gdK7viZ1-c1EWg6UkRcCYx-FYB4eKrPG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-30_12:2021-04-30,2021-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 clxscore=1011 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104300139
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Wed, 2021-04-07 at 12:52 +0200, Roberto Sassu wrote:
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
> ---
>  Documentation/ABI/testing/evm      | 5 +++--
>  security/integrity/evm/evm_secfs.c | 4 ++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
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
>  
>  		Until key loading has been signaled EVM can not create
>  		or validate the 'security.evm' xattr, but returns
> diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
> index bbc85637e18b..197a4b83e534 100644
> --- a/security/integrity/evm/evm_secfs.c
> +++ b/security/integrity/evm/evm_secfs.c
> @@ -81,10 +81,10 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
>  		return -EINVAL;
>  
>  	/* Don't allow a request to freshly enable metadata writes if
> -	 * keys are loaded.
> +	 * an HMAC key is loaded.
>  	 */
>  	if ((i & EVM_ALLOW_METADATA_WRITES) &&
> -	    ((evm_initialized & EVM_KEY_MASK) != 0) &&
> +	    ((evm_initialized & EVM_INIT_HMAC) != 0) &&
>  	    !(evm_initialized & EVM_ALLOW_METADATA_WRITES))
>  		return -EPERM;
>  

The comment "freshly enable" is confusing.  Perhaps the original intent
was to enable flags before loading any keys.  So the comment and code
were kind of in sync.  With this change, enabling metadata writes may
be triggered after loading an x509 certificate.  Unless someone
comments, I don't have problems with this change.

Once metadata writes are enabled, the only way of disabling them is by
loading and enabling an HMAC key.  With this change "freshly enable"
only refers to after an HMAC key is loaded, when the setup completion
flag is not set.  The code can be simplified by just checking if an
HMAC key is loaded.

thanks,

Mimi

