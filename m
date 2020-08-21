Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EC024DF9D
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 20:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgHUSaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 14:30:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbgHUSaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 14:30:19 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LI3UuM029711;
        Fri, 21 Aug 2020 14:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=UdI+uESx+0ouwqK+UkkXRC5jVNonEHLLFlFBL4bsdZc=;
 b=MPICVs9/96Ubrco6QijwGI2grU0C+tAwYz2xEMYb9dlpTCaC7bqlLEjCRl307R4aXvbm
 wSRsCVVYICyLAEVMPaN2l8RHG6lvIMHrz+xMHhjY5YQNO4dCAN3Dq8aFTAfBSkBjaX63
 RUckNaX2pirU9jf73ic+CE9ZTUu91DEPgcaQ/l86H+PE0f4myVUn1MmBlqWc2E6RD+bc
 Zg6AplL/8rlL+Eecj4mzYrtXVBIeXwcw/Qq3i3I7AdiKld2W+ubG6lKnQ2TiW6jly1Ea
 I3w+VMzkJnj8w5SHNkyjWdE9RD1K5SoPg2Y5rOcl/bgUzkhCBpd+n4eRGSBOLwFNyoDe Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3327mvc9pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 14:30:09 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LIU9ZE143948;
        Fri, 21 Aug 2020 14:30:09 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3327mvc9nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 14:30:09 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LIG935021179;
        Fri, 21 Aug 2020 18:30:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3304ujtu51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 18:30:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LIU4FP62128528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 18:30:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B99852052;
        Fri, 21 Aug 2020 18:30:04 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.65.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A8DBC5204E;
        Fri, 21 Aug 2020 18:30:02 +0000 (GMT)
Message-ID: <2b204e31d21e93c0167d154c2397cd5d11be6e7f.camel@linux.ibm.com>
Subject: Re: [PATCH 01/11] evm: Execute evm_inode_init_security() only when
 the HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Fri, 21 Aug 2020 14:30:01 -0400
In-Reply-To: <20200618160133.937-1-roberto.sassu@huawei.com>
References: <20200618160133.937-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 clxscore=1011 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210166
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

Sorry for the delay in reviewing these patches.   Missing from this
patch set is a cover letter with an explanation for grouping these
patches into a patch set, other than for convenience.  In this case, it
would be along the lines that the original use case for EVM portable
and immutable keys support was for a few critical files, not combined
with an EVM encrypted key type.   This patch set more fully integrates
the initial EVM portable and immutable signature support.

On Thu, 2020-06-18 at 18:01 +0200, Roberto Sassu wrote:
> evm_inode_init_security() requires the HMAC key to calculate the HMAC on
> initial xattrs provided by LSMs. Unfortunately, with the evm_key_loaded()
> check, the function continues even if the HMAC key is not loaded
> (evm_key_loaded() returns true also if EVM has been initialized only with a
> public key). If the HMAC key is not loaded, evm_inode_init_security()
> returns an error later when it calls evm_init_hmac().
> 
> Thus, this patch replaces the evm_key_loaded() check with a check of the
> EVM_INIT_HMAC flag in evm_initialized, so that evm_inode_init_security()
> returns 0 instead of an error.
> 
> Cc: stable@vger.kernel.org # 4.5.x
> Fixes: 26ddabfe96b ("evm: enable EVM when X509 certificate is loaded")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

> ---
>  security/integrity/evm/evm_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 0d36259b690d..744c105b48d1 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -521,7 +521,8 @@ int evm_inode_init_security(struct inode *inode,
>  	struct evm_xattr *xattr_data;
>  	int rc;
>  
> -	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
> +	if (!(evm_initialized & EVM_INIT_HMAC) ||
> +	    !evm_protected_xattr(lsm_xattr->name))
>  		return 0;
>  
>  	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);


