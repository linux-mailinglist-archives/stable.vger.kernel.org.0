Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3257511C6D2
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 09:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfLLIKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 03:10:00 -0500
Received: from mail-eopbgr00052.outbound.protection.outlook.com ([40.107.0.52]:5255
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728150AbfLLIKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 03:10:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzCO1HNVnE1uHSdPBNHKWoHBjOiefXyAFifi+nz4bc5OTanjP1vZz9yDG6+DrMbjD6FyERnhRruUv9l1PT4Zw9c0frdIqpvg8Cr1YOpbjHwhxfImGXgRrdq/vamzPldBhxi3z7aFzvf2VZHieYAWnkCnVdOmQehMo42iSXYEykaA7QQ6iCu5piU3ToGyHh84knqFC+ROOvNaAb21enqPOYC8izxSvcHy9P3fXG3i+IjFPi43cCVjAGHicDa8rECQa9+8Bdle3DuBtyvAb+LbKTU0lPNXfUMLZWYx2nATrTFUEnjHBK1ZSZiZvFBJsT07cWB21dYjwTWmd/T8X9KjrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+bt78+TK9Izlb270cmWwFGCanMsDj6MRnS56lli0hk=;
 b=IqjxV8MwlMYiBEJ8JtZ8rrYToywVgnmVyoOz03a58iEl9YrGtdqd+P1hik3jrZ71kQVZ/wgYKCRxNC+2TMvcp/Vin2kGBD9NNyqR12p84tiKK44f8NArhCayO1U7FDko4psOxRXoOUH5xDRErCUSqlTSkallQYE8vAouBlHxVhoJWD2JUNle5jz3BOQ8NtkJ3z4ngg5pOBaRbSdkuGmqwR131Xns3sN4/j0m/hwipyiocfdf5VV5R4yFnU1qeoa0uoLHMerVBb8cqVDPdKYvWXEAIGYcYjtduNGHMnKBuiajMSsWiIxGpQuYRFxbcMfUxMf2tbsF3LPVtmtzkEtM6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+bt78+TK9Izlb270cmWwFGCanMsDj6MRnS56lli0hk=;
 b=cQGKGn5d7CWimCcYJvFx6tusHfOh1evFrkR03U2n1gElw9pVuyMiZzhatLjYzm8D4VaisFJoyiEnY379lI1HBEuEIJWfQWTPtx47xE9Jg1Cl66A/+YUTR4W64jeQVBnE7NkV1zGUgz6bTZ+5SgNljpQtqXm5eLNIe6F0gan7XDQ=
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com (20.177.51.23) by
 VI1PR04MB4174.eurprd04.prod.outlook.com (52.134.30.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 12 Dec 2019 08:09:56 +0000
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::cd33:501f:b25:51a9]) by VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::cd33:501f:b25:51a9%7]) with mapi id 15.20.2538.017; Thu, 12 Dec 2019
 08:09:55 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Felipe Balbi <balbi@kernel.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>, Jun Li <jun.li@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] usb: gadget: f_fs: set req->num_sgs as 0 for sync io
 mode
Thread-Topic: [PATCH 1/1] usb: gadget: f_fs: set req->num_sgs as 0 for sync io
 mode
Thread-Index: AQHVsKDizJBJhPXRY0awfinO/GM7Sqe2Da2AgAAXwDA=
Date:   Thu, 12 Dec 2019 08:09:55 +0000
Message-ID: <VI1PR04MB532743340CE35C4F236FEAB68B550@VI1PR04MB5327.eurprd04.prod.outlook.com>
References: <1576123160-28931-1-git-send-email-peter.chen@nxp.com>
 <878snixcvg.fsf@kernel.org>
In-Reply-To: <878snixcvg.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.chen@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 11caddcc-d467-4796-5450-08d77edaac92
x-ms-traffictypediagnostic: VI1PR04MB4174:|VI1PR04MB4174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB41748B41F11CD532998E45418B550@VI1PR04MB4174.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(66946007)(8936002)(186003)(55016002)(86362001)(5660300002)(76116006)(4326008)(54906003)(7696005)(9686003)(52536014)(66446008)(66476007)(64756008)(8676002)(66556008)(33656002)(6506007)(81156014)(81166006)(71200400001)(26005)(316002)(2906002)(478600001)(44832011)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4174;H:VI1PR04MB5327.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IKj+ASPFdB1BS/vjeKr6BX84YGW1yuXERVRGMMcF6Fov4vZjGxC3FYYLBNG2AlAaYRO7ZwKUNI20S8FSd6ClTtOBhO/7hLPHpo027LAGZJ57zFzpsawH1MUAPYd9ytYisTTm36eJS6mDqUOAzZnIrjt8udJsqNcdr7NM354uYjZDs6ZqLWj5CqtsRmA8Hz/FXmvr1jgfzJN/iJC21f+IvpOaW4YgZpB9yF6NIEgL7HzqUEZ/9szZUXGqD3i0fQdTzAU7DmdDxqNuzlnK2UlzI+ELMcdBrVo6Amo+8mndm57NQRCBteO6ZPEr2O+mn3M19tvDwOwztkuxRbikbFj0jCIMfpSRMfgFgsiC+gfn5siRou6ubDK3Z/QX7Ewn8TV7rXSaMgTAiVYRVstYPQVXns7oQ6BDTRCBcAmPLM7pYV3Jr6WchalPDqHw1i2uyb3w
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11caddcc-d467-4796-5450-08d77edaac92
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 08:09:55.8266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FCfBLxp9nkw+6KWnlsHzdFgq7kfuW9hqSMiqT+M7QGVDjzhK0iefcWHA1bb+l8iQx3Y2zygfAXUTr174LeaCxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4174
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=20
> Peter Chen <peter.chen@nxp.com> writes:
> > The UDC core uses req->num_sgs to judge if scatter buffer list is used.
> > Eg: usb_gadget_map_request_by_dev. For f_fs sync io mode, the request
> > is re-used for each request, so if the 1st request->length >
> > PAGE_SIZE, and the 2nd request->length is < PAGE_SIZE, the f_fs uses
> > the 1st
> > req->num_sgs for the 2nd request, it causes the UDC core get the wrong
> > req->num_sgs value (The 2nd request doesn't use sg).
> >
> > We set req->num_sgs as 0 for each request at non-sg transfer case to
> > fix it.
>=20
> The patch, however, is *removing* initialization to 0...
>=20
> > Cc: Jun Li <jun.li@nxp.com>
> > Cc: stable <stable@vger.kernel.org>
> > Fixes: 772a7a724f69 ("usb: gadget: f_fs: Allow scatter-gather
> > buffers")
> > Signed-off-by: Peter Chen <peter.chen@nxp.com>
> > ---
> >  drivers/usb/gadget/function/f_fs.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/usb/gadget/function/f_fs.c
> > b/drivers/usb/gadget/function/f_fs.c
> > index eedd926cc578..b5a1bfc2fc7e 100644
> > --- a/drivers/usb/gadget/function/f_fs.c
> > +++ b/drivers/usb/gadget/function/f_fs.c
> > @@ -1106,7 +1106,6 @@ static ssize_t ffs_epfile_io(struct file *file, s=
truct
> ffs_io_data *io_data)
> >  			req->num_sgs =3D io_data->sgt.nents;
> >  		} else {
> >  			req->buf =3D data;
> > -			req->num_sgs =3D 0;
>=20
> ... this doesn't seem to match your commit log. Care to explain?
>=20

Sorry, I did not check the patch when I formatted it. I need to pay more at=
tention to it next time.
I will send it again.

Peter
