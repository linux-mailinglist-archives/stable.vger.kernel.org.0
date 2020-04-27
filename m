Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09751BA1D0
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 13:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgD0LAM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 27 Apr 2020 07:00:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:54617 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgD0LAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 07:00:11 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-191-HECg1l8bNsO4jduJXHGeUw-1; Mon, 27 Apr 2020 12:00:07 +0100
X-MC-Unique: HECg1l8bNsO4jduJXHGeUw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 27 Apr 2020 12:00:06 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 27 Apr 2020 12:00:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Roberto Sassu' <roberto.sassu@huawei.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "rgoldwyn@suse.de" <rgoldwyn@suse.de>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "silviu.vlasceanu@huawei.com" <silviu.vlasceanu@huawei.com>,
        "krzysztof.struczynski@huawei.com" <krzysztof.struczynski@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 3/6] ima: Fix ima digest hash table key calculation
Thread-Topic: [PATCH v2 3/6] ima: Fix ima digest hash table key calculation
Thread-Index: AQHWHH8SDZUC+XMi6UOqF9nBthnXX6iMzGEg
Date:   Mon, 27 Apr 2020 11:00:06 +0000
Message-ID: <84ecd8f2576849b29876448df66824fc@AcuMS.aculab.com>
References: <20200427102900.18887-1-roberto.sassu@huawei.com>
 <20200427102900.18887-3-roberto.sassu@huawei.com>
In-Reply-To: <20200427102900.18887-3-roberto.sassu@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu
> Sent: 27 April 2020 11:29
> Function hash_long() accepts unsigned long, while currently only one byte
> is passed from ima_hash_key(), which calculates a key for ima_htable.
> 
> Given that hashing the digest does not give clear benefits compared to
> using the digest itself, remove hash_long() and return the modulus
> calculated on the beginning of the digest with the number of slots. Also
> reduce the depth of the hash table by doubling the number of slots.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3323eec921ef ("integrity: IMA as an integrity service provider")
> Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
> ---
>  security/integrity/ima/ima.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 467dfdbea25c..6ee458cf124a 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -36,7 +36,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
>  #define IMA_DIGEST_SIZE		SHA1_DIGEST_SIZE
>  #define IMA_EVENT_NAME_LEN_MAX	255
> 
> -#define IMA_HASH_BITS 9
> +#define IMA_HASH_BITS 10
>  #define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
> 
>  #define IMA_TEMPLATE_FIELD_ID_MAX_LEN	16
> @@ -179,9 +179,9 @@ struct ima_h_table {
>  };
>  extern struct ima_h_table ima_htable;
> 
> -static inline unsigned long ima_hash_key(u8 *digest)
> +static inline unsigned int ima_hash_key(u8 *digest)
>  {
> -	return hash_long(*digest, IMA_HASH_BITS);
> +	return (*(unsigned int *)digest % IMA_MEASURE_HTABLE_SIZE);

That almost certainly isn't right.
It falls foul of the *(integer_type *)ptr being almost always wrong.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

