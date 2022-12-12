Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB54649C15
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 11:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiLLK1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 05:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiLLK06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 05:26:58 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2095.outbound.protection.outlook.com [40.107.114.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D520CF011;
        Mon, 12 Dec 2022 02:26:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DH2XwLecRlkqx/5T+PpLJNgea7yo5vZqN/yLHjddGBTomyLM42SoaDsC7Li9HI6/NkFUYhvaI9V3mk7MA0J8nc1t1qGBitX6QeUfaVOowcljo9Uj6i7thhrcIUgtMCiO7d/htkMSvyZSAlFl6OUz35OazpJy2eicDLrBd62BAZg5SvILTvG60Ljk1PxgEyX9mDmiOR3GV01BmJD/t47lXKqs1uqEnm+9my1B4pfK3ArtkPek9K8CotQgDmL8wBC4TcqugFHBsn/J5djpfv9PJjMJjT74iNhBjcFHJpTZniBLoQE8h8Jn2w4/zgDFCya6Ly9u9muSX6Gf44G/JcDnhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lfl0vqZMrJrL8RhM/y6Bv9PM0YMwJRIqPEiCiaV+Qg=;
 b=mXtDQuVKNlHO9ttj6iImv3mLNEO7edw/i1WpAPT7aS1PvJvQ7WGjxaMvmZ+w1cVWPgwE4dLkR6CSFsD5mXKzQ8aBLxYbdjeiQGqNTtKHrLSp3EYAPnvHcn2ebaI++WXEU/8IP2HsfUGRiPTbJjRDUq7C2i8oAdJqjfj4st6r6Tdvl6erabHTsPdS3hmnIC6u215t5ncgHDKxdtHJ/Yj+sBqdlc13388jeUNg/t/R6R5DG6ZdwMkydQAXQ3KgKoXZzecMtMa/YyECwVwVpcHCAoM45KhbsN6+wk8ZUY2L3v8jArcbfz4/fUAkIuYnTq5+MLGFjqabBWy7nBrBEXLjAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lfl0vqZMrJrL8RhM/y6Bv9PM0YMwJRIqPEiCiaV+Qg=;
 b=p+bG46mx+owr6E2gkI7YdSZS1ruDfUSSxqJuLZnnfrd2hOE2loIe2/Hp3qtUo5NG7tHjbPdIrJx86zV2L0IPNjf2dpymJXVXE21EtkHwwBYwz1SIyyFzVXD6ncMod/Y3RnqA3KMZRk/829Jr9ihg+weCeN9c/3wOo5WrCH5uBFs=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB9692.jpnprd01.prod.outlook.com (2603:1096:400:232::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 10:26:53 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 10:26:53 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
Thread-Topic: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
Thread-Index: AQHZC/DC5zMigf6CwEe1ynb/crSS+K5qA3UAgAAKhHA=
Date:   Mon, 12 Dec 2022 10:26:53 +0000
Message-ID: <OS0PR01MB59225780B75FDC02C077ACE986E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221209170740.70539-1-biju.das.jz@bp.renesas.com>
 <Y5b24vdYTNW/aJ+0@kuha.fi.intel.com>
In-Reply-To: <Y5b24vdYTNW/aJ+0@kuha.fi.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB9692:EE_
x-ms-office365-filtering-correlation-id: e7befeac-28a8-47a4-842c-08dadc2b638e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /lN6cJ8+Tyuz6Nj2+a2nRJ7ahL7dcVi3r2kBDFvdWnkhMaipceGkaovrJXpaQo8o/BIKWgUXfpyWDkwLZPdta2uJ6ACG5YyjbhJtghc/VnYFFvM/wbJk/aEChzH0kyhYgzq25iaUJq8wITK+Yx0Klr0JbOP1xOHA0fYNnL+5/f2Fk4R7olyZ/MhHXvd4T08I0Wek3Mm5A88doQkScckHxsMcjFbAU5WJhWK9wW6bzVqKJ6tHo/v9R+bwImFKb+0VwwAlMxK93Z1foGPlY6zrPDoDwd9ADpg7XzG07eFcqumWVGZPFhorvT7VuG7mv+qOnio1xmIymYzUFIYKvwfnVoDE3VdjCyZst3x8uIP9UEAdBJVdCUP7m1033AhR/+ptDGRq34Hv4pEoVd9NwWBFjOlz+ZLjtD9LkQM4Xh7npalC9+yFBrZdpQ0P4wX6NjQmMwuUyAAYhYw3pyQ6qw1NWvUXuFzjJfTzNNTvvxKVrvDXDZqkky+n5Wpdcbpa8ZZp6FvFf1bloAM0OxbtVgmDPBcw/54tV3eMQf7eXJNbzhZGmleb3bW9sRe56LPRgvrBdUkUJmCAxT29RCmrvC1YZeJcXj2GpRVwSOoOfZWOEe88VBh7Oo9sWO41Uj+3bK+xkq0Tq2gw6ddq9lJdFdqsClmYOzpotyQwYlstMV4hXnJ4jfSfDwbX4gWA6Ua1EKi4i7F4uNTuA3zTmSOKhxKNyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199015)(316002)(6506007)(7696005)(186003)(26005)(9686003)(2906002)(54906003)(76116006)(64756008)(52536014)(66946007)(66476007)(66556008)(8676002)(66446008)(4326008)(83380400001)(122000001)(41300700001)(38100700002)(38070700005)(5660300002)(55016003)(478600001)(33656002)(8936002)(6916009)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?br365+hMgLpBrpL3czx3BGGo8frtEbodCZH7AT6bPxTC3vvtJat32r6xyJVi?=
 =?us-ascii?Q?vQo8qsydR9KZcV/vZig06bZEzHCQIGwx3to7w4VSMAxyEqB96UX2w0Qw5pcf?=
 =?us-ascii?Q?ysLllndGk5B876yBjpY9MRme08vXmiqk2PqidtjLsysu6VlMx5a6a5g0mPAO?=
 =?us-ascii?Q?dKJEJQMt+SerNk4A8A6sNkGZOgYh/VAS/v1Pm9oiDgUwG1C0DJYu88dvmlyQ?=
 =?us-ascii?Q?bObgj08Ax4cH9p7R5SQwHXFuWm8OkReTIQsLkmFz2RK3ZcrB8w12+3r12xHM?=
 =?us-ascii?Q?MuNgBMjhPvWaU8XpfMQHPWWBI/XtA4Gknhg/YvOdJlUkdySe4zI/rXRg3g+j?=
 =?us-ascii?Q?E0Ehb7Gd8Mk9T2Cs0x9SiLGPBy7kDVvEnyCLHk5TcBqchr84cTkoH/dALW/G?=
 =?us-ascii?Q?5TEMt9luPrmLRZt4U+rqry0o3+B+AdzLGMB51W7FvaBg5Fpupp61pKwwYE6q?=
 =?us-ascii?Q?jz9Zk7MVP95i5+NOOPXhmcsk0mDAgBLDVPEF5/k0r8EgjWyj0LUeQnFS1pTp?=
 =?us-ascii?Q?n8qqx5N64yZJ+z+BO3gkBtVGEdgRvNuu/jqvs1Jp6APCfGj1GxdzSramI5kL?=
 =?us-ascii?Q?fQxGFoey8PEI0cYFcZNP82PTCG/TY7UgPPPJz20IhP8teVW/1Z3ZgTyq+xdY?=
 =?us-ascii?Q?QVGoqHNIPnIybRysKGWPDsyyKgX4/Hsby/3abCnKn5uW44AhTx7JHS+6VR16?=
 =?us-ascii?Q?PhWHK/Uo3ZOAYTPErVmPu2Ez7Kz6Y2Rx5i1KUukrXsjqA8pCRmOnZYrmqcDp?=
 =?us-ascii?Q?jUwUZSK6gvjBnkX7pWVdQwIeZX5iweqovmMh1r0mAtOmZfKcCLVMMlJbtmwQ?=
 =?us-ascii?Q?IHvItz7H76YQHCckkBQIFO0jGRucVRzzwu5tunjSdcHoBwiV0TB6Op01965F?=
 =?us-ascii?Q?AViFG0h/+eVZBx3BSqR4gUBv1w2yx1+Dm0uaMflyz8D6DTUDcKm1fpPSV2/o?=
 =?us-ascii?Q?viVnzDJtKRLOd2jVL83B71TPEXfcpDFYgYOb/zgGEBCmgdWtc0+5OEBnlM79?=
 =?us-ascii?Q?0pWaeiNDbAe7/8CTP1pjDFiCWDPeX+/9639c06by0Jnuk4m2CTywBLzhm5VS?=
 =?us-ascii?Q?nLtEKWlyuEQnjFVg5ZI09sIo3qoxC8kydoCJBiQvT6ZOemZmMKPRPg4T89rg?=
 =?us-ascii?Q?OwCSWmVu1Vk36PepgW6ZME7GDqL8zQIGt63SDCYV8xnHZgbNGhZ/2Fj7RKrT?=
 =?us-ascii?Q?ku32ikdDMsza4E2zqfwp/ZK5CAAV/S4Bymgw/VsFpuAGVElrurYrUrTBtIBz?=
 =?us-ascii?Q?3FRG06PtzRYfZcWNAeFw3Q3onpKdqWG/OWxwEjIEjeEYlhq5j1w5tx6ME7Sj?=
 =?us-ascii?Q?g7HIbJYS8d3hqzGM9O02yN0BZpi7NMsLloP6hudLz1ZA4b9QPzZujuUpwLHU?=
 =?us-ascii?Q?lSoUYAhlU+keOjUBf9LguF+ig7fVzRjABPT/Xd17ow/8aYw7Uc5E22odnBSJ?=
 =?us-ascii?Q?OAuDGXemmEuSLPn8VhoXcjNv9gTW/DfWx8dZ2wvtkWVvkjR+uePdkNT7ShDw?=
 =?us-ascii?Q?JfTkEUzaLUSurCNsRo6aP3XBFobkvTUBdKcYJbEWaLKlM3Uyb3GNsmhQ29Om?=
 =?us-ascii?Q?VfTIkAlBN0155UUIUP3qDpoK+DdryKxn7sJjbDKLn27lV0+t+0qMeJrwiTqT?=
 =?us-ascii?Q?RA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7befeac-28a8-47a4-842c-08dadc2b638e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 10:26:53.8178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xu49U6ntjWmIWea4yS69+eiaJ2OL8lRdGScdeWEl3eO6jEHHBWxVfbWBnkvkH8rFWS23weLTXPbvi1VI2Ae93HKRWN8VtboCnErdQBqW78U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9692
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Heikki,

> Subject: Re: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
>=20
> Hi Biju,
>=20
> On Fri, Dec 09, 2022 at 05:07:40PM +0000, Biju Das wrote:
> > The value returned by usb_role_switch_get() can be NULL and it leads
> > to NULL pointer crash. This patch fixes this issue by adding NULL
> > check for the role switch handle.
> >
> > [   25.336613] Hardware name: Silicon Linux RZ/G2E evaluation kit EK874
> (CAT874 + CAT875) (DT)
> > [   25.344991] Workqueue: events_unbound deferred_probe_work_func
> > [   25.350869] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS
> BTYPE=3D--)
> > [   25.357854] pc : renesas_usb3_role_switch_get+0x40/0x80
> [renesas_usb3]
> > [   25.364428] lr : renesas_usb3_role_switch_get+0x24/0x80
> [renesas_usb3]
> > [   25.370986] sp : ffff80000a4b3a40
> > [   25.374311] x29: ffff80000a4b3a40 x28: 0000000000000000 x27:
> 0000000000000000
> > [   25.381476] x26: ffff80000a3ade78 x25: ffff00000a809005 x24:
> ffff80000117f178
> > [   25.388641] x23: ffff00000a8d7810 x22: ffff00000a8d8410 x21:
> 0000000000000000
> > [   25.395805] x20: ffff000011cd7080 x19: ffff000011cd7080 x18:
> 0000000000000020
> > [   25.402969] x17: ffff800076196000 x16: ffff800008004000 x15:
> 0000000000004000
> > [   25.410133] x14: 000000000000022b x13: 0000000000000001 x12:
> 0000000000000001
> > [   25.417291] x11: 0000000000000000 x10: 0000000000000a40 x9 :
> ffff80000a4b3770
> > [   25.424452] x8 : ffff00007fbc9000 x7 : 0040000000000008 x6 :
> ffff00000a8d8590
> > [   25.431615] x5 : ffff80000a4b3960 x4 : 0000000000000000 x3 :
> ffff00000a8d84f4
> > [   25.438776] x2 : 0000000000000218 x1 : ffff80000a715218 x0 :
> 0000000000000218
> > [   25.445942] Call trace:
> > [   25.448398]  renesas_usb3_role_switch_get+0x40/0x80 [renesas_usb3]
> > [   25.454613]  renesas_usb3_role_switch_set+0x4c/0x440 [renesas_usb3]
> > [   25.460908]  usb_role_switch_set_role+0x44/0xa4
> > [   25.465468]  hd3ss3220_set_role+0xa0/0x100 [hd3ss3220]
> > [   25.470635]  hd3ss3220_probe+0x118/0x2fc [hd3ss3220]
> > [   25.475621]  i2c_device_probe+0x338/0x384
>=20
> Based on that backtrace, your role switch is not NULL.
>=20
> You can only end up calling renesas_usb3_role_switch_set() if your
> hd3ss3220->role_sw contains a handle to the renesas usb3 role switch.

Looks you are correct.

>=20
> > Fixes: 5a9a8a4c5058 ("usb: typec: hd3ss3220: hd3ss3220_probe() warn:
> > passing zero to 'PTR_ERR'")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > ---
> > This issue triggered on RZ/G2E board, where there is no USB3 firmware
> > and it returned a null role switch handle.
> >
> > v1->v2:
> >  * Make it as individual patch
> >  * Added Cc tag
> > ---
> >  drivers/usb/typec/hd3ss3220.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/typec/hd3ss3220.c
> > b/drivers/usb/typec/hd3ss3220.c index 2a58185fb14c..c24bbccd14f9
> > 100644
> > --- a/drivers/usb/typec/hd3ss3220.c
> > +++ b/drivers/usb/typec/hd3ss3220.c
> > @@ -186,7 +186,10 @@ static int hd3ss3220_probe(struct i2c_client
> *client,
> >  		hd3ss3220->role_sw =3D usb_role_switch_get(hd3ss3220->dev);
> >  	}
> >
> > -	if (IS_ERR(hd3ss3220->role_sw)) {
> > +	if (!hd3ss3220->role_sw) {
> > +		ret =3D -ENODEV;
> > +		goto err_put_fwnode;
> > +	} else if (IS_ERR(hd3ss3220->role_sw)) {
> >  		ret =3D PTR_ERR(hd3ss3220->role_sw);
> >  		goto err_put_fwnode;
> >  	}
>=20
> You should not do that.
>=20
> Either I'm missing something, or this patch is hiding some other issue.

Looks It is a bug in renesas_usb3.c rather than this driver.

But how we will prevent hd3ss3220_set_role being called after
usb_role_switch_unregister(usb3->role_sw) from renesas_usb3.c
driver??

Cheers,
Biju
