Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431482F185C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388816AbhAKOdR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 11 Jan 2021 09:33:17 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52331 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388801AbhAKOdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 09:33:16 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-158-SO1OyShiOvaxZ03HwLl3PQ-1; Mon, 11 Jan 2021 14:31:37 +0000
X-MC-Unique: SO1OyShiOvaxZ03HwLl3PQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 11 Jan 2021 14:31:36 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 11 Jan 2021 14:31:36 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Mikko Perttunen' <mperttunen@nvidia.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "digetx@gmail.com" <digetx@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "wsa@kernel.org" <wsa@kernel.org>
CC:     "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] i2c: tegra: Wait for config load atomically while in ISR
Thread-Topic: [PATCH] i2c: tegra: Wait for config load atomically while in ISR
Thread-Index: AQHW6CIcSfsKH+/ghEGIVUc6PkdaV6oifElA
Date:   Mon, 11 Jan 2021 14:31:36 +0000
Message-ID: <a0b0f224c2864b80a5bac53646d67daf@AcuMS.aculab.com>
References: <20210111135547.3613092-1-mperttunen@nvidia.com>
In-Reply-To: <20210111135547.3613092-1-mperttunen@nvidia.com>
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

From: Mikko Perttunen
> Sent: 11 January 2021 13:56
> 
> Upon a communication error, the interrupt handler can call
> tegra_i2c_disable_packet_mode. This causes a sleeping poll to happen
> unless the current transaction was marked atomic. Since
> tegra_i2c_disable_packet_mode is only called from the interrupt path,
> make it use atomic waiting always.

Spin-waiting in an ISR for anything that it makes sense to do
a sleep-wait for at other times is badly broken design.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

