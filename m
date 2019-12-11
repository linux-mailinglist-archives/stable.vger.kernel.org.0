Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E39C11AE10
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbfLKOoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:44:14 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:10215 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfLKOoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 09:44:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576075452;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=aAEdKVGDi6t7TbiIGPCbqihfDuomUSlzL1Pc5B3mhFU=;
        b=KcvpQaHJiFuVky0ZWMu+L5s+OjvytQWqTwSoBJ6RelkHsNjWyebAzL/szUpXsquXl8
        4pquekWysrbAB5+squ1rjoAtxjoh8NOqaQvZqk/zYHYjZXiqTeDAsrhmDs6/jKhpUFW0
        72WT9eOZmTp/2LtErNYDnuD4Mcy+odJwAnCrzPU/Fi0gNRP0HabczU4dNsp+A5ezknQR
        h43OI456SIEzRg+jbTYuvltsNxAq9IWewskPMXOZg5+/KGYGfe9CnJNuTS1kCY16v81I
        mICY/h6/JsVlUdLl4QWhknPqMoa7hlPv/0+MJX5Jiw3U7ugxjQUPkOtZS6nnJENw1mrM
        u28w==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrvwDOutHk="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.0.4 DYNA|AUTH)
        with ESMTPSA id Q0b574vBBEiB04V
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Wed, 11 Dec 2019 15:44:11 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: WTF: patch "[PATCH] net: wireless: ti: wl1251 add device tree support" was seriously submitted to be applied to the 5.4-stable tree?
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20191211142448.GA605616@kroah.com>
Date:   Wed, 11 Dec 2019 15:44:11 +0100
Cc:     kvalo@codeaurora.org, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4B4FDCC1-F8D1-4DA9-8A6F-8E2B1DF27E93@goldelico.com>
References: <1576073193178125@kroah.com> <8B77E722-80C2-4607-8519-AC36CC42519C@goldelico.com> <20191211142448.GA605616@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 11.12.2019 um 15:24 schrieb Greg KH <gregkh@linuxfoundation.org>:
>=20
> On Wed, Dec 11, 2019 at 03:19:19PM +0100, H. Nikolaus Schaller wrote:
>> Hi Greg,
>> I have checked with Documentation/process/stable-kernel-rules.rst but =
not found out
>> what is failing.
>>=20
>> Basically this belongs to a series to fix a bug
>>=20
>> 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting =
DMA channel")
>>=20
>> that exists since v4.7 and has been hidden by patches which came into =
the kernel over
>> the time.
>=20
> I do not understand at all.
>=20
> What does tagging all of these random wifi driver commits with cc:
> stable have to do with an old mmc commit from 4.7-rc1?

v4.7 received the commit ("mmc: omap_hsmmc: Use dma_request_chan() for =
requesting DMA channel").

This commit itself is not bad but has a bad side-effect that it breaks =
the device tree
and platform quirks of the wl1251 connected to mmc3 port of the =
OpenPandora.

The reason turned out to be because it now requires a device tree record =
for the mmc port
while the v4.7 status was to have a mmc port created by a platform quirk =
- without scanning
the DT.

To be able to fix that we have to
* modify the device tree
* remove the platform quirk for pandora and replace by DT based =
instantiation of the mmc port
* make sure that what the platform quirk does is still done in the mmc =
subsystem
* fix some assumptions introduced by later patches which make the device =
non-detectable

The only alternative I can imagine would be to revert "mmc: omap_hsmmc: =
Use dma_request_chan() for requesting DMA channel".

This would fix WiFi for OpenPandora. But - besides you can't simply git =
revert any more - it
would require fixing much more subsystems than omap_hsmmc + mmc + wl1251 =
+ Pandora device tree.

Yes, it is unfortunate that nobody did care about this bug (although =
known) before I
recently did a git bisect to identify this commit. So it got buried =
under a thick layer
of kernel patches so that getting back a working solution touches areas =
outside the omap_hsmmc
driver.

Does this better explain what the rationale is?

BR and thanks,
Nikolaus Schaller=
