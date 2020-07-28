Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86A2309B2
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 14:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgG1MNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 08:13:16 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:43547 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbgG1MNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 08:13:16 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4BGFtw4DS3zMvj4;
        Tue, 28 Jul 2020 14:13:12 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4BGFtM6DLyz2xbN;
        Tue, 28 Jul 2020 14:12:43 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.29) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 28 Jul
 2020 14:03:31 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     David Laight <David.Laight@aculab.com>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] eeprom: at25: set minimum read/write access stride to 1
Date:   Tue, 28 Jul 2020 14:03:30 +0200
Message-ID: <2379124.UCELOXW4Ax@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <02cb3be60abf4a54affe239009c6e157@AcuMS.aculab.com>
References: <20200728092959.24600-1-ceggers@arri.de> <2225645.EMaFvj1lSc@n95hx1g2> <02cb3be60abf4a54affe239009c6e157@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.29]
X-RMX-ID: 20200728-141253-4BGFtM6DLyz2xbN-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, 28 July 2020, 13:20:15 CEST, David Laight wrote:
> From: Christian Eggers
> 
> > &spi {
> >     ....
> >     fram: fram@0 {
> >     ...
> >         mac_address_fec2: mac-address@126 {
> >             reg = <0x126 6>;
> >         };
> >     ...
> >     };
> > };
> 
> 
> Hmmmm.... the 'stride' only constrains the alignment of 'cells'.
> (ie address ranges from the device tree.)

My mac-address is not aligned to 4 bytes...

> It looks as though you can open the entire NVMEM device and
> then do reads from byte offsets.
> The 'stride' and 'word_size' are then not checked!

When I set back the stride to 4, I get the following errors:
[    6.998788] 000: nvmem spi0.00: cell mac-address unaligned to nvmem stride 4
[    6.998902] 000: at25: probe of spi0.0 failed with error -22
...
[    7.146454] 000: fec 20b4000.ethernet: Invalid MAC address: 00:00:00:00:00:00
[    7.146480] 000: fec 20b4000.ethernet: Using random MAC address: 6e:9d:37:49:6d:15

> Actually it might be that before 01973a01f9ec3 byte aligned
> 'cells' were allowed.

I use linux-5.4.x (latest), the mentioned patch has been included long time ago.

regards
Christian



