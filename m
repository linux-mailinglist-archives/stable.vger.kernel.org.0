Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA98724FDA0
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 14:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHXMSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 08:18:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbgHXMSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 08:18:11 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07OC28RL026224;
        Mon, 24 Aug 2020 08:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=YVSlf2AzXg5AoaIwusruiLv/LC+K0rAL6DWLqYRzu1s=;
 b=S6YvTQRCPNeVhcrfUiCw5kqNqRGF/USGHCkQEFqnxjmdiIh43eXQJglqZWRVAD9/eU24
 VRDM8m9NBo5CSL64kLs8VhfdfgPc5TKAGrL698OeV8q0s6a9u2AXQVFKfMytoZipkJDE
 lO/e1DtCGZ/NvkcPpE8KHvNflFP3NA2hc9B8pST7vcV224p8PmJNjPF18dr2rB1t51kY
 vReiTYBn6gQ6bNd83JvIvVTKB/DbbPGdTMdD5EIWbd/Iv/XHou1XXXyCr4QmPduPbrON
 8exR71HgEl3HNxisTYYOUAepjCvGeaddzS4W7IOXeoBci9hHYYBmHi+Ng+5bvV+nhjxW XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 334d6ygfq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 08:18:03 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07OCAhWu058306;
        Mon, 24 Aug 2020 08:18:02 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 334d6ygfp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 08:18:02 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07OCDupV015779;
        Mon, 24 Aug 2020 12:18:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 332ujktb50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 12:18:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07OCHwse28311886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 12:17:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97162AE045;
        Mon, 24 Aug 2020 12:17:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B9BAAE051;
        Mon, 24 Aug 2020 12:17:57 +0000 (GMT)
Received: from sig-9-65-254-31.ibm.com (unknown [9.65.254.31])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Aug 2020 12:17:57 +0000 (GMT)
Message-ID: <67cafcf63daf8e418871eb5302e7327ba851e253.camel@linux.ibm.com>
Subject: Re: [PATCH 07/11] evm: Set IMA_CHANGE_XATTR/ATTR bit if
 EVM_ALLOW_METADATA_WRITES is set
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Mon, 24 Aug 2020 08:17:56 -0400
In-Reply-To: <20200618160458.1579-7-roberto.sassu@huawei.com>
References: <20200618160329.1263-2-roberto.sassu@huawei.com>
         <20200618160458.1579-7-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_08:2020-08-24,2020-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=3 priorityscore=1501
 phishscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240092
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-06-18 at 18:04 +0200, Roberto Sassu wrote:
> When EVM_ALLOW_METADATA_WRITES is set, EVM allows any operation on
> metadata. Its main purpose is to allow users to freely set metadata when
> they are protected by a portable signature, until the HMAC key is loaded.
> 
> However, IMA is not notified about metadata changes and, after the first
> appraisal, always allows access to the files without checking metadata
> again.

^after the first successful appraisal
> 
> This patch checks in evm_reset_status() if EVM_ALLOW_METADATA WRITES is
> enabled and if it is, sets the IMA_CHANGE_XATTR/ATTR bits depending on the
> operation performed. At the next appraisal, metadata are revalidated.

EVM modifying IMA bits crosses the boundary between EVM and IMA.  There
is already an IMA post_setattr hook.  IMA could reset its own bit
there.  If necessary EVM could export as a function it's status info.

Mimi

> 
> This patch also adds a call to evm_reset_status() in
> evm_inode_post_setattr() so that EVM won't return the cached status the
> next time appraisal is performed.
> 
> Cc: stable@vger.kernel.org # 4.16.x
> Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/evm/evm_main.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 41cc6a4aaaab..d4d918183094 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -478,13 +478,17 @@ int evm_inode_removexattr(struct dentry *dentry, const char *xattr_name)
>  	return evm_protect_xattr(dentry, xattr_name, NULL, 0);
>  }
>  
> -static void evm_reset_status(struct inode *inode)
> +static void evm_reset_status(struct inode *inode, int bit)
>  {
>  	struct integrity_iint_cache *iint;
>  
>  	iint = integrity_iint_find(inode);
> -	if (iint)
> +	if (iint) {
> +		if (evm_initialized & EVM_ALLOW_METADATA_WRITES)
> +			set_bit(bit, &iint->atomic_flags);
> +
>  		iint->evm_status = INTEGRITY_UNKNOWN;
> +	}
>  }
>  
>  /**:q
> @@ -507,7 +511,7 @@ void evm_inode_post_setxattr(struct dentry *dentry, const char *xattr_name,
>  				  && !posix_xattr_acl(xattr_name)))
>  		return;
>  
> -	evm_reset_status(dentry->d_inode);
> +	evm_reset_status(dentry->d_inode, IMA_CHANGE_XATTR);
>  
>  	evm_update_evmxattr(dentry, xattr_name, xattr_value, xattr_value_len);
>  }
> @@ -527,7 +531,7 @@ void evm_inode_post_removexattr(struct dentry *dentry, const char *xattr_name)
>  	if (!evm_key_loaded() || !evm_protected_xattr(xattr_name))
>  		return;
>  
> -	evm_reset_status(dentry->d_inode);
> +	evm_reset_status(dentry->d_inode, IMA_CHANGE_XATTR);
>  
>  	evm_update_evmxattr(dentry, xattr_name, NULL, 0);
>  }
> @@ -600,6 +604,8 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
>  	if (!evm_key_loaded())
>  		return;
>  
> +	evm_reset_status(dentry->d_inode, IMA_CHANGE_ATTR);
> +
>  	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
>  		evm_update_evmxattr(dentry, NULL, NULL, 0);
>  }


