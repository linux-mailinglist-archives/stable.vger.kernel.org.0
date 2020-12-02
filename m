Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3B62CC8AD
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 22:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgLBVKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 16:10:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726634AbgLBVKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 16:10:50 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2L3jgq052776;
        Wed, 2 Dec 2020 16:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=LGkIrjtqa4joGxWb7uI/qvkO4B4va5rfsqLIzouACJ0=;
 b=Tqcx84/+3LacU4+UY8colQcRxLLIUvRYwlaRCZOy5d/ZgWZ7DUiUkiF+X/vSTUxVmjzr
 NdGGnWU1Zkj3v7ma7aCyMEuZNpvCum5Ku0S15p1gf3FSM+t3ev0lesJPRxd8rJfZVyLV
 5w+WqOsyAfGLIIJZPHJvkEZpuWxPAQXRhoK8V6bnrS6n5sxhTWgxrDkv5eD41UuRbKsI
 cXoSjVph+XLBK+Rhn5q8ctNAKkwK3W3NpLieqS1h2zfgImhWFj+uYQvYVvStqLfV6s2q
 tgnbHeVzDl7tKxwfHqDGwoYgJ+mnKqJks6EikLr94Xkiuh7C/b5FawP1X/Nf4cpDJJQB Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 356jekga8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 16:10:04 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B2L4grh064376;
        Wed, 2 Dec 2020 16:10:03 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 356jekga7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 16:10:03 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B2L7TJj017114;
        Wed, 2 Dec 2020 21:10:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 353e686s1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 21:10:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B2L7UE85309106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 21:07:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1674D4C046;
        Wed,  2 Dec 2020 21:07:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B80B4C04E;
        Wed,  2 Dec 2020 21:07:28 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.92.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Dec 2020 21:07:27 +0000 (GMT)
Message-ID: <a84520e3c7de9c767cbbc17e8ad894525043e211.camel@linux.ibm.com>
Subject: Re: [PATCH v3 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if
 an HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org
Date:   Wed, 02 Dec 2020 16:07:27 -0500
In-Reply-To: <20201111092302.1589-4-roberto.sassu@huawei.com>
References: <20201111092302.1589-1-roberto.sassu@huawei.com>
         <20201111092302.1589-4-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_12:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020123
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-11-11 at 10:22 +0100, Roberto Sassu wrote:
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
>  security/integrity/evm/evm_secfs.c | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
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
> index cfc3075769bb..92fe26ace797 100644
> --- a/security/integrity/evm/evm_secfs.c
> +++ b/security/integrity/evm/evm_secfs.c
> @@ -84,7 +84,7 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
>  	 * keys are loaded.
>  	 */
>  	if ((i & EVM_ALLOW_METADATA_WRITES) &&
> -	    ((evm_initialized & EVM_KEY_MASK) != 0) &&
> +	    ((evm_initialized & EVM_INIT_HMAC) != 0) &&
>  	    !(evm_initialized & EVM_ALLOW_METADATA_WRITES))
>  		return -EPERM;
>  

If an HMAC key is loaded EVM_ALLOW_METADATA_WRITES should already be
disabled.  Testing EVM_ALLOW_METADATA_WRITES shouldn't be needed. 
Please update the comment: "Don't allow a request to freshly enable
metadata writes if keys are loaded."

thanks,

Mimi

