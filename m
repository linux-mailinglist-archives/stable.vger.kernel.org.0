Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1921315A86A
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 12:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgBLL4M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 12 Feb 2020 06:56:12 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:48910 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728108AbgBLL4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 06:56:12 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-27-6s1ADMqVNEa4MBw75WIRIA-1; Wed, 12 Feb 2020 11:56:07 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 12 Feb 2020 11:56:06 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 12 Feb 2020 11:56:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Robin Murphy' <robin.murphy@arm.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Roger Quadros <rogerq@ti.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "vigneshr@ti.com" <vigneshr@ti.com>,
        "nsekhar@ti.com" <nsekhar@ti.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        =?iso-8859-1?Q?P=E9ter_Ujfalusi?= <peter.ujfalusi@ti.com>
Subject: RE: [PATCH] ata: ahci_platform: add 32-bit quirk for dwc-ahci
Thread-Topic: [PATCH] ata: ahci_platform: add 32-bit quirk for dwc-ahci
Thread-Index: AQHV4Zmb/DqkVgCd3ECs486jc5D8CqgXcftg
Date:   Wed, 12 Feb 2020 11:56:06 +0000
Message-ID: <2a527d21087b4f959c7f95895d70b669@AcuMS.aculab.com>
References: <20200206111728.6703-1-rogerq@ti.com>
 <d3a80407-a40a-c9e4-830f-138cfe9b163c@redhat.com>
 <1c3ec10c-8505-a067-d51d-667f47d8d55b@ti.com>
 <37c3ca6a-dc64-9ce9-e43b-03b12da6325e@redhat.com>
 <7e5f503f-03df-29d0-baae-af12d0af6f61@arm.com>
In-Reply-To: <7e5f503f-03df-29d0-baae-af12d0af6f61@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 6s1ADMqVNEa4MBw75WIRIA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy
> Sent: 12 February 2020 11:43
...
> If the device *is* inherently 64-bit capable, then setting 64-bit masks
> in the driver is correct - if a 64-bit IP block happens to have been
> integrated with only 32 address bits wired up, but the system has memory
> above the 32-bit boundary, then that should be described via
> "dma-ranges", which should then end up being used to further constrain
> the device masks internally to the DMA API.

Given how often this happens (please can I shoot some more
hardware engineers - he says while compiling some VHDL)
is it possible to allocate some memory pages that are
aliases if the address bits over 31 are ignored?

Then (at least some) drivers could to a run-time probe
reading to the high address and checking the data didn't
appear in the low address.

Only one such set of pages is needed - access can be locked.
But they'd need to be reserved early on.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

