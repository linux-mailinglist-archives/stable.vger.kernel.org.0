Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B32427C3
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 15:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfFLNh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 09:37:59 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:44832 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726822AbfFLNh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 09:37:59 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 63715C01C1;
        Wed, 12 Jun 2019 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1560346678; bh=pwJ+bIUg4ZRU+TeAoBcre13vJABWf7ItQBkeSFq80jw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=M1FyFvBcEOuv9D2MnCW4dFKFPlh8wFdwAXlsD9RP044qfIVftcgaKuR1mz52nvIjv
         ZJESMBqgYe6BL4x2+zAX5OqlXMoGG4PuIRmJowBnvbHhqenvEXhca3LPsRQtOuHc0B
         zT/n0sq7K+Bj6afc6XL0QkJNfKQ2PuIOlz0pwPfSAzMXcWL/tfpfu5QwECrGj0Rhbm
         0Nak55zAKSy/619bKi/ESJ16bSkKk5clNbM1nck+ou2u7RSc9HMayaReGQ7hVMOaUX
         m6+3xWM/0NKv9tN3griYs/+gTQjp6ptqNSz4Kt2GuulYn0tcYY2HaxTNIkvUJFiogy
         QI3UI10YlGUmA==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id DD8FAA0093;
        Wed, 12 Jun 2019 13:37:56 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 12 Jun 2019 06:37:56 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 12 Jun 2019 15:37:54 +0200
From:   Vitor Soares <Vitor.Soares@synopsys.com>
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Vitor Soares <Vitor.Soares@synopsys.com>
CC:     "linux-i3c@lists.infradead.org" <linux-i3c@lists.infradead.org>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 1/3] i3c: fix i2c and i3c scl rate by bus mode
Thread-Topic: [PATCH v3 1/3] i3c: fix i2c and i3c scl rate by bus mode
Thread-Index: AQHVIF7tXczCemTY50qlGHD151vpyqaXajaAgABfUkD///qegIAAOxPw
Date:   Wed, 12 Jun 2019 13:37:53 +0000
Message-ID: <13D59CF9CEBAF94592A12E8AE55501350AABECD8@DE02WEMBXB.internal.synopsys.com>
References: <cover.1560261604.git.vitor.soares@synopsys.com>
        <b39923bda3625a5c6874755ae81cdfe85fb5abef.1560261604.git.vitor.soares@synopsys.com>
        <20190612081533.2cf9e12a@collabora.com>
        <13D59CF9CEBAF94592A12E8AE55501350AABEC91@DE02WEMBXB.internal.synopsys.com>
 <20190612133727.48f85060@collabora.com>
In-Reply-To: <20190612133727.48f85060@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc29hcmVzXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctNDUzNGUzNmQtOGQxNy0xMWU5LTgyNDYtYjgwOGNm?=
 =?us-ascii?Q?NTlkN2ZjXGFtZS10ZXN0XDQ1MzRlMzZlLThkMTctMTFlOS04MjQ2LWI4MDhj?=
 =?us-ascii?Q?ZjU5ZDdmY2JvZHkudHh0IiBzej0iNzYzOSIgdD0iMTMyMDQ4MjAyNzI0NTIy?=
 =?us-ascii?Q?MjI3IiBoPSJ0c1NIdFdLc21mQ1ZSQUdBYkNyZ3Q1aW5abUE9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFCUUpBQUR6?=
 =?us-ascii?Q?dUo4SUpDSFZBYUlNdjB2YUhaSGtvZ3kvUzlvZGtlUU9BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFDa0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQVZ6ZGhHZ0FBQUFBQUFBQUFBQUFBQUo0QUFBQm1BR2tBYmdC?=
 =?us-ascii?Q?aEFHNEFZd0JsQUY4QWNBQnNBR0VBYmdCdUFHa0FiZ0JuQUY4QWR3QmhBSFFB?=
 =?us-ascii?Q?WlFCeUFHMEFZUUJ5QUdzQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZQWJ3QjFBRzRBWkFCeUFIa0FYd0J3?=
 =?us-ascii?Q?QUdFQWNnQjBBRzRBWlFCeUFITUFYd0JuQUdZQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFaZ0J2QUhVQWJnQmtBSElBZVFCZkFIQUFZUUJ5QUhRQWJnQmxB?=
 =?us-ascii?Q?SElBY3dCZkFITUFZUUJ0QUhNQWRRQnVBR2NBWHdCakFHOEFiZ0JtQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCbUFHOEFk?=
 =?us-ascii?Q?UUJ1QUdRQWNnQjVBRjhBY0FCaEFISUFkQUJ1QUdVQWNnQnpBRjhBY3dCaEFH?=
 =?us-ascii?Q?MEFjd0IxQUc0QVp3QmZBSElBWlFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1lBYndCMUFHNEFaQUJ5QUhrQVh3?=
 =?us-ascii?Q?QndBR0VBY2dCMEFHNEFaUUJ5QUhNQVh3QnpBRzBBYVFCakFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVpnQnZBSFVBYmdCa0FISUFlUUJmQUhBQVlRQnlBSFFBYmdC?=
 =?us-ascii?Q?bEFISUFjd0JmQUhNQWRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJtQUc4?=
 =?us-ascii?Q?QWRRQnVBR1FBY2dCNUFGOEFjQUJoQUhJQWRBQnVBR1VBY2dCekFGOEFkQUJ6?=
 =?us-ascii?Q?QUcwQVl3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHWUFid0IxQUc0QVpBQnlBSGtB?=
 =?us-ascii?Q?WHdCd0FHRUFjZ0IwQUc0QVpRQnlBSE1BWHdCMUFHMEFZd0FBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFD?=
 =?us-ascii?Q?QUFBQUFBQ2VBQUFBWndCMEFITUFYd0J3QUhJQWJ3QmtBSFVBWXdCMEFGOEFk?=
 =?us-ascii?Q?QUJ5QUdFQWFRQnVBR2tBYmdCbkFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnpB?=
 =?us-ascii?Q?R0VBYkFCbEFITUFYd0JoQUdNQVl3QnZBSFVBYmdCMEFGOEFjQUJzQUdFQWJn?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUhNQVlRQnNBR1VBY3dCZkFI?=
 =?us-ascii?Q?RUFkUUJ2QUhRQVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFB?=
 =?us-ascii?Q?QUNBQUFBQUFDZUFBQUFjd0J1QUhBQWN3QmZBR3dBYVFCakFHVUFiZ0J6QUdV?=
 =?us-ascii?Q?QVh3QjBBR1VBY2dCdEFGOEFNUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFC?=
 =?us-ascii?Q?ekFHNEFjQUJ6QUY4QWJBQnBBR01BWlFCdUFITUFaUUJmQUhRQVpRQnlBRzBB?=
 =?us-ascii?Q?WHdCekFIUUFkUUJrQUdVQWJnQjBBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBSFlBWndCZkFHc0FaUUI1?=
 =?us-ascii?Q?QUhjQWJ3QnlBR1FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFB?=
 =?us-ascii?Q?QUFBQ0FBQUFBQUE9Ii8+PC9tZXRhPg=3D=3D?=
x-originating-ip: [10.107.19.137]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>
Date: Wed, Jun 12, 2019 at 12:37:27

> On Wed, 12 Jun 2019 11:16:34 +0000
> Vitor Soares <Vitor.Soares@synopsys.com> wrote:
>=20
> > From: Boris Brezillon <boris.brezillon@collabora.com>
> > Date: Wed, Jun 12, 2019 at 07:15:33
> >=20
> > > On Tue, 11 Jun 2019 16:06:43 +0200
> > > Vitor Soares <Vitor.Soares@synopsys.com> wrote:
> > >  =20
> > > > Currently the I3C framework limits SCL frequency to FM speed when
> > > > dealing with a mixed slow bus, even if all I2C devices are FM+ capa=
ble.
> > > >=20
> > > > The core was also not accounting for I3C speed limitations when
> > > > operating in mixed slow mode and was erroneously using FM+ speed as=
 the
> > > > max I2C speed when operating in mixed fast mode.
> > > >=20
> > > > Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
> > > > Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
> > > > Cc: Boris Brezillon <bbrezillon@kernel.org>
> > > > Cc: <stable@vger.kernel.org>
> > > > Cc: <linux-kernel@vger.kernel.org>
> > > > ---
> > > > Changes in v3:
> > > >   Change dev_warn() to dev_dbg()
> > > >=20
> > > > Changes in v2:
> > > >   Enhance commit message
> > > >   Add dev_warn() in case user-defined i2c rate doesn't match LVR co=
nstraint
> > > >   Add dev_warn() in case user-defined i3c rate lower than i2c rate
> > > >=20
> > > >  drivers/i3c/master.c | 61 ++++++++++++++++++++++++++++++++++++++++=
+-----------
> > > >  1 file changed, 48 insertions(+), 13 deletions(-)
> > > >=20
> > > > diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
> > > > index 5f4bd52..f8e580e 100644
> > > > --- a/drivers/i3c/master.c
> > > > +++ b/drivers/i3c/master.c
> > > > @@ -91,6 +91,12 @@ void i3c_bus_normaluse_unlock(struct i3c_bus *bu=
s)
> > > >  	up_read(&bus->lock);
> > > >  }
> > > > =20
> > > > +static struct i3c_master_controller *
> > > > +i3c_bus_to_i3c_master(struct i3c_bus *i3cbus)
> > > > +{
> > > > +	return container_of(i3cbus, struct i3c_master_controller, bus);
> > > > +}
> > > > +
> > > >  static struct i3c_master_controller *dev_to_i3cmaster(struct devic=
e *dev)
> > > >  {
> > > >  	return container_of(dev, struct i3c_master_controller, dev);
> > > > @@ -565,20 +571,48 @@ static const struct device_type i3c_masterdev=
_type =3D {
> > > >  	.groups	=3D i3c_masterdev_groups,
> > > >  };
> > > > =20
> > > > -int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mod=
e)
> > > > +int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mod=
e,
> > > > +		     unsigned long max_i2c_scl_rate)
> > > >  {
> > > > -	i3cbus->mode =3D mode;
> > > > =20
> > > > -	if (!i3cbus->scl_rate.i3c)
> > > > -		i3cbus->scl_rate.i3c =3D I3C_BUS_TYP_I3C_SCL_RATE;
> > > > +	struct i3c_master_controller *master =3D i3c_bus_to_i3c_master(i3=
cbus);
> > > > =20
> > > > -	if (!i3cbus->scl_rate.i2c) {
> > > > -		if (i3cbus->mode =3D=3D I3C_BUS_MODE_MIXED_SLOW)
> > > > -			i3cbus->scl_rate.i2c =3D I3C_BUS_I2C_FM_SCL_RATE;
> > > > -		else
> > > > -			i3cbus->scl_rate.i2c =3D I3C_BUS_I2C_FM_PLUS_SCL_RATE;
> > > > +	i3cbus->mode =3D mode;
> > > > +
> > > > +	switch (i3cbus->mode) {
> > > > +	case I3C_BUS_MODE_PURE:
> > > > +		if (!i3cbus->scl_rate.i3c)
> > > > +			i3cbus->scl_rate.i3c =3D I3C_BUS_TYP_I3C_SCL_RATE;
> > > > +		break;
> > > > +	case I3C_BUS_MODE_MIXED_FAST:
> > > > +		if (!i3cbus->scl_rate.i3c)
> > > > +			i3cbus->scl_rate.i3c =3D I3C_BUS_TYP_I3C_SCL_RATE;
> > > > +		if (!i3cbus->scl_rate.i2c)
> > > > +			i3cbus->scl_rate.i2c =3D max_i2c_scl_rate;
> > > > +		break;
> > > > +	case I3C_BUS_MODE_MIXED_SLOW:
> > > > +		if (!i3cbus->scl_rate.i2c)
> > > > +			i3cbus->scl_rate.i2c =3D max_i2c_scl_rate;
> > > > +		if (!i3cbus->scl_rate.i3c ||
> > > > +		    i3cbus->scl_rate.i3c > i3cbus->scl_rate.i2c)
> > > > +			i3cbus->scl_rate.i3c =3D i3cbus->scl_rate.i2c;
> > > > +		break;
> > > > +	default:
> > > > +		return -EINVAL;
> > > >  	}
> > > > =20
> > > > +	if (i3cbus->scl_rate.i3c < i3cbus->scl_rate.i2c)
> > > > +		dev_dbg(&master->dev,
> > > > +			"i3c-scl-hz=3D%ld lower than i2c-scl-hz=3D%ld\n",
> > > > +			i3cbus->scl_rate.i3c, i3cbus->scl_rate.i2c);
> > > > +
> > > > +	if (i3cbus->scl_rate.i2c !=3D I3C_BUS_I2C_FM_SCL_RATE &&
> > > > +	    i3cbus->scl_rate.i2c !=3D I3C_BUS_I2C_FM_PLUS_SCL_RATE &&
> > > > +	    i3cbus->mode !=3D I3C_BUS_MODE_PURE)
> > > > +		dev_dbg(&master->dev,
> > > > +			"i2c-scl-hz=3D%ld not defined according MIPI I3C spec\n",
> > > > +			i3cbus->scl_rate.i2c);
> > > > + =20
> > >=20
> > > Again, that's not what I suggested, so I'll write it down:
> > >=20
> > > 	dev_dbg(&master->dev, "i2c-scl =3D %ld Hz i3c-scl =3D %ld Hz\n",
> > > 		i3cbus->scl_rate.i2c, i3cbus->scl_rate.i3c);
> > >  =20
> >=20
> > I'm not ok with that change. The reasons are:
> >   i3cbus->scl_rate.i3c < i3cbus->scl_rate.i2c is an abnormal use case. =
As=20
> > discuss early it can be cause by a wrong DT definition or just for=20
> > testing purposes.
>=20
> Is it buggy, and if it is, what are the symptoms? And I'm not talking
> about slow transfers here. Also, note that forcing the I2C/I3C rate
> through the DT already means you want to tweak the bus speed (either
> for debugging purposes or because slowing things down is needed to fix
> a HW bug).

Does it need to be buggy to inform the user of such inconsistence?

>=20
> >=20
> >   i3cbus->scl_rate.i2c !=3D I3C_BUS_I2C_FM_SCL_RATE && i3cbus->scl_rate=
.i2c=20
> > !=3D I3C_BUS_I2C_FM_PLUS_SCL_RATE, the MIPI I3C Spec v1.0 clearly says =
that=20
> > all I2C devices on the bus shall have a LVR register and thus support F=
M=20
> > or FM+ modes.
>=20
> Yet, you might want to apply a lower I2C freq, and this sounds like a
> valid case that doesn't deserve a dev_warn().

I already said that I'm ok to change the dev_warn(), you just have to=20
tell me what is the best message level to use.

>=20
> > By  definition a FM bus works at 400kHz and a FM+ bus 1MHz.
> > And for slaves, a FM device works up to 400kHz and a FM+ device works u=
p=20
> > to 1MHz respectively.
>=20
> *up to*, that's the important thing to keep in mind. There's no problem
> driving the SCL signal at a lower freq.

We already know that a FM or FM+ supports lower frequencies due backyard=20
capabilities.

>=20
> >=20
> > Apart of that, if the I2C device support you can use a custom higher or=
=20
> > lower rate, yet not defined according MIPI I3C spec.
>=20
> I'm not going to have this discussion again, sorry. I think I gave
> enough arguments to explain why having an I2C SLC rate that's slower
> than what I2C devices support is fine.

It is clear to me that the I2C devices on I3C bus shall support FM or=20
FM+.
If not they don't follow the MIPI I3C spec and for that reason I prefer=20
to inform the user.

>=20
> >=20
> > > dev_dbg() is not printed by default, so it's just fine to have a trac=
e
> > > that prints the I3C and I2C rate unconditionally. =20
> >=20
> > I'm ok to change the way that user is notified and I think that is here=
=20
> > the problem.
> > Maybe the best is to change the first dev_dbg() to dev_warn() and the=20
> > second dev_info().
>=20
> Same here. I'm fine having a dev_warn() when the rate is higher than
> what's supported by devices present on the bus (because that case is
> buggy), but not when it's lower and still in the valid range.

Please take some time to analyze it again, my concern is only to inform=20
the user about inconsistencies (forced or not) with the I3C specification=20
and I already agreed to change the message levels.

Best regards,
Vitor Soares
