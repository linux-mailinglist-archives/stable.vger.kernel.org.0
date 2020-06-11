Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF91F6888
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 15:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgFKNEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 09:04:48 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:9444
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbgFKNEr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 09:04:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTWfezro1Z8EMZj/8MTKPkc67ijaAzCB8KE+/2juIW8TsWrSILyMXYV40Q36ytsHK7e8AvEcAVNLwCZ6Iq2OHbjHbA+Jdz0e+MyVqkk+xs961sXP18KN1DyU7p8xZdeIbmInT8vSSqB6qxF/KoRKpnSfUmiT3PHvxtQ+9n73D5LvRY610+TIkC3I5UINO7UUNY1LNwA4InyTfQnZPGLtjMnr6L5WsR4VxaKNCOzX+cLBYN02RV/HUpODG5NtWO+z5O9dTaaVibHAEfFw82Ie/iQF2MCODE2RxY//pFYxiJpcCZuOARazd3utNZIc/CBgz0ZlRyLcT6m3R4oBh+OURg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVMrhleJs+C3/h9NRE/9AXt0O0CUuv17G5xxLWKZhD8=;
 b=dgRRXpHQxMdxFukjnlMi9PTobix2BicVq3Ggsb5ZxCaJk/fdAwLxDNfJo4FRdgCJ8V73tLbtaFLXxaTztsqtFsxZquJwjnaOa81pnUVCPWK2KgZUFGvPVqOkTTGbMtryFarGwwUyoUPojhdUYTpvc8FahRkA/L0+d17nj0P96vesjJi4hf3DRTF1Q/JT+XTds7i0WSny+d5u7Bzx352OJrEOJ8bbC7fnlgyU/rw467w0B3YNWC7L3HmX0T5oomR7CZYt+r4NbhbwcjFjAM76OedhjbMoDQ+HeYaFebcNC8XjMz72sQ3Aj4LQT1k0RLNneW/DTXWb6Xponf1S6TAH1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVMrhleJs+C3/h9NRE/9AXt0O0CUuv17G5xxLWKZhD8=;
 b=X5wssMiEoYxp0vTGEdk431Nh6ZjiCAYlkytMajLrxgGECtSELCtIdyqT0C7pN/yuZe5mX+LSvHit0wlFbKFGqAJqRNgjxsE8MoFOZdgSv9RyTfNgho90sph+Qm5HJD4fkEsmIWxmLB1upTj1vLEvSY5+JohFYFTeHKVPeCDzBbk=
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15)
 by VE1PR04MB6688.eurprd04.prod.outlook.com (2603:10a6:803:127::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20; Thu, 11 Jun
 2020 13:04:44 +0000
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::5cc4:23a5:ca17:da7d]) by VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::5cc4:23a5:ca17:da7d%6]) with mapi id 15.20.3066.023; Thu, 11 Jun 2020
 13:04:43 +0000
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
Thread-Index: AQHWP+pVSg8DVLJSBk+m5kI3CuPTMqjTYMkQ
Date:   Thu, 11 Jun 2020 13:04:43 +0000
Message-ID: <VE1PR04MB66382172816FB95036776F6489800@VE1PR04MB6638.eurprd04.prod.outlook.com>
References: <1591877861-28156-1-git-send-email-krzk@kernel.org>
 <1591877861-28156-2-git-send-email-krzk@kernel.org>
In-Reply-To: <1591877861-28156-2-git-send-email-krzk@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [183.192.235.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 566b654a-6142-4583-6cd0-08d80e08029d
x-ms-traffictypediagnostic: VE1PR04MB6688:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6688C3F75DAB628762B873D089800@VE1PR04MB6688.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uOie5vgxlqitnss35EP1S0Q7bGWkVlgfg4B0JQPtS3M4M2/Ri1JEd9zOBbXRNnEWdScAfI8gwwbtmimzqVCPV1IPKy8GeiC9A0iZ4aI7RTScgmfrK9aScnVbKacEvmKX1w17JjNs3+pmmGJP3JOWHJiNtKz31cRsqHvFFH8PLHXf2Z2smMynV9cvfZOou6v+RqCoQxYcWcI3bfcJNvC63oPGFuXXIe2ny54ESF0dQjCgeo1dx08doC3ZMfEqZVojb7jWc49HJ8MQ7jYgzzWEl8UbKbyA2jY0g/Rckdnmx1dVzVVJK74/zPd2qZ5E2COfwn5NA3jOKl4MOoMOn3wIOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6638.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(186003)(4326008)(66946007)(66476007)(76116006)(66446008)(66556008)(9686003)(86362001)(55016002)(2906002)(64756008)(52536014)(7696005)(5660300002)(53546011)(110136005)(316002)(71200400001)(33656002)(6506007)(478600001)(26005)(8676002)(83380400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: XEjULlDpb+V5lNES0Ph/XaiVWVciLCR93Fv+W3qXFihNAr/FSE7fDrCk5LU03i1TY9CSNxG/RK5eEN2hdcFeiv08EXJ3I6jexQCGNallPLyQu5yUeRQXwtlpIKNNvwLYT3fOq+CzXLCiase/mbvklq5ZiwDXm5sJSKmJEFPiY3FFpm0m3eMp5L3vGho9dSM0RmZ4/YprAR0ucK6om6r/GGooHnZl24xO8xqxpI/Mb79K+UJ4W1PspikoD2uv8KmZsKmrnzfyzQPIDSb0bW1bRUnbrmz1KbQZVR2wnWPJO0wgVNBl5ZK4MntsRUcZMmGNP7aicvMVxn+PtpPElJMkOfPNYdccqKR9lVQcIECew2ZdosQTqjFJUK28Qza/gtlg/ExHI2x47uUwB6XmZxwVirMStYPq+JZluV5mMn593P989XCmDXadSTGhvPWWLBeWl2h/Zz6ukHASrWq61ot0Vli6rAmK3NGysrS98QR/a77JrtozK6Bk1mvcZA928gNw
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566b654a-6142-4583-6cd0-08d80e08029d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 13:04:43.8104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9S1+OHwc4kLs94uIPqPmOj8pQiraKC9Ts6AExU11unCTw/Qk5g+FF3tt3d6BiSxB5gqALbYl0lwqYiGunEfM/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6688
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/06/11 20:18 Krzysztof Kozlowski <krzk@kernel.org> wrote:
>=20
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
Would you like fix the same potential issue in mcf_edma_tx_handler()
of mcf-edma.c?=20
> +				/* terminate_all called before */
> +				spin_unlock(&fsl_chan->vchan.lock);
> +				continue;
> +			}
> +
>  			if (!fsl_chan->edesc->iscyclic) {
>  				list_del(&fsl_chan->edesc->vdesc.node);
>  				vchan_cookie_complete(&fsl_chan->edesc->vdesc);
> --
> 2.7.4

