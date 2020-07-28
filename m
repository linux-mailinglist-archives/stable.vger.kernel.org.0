Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9D92307B1
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 12:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgG1Kan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 06:30:43 -0400
Received: from mailout09.rmx.de ([94.199.88.74]:45589 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728547AbgG1Kan (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 06:30:43 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4BGCcb49C6zbmFY;
        Tue, 28 Jul 2020 12:30:39 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4BGCcD6VGSz2TTNR;
        Tue, 28 Jul 2020 12:30:20 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 28 Jul
 2020 12:30:14 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     David Laight <David.Laight@aculab.com>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] eeprom: at25: set minimum read/write access stride to 1
Date:   Tue, 28 Jul 2020 12:30:13 +0200
Message-ID: <2225645.EMaFvj1lSc@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <a65b01608fb34c5c8782b301c2e0cabc@AcuMS.aculab.com>
References: <20200728092959.24600-1-ceggers@arri.de> <a65b01608fb34c5c8782b301c2e0cabc@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20200728-123024-4BGCcD6VGSz2TTNR-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, 28 July 2020, 11:52:05 CEST, David Laight wrote:
> From: Christian Eggers
> 
> > Sent: 28 July 2020 10:30
> > 
> > SPI eeproms are addressed by byte.
> 
> They also support multi-byte writes - possibly with alignment
> restrictions.
> So forcing 4-byte writes (at aligned addresses) would typically
> speed up writes by a factor of 4 over byte writes.
> 
> So does this fix a problem?
> If so what.
I use the nvmem-cells property for getting the MAC-Address out of the eeprom 
(actually an FRAM in my case).

&spi {
    ....
    fram: fram@0 {
    ...
        mac_address_fec2: mac-address@126 {
            reg = <0x126 6>;
        };
    ...
    };
};

&fec2 {
    ...
    nvmem-cells = <&mac_address_fec2>;
    nvmem-cell-names = "mac-address";
    ...
};

As the address of the MAC is not aligned to 4 bytes,
reading the MAC from FRAM fails.

> So setting the 'stride' to 4 may be a compromise.
> Looking at some code that writes the EPCQ for Altera FPGA
> (which I think is just SPI) it does aligned 256 byte writes.
> The long writes (and the 4-bit physical interface) are needed
> to get the write times down to a sensible value.
I do not understand why a minimum read/write stride of 1 would affect 
performance. It is fully up to the user of the eeprom, how much data is read/
written at once. Of course it would not be economical only to read/write one 
byte at a time.

For reading data, there should be no difference whether the access is aligned 
to a particular address. For writing, data is usually organized in "write 
pages". For (I2C) eeproms I've used, the write page size is typically 32 
bytes. But his is handled separately by the "pagesize" property.

Is there any benefit at all if the stride size is set > 1?


> 
> 	David
> 
regards
Christian



