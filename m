Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE96D8FB6
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbjDFGux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbjDFGuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:50:51 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2120.outbound.protection.outlook.com [40.107.113.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008AA8A55;
        Wed,  5 Apr 2023 23:50:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K779qQHtv217ig/+689Lxly+FMXnXHbIOqJk+m8R46cOu1l1Oq1Xm3ZEuczRE9DNJ0tOFR3NPoibUs+IyH9OYN40dBcm6EBz4+QT3Js9yL3ModY9kebE4HRqzkJ/h34I2YcsPl/1Cq7R0USDdR0XkvR3ocRTLDXYwBJfitmAiju4ILnTZCHn6RDsKuZd7P6CMwz2OfdNqcRqcPnQ3K8o88M4RgeBBtqRZHV9R7cXet6kgf1+alLenBU/I/Z1G/GTs/m+ggxQoeCmhhdvFhN7bwNrNpPPpTVdTmveWXzGpu2LwR88Y7QVHTiz/gQ5EC4/qywyfVdTEBONsEnFyjhhtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lM7oDe8qhxOnkfdEc6M4QNWfAur0Ued0NakMErDtZAk=;
 b=GSvsgBZ7pwLEammogoNUDzLwsaoBwDvqo+OPwffxrOqpQe0QSert3KLVsHbiv+bjQ2GezNLq3axEOyDO9nf3NqIrAAPs5e32yN24ZfuXs23XyrJKin8umJJWb6Qo2XjpOIK3s9OnEOHVUzPRIGsHmrf9LdytE9Wv+omchFhMJraV2WR4UAD/VNS2nMSf5fIsU24A5agxKPm11zubRVNc3+jKeeBSKlRYhfr9lU3fQSTCdjnrA/V+B4hl34bqznpSId4xxdDVYsW6RKUswey5Y5P71w93PyerZbUV+7DlKgnFRtSLnouDmXCHFoXvqpKkzuVIFeQFZ2gpKGKwwsh9Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lM7oDe8qhxOnkfdEc6M4QNWfAur0Ued0NakMErDtZAk=;
 b=lGOTZ8i5Wha4ZJvBKFgClbqbqNnwuw6d9TDmOXl8K7lZ+SOwwbUCHEhWgy2XlreQY1a8nr9/4zoJOL3bGIVFgHej+0GBXeNGdonMlQWkqgSLBjB0VzpIk+Gt9yCCE3mlbejzen2w3+pWSn6hpqoYx9jTkm4dcaIhva3wwzv070E=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6023.jpnprd01.prod.outlook.com (2603:1096:604:d6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 06:50:47 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6%8]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 06:50:46 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Jiri Slaby <jirislaby@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v4 3/5] tty: serial: sh-sci: Fix Tx on SCI IP
Thread-Topic: [PATCH v4 3/5] tty: serial: sh-sci: Fix Tx on SCI IP
Thread-Index: AQHZW+sDTp56XJCyOUCmMvHLJFxxba8d7uaA
Date:   Thu, 6 Apr 2023 06:50:46 +0000
Message-ID: <OS0PR01MB59220B26E3627CF3EFC94D5E86919@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
 <20230321114753.75038-4-biju.das.jz@bp.renesas.com>
In-Reply-To: <20230321114753.75038-4-biju.das.jz@bp.renesas.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB6023:EE_
x-ms-office365-filtering-correlation-id: 3fe8518f-89fa-4435-0169-08db366b401a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 14cshgBlBsPTiAFB3hdvoh8M6HAhrycXz1uJ/1U11DMlMr3Kmqa53OGnNLWmEU7m6zzDXPsC0jOzJQg8bZirRe3xj6Y4JI0A5wAIJnMuqUDOcg/CUJJ28Q2d5WHaBtJKQABQS49K9/4QKQbiADbHHZ0yAyjtMbKp/oUNWdlrmw/Nlqt/OGCwO6ErVDSa43JhNinVwZUPxmZssSLYwPLl8fZOB4SWCnGR4kuU86ipBQp+2dWz5tvAYkHjuG5ewYITkf3ESS6M+2Mppmj2aGRcvueGpls9dnXY54DSYXL92yTbJjXFoPjMuE04N1sgU11v1Lpyv4vY7bdCe6nekwZ3WR8k9bNcpftdM1/tpCJswj1EBthxV8vD9xU63kdzwyS2+iV1xi0d+B5FEIb+DXBN8LxQXd24ilHQGXvUdRhMaozXZnMmYeQ4UH4EyOlPFMvPKJwKoKoiC/uSmLIRqtJw82Qydkvo22lglFToAd6Moq556UK6lZ2ytCdXbZbelIDUGM/Yw2vjdjJTUG5R5LA/G79SiDHe2jXemb0K5rpe5Aqs0hYNXvlPYNKTd3SV3J37ib0mk8bBWqKkShkjraHaj3Z4UyplBzwjS59lqpaG1zn6feLTGNkytZ2S7QZ+7NVcX9WAQBCf6p+Uzrk3MxY6gQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199021)(4326008)(8676002)(54906003)(64756008)(966005)(316002)(66476007)(66446008)(6916009)(66556008)(66946007)(76116006)(41300700001)(478600001)(52536014)(7696005)(8936002)(71200400001)(2906002)(5660300002)(86362001)(38070700005)(55016003)(186003)(83380400001)(26005)(9686003)(6506007)(38100700002)(122000001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sjD9x17OrsWc25fcVqUYQJylA6BQY+1TnqI6zS+V8vLVu5y4oicF7HHHkFA/?=
 =?us-ascii?Q?RZDSVO6BcpY6HAIhabtkEs7tY6hKA5lN4lTSN2arVGi6qqP+mHvh6p15KvvX?=
 =?us-ascii?Q?cZD1F2hgV+K2c3mpDtI4kfbTEuYuGF1/XXi7rkiVa0QDpfFI4SmekCCcWsIw?=
 =?us-ascii?Q?UA+AX+kMRgtEqKSYIHZZV/oswr8sm5uyfoVXYEDiCR297cL2lLTtrgjCACqD?=
 =?us-ascii?Q?BQO8MrFzZ7Wc6XufFgfaHUKHQonikafA5Y6evtqighMGq26BROqO5I3VVcbp?=
 =?us-ascii?Q?KshfY/v+wcSUM1ngR09v8d0RB4p5WO3Vj/ya1iBLOIXDhXFSdDeVldCroRt/?=
 =?us-ascii?Q?2qv4hX4788gAiRQ0rcPFdTWYXNija/PmqrAtJi/wuAFQQqr6bOstWVgl/aIP?=
 =?us-ascii?Q?SEiaf6nfHzay5iXAvUnq6aIzhyjdy3bmkBjdrmozLBd6N1CgCX1ipETig8je?=
 =?us-ascii?Q?r7Hz/lnuimOmoc+Cb2uB6Z4x2fazAPOYR9k1DJkJI891IErwJyzh7eJ9XcQT?=
 =?us-ascii?Q?6pkKXeqn2Vl/sPfJEZG4UuFBu6CCo0zxwKwu0EbRJHnXJp4l0PeroGcomupe?=
 =?us-ascii?Q?CoCj4G0qmrliTnDsP2mtvxirFZZdBaE4okXALcgHw7YellR/9opRSbpsrX1Y?=
 =?us-ascii?Q?WZS7bk+VXg2yfxpL3P/TBLNYyixRWjhVW2ToxCKLqzAKTgxs5cZwUSZIR7OW?=
 =?us-ascii?Q?Z8t2iA8uMKSAKaE2fX1s37gdnnol90qJFWT+NB+mXYEmPuGyCRaBvu7aPEVW?=
 =?us-ascii?Q?VGN66pt3OKWcjKoC7kgT1lGSbZJ5fSoyjIIxhltbYHIGOrHuFhp5th0yBiFS?=
 =?us-ascii?Q?q+DDwWUILX4v1xMAdaqI/ngzsURgEpB+cNZJ540qseoJOlQi+KW3MrQ7xLIY?=
 =?us-ascii?Q?3KHB3kZ+a5PmRl2qD7PzCbSAotSYSI6Sos/nIJyCjzuefVS0CFGwXiEoWvNY?=
 =?us-ascii?Q?pkBIN4pSyrj21GS14zjOH5tcAbRV0B4M72Zqs0c/zuxyZu2aw1q8otQmkLFe?=
 =?us-ascii?Q?LrD7OdgI7asbXzd9kNlcSpbbC9f8kqbrp8zpXU2eCzJL7regYYk9pSDYsOri?=
 =?us-ascii?Q?PLzT4pu2AyJnbIBPlamy01Xbdi6YcWWfYxr5fsEKRd/R++12ifc7YnQb3y5P?=
 =?us-ascii?Q?+xdGcahdM5PjpkqI6MmHIExGbCziJTkBA75f0QTCO1ThDxSSh8SDMM6usR4k?=
 =?us-ascii?Q?EKA6YfRtCc5IBAzRV5fjU+3odTHNQNMuP7U+ns4MihYEo5Rep3fN6xfdg73Q?=
 =?us-ascii?Q?5MG8WsCKBIFemqs/mP1Ljzfj2tRoQs0q7z98jzqlDNv2wzpEZkNOcpdOIMEZ?=
 =?us-ascii?Q?Mg2rRsDG50woN+ECIuVjXT4wbg8r95kR+JOjBazqg3HerSVJ7AyzkXk6cYAH?=
 =?us-ascii?Q?IzqrSxmATwn7iGGR49k1FTL9EgrZ4nC3mehNR7F0EjI+QV7MXRDi38ijCp8y?=
 =?us-ascii?Q?Zfkp6+HlA0JQ0nnWvYPROMPrdvZC1bLhiyUFeXAwARsa06NrPIC6yKqbK9B6?=
 =?us-ascii?Q?hq5TZCkKuuuQSRDwSpF3giICLXpkxEo9F3ISKr3Nra1BJnoXTRFHWaufJFh1?=
 =?us-ascii?Q?iIDlH5l0yIrWDCXHCOwxc6jp8qvOioIi2SzKi1ss?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe8518f-89fa-4435-0169-08db366b401a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 06:50:46.7866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mRhOLqYCrOk49K0MNj733t2Ln00aqRmGkK2lY6zxnY6wG9jbA7iL4TfBqoLxyZ4VV7FnnpQzM2xwJ7lxX63Tn7yRlut6ets7fiUwQZAaCdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6023
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

I split this patch into 2([1] & [2]) after fixing commit message
and merged with the series[3] to avoid any dependencies.

[1] https://lore.kernel.org/linux-renesas-soc/20230331113346.170602-4-biju.=
das.jz@bp.renesas.com/T/#u
[2] https://lore.kernel.org/linux-renesas-soc/20230331113346.170602-4-biju.=
das.jz@bp.renesas.com/T/#md8ae156345aed10bdeba764dcf2253f00b02e38c

[3] https://lore.kernel.org/linux-renesas-soc/20230331113346.170602-4-biju.=
das.jz@bp.renesas.com/T/#me7f60560fbf24bf361d70ccb6ba223e92a60de9b

Cheers,
Biju


> Subject: [PATCH v4 3/5] tty: serial: sh-sci: Fix Tx on SCI IP
>=20
> For SCI, the TE (transmit enable) must be set after setting TIE (transmit
> interrupt enable) or in the same instruction to start the transmission.
> Set TE bit in sci_start_tx() instead of set_termios() for SCI and clear T=
E
> bit, if circular buffer is empty in sci_transmit_chars().
>=20
> Fixes: 93bcefd4c6ba ("serial: sh-sci: Fix setting SCSCR_TIE while
> transferring data")
> Cc: stable@vger.kernel.org
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v3->v4:
>  * Updated fixes tag.
> v3:
>  * New patch
> ---
>  drivers/tty/serial/sh-sci.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c in=
dex
> 15954ca3e9dc..bcc4152ce043 100644
> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -596,6 +596,15 @@ static void sci_start_tx(struct uart_port *port)
>  	if (!s->chan_tx || port->type =3D=3D PORT_SCIFA || port->type =3D=3D
> PORT_SCIFB) {
>  		/* Set TIE (Transmit Interrupt Enable) bit in SCSCR */
>  		ctrl =3D serial_port_in(port, SCSCR);
> +
> +		/*
> +		 * For SCI, TE (transmit enable) must be set after setting TIE
> +		 * (transmit interrupt enable) or in the same instruction to
> start
> +		 * the transmit process.
> +		 */
> +		if (port->type =3D=3D PORT_SCI)
> +			ctrl |=3D SCSCR_TE;
> +
>  		serial_port_out(port, SCSCR, ctrl | SCSCR_TIE);
>  	}
>  }
> @@ -834,6 +843,12 @@ static void sci_transmit_chars(struct uart_port *por=
t)
>  			c =3D xmit->buf[xmit->tail];
>  			xmit->tail =3D (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
>  		} else {
> +			if (port->type =3D=3D PORT_SCI) {
> +				ctrl =3D serial_port_in(port, SCSCR);
> +				ctrl &=3D ~SCSCR_TE;
> +				serial_port_out(port, SCSCR, ctrl);
> +				return;
> +			}
>  			break;
>  		}
>=20
> @@ -2580,8 +2595,14 @@ static void sci_set_termios(struct uart_port *port=
,
> struct ktermios *termios,
>  		sci_set_mctrl(port, port->mctrl);
>  	}
>=20
> -	scr_val |=3D SCSCR_RE | SCSCR_TE |
> -		   (s->cfg->scscr & ~(SCSCR_CKE1 | SCSCR_CKE0));
> +	/*
> +	 * For SCI, TE (transmit enable) must be set after setting TIE
> +	 * (transmit interrupt enable) or in the same instruction to
> +	 * start the transmitting process. So skip setting TE here for SCI.
> +	 */
> +	if (port->type !=3D PORT_SCI)
> +		scr_val |=3D SCSCR_TE;
> +	scr_val |=3D SCSCR_RE | (s->cfg->scscr & ~(SCSCR_CKE1 | SCSCR_CKE0));
>  	serial_port_out(port, SCSCR, scr_val | s->hscif_tot);
>  	if ((srr + 1 =3D=3D 5) &&
>  	    (port->type =3D=3D PORT_SCIFA || port->type =3D=3D PORT_SCIFB)) {
> --
> 2.25.1

