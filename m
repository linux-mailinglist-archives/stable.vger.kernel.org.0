Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0424532A7C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 10:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfFCIKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 04:10:20 -0400
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:54048
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbfFCIKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 04:10:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thiX5AixHvQdoHiKdTe/DrVmr+bPYqYWO9Sb1/osHyc=;
 b=qNTgRv6KuN40FzMZlNPHvb2Ymv8MLJet7C68OJv4TnTRffQ4EuqfFBX58nWxNr0V7o7QhqhLuxIJwglkymhoWyxW5d5bKEEDQOcb5urndxKiqQUp7oO+T5ghupvI5tb4fdcesT0UoLWkDIfcfUqprdan6JeP3/jqjODxOiJElDo=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2941.eurprd04.prod.outlook.com (10.175.24.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Mon, 3 Jun 2019 08:10:15 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 08:10:15 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: caam - fix DKP detection logic
Thread-Topic: [v2 PATCH] crypto: caam - fix DKP detection logic
Thread-Index: AQHVGeFGHEC21fvWy0uWA6SVPYo83g==
Date:   Mon, 3 Jun 2019 08:10:15 +0000
Message-ID: <VI1PR0402MB3485DFE0BB41351836D4BF3598140@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190503120548.5576-1-horia.geanta@nxp.com>
 <20190506063944.enwkbljhy42rcaqq@gondor.apana.org.au>
 <VI1PR0402MB3485B440F9D3F033F021307298300@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR0402MB348596A1F9AF7B547DC6AB2C98180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190603075215.GA7814@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95286d7c-acb1-443c-6e88-08d6e7fae8f2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2941;
x-ms-traffictypediagnostic: VI1PR0402MB2941:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB29418F8936836B4FEC3FE30E98140@VI1PR0402MB2941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(39860400002)(396003)(346002)(199004)(189003)(486006)(476003)(102836004)(53936002)(4326008)(6246003)(53546011)(6506007)(478600001)(64756008)(446003)(66446008)(229853002)(66556008)(66476007)(66946007)(256004)(76116006)(44832011)(54906003)(2906002)(25786009)(7696005)(6916009)(76176011)(68736007)(73956011)(86362001)(3846002)(6116002)(316002)(52536014)(6306002)(6436002)(99286004)(55016002)(26005)(8936002)(8676002)(5660300002)(81156014)(81166006)(33656002)(9686003)(74316002)(186003)(14454004)(966005)(305945005)(7736002)(66066001)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2941;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AYbpxPbVv1MYMDJth5uHGXKMBX58w7JaCasO8SrXB5YZdL3ywuqjDJPcUIUIy6HjOvJdg3wzjrxgxU+ECbcR5pWQ9qJQhG/vJ4b0qmZ2ePVuqi2Gk0wrmE2lmUH835oi2c34qcjrMSedI9oN7NtP81I2nzqzIjYfIPf/iraeL7lKIvfZrW1YoGO9lOuDyNfmFIqINvqOiOfhgSLk208jPLQ40x1uD7yimgqzaldTnP+mSCrJ7JpRWO+f2eAQdyBosnnlnK48lDaDLH/ckGECw6DjfP7oa90MYovgX2W9PrjeETWs/iPe1DYxbow29i0GpzQf2ezfBuXH6mCnMGH6Opu2/WoBAH9Y8lwDC5mkjsaCdY8UzgfpUs9WHL55BKD2xA/PNpoXeu3qYMcAKQoC/3LgL40XApqDzghKjgkK0RU=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95286d7c-acb1-443c-6e88-08d6e7fae8f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 08:10:15.4466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2941
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/2019 10:52 AM, Greg Kroah-Hartman wrote:=0A=
> On Thu, May 30, 2019 at 11:36:25AM +0000, Horia Geanta wrote:=0A=
>> On 5/6/2019 11:06 AM, Horia Geanta wrote:=0A=
>>> On 5/6/2019 9:40 AM, Herbert Xu wrote:=0A=
>>>> On Fri, May 03, 2019 at 03:05:48PM +0300, Horia Geant=E3 wrote:=0A=
>>>>> The detection whether DKP (Derived Key Protocol) is used relies on=0A=
>>>>> the setkey callback.=0A=
>>>>> Since "aead_setkey" was replaced in some cases with "des3_aead_setkey=
"=0A=
>>>>> (for 3DES weak key checking), the logic has to be updated - otherwise=
=0A=
>>>>> the DMA mapping direction is incorrect (leading to faults in case caa=
m=0A=
>>>>> is behind an IOMMU).=0A=
>>>>>=0A=
>>>>> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=
=0A=
>>>>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>>>>> ---=0A=
>>>>>=0A=
>>>>> This issue was noticed when testing with previously submitted IOMMU s=
upport:=0A=
>>>>> https://patchwork.kernel.org/project/linux-crypto/list/?series=3D1102=
77&state=3D*=0A=
>>>>=0A=
>>>> Thanks for catching this Horia!=0A=
>>>>=0A=
>>>> My preference would be to encode this logic separately rather than=0A=
>>>> relying on the setkey test.  How about this patch?=0A=
>>>>=0A=
>>> This is probably more reliable.=0A=
>>>=0A=
>>>> ---8<---=0A=
>>>> The detection for DKP (Derived Key Protocol) relied on the value=0A=
>>>> of the setkey function.  This was broken by the recent change which=0A=
>>>> added des3_aead_setkey.=0A=
>>>>=0A=
>>>> This patch fixes this by introducing a new flag for DKP and setting=0A=
>>>> that where needed.=0A=
>>>>=0A=
>>>> Reported-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>>>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>=0A=
>>> Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>>>=0A=
>> Unfortunately the commit message dropped the tag provided in v1:=0A=
>> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=0A=
>>=0A=
>> This fix was merged in v5.2-rc1 (commit 24586b5feaf17ecf85ae6259fe3ea781=
5dee432d=0A=
>> upstream) but should also be queued up for 5.1.y.=0A=
> =0A=
> I do not understand, sorry.  What exact patches need to be applied to=0A=
> 5.1.y?=0A=
> =0A=
Commit 24586b5feaf1 ("crypto: caam - fix DKP detection logic").=0A=
=0A=
Thanks,=0A=
Horia=0A=
