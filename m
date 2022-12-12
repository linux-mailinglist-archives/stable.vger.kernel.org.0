Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFA6649D0E
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 12:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiLLLHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 06:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiLLLHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 06:07:05 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2094.outbound.protection.outlook.com [40.107.114.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BAF11A07;
        Mon, 12 Dec 2022 02:54:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIAHfwDosB9joC/7Qx6yHZ0fse+MR09TWRFCBRdxGT/sXWaeoN2ezBRY9Ka1wvBuputYbTqTA84v9KKFGU99wwIZW8SMbgkyo+fmhhvQeEjTosX9V6b54cgpm0biH9XRx1j/EfJh9BhU730KjDlwnYKkmeetmZ8D2+OgeuZYj6Fa8bGkMSGP75x178NNqaqTYGBXwiLNvLxO8r63t/mSWFb3XpGSceNfH9LraB4OdaYBlg4Y943FBUwwMHPpLMlB8MSHW75z1K3Hx1269WD+DdAYgZV0gTViw3lhN6N3Gv9fIsFkzQF6nco9jQsC3bZ7UYzFh487GT57eoK3suA1xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/8F4Q4gI0ADS94bjuD54/xOQMpq83X4dVhpcMZj9dY=;
 b=K7v40MvOeJD1hkDsKSXSb1+bGPWf63DuVTT8wRJSt/9EckCtPODffZo+nD+FUE6RdmMkK312Dc7jTL0mwSnPZjxD6yw8M/3L+KvpnVKrm/MFwseGNO53zx+OiC7XqUdloU969Mep3f2FFFg0viJjfACT7ExkmyDtAzAWPvYj5qwNV15UU4EH1jQBE2H07/Id4oWVRWvFXNT8b2REU0JV4xYrZgUAX/7EdmEKJvqR960Xj0NQO9Xbr1bkaHT4z074sq+vMBbQsVzO9f3bFRj9W4uE472nx9WwTPZSnXybvs3VA+tr6nYMVJmUZn/9IlAGtzOUXiCxxoP6njfVM4qQwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/8F4Q4gI0ADS94bjuD54/xOQMpq83X4dVhpcMZj9dY=;
 b=GcKHNtvNIO5V4rAMFZCGSriC62eYjl/X7TTGXlYZ7DWMliXgg2I0ltkNWnliqNIECzofxoyJR1uG2FfcKNVjewQoOrb92ax+wocsFVK4hni43GoGZWIX4T7VBVWbn3jxjwTQnEST03RnOgtmrgRUD0j+MxTw11SazBVDq96ki0s=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB10520.jpnprd01.prod.outlook.com (2603:1096:400:29f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 10:54:26 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 10:54:25 +0000
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
Thread-Index: AQHZC/DC5zMigf6CwEe1ynb/crSS+K5qA3UAgAAKhHCAAAl9IA==
Date:   Mon, 12 Dec 2022 10:54:25 +0000
Message-ID: <OS0PR01MB5922FC3A7C5F0507292F99AF86E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221209170740.70539-1-biju.das.jz@bp.renesas.com>
 <Y5b24vdYTNW/aJ+0@kuha.fi.intel.com>
 <OS0PR01MB59225780B75FDC02C077ACE986E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59225780B75FDC02C077ACE986E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB10520:EE_
x-ms-office365-filtering-correlation-id: f3ebc2d8-7cec-4d46-e249-08dadc2f3c48
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JjOkZ2XAdR/QsWJMls1HH4zjZJp6LxZtRR1o+GPUx45wP+4EV6fnRH77+RVYJ3LSwvHRmAiPwjmyfEpUbgWzOMvhfbvS3Lb+Or4CjGd7MlLF0++7JIusX4kDqpFL82mly1g8phACDl9nRXRrXZ5b/oDPNeBmJbDxQ/nBbjhgKsipjyoHYbB63nobPhOtxxRQH63mXU8Iu+8ywMZIo5l2LfeFbgTRW1xts69yZHCCLVzoypbvg4wxFBNmpDy/KdKRtXobdAalzmbdveYMYCr3+CXimHLdmm2DHyMYluJt0X2PEyZW457FibSx4OTzOi+uwIxVYOBdzPRmPtpJ4iJ9VrKVfJg74TddJkyb6KGGyuQqIbkVahVPpRUxWP7caCtwztFo65qoqECxTCt92RRVDgvpyYpSY9c6MVyGjalU9bZLDB4heb4dyg1ecgRIMU2kxf39R4qh0/BYIQkaawgaEOFsE1kBxKsSO+/pk9oaE+cXBZ296VWZJb2VHDSpSQ93RD8HKl9DgNZEor/i6T9D2Z4VXFm8Jhj5SnJPMzJF/9xCtcrbaG4oQeVmLwok6VGKI4sAJ6IOf8CDuCkTRvBl3wK8DkAmeYKruMbEdqnpx02GARrNIRVjCqqWIPJ6mpiKIz1vn3JrYTQmrkCutZTVWgCETcEPtrP0Yi+hepZL9AJdVibRaaUe7hVrnPL2LburoS8FJ8tXzpYsj606zJGVAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199015)(71200400001)(478600001)(33656002)(7696005)(2906002)(86362001)(52536014)(5660300002)(186003)(2940100002)(6506007)(38100700002)(38070700005)(55016003)(9686003)(26005)(8936002)(6916009)(64756008)(54906003)(122000001)(41300700001)(4326008)(83380400001)(66946007)(8676002)(66556008)(66476007)(66446008)(316002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QQAdF+KmcKWnOkhg2a78xL+5h5Jt4/B4wii/anwckXDfaNhugQAsLzXrMBq2?=
 =?us-ascii?Q?PlX9zspC9ukA9ulYWydGQQY0shovibpDAn82raQjQTM7eDA4hTmfFPHS84PK?=
 =?us-ascii?Q?gSpBHE23dytQbzuKO6YATORRx28ETIBpMsK41ZfUmtlenmxKvB+W/jkhAD6u?=
 =?us-ascii?Q?5sCkXG44DwYnryaDjKbkuxRqlP5/fVbQt0KU9Lzs7Pcy033Tt4adjG5JLC+E?=
 =?us-ascii?Q?jxN7vdKL44PeB3SQDnjgngOu/Ge0sZ+pihHxNsg0rR6dgJ3iyfk4B9YOMM0M?=
 =?us-ascii?Q?mJbBLjosv/ilq/3jL6yFOMFSWfzM1haGsyQIfNgKlNbl590PHtXpJ8hKIGV6?=
 =?us-ascii?Q?Hw+26shu3sa049Feav+M0uqKczpAjLvHv+rR8ktKgNd9vnw2TNFtDHsDR1ZQ?=
 =?us-ascii?Q?+BVP51TaDw0ZuzUth7ZWW7n0aEiI02XvXRrv/+ZjEqH81Ur2JVgUqHHLHB7A?=
 =?us-ascii?Q?zNWzu7Jkbv3fC4E047f51V2eFwcpqY27igAUQCAAF5TnGFiO34/IF3SoY3h+?=
 =?us-ascii?Q?vRLW0oO0c/4ug35LNj9qDa74YZBoxhShvNYXYZqxTzJimr3CUDKWYhRVVeRU?=
 =?us-ascii?Q?xweaFsglYtYToGra0nAVG+rYJJ+xvvPZAFSovy5Sj0jgKm6dARTuZgd7B/ay?=
 =?us-ascii?Q?+DzVc5abA3JLBRknLe4SZHD2Rz+nfqsyL/9lPqMd0EJxGKRms1RoY3s8dLon?=
 =?us-ascii?Q?3XR48rxf03KybPgUS6ILiAf50d/o5ndhEAsKD8OptkFxCdTBKTDEYJvvwTwl?=
 =?us-ascii?Q?NFelkK/FJtwzUn9H47qNgWlWJhYzE5y5rPRFqAHg1dbyC5hM+ihNYD0qcpXT?=
 =?us-ascii?Q?cdXjN/mcQqQWzINX9+zs5Qd9uya0ioVg729S7v4aEdJxyy3Vo28GzdMl7DqH?=
 =?us-ascii?Q?9/QNLTMCdO2Yx40jjBtLMTRziyU9AHZVBLDLgOSVzOxoSm3BUj5QsZgzU61e?=
 =?us-ascii?Q?oF5EQ5yBSqcwWsJX3CbCPelXFgVfUF+ImRlc7cLvS1Ebj83ZqjtYC6F3H4sU?=
 =?us-ascii?Q?SGtNbDiMUY1n4I1M+W16uDdPB7+FfFudfmaV8bDXYlfYPb94qiqNAxW/XZ7Y?=
 =?us-ascii?Q?/H3PlIJsAc0QOLsNTkuuRhKaoeFxqp0c8+WNod9aAU5JK+MgsUGPgZWTUqkI?=
 =?us-ascii?Q?a/GSPs7g+h6dKq8KG4wcV5DU+BwwPTkA5kwMGtt4nZAUzzp3nKAxBrThta17?=
 =?us-ascii?Q?2sunQbdYSjSB+cJk1A71ZbV5Iw0O42+qxkp++RsoyN7vFiejM2wawPOigC/e?=
 =?us-ascii?Q?AWch6HrCB3BprubN0G1TYYb7/rPIUiMzP/z55SQ/GNnYMRtnycIU4nlWwH2j?=
 =?us-ascii?Q?UKIeraEh4BFfL/L708Zo4nWeWad1YVLmZk1lKUg5f2FWh2DP2XGGyzV9g+GW?=
 =?us-ascii?Q?ZIXNuqELJ0v6cERflnVBIkjjvvsoHlQHG6Xc8HbZPpxh2iixwRw3kTXk4SJV?=
 =?us-ascii?Q?tEeO9bltiykGlTSZpU6L7Qjq7Z/0egPWka6VB9CvBljse1sDKLfMR8yKg/nD?=
 =?us-ascii?Q?a5pXVQwOp78883weKmtSSjMx5mPSAGv7+am/IWX1DBLX1rQLN78Hri3LOgJf?=
 =?us-ascii?Q?61JfCJWTxxsSjjbZK+m06IsS80Z+V5eg7f4TT6D0FtKWv5JPPV3aEf7BxfDw?=
 =?us-ascii?Q?6w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ebc2d8-7cec-4d46-e249-08dadc2f3c48
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 10:54:25.8860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9uIPxd6Cw1sGeJ7wAPO5ZKqmtJwMdCuMUaQP4Bzb5bBY2zpawx4s2mVJTWOzpcxjFvstW+WOodifGR2o4nEgfWr3uFCW+mJOIEkBM6BDZc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10520
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Subject: RE: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
>=20
> Hi Heikki,
>=20
> > Subject: Re: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
> >
> > Hi Biju,
> >
> > On Fri, Dec 09, 2022 at 05:07:40PM +0000, Biju Das wrote:
> > > The value returned by usb_role_switch_get() can be NULL and it leads
> > > to NULL pointer crash. This patch fixes this issue by adding NULL
> > > check for the role switch handle.
> > >
> > > [   25.336613] Hardware name: Silicon Linux RZ/G2E evaluation kit
> EK874
> > (CAT874 + CAT875) (DT)
> > > [   25.344991] Workqueue: events_unbound deferred_probe_work_func
> > > [   25.350869] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS
> > BTYPE=3D--)
> > > [   25.357854] pc : renesas_usb3_role_switch_get+0x40/0x80
> > [renesas_usb3]
> > > [   25.364428] lr : renesas_usb3_role_switch_get+0x24/0x80
> > [renesas_usb3]
> > > [   25.370986] sp : ffff80000a4b3a40
> > > [   25.374311] x29: ffff80000a4b3a40 x28: 0000000000000000 x27:
> > 0000000000000000
> > > [   25.381476] x26: ffff80000a3ade78 x25: ffff00000a809005 x24:
> > ffff80000117f178
> > > [   25.388641] x23: ffff00000a8d7810 x22: ffff00000a8d8410 x21:
> > 0000000000000000
> > > [   25.395805] x20: ffff000011cd7080 x19: ffff000011cd7080 x18:
> > 0000000000000020
> > > [   25.402969] x17: ffff800076196000 x16: ffff800008004000 x15:
> > 0000000000004000
> > > [   25.410133] x14: 000000000000022b x13: 0000000000000001 x12:
> > 0000000000000001
> > > [   25.417291] x11: 0000000000000000 x10: 0000000000000a40 x9 :
> > ffff80000a4b3770
> > > [   25.424452] x8 : ffff00007fbc9000 x7 : 0040000000000008 x6 :
> > ffff00000a8d8590
> > > [   25.431615] x5 : ffff80000a4b3960 x4 : 0000000000000000 x3 :
> > ffff00000a8d84f4
> > > [   25.438776] x2 : 0000000000000218 x1 : ffff80000a715218 x0 :
> > 0000000000000218
> > > [   25.445942] Call trace:
> > > [   25.448398]  renesas_usb3_role_switch_get+0x40/0x80 [renesas_usb3]
> > > [   25.454613]  renesas_usb3_role_switch_set+0x4c/0x440 [renesas_usb3=
]
> > > [   25.460908]  usb_role_switch_set_role+0x44/0xa4
> > > [   25.465468]  hd3ss3220_set_role+0xa0/0x100 [hd3ss3220]
> > > [   25.470635]  hd3ss3220_probe+0x118/0x2fc [hd3ss3220]
> > > [   25.475621]  i2c_device_probe+0x338/0x384
> >
> > Based on that backtrace, your role switch is not NULL.
> >
> > You can only end up calling renesas_usb3_role_switch_set() if your
> > hd3ss3220->role_sw contains a handle to the renesas usb3 role switch.
>=20
> Looks you are correct.
>=20
> >
> > > Fixes: 5a9a8a4c5058 ("usb: typec: hd3ss3220: hd3ss3220_probe() warn:
> > > passing zero to 'PTR_ERR'")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > ---
> > > This issue triggered on RZ/G2E board, where there is no USB3
> > > firmware and it returned a null role switch handle.
> > >
> > > v1->v2:
> > >  * Make it as individual patch
> > >  * Added Cc tag
> > > ---
> > >  drivers/usb/typec/hd3ss3220.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/usb/typec/hd3ss3220.c
> > > b/drivers/usb/typec/hd3ss3220.c index 2a58185fb14c..c24bbccd14f9
> > > 100644
> > > --- a/drivers/usb/typec/hd3ss3220.c
> > > +++ b/drivers/usb/typec/hd3ss3220.c
> > > @@ -186,7 +186,10 @@ static int hd3ss3220_probe(struct i2c_client
> > *client,
> > >  		hd3ss3220->role_sw =3D usb_role_switch_get(hd3ss3220->dev);
> > >  	}
> > >
> > > -	if (IS_ERR(hd3ss3220->role_sw)) {
> > > +	if (!hd3ss3220->role_sw) {
> > > +		ret =3D -ENODEV;
> > > +		goto err_put_fwnode;
> > > +	} else if (IS_ERR(hd3ss3220->role_sw)) {
> > >  		ret =3D PTR_ERR(hd3ss3220->role_sw);
> > >  		goto err_put_fwnode;
> > >  	}
> >
> > You should not do that.
> >
> > Either I'm missing something, or this patch is hiding some other issue.
>=20
> Looks It is a bug in renesas_usb3.c rather than this driver.
>=20
> But how we will prevent hd3ss3220_set_role being called after
> usb_role_switch_unregister(usb3->role_sw) from renesas_usb3.c driver??

Do we need to add additional check for "fwnode_usb_role_switch_get" and
"usb_role_switch_get" to return error if there is no registered role_switch=
 device
Like the scenario above??

Cheers,
Biju
