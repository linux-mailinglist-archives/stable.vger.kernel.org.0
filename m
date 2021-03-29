Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1FF34D762
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhC2SgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:36:04 -0400
Received: from a27-65.smtp-out.us-west-2.amazonses.com ([54.240.27.65]:53353
        "EHLO a27-65.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230506AbhC2Sfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 14:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zzmz6pik4loqlrvo6grmnyszsx3fszus; d=nh6z.net; t=1617042938;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
        bh=sSeroXM5SYz8wV9FNENIRsjQP4SR64aOo7kXZnF2B0k=;
        b=YVG4rh4HmuHqR3PT36Dg5lnRQyGxu6BTqMFCZnwieI/23ZWG0g304NMbRrqjiazA
        J2/mI5CEdtGxWbe57WQmGusOTbc6+OloB19XAru8AkRpojyPverxeUyw5yM9Fpuqz9Q
        cRkd7Ik6h4oi2+ZK7Ke3NVClTcBoqwJT1er7P+cs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1617042938;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
        bh=sSeroXM5SYz8wV9FNENIRsjQP4SR64aOo7kXZnF2B0k=;
        b=ODjoI2qD1sSsdaPQ9q4HvxjwqkKvwUqJ2DT17eDnBYTSwj9Znf8arAmqD7k061S5
        kOi/d8c02EDgms5SADPAnDaXLza9KS9E7k3Zd2jIKeFmNdXnxzH1sf1O3z4rjd5WLMt
        7cLEiJgkIaP90AEyiTy5VeHglR79Xi9TOkJAuan4=
Subject: Re: [PATCH] sc16is7xx: Defer probe if device read fails
From:   =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>
To:     =?UTF-8?Q?Greg_KH?= <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?Q?linux-serial=40vger=2Ekernel=2Eorg?= 
        <linux-serial@vger.kernel.org>,
        =?UTF-8?Q?team=40nwdigitalradio=2Ecom?= <team@nwdigitalradio.com>,
        =?UTF-8?Q?stable=40vger=2Ekernel=2Eorg?= <stable@vger.kernel.org>
Date:   Mon, 29 Mar 2021 18:35:38 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YGIZ4bOX/4DF0KQ4@kroah.com>
References: <20210329154013.408967-1-nh6z@nh6z.net> 
 <010101787ea4d8c4-08608e8d-9755-4a88-9908-af95233a4f8e-000000@us-west-2.amazonses.com> 
 <YGIZ4bOX/4DF0KQ4@kroah.com> <D3421B6F-AD12-4B5E-AF02-9EFF80E79473@nh6z.net>
X-Priority: 3 (Normal)
X-Mailer: Amazon WorkMail
Thread-Index: AQHXJLHb+f11tj/5RVCWuJdkpEj6bAAFgjFTAAYdOGk=
Thread-Topic: [PATCH] sc16is7xx: Defer probe if device read fails
X-Original-Mailer: Apple Mail (2.3654.40.0.2.32)
X-Wm-Sent-Timestamp: 1617042937
Message-ID: <010101787f451ae7-57a585bf-f3c4-447c-bc86-077799736766-000000@us-west-2.amazonses.com>
X-SES-Outgoing: 2021.03.29-54.240.27.65
Feedback-ID: 1.us-west-2.An468LAV0jCjQDrDLvlZjeAthld7qrhZr+vow8irkvU=:AmazonSES
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=0D=0A=0D=0A> On Mar 29, 2021, at 11:18 AM, Greg KH <gregkh@linuxfoundati=
on.org> wrote:=0D=0A>=20=0D=0A> On Mon, Mar 29, 2021 at 03:40:35PM +0000,=
 Annaliese McDermond wrote:=0D=0A>> A test was added to the probe functio=
n to ensure the device was=0D=0A>> actually connected and working before =
successfully completing a=0D=0A>> probe.  If the device was actually ther=
e, but the I2C bus was not=0D=0A>> ready yet for whatever reason, the pro=
be fails permanently.=0D=0A>>=20=0D=0A>> Change the probe so that we defe=
r the probe on a regmap read=0D=0A>> failure so that we try the probe aga=
in when the dependent drivers=0D=0A>> are potentially loaded.  This shoul=
d not affect the case where the=0D=0A>> device truly isn't present becaus=
e the probe will never successfully=0D=0A>> complete.=0D=0A>>=20=0D=0A>> =
Fixes: 2aa916e ("sc16is7xx: Read the LSR register for basic device presen=
ce check")=0D=0A>=20=0D=0A> Please use the full 12 characters of the git =
commit id, as the=0D=0A> documentation asks for.  This should be:=0D=0A>=20=
=0D=0A> Fixes: 2aa916e67db3 ("sc16is7xx: Read the LSR register for basic =
device presence check")=0D=0A=0D=0AI=E2=80=99m sorry, I must have missed =
the section specifying that, and since I saw commits like=0D=0A05962f95f9=
ac specifying 7 characters in their =E2=80=9Cfixes=E2=80=9D line, I made =
the assumption that=0D=0Athis was the correct length.=0D=0A=0D=0AWould yo=
u like me to post a v2 patch with the hash changed=3F=0D=0A=0D=0A>> Cc: s=
table@vger.kernel.org=0D=0A>> Signed-off-by: Annaliese McDermond <nh6z@nh=
6z.net>=0D=0A>> ---=0D=0A>> drivers/tty/serial/sc16is7xx.c | 2 +-=0D=0A>>=
 1 file changed, 1 insertion(+), 1 deletion(-)=0D=0A>>=20=0D=0A>> diff --=
git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c=0D=0A=
>> index f86ec2d2635b..9adb8362578c 100644=0D=0A>> --- a/drivers/tty/seri=
al/sc16is7xx.c=0D=0A>> +++ b/drivers/tty/serial/sc16is7xx.c=0D=0A>> @@ -1=
196,7 +1196,7 @@ static int sc16is7xx_probe(struct device *dev,=0D=0A>> =09=
ret =3D regmap_read(regmap,=0D=0A>> =09=09=09  SC16IS7XX_LSR_REG << SC16I=
S7XX_REG_SHIFT, &val);=0D=0A>> =09if (ret < 0)=0D=0A>> -=09=09return ret;=
=0D=0A>> +=09=09return -EPROBE_DEFER;=0D=0A>>=20=0D=0A>> =09/* Alloc port=
 structure */=0D=0A>> =09s =3D devm_kzalloc(dev, struct_size(s, p, devtyp=
e->nr_uart), GFP_KERNEL);=0D=0A>> --=20=0D=0A>> 2.27.0=0D=0A>=20=0D=0A> A=
ny reason you did not cc: the tty maintainer with this change=3F=0D=0A=0D=
=0ANone other than I believed =E2=80=9Cserial drivers=E2=80=9D to be more=
 specific than =E2=80=9Ctty layer=E2=80=9D when=0D=0Alooking at the maint=
ainers.  I=E2=80=99m happy to Cc Jiri if needed.=0D=0A=0D=0A>=20=0D=0A> t=
hanks,=0D=0A>=20=0D=0A> greg k-h=0D=0A=0D=0A-- Anna
