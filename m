Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E215F423D6
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 13:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfFLLRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 07:17:10 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:38690 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725681AbfFLLRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 07:17:09 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E1522C219F;
        Wed, 12 Jun 2019 11:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1560338229; bh=MgO1bCwTyZhK5DHVoaxM5GS/xjDRbELuQhJKQkJgSEo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=E+blSl1+ItvoHyQZSgtYRvRXpBLIs8FSA88M6GV8mFIKvOOFUlGJiQ/MWfGIz0u6q
         00dtbrvIeVPlR6Ob/Bd72fRT2WeLK8dPnW86zt2jU2IjhHfjWIVkSzfjNFQ9VZnCTb
         lQyFWNqWkTehWx7IuP4cW9CMSkuC38ci3HOSV6mIEH6Ge7t5zJLIk+0E1GnMA2zeum
         QFGZDEVAePOaRiLbZ4v892vaB8xJU+Bf85pcS17aJp3YES8qtib18YqUmQBv5iwrdL
         yB0P8/6hqbRLdSWtAh9DbOJHifXDRdxkVhbPZK9IGV4wMk2Xa3/87mN6FoFPf7TqyM
         oiXTJVGp9Asfg==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8368FA009B;
        Wed, 12 Jun 2019 11:17:08 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 12 Jun 2019 04:16:37 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 12 Jun 2019 13:16:35 +0200
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
Thread-Index: AQHVIF7tXczCemTY50qlGHD151vpyqaXajaAgABfUkA=
Date:   Wed, 12 Jun 2019 11:16:34 +0000
Message-ID: <13D59CF9CEBAF94592A12E8AE55501350AABEC91@DE02WEMBXB.internal.synopsys.com>
References: <cover.1560261604.git.vitor.soares@synopsys.com>
        <b39923bda3625a5c6874755ae81cdfe85fb5abef.1560261604.git.vitor.soares@synopsys.com>
 <20190612081533.2cf9e12a@collabora.com>
In-Reply-To: <20190612081533.2cf9e12a@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc29hcmVzXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctODY3YTBiYTktOGQwMy0xMWU5LTgyNDYtYjgwOGNm?=
 =?us-ascii?Q?NTlkN2ZjXGFtZS10ZXN0XDg2N2EwYmFhLThkMDMtMTFlOS04MjQ2LWI4MDhj?=
 =?us-ascii?Q?ZjU5ZDdmY2JvZHkudHh0IiBzej0iNjYwMiIgdD0iMTMyMDQ4MTE3OTMwNTA4?=
 =?us-ascii?Q?NDY1IiBoPSJoalZaTStBejhsb2dTaldBZ1pObm9VZUIrZWc9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFCUUpBQUN4?=
 =?us-ascii?Q?d0lGS0VDSFZBY2VrUEhkUDVwREZ4NlE4ZDAvbWtNVU9BQUFBQUFBQUFBQUFB?=
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
Date: Wed, Jun 12, 2019 at 07:15:33

> On Tue, 11 Jun 2019 16:06:43 +0200
> Vitor Soares <Vitor.Soares@synopsys.com> wrote:
>=20
> > Currently the I3C framework limits SCL frequency to FM speed when
> > dealing with a mixed slow bus, even if all I2C devices are FM+ capable.
> >=20
> > The core was also not accounting for I3C speed limitations when
> > operating in mixed slow mode and was erroneously using FM+ speed as the
> > max I2C speed when operating in mixed fast mode.
> >=20
> > Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
> > Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
> > Cc: Boris Brezillon <bbrezillon@kernel.org>
> > Cc: <stable@vger.kernel.org>
> > Cc: <linux-kernel@vger.kernel.org>
> > ---
> > Changes in v3:
> >   Change dev_warn() to dev_dbg()
> >=20
> > Changes in v2:
> >   Enhance commit message
> >   Add dev_warn() in case user-defined i2c rate doesn't match LVR constr=
aint
> >   Add dev_warn() in case user-defined i3c rate lower than i2c rate
> >=20
> >  drivers/i3c/master.c | 61 +++++++++++++++++++++++++++++++++++++++++---=
--------
> >  1 file changed, 48 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
> > index 5f4bd52..f8e580e 100644
> > --- a/drivers/i3c/master.c
> > +++ b/drivers/i3c/master.c
> > @@ -91,6 +91,12 @@ void i3c_bus_normaluse_unlock(struct i3c_bus *bus)
> >  	up_read(&bus->lock);
> >  }
> > =20
> > +static struct i3c_master_controller *
> > +i3c_bus_to_i3c_master(struct i3c_bus *i3cbus)
> > +{
> > +	return container_of(i3cbus, struct i3c_master_controller, bus);
> > +}
> > +
> >  static struct i3c_master_controller *dev_to_i3cmaster(struct device *d=
ev)
> >  {
> >  	return container_of(dev, struct i3c_master_controller, dev);
> > @@ -565,20 +571,48 @@ static const struct device_type i3c_masterdev_typ=
e =3D {
> >  	.groups	=3D i3c_masterdev_groups,
> >  };
> > =20
> > -int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode)
> > +int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode,
> > +		     unsigned long max_i2c_scl_rate)
> >  {
> > -	i3cbus->mode =3D mode;
> > =20
> > -	if (!i3cbus->scl_rate.i3c)
> > -		i3cbus->scl_rate.i3c =3D I3C_BUS_TYP_I3C_SCL_RATE;
> > +	struct i3c_master_controller *master =3D i3c_bus_to_i3c_master(i3cbus=
);
> > =20
> > -	if (!i3cbus->scl_rate.i2c) {
> > -		if (i3cbus->mode =3D=3D I3C_BUS_MODE_MIXED_SLOW)
> > -			i3cbus->scl_rate.i2c =3D I3C_BUS_I2C_FM_SCL_RATE;
> > -		else
> > -			i3cbus->scl_rate.i2c =3D I3C_BUS_I2C_FM_PLUS_SCL_RATE;
> > +	i3cbus->mode =3D mode;
> > +
> > +	switch (i3cbus->mode) {
> > +	case I3C_BUS_MODE_PURE:
> > +		if (!i3cbus->scl_rate.i3c)
> > +			i3cbus->scl_rate.i3c =3D I3C_BUS_TYP_I3C_SCL_RATE;
> > +		break;
> > +	case I3C_BUS_MODE_MIXED_FAST:
> > +		if (!i3cbus->scl_rate.i3c)
> > +			i3cbus->scl_rate.i3c =3D I3C_BUS_TYP_I3C_SCL_RATE;
> > +		if (!i3cbus->scl_rate.i2c)
> > +			i3cbus->scl_rate.i2c =3D max_i2c_scl_rate;
> > +		break;
> > +	case I3C_BUS_MODE_MIXED_SLOW:
> > +		if (!i3cbus->scl_rate.i2c)
> > +			i3cbus->scl_rate.i2c =3D max_i2c_scl_rate;
> > +		if (!i3cbus->scl_rate.i3c ||
> > +		    i3cbus->scl_rate.i3c > i3cbus->scl_rate.i2c)
> > +			i3cbus->scl_rate.i3c =3D i3cbus->scl_rate.i2c;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> >  	}
> > =20
> > +	if (i3cbus->scl_rate.i3c < i3cbus->scl_rate.i2c)
> > +		dev_dbg(&master->dev,
> > +			"i3c-scl-hz=3D%ld lower than i2c-scl-hz=3D%ld\n",
> > +			i3cbus->scl_rate.i3c, i3cbus->scl_rate.i2c);
> > +
> > +	if (i3cbus->scl_rate.i2c !=3D I3C_BUS_I2C_FM_SCL_RATE &&
> > +	    i3cbus->scl_rate.i2c !=3D I3C_BUS_I2C_FM_PLUS_SCL_RATE &&
> > +	    i3cbus->mode !=3D I3C_BUS_MODE_PURE)
> > +		dev_dbg(&master->dev,
> > +			"i2c-scl-hz=3D%ld not defined according MIPI I3C spec\n",
> > +			i3cbus->scl_rate.i2c);
> > +
>=20
> Again, that's not what I suggested, so I'll write it down:
>=20
> 	dev_dbg(&master->dev, "i2c-scl =3D %ld Hz i3c-scl =3D %ld Hz\n",
> 		i3cbus->scl_rate.i2c, i3cbus->scl_rate.i3c);
>=20

I'm not ok with that change. The reasons are:
  i3cbus->scl_rate.i3c < i3cbus->scl_rate.i2c is an abnormal use case. As=20
discuss early it can be cause by a wrong DT definition or just for=20
testing purposes.

  i3cbus->scl_rate.i2c !=3D I3C_BUS_I2C_FM_SCL_RATE && i3cbus->scl_rate.i2c=
=20
!=3D I3C_BUS_I2C_FM_PLUS_SCL_RATE, the MIPI I3C Spec v1.0 clearly says that=
=20
all I2C devices on the bus shall have a LVR register and thus support FM=20
or FM+ modes.
By  definition a FM bus works at 400kHz and a FM+ bus 1MHz.
And for slaves, a FM device works up to 400kHz and a FM+ device works up=20
to 1MHz respectively.

Apart of that, if the I2C device support you can use a custom higher or=20
lower rate, yet not defined according MIPI I3C spec.

> dev_dbg() is not printed by default, so it's just fine to have a trace
> that prints the I3C and I2C rate unconditionally.

I'm ok to change the way that user is notified and I think that is here=20
the problem.
Maybe the best is to change the first dev_dbg() to dev_warn() and the=20
second dev_info().

>=20
> >  	/*
> >  	 * I3C/I2C frequency may have been overridden, check that user-provid=
ed
> >  	 * values are not exceeding max possible frequency.
> > @@ -1966,9 +2000,6 @@ of_i3c_master_add_i2c_boardinfo(struct i3c_master=
_controller *master,
> >  	/* LVR is encoded in reg[2]. */
> >  	boardinfo->lvr =3D reg[2];
> > =20
> > -	if (boardinfo->lvr & I3C_LVR_I2C_FM_MODE)
> > -		master->bus.scl_rate.i2c =3D I3C_BUS_I2C_FM_SCL_RATE;
> > -
> >  	list_add_tail(&boardinfo->node, &master->boardinfo.i2c);
> >  	of_node_get(node);
> > =20
> > @@ -2417,6 +2448,7 @@ int i3c_master_register(struct i3c_master_control=
ler *master,
> >  			const struct i3c_master_controller_ops *ops,
> >  			bool secondary)
> >  {
> > +	unsigned long i2c_scl_rate =3D I3C_BUS_I2C_FM_PLUS_SCL_RATE;
> >  	struct i3c_bus *i3cbus =3D i3c_master_get_bus(master);
> >  	enum i3c_bus_mode mode =3D I3C_BUS_MODE_PURE;
> >  	struct i2c_dev_boardinfo *i2cbi;
> > @@ -2466,9 +2498,12 @@ int i3c_master_register(struct i3c_master_contro=
ller *master,
> >  			ret =3D -EINVAL;
> >  			goto err_put_dev;
> >  		}
> > +
> > +		if (i2cbi->lvr & I3C_LVR_I2C_FM_MODE)
> > +			i2c_scl_rate =3D I3C_BUS_I2C_FM_SCL_RATE;
> >  	}
> > =20
> > -	ret =3D i3c_bus_set_mode(i3cbus, mode);
> > +	ret =3D i3c_bus_set_mode(i3cbus, mode, i2c_scl_rate);
> >  	if (ret)
> >  		goto err_put_dev;
> > =20


