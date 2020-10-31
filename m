Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07842A1573
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgJaL2I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 31 Oct 2020 07:28:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:58585 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgJaL1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 07:27:41 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-182-4z7xTnoLOrGqJFlKs8kCWg-1; Sat, 31 Oct 2020 11:27:13 +0000
X-MC-Unique: 4z7xTnoLOrGqJFlKs8kCWg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 31 Oct 2020 11:27:13 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 31 Oct 2020 11:27:13 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Song Liu' <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     stable <stable@vger.kernel.org>, Jin Yao <yao.jin@linux.intel.com>,
        "Jiri Olsa" <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>
Subject: RE: [PATCH] perf: increase size of buf in perf_evsel__hists_browse()
Thread-Topic: [PATCH] perf: increase size of buf in perf_evsel__hists_browse()
Thread-Index: AQHWrxgdvZ16XH9dCka7K+36/Ico6qmxkurg
Date:   Sat, 31 Oct 2020 11:27:13 +0000
Message-ID: <5334209cb6fa4a0782029ca7b44c917e@AcuMS.aculab.com>
References: <20201030235431.534417-1-songliubraving@fb.com>
In-Reply-To: <20201030235431.534417-1-songliubraving@fb.com>
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

From: Song Liu
> Sent: 30 October 2020 23:55
> 
> Making perf with gcc-9.1.1 generates the following warning:
> 
>   CC       ui/browsers/hists.o
> ui/browsers/hists.c: In function 'perf_evsel__hists_browse':
> ui/browsers/hists.c:3078:61: error: '%d' directive output may be \
> truncated writing between 1 and 11 bytes into a region of size \
> between 2 and 12 [-Werror=format-truncation=]
> 
>  3078 |       "Max event group index to sort is %d (index from 0 to %d)",
>       |                                                             ^~
> ui/browsers/hists.c:3078:7: note: directive argument in the range [-2147483648, 8]
>  3078 |       "Max event group index to sort is %d (index from 0 to %d)",
>       |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from /usr/include/stdio.h:937,
>                  from ui/browsers/hists.c:5:
> 
> IOW, the string in line 3078 might be too long for buf[] of 64 bytes.
> 
> Fix this by increasing the size of buf[] to 128.

ISTM that something should be unsigned so that the bound check
that puts an upper bound of 8 implies a lower bound.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

