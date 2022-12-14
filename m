Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7128964CEE8
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbiLNRfM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 14 Dec 2022 12:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237959AbiLNRfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 12:35:09 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B848E264A2
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 09:35:06 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mtapsc-4-oxZQ4DUbPQStXoCR3WtWJQ-1; Wed, 14 Dec 2022 17:35:03 +0000
X-MC-Unique: oxZQ4DUbPQStXoCR3WtWJQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 14 Dec
 2022 17:35:01 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Wed, 14 Dec 2022 17:35:01 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        Prashanth K <quic_prashk@quicinc.com>
CC:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 5 . 15" <stable@vger.kernel.org>
Subject: RE: usb: f_fs: Fix CFI failure in ki_complete
Thread-Topic: usb: f_fs: Fix CFI failure in ki_complete
Thread-Index: AQHZDjGpwikydY+vnkC/L44cbfn06q5tpHEA
Date:   Wed, 14 Dec 2022 17:35:01 +0000
Message-ID: <abe47a47aa5d49878c58fc1199be18ea@AcuMS.aculab.com>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
 <Y5cuCMhFIaKraUyi@kroah.com>
In-Reply-To: <Y5cuCMhFIaKraUyi@kroah.com>
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
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman
> Sent: 12 December 2022 13:35
> 
> On Mon, Dec 12, 2022 at 06:54:24PM +0530, Prashanth K wrote:
> > Function pointer ki_complete() expects 'long' as its second
> > argument, but we pass integer from ffs_user_copy_worker. This
> > might cause a CFI failure, as ki_complete is an indirect call
> > with mismatched prototype. Fix this by typecasting the second
> > argument to long.
> 
> "might"?  Does it or not?  If it does, why hasn't this been reported
> before?

Does the cast even help at all.

...
> > -	io_data->kiocb->ki_complete(io_data->kiocb, ret);
> > +	io_data->kiocb->ki_complete(io_data->kiocb, (long)ret);
...

If definition of the parameter in the structure member ki_complete()
definition is 'long' then the compiler has to promote 'ret' to long
anyway. CFI has nothing to do with it.

OTOH if you've used a cast to assign a function with a
different prototype to ki_complete then 'all bets are off'
and you get all the run time errors you deserve.
CFI just converts some of them to compile time errors.

For instance if you assign xx_complete(long) to (*ki_complete)(int)
then it is very likely that xx_complete() will an argument
with some of the high bits set.
But adding a cast to the call - ki_complete((long)int_var)
will make absolutely no difference.
The compiler wont zero/sign extend int_var to 64bits for you,
that will just get optimised away and the high bits will
be unchanged.

You're description seems to be the other way around (which might
be safe, but CFI probably still barfs).
But you need to fix the indirect calls so the function types
match.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

