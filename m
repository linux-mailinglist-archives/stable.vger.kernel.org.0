Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446BF1BC701
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 19:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgD1Rqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 13:46:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727074AbgD1Rqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 13:46:51 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SHZ0T7018100;
        Tue, 28 Apr 2020 13:46:44 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30pjmjf4tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 13:46:44 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03SHepiB028904;
        Tue, 28 Apr 2020 17:46:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 30mcu592aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 17:46:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03SHkeYk26280154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 17:46:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B02811C06E;
        Tue, 28 Apr 2020 17:46:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9DBE11C05E;
        Tue, 28 Apr 2020 17:46:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.198.90])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Apr 2020 17:46:38 +0000 (GMT)
Message-ID: <1588095998.5195.49.camel@linux.ibm.com>
Subject: Re: [PATCH v2 6/6] ima: Fix return value of ima_write_policy()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        krzysztof.struczynski@huawei.com, stable@vger.kernel.org
Date:   Tue, 28 Apr 2020 13:46:38 -0400
In-Reply-To: <20200427103128.19229-1-roberto.sassu@huawei.com>
References: <20200427102900.18887-1-roberto.sassu@huawei.com>
         <20200427103128.19229-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_12:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280130
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Mon, 2020-04-27 at 12:31 +0200, Roberto Sassu wrote:
> This patch fixes the return value of ima_write_policy() when a new policy
> is directly passed to IMA and the current policy requires appraisal of the
> file containing the policy. Currently, if appraisal is not in ENFORCE mode,
> ima_write_policy() returns 0 and leads user space applications to an
> endless loop. Fix this issue by denying the operation regardless of the
> appraisal mode.
> 
> Changelog
> 
> v1:
> - deny the operation in all cases (suggested by Mimi, Krzysztof)

Relatively recently, people have moved away from including the
"Changelog" in the upstream commit. (I'm removing them now.)  

> 
> Cc: stable@vger.kernel.org # 4.10.x
> Fixes: 19f8a84713edc ("ima: measure and appraise the IMA policy itself")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Without the Changelog, the only way of acknowledging people's
contributions is by including their tags.  Krzysztof, did you want to
add your "Reviewed-by" tag?

> ---

People have started putting the Changelog or any comments immediately
below the separator "---" here.

thanks,

Mimi

>  security/integrity/ima/ima_fs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index 8b030a1c5e0d..e3fcad871861 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -338,8 +338,7 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
>  		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL,
>  				    "policy_update", "signed policy required",
>  				    1, 0);
> -		if (ima_appraise & IMA_APPRAISE_ENFORCE)
> -			result = -EACCES;
> +		result = -EACCES;
>  	} else {
>  		result = ima_parse_add_rule(data);
>  	}

