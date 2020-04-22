Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A751B43DA
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgDVMDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 08:03:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726835AbgDVMDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 08:03:11 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MC35eO106317
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 08:03:10 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggr3n6vk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 08:03:09 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 22 Apr 2020 13:02:30 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 13:02:27 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03MC32sU56033566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 12:03:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7758A11C054;
        Wed, 22 Apr 2020 12:03:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79CA111C050;
        Wed, 22 Apr 2020 12:03:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.220.15])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 12:03:01 +0000 (GMT)
Subject: Re: [PATCH 1/5] ima: Set file->f_mode instead of file->f_flags in
 ima_calc_file_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, krzysztof.struczynski@huawei.com,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Date:   Wed, 22 Apr 2020 08:03:01 -0400
In-Reply-To: <20200325161116.7082-1-roberto.sassu@huawei.com>
References: <20200325161116.7082-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042212-0008-0000-0000-0000037558B1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042212-0009-0000-0000-00004A9721D8
Message-Id: <1587556981.5738.7.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_03:2020-04-22,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220097
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[CC'ing Goldwyn Rodrigues]

Hi Roberto,

On Wed, 2020-03-25 at 17:11 +0100, Roberto Sassu wrote:
> Commit a408e4a86b36 ("ima: open a new file instance if no read
> permissions") tries to create a new file descriptor to calculate a file
> digest if the file has not been opened with O_RDONLY flag. However, if a
> new file descriptor cannot be obtained, it sets the FMODE_READ flag to
> file->f_flags instead of file->f_mode.
> 
> This patch fixes this issue by replacing f_flags with f_mode as it was
> before that commit.
> 
> Cc: stable@vger.kernel.org # 4.20.x
> Fixes: a408e4a86b36 ("ima: open a new file instance if no read permissions")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/ima/ima_crypto.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 423c84f95a14..8ab17aa867dd 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -436,7 +436,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  			 */

Thanks, Roberto.  The comment above here and the rest of the code
refers to flags.  Both should be updated as well to reflect using
f_mode.

>  			pr_info_ratelimited("Unable to reopen file for reading.\n");
>  			f = file;
> -			f->f_flags |= FMODE_READ;
> +			f->f_mode |= FMODE_READ;
>  			modified_flags = true;

The variable should be changed to "modified_mode".

thanks,

Mimi

>  		} else {
>  			new_file_instance = true;
> @@ -456,7 +456,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  	if (new_file_instance)
>  		fput(f);
>  	else if (modified_flags)
> -		f->f_flags &= ~FMODE_READ;
> +		f->f_mode &= ~FMODE_READ;
>  	return rc;
>  }
>  

