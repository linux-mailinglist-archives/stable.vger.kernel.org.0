Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A824B584E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 18:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiBNRQT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 14 Feb 2022 12:16:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237384AbiBNRQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 12:16:18 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0256652C4
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 09:16:09 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-196-yVufUhzxMf6aRMAEmkShMQ-1; Mon, 14 Feb 2022 17:16:07 +0000
X-MC-Unique: yVufUhzxMf6aRMAEmkShMQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Mon, 14 Feb 2022 17:16:06 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Mon, 14 Feb 2022 17:16:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Solar Designer' <solar@openwall.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alexey Gladkov" <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        Michal Koutn?? <mkoutny@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 5/8] ucounts: Handle wrapping in is_ucounts_overlimit
Thread-Topic: [PATCH 5/8] ucounts: Handle wrapping in is_ucounts_overlimit
Thread-Index: AQHYIGEwFCfhAMi5WkKLr8caSZ9ypKyTSxMw
Date:   Mon, 14 Feb 2022 17:16:06 +0000
Message-ID: <ff5abac97c7549d392674ce09cd970c5@AcuMS.aculab.com>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
 <20220211021324.4116773-5-ebiederm@xmission.com>
 <20220212223638.GB29214@openwall.com>
In-Reply-To: <20220212223638.GB29214@openwall.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Solar Designer
> Sent: 12 February 2022 22:37
...
> bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsigned long rlimit)
> {
> 	struct ucounts *iter;
> 	long max = rlimit;
> 	if (rlimit > LONG_MAX)
> 		max = LONG_MAX;
> 
> The assignment on "long max = rlimit;" would have already been UB if
> "rlimit > LONG_MAX", which is only checked afterwards.  I think the
> above would be better written as:

I'm pretty sure assignments and casts of negative values to unsigned
types are actually well defined.
Although the actual value may differ for ones-compliment and
sign-overpunch systems.
But I suspect Linux requires twos-compliment negative numbers.

(In much the same way as it requires that NULL be the all zero
bit pattern - although a load of annoying compiler warnings are only
relevant if that isn't the case.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

