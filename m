Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D925F218926
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 15:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgGHNeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 09:34:00 -0400
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:45771
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729436AbgGHNeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 09:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmpbOBMnme8ZgoEpk9Me0ZMKjnV3oC4ufZ8DwrWNYx85gGOrIx2aUP6kgk+7ngXWY08lxojW/ezf9BhwLDTsvWOtHPKmb5Eky4OBgUpKXT9FYsthGhc+SJdVQs0ndQvBFnThn4rdkoBJE2/wbn6nQ8YL56vNVncSuBDnaGfWFP4OBmqZ42cQ907w1XASJwQ33JI+uDea2zXKMlBwI4a66aCF0qinTahiiHW1yqetnqy7ZehdIIRYxK/nGrPZEi7HjRVTD+J1cDeHyIak4yMBZu0Mxh84YY+Dv1xwFj40IbdDZrGhwEKEe/dZzEWC1eu/wzyaEX6iyDBh5s3jz70Jhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEv9QVWqQBmT8Op3NyolOCRsABpuhSApz4HKROj8qJg=;
 b=Ip+0AExpdbBQ3PJEIPB4na3sTmhHHMYI0gDInlVLkEaZ2txtyH1A4gO3ZJEgfhJzPivoRaAxSouImeRguQhPfS23/eMNQlfVv7Tb5PbNMjPXIraOJoytz1Exw/OoaH+AKS9WrnXt+mD7gTqtUqX64qxSVLG3oCZ/s4oAwURlpZ7MLuJj+v/ITeQEvMjGUV73gk8sC9QkY0r+hzIu+1sxx7MVYW/cDUggm7ihZTxh/WwB8a6c6pD1EFHrsIkJ7Rzxsu8xTG9VcJfOflOrU/hObZJzR46C1m7f5AsC+jfPPfw5LoAwNj8u5gVrUFKeOM4hK26ebYx/ZViFxt4lD/O2pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEv9QVWqQBmT8Op3NyolOCRsABpuhSApz4HKROj8qJg=;
 b=WaE874QL0Z8cEwG5KsW1957LiD12MB1Zcufdw6sPBmiP0tHufHcJspjSEdAaYj56yZINt6CV9DFDNp3P9K7seDDnURmO6h8jvomAIFwZNeCNysw6y5uyXIjiSues3UoyHNVOP90E6XPwOsUjp1cz2qBrYrm5f6bCeeOgomC0458=
Received: from VE1PR04MB6528.eurprd04.prod.outlook.com (2603:10a6:803:127::18)
 by VE1PR04MB6717.eurprd04.prod.outlook.com (2603:10a6:803:129::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Wed, 8 Jul
 2020 13:33:57 +0000
Received: from VE1PR04MB6528.eurprd04.prod.outlook.com
 ([fe80::30e2:71b0:ffd3:e39e]) by VE1PR04MB6528.eurprd04.prod.outlook.com
 ([fe80::30e2:71b0:ffd3:e39e%7]) with mapi id 15.20.3153.030; Wed, 8 Jul 2020
 13:33:57 +0000
From:   Jun Li <jun.li@nxp.com>
To:     Peter Chen <peter.chen@nxp.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "pawell@cadence.com" <pawell@cadence.com>,
        "rogerq@ti.com" <rogerq@ti.com>, stable <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] usb: cdns3: gadget: own the lock wrongly at the
 suspend routine
Thread-Topic: [PATCH 1/1] usb: cdns3: gadget: own the lock wrongly at the
 suspend routine
Thread-Index: AQHWVQp3VFYjV/gMpE2zL2ZZVX89sKj9p6/A
Date:   Wed, 8 Jul 2020 13:33:56 +0000
Message-ID: <VE1PR04MB6528647055C8D740ED81E7C389670@VE1PR04MB6528.eurprd04.prod.outlook.com>
References: <20200708093043.25756-1-peter.chen@nxp.com>
In-Reply-To: <20200708093043.25756-1-peter.chen@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c9d5866c-5a6f-4d85-0246-08d8234390c7
x-ms-traffictypediagnostic: VE1PR04MB6717:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB67170C0DC4427D35F32F5ED789670@VE1PR04MB6717.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bj0NVZwQedwRUbHwoZ1PV03f7xWU7+PjJcAScC4iBQ/5qBzuB4BsnHTQ/x1IMlRSNNoxogEvcosFLrNWbpL/J72j9zWtgh0JvT84/Frwa+FTwNsyI9qgtUdZ/QPMRJLukcG2GbZrOrjdohuMeCJ8/MZP8U3z9nw01NOYI351vYvX3EuygtcxKvG0YqVlGgy5ZXmuhI22ePL0bV1WK8bZibabghp3a1Jf9S/q+Ynkx93ITgP0n3E/yzmYiZ319ZwB8wB3oZkz5nUdHpWc6Yy+yM5mPRWy/iM5ux6PQ310kt7vx3IUMsMUjGmKBq1WBfdwknl1Z5Rq84QjyAM6qhPwCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6528.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(44832011)(71200400001)(64756008)(316002)(83380400001)(110136005)(76116006)(54906003)(66446008)(66556008)(66476007)(66946007)(4326008)(9686003)(478600001)(55016002)(8676002)(7696005)(5660300002)(33656002)(2906002)(15650500001)(52536014)(8936002)(6506007)(53546011)(86362001)(26005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 15eWJZ1WhKt9TWNW9MPHwGv0/B/Gt+J5QkuWZVACU+d5sswSkmWNO+HnC1v8uI8dxll6QFicPEXS0GiSmmz5PRFkvQGmrB1c5rsWu7sbaqNTxz6eZuglhoE6fny7k3CTz8EjknxUbq7uxArRNzUTylQ4+hNNJikOAY/DGV7GWRdnMnBTCZYeI/kAnh8xpsb4cRRQ5kkh0jX6O6jrD8kI5oFrl8nKBjDtKCQeIpujkTKXPcun/n8grRMpDJG+mhZ5unGLdZpC32C4u7xI2IaIlFgFeEDfYQ1OF1x3yvkaxRbNZcLADUTJtPkAPTUcUwgd842scj1aLmeSv4xIqI1FLwruLk9rkPpdVOeIqJzeB8HdvhuK3w+OUMAyGbldkRCAKP/KiQ3DQAFumDJ8BqC7BIfNP9CndtQJ68xmtOacHMvGzS5b6DIpy2ld4C1tgPwbZdPiXMlPdz/lq+OZTY7Erl77DbG16smFSJPxUHERjlk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6528.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d5866c-5a6f-4d85-0246-08d8234390c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 13:33:57.0638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 086NpdgMtKvXXjx07jvSFSd47U6XUkbz8N9VUa8TxITGMbVf9ijDxHl6GHFOSIsH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6717
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,
> -----Original Message-----
> From: Peter Chen <peter.chen@nxp.com>
> Sent: Wednesday, July 8, 2020 5:31 PM
> To: balbi@kernel.org; gregkh@linuxfoundation.org
> Cc: linux-usb@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>;
> pawell@cadence.com; rogerq@ti.com; Jun Li <jun.li@nxp.com>; Peter Chen
> <peter.chen@nxp.com>; stable <stable@vger.kernel.org>
> Subject: [PATCH 1/1] usb: cdns3: gadget: own the lock wrongly at the susp=
end routine
>=20
> When it is device mode with cable connected to host, the call stack is:
> cdns3_suspend->cdns3_gadget_suspend->cdns3_disconnect_gadget,
> the cdns3_disconnect_gadget owns lock wrongly at this situation, it cause=
s the

Isn't afterwards the lock will be released in cdns3_suspend() by below code=
?
spin_unlock_irqrestore(&cdns->gadget_dev->lock, flags);

> system being deadlock after resume due to at cdns3_device_thread_irq_hand=
ler, it
> tries to get the lock, but will never get it.
>=20
> To fix it, we delete the lock operations, and add them at the caller when=
 necessary.

There are 2 caller places, by this, another code path:
cdns3_suspend->cdns3_gadget_suspend->cdns3_disconnect_gadget() will do
gadget_driver->disconnect() with lock hold, is this intentional?

Thanks
Li Jun
=20
>=20
> Cc: stable <stable@vger.kernel.org>
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> ---
>  drivers/usb/cdns3/gadget.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c inde=
x
> 13027ce6bed8..f6c51cc924a8 100644
> --- a/drivers/usb/cdns3/gadget.c
> +++ b/drivers/usb/cdns3/gadget.c
> @@ -1674,11 +1674,8 @@ static int cdns3_check_ep_interrupt_proceed(struct
> cdns3_endpoint *priv_ep)
>=20
>  static void cdns3_disconnect_gadget(struct cdns3_device *priv_dev)  {
> -	if (priv_dev->gadget_driver && priv_dev->gadget_driver->disconnect) {
> -		spin_unlock(&priv_dev->lock);
> +	if (priv_dev->gadget_driver && priv_dev->gadget_driver->disconnect)
>  		priv_dev->gadget_driver->disconnect(&priv_dev->gadget);
> -		spin_lock(&priv_dev->lock);
> -	}
>  }
>=20
>  /**
> @@ -1713,8 +1710,10 @@ static void cdns3_check_usb_interrupt_proceed(stru=
ct
> cdns3_device *priv_dev,
>=20
>  	/* Disconnection detected */
>  	if (usb_ists & (USB_ISTS_DIS2I | USB_ISTS_DISI)) {
> +		spin_unlock(&priv_dev->lock);
>  		cdns3_disconnect_gadget(priv_dev);
>  		priv_dev->gadget.speed =3D USB_SPEED_UNKNOWN;
> +		spin_lock(&priv_dev->lock);
>  		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_NOTATTACHED);
>  		cdns3_hw_reset_eps_config(priv_dev);
>  	}
> --
> 2.17.1

