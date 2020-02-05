Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5921539A6
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 21:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgBEUlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 15:41:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727192AbgBEUlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 15:41:35 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 015KeE2w078893
        for <stable@vger.kernel.org>; Wed, 5 Feb 2020 15:41:34 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xym4n35eb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 15:41:33 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 5 Feb 2020 20:41:31 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 20:41:28 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 015KfRZD46268756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 20:41:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 270A6AE04D;
        Wed,  5 Feb 2020 20:41:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42953AE053;
        Wed,  5 Feb 2020 20:41:26 +0000 (GMT)
Received: from dhcp-9-31-103-105.watson.ibm.com (unknown [9.31.103.105])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Feb 2020 20:41:26 +0000 (GMT)
Subject: Re: [PATCH v2 2/8] ima: Switch to ima_hash_algo for boot aggregate
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        James.Bottomley@HansenPartnership.com,
        jarkko.sakkinen@linux.intel.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Wed, 05 Feb 2020 15:41:25 -0500
In-Reply-To: <20200205103317.29356-3-roberto.sassu@huawei.com>
References: <20200205103317.29356-1-roberto.sassu@huawei.com>
         <20200205103317.29356-3-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020520-0012-0000-0000-0000038408C2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020520-0013-0000-0000-000021C07466
Message-Id: <1580935285.5585.297.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_06:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 suspectscore=11 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050158
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-02-05 at 11:33 +0100, Roberto Sassu wrote:
> boot_aggregate is the first entry of IMA measurement list. Its purpose is
> to link pre-boot measurements to IMA measurements. As IMA was designed to
> work with a TPM 1.2, the SHA1 PCR bank was always selected.
> 
> Currently, even if a TPM 2.0 is used, the SHA1 PCR bank is selected.
> However, the assumption that the SHA1 PCR bank is always available is not
> correct, as PCR banks can be selected with the PCR_Allocate() TPM command.
> 
> This patch tries to use ima_hash_algo as hash algorithm for boot_aggregate.
> If no PCR bank uses that algorithm, the patch tries to find the SHA256 PCR
> bank (which is mandatory in the TCG PC Client specification). If also this
> bank is not found, the patch selects the first one. If the TPM algorithm
> of that bank is not mapped to a crypto ID, boot_aggregate is set to zero.
> 
> Changelog
> 
> v1:
> - add Mimi's comments
> - if there is no PCR bank for the IMA default algorithm use SHA256 or the
>   first bank (suggested by James Bottomley)

If the IMA default hash algorithm is not enabled, James' comment was
to use SHA256 for TPM 2.0 and SHA1 for TPM 1.2.  I don't remember him
saying anything about using the first bank, that was in v1 of my
patch.  Please refer to v2 of my patch, based on James' comments.

> 
> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Cc: stable@vger.kernel.org
> ---
>  security/integrity/ima/ima_crypto.c | 45 +++++++++++++++++++++++++----
>  security/integrity/ima/ima_init.c   | 22 ++++++++++----
>  2 files changed, 56 insertions(+), 11 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 73044fc6a952..f2f41a2bc3d4 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -655,18 +655,29 @@ static void __init ima_pcrread(u32 idx, struct tpm_digest *d)
>  }
>  
>  /*
> - * Calculate the boot aggregate hash
> + * The boot_aggregate is a cumulative hash over TPM registers 0 - 7.  With
> + * TPM 1.2 the boot_aggregate was based on reading the SHA1 PCRs, but with
> + * TPM 2.0 hash agility, TPM chips could support multiple TPM PCR banks,
> + * allowing firmware to configure and enable different banks.
> + *
> + * Knowing which TPM bank is read to calculate the boot_aggregate digest
> + * needs to be conveyed to a verifier.  For this reason, use the same
> + * hash algorithm for reading the TPM PCRs as for calculating the boot
> + * aggregate digest as stored in the measurement list.
>   */
> -static int __init ima_calc_boot_aggregate_tfm(char *digest,
> +static int __init ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
>  					      struct crypto_shash *tfm)
>  {
> -	struct tpm_digest d = { .alg_id = TPM_ALG_SHA1, .digest = {0} };
> +	struct tpm_digest d = { .alg_id = alg_id, .digest = {0} };
>  	int rc;
>  	u32 i;
>  	SHASH_DESC_ON_STACK(shash, tfm);
>  
>  	shash->tfm = tfm;
>  
> +	pr_devel("calculating the boot-aggregate based on TPM bank: %04x\n",
> +		 d.alg_id);
> +

Good

>  	rc = crypto_shash_init(shash);
>  	if (rc != 0)
>  		return rc;
> @@ -675,7 +686,8 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest,
>  	for (i = TPM_PCR0; i < TPM_PCR8; i++) {
>  		ima_pcrread(i, &d);
>  		/* now accumulate with current aggregate */
> -		rc = crypto_shash_update(shash, d.digest, TPM_DIGEST_SIZE);
> +		rc = crypto_shash_update(shash, d.digest,
> +					 crypto_shash_digestsize(tfm));
>  	}
>  	if (!rc)
>  		crypto_shash_final(shash, digest);
> @@ -685,14 +697,35 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest,
>  int __init ima_calc_boot_aggregate(struct ima_digest_data *hash)
>  {
> 
< snip >
>  
>  	hash->length = crypto_shash_digestsize(tfm);
> -	rc = ima_calc_boot_aggregate_tfm(hash->digest, tfm);
> +	alg_id = ima_tpm_chip->allocated_banks[bank_idx].alg_id;
> +	rc = ima_calc_boot_aggregate_tfm(hash->digest, alg_id, tfm);

Sure, backporting this change to ima_calc_boot_aggregate_tfm() should
be fine.

Mimi

>  	ima_free_tfm(tfm);
>  

