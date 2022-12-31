Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA58265A49C
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 14:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiLaNXY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 31 Dec 2022 08:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiLaNXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 08:23:23 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2DD6362
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 05:23:21 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-54-12njZMflPrOHOWWm3UOPXQ-1; Sat, 31 Dec 2022 13:23:15 +0000
X-MC-Unique: 12njZMflPrOHOWWm3UOPXQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sat, 31 Dec
 2022 13:23:14 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Sat, 31 Dec 2022 13:23:14 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Herbert Xu' <herbert@gondor.apana.org.au>
CC:     'Roberto Sassu' <roberto.sassu@huaweicloud.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v5 1/2] lib/mpi: Fix buffer overrun when SG is too long
Thread-Topic: [PATCH v5 1/2] lib/mpi: Fix buffer overrun when SG is too long
Thread-Index: AQHZGf+Li10Ctze9/ky4tLizwqJmjK6Gb6hQgAAmKQCAAWpJUA==
Date:   Sat, 31 Dec 2022 13:23:14 +0000
Message-ID: <0d5fda5b25b8467c860d625116dac1d2@AcuMS.aculab.com>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-2-roberto.sassu@huaweicloud.com>
 <6949ced7c1014488b2d00ff26eba6b6b@AcuMS.aculab.com>
 <Y68GMsGKROsgDbcs@gondor.apana.org.au>
In-Reply-To: <Y68GMsGKROsgDbcs@gondor.apana.org.au>
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu
> Sent: 30 December 2022 15:40
> 
> On Fri, Dec 30, 2022 at 01:35:07PM +0000, David Laight wrote:
> >
> > miter.length is size_t (unsigned long on 64bit) and nbytes unsigned int.
> 
> miter.length is bounded by sg->length which is unsigned int.

I did say 'technically' :-)

Should there be a sg_miter_stop() before the return at the bottom?
Care seems to have been taken to add one before an earlier error return.
(The logic in that function is very strange...)

Indeed other parts of the file are equally strange.
The big multi-line if-else in twocompl() is just:
	p[i] = (p[1] ^ 0xff) + 1;
or even:
	p[i] = -p[i];
That function could also return the 'zero status' to correct
for -0 (rather than the extra check earlier in the caller).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

