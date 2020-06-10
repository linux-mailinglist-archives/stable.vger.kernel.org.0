Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E471F5914
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 18:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgFJQcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 12:32:54 -0400
Received: from mail-vi1eur05on2041.outbound.protection.outlook.com ([40.107.21.41]:58762
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729049AbgFJQcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 12:32:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MarC5Ttt/tI8Ob1v15q4gc70jtlXiWapFKgbd0IvD+OotcsYCzzIziePORcoEBj1PFbzaInl9XNcIVbctVUIGquicwtPIn2w6EMkVCMjxd/VPv2sJyT+uuhXNfWl8l+iatOSGTpqRQyjAL8/7b4m/jr4VdW5E2zrp9hknfOVwKN9a/zNH1kWQbMhhdgRgJYqLQ4OCIb95nNC0cOhA1QEs/NFYgXGxm4UCqQaQaMp6q0WilBy5931L3NgyF83R2JcURdRjZJ5uK66FYpxaMTUIzkXCZDkT4C09cuEGiXZnMXCis3tX90ATF7OA5LbsjT0y8LP59d674/jNe9jYZLHZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uIR5O/VjiiPuF5ADz01F50TG22k4Y1WIr0o2FlnbwY=;
 b=AGp2sAhmJSdx+XJWOZ/Qx6rKRNg4PPWzoNtcEFIN+FdI5JjTJZ8JMg6IMnntwzaRfAtj4HEENQ7OnmehHeQcdQKkVIkEr5MwLbmRy1omCu5WJXdAIYMSiUtXF7aGixMSiPki0xbAhpNojgJpgycJ4QjD1a0alAc5AsU4h1JrSPxFo5o9NEQK7eJPmsyHIUysMUFUXNlNxkr5++n+6MeDjntcDBVeHWK9CApdIgXNfaD9a9LISD1HS/UbgLwFkDfuSPndUDAkfbePb5f/KCKMpPTej2nmFHnO8RVWKpADt/MIrMxAwqrVzqouquJ3i32UOr6+U0FbtACBfgddrFBLUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uIR5O/VjiiPuF5ADz01F50TG22k4Y1WIr0o2FlnbwY=;
 b=NSwGbLBx1qzUiAuWixjWTz7f1o3MsqAj5eJjoahr6b1faUPIpA6cGD8f1+F2atJGR3S2DRxvdV1QpyGefVkWATwQWCYYpUlTV0o8bm4fUwfXrufqKKYcdKcNszKGQjnxCu7IM4rAdWn2UBREn4TfGqkMYxCA0z0BsQnvfQphYUM=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6127.eurprd04.prod.outlook.com (2603:10a6:803:fa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Wed, 10 Jun
 2020 16:32:49 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::1df:4c77:2e50:22d4]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::1df:4c77:2e50:22d4%7]) with mapi id 15.20.3066.023; Wed, 10 Jun 2020
 16:32:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] spi: spi-fsl-dspi: Free DMA memory with matching function
Thread-Topic: [PATCH] spi: spi-fsl-dspi: Free DMA memory with matching
 function
Thread-Index: AQHWP0THy/tYaffJNkG7XB6oxxgkvQ==
Date:   Wed, 10 Jun 2020 16:32:49 +0000
Message-ID: <VI1PR04MB56960EE5C94270738D273C7DE0830@VI1PR04MB5696.eurprd04.prod.outlook.com>
References: <1591803717-11218-1-git-send-email-krzk@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d316099c-3be0-481f-ee16-08d80d5bea40
x-ms-traffictypediagnostic: VI1PR04MB6127:
x-microsoft-antispam-prvs: <VI1PR04MB6127A4250DD1C8B22A85CB1AE0830@VI1PR04MB6127.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0430FA5CB7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BlQegMUVAFYjSqv8jFX0bCthP9gBQ5//Sm7MxyNUfnvm9HEunyv6pkIWPsm7qOCqutZgecGONkz6Tj5sdK3lpJLpXX1JXOyTjlfrVgwuhnYtUJcqSOz43NDUHaC279yLpwmsb5oVhL3dAEn4DOmanLIObiGmOPyI3T6tZyMpJU9WcqD9mjdjwj8wp0S+9ccwAEuFZjRwY/+XD1YIRrQKQGt0kaZjfRToRoRcITiK/GbJkeVvapM+StAvjfAjudP7snrfB1LY34cAy1qO5ba/cDrCF52sjBEhxAyKqy68ERjXa55a87px1tAjmmbG5sLhv5quSgNQNaOC87VRrGqeuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(110136005)(9686003)(2906002)(66476007)(66556008)(64756008)(66446008)(66946007)(71200400001)(55016002)(316002)(76116006)(91956017)(44832011)(5660300002)(53546011)(33656002)(7696005)(6506007)(478600001)(86362001)(4326008)(186003)(26005)(52536014)(83380400001)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AF4/GfsCP1eDhyq5FaAPCH4Nz6xw5ycai2B55hzJqZekkCImDJh0dtcZaLujwDUrcyE0wAOdEkGWV0DUUyE27OhqEBiCBLq7A0qjc5ktnAPe1QFN9Uu6n/ZQERn47SXZgmMqlEB5ZeSS0fCgwAtCddMK2hAhki/KtWpzVvF2EoWue+e2dxcEqH84oyndfIDxV4IGRJvOCBJnVX0nA7nj0gDt6Tew6yNtMdVAdpMyRA/JPbvNME8s3Kqj7+CyJkqLEGrllGgTV6AxV8o9IpwFtD/nnsNRggK/bUNDCBFXqz3ti0z3ZMlobGrEoCa7JAMP2nAGEQ1/QaHFZjPk079ZlZqiZfeWZUFE+YYkQtByxHzhXGzoBpn1mC/Sf9rPkWKiTxMbnQjTWEZZMJ+LPZaA/4BEudj+DeueoKl1MU0X5VTmHME9aT6R9axzb7suqsWM5N7mK2nS3NihwG+WKrxQ4tQR/5AgRy/SazbkMw8w7nY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d316099c-3be0-481f-ee16-08d80d5bea40
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2020 16:32:49.5094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l0ePjWMcz3miv0qWWHEV/tZkXP0b2WlLkklmc7/7tfx/RFD/J3GSSCoj7CsEfyZ5MsWtKGNxFtmvrCdj26BxZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6127
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/10/20 6:42 PM, Krzysztof Kozlowski wrote:=0A=
> =0A=
> Driver allocates DMA memory with dma_alloc_coherent() but frees it with=
=0A=
> dma_unmap_single().=0A=
> =0A=
> This causes DMA warning during system shutdown (with DMA debugging) on=0A=
> Toradex Colibri VF50 module:=0A=
> =0A=
>      WARNING: CPU: 0 PID: 1 at ../kernel/dma/debug.c:1036 check_unmap+0x3=
fc/0xb04=0A=
>      DMA-API: fsl-edma 40098000.dma-controller: device driver frees DMA m=
emory with wrong function=0A=
>        [device address=3D0x0000000087040000] [size=3D8 bytes] [mapped as =
coherent] [unmapped as single]=0A=
>      Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)=0A=
>        (unwind_backtrace) from [<8010bb34>] (show_stack+0x10/0x14)=0A=
>        (show_stack) from [<8011ced8>] (__warn+0xf0/0x108)=0A=
>        (__warn) from [<8011cf64>] (warn_slowpath_fmt+0x74/0xb8)=0A=
>        (warn_slowpath_fmt) from [<8017d170>] (check_unmap+0x3fc/0xb04)=0A=
>        (check_unmap) from [<8017d900>] (debug_dma_unmap_page+0x88/0x90)=
=0A=
>        (debug_dma_unmap_page) from [<80601d68>] (dspi_release_dma+0x88/0x=
110)=0A=
>        (dspi_release_dma) from [<80601e4c>] (dspi_shutdown+0x5c/0x80)=0A=
>        (dspi_shutdown) from [<805845f8>] (device_shutdown+0x17c/0x220)=0A=
>        (device_shutdown) from [<80143ef8>] (kernel_restart+0xc/0x50)=0A=
>        (kernel_restart) from [<801441cc>] (__do_sys_reboot+0x18c/0x210)=
=0A=
>        (__do_sys_reboot) from [<80100060>] (ret_fast_syscall+0x0/0x28)=0A=
>      DMA-API: Mapped at:=0A=
>       dma_alloc_attrs+0xa4/0x130=0A=
>       dspi_probe+0x568/0x7b4=0A=
>       platform_drv_probe+0x6c/0xa4=0A=
>       really_probe+0x208/0x348=0A=
>       driver_probe_device+0x5c/0xb4=0A=
> =0A=
> Fixes: 90ba37033cb9 ("spi: spi-fsl-dspi: Add DMA support for Vybrid")=0A=
> Cc: <stable@vger.kernel.org>=0A=
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>=0A=
> ---=0A=
=0A=
Sounds reasonable. I always wondered why err_slave_config and =0A=
err_rx_dma_buf call something different than dspi_release_dma, but I =0A=
didn't see any problem so I didn't investigate it further.=0A=
=0A=
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>=0A=
=0A=
>   drivers/spi/spi-fsl-dspi.c | 8 ++++----=0A=
>   1 file changed, 4 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c=0A=
> index a35faced0456..58190c94561f 100644=0A=
> --- a/drivers/spi/spi-fsl-dspi.c=0A=
> +++ b/drivers/spi/spi-fsl-dspi.c=0A=
> @@ -588,14 +588,14 @@ static void dspi_release_dma(struct fsl_dspi *dspi)=
=0A=
>                  return;=0A=
> =0A=
>          if (dma->chan_tx) {=0A=
> -               dma_unmap_single(dma->chan_tx->device->dev, dma->tx_dma_p=
hys,=0A=
> -                                dma_bufsize, DMA_TO_DEVICE);=0A=
> +               dma_free_coherent(dma->chan_tx->device->dev, dma_bufsize,=
=0A=
> +                                 dma->tx_dma_buf, dma->tx_dma_phys);=0A=
>                  dma_release_channel(dma->chan_tx);=0A=
>          }=0A=
> =0A=
>          if (dma->chan_rx) {=0A=
> -               dma_unmap_single(dma->chan_rx->device->dev, dma->rx_dma_p=
hys,=0A=
> -                                dma_bufsize, DMA_FROM_DEVICE);=0A=
> +               dma_free_coherent(dma->chan_rx->device->dev, dma_bufsize,=
=0A=
> +                                 dma->rx_dma_buf, dma->rx_dma_phys);=0A=
>                  dma_release_channel(dma->chan_rx);=0A=
>          }=0A=
>   }=0A=
> --=0A=
> 2.7.4=0A=
> =0A=
> =0A=
=0A=
Thanks!=0A=
-Vladimir=0A=
