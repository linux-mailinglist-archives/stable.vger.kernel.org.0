Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1E4219897
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 08:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgGIG0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 02:26:40 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:14177
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbgGIG0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 02:26:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJEw3u5iXOOrzjhBwTgYAqKyGZ7ybXW6gTPMuK+uw57e67qjdGNnocDMV+DsUTqYBd3MAMU+/Y/HFfWqBAoNRu9yl7OdbevzV/FUyEd82CYmMqdUSc+vDtwrryuBZ+0S1w+cjL4wOlezPRM0x/4D4w7CiqkqW0hm+Uxq0womN06DSkHMS4ykMixbIE7H3h70jO8XYdJd4HZGeE9ERZHjc61bLdZbymC54TMV7K9D9bHXDcyur07TMhyqrfTS8TzT9DY/cn2gmCui2tD4GaKUtuI8zztCIZUNzlnWBxUjUKTaXu5TuY12twC0f8JdHeJ38yCKbNxW1CycV2YurT35pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ytndxm9ZVFAhJ6JGXDjMpKDnktB4vryboUH8Km7qEA=;
 b=CgBF6iZ8Mx7ONWJAjtAjsMlFdGpbq2a/qm2qKnfdkNtZLLFwpqNUVA82brofgeX/5Zq6BfXUs1cN+aYldYOZ6xvcN74ZxwLxVJcfVjxuSR0wU9C9lxsvSAASYDJOkq3sU2T1ydShT+EzzJse4L3ZM+vx8uyvJCqfY9OfIX++gLb2+7BI/75h4Iob505PQYeuzZyLw+BX3mMh8RvA5BlAgn00K3I32qOsRZCcsTgQnfmUj33/7pSXZHmMHaqYQm4ggF7VDUzdm55CBNzC0+NWa3jh3B+TKjsJG+wMRSZfssLh1QQL2Eu6/SXuJd2LX4wuJz2EzC2SQEawH/6QX3kL8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ytndxm9ZVFAhJ6JGXDjMpKDnktB4vryboUH8Km7qEA=;
 b=iwWJcxrKhnZXkv458yMYZgm3a8T+qUfP32jEYI215Z/6lDPIY1BqVFG28L1dKFp78ctjmc1mcTJUnK8GkuNv3se41XPvpLRQdz38sA2xY9eApoMMH7iyxW/h3ST8ey6ZCmKTN8hLe+N3WvBX8BedmBjXAqEWy+yFI7bGHqWhZ5Y=
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM6PR04MB5912.eurprd04.prod.outlook.com (2603:10a6:20b:ab::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 9 Jul
 2020 06:26:36 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a%3]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 06:26:36 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Jun Li <jun.li@nxp.com>
CC:     "balbi@kernel.org" <balbi@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "pawell@cadence.com" <pawell@cadence.com>,
        "rogerq@ti.com" <rogerq@ti.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: cdns3: gadget: own the lock wrongly at the
 suspend routine
Thread-Topic: [PATCH 1/1] usb: cdns3: gadget: own the lock wrongly at the
 suspend routine
Thread-Index: AQHWVQp3Rt8mOl2Uc0WzqZpoCRSvX6j9rsYAgAEa+oA=
Date:   Thu, 9 Jul 2020 06:26:36 +0000
Message-ID: <20200709062644.GB17510@b29397-desktop>
References: <20200708093043.25756-1-peter.chen@nxp.com>
 <VE1PR04MB6528647055C8D740ED81E7C389670@VE1PR04MB6528.eurprd04.prod.outlook.com>
In-Reply-To: <VE1PR04MB6528647055C8D740ED81E7C389670@VE1PR04MB6528.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9a20a533-0f29-4a84-416d-08d823d10835
x-ms-traffictypediagnostic: AM6PR04MB5912:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB591279ABB79ED77C0F74B2838B640@AM6PR04MB5912.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ote3ateXNSUvCfDzCUTsI2EZghvucahfn3HmXGdVzA4Vwasa+tIK00skcVp/NLDAckk7bkUQuzrlAW9ZX53cd5Gytnmp0piRF7lczRkY9zDySByWKcqaquc9LkrX0IG8VNVMOBiFkzDYxJzGTy3SfHQ5/lAGvhd+VT4MwGmE3bGxV7NXIXiYeT7xztZ0U5xK0SsRMMDEg11CkuFcWipMCQbnkiEtAsKlhdOZqnQjGAJrZ8XQLBW8Yj6M+r+3gHhXhM9RcDJD+oJz5wsk2dmB0/v7PvdRMirIUJmrJSa65AEKRQXsTE0mrr4JyFhMOw7Gtm7QluZwSSfS9eCbS4XcMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(396003)(136003)(376002)(39860400002)(346002)(366004)(33716001)(54906003)(66946007)(86362001)(8676002)(8936002)(6636002)(1076003)(15650500001)(66476007)(64756008)(5660300002)(66556008)(76116006)(2906002)(66446008)(91956017)(6486002)(4326008)(316002)(53546011)(6506007)(44832011)(6862004)(83380400001)(9686003)(33656002)(186003)(71200400001)(26005)(6512007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QAPHVonwqw+QRbJ43RwrY5hFq6TpNLJsT4bz1HejBiR8bOtvEXHmBHgWEDyKnSnsYL/dDGPAu72pDpNXkd1ti46Ebl/iB8okFN2wtdXepQ93biXjSG4RpWGJ+yMVIAoC89UYxOKS/M2hTFkfoRp2eI7z1vMHL4IamZTX1UcfSdEdSvLsO9gZQWdNWjkqEtgAAMzZS9gsBT+mTCyIfUnJ/46OB5+TNcmvyfIJWS+kzfpWwD2l4DYp5nJS3Hn+3YSmR1ax8AmxuSL7SAYYPff+pWp+1zp5Q6FUDz4NDoRez6Okkvn6d7Ll7UA6Q6Z01ZTgX03B5ieNxT47QFfmcP5kaE/URUlKpSG1MG4xI1tQyUykDOQw2VxtqF5NHNWCAeDj4Xzvnv5gb8hBGmF6v9PhHGirKpASrnasDFFO3Mk5/iHsDpmSq58qNEnIr+FUJP3i6EzYOnzq9rClqjNtW9vevHX3qLbDaN5U5L1nPAqpusU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <895B3B77C7467348B47D68B0FBF71488@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB7157.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a20a533-0f29-4a84-416d-08d823d10835
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 06:26:36.5033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ecoAUjKjiNvB+NZ3EaRI1c+g39B96AE1ywYeVhMD8pVDFrfeRVmRyWnQ60ydxfhgtrTbix+/PUSM2pU0J+ZhMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5912
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-07-08 13:33:56, Jun Li wrote:
>=20
> Hi,
> > -----Original Message-----
> > From: Peter Chen <peter.chen@nxp.com>
> > Sent: Wednesday, July 8, 2020 5:31 PM
> > To: balbi@kernel.org; gregkh@linuxfoundation.org
> > Cc: linux-usb@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>;
> > pawell@cadence.com; rogerq@ti.com; Jun Li <jun.li@nxp.com>; Peter Chen
> > <peter.chen@nxp.com>; stable <stable@vger.kernel.org>
> > Subject: [PATCH 1/1] usb: cdns3: gadget: own the lock wrongly at the su=
spend routine
> >=20
> > When it is device mode with cable connected to host, the call stack is:
> > cdns3_suspend->cdns3_gadget_suspend->cdns3_disconnect_gadget,
> > the cdns3_disconnect_gadget owns lock wrongly at this situation, it cau=
ses the
>=20
> Isn't afterwards the lock will be released in cdns3_suspend() by below co=
de?
> spin_unlock_irqrestore(&cdns->gadget_dev->lock, flags);
>=20
> > system being deadlock after resume due to at cdns3_device_thread_irq_ha=
ndler, it
> > tries to get the lock, but will never get it.
> >=20
> > To fix it, we delete the lock operations, and add them at the caller wh=
en necessary.
>=20
> There are 2 caller places, by this, another code path:
> cdns3_suspend->cdns3_gadget_suspend->cdns3_disconnect_gadget() will do
> gadget_driver->disconnect() with lock hold, is this intentional?
>=20

Oh, my oops. This patch is based on my PM patch set which delete the
gadget_dev->lock protect at cdns3_suspend, please skip it.

Peter

> =20
> >=20
> > Cc: stable <stable@vger.kernel.org>
> > Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> > Signed-off-by: Peter Chen <peter.chen@nxp.com>
> > ---
> >  drivers/usb/cdns3/gadget.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c in=
dex
> > 13027ce6bed8..f6c51cc924a8 100644
> > --- a/drivers/usb/cdns3/gadget.c
> > +++ b/drivers/usb/cdns3/gadget.c
> > @@ -1674,11 +1674,8 @@ static int cdns3_check_ep_interrupt_proceed(stru=
ct
> > cdns3_endpoint *priv_ep)
> >=20
> >  static void cdns3_disconnect_gadget(struct cdns3_device *priv_dev)  {
> > -	if (priv_dev->gadget_driver && priv_dev->gadget_driver->disconnect) {
> > -		spin_unlock(&priv_dev->lock);
> > +	if (priv_dev->gadget_driver && priv_dev->gadget_driver->disconnect)
> >  		priv_dev->gadget_driver->disconnect(&priv_dev->gadget);
> > -		spin_lock(&priv_dev->lock);
> > -	}
> >  }
> >=20
> >  /**
> > @@ -1713,8 +1710,10 @@ static void cdns3_check_usb_interrupt_proceed(st=
ruct
> > cdns3_device *priv_dev,
> >=20
> >  	/* Disconnection detected */
> >  	if (usb_ists & (USB_ISTS_DIS2I | USB_ISTS_DISI)) {
> > +		spin_unlock(&priv_dev->lock);
> >  		cdns3_disconnect_gadget(priv_dev);
> >  		priv_dev->gadget.speed =3D USB_SPEED_UNKNOWN;
> > +		spin_lock(&priv_dev->lock);
> >  		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_NOTATTACHED);
> >  		cdns3_hw_reset_eps_config(priv_dev);
> >  	}
> > --
> > 2.17.1
>=20

--=20

Thanks,
Peter Chen=
