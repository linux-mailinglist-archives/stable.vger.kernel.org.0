Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973B234331E
	for <lists+stable@lfdr.de>; Sun, 21 Mar 2021 16:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhCUPKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Mar 2021 11:10:05 -0400
Received: from mout01.posteo.de ([185.67.36.65]:49879 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230214AbhCUPJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Mar 2021 11:09:36 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 29E3116005C
        for <stable@vger.kernel.org>; Sun, 21 Mar 2021 16:09:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1616339374; bh=lhFd45mIGXuppYqfgZze5IoFnJZ5RSTPVIt6oeO3OVg=;
        h=Date:From:To:Cc:Subject:From;
        b=FdevwaJdxl8mL65jhQv1DQH7IwJJ7QiaLB6OD6G607r5rtRlGo8N8A6M0NUbVlGY3
         BcF8aGweJmAkaEi+VRyBjQrqQX5ENt7E7RoDo+5a5NBkn/nBuAXeEcDiwUOwKGyY4l
         qe9kcw7qoLF36ZIMhvt2GWTpa5HnIOR+PIJ947vKgTXvEB1G0cv+HMI46CS4/YhWDf
         qRQIYQZkX2cGC7zEhIvEixjfpytZgMliu5XvjJQpUS7yqYWQ6fqOjGpY35rkE1n5Kp
         YAhWN5iFeb09f5c3rcCv6efkoXTv0lci5vI7XhMNFNE8iSK8TXncXB1eZHbE50jnvX
         7/FKwRHaS9HaQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4F3LdT38r8z6tmX;
        Sun, 21 Mar 2021 16:09:33 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: quoted-printable
Date:   Sun, 21 Mar 2021 16:09:33 +0100
From:   =?UTF-8?Q?R=C3=B6tti?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
        linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Zachary Zhang <zhangzg@marvell.com>
Subject: Re: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062
 SATA controller
In-Reply-To: <20210319190228.xdejimfdpjch6de4@pali>
References: <20210317225544.fm4oyuujylsxa77b@pali>
 <20210317230355.GA95738@bjorn-Precision-5520>
 <20210319190228.xdejimfdpjch6de4@pali>
Message-ID: <cac9265e1c53638eca1aebe8a18bebc2@posteo.de>
X-Sender: espressobinboardarmbiantempmailaddress@posteo.de
User-Agent: Posteo Webmail
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I organized a T60 Thinkpad, pulled out the Wificard (MiniPCIE) and=20
plugged in the Marvell SATA-Controller card. Good news is that you're=20
right, the DevCap MaxPayload is 128 bytes, so I couldn't reproduce that=20
error on that thinkpad. I tried two different Marvell controller cards.=20
Wierd thing is, that both cards did not sho up in the lspci -nn -vv=20
command. So I'm not sure if these got recognized.

With these patches supplied (@thank you very much Marek & Bj=C3=B6rn) is=20
there a build server I can download a nightly version of armbian I can=20
test for you?
Is there any way I can support?

Thank you very much in advance!

Am 19.03.2021 20:02 schrieb Pali Roh=C3=A1r:
> On Wednesday 17 March 2021 18:03:55 Bjorn Helgaas wrote:
>> On Wed, Mar 17, 2021 at 11:55:44PM +0100, Pali Roh=C3=A1r wrote:
>> > On Wednesday 17 March 2021 17:45:49 Bjorn Helgaas wrote:
>> > > This quirk suggests that there's a hardware defect in the ASMedia
>> > > ASM1062.  But if that's really the case, we should see reports on lo=
ts
>> > > of platforms, and I'm only aware of these two.
>> >
>> > Do you have platform which support MPS of 512 bytes? Because I have no=
t
>> > seen any x86 / Intel PCIe controller with such support on ordinary
>> > laptop and desktop.
>> >
>> > These two (A3720 and CN9130) are the only which has support for it.
>> >
>> > Has somebody else PCIe controller which Root Bridge supports MPS of 51=
2
>> > bytes?
>> >
>> > Maybe they are in servers, but then such "cheap" SATA controllers are
>> > not used in servers. So this is probably reason why nobody else report=
ed
>> > such issue.
>>=20
>> I have no idea.  My laptop only supports 512 (except for an ASMedia
>> USB controller).  If the device advertises it, I would expect the
>> vendor to test it.  Obviously it still could be a device defect.  They
>> should publish an erratum if that's the case so people know to avoid
>> it.  So I would try to get ASMedia to say "no, that's tested and
>> should work" or "oh, sorry, here's an erratum and we'll fix it in the
>> next round."
>=20
> I doubt that ASMedia publish something...
>=20
> But has somebody contact to ASMedia? I can try it.
>=20
> Basically these ASMedia SATA controller chips are present on more
> "noname" mPCIe-form cards and I guess ASMedia is not going to support
> them.
>=20
> Note that we have also tested Marvell PCIe-based SATA controllers which
> support MPS of 512 bytes too and there were no problem with them on
> A3720 nor CN9130.
