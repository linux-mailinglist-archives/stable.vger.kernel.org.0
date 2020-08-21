Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F6424E1F5
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 22:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgHUUOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 16:14:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbgHUUOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 16:14:50 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LK3H1P132003;
        Fri, 21 Aug 2020 16:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=OEL2qiQPMhRIm7Kf1rmkn8qZo5qwji4nRxuZSZ+sKUc=;
 b=rvkncGg+heFsofqSqD8cscXSzXxVYKzgeH/Icc7sfVL0xKNqLeOgd0nwqFFEzch86iwE
 VZulPcvulKDfulzwX906quMaHfHuZEKEYymfp9Ii3r33S8mr695jmEVksqs3tPjtd45u
 NWyD/vb+rv+4mvNqRAA0DMLYqrX3VXxbdOhueO7yzumIMoKu9UkJsqAKyCGh/2ijzFII
 QIPP342d+8f4V/EQShyut2odxaC/2jnl7YIYszYFx0C9lu0o07le7sBYwIMh4nY/gRxN
 LnImjSLAt9/p68Kb/xC+k8VliAQF8vvvkVdZtFVTbD8QV/AeSg8MDf0mZtnjikd9fkPc Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3327xueyev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 16:14:43 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LK3PAG132989;
        Fri, 21 Aug 2020 16:14:43 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3327xueyee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 16:14:43 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LK52fH015848;
        Fri, 21 Aug 2020 20:14:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3304cc4qka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 20:14:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LKEdlB24314184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 20:14:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29160A4053;
        Fri, 21 Aug 2020 20:14:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7ED45A4040;
        Fri, 21 Aug 2020 20:14:37 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.65.240])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 20:14:37 +0000 (GMT)
Message-ID: <caedd49bc2080a2fb8b16b9ecacab67d11e68fd7.camel@linux.ibm.com>
Subject: Re: [PATCH 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if the
 HMAC key is loaded
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Fri, 21 Aug 2020 16:14:36 -0400
In-Reply-To: <20200618160133.937-3-roberto.sassu@huawei.com>
References: <20200618160133.937-1-roberto.sassu@huawei.com>
         <20200618160133.937-3-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_09:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210183
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Thu, 2020-06-18 at 18:01 +0200, Roberto Sassu wrote:
> Granting metadata write is safe if the HMAC key is not loaded, as it won't
> let an attacker obtain a valid HMAC from corrupted xattrs. evm_write_key()
> however does not allow it if any key is loaded, including a public key,
> which should not be a problem.
> 

Why is the existing hebavior a problem?  What is the problem being
solved?

> This patch allows setting EVM_ALLOW_METADATA_WRITES if the EVM_INIT_HMAC
> flag is not set.
> 
> Cc: stable@vger.kernel.org # 4.16.x
> Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/evm/evm_secfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
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

Documentation/ABI/testing/evm needs to be updated as well.

thanks,

Mimi



