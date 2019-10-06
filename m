Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98201CCD85
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 02:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfJFAjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 20:39:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726957AbfJFAjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 20:39:05 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x960aYIR005524
        for <stable@vger.kernel.org>; Sat, 5 Oct 2019 20:39:04 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vf5np87w2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 20:39:03 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Sun, 6 Oct 2019 01:39:00 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 6 Oct 2019 01:38:56 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x960ctYr57671800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Oct 2019 00:38:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89019A4040;
        Sun,  6 Oct 2019 00:38:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4502A404D;
        Sun,  6 Oct 2019 00:38:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.134.152])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  6 Oct 2019 00:38:53 +0000 (GMT)
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Sat, 05 Oct 2019 20:38:53 -0400
In-Reply-To: <1570227068.17537.4.camel@HansenPartnership.com>
References: <1570128827.5046.19.camel@linux.ibm.com>
         <20191003215125.GA30511@linux.intel.com>
         <20191003215743.GB30511@linux.intel.com>
         <1570140491.5046.33.camel@linux.ibm.com>
         <1570147177.10818.11.camel@HansenPartnership.com>
         <20191004182216.GB6945@linux.intel.com>
         <1570213491.3563.27.camel@HansenPartnership.com>
         <20191004183342.y63qdvspojyf3m55@cantor>
         <1570214574.3563.32.camel@HansenPartnership.com>
         <20191004200728.xoj6jlgbhv57gepc@cantor>
         <20191004201134.nuesk6hxtxajnxh2@cantor>
         <1570227068.17537.4.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19100600-0012-0000-0000-0000035467BF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100600-0013-0000-0000-0000218F7549
Message-Id: <1570322333.5046.145.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-05_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910060003
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-10-04 at 15:11 -0700, James Bottomley wrote:

> +
> +/**
> + * tpm_get_random() - get random bytes influenced by the TPM's RNG
> + * @chip:	a &struct tpm_chip instance, %NULL for the default chip
> + * @out:	destination buffer for the random bytes
> + * @max:	the max number of bytes to write to @out
> + *
> + * Uses the TPM as a source of input to the kernel random number
> + * generator and then takes @max bytes directly from the kernel.  In
> + * the worst (no other entropy) case, this will return the pure TPM
> + * random number, but if the kernel RNG has any entropy at all it will
> + * return a mixed entropy output which doesn't rely on a single
> + * source.
> + *
> + * Return: number of random bytes read or a negative error value.
> + */
> +int tpm_get_random(struct tpm_chip *chip, u8 *out, size_t max)
> +{
> +	int rc;
> +
> +	rc = __tpm_get_random(chip, out, max);
> +	if (rc <= 0)
> +		return rc;
> +	/*
> +	 * assume the TPM produces pure randomness, so the amount of
> +	 * entropy is the number of bits returned
> +	 */
> +	add_hwgenerator_randomness(out, rc, rc * 8);
> +	get_random_bytes(out, rc);

Using the TPM as a source of input to the kernel random number
generator is fine, but please don't change the meaning of trusted
keys.  The trusted-encrypted keys documentation clearly states
"Trusted Keys use a TPM both to generate and to seal the keys."

If you really want to use a different random number source instead of
the TPM, then define a new trusted key option (eg. rng=kernel), with
the default being the TPM.

Mimi


> +
> +	return rc;
> +}
>  EXPORT_SYMBOL_GPL(tpm_get_random);

