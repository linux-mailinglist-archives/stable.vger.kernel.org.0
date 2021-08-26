Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6B53F85FD
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 13:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhHZLB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 07:01:28 -0400
Received: from mout02.posteo.de ([185.67.36.66]:57445 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234228AbhHZLB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 07:01:27 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 570C3240107
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 13:00:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1629975638; bh=Og0Zu2lCzfDI1UBk5doA/K2AA0rwE+SzHGDlHk8hnbI=;
        h=Date:From:To:Subject:From;
        b=dHTjvrG39JvIcolZP5NZDpK3HbAM13OWO6+llwV6qylR/NMFoDx19RRGzBaTn/qHQ
         vAhaUk2TCHr0GHZelqg89q3IEeupSx0d2Cgjs2y/0ek9GroxVTbVydc0oQBbBLd7RW
         Tdut/Q0lSBLV/H3Q2OH8lWaTYDX4+Hh1i436s/mHPvi1VAGKKSxEDl4kbS0FPpVX+n
         fBQPZ/K7wsJYefPR4JNIlMz0OLFfNt7eLfsjfH30Ks7bZ0SR3uQa3y5+Xd8JcXfJrk
         Rde1GyfvI8Qb5QTKxclhfSC/oi84s1tJE1/36Bhii1lVPoInJvTzWwUOX3sZ99t7oz
         79B5+irDjtuwQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4GwKdK4Rljz9rxP;
        Thu, 26 Aug 2021 13:00:37 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 26 Aug 2021 11:00:37 +0000
From:   =?UTF-8?Q?R=C3=B6tti?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
        linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Zachary Zhang <zhangzg@marvell.com>
Subject: Re: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062
 SATA controller
In-Reply-To: <cac9265e1c53638eca1aebe8a18bebc2@posteo.de>
References: <20210317225544.fm4oyuujylsxa77b@pali>
 <20210317230355.GA95738@bjorn-Precision-5520>
 <20210319190228.xdejimfdpjch6de4@pali>
 <cac9265e1c53638eca1aebe8a18bebc2@posteo.de>
Message-ID: <020dd45b71c7d6aaed62570831845ff2@posteo.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I directed the Armbian guys (Werner) to your patch and they included it=20
into their master branch.
So I got to compile an Armbian kernel in order to test the patch in my=20
setup with the EspressoBin Board and the AS-Media SATA-controller chips.

I've tested it and it works flawlessly :-)

Thanks!

Am 21.03.2021 16:09 schrieb R=C3=B6tti:
> I organized a T60 Thinkpad, pulled out the Wificard (MiniPCIE) and
> plugged in the Marvell SATA-Controller card. Good news is that you're
> right, the DevCap MaxPayload is 128 bytes, so I couldn't reproduce
> that error on that thinkpad. I tried two different Marvell controller
> cards. Wierd thing is, that both cards did not sho up in the lspci -nn
> -vv command. So I'm not sure if these got recognized.
>=20
> With these patches supplied (@thank you very much Marek & Bj=C3=B6rn) is
> there a build server I can download a nightly version of armbian I can
> test for you?
> Is there any way I can support?
>=20
> Thank you very much in advance!
>=20
> Am 19.03.2021 20:02 schrieb Pali Roh=C3=A1r:
>> On Wednesday 17 March 2021 18:03:55 Bjorn Helgaas wrote:
>>> On Wed, Mar 17, 2021 at 11:55:44PM +0100, Pali Roh=C3=A1r wrote:
>>> > On Wednesday 17 March 2021 17:45:49 Bjorn Helgaas wrote:
>>> > > This quirk suggests that there's a hardware defect in the ASMedia
>>> > > ASM1062.  But if that's really the case, we should see reports on l=
ots
>>> > > of platforms, and I'm only aware of these two.
>>> >
>>> > Do you have platform which support MPS of 512 bytes? Because I have n=
ot
>>> > seen any x86 / Intel PCIe controller with such support on ordinary
>>> > laptop and desktop.
>>> >
>>> > These two (A3720 and CN9130) are the only which has support for it.
>>> >
>>> > Has somebody else PCIe controller which Root Bridge supports MPS of 5=
12
>>> > bytes?
>>> >
>>> > Maybe they are in servers, but then such "cheap" SATA controllers are
>>> > not used in servers. So this is probably reason why nobody else repor=
ted
>>> > such issue.
>>>=20
>>> I have no idea.  My laptop only supports 512 (except for an ASMedia
>>> USB controller).  If the device advertises it, I would expect the
>>> vendor to test it.  Obviously it still could be a device defect. =20
>>> They
>>> should publish an erratum if that's the case so people know to avoid
>>> it.  So I would try to get ASMedia to say "no, that's tested and
>>> should work" or "oh, sorry, here's an erratum and we'll fix it in the
>>> next round."
>>=20
>> I doubt that ASMedia publish something...
>>=20
>> But has somebody contact to ASMedia? I can try it.
>>=20
>> Basically these ASMedia SATA controller chips are present on more
>> "noname" mPCIe-form cards and I guess ASMedia is not going to support
>> them.
>>=20
>> Note that we have also tested Marvell PCIe-based SATA controllers=20
>> which
>> support MPS of 512 bytes too and there were no problem with them on
>> A3720 nor CN9130.
