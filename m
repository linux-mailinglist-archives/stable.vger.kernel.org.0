Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731D8242AC
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 23:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfETVUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 17:20:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726692AbfETVUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 17:20:13 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4KL27rR126364
        for <stable@vger.kernel.org>; Mon, 20 May 2019 17:20:12 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sm1avwy6m-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 20 May 2019 17:20:12 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 20 May 2019 22:20:10 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 May 2019 22:20:08 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4KLK7Lc58130628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 21:20:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B5B64C050;
        Mon, 20 May 2019 21:20:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F5F34C04A;
        Mon, 20 May 2019 21:20:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.109])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 May 2019 21:20:05 +0000 (GMT)
Subject: Re: [PATCH 2/4] evm: reset status in evm_inode_post_setattr()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Mon, 20 May 2019 17:19:55 -0400
In-Reply-To: <20190516161257.6640-2-roberto.sassu@huawei.com>
References: <20190516161257.6640-1-roberto.sassu@huawei.com>
         <20190516161257.6640-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19052021-0008-0000-0000-000002E8B38E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052021-0009-0000-0000-000022556717
Message-Id: <1558387195.4039.76.camel@linux.ibm.com>
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
> This patch adds a call to evm_reset_status() in evm_inode_post_setattr(),
> before security.evm is updated. The same is done in the other
> evm_inode_post_* functions.
> 
> Fixes: 523b74b16bcbb ("evm: reset EVM status when file attributes change")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Cc: stable@vger.kernel.org

Why all of a sudden do we also need to clear the EVM cached status
when modifying the file attributes?  The HMAC is being recalculated.  
If the reason is because of EVM portable and immutable signatures,
then the "Fixes" tag is incorrect.

Mimi

> ---
>  security/integrity/evm/evm_main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index b6d9f14bc234..b41c2d8a8834 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -512,8 +512,11 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
>  	if (!evm_key_loaded())
>  		return;
>  
> -	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
> +	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)) {
> +		evm_reset_status(dentry->d_inode);
> +
>  		evm_update_evmxattr(dentry, NULL, NULL, 0);
> +	}
>  }
>  
>  /*

