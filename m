Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D4C649B86
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 10:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiLLJ6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 04:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLLJ6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 04:58:13 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2118.outbound.protection.outlook.com [40.107.113.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DD664C0;
        Mon, 12 Dec 2022 01:58:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AB+Aj6qUN0CayWuvp5su/WkV352c6BazmU6zhc0Gym7gikxH0uclJ41vw8Mb/hxiJjUae9YJZuwRx+uCSBRPRoU2yALNtkQg2+8lSulghsfUhjOSBLOLP+T2QHgPwA+HcnnCXLZzLC9guumtQgGjDpA6bIqwOrXpWLaC2HgvUVNR19jc+I681U4Ay0/DGkH+Io0Lja7HvDRVX6V4j1JdaObvToCDGwhtP75Im3yE3SBubT0DqBcIey89+tyBJo6mzqS76V//fo4QgUHcvlnqpXYrn+4pDeNl9l3UXSTNxrer4dSTwRDhQ5t9Am/xyIiz7+36lnCkImqvh0kwKTGJWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHqOyj860POeKvYGbTxakI1NMs6Z+DQ6O7yrqIAjefA=;
 b=AmMhpHONg8bJtxvtc34C/e5Xd2UCXOYGW/Ik9vLfMN7Zox7srZ5tSUjkPdNTjrQ1btWK1N59aU86DNxHrVW2IKPgsPXuFme1qcFJIFKXZIa4oujyHuY1lgKi2u11atJ615CKQCh94TF2hpeo6PXPcSyX5PLqMdsE76bFOxYKMsC7BYAxetF6M4TMP3SsyunkEuxrPokKOqIagQjIdjkzqVvEHVBLg4p50odXVWJzgc0zXA1rFr/wfKfNyQGZRX9oUTGFUNf5/snDo8sgWY3hMBYG/tb9FuYJcJKEAApAEi+EOV+lRkTIzNUtl/rvIMaaTzKmqhD7K3hGY72fcB9nyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHqOyj860POeKvYGbTxakI1NMs6Z+DQ6O7yrqIAjefA=;
 b=VLy5g2PGTJxeUwPfBMAPxouyNWpP2wUMa9SDiE+ip9h5FMA8D7lqAT8zY9wAF8kCbFSgnuDsLyhsabLfgbUUSR/XhJeSTjPxWjRGBSVaxDaO7AcKPbyo+X/DBMBFeLqoOFCF+8Sb/oFBC+R1IvrTOrjl+kPGOrHvnsibe5IGMeI=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB10229.jpnprd01.prod.outlook.com (2603:1096:400:1ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 09:58:09 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 09:58:09 +0000
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
Thread-Index: AQHZC/DC5zMigf6CwEe1ynb/crSS+K5qA3UAgAABcXA=
Date:   Mon, 12 Dec 2022 09:58:09 +0000
Message-ID: <OS0PR01MB5922255B5D2AA55870909E1486E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
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
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYCPR01MB10229:EE_
x-ms-office365-filtering-correlation-id: 05b41064-4a23-44cd-83c3-08dadc275fb1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f477OQAA3n4qlLPi5UCgJd86hCMwXxHBQYodYHg7XBDsCuWDs84/DJ+hJvVIy1kFY9q+YPv1XkqKCBa84UPw6uCuHs2c19U8+0Qupr2+rS6IpLeAQ4erF2bA8FQD9r70GDHmKnuckW2kbSE3BmeJ4l8apSeg38ASfWfkHH1RKHS84aE27n112YFHe9hcOVm8mrsDze5M7b4Oxr58vnQ96pw40dKWlPb3mkvnUuhtsFT28XjREDFGJgydJXee7LI7bACOWrqxc/IjeHEa3rPhiBc7tC1MCFHth64xfWrE5orElizlJHa43a/WZcAjXYGtPuW04J9jJfwgP91guqP2snWK5CO1dWdZUua5VgDIH2DqbhN6xpSCKHC06DTHuSjCpb2wreyuq2WoIEy95IQ4659zXgTHkTEdhBGQg2aQZf5obWLn/om1ISW7xrXgFOT0WA0XU/pM74jmKp20NuY/qEBbcpBz5NKbVH8/KciCGSvdQGLNDMmrsW43K49/VSht89KK+516FXhUC1bx4naoCSBwdR7CVJduseLxS6nLUaKVmKIpkLieV1cK+D4G0RAvyUXwG5qaQY+sidO8a34WZPiPPj9BEoAGnpL27rZIXXecBWbgI2K0uLlpfgUWNRgFQOzSFIjL6sWVEM3kUxeKatwFtEVvfimrGxGCVKghjZmA8fi9+OnWmO4Hnthn6lUrJGCuSfIGIbxr5+n2k9jugbuBO5tj/8gSWZ/hq2vGDPo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199015)(9686003)(316002)(71200400001)(6916009)(54906003)(966005)(6506007)(7696005)(186003)(26005)(64756008)(66556008)(76116006)(66946007)(4326008)(8676002)(66446008)(2906002)(66476007)(478600001)(33656002)(86362001)(8936002)(55016003)(38100700002)(5660300002)(122000001)(83380400001)(52536014)(41300700001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HOu49Sfv/f10QC3d2xbJrPG8yU+1BRtAGloE9nFSxQXY3WQ2E0dWh52WooHv?=
 =?us-ascii?Q?fQpjy2mpz2CeYmsDPrlXvJiXVbmXsOcJIJ6DGOIbGN/bLUbLZ2w2gQik66y8?=
 =?us-ascii?Q?w59sc9Ck6dKSYKbt3hIk0S1WFObXiKa7d8DLGyyLxoiLrqIKpwF/am4sdcE/?=
 =?us-ascii?Q?Z+khFJbh9aOELIfVyH3nkaXSWdLV9uWyyLPhIogTJDgktiO64YlCU0SEAHic?=
 =?us-ascii?Q?/UWv+j0TzIkLLoHIixKQGb77firCYG/ZcTmivoHHfDDqnPGhf1gCNKvR5Eij?=
 =?us-ascii?Q?bl0dX/0wUDhO4JPAmLYKH61lmY18ZOA+V9Mh06Uramr9VDaN92dM4sEHJVwp?=
 =?us-ascii?Q?IEqcU1+7gcaD8cU2UTyNaPeIoEapYOzMfsHLoxTq1D5dol9HsgdanejghI5s?=
 =?us-ascii?Q?9IkCiefmUpDyvdIwQWPk2D0727dhGqGGtJS3D9tyk4YROtz+wTetreCTtnOZ?=
 =?us-ascii?Q?X0sR2A/mQCKixqS4zyCG0UmDZMO2dKkEcNtsar7sWSd4UKhhD3x5cTeCG2nx?=
 =?us-ascii?Q?e0OJBx9BR9S7mmSReNnUGRnfqzK4KJnnnIkIsvNCBGYDIemOvmSK6SbrBWNC?=
 =?us-ascii?Q?MNWvqCsG1lrQZcM9rXBOY16ZLPsnDjxyB0g61IFuI2Laqvuqff9INh9qt7x2?=
 =?us-ascii?Q?K0/TJA1p6jgjscLssqhBX4drbP7iw/QT4+TR45fNCK1k7eCw+GWhztsI+Kaq?=
 =?us-ascii?Q?GlNES41+CJgEkBI6tjOCMmTz6lid8zXsYyeaHWFFwuCLjNa9IMarwVSqJlL6?=
 =?us-ascii?Q?qBlLRnca4ExnUM6KdCLvZAg+REYGMq4mPnlBq2SPZ6tSG5bm8F+QzE1qrkvp?=
 =?us-ascii?Q?sYd0OLq+bCQV7pnZdi/z3xNLICqgYFB1RJu7K9fkS6DRgbI9BXxLy2/WiyQz?=
 =?us-ascii?Q?rBcvZFhywGuFmizR6ZG0xAd4MFS+c3pO3VTmuf6tL8fTwroAnzpv//2LhLuV?=
 =?us-ascii?Q?9rC0r4AvLPA538rz7gCwUNYhTU1GFu2MHty3bQS25aLsZaQy5DrW9KKl3hhA?=
 =?us-ascii?Q?NSJF+ksSE+RqWMfP+s/xnej/uvCtjXbxYSmZ9OuxsqZNPgQg27yJ+5PNzXiQ?=
 =?us-ascii?Q?YlGo0ig22imHaus60z8pQEKSLvJWDE/RLZBnzCStp2Jq1vy39/+Cp0oJNthJ?=
 =?us-ascii?Q?Q3phpHiWlpmkghwCXSXWrg/XmEE4y7Bfl1QO6JOuMRQ0Sl5KvgdCkPvOJOAV?=
 =?us-ascii?Q?9nL5n7GX6laoiJOygF6e/9Rb5qMmLVQwynM3jcOwe26w3gUS2d8Xu/HTDXme?=
 =?us-ascii?Q?7nKa6VdA+OPSh08mawbxCBOM/nWd8/+/MnDMHY32YmnCJlTVIt/E8q5ybnnQ?=
 =?us-ascii?Q?E/2hCYWepm+poIK3fI+R1VEiFKszq/xdzCluVSDejyc0cea1lGzOFfoCq+vK?=
 =?us-ascii?Q?3wye2/Z74JTKZ7aBY4HH8XFmg1eqAZP/PatW2UivlNY1ipxyk/WVQWZoHP62?=
 =?us-ascii?Q?KYbCseruLhm6WwbYAcSsafXr6w8GvQoHC3yK2sE1sITnmgi+lRsjjCwlrlOP?=
 =?us-ascii?Q?zpciYe324Cxty8ag0bZDpyuByRDndtosbRJqzv3yXFcVL0ggS0iTRKGs0VGe?=
 =?us-ascii?Q?N0MDcz/wc4jzxVdSVYUV53ezbGKAp/mSITgrMY6bcflYXuHAuohAbSOe7nW/?=
 =?us-ascii?Q?rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b41064-4a23-44cd-83c3-08dadc275fb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 09:58:09.3026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QOKekTtYiM9r5BLGhUlawFmAUbkwSRdnpXZPGjv+OhnbGJJgKRRzBs2xFO8apgAmw10r0I1eNeUrQROTtsRRADs58w6nB/Q3cP89U/BopqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10229
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Heikki,

Thanks for the feedback.

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

I haven't provided the USB3 firmware, so companion device will fail. See [1=
]
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/dr=
ivers/usb/gadget/udc/renesas_usb3.c?h=3Dnext-20221208#n2917


Cheers,
Biju

>=20
> You can only end up calling renesas_usb3_role_switch_set() if your
> hd3ss3220->role_sw contains a handle to the renesas usb3 role switch.
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
>=20
> thanks,
>=20
> --
> heikki
