Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E91F32F31
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 14:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfFCMHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 08:07:32 -0400
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:29348
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbfFCMHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 08:07:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qagzcxISTwrZW6qAv2VJG86x+G+EYNVbGEFGV8lt4bI=;
 b=gwfrZ3Jbq+XwQObS825x6YsK+5rAKrNWG4xZVvqB59IywUP4wODMacu8q3rnzGn5B4rAD19gpHZ+9PwCP06vWDuINt0M0KZ6n2YVh1cMfJH5DSe7z/51rGjZCvnOuLSHLKpPC10GIQk6HjlgDUZ26va+nn4snKOPTyzXTW2eoRI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1SPR00MB110.eurprd04.prod.outlook.com (10.173.72.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.20; Mon, 3 Jun 2019 12:07:28 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 12:07:28 +0000
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
Date:   Mon, 3 Jun 2019 12:07:28 +0000
Message-ID: <VI1PR0402MB3485776F44CA3D034F66821798140@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190503120548.5576-1-horia.geanta@nxp.com>
 <20190506063944.enwkbljhy42rcaqq@gondor.apana.org.au>
 <VI1PR0402MB3485B440F9D3F033F021307298300@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR0402MB348596A1F9AF7B547DC6AB2C98180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190603075215.GA7814@kroah.com>
 <VI1PR0402MB3485DFE0BB41351836D4BF3598140@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190603084257.GA13673@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18cf3e19-a1e8-4c05-c356-08d6e81c0c63
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1SPR00MB110;
x-ms-traffictypediagnostic: VI1SPR00MB110:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1SPR00MB1108BD62E41238742719D5498140@VI1SPR00MB110.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(396003)(366004)(136003)(189003)(199004)(102836004)(6916009)(73956011)(99286004)(76116006)(66946007)(26005)(14444005)(256004)(316002)(6506007)(7696005)(66476007)(186003)(54906003)(53546011)(74316002)(446003)(44832011)(476003)(71200400001)(71190400001)(486006)(5660300002)(66556008)(76176011)(64756008)(68736007)(52536014)(66446008)(14454004)(8936002)(86362001)(25786009)(966005)(45080400002)(8676002)(478600001)(6436002)(229853002)(4326008)(9686003)(6246003)(53936002)(305945005)(7736002)(55016002)(6306002)(81156014)(81166006)(2906002)(66066001)(33656002)(3846002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR00MB110;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2xIEduWZ6R+N6su4LGgWSqdCNmxZ8GWyVlwHYsQidQjzoCfVQt4YXNt8RA8YEAFkxIvt2ujeAgmoGG6Fw+goYIk8YuDoW11l16686i44djthNyFt+LB69HWQAMT6voHwHk0PsI7UF93XiPq8UkIXjsCBKdNVw3aKm6UpdXRa7Cx32rLBxatd5oOpJ+4TO6s1rtqJz1P5WxVAKWXfJy0QyNyh0we116FiP5WQNFNrRUSLT3EKyLyVMmdo+dRTH/v9kd5C5eRiuHTxKv4bX1+B58/CS4koZ8hreI9YSoZ4WbCft78vi1+pJnJwB/mcsGadjuVJp5ucYHy9JfbXvR2DF6WLZQTyDoraicVqphf1PKWIWLU41Chh/ye8OUNs6Yd0V7B/mKiJ1XzH52ST7vhVCbGecLazRk7Q5KOOKSOJ5pE=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18cf3e19-a1e8-4c05-c356-08d6e81c0c63
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 12:07:28.2417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR00MB110
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/2019 11:43 AM, Greg Kroah-Hartman wrote:=0A=
> On Mon, Jun 03, 2019 at 08:10:15AM +0000, Horia Geanta wrote:=0A=
>> On 6/3/2019 10:52 AM, Greg Kroah-Hartman wrote:=0A=
>>> On Thu, May 30, 2019 at 11:36:25AM +0000, Horia Geanta wrote:=0A=
>>>> On 5/6/2019 11:06 AM, Horia Geanta wrote:=0A=
>>>>> On 5/6/2019 9:40 AM, Herbert Xu wrote:=0A=
>>>>>> On Fri, May 03, 2019 at 03:05:48PM +0300, Horia Geant=E3 wrote:=0A=
>>>>>>> The detection whether DKP (Derived Key Protocol) is used relies on=
=0A=
>>>>>>> the setkey callback.=0A=
>>>>>>> Since "aead_setkey" was replaced in some cases with "des3_aead_setk=
ey"=0A=
>>>>>>> (for 3DES weak key checking), the logic has to be updated - otherwi=
se=0A=
>>>>>>> the DMA mapping direction is incorrect (leading to faults in case c=
aam=0A=
>>>>>>> is behind an IOMMU).=0A=
>>>>>>>=0A=
>>>>>>> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode=
")=0A=
>>>>>>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>>>>>>> ---=0A=
>>>>>>>=0A=
>>>>>>> This issue was noticed when testing with previously submitted IOMMU=
 support:=0A=
>>>>>>> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Fpatchwork.kernel.org%2Fproject%2Flinux-crypto%2Flist%2F%3Fseries%3D110277%=
26state%3D*&amp;data=3D02%7C01%7Choria.geanta%40nxp.com%7C0531d21296e1471cd=
12708d6e7ff7ed1%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C63695148186750=
9241&amp;sdata=3DvpeK41WQcINZTn4REHwk1Zgh5kIwPJNqiB75sT3ABV0%3D&amp;reserve=
d=3D0=0A=
>>>>>>=0A=
>>>>>> Thanks for catching this Horia!=0A=
>>>>>>=0A=
>>>>>> My preference would be to encode this logic separately rather than=
=0A=
>>>>>> relying on the setkey test.  How about this patch?=0A=
>>>>>>=0A=
>>>>> This is probably more reliable.=0A=
>>>>>=0A=
>>>>>> ---8<---=0A=
>>>>>> The detection for DKP (Derived Key Protocol) relied on the value=0A=
>>>>>> of the setkey function.  This was broken by the recent change which=
=0A=
>>>>>> added des3_aead_setkey.=0A=
>>>>>>=0A=
>>>>>> This patch fixes this by introducing a new flag for DKP and setting=
=0A=
>>>>>> that where needed.=0A=
>>>>>>=0A=
>>>>>> Reported-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>>>>>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>=0A=
>>>>> Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>>>>>=0A=
>>>> Unfortunately the commit message dropped the tag provided in v1:=0A=
>>>> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=
=0A=
>>>>=0A=
>>>> This fix was merged in v5.2-rc1 (commit 24586b5feaf17ecf85ae6259fe3ea7=
815dee432d=0A=
>>>> upstream) but should also be queued up for 5.1.y.=0A=
>>>=0A=
>>> I do not understand, sorry.  What exact patches need to be applied to=
=0A=
>>> 5.1.y?=0A=
>>>=0A=
>> Commit 24586b5feaf1 ("crypto: caam - fix DKP detection logic").=0A=
> =0A=
> But that commit says:=0A=
> 	Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=0A=
> which is only contained in 5.2-rc1, so why would I want to apply the=0A=
> first one to 5.1.y?=0A=
> =0A=
Sorry, my bad.=0A=
=0A=
I've looked at the failing kernel version: 5.1.0-09365-g8ea5b2abd07e=0A=
and seeing that commit 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in F=
IPS=0A=
mode") is in the tree, concluded it was delivered in 5.1 and would need the=
 fix.=0A=
=0A=
Please disregard the request.=0A=
=0A=
Thanks,=0A=
Horia=0A=
