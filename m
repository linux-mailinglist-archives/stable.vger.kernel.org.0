Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE10FC050
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 07:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfKNGpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 01:45:01 -0500
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:46754
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbfKNGpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Nov 2019 01:45:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myrPNloSgODuDVF+Lxy8Rys8OoeP9l7Bco0IQeUPbc9b1ceNsLSxILF8gy1spJBOo0eNJQssedntEBomFeJlVY7kJl59rAbbUfW48d/XXBhBByzhTDz4H5rpIYTkqPlGEqK+xHgIf3/4V3Y/9HieLDk8a7nmhmcTcDJ8o2lSIncqSc+OzXmRSBfYi6d4u72hU4wfcJlMfV0aoFC5ngcFzD2cxj+qUTF+5eROTMYM2g9+hOoVaQpCZKEch7LWo5tifeRBVrqOxCTDFgeOhFpAN5hxjyPiD2ovxhaxU1Axd6VvLuAoSUhUZwMHcXyahLSuIOyWZVVsXrtZOp663dN+gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c90VjeDbT9GrWbIefYagslXlWp0qzbIYDp2utrm7agg=;
 b=OqxkQXUtwYWObzMiwNsKRuUER2scUIz5NpqtBgf5A7SC8FHjSBu0KcTB0mDl7c85PYKfO6fxw4K08q6Q8ykp7soksvPIINGI/WWuUw/K/HDZ+bEkFenluRBxv9c7/aKKhDWYkIdcVkoxb937ruCpPn31vXNzpFzAxYCZPC2YNOsu0Byw3bhOlD0qp+YPDn2F29wTtDHp3gKO0SeMot2CM91/GigEwtYJq0R6qzroa/hBryuUqGnkVE5Az2EGCr+DyRP9510CJayfUNSgLc66vvG4jemALTPrXz0BxQYRSKk29Z0x6nrgKWpWBeR5VbH0rBCi+51bN15vaAwWE4z+Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c90VjeDbT9GrWbIefYagslXlWp0qzbIYDp2utrm7agg=;
 b=UYjojj0BPM70smIw7BjjjMXRYs7BDwFaYsN8c/0Tog5P1OCDu+cwMjKtOLu8tm2mKReZTi1cRUXdiQRp2f6q1/19K+/09mHqx6WY6h9ciFj/uAK+MqDijmNd094KaUYZmNLEdmOyupENDRP/E22K/W7paPPds83YzNVUnGZguiE=
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com (20.177.51.23) by
 VI1PR04MB5072.eurprd04.prod.outlook.com (20.177.50.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 06:44:58 +0000
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::cd33:501f:b25:51a9]) by VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::cd33:501f:b25:51a9%7]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 06:44:58 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 4.19 093/125] usb: gadget: configfs: fix concurrent issue
 between composite APIs
Thread-Topic: [PATCH 4.19 093/125] usb: gadget: configfs: fix concurrent issue
 between composite APIs
Thread-Index: AQHVmMAk0+NCuNSe+0SwjLKirLuN5KeJIN4AgAEXLnA=
Date:   Thu, 14 Nov 2019 06:44:58 +0000
Message-ID: <VI1PR04MB532778F3728AB7465D0892F38B710@VI1PR04MB5327.eurprd04.prod.outlook.com>
References: <20191111181438.945353076@linuxfoundation.org>
 <20191111181452.322265396@linuxfoundation.org>
 <20191113134935.GA20980@duo.ucw.cz>
In-Reply-To: <20191113134935.GA20980@duo.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.chen@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 76415925-ab42-4310-cc05-08d768ce2a7e
x-ms-traffictypediagnostic: VI1PR04MB5072:
x-microsoft-antispam-prvs: <VI1PR04MB50727A5890F0315BC8E8B71C8B710@VI1PR04MB5072.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(199004)(189003)(54906003)(6246003)(110136005)(33656002)(186003)(99286004)(7696005)(256004)(76176011)(52536014)(14444005)(478600001)(5660300002)(14454004)(316002)(74316002)(102836004)(66066001)(26005)(25786009)(7736002)(305945005)(4326008)(71200400001)(71190400001)(6506007)(229853002)(44832011)(476003)(81166006)(76116006)(486006)(2906002)(8676002)(66556008)(3846002)(64756008)(81156014)(6116002)(66476007)(66946007)(66446008)(8936002)(86362001)(55016002)(9686003)(11346002)(6436002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5072;H:VI1PR04MB5327.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dcHlKmuWV3QGS+2rJLQfu42C7W/iQlC5phX/7/QKb0aR7S+CgyAZAgKrADs+zzqKlvlw+H2BXZiVYObQnFWT0AR8kb6QzIgyIK4RGVVt6KWyTWvueBlgVMIVl7VWoiZXDs0nJkaSPhl1cgYqUOeOa68s7SikTEdqfwsaZX7Xmoc8ntdrzOG6aW5eGLvFu+J0x3e2wPdTZKwb2gRO5jph5j/HlFlib6bLVIVN4h4rL1ltv7H0UhO9gFmEwi6xtrockJg74QU9j6CnFr/AQIYaz/+swwx0CyoDCX4kEIBKfs8yiohbKXq45L2y/2ux25uxgOBqpD4Tron31guoKnzvZwSQto8WPiUdM1X8AXrA27k60oFz13tYyAMoTrCd5CK7cbL15VYm/kBhPIdjAkFH0wiSapAkR2LEIzqvZVINwA8hiooX3fW5xv0vEE2+d19A
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76415925-ab42-4310-cc05-08d768ce2a7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 06:44:58.0739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C+JMv2OFLWx8cgrzEUx9sYHngxwydcfIAKKrUANT9vLZuzOEXwzwbiBeQps/7P58pjlMwu6iYruy/ZXplBJqSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5072
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=20
> >
> > We meet several NULL pointer issues if configfs_composite_unbind and
> > composite_setup (or composite_disconnect) are running together.
> > These issues occur when do the function switch stress test, the
> > configfs_compsoite_unbind is called from user mode by echo "" to
> > /sys/../UDC entry, and meanwhile, the setup interrupt or disconnect
> > interrupt occurs by hardware. The composite_setup
>=20
> > +++ b/drivers/usb/gadget/configfs.c
> > @@ -61,6 +61,8 @@ struct gadget_info {
> >  	bool use_os_desc;
> >  	char b_vendor_code;
> >  	char qw_sign[OS_STRING_QW_SIGN_LEN];
> > +	spinlock_t spinlock;
> > +	bool unbind;
> >  };
> >
> >  static inline struct gadget_info *to_gadget_info(struct config_item
> > *item) @@ -1244,6 +1246,7 @@ static int configfs_composite_bind(struct
> usb_gadget *gadget,
> >  	int				ret;
> >
> >  	/* the gi->lock is hold by the caller */
> > +	gi->unbind =3D 0;
> >  	cdev->gadget =3D gadget;
>=20
> Since variable is bool, I'd expect "=3D false" here?
>=20
> > +	unsigned long flags;
> >
> >  	/* the gi->lock is hold by the caller */
>=20
> "is held".
>=20
> >  	cdev =3D get_gadget_data(gadget);
> >  	gi =3D container_of(cdev, struct gadget_info, cdev);
> > +	spin_lock_irqsave(&gi->spinlock, flags);
> > +	gi->unbind =3D 1;
>=20
> =3D true;
>=20
> > +static int configfs_composite_setup(struct usb_gadget *gadget,
> > +		const struct usb_ctrlrequest *ctrl) {
> > +	struct usb_composite_dev *cdev;
> > +	struct gadget_info *gi;
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	cdev =3D get_gadget_data(gadget);
> > +	if (!cdev)
> > +		return 0;
> > +
> > +	gi =3D container_of(cdev, struct gadget_info, cdev);
> > +	spin_lock_irqsave(&gi->spinlock, flags);
> > +	cdev =3D get_gadget_data(gadget);
>=20
> cdev already contains required value, why get it second time? (If it need=
s to be
> done under lock, comment might be useful...)
>=20

Hi Pavel,

Thanks for comment.

The reason is the cdev may be set to NULL by configfs_composite_unbind thro=
ugh
another process, eg, the user wants to disable current USB gadget function,=
=20
this patch tries to fix such kinds of concurrent issue.

Peter
=20
=20
