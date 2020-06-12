Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CE21F722E
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 04:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgFLCWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 22:22:19 -0400
Received: from mail-db8eur05on2050.outbound.protection.outlook.com ([40.107.20.50]:6115
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbgFLCWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 22:22:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARCz3bO8eB/a9rPPW7UbR/imdpyeoBJOQOWzROftqNYbMhyYGgCZeX/w7qUsrTw2eC3fnXbzV/my3V+Sax4h7PEKF7IkcpBrKluPAmDg+WdZk8Vg1BRSNsJwpdbBJgaYpjZ6Rck5ZLZ8CZ7suHXDWIwHaNeTC9EcEJR1tTMjyhnh6jgesLQZJL7ueYCuTiv4s7co0srovl3oPZrF2p3QU4GrBy3YL1HXBpaYLSI0gBXwUr3tGhW/+ygcw124B/XSjeirekcFxlbVmGZdtifNpytqYRSo+za0oQE2GwkPlDIgpE8gDtC44/qTYt+tBkJ4QeAl2MKVO7HbAOMfNuTwSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDJKnIKFY4AKnuDsYKC3aneOdWrI8XXZUMD0yxYK8eM=;
 b=IVuAnIKeIboF+9nf7oBRd+YK/+HsOKwHL0K/u1igWOqsvEgy/b68w5SflwLpLV2xjeBp9G1rDMd4HsN2OFEktYoLmbAXJ0TJAcMJuiLGrQbyXQNCufMNh8j8Bi6+R5dFS4SLkk3OCzpe0qJPjAJynYma7GlqSW+vQTslQMgvwAVWWVL/B6qIveHvs9emBA2ZtVjX4qEhnHdaCoIig+IDX26W5CzosDCOiUMCZgIdLt2N4MHmBkVWLeIiWPlHd2czpnJNZ0XRmShVeBxq5J5O8qqCG/aOCmspumTCV4j3KBCe4Cyit7XuM5GHXozN4RvTQBx01edVbWg1S1njrveeDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDJKnIKFY4AKnuDsYKC3aneOdWrI8XXZUMD0yxYK8eM=;
 b=nY5zjFJVKjvraKH8Bv+AxLYhf+hKiP0zNAkKgR389Ld9DcKmljcg64qFoyugbN2FotyqJBMVKPjwpEb4hI5oamjwJE96vXmW+qHB4OpyCTIDjBQzQDlRWEIzsbNJ+tbhlszbkUZUgUXmfox8epqwmY0RPVFMKb3iz/5+WJkyoe4=
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15)
 by VE1PR04MB6477.eurprd04.prod.outlook.com (2603:10a6:803:11e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Fri, 12 Jun
 2020 02:22:14 +0000
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::5cc4:23a5:ca17:da7d]) by VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::5cc4:23a5:ca17:da7d%6]) with mapi id 15.20.3066.023; Fri, 12 Jun 2020
 02:22:14 +0000
From:   Robin Gong <yibin.gong@nxp.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Peng Ma <peng.ma@nxp.com>, Fabio Estevam <festevam@gmail.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 2/2] dmaengine: fsl-edma: Fix NULL pointer exception in
 fsl_edma_tx_handler
Thread-Topic: [PATCH 2/2] dmaengine: fsl-edma: Fix NULL pointer exception in
 fsl_edma_tx_handler
Thread-Index: AQHWP+pVSg8DVLJSBk+m5kI3CuPTMqjUQEUw
Date:   Fri, 12 Jun 2020 02:22:13 +0000
Message-ID: <VE1PR04MB66380552302906130261F96189810@VE1PR04MB6638.eurprd04.prod.outlook.com>
References: <1591877861-28156-1-git-send-email-krzk@kernel.org>
 <1591877861-28156-2-git-send-email-krzk@kernel.org>
In-Reply-To: <1591877861-28156-2-git-send-email-krzk@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 38f35fa0-84a4-41da-7ad2-08d80e776be2
x-ms-traffictypediagnostic: VE1PR04MB6477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB64771EAD3BDD82EE856EC87089810@VE1PR04MB6477.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0432A04947
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w3Z/DENBTdi+oGwPJ+1mLkfKZ8hMjAilriFwp59YRIXusY4WmGe3waFrHvRR1HJfMYMSS6t9oEJ/N1jF2Pqz+wuwyu71gRSxZ2B11u8o3Wf5KmMKhtE4yHHmNXVINbthYENjlR2iiT5avod5sz69e9Tgb3O6FCjtBPGdLNBYvKb0pqrbzHGNEr/Vt0cVks8u+mPiO6yZMqDBcMmfmx5pNuwzmOXki/bX1dzGIt7G0k973t77bP4Dx9jmx73v530NzZfEByTfql541u5rISseD5ifWAce2/mcgyDACvcHK+sSLXgceO8RQNQxwZ5esCICGkmLJ3s8h18/nhmcCzv03A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6638.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(8936002)(2906002)(8676002)(66946007)(76116006)(66446008)(9686003)(64756008)(55016002)(66476007)(66556008)(86362001)(33656002)(4326008)(26005)(83380400001)(6506007)(478600001)(186003)(7696005)(53546011)(316002)(52536014)(110136005)(71200400001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: eG+W6JY9aebLvsItg2YO7wAsdUkN04uMThX0WzHPqYaZ6QIS0OPGiWHxp1VY7VZytaCL0242pNspDbn2VxCRgmbAj+fOwcZeiD9ocojVTi12obepMHi2NIs+Ej3ap/X+UsI4vmFTaNxve1lz+TPd/tSCHlyWJdNGxjZPyC9WiqyK+gbmfgA+b1kODcV04Nup2sZZVTaJYVDzgPXeL40r4k82lEEbD7hUd7GDTUe+ZQhvzly1l+3aFthBdCrNiYoRUfK3xRWqMJFQOuLrm+EVUXcFsGtkBGt+SBdkWYDgOZd+Qa3WM2RrIcUgPkdppmjttb7BM/ZtU0RlFC5XN36pw3WJ+fxxXWq435n9/wp/r/naTB0v08FuqMeYkJatlMTyO2puRel89cuOZseAsi6KUSaiIHDsJ82AxHbkaZrXo045LXJem2ZUiUXVDNPPiEe5avDZn2R6bLIzBZkPDN6dq11pLlo+RAS7p0sPOBrqfpA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f35fa0-84a4-41da-7ad2-08d80e776be2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2020 02:22:14.5597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RrD+NrInfRrV4EaT3YqRVhqzpaON01hURCZe5yp8QB7RYPXQ2Op3kYodbwBuTY3xxw0QVVFFYSKUB+9wDDyDFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6477
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/06/11 20:18 Krzysztof Kozlowski <krzk@kernel.org> wrote:
> NULL pointer exception happens occasionally on serial output initiated by=
 login
> timeout.  This was reproduced only if kernel was built with significant
> debugging options and EDMA driver is used with serial console.
>=20
>     col-vf50 login: root
>     Password:
>     Login timed out after 60 seconds.
>     Unable to handle kernel NULL pointer dereference at virtual address
> 00000044
>     Internal error: Oops: 5 [#1] ARM
>     CPU: 0 PID: 157 Comm: login Not tainted 5.7.0-next-20200610-dirty #4
>     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
>       (fsl_edma_tx_handler) from [<8016eb10>]
> (__handle_irq_event_percpu+0x64/0x304)
>       (__handle_irq_event_percpu) from [<8016eddc>]
> (handle_irq_event_percpu+0x2c/0x7c)
>       (handle_irq_event_percpu) from [<8016ee64>]
> (handle_irq_event+0x38/0x5c)
>       (handle_irq_event) from [<801729e4>]
> (handle_fasteoi_irq+0xa4/0x160)
>       (handle_fasteoi_irq) from [<8016ddcc>]
> (generic_handle_irq+0x34/0x44)
>       (generic_handle_irq) from [<8016e40c>]
> (__handle_domain_irq+0x54/0xa8)
>       (__handle_domain_irq) from [<80508bc8>] (gic_handle_irq+0x4c/0x80)
>       (gic_handle_irq) from [<80100af0>] (__irq_svc+0x70/0x98)
>     Exception stack(0x8459fe80 to 0x8459fec8)
>     fe80: 72286b00 e3359f64 00000001 0000412d a0070013 85c98840
> 85c98840 a0070013
>     fea0: 8054e0d4 00000000 00000002 00000000 00000002 8459fed0
> 8081fbe8 8081fbec
>     fec0: 60070013 ffffffff
>       (__irq_svc) from [<8081fbec>]
> (_raw_spin_unlock_irqrestore+0x30/0x58)
>       (_raw_spin_unlock_irqrestore) from [<8056cb48>]
> (uart_flush_buffer+0x88/0xf8)
>       (uart_flush_buffer) from [<80554e60>] (tty_ldisc_hangup+0x38/0x1ac)
>       (tty_ldisc_hangup) from [<8054c7f4>] (__tty_hangup+0x158/0x2bc)
>       (__tty_hangup) from [<80557b90>]
> (disassociate_ctty.part.1+0x30/0x23c)
>       (disassociate_ctty.part.1) from [<8011fc18>] (do_exit+0x580/0xba0)
>       (do_exit) from [<801214f8>] (do_group_exit+0x3c/0xb4)
>       (do_group_exit) from [<80121580>] (__wake_up_parent+0x0/0x14)
>=20
> Issue looks like race condition between interrupt handler fsl_edma_tx_han=
dler()
> (called as result of fsl_edma_xfer_desc()) and terminating the transfer w=
ith
> fsl_edma_terminate_all().
>=20
> The fsl_edma_tx_handler() handles interrupt for a transfer with already f=
reed
> edesc and idle=3D=3Dtrue.
>=20
> Fixes: d6be34fbd39b ("dma: Add Freescale eDMA engine driver support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/dma/fsl-edma.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c index
> eff7ebd8cf35..90bb72af306c 100644
> --- a/drivers/dma/fsl-edma.c
> +++ b/drivers/dma/fsl-edma.c
> @@ -45,6 +45,13 @@ static irqreturn_t fsl_edma_tx_handler(int irq, void
> *dev_id)
>  			fsl_chan =3D &fsl_edma->chans[ch];
>=20
>  			spin_lock(&fsl_chan->vchan.lock);
> +
> +			if (!fsl_chan->edesc) {
> +				/* terminate_all called before */
> +				spin_unlock(&fsl_chan->vchan.lock);
> +				continue;
> +			}
Reviewed-by: Robin Gong <yibin.gong@nxp.com>
> +
>  			if (!fsl_chan->edesc->iscyclic) {
>  				list_del(&fsl_chan->edesc->vdesc.node);
>  				vchan_cookie_complete(&fsl_chan->edesc->vdesc);
> --
> 2.7.4

