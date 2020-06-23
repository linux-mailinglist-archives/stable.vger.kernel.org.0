Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D599204A6A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbgFWHBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:01:55 -0400
Received: from mail-eopbgr40058.outbound.protection.outlook.com ([40.107.4.58]:28878
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731291AbgFWHBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 03:01:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO2esljOsMj4F2w7ZikjGR2eF1cQyoZYq+Emsd0YjXlLcZ8mX+D9wgBVhXD/gIhoyDPm/1WzhcolousQ+GXnrLOxovoW3pBxfoZwHWEnHIVuom1WbnT8DtUo/l7/3BwWk0je1Pex4M58x43cKDCHnii2eNY4UVIVaFv8Wd/4r4vOMG+QFIBKbzHccnuXx2twDCbgz3M+7uFrXm1eS4j+8kdJ034AeWORMT1TtQPJgyvM50lWjXcrT0MaV3u80BlVsUfBK/XCO9nJlvkAF9mteMo0YoKJAggldwS90f5BkXjAgRXkzVKokW0KVH080xrNl3t6nxbAt2vVvK3D/UN6Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yz8SlhwyneISI5WmMDxQbjYvKxf2pJnzwLF8FlbUsOo=;
 b=FSeWwHzV+9swtGxzNznQ/WB021utRBJvRurZaKtPAriUuTV8sogZ1U6HVLqyQhb0E9wYx8VHs9MpHAu3ykJrTNobZzloiRb3+AJJB/IYKgZbljwq6Hqq60WUk19UnJuSe1uUoMbCNx0FASzB3JC7nCdbEQ3yeOep7xNVQi5CNh2iUlC6EY+iedUAEHPW0LxMwpYpMciLh9l1bjNyqgNS/plqqPQwqRxUGuvNwZTxFqW6xckr+c1KbBMubZuvZHJ1fuF+DIRFcnwpdqbBhW11GPKabktRtuCJoYSrSXMTLJz3fSP6Y1EiBV2eVGVzToQ96V7FifCR4udZND3mOeSyqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yz8SlhwyneISI5WmMDxQbjYvKxf2pJnzwLF8FlbUsOo=;
 b=mPtTCwqu46YM4caDXgEF4KjvdxJjG1JOHrwIVLtX0lk/esZWZrC5k0Y23sKPPEix+uMRECbELtZovkyHKaF65a0GCHrPUy8YNNPZIhutfKN9JjvZoilpbaZDu25eo21VqwS8GrSjDpvoQMQmmclszS+kRmkeKLcvDS7eXvjAC3I=
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB6824.eurprd04.prod.outlook.com (2603:10a6:20b:10e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 07:01:50 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 07:01:50 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Pawel Laszczak <pawell@cadence.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "rogerq@ti.com" <rogerq@ti.com>, Jun Li <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/3] usb: cdns3: ep0: fix the test mode set incorrectly
Thread-Topic: [PATCH 1/3] usb: cdns3: ep0: fix the test mode set incorrectly
Thread-Index: AQHWSQupFw5V8uHuF0SjT1pMG/f4DajlwbcAgAAEHVA=
Date:   Tue, 23 Jun 2020 07:01:50 +0000
Message-ID: <AM7PR04MB7157421522B2ADE6F75A0A518B940@AM7PR04MB7157.eurprd04.prod.outlook.com>
References: <20200623030918.8409-1-peter.chen@nxp.com>
 <20200623030918.8409-2-peter.chen@nxp.com>
 <DM6PR07MB55299792641156038575FC4DDD940@DM6PR07MB5529.namprd07.prod.outlook.com>
In-Reply-To: <DM6PR07MB55299792641156038575FC4DDD940@DM6PR07MB5529.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: cadence.com; dkim=none (message not signed)
 header.d=none;cadence.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [222.67.222.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e0103b9-3ad7-4941-965a-08d817434da0
x-ms-traffictypediagnostic: AM7PR04MB6824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB6824173513C4097D7363763B8B940@AM7PR04MB6824.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UYzHf/TOHk48un/ypuy5D7deDUMqJU7D9WfrS7nPuqv/TTq+fQ+d30e0oLQybr0FqKEhrK4KfJZrCkHNyZH+LOJqcbsmi+QoQC5hkKs2Fo7Ujza4E2kV3FRDs0djycXZiTPq+gp8MsO2EEWwhPWPasizddzZR2iZwvHo95XWbGT2supjtkNP+XOvJo60bnKtziFRf5OkXqPTS/xvfBpUmfA3ddVT7+XL8sFwFLvWLlkp2Cn5xJLs5FDn+DMLxJ05VeuMkWk4yayFLDHD5K0h5ct4U28av70RzqlnFZYHPHFBKukSEOWr6mTH+5qzHkGjSaf195AYRjeXMaXXhN125w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(55016002)(478600001)(9686003)(4326008)(6506007)(110136005)(7696005)(26005)(8676002)(71200400001)(186003)(8936002)(54906003)(2906002)(5660300002)(52536014)(4744005)(44832011)(86362001)(316002)(33656002)(66946007)(64756008)(66446008)(66476007)(66556008)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NOVWyvU/SoF4gaHE2SQYGODSVM5L5UFQoFaBiganrXFhUV7WtkkZ6SA6RkFtW12cZCU68JTQKhf5kLyXyOm0gEW1wtBhpsX0luFR/Qw+sUf+4EV+wp0CLUbRxt7rak/i0BjCQcV1xtsMc+eY9lZbWcEh5dTpW5ArsS7nik58lskf+eVKlgGUgHMRr11+QVBrytymlu5bQRVSu0jFqcAIQQF1mxi1D0fvb9DqcWg2eAcQk2ZHO0D1733Vn6rJ8RZdJBPF/aG9qiGultqtKAdM+e0bmVo5ysKbrAfutEuRYS/12DASaq9ekC4BPV5G/ad1+FN7/1+EqaJ4MJD/EHD7Of7CPTu8EA9gXCqhnwoQoZXktWTiGH5CrnImkA0vU+uWlpTfRummFYcUV0a8GE26agVobT6Ngjzj7PA+4dgnJP8b3LwIMHaQYcl4hUvRbsW8mPbIcUk6cfP7r3CjyEqJts/CkBTAdjunON9+JgTQkFbLDAxCiRi6TofQVHmuzeUq
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0103b9-3ad7-4941-965a-08d817434da0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 07:01:50.4586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DNnEs+nsFiLx3LKqID1FX7N1vyqj3Mtg1mRNaae8l+P4t38PokgyhKlVqcCKW9e0YEBdESW2CtP5ComC/AJIIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6824
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=20
> >diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c index
> >2465a84e8fee..74a1ff5000ba 100644
> >--- a/drivers/usb/cdns3/ep0.c
> >+++ b/drivers/usb/cdns3/ep0.c
> >@@ -327,7 +327,8 @@ static int cdns3_ep0_feature_handle_device(struct
> cdns3_device *priv_dev,
> > 		if (!set || (tmode & 0xff) !=3D 0)
> > 			return -EINVAL;
> >
> >-		switch (tmode >> 8) {
> >+		tmode >>=3D 8;
> >+		switch (tmode) {
>=20
> For me it's looks the same, but it's ok.
>=20

Pawel, please check the coming code, it uses tmode to set the register whic=
h
is incorrect before shift. (line 336)

328                 tmode >>=3D 8;
329                 switch (tmode) {
330                 case TEST_J:
331                 case TEST_K:
332                 case TEST_SE0_NAK:
333                 case TEST_PACKET:
334                         cdns3_set_register_bit(&priv_dev->regs->usb_cmd=
,
335                                                USB_CMD_STMODE |
336                                                USB_STS_TMODE_SEL(tmode =
- 1));
337                         break;

Peter

