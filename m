Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD763B1EA3
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 18:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFWQaJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 23 Jun 2021 12:30:09 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:20099 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhFWQaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 12:30:08 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-216-XdzaOTOkN5a2bqttQ15hmQ-1; Wed, 23 Jun 2021 17:27:48 +0100
X-MC-Unique: XdzaOTOkN5a2bqttQ15hmQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Jun
 2021 17:27:47 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Wed, 23 Jun 2021 17:27:47 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>
CC:     'Guillaume Tucker' <guillaume.tucker@collabora.com>,
        Shuah Khan <shuah@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
Thread-Topic: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
Thread-Index: AQHXaCznpjkpNTpwjEW+kA8o/GdKZashmKhggAAdGgCAABKuUA==
Date:   Wed, 23 Jun 2021 16:27:47 +0000
Message-ID: <76a575d1364a47458d27c76c65b673b6@AcuMS.aculab.com>
References: <20210619025834.2505201-1-keescook@chromium.org>
 <e958209b-8621-57ca-01d6-2e76b05dab4c@collabora.com>
 <42f26361db6f481e980ac349bf0079ef@AcuMS.aculab.com>
 <202106230917.FE2F587@keescook>
In-Reply-To: <202106230917.FE2F587@keescook>
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
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook
> Sent: 23 June 2021 17:19
> 
> On Wed, Jun 23, 2021 at 01:43:04PM +0000, David Laight wrote:
> > From: Guillaume Tucker
> > > Sent: 23 June 2021 13:40
> > ...
> > > > diff --git a/tools/testing/selftests/lkdtm/run.sh b/tools/testing/selftests/lkdtm/run.sh
> > > > index bb7a1775307b..0f9f22ac004b 100755
> > > > --- a/tools/testing/selftests/lkdtm/run.sh
> > > > +++ b/tools/testing/selftests/lkdtm/run.sh
> > > > @@ -78,8 +78,9 @@ dmesg > "$DMESG"
> > > >
> > > >  # Most shells yell about signals and we're expecting the "cat" process
> > > >  # to usually be killed by the kernel. So we have to run it in a sub-shell
> > > > -# and silence errors.
> > > > -($SHELL -c 'cat <(echo '"$test"') >'"$TRIGGER" 2>/dev/null) || true
> > > > +# to avoid terminating this script. Leave stderr alone, just in case
> > > > +# something _else_ happens.
> > > > +(/bin/sh -c '(echo '"$test"') | cat >'"$TRIGGER") || true
> >
> > I was having trouble parsing that command - and I'm good
> > at shell scripts.
> > I think the extra subshell the 'echo' is in doesn't help.
> > In fact, is either subshell needed?
> > Surely:
> > /bin/sh -c "echo '$test' | cat >$trigger" || true
> > will work just as well?
> 
> Ah yeah, and I just tested it to double check, it can be even simpler:
> 
> echo "$test" | /bin/sh -c "cat >$TRIGGER" || true

You can probably even do:

echo "$test" | /bin/sh -c cat >$TRIGGER || true

(moving the redirect to the outer shell).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

