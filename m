Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13DD6131AD
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 09:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiJaI0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 04:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJaI0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 04:26:37 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2101.outbound.protection.outlook.com [40.107.114.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2323E644A
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 01:26:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jkk9NUcuHIiNO3FTBgOMLAJIdRlvGRL2+bbBI1l6WUzCeho/bFjRFp2gomYkoasCR0MbnD5MrxHSiKfGp1eiUzizpyFRtQfJfdVYZYmnfI5ZOtmE2KU4ioNj1RICzesEIRZXLNjbmyB7LZsKoWNRsNAVHyW585De3czmr/vX7xGxw0aLYgEqSlaYxJa3mNrrad8AcH6QAxWj2wOaqo/PARkaVGHEfLeTGMdKOoQaiHra4ahSMW7XA2SDKYPt/XawbKk2JH36d9D5PzcceenUGdpkFe+7l/bZOSA/vwQAMIAUHRzWVVhuzR0093JB8Znvx5a7mHq/1rWX9RQgppwHhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NP0RIadRz3bbai61N0ucBtU1AohBFdnHRPEzJQrDtN4=;
 b=JFNVf86D/JVswvxkI1MBZ3KWwvuIKizYjCjBOLZkgaaYvAJTa1M2UQW15eBFAJ05W8kAaRdz1nKaMiSwsaTGZVbXMzkVtfMEd+wp+qGw44oQUsQ+dF4Y1YggEZ/NhFb3ovFEWy0ff5Ikv1RfY25qeSPoH0N0ODPfqPW+HNOcqAlZg51pBwAqCfLa854cBi0rswqvNBOeVWk/lMdlleijzn6Dn+wCL4csJYEUxKW82oN8So9lic93btxGH2kob1TCmOvTvP+Lru6obi2cAtG9jbH19u/fgOZmPmtUesRoW8a0VgaFmRl4o1vIciWZlyNTQVssJPTSVhacrQFIhOwXMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NP0RIadRz3bbai61N0ucBtU1AohBFdnHRPEzJQrDtN4=;
 b=Zl4cTgg39eNEPqzzHMKhMNun6zB5UaPGMP4kMRi8UcFiu8DjKcNhIW+lMys2Zu4XfWern4thg6ay50Y/+3goYzzB4dKwx/An/4GtypXjKv0GyPciRXcoY3g8Aa22ZqBHh2NRZ8GrCC6FOgha+tE2xa9f/4RkunUE+da+Gs9SNVc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB9759.jpnprd01.prod.outlook.com (2603:1096:400:235::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 08:26:33 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 08:26:33 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] can: rcar_canfd:
 rcar_canfd_handle_global_receive(): fix IRQ" failed to apply to 4.9-stable
 tree
Thread-Topic: FAILED: patch "[PATCH] can: rcar_canfd:
 rcar_canfd_handle_global_receive(): fix IRQ" failed to apply to 4.9-stable
 tree
Thread-Index: AQHY7OnAJ/01wSwUF0SF6iKB3abBNa4oKrEA
Date:   Mon, 31 Oct 2022 08:26:32 +0000
Message-ID: <OS0PR01MB59226F2443DFCE7C5D73778786379@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <166719420910145@kroah.com>
In-Reply-To: <166719420910145@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB9759:EE_
x-ms-office365-filtering-correlation-id: 32d6291b-be76-4db2-0f52-08dabb199e47
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QCyMmykpzaBnsn886XODxxAqe5GR7UxdgLVc0XNCeXM7qbRaQU89H6r/P9C5VIWXr46hcb4lx0GDy4Z2tinGSrzcYxPxjQmS9m4rIvMG4n60iy/G3PVfAQUS1Zbj5Oo/GdHvIiSWUVl2fuAQt8wKv7TTAlT2dplWgZjU0tkmpXhW/56UTNd3riA+ale3zm5LCncQziKjAlChsAVPzCTykD+qyELk3EmekXY6KeuEGP2L0Mfowa74LZqr+Fp0C1KVo2sYiAZ5AvpXQIjOGH3bgE4NwMtLFywtFVGpBsp/9dptEkwFEixZYE06GM0JUoQmW6wkOnyasFtL1+yYULD0e20EjToaGREupxUxyEzSq24Xt+Uxgq7sN/4hqPX81alS9V6ZSYCfCJGLoEKiipiTMSTHZsKyrafs9aJVoslCiruD3mkcH4IsH9butAYrzWhzyABUpAzbQOQvrS2MertRaqs9eoDhRQvV7ODvc66r26O8pSHZraFYF+fcRjhp2Z93sQiVn7AgM0zSs60q9rw5WdWLj8KhknD67FG75+dtYhRAqESuofKckzFLccYrgpNtvRg14dFt7jhfcNFkiDTM6E2PnLNX5PStUpCcIoJaew36zjtWzeM8gBZB+8ck4znYHBTffftwsG+IM6DPoRIdnbnctA1O4YoEShFQiCkJeCrFDzKlyLrgcdiBINeaP5ugK4MV/lxOHElfDl9/UT54nCeoH3xMef+dnGdskuFUyxxoBMhXCAdZ7RG4VYHX5mdQGdi4ND0AmXH/N54d+o0Hvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199015)(55016003)(7696005)(110136005)(316002)(53546011)(76116006)(4326008)(33656002)(8676002)(6506007)(66946007)(64756008)(66476007)(66556008)(66446008)(83380400001)(122000001)(38100700002)(86362001)(8936002)(26005)(41300700001)(9686003)(38070700005)(2906002)(5660300002)(186003)(52536014)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3Y5MKniI3xqZP1ceFChGzfTJIrYGqtnY7iBHDPCf4TxVzejH0ymc6VhRbe52?=
 =?us-ascii?Q?ZgJwkBbkd22rNefweTVW83vOpnTRU3H8IWae/C+tVJLrkCs7Ju61cyqQkjP2?=
 =?us-ascii?Q?9xTMiOKFx3kpOQDCzXrN8qoNePyG5V2LZ8cATM1iahrRpYqKq/AN2kJK4Ljt?=
 =?us-ascii?Q?UmDl9X8zDYqN9SHv/Hnz8tWJ1rN9AXnngZiwsT7iAfbwb7NOB9b34D6AcVv8?=
 =?us-ascii?Q?Hcv0GTFvQ7E9uok3qmkx6x+x5jDH8i1CI5v5b1hEGBzmh6SVSUgS3KDAEUYp?=
 =?us-ascii?Q?yzNc6aY+5i29R3zY/PciuzihI7ylDj5dU5FL51PxMgzxieQmQqsuaTypMf18?=
 =?us-ascii?Q?zFr78/GepAb4OhsQ4EhqPB65t3Gr0/7y5K/2KssdcMnAckJBXsguNg/j2Plq?=
 =?us-ascii?Q?FfkzchZT6Wg2l6jFNCXKZOmw5YU0hIpeYXUN7IuAkdwcusx11LTvJ9HgQXWD?=
 =?us-ascii?Q?Hng0vlGS3FD2HifrLZAWuZt8E5sRnObFi1J086X1iSgG5lxskuQjYk4azMJ8?=
 =?us-ascii?Q?oExUAvZic000l91IeXu/FpFo4vQddStAF5+gvSXuO/Chn7b30YY8ctSx8opz?=
 =?us-ascii?Q?dzztLCQ8ndKLIgzJlaXA/b/mGA2lxXB5aO8Qvw41OTa0kKDN6QQSNkQJyViS?=
 =?us-ascii?Q?enJXVpbQdf7bKrxuHomk4d9i6CxiA+v4D+ptWOmYoL/N6WrbUZ9w1Qk+MxVj?=
 =?us-ascii?Q?dVmus6ibFRLZ9IlG8QZEuUVggAF9zKq1dnxFhN71HuMVMgG9wu34249MeG08?=
 =?us-ascii?Q?rqbq/pWaz8/MNIeGadgTPmC+UQr7bFS9Z5EMcu3NuFJLL0z6dTZMuWjjmmSM?=
 =?us-ascii?Q?AVxTqQv4rRLXXxh7jPDyG5Qn7iJJWSCuQp6camdqJKIS/mYXTAFVnjAqeYiZ?=
 =?us-ascii?Q?PPXi+cof0HtBRL6vIV0PVbG3ZfsR5xUvU78yqQWqZdaOKPuzFEmKHsXLAg22?=
 =?us-ascii?Q?WJfcCY8oR5MM9AzfNyP2nc/4vcJ3x8ldlXb4jWoNVMI610trM5IgzUrq3vVi?=
 =?us-ascii?Q?PGxx8nHDuydX6+G1LU+ZJMdPnTkwifhX3sERH9D4U3HZAjlP79Edut9wVfmN?=
 =?us-ascii?Q?HXwAVvQsf0+u9SPpZb81p/tdQvLqubaHH9Jrfgs4xi3DxzIbwyEXzN3QMHQP?=
 =?us-ascii?Q?aFw+olRcG6NBJQNgWGLWz5r/vaPNuc8OeV0h4ftXlfcIWgZFTTxuLrEvT43N?=
 =?us-ascii?Q?rlCm7RAKaHRqye1d93XBnwVyn75ggZQcvlQGFrZlCElohabSEqs1SIbMnUNY?=
 =?us-ascii?Q?UgjTwGKfgI66+4eE1cyL7xlJUFans65ZpNuQydixTTQ4vdtcsaSS9zKs2qBU?=
 =?us-ascii?Q?0KpYaYoG1xmMetmDCqhiBMzj29+Q1gwbcpWR1vhhbUIT2v67hXhICKteRiyN?=
 =?us-ascii?Q?tylL0Tibvq9CrLe3dnzlBLRdfCv7tbA5SbAIRFG02aW/e+opUFBwu3H0nfoe?=
 =?us-ascii?Q?ExmrZSysd1negq4vFEL+iL6DZEPygH3QjfD1axkNClezu4xgEuoh79OoRyNh?=
 =?us-ascii?Q?ILHio9PDqVpKIotnw4cyg6NR4fKf4KXM2Mym6p5LumbuxDG1baUJ2asHALxY?=
 =?us-ascii?Q?DBoluXSUvA9p8b6Z8emjuplKot7k7M8mO52Nku4F914ehPHhD7BrpkrOWlFj?=
 =?us-ascii?Q?xA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d6291b-be76-4db2-0f52-08dabb199e47
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 08:26:32.9911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8H+lYjS4za+JWyAb9TVV3gMMY4DfuJL8Ye0mb6unaP9xj07EfQPqAv0lhNj1EBf267hE72iX7DfPIycj7Lx5sedx8O6bG0e1jIzS0/iCzvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9759
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

I will send patch to 4.9 stable after fixing the conflicts.
Similar for other failed patches.

Cheers,
Biju

> Subject: FAILED: patch "[PATCH] can: rcar_canfd:
> rcar_canfd_handle_global_receive(): fix IRQ" failed to apply to 4.9-
> stable tree
>=20
>=20
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git
> commit id to <stable@vger.kernel.org>.
>=20
> Possible dependencies:
>=20
> 702de2c21eed ("can: rcar_canfd: rcar_canfd_handle_global_receive():
> fix IRQ storm on global FIFO receive") 45721c406dcf ("can: rcar_canfd:
> Add support for r8a779a0 SoC")
> 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
> 13dfb3fa4943 ("Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 702de2c21eed04c67cefaaedc248ef16e5f6b293 Mon Sep 17 00:00:00 2001
> From: Biju Das <biju.das.jz@bp.renesas.com>
> Date: Tue, 25 Oct 2022 16:56:55 +0100
> Subject: [PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive():
> fix IRQ  storm on global FIFO receive
>=20
> We are seeing an IRQ storm on the global receive IRQ line under heavy
> CAN bus load conditions with both CAN channels enabled.
>=20
> Conditions:
>=20
> The global receive IRQ line is shared between can0 and can1, either of
> the channels can trigger interrupt while the other channel's IRQ line
> is disabled (RFIE).
>=20
> When global a receive IRQ interrupt occurs, we mask the interrupt in
> the IRQ handler. Clearing and unmasking of the interrupt is happening
> in rx_poll(). There is a race condition where rx_poll() unmasks the
> interrupt, but the next IRQ handler does not mask the IRQ due to
> NAPIF_STATE_MISSED flag (e.g.: can0 RX FIFO interrupt is disabled and
> can1 is triggering RX interrupt, the delay in rx_poll() processing
> results in setting NAPIF_STATE_MISSED flag) leading to an IRQ storm.
>=20
> This patch fixes the issue by checking IRQ active and enabled before
> handling the IRQ on a particular channel.
>=20
> Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD
> driver")
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Link:
> Cc: stable@vger.kernel.org
> [mkl: adjust commit message]
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> diff --git a/drivers/net/can/rcar/rcar_canfd.c
> b/drivers/net/can/rcar/rcar_canfd.c
> index 567620d215f8..ea828c1bd3a1 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -1157,11 +1157,13 @@ static void
> rcar_canfd_handle_global_receive(struct rcar_canfd_global *gpriv, u3
> {
>  	struct rcar_canfd_channel *priv =3D gpriv->ch[ch];
>  	u32 ridx =3D ch + RCANFD_RFFIFO_IDX;
> -	u32 sts;
> +	u32 sts, cc;
>=20
>  	/* Handle Rx interrupts */
>  	sts =3D rcar_canfd_read(priv->base, RCANFD_RFSTS(gpriv, ridx));
> -	if (likely(sts & RCANFD_RFSTS_RFIF)) {
> +	cc =3D rcar_canfd_read(priv->base, RCANFD_RFCC(gpriv, ridx));
> +	if (likely(sts & RCANFD_RFSTS_RFIF &&
> +		   cc & RCANFD_RFCC_RFIE)) {
>  		if (napi_schedule_prep(&priv->napi)) {
>  			/* Disable Rx FIFO interrupts */
>  			rcar_canfd_clear_bit(priv->base,

