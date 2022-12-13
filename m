Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81C364B16D
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 09:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiLMIq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 03:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiLMIqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 03:46:13 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2107.outbound.protection.outlook.com [40.107.114.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154291AA1D;
        Tue, 13 Dec 2022 00:46:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FX/Fm6eqTI5xRY26lLpt3vSLFfYp9Sy93JKFIbGR+psZu1HiVE3xeGOSpTr73VLEfkBRekhsAM4xtz9abvlzhHhh+HjVOGTCuZjfV3UZ9i4EdPOEN4QIcyj3bWOZRgInHSohwqqVSCt+mrULhjOtf0jIcdQf3t9cKMVuZq++hw91g/sLU8IMy0+vkWYbZF0M0tOEfxunfc5o55gcw6GGa96jpe3hPzFAFdgcRFSQNonYnjhtUqwQMdDtzbFXcPBazkkCZdkSQ6Lgz6kBTge0EI3Yr3HgSLEb4IiqJTfRqYEMmU5sGh5ZGzICGK40R99aeGJgrdg3CK9PAyhq6wNRdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YD7Fg3+lWPT6EZR/dCsvxxN/UHHvBPHxucEbIrOLU9Q=;
 b=Q5aQvZ7ruw/t5P+IGURExOwFlt1Fn554N7PrCT0o1VEHSGXrYmslBSwqOk273dhg1RI/C9e8I0RGNT5DzUKy4USC7x00gCRrlH6dXMcQ9ngkgoF3TQIg4qzigGZg/q1aIGHwkdbePOj594tze1UJqI7dVOYwyNn9l3PEKRfEMlaMpOEkd+1KrgORvGDtzAf9BrXIAgg0+ry6VHZ7P8f4eET9AShsorhdu3/GFrZ+7Y1Ll8GcSqRqmmdK141/dG7brt5DFwNY4Bo4kr9jhHEpDACdr9STcB06GDOZa+UB4qLXKRnd16YgYWAbqPyHNDmv9ejTXfDD2kNpC7YHF8ifUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YD7Fg3+lWPT6EZR/dCsvxxN/UHHvBPHxucEbIrOLU9Q=;
 b=diirijSZReBOaZoBYeYUPiTKGUJhSiviaYdMU1qBTWc/FIQhKHhi1/0/92wV+ggberOW2m4TQbUZUUh3jsqVixUVz4Fqsp/r+kWMF0qzycYnF83Pr5U+U8pGSlH+IaTAzzBWYzOGgp2lQUrQLXwlpwzHvQQDosuXHKdXSMN61UQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB9791.jpnprd01.prod.outlook.com (2603:1096:400:235::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 08:46:09 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3%5]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 08:46:09 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: RE: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
Thread-Topic: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
Thread-Index: AQHZC/DC5zMigf6CwEe1ynb/crSS+K5qA3UAgAAKhHCAAAl9IIABbKkAgAABznA=
Date:   Tue, 13 Dec 2022 08:46:09 +0000
Message-ID: <OS0PR01MB5922C5BC2F2B7654B3185F6586E39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221209170740.70539-1-biju.das.jz@bp.renesas.com>
 <Y5b24vdYTNW/aJ+0@kuha.fi.intel.com>
 <OS0PR01MB59225780B75FDC02C077ACE986E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB5922FC3A7C5F0507292F99AF86E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <Y5g5kPYu9+tGfriE@kuha.fi.intel.com>
In-Reply-To: <Y5g5kPYu9+tGfriE@kuha.fi.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB9791:EE_
x-ms-office365-filtering-correlation-id: d92b0c6f-76f0-41df-7ac2-08dadce67b17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VHeKyDLirlEr9k9t7SANfOCHiDXejfdF/WOXwfBHUkVPy0k4rKB7wlXlB+uAJoz6+t1DxB+ilbCh/lSV1bQT8ZCLxVhpqKpSxjMwo8F4OKTajQB7Wbq3I9HMq99c8pTKIvZf9Oz+oqQMPDxdlPxrxdDKK+oabcNuupse5v9Q5ynXl47+xiC0/cxZr2GEW5sHHOwQ1CiUZ7nIcI91FT/4smcnjP5T1ZtfWy0Beb297IAUWrcC2b9m0fXcIqmHXtrnbttqahr707PUeHqEkZJZjtTrR1Hm9WS6mlqdQ1q/MNJp6ZsBr5WeXS6to9/jwnYDbRDnsbL4HPYO8FN9ybQmORKqEhVi6Bc9hPm1/QqU1uO+bq0IKDcYY8lgkqyIJCtuxkSDqdd23XmpqdYz7hsyJZVt1Q+CYsFUJez1oSkAdO/elzAnpeo9KrlxYrXQev6Hvc+iava1Q8hi5t2avV+0opMyAVlBHEfsIFMap5RDFPF0kofir0pXjvxj0uT94XXKe3nftofAEfyfe4f5oHBlOe/DVBnF6zo8tBEy5nmc1mPbG5YidUSGSPTW5N5pz/wW5LB8fCjTFBrqkHkg10MXv4nFD1sAsrzKtSq6vo583XebLOlwqeQeaiWKELVqmnOB0VMXz19vRdM7oadU1oKFtRIZUOMAkl8e0gW+XTSqijnPEMDQ9y/lnq11PimqOzU6U3oagVWU596AXx43+fb8tg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199015)(66556008)(54906003)(8936002)(6916009)(316002)(66476007)(52536014)(66946007)(76116006)(66446008)(41300700001)(4326008)(33656002)(83380400001)(38100700002)(107886003)(38070700005)(53546011)(186003)(9686003)(86362001)(71200400001)(64756008)(122000001)(7696005)(26005)(55016003)(6506007)(478600001)(8676002)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pnxACsoeKabCOZ0tZb8Kqxg2S7t01BNkpONsmL3uEqvy/rd/QeFhmRlin4+C?=
 =?us-ascii?Q?nvpCu3G6Z2KsHk9e09gsYtOSs7sSeYbYK5ke/wVL31HPwlUYH90eatWWeO0w?=
 =?us-ascii?Q?OXdO9f9NKczA/xHb8223/S2LOnSjCWsRshlwrRbAqobOzaPP2NUmNnF5SXrt?=
 =?us-ascii?Q?2v/z787KPaDr3ncg7z0kM6+SXzCmXbgwVSx7H5JIgoTcAfuutG1v/9LnRtP/?=
 =?us-ascii?Q?gCApBuwCQwI/3QyxIZi7EAllRY6qmdkeU+6rx3y4RO+jy/aLIrCnX+cQ3jOl?=
 =?us-ascii?Q?qaLfP5IGdfb8NPB7D+QW2ZOPwY3nkMf7rgt7lAV5ngmAq5VCrOOFhvUdg02L?=
 =?us-ascii?Q?J+5lrArN6Pv2H25+zd8hoJqbNaF/qq4cCbU/qCKZdDk/Yh9Aot+ulgTL+Izs?=
 =?us-ascii?Q?ZN9kFhBhqelucaFK+ZhxUrNTFY+538LfQwUVfRCKE2PybGn/SrAl15zbnSqJ?=
 =?us-ascii?Q?iaFIN6+GyekKCRn6XECx/UNYviM8EH2Slh3Ct7s2x1u1fmOPqFXDG8dNwtRj?=
 =?us-ascii?Q?GtCXolFJmjIvLiCRGzTSWBInPXfAa1XdBbQN+8zNthUFAQEZrX5Q021JN/I0?=
 =?us-ascii?Q?7REN/HST0qwMZ6FfZ6H4OvdiDkj6Mczj6xEPEIVjKlmu9+CwW1bej/zugnlO?=
 =?us-ascii?Q?HNcFj2C4U6KjP6NtcQficLJ2uC/4ub8rxkGrwu1PsAUvPROK7eUMJeLmf+DA?=
 =?us-ascii?Q?G9sMkYGm2Oe6XZSCogBpSO3tgZp85d8qbCzgEDq6LeEFkpa3HvgDq88RrLCb?=
 =?us-ascii?Q?riksJp8zmYQPi05ijHjx2tb7+T5N7du3OiTvBK3BTEALggmydiaKir0iQRUm?=
 =?us-ascii?Q?MqmNSA1JEIayKi5owAVv3GjXSLkMj/KivvdFG2J2zLFjbWamQcQgB9RyVTwz?=
 =?us-ascii?Q?7ar3KjNEDXGb0LSaORDQtTP/JMu94fuk2mwC02Prl4qhcpIMlb4NN4SNBVuK?=
 =?us-ascii?Q?lFSvdaye3XPPLXZoTnnThpTrIBC8dNMYY3mRcrwNSoD0Mxs+oDyO4TiqC4ED?=
 =?us-ascii?Q?YOXER14KaKnnC/+ks15tV3uzvnEVRR78czcZP1wN1dohLcu8y0WZ+DyCj45X?=
 =?us-ascii?Q?5OE6nva4ur6MMuqE/iFTLz6o2F5366/ntNt/ZhrgmOVfnOWOXc7zlx55aRjN?=
 =?us-ascii?Q?TBMkmRseg3LrnDc1T875NmN6a/Uq4vRe/tHVpIVeZ1+umohb1py/i+Uywcha?=
 =?us-ascii?Q?Z8x9zaaREACqu9V4E2xuOuAdQQHg8IGxr1Klxj90cWqLXGrHYusr8ngrwBnP?=
 =?us-ascii?Q?OI2Cf/K0c3NUxmZmtnbDDmBkGKLRbKnuC1IdKI4//F83PSiV1ow9gQLrtDfc?=
 =?us-ascii?Q?0qpUAbYe6apBHXpbWl2/3IWWo2TxRXYhGwiFVEwcPs7rLjd126qZqi/EkzAH?=
 =?us-ascii?Q?JO//ZGec+SoAyg+1ocZJEcjSKHG4cuXRVNcST86vAg8CDQkHl4w8HkadlT7a?=
 =?us-ascii?Q?P7mZ48605Pb8XOEkomqieHcwDvZUd4Xd5cEa6USiE9qDeyLsqJDBKlWAM+ix?=
 =?us-ascii?Q?+lo/mPl+YOzV99q7dFbG5P34e3oFvMvV/iXfi8sEtVPsTSnFVcPyce19c1oE?=
 =?us-ascii?Q?JSCs18DAW8osrneoYDeGk7K+QCCnJegUpaxUjMcTCL4jayNBv4DtI5gLUamx?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d92b0c6f-76f0-41df-7ac2-08dadce67b17
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 08:46:09.1602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zLNBlx4nREWy5bpfX5MF7eHCFSCejHLBrOAGQ95dHCsB2nj7EVvJcu+G4YzhDkfIEMa7/Z9yw81endf2pytwFSnOhXzRC7jWlVgpQPfpbEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9791
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Shimoda-San

> -----Original Message-----
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Sent: 13 December 2022 08:37
> To: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Biju Das
> <biju.das@bp.renesas.com>; linux-usb@vger.kernel.org; Geert Uytterhoeven
> <geert+renesas@glider.be>; Fabrizio Castro
> <fabrizio.castro.jz@renesas.com>; linux-renesas-soc@vger.kernel.org;
> stable@vger.kernel.org
> Subject: Re: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
>=20
> Hi,
>=20
> On Mon, Dec 12, 2022 at 10:54:25AM +0000, Biju Das wrote:
> > > Looks It is a bug in renesas_usb3.c rather than this driver.
> > >
> > > But how we will prevent hd3ss3220_set_role being called after
> > > usb_role_switch_unregister(usb3->role_sw) from renesas_usb3.c driver?=
?
>=20
> Normally that should not be a problem. When you get a reference to the
> role switch, also the reference count of the switch driver module (on top
> of the device) is incremented.
>=20
> From where is usb_role_switch_unregister() being called in this case - is
> it renesas_usb3_probe()?

Yes, that os correct.

>=20
> If it is, would something like this help:

Shimoda-San,

What is your thoughts on Heikki's proposal as below? It looks good to me.

>=20
> diff --git a/drivers/usb/gadget/udc/renesas_usb3.c
> b/drivers/usb/gadget/udc/renesas_usb3.c
> index 615ba0a6fbee1..d2e01f7cfef11 100644
> --- a/drivers/usb/gadget/udc/renesas_usb3.c
> +++ b/drivers/usb/gadget/udc/renesas_usb3.c
> @@ -2907,18 +2907,13 @@ static int renesas_usb3_probe(struct
> platform_device *pdev)
>         renesas_usb3_role_switch_desc.driver_data =3D usb3;
>=20
>         INIT_WORK(&usb3->role_work, renesas_usb3_role_work);
> -       usb3->role_sw =3D usb_role_switch_register(&pdev->dev,
> -                                       &renesas_usb3_role_switch_desc);
> -       if (!IS_ERR(usb3->role_sw)) {
> -               usb3->host_dev =3D usb_of_get_companion_dev(&pdev->dev);
> -               if (!usb3->host_dev) {
> -                       /* If not found, this driver will not use a role
> sw */
> -                       usb_role_switch_unregister(usb3->role_sw);
> -                       usb3->role_sw =3D NULL;
> -               }
> -       } else {
> +
> +       usb3->host_dev =3D usb_of_get_companion_dev(&pdev->dev);
> +       if (usb3->host_dev)
> +               usb3->role_sw =3D usb_role_switch_register(&pdev->dev,
> +
> &renesas_usb3_role_switch_desc);
> +       if (IS_ERR(usb3->role_sw))
>                 usb3->role_sw =3D NULL;
> -       }
>=20
>         usb3->workaround_for_vbus =3D priv->workaround_for_vbus;
>=20
>=20
>=20
> > Do we need to add additional check for "fwnode_usb_role_switch_get"
> > and "usb_role_switch_get" to return error if there is no registered
> > role_switch device Like the scenario above??
>=20
> No. The switch is always an optional resource.
>=20
> Error means that there is a switch that you can control, but you can't ge=
t
> a handle to it for some reason.
>=20
> NULL means you don't need to worry about it - there is no switch on your
> platform that you could control.
>=20
> thanks,
>=20
> --
> heikki
