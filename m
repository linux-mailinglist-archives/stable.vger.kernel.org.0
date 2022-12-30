Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEF16598C1
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 14:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbiL3NfR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 30 Dec 2022 08:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiL3NfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 08:35:15 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118181A83E
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 05:35:12 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-314-HWfElW15Mq-_iaahh_74GQ-1; Fri, 30 Dec 2022 13:35:09 +0000
X-MC-Unique: HWfElW15Mq-_iaahh_74GQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 30 Dec
 2022 13:35:07 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Fri, 30 Dec 2022 13:35:07 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Roberto Sassu' <roberto.sassu@huaweicloud.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v5 1/2] lib/mpi: Fix buffer overrun when SG is too long
Thread-Topic: [PATCH v5 1/2] lib/mpi: Fix buffer overrun when SG is too long
Thread-Index: AQHZGf+Li10Ctze9/ky4tLizwqJmjK6Gb6hQ
Date:   Fri, 30 Dec 2022 13:35:07 +0000
Message-ID: <6949ced7c1014488b2d00ff26eba6b6b@AcuMS.aculab.com>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-2-roberto.sassu@huaweicloud.com>
In-Reply-To: <20221227142740.2807136-2-roberto.sassu@huaweicloud.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu
> Sent: 27 December 2022 14:28
> 
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
> The helper mpi_read_raw_from_sgl sets the number of entries in
> the SG list according to nbytes.  However, if the last entry
> in the SG list contains more data than nbytes, then it may overrun
> the buffer because it only allocates enough memory for nbytes.
> 
> Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
> Reported-by: Roberto Sassu <roberto.sassu@huaweicloud.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  lib/mpi/mpicoder.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
> index 39c4c6731094..3cb6bd148fa9 100644
> --- a/lib/mpi/mpicoder.c
> +++ b/lib/mpi/mpicoder.c
> @@ -504,7 +504,8 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
> 
>  	while (sg_miter_next(&miter)) {
>  		buff = miter.addr;
> -		len = miter.length;
> +		len = min_t(unsigned, miter.length, nbytes);

Technically that min_t() is incorrect.
miter.length is size_t (unsigned long on 64bit) and nbytes unsigned int.
Any cast needs to force the smaller type to the larger one.
(Clearly here the domain of the values is probably than 4G - but that isn't
the point. There must be some places where the sg length needs to
be size_t because 32 bits isn't enough.)

In reality min() is being completely over-zealous in its checking and
should allow comparisons where the signed-ness of the two values matches.
Search for the patch I posted before xmas.

	David


> +		nbytes -= len;
> 
>  		for (x = 0; x < len; x++) {
>  			a <<= 8;
> --
> 2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

