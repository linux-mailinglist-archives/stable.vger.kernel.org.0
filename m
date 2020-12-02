Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB952CC2FB
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 18:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387525AbgLBREc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 12:04:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387464AbgLBREc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 12:04:32 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2GVeXk018304;
        Wed, 2 Dec 2020 12:03:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=VkAK9awdrlq9A2BqEcSqkXYPO2nZPqg2uDrl8aCSr8c=;
 b=FpXLeMbGp2LkCIUGhyE6f6Rd77dMZhgDDxn23HsKYaTE0uEEb+HTLSNWLglI964V1Bo7
 Ir9vbn6RkxaIsmvPnU9yYR9N7/B4gLE9NqfAxwmBdVBy2CiqO5M3RGErR27UochMCyMp
 itAioCGaob3hYYkFD0P6ETc5Sr+B7raPrz/haj0V258fk75u2Ndj4j9hbH94wosQ4Bw5
 v6C8u5QgukhHIsb/zEr2YLopx7suwT9TZaSbs+qbE6io0FjgN2sVr2kLqAuvI7iXI/91
 lamQi1YtH+BS2fnqciYt7rLfRhTBE9qcKNgsaqPhOkuNI0IpMa9pg4VEONxTsozJVUXH mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3569tgk0hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 12:03:41 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B2GiTnx056004;
        Wed, 2 Dec 2020 12:03:41 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3569tgk0gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 12:03:41 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B2H26QK013988;
        Wed, 2 Dec 2020 17:03:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 354fpdb622-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 17:03:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B2H3a6Y58065406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 17:03:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA2115204E;
        Wed,  2 Dec 2020 17:03:36 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.92.233])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5092452052;
        Wed,  2 Dec 2020 17:03:35 +0000 (GMT)
Message-ID: <c90746b88ff93402910f03a02ffb555bb781578d.camel@linux.ibm.com>
Subject: Re: [PATCH v3 01/11] evm: Execute evm_inode_init_security() only
 when an HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org
Date:   Wed, 02 Dec 2020 12:03:34 -0500
In-Reply-To: <20201111092302.1589-2-roberto.sassu@huawei.com>
References: <20201111092302.1589-1-roberto.sassu@huawei.com>
         <20201111092302.1589-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 suspectscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020096
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-11-11 at 10:22 +0100, Roberto Sassu wrote:
> evm_inode_init_security() requires an HMAC key to calculate the HMAC on
> initial xattrs provided by LSMs. However, it checks generically whether a
> key has been loaded, including also public keys, which is not correct as
> public keys are not suitable to calculate the HMAC.
> 
> Originally, support for signature verification was introduced to verify a
> possibly immutable initial ram disk, when no new files are created, and to
> switch to HMAC for the root filesystem. By that time, an HMAC key should
> have been loaded and usable to calculate HMACs for new files.
> 
> More recently support for requiring an HMAC key was removed from the
> kernel, so that signature verification can be used alone. Since this is a
> legitimate use case, evm_inode_init_security() should not return an error
> when no HMAC key has been loaded.
> 
> This patch fixes this problem by replacing the evm_key_loaded() check with
> a check of the EVM_INIT_HMAC flag in evm_initialized.
> 
> Cc: stable@vger.kernel.org # 4.5.x
> Fixes: 26ddabfe96b ("evm: enable EVM when X509 certificate is loaded")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  security/integrity/evm/evm_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 76d19146d74b..001e001eae01 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -530,7 +530,8 @@ int evm_inode_init_security(struct inode *inode,
>  	struct evm_xattr *xattr_data;
>  	int rc;
>  
> -	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
> +	if (!(evm_initialized & EVM_INIT_HMAC) ||
> +	    !evm_protected_xattr(lsm_xattr->name))
>  		return 0;
>  
>  	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);

Let's update the function description to make it explicit.  Something
like: "evm_inode_init_security - initializes security.evm HMAC value"

Mimi



