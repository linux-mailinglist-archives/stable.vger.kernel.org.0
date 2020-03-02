Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29653175481
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 08:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgCBHg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 02:36:58 -0500
Received: from mail-am6eur05on2068.outbound.protection.outlook.com ([40.107.22.68]:51233
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgCBHg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 02:36:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yx/xED3x3NSwXaHLyPfXAqgOiyGJw5B9bDXygPZS7i3vbKb/XhSAIxrbg82na5U/jpSp05VaMwA11lKbPLIw5eekWFX+12PSdPh3nAMlNBMSZMJx8AAQ1C7YKKrqDeGz+KUrp4iw/V8dJCbWZLFGtGE8A1zIgGGSFrvWkho5bIUNA7C7tYFVBeVgOPcOwILH81/0UioQ/m9GadQjxyJI7bxXSCoz2JshdTRDrwhLGGnB6So9ZXA7azpJG/OeNjNamu3ZpLXcd0Rvo2V/nT5k5gPbu4nPBfCUdooP7XAjOX1kU95pQGUYJJnB9ZFvGv96DaFnvA0bv6bom2ZgLwJ8HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CW8kX+OBHDocvqUzhceSUBQpJ+2wT3OAYRuLZ0tqIY=;
 b=IaI64oiYHRTFDt7zQigYbvHlBnzJy4HeAkOoLaQ11Tdvzvtn+hUq6YqwaIYBQxNR4OTW2UqWnuxVPcidjx5B65Q/g0o94ZIXJDyhkIEi/MpTyj/7wkarNXN3XtPKrpxo1ou7Xy1mWHXQwHvY2dCL4PE0/S5u4Ps3H2lrpORhtGfJtobZbQymqi48XXkXo+Bd3M0oD3Emp2+dqJu40sEGbNzWKQ6Irs8LTrNrbEQ9jJ5Ta2Nh9J365ToPTXZl9TH68jcPm5KoLQ5YjHrH213svLKaijDrKC8M47FMV7j2QFkmVvldy98cq5qInT4vlFOeH0GQfJNOaEn/7ou5t/EymA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CW8kX+OBHDocvqUzhceSUBQpJ+2wT3OAYRuLZ0tqIY=;
 b=Hg5Pf70imGtHtGk8vKmDMDHHDlLCrWxVBER9rpDL28/iN/kkmmRM4DwCxy4VB5UPAXQ7CY7YmnQ19r7nfsGEoeDlfU3LVzMaVmqOHC/iMEkPjtBREsIGNc2nFTTjsSryWDDh5i/Jp8UHS5IuE7XmUHexwCgToI9UcoQ8t7f/FlM=
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com (20.179.232.15) by
 VE1PR04MB6445.eurprd04.prod.outlook.com (20.179.232.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Mon, 2 Mar 2020 07:36:54 +0000
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::490:6caa:24b:4a31]) by VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::490:6caa:24b:4a31%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 07:36:54 +0000
From:   Robin Gong <yibin.gong@nxp.com>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] dmaengine: imx-sdma: fix context cache
Thread-Topic: [PATCH] dmaengine: imx-sdma: fix context cache
Thread-Index: AQHV1qnIaNGAJ9R9HEaS0rzYiAQ7rag1GlnQ
Date:   Mon, 2 Mar 2020 07:36:54 +0000
Message-ID: <VE1PR04MB66383055663F08FBFDF2E47489E70@VE1PR04MB6638.eurprd04.prod.outlook.com>
References: <1580305274-27274-1-git-send-email-martin.fuzzey@flowbird.group>
In-Reply-To: <1580305274-27274-1-git-send-email-martin.fuzzey@flowbird.group>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yibin.gong@nxp.com; 
x-originating-ip: [183.192.236.243]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 574c4a10-eb01-459e-cb2d-08d7be7c7aeb
x-ms-traffictypediagnostic: VE1PR04MB6445:|VE1PR04MB6445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB644543B84FA553006E6EAA3489E70@VE1PR04MB6445.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(4326008)(2906002)(52536014)(186003)(86362001)(478600001)(8936002)(71200400001)(33656002)(8676002)(81156014)(81166006)(316002)(66946007)(76116006)(55016002)(66446008)(66556008)(66476007)(9686003)(64756008)(5660300002)(966005)(110136005)(54906003)(6506007)(7696005)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6445;H:VE1PR04MB6638.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CU51/NeB4Q7nPZKexdqQNU22py3pdtD80JGpdp8i1VnfetPXM+OvfNi5wXsMidqzuUuFjf7zMJTg5tq+u/1Fjbv3TIR2Xlmk8E7cjLRfaAADtjBX3/XXhP1EnGP9k7pfrjG6p8uHk+ueHojkACOhs40n4RSptR8nCMPlhYHWKFkvvGdEIPK5qX+G2xJMabfOzUEapAJcFq1rsDkF19Dd8mcmodTT1I50OxZ8CgQyo4Y/H+rpoBGN7f7HnCAyraNy2tdyUgVfBA9wMqD4ltRFpNuJgPWh+mHNfiu3hWo6smOorEmpKRrR7llrNL011plJHBqNo1cXe5t//IV72PdIAwOGqswri8wuuPB7FXJsxxaH+pEW9WQHko+NjIKR0bGEn7nsPq1vCicnMSkfoFWsFibllvntCIUVX+3ciJpkIaJ5vim8inxtF8obLvTISIpSHkd7pqqRQqZWYbRfvDuTQLOIDZTAdE/Z4KHzG2iGtplqzLWbgBjwbEo6SPg4k0AmQKMFKAAkeaDDx2c7t9dgtw==
x-ms-exchange-antispam-messagedata: mwH/hvwRRAbc0k7KQ7Wh1pXwAdABjQ7VaQKZWRbMz83gIVq84mTDvW1JrUq4++ZaLz/fxFuBu/vxY8s/c0CPp6sbOPK+FUn7tXOJAU0XeIi5a0GloAtQ8/xRCZ5ON93ugrFQzLS6EcdTiZQqkhx4AQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 574c4a10-eb01-459e-cb2d-08d7be7c7aeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 07:36:54.1990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aRHXWh+CsUO01BTgF1us9wvY+sqTuQgECo8Lj6yoe80qVb8vekEf/VV80Hkf/z2pEQIL4aoxa6rPiGxXoZy1ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6445
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/01/29 Martin Fuzzey <martin.fuzzey@flowbird.group> wrote:
>=20
> There is a DMA problem with the serial ports on i.MX6.
>=20
> When the following sequence is performed:
>=20
> 1) Open a port
> 2) Write some data
> 3) Close the port
> 4) Open a *different* port
> 5) Write some data
> 6) Close the port
>=20
> The second write sends nothing and the second close hangs.
> If the first close() is omitted it works.
>=20
> Adding logs to the the UART driver shows that the DMA is being setup but =
the
> callback is never invoked for the second write.
>=20
> This used to work in 4.19.
>=20
> Git bisect leads to:
> 	ad0d92d: "dmaengine: imx-sdma: refine to load context only once"
>=20
> This commit adds a "context_loaded" flag used to avoid unnecessary contex=
t
> setups.
> However the flag is only reset in sdma_channel_terminate_work(), which is
> only invoked in a worker triggered by sdma_terminate_all() IF there is an=
 active
> descriptor.
>=20
> So, if no active descriptor remains when the channel is terminated, the f=
lag is
> not reset and, when the channel is later reused the old context is used.
>=20
> Fix the problem by always resetting the flag in sdma_free_chan_resources(=
).
>=20
> Fixes: ad0d92d: "dmaengine: imx-sdma: refine to load context only once"
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
>=20
> ---
>=20
> The following python script may be used to reproduce the problem:
>=20
> import re, serial, sys
>=20
> ports=3D(0, 4) # Can be any ports not used (no need to connect anything) =
NOT
> console...
>=20
> def get_tx_counts():
>         pattern =3D re.compile("(\d+):.*tx:(\d+).*")
>         tx_counts =3D {}
>         with open("/proc/tty/driver/IMX-uart", "r") as f:
>                 for line in f:
>                         match =3D pattern.match(line)
>                         if match:
>                                 tx_counts[int(match.group(1))] =3D
> int(match.group(2))
>         return tx_counts
>=20
> before =3D get_tx_counts()
>=20
> a =3D serial.Serial("/dev/ttymxc%d" % ports[0])
> a.write("polop")
> a.close()
> b =3D serial.Serial("/dev/ttymxc%d" % ports[1])
> b.write("test")
>=20
> after =3D get_tx_counts()
>=20
> if (after[ports[0]] - before[ports[0]]  > 0) and (after[ports[1]] - befor=
e[ports[1]] >
> 0):
>         print "PASS"
>         sys.exit(0)
> else:
>         print "FAIL"
>         print "Before: %s" % before
>         print "After: %s" % after
>         sys.exit(1)
> ---
>  drivers/dma/imx-sdma.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c index
> 066b21a..332ca50 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1338,6 +1338,7 @@ static void sdma_free_chan_resources(struct
> dma_chan *chan)
>=20
>  	sdmac->event_id0 =3D 0;
>  	sdmac->event_id1 =3D 0;
> +	sdmac->context_loaded =3D false;
Martin, thanks for you patch, sorry for the issue left in kernel for so lon=
g, because my below patch set has been pending from last year. I would like=
 revert commit ad0d92d: "dmaengine: imx-sdma: refine to load context only o=
nce" since some drivers may change.
context during two transfer like spi did. I would pick up this patch set th=
is week anyway.=20
https://lore.kernel.org/patchwork/patch/1086454/=20
>=20
>  	sdma_set_channel_priority(sdmac, 0);
>=20
> --
> 1.9.1

