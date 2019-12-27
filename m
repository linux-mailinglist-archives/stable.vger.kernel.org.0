Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD97B12B05E
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 02:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfL0BqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 20:46:07 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:32258
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbfL0BqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Dec 2019 20:46:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZLqSU5i9LFBMCrcerz+cCZj35Vshrq/GMmEhWywHxxnf1EeDdx9wUbCYibXCMNktbykWovqCuvH2OYmIPKXHLvFlsvnDo7z8UhrkC7KvnZZAIOtTM6XkqXapo+MtYk+Fal6TJRdhU9z2DjG7GxJY2JCUQeRuZITdA2fxMbRQUCgRo9aGXAOH9kjxUxbs8gPI4MtKhtbA5uLDjnp3XwTEBjhmIU3BUOOKZYr3MJqN2UceYTeoIpYCbProTRw3XpkAnIpREklFcAzKMqAkHdD18XpFIgMaRPFTob4GyKZUhFY1vCRl/d786XSpsxpbk5mNjgBxPz2AV8vC3OcU2bYKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qtd8tPSeqTssjbR64Q5CV/YxZyJfUBJybV6hbL303Do=;
 b=dosVoP7Jpc1x7lqTH3/6vaNcpzZAMYCAHQdlvLy8Gv2FDSbtD8S8LoLk0d9cmiIX+G5sSXbo9Qv61gpfzZaibrFJtEpL5GeBUgWtrO5BH5Lh3C42qhQchxbNHz8BtftnMSsu+TaeY8xEnLYeMgNBKvHEF6yUjyH/lNRgJoHQwJsArkfozVIoGUCzsX2T1kPGNwlUI4dli7aPHXt1a3OXT7p1LaV/YgzyODSQYE4LWzZU3zvNFKvA6WyGVf6UspW64jnmnUSw/jTTwhlgrBN+yNpx3kcrbPWSdk4kpDM1m4PFDCGFczkuFUD+3mUcd6DSDUmS0P+Hg3iVApTgSvc+Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qtd8tPSeqTssjbR64Q5CV/YxZyJfUBJybV6hbL303Do=;
 b=VsbuEvoeBh2lvodIlSNsKmIwV+MdobmWV8sU4je8U0as0QqK85NVRCghUX8g00ENqwTCB5k7yjtZwuYLqGX1Xda2J2QWswfvGAaYDZD2ELnD1XO0p5+S1SgEVVEM7EL4i6PMxO5UODzkX/7Wf+0AUmo/2sW3l5Yj3w5hvcQl5s4=
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com (20.177.51.23) by
 VI1PR04MB4318.eurprd04.prod.outlook.com (52.133.15.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 01:45:24 +0000
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::c7d:58a2:7265:407e]) by VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::c7d:58a2:7265:407e%6]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 01:45:24 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     Peter Chen <peter.chen@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: chipidea: host: Disable port power only if
 previously enabled
Thread-Topic: [PATCH] usb: chipidea: host: Disable port power only if
 previously enabled
Thread-Index: AQHVvAVIstmi2Z+Az0y8RyzR9GDiKqfNNo6A
Date:   Fri, 27 Dec 2019 01:45:24 +0000
Message-ID: <20191227014521.GB5283@b29397-desktop>
References: <20191226155754.25451-1-linux@roeck-us.net>
In-Reply-To: <20191226155754.25451-1-linux@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.chen@nxp.com; 
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7cf39e7c-a97d-40f7-3a08-08d78a6e712b
x-ms-traffictypediagnostic: VI1PR04MB4318:|VI1PR04MB4318:
x-microsoft-antispam-prvs: <VI1PR04MB4318BC516E93CEBE16EF6EF38B2A0@VI1PR04MB4318.eurprd04.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0264FEA5C3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(199004)(189003)(81166006)(8936002)(33656002)(66946007)(81156014)(1076003)(33716001)(45080400002)(91956017)(66446008)(53546011)(8676002)(6506007)(26005)(66556008)(64756008)(478600001)(66476007)(76116006)(186003)(6486002)(2906002)(6512007)(6916009)(316002)(44832011)(54906003)(71200400001)(86362001)(5660300002)(4326008)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4318;H:VI1PR04MB5327.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eKXrxEgw0+m5tZdt5tPcGPtZOg4+34TvzdqEKVx7jYt66kG3qU0QiIOE5w/33+we0Tef1A9JGzh89BCT62bTQ0BUkjOrQGgx08RWFVxntAmufg6waTSJWVg/ZVtrjlndau38gMriyE8Q9RdH4WLI+9FH9sbVn04wf32JDvdACGF0D53YNEU3yFfblaNOQEw8nMUlOHZCLV5DGZ5AZ1YlUlmtKyLdr0ihXRi6T5a2VbhgxrsRaEQagwWJvtz4itlsJIm32zvSB6MokRMWJxSGlZ+4lZfkXS2YPgE61FUp/j+n6fN5DV/BemHBfNx1HCuUfRrNGqZbp2a0H5JaEyg1cif4dRvsMjTMInYf1atsG0Mdwty2Ro0ztwbzxOVaZmntONAajgeg3E5g3sQfnmLzDsn+Hg3BoVGrEobNlcngf5VdrOUf8BSIiN67kWG/llb8
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D0457B39C313C44B844764F716655117@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cf39e7c-a97d-40f7-3a08-08d78a6e712b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2019 01:45:24.4289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OFe4vjPoQpgqasM9+2eDyB1ULJFrrxrotbeugKcpN0JLZKf0jVfFFIwH5OJhhW4s0oPAYVTiWE+Uhfp59HrjjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4318
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19-12-26 07:57:54, Guenter Roeck wrote:
> On shutdown, ehci_power_off() is called unconditionally to power off
> each port, even if it was never called to power on the port.
> For chipidea, this results in a call to ehci_ci_portpower() with a reques=
t
> to power off ports even if the port was never powered on.
> This results in the following warning from the regulator code.
>=20
> WARNING: CPU: 0 PID: 182 at drivers/regulator/core.c:2596 _regulator_disa=
ble+0x1a8/0x210
> unbalanced disables for usb_otg2_vbus
> Modules linked in:
> CPU: 0 PID: 182 Comm: init Not tainted 5.4.6 #1
> Hardware name: Freescale i.MX7 Dual (Device Tree)
> [<c0313658>] (unwind_backtrace) from [<c030d698>] (show_stack+0x10/0x14)
> [<c030d698>] (show_stack) from [<c1133afc>] (dump_stack+0xe0/0x10c)
> [<c1133afc>] (dump_stack) from [<c0349098>] (__warn+0xf4/0x10c)
> [<c0349098>] (__warn) from [<c0349128>] (warn_slowpath_fmt+0x78/0xbc)
> [<c0349128>] (warn_slowpath_fmt) from [<c09f36ac>] (_regulator_disable+0x=
1a8/0x210)
> [<c09f36ac>] (_regulator_disable) from [<c09f374c>] (regulator_disable+0x=
38/0xe8)
> [<c09f374c>] (regulator_disable) from [<c0df7bac>] (ehci_ci_portpower+0x3=
8/0xdc)
> [<c0df7bac>] (ehci_ci_portpower) from [<c0db4fa4>] (ehci_port_power+0x50/=
0xa4)
> [<c0db4fa4>] (ehci_port_power) from [<c0db5420>] (ehci_silence_controller=
+0x5c/0xc4)
> [<c0db5420>] (ehci_silence_controller) from [<c0db7644>] (ehci_stop+0x3c/=
0xcc)
> [<c0db7644>] (ehci_stop) from [<c0d5bdc4>] (usb_remove_hcd+0xe0/0x19c)
> [<c0d5bdc4>] (usb_remove_hcd) from [<c0df7638>] (host_stop+0x38/0xa8)
> [<c0df7638>] (host_stop) from [<c0df2f34>] (ci_hdrc_remove+0x44/0xe4)
> ...
>=20
> Keeping track of the power enable state avoids the warning and traceback.
>=20
> Fixes: c8679a2fb8dec ("usb: chipidea: host: add portpower override")
> Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Cc: Peter Chen <peter.chen@freescale.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/usb/chipidea/host.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> index b45ceb91c735..48e4a5ca1835 100644
> --- a/drivers/usb/chipidea/host.c
> +++ b/drivers/usb/chipidea/host.c
> @@ -26,6 +26,7 @@ static int (*orig_bus_suspend)(struct usb_hcd *hcd);
> =20
>  struct ehci_ci_priv {
>  	struct regulator *reg_vbus;
> +	bool enabled;
>  };
> =20
>  static int ehci_ci_portpower(struct usb_hcd *hcd, int portnum, bool enab=
le)
> @@ -37,7 +38,7 @@ static int ehci_ci_portpower(struct usb_hcd *hcd, int p=
ortnum, bool enable)
>  	int ret =3D 0;
>  	int port =3D HCS_N_PORTS(ehci->hcs_params);
> =20
> -	if (priv->reg_vbus) {
> +	if (priv->reg_vbus && enable !=3D priv->enabled) {
>  		if (port > 1) {
>  			dev_warn(dev,
>  				"Not support multi-port regulator control\n");
> @@ -53,6 +54,7 @@ static int ehci_ci_portpower(struct usb_hcd *hcd, int p=
ortnum, bool enable)
>  				enable ? "enable" : "disable", ret);
>  			return ret;
>  		}
> +		priv->enabled =3D enable;
>  	}
> =20
>  	if (enable && (ci->platdata->phy_mode =3D=3D USBPHY_INTERFACE_MODE_HSIC=
)) {
> --=20

Acked-by: Peter Chen <peter.chen@nxp.com>

--=20

Thanks,
Peter Chen=
