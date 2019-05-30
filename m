Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0502FAFB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 13:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfE3Lga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 07:36:30 -0400
Received: from mail-eopbgr00060.outbound.protection.outlook.com ([40.107.0.60]:53127
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbfE3Lga (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 07:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZJGGSH0+d6IrAW7guS93/lvz2bAdA1RpLKWlAimzZ8=;
 b=mfi66sUrbopM1nqJlk1fIO1Ei93xET+plNKalM7qsU75iqyBCNAcF7l/UiYc8JxKBBgdbHvfempiL38C7a+LI8piDhvWEAi3TRf4mvFTmzs5F4ZzgOz8gWPDkRke7mzJhs/dwdErnIq2Gm9+kxJrutgx7Z0dfDqG1x8Kl/VhH/c=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3534.eurprd04.prod.outlook.com (52.134.4.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 30 May 2019 11:36:26 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 11:36:25 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: caam - fix DKP detection logic
Thread-Topic: [v2 PATCH] crypto: caam - fix DKP detection logic
Thread-Index: AQHVFtvp6L+GVTG2yEe9n6uchO0tWg==
Date:   Thu, 30 May 2019 11:36:25 +0000
Message-ID: <VI1PR0402MB348596A1F9AF7B547DC6AB2C98180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190503120548.5576-1-horia.geanta@nxp.com>
 <20190506063944.enwkbljhy42rcaqq@gondor.apana.org.au>
 <VI1PR0402MB3485B440F9D3F033F021307298300@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3100dcc8-73eb-4d30-435a-08d6e4f30ca3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3534;
x-ms-traffictypediagnostic: VI1PR0402MB3534:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB3534214C3A4767DDD01D302798180@VI1PR0402MB3534.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(366004)(396003)(346002)(199004)(189003)(186003)(99286004)(8676002)(966005)(256004)(316002)(8936002)(53546011)(44832011)(81166006)(81156014)(74316002)(476003)(53936002)(66446008)(66556008)(7736002)(6246003)(102836004)(76176011)(305945005)(6506007)(26005)(7696005)(110136005)(446003)(33656002)(486006)(6436002)(54906003)(229853002)(9686003)(91956017)(68736007)(64756008)(66066001)(14454004)(71190400001)(4326008)(5660300002)(6306002)(71200400001)(73956011)(55016002)(76116006)(478600001)(86362001)(25786009)(3846002)(66946007)(66476007)(2906002)(6116002)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3534;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qGJIeW1qc7JqJNlOOBpHepKhrJiCsPbMJQhP4Y1fXkrMM960pLOzltAu6Ib+fGVQEvtmAxsxqUJZTnO9F7K2sSm+7spT0GNiFVHyfu3E/lpyGTjwZdfIrTcLino+3oKOp4MzR2fgk3Wylpawwcyvk5GVQJde8ijw5LCcKIqHPnsbfIpRnlyFWCjE6D1/fMGeHOMmVfY5j+K+KQvRq6O/IlDAA1LO/vd8ND1KJblTiUFL9gIA8Dw76ZSA9V89AY4v094RJfDHEEDrIJVz93MewKQCjXWaYDZBhCquB5BcJPk0blA1yHXzwNo9fBW6Ga8JBbt89kuj0OL9oq30N5Mb+cTZQbSMf/iqO3+Dqk6cVWHdQOuisNH1yzP7ltepmq8XO2Tylci9k27vkdub536JPxfJvQSXFFr0835qEtWlYr8=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3100dcc8-73eb-4d30-435a-08d6e4f30ca3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 11:36:25.8626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3534
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/6/2019 11:06 AM, Horia Geanta wrote:=0A=
> On 5/6/2019 9:40 AM, Herbert Xu wrote:=0A=
>> On Fri, May 03, 2019 at 03:05:48PM +0300, Horia Geant=E3 wrote:=0A=
>>> The detection whether DKP (Derived Key Protocol) is used relies on=0A=
>>> the setkey callback.=0A=
>>> Since "aead_setkey" was replaced in some cases with "des3_aead_setkey"=
=0A=
>>> (for 3DES weak key checking), the logic has to be updated - otherwise=
=0A=
>>> the DMA mapping direction is incorrect (leading to faults in case caam=
=0A=
>>> is behind an IOMMU).=0A=
>>>=0A=
>>> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=
=0A=
>>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>>> ---=0A=
>>>=0A=
>>> This issue was noticed when testing with previously submitted IOMMU sup=
port:=0A=
>>> https://patchwork.kernel.org/project/linux-crypto/list/?series=3D110277=
&state=3D*=0A=
>>=0A=
>> Thanks for catching this Horia!=0A=
>>=0A=
>> My preference would be to encode this logic separately rather than=0A=
>> relying on the setkey test.  How about this patch?=0A=
>>=0A=
> This is probably more reliable.=0A=
> =0A=
>> ---8<---=0A=
>> The detection for DKP (Derived Key Protocol) relied on the value=0A=
>> of the setkey function.  This was broken by the recent change which=0A=
>> added des3_aead_setkey.=0A=
>>=0A=
>> This patch fixes this by introducing a new flag for DKP and setting=0A=
>> that where needed.=0A=
>>=0A=
>> Reported-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
Unfortunately the commit message dropped the tag provided in v1:=0A=
Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=0A=
=0A=
This fix was merged in v5.2-rc1 (commit 24586b5feaf17ecf85ae6259fe3ea7815de=
e432d=0A=
upstream) but should also be queued up for 5.1.y.=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
