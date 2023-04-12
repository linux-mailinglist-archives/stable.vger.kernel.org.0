Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70486DECB1
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 09:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjDLHiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 03:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjDLHiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 03:38:50 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2128.outbound.protection.outlook.com [40.107.114.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC72F5FDE;
        Wed, 12 Apr 2023 00:38:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9W+pczFdaAcQl3lx4f+U/bmx1EulrGQ0zgPJVGaq2kqWju8SvFhjUiEOlk7zirHyHIhLKVaYp039Z0qCRUunUgOneXqf0yeSVIHg5cziJXK0sCeKQGeJSPnXJBlp38YxLqoJ8MYelQ3rwDNtO4WpchByF5DbvV1kmAk0AnntPqiInraZ8yAx6hmganWMBBBE9QpULLXoDmmKbaHneASXQ0iOIoQuOoKQvNopKaGKdmwMEb6MdirLhpUVHq6jQUBOKvf8rwLHSPQoZLbXv24eGM3WemF/2VMc4oP7BqcoFA+vy+pBsPkDuBhKxUwOxYjpjSIm3BIoLG10UB4TdwhjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwYt8/1aS/ud3/9oR0T+iTjzvKczjl9jGXvy8ZRjdL4=;
 b=c8ubMjlOmJ53Z9XgIO54pPtPXSOHXSc1Xu54klnHgcsVYNAHuQPBc7P5RDdlxe1P0oaUgga/9WMalCokthEEjX5/vokZGYussy3zpGJyqkZjn51fpJYnC9UjzUJRzZSLdVX9/pifqCnXBMRqC2p6OpRRkjtRPSzfCquWzM764gmHj4s18bi9KpqVQWS3xsMgtFTdu+GLW+rAg+6hO76Oyrf2kxGS5b5cBFeg/c55gXsfLcDltP83chKjU8MBgdBnnVuYlbvddztkVKi5TUx68+SP8kKlYOknxQ7Yp8J3SO6G+8wEm1h+oNhZzyQqgg3hBC4JGmWq+gtPxuig++BbTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwYt8/1aS/ud3/9oR0T+iTjzvKczjl9jGXvy8ZRjdL4=;
 b=kWxDoVgoyjs+EmOswfeUSS9lDhIXZNYqCI2GF/JbqPi30O4lXUopYr04Wao0ULn6XXLnIRsR8WFSWP1znM1LB0Wb/P/dpCXyFGgDUd2wJaaO5I367TO4LIYHUBfUX4Flf6MwUAc4GGkQnWSxIId+jfvU1KnxjeXG825NY1wxcAo=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TY3PR01MB10471.jpnprd01.prod.outlook.com (2603:1096:400:313::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Wed, 12 Apr
 2023 07:38:26 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6%8]) with mapi id 15.20.6298.029; Wed, 12 Apr 2023
 07:38:25 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Jiri Slaby <jirislaby@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 3/5] tty: serial: sh-sci: Fix TE setting on SCI IP
Thread-Topic: [PATCH v3 3/5] tty: serial: sh-sci: Fix TE setting on SCI IP
Thread-Index: AQHZY8SxDZT8DMgEvkiUPAFWgGwr1a8nWr0w
Date:   Wed, 12 Apr 2023 07:38:25 +0000
Message-ID: <OS0PR01MB592262FFD02CB9E095A057DB869B9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20230331113346.170602-1-biju.das.jz@bp.renesas.com>
 <20230331113346.170602-4-biju.das.jz@bp.renesas.com>
In-Reply-To: <20230331113346.170602-4-biju.das.jz@bp.renesas.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TY3PR01MB10471:EE_
x-ms-office365-filtering-correlation-id: 9d7dde41-d6e2-49dc-b445-08db3b28e6bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5dGF0t35xmHzBahi0LdjZGiN68i8M2PkbTu5PTEV90CcgI94W+VRA6CPAb2REjsZr5py5/NBWyv+RaLF0cn+M/5K6RRa7jTRnq7xYE9N1MmI6q6899UhcHgg/56eJd3jNymG39znyMcJy4ITTS5rRo/RaWUcbpQCZ5ryuC6eZTMqpu4r+7JRnI5gZ36y7ATJj7T95Ch/jQ9GqvUglpTlmsosiViKToKKMDnrAJ1/wsOFzBewLgR3MyL9GeGc7fLGgvduDfekhShFq3nqfDbJQcanpcNnq9YGL52LtiGw3p9kleUTzyNOv3lWUv15hzrcwAtqZo+6L2t6FLiQoynj2zqkQMoQ/NDMptJ/d6Udp2KX5qkdfd0SWjVeUDi499dISGkjwiTTLUJXA8NvVjXfYJQhz33hzIrxZRAK5V2FlQKpw9Z5m2CHAilPJIuvcbfgqNp+P5VNXunzncsbqiDZnd7JHii7VOMTmPnEQWM1ACIU99k/dK4Tdp+wKVxFMlifat8zOsfNGElMiP25DmJ2AvJ5Tnbqddshdda/OkokZZONWpCRqB2A1mWouIjbIKBBF3IPksX+eywMYJTviAp1buDxGcyO9AnKATyORF5FbIkHa94kCMgD4Skk+cpoVDJ9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199021)(4326008)(66446008)(64756008)(76116006)(66476007)(66556008)(478600001)(54906003)(66946007)(33656002)(110136005)(316002)(2906002)(55016003)(8936002)(8676002)(41300700001)(52536014)(5660300002)(86362001)(83380400001)(38100700002)(122000001)(38070700005)(71200400001)(7696005)(9686003)(53546011)(6506007)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UyG3zad5tYj1Vgj7gt8MWscB85icLs5jJcfCHtt30nbZjMeWUenohi+/5d5t?=
 =?us-ascii?Q?IQWPqV9J2IOVhNpWk9FQmdxjuLNqskUn98CA/1oRai+xxEgMq8yzP0omTUMY?=
 =?us-ascii?Q?cDr+24TDhSheYpK6Uza0J0lr85py1FmCUQHW7t/ZpI2Yt6FmsMzmtSFblkcg?=
 =?us-ascii?Q?8nEQcag3VZjPlkAzTt86M514IepiO/2OJZD/qwM1ctdlm/vY+8VSMkvRHKFt?=
 =?us-ascii?Q?wo8LR7F/LH+iFhnhpK6wgpLyxFhn46gsRZM6PF3LD8eEF+QUP7m6EHTdfYfB?=
 =?us-ascii?Q?EbOiXraKXSnDx0+qexMzXmolKsVG4siSs43wWKe3ocse0EliBVYDvLknwXsy?=
 =?us-ascii?Q?ydiNqH0ggfzMli9LC4qxjmJwW4UG2yJTq4x6QNjqVMfl6008QGha3F1wxnZl?=
 =?us-ascii?Q?1as4Ue0fyUsgJyxFU1GbQB/FNkkx/358ZxNcLyBsk9BdCMAS4ycYbFYBDEA0?=
 =?us-ascii?Q?d00O7KaZJ7T03T/3pCZ8VmnJa+tI0PdphNvh5OmR5YRdfgjjiDLfMQ1qMpSx?=
 =?us-ascii?Q?KFPlcqU+Cj8/8kVa+oI5otp5GGBKkGdc5fGqlX1WL/8EPcHc7sYiAhErzoV9?=
 =?us-ascii?Q?Qv8EtHNBAuz9p42SmYrIAHAH2tE3aIyvtxx1ro/umGMamfpRRGtvfY+4GYnl?=
 =?us-ascii?Q?4QZQG1x0VTFgTmdE5QRfYB4iOw6e4xX4wb9EQThSLpp7QTwuTmwD7DVOkqnT?=
 =?us-ascii?Q?wsU+J2o3oupr/GYg2zhbPm8nUN7ijl1MG9KhNr8X1/uPzrr087ja6OqX1BuI?=
 =?us-ascii?Q?LvhNGZsmqP64Is7PW8fYiu2uY/8btXm1MN3bQVsH9zxXGEmuQRDYx2b1sPHd?=
 =?us-ascii?Q?hajtslznaqv9AzAkcxSTWa0CUuTEluwjXFwl9OpVf9TM60IrRegKErvZWkmz?=
 =?us-ascii?Q?+U57iVOrWpjQc+y6Vj1WP0UAJsepJTWEU2ZAsf3mA9JPA2EvCxjrP7rPeHDN?=
 =?us-ascii?Q?pPVMhW4y0tdT0d4RG5D4ApBCe5z1nlS/IBvYjY43hU8j0+QS6Kr0n/IKuTSD?=
 =?us-ascii?Q?Rcz8GuQCwWkAIJ/KfwadKk4HFC2EmUcoLRYypvEGpAnCyfABNirGYKi4HG0Y?=
 =?us-ascii?Q?swHdIzxy1mt8r6d2clWIYdvY18BOzf/TYX01xuorYj6v5BN2hBHWBz4YbXKY?=
 =?us-ascii?Q?Cn2H03mTYiNpQ2YGaXR6/HcJA1KMroSKv01tyN8dud4/cUhsq/xgGA2DQp0S?=
 =?us-ascii?Q?Z8jXKzcHISZQAbJ2FAjzDDtQcpxHWCS5rFdYPgbhrAIutlX1uorcJOtHggfM?=
 =?us-ascii?Q?mzQ70Sea3xLZTOHEwmamt3B6Ed9KJLfQN3e1XdrbFTuCYr156gnSPHKT2rrA?=
 =?us-ascii?Q?Ojm95xSMpnuLX07/vEsZ1cMZzMQLx8CkORn96x8HJL4byoFmCu8QEHUTdesG?=
 =?us-ascii?Q?fwWknC6VxTfvfmPJBNXRfHNqJL2Ks2jVQ71oG1LtmU1MDff0o08NqkyFntZ7?=
 =?us-ascii?Q?KqzA7Lz/cWyy9eJ+TlSpdmcEReL4RQrIWjinu0NcXdseRMaeF/cMcb3BCtaZ?=
 =?us-ascii?Q?Q36XU3Dq9UD6Z9kjeTRBe6m2EHNZzun/7HzgivfqUDWyhasdqMp0V8AlEHE7?=
 =?us-ascii?Q?ef591w0FRsz5dU2fRAHHuhQKLHCvNI3qF2eBAVB1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7dde41-d6e2-49dc-b445-08db3b28e6bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 07:38:25.8581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r1r7YC3zajtVIrerVNaKIu86ZrWbfpSxV9KsmuJO2AmUWrbYLk1eT9yRvufKwPYE6mo/MZ40KBUf1LeGvR/muNKU8srKruet/eFL7lL9gkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB10471
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

> -----Original Message-----
> From: Biju Das <biju.das.jz@bp.renesas.com>
> Sent: Friday, March 31, 2023 12:34 PM
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Biju Das <biju.das.jz@bp.renesas.com>; Jiri Slaby
> <jirislaby@kernel.org>; Geert Uytterhoeven <geert+renesas@glider.be>;
> Yoshinori Sato <ysato@users.sourceforge.jp>; linux-serial@vger.kernel.org=
;
> Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>; linux-
> renesas-soc@vger.kernel.org; stable@vger.kernel.org
> Subject: [PATCH v3 3/5] tty: serial: sh-sci: Fix TE setting on SCI IP
>=20
> As per the RZ/G2L users hardware manual (Rev.1.20 Sep, 2022), section
> 23.3.7 Serial Data Transmission (Asynchronous Mode) it is mentioned that =
the
> TE (transmit enable) must be set after setting TIE (transmit interrupt
> enable) or these 2 bits are set to 1 simultaneously by a single instructi=
on.
> So set these 2 bits in single instruction.
>=20
> Fixes: 93bcefd4c6ba ("serial: sh-sci: Fix setting SCSCR_TIE while
> transferring data")
> Cc: stable@vger.kernel.org

I rechecked and the fixes tag is wrong. So, I would like to remove fixes
tag for this patch in next version.

Cheers,
Biju

> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v3:
>  * New patch moved here from Renesas SCI fixes patch series
>  * Updated commit description
>  * Moved handling of clearing TE bit as separate patch#5.
> ---
>  drivers/tty/serial/sh-sci.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c in=
dex
> 15743c2f3d3d..32f5c1f7d697 100644
> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -601,6 +601,15 @@ static void sci_start_tx(struct uart_port *port)
>  	    port->type =3D=3D PORT_SCIFA || port->type =3D=3D PORT_SCIFB) {
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
> @@ -2600,8 +2609,14 @@ static void sci_set_termios(struct uart_port *port=
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

