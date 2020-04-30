Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342EF1BF1FA
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 10:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgD3IDx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 Apr 2020 04:03:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:47084 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbgD3IDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 04:03:52 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-188-QwramPYPODaeNg-qytVVbw-1; Thu, 30 Apr 2020 09:03:47 +0100
X-MC-Unique: QwramPYPODaeNg-qytVVbw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 Apr 2020 09:03:47 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 Apr 2020 09:03:47 +0100
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
Subject: RE: [RESEND][PATCH v2 3/6] ima: Fix ima digest hash table key
 calculation
Thread-Topic: [RESEND][PATCH v2 3/6] ima: Fix ima digest hash table key
 calculation
Thread-Index: AQHWHS80o0OMQYVPmUqc5kiRSsIx16iRUJzg
Date:   Thu, 30 Apr 2020 08:03:47 +0000
Message-ID: <060c71f88c8d4c6a9fafca4b329605c5@AcuMS.aculab.com>
References: <20200427102900.18887-3-roberto.sassu@huawei.com>
 <20200428073010.25631-1-roberto.sassu@huawei.com>
In-Reply-To: <20200428073010.25631-1-roberto.sassu@huawei.com>
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
> Sent: 28 April 2020 08:30
> From: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
> 
> Function hash_long() accepts unsigned long, while currently only one byte
> is passed from ima_hash_key(), which calculates a key for ima_htable.
> 
> Given that hashing the digest does not give clear benefits compared to
> using the digest itself, remove hash_long() and return the modulus
> calculated on the first two bytes of the digest with the number of slots.
> Also reduce the depth of the hash table by doubling the number of slots.
> 
> Changelog
> 
> v2: directly access the first two bytes of the digest to avoid memory
>     access issues on big endian systems (suggested by David Laight)
> 
> Cc: stable@vger.kernel.org
> Fixes: 3323eec921ef ("integrity: IMA as an integrity service provider")
> Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>

Acked-by: David.Laight@aculab.com

> ---
>  security/integrity/ima/ima.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 467dfdbea25c..02796473238b 100644
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
> @@ -179,9 +179,10 @@ struct ima_h_table {
>  };
>  extern struct ima_h_table ima_htable;
> 
> -static inline unsigned long ima_hash_key(u8 *digest)
> +static inline unsigned int ima_hash_key(u8 *digest)
>  {
> -	return hash_long(*digest, IMA_HASH_BITS);
> +	/* there is no point in taking a hash of part of a digest */
> +	return (digest[0] | digest[1] << 8) % IMA_MEASURE_HTABLE_SIZE;
>  }
> 
>  #define __ima_hooks(hook)		\
> --
> 2.17.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

