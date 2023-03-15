Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A5E6BB5F5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjCOO1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbjCOO1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:27:35 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2119.outbound.protection.outlook.com [40.107.114.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D6F3A877;
        Wed, 15 Mar 2023 07:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8sOSr3DUvn3i0qnI0+b83tHMXuP3kdhqOeCjmjT9b9jCEKp8mLRWTaNjgb5oj307teFh155X9LIXtP5Jpnoo2dTmsHjy796vU4RVrlkwf9xIyiwNlGiJN/LaYm5SRyzUawcOy7tYOxzGaXOHd3eiVj3gaps3O4IU+bVsbd5L/zdy4mEo59eucXukHVG2YKzGFMvTOl7pxb0c89LeZ9DovJtZ6//XOF52lHK9GT4lYx8zQRrqjVQxpMwiRgk6k5xSI0ET2Ky+9HRIsNcXphtr1mshAvvrNa7eJtdRck4IVQo4JTUic+G4Yyfa2z05hs8txy68tC6vnK4UPgXJlppWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8QY/IVp1BHSOf3SmL/VGLLTX1TIji9Rt+4mNNWkrTY=;
 b=CpQ7Xar5LSwMEe7t9wK+xGi8KNx9oTYXvX1/4WpD4D4vhdiheeSBkto3/2vqYvCwUwwTE3X0wm/hf9/C9fgmeyjXSklco9Wopcd0Hi9hnoQOAtNLVo4mCMFK07cTGbeMA7yv1OuPWp0LhRUypuYjsklH7JujE1EZ0Fxunm32j7hTtbhfT0B5ooaSqqBvszfY/I0BytmUlKCxweDtJfWCLqpp9mZwMuS8ZU0Dig7azWcgk9ej9o7eqpVnN15DOt3eDsik7TyklG8CMdeJ2iSx7aoiTxY89IGxWHg3hbhmgmOcqZgafm0IzwVx/8AjYXtxx0sg6N2+BZoDCLNMpH3wVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8QY/IVp1BHSOf3SmL/VGLLTX1TIji9Rt+4mNNWkrTY=;
 b=A96F0b86pyuaPj0RSwB1e8t3KVaMHHxF2+qDm0rLQfc7ya7JhQMVxwasxsxPFHsFVi09kyXbFzdAI38JkIrAdys5R/HWY0V3BBR19p0wrrbsB38sAUB66z4HMdWxCiY3Q86E9KF/NXs6DuPwHNYHYWsB279GXSasbFFfVEM4rj0=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB8394.jpnprd01.prod.outlook.com (2603:1096:400:161::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 14:27:28 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 14:27:28 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: RE: [PATCH 5.4 00/68] 5.4.237-rc1 review
Thread-Topic: [PATCH 5.4 00/68] 5.4.237-rc1 review
Thread-Index: AQHZVzgqm2vHjZhS50CM2HQSuq89Ea775Jzg
Date:   Wed, 15 Mar 2023 14:27:28 +0000
Message-ID: <TYCPR01MB10588F845D48C023460EDB70BB7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230315115726.103942885@linuxfoundation.org>
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB8394:EE_
x-ms-office365-filtering-correlation-id: 9423ec2d-1f89-43fa-be04-08db256167af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O9/Ew+5vKPjeevhQSB9uyQVbqj0HWaZibMQxOHCfgaGLv1ojn/YeKLViM2/RrC0eo5L5TIpIq/mngWenwCPZiS8RKYM6ZR6nzeySJ0/tBEyo9g1HlKmEL8UjhK9Ml7YFiucv60junBn1+o5jcFpf9SOxE5uyieButAs1nYv6LCJMcgS17dVCKzCWfooqrapAsLv/CrJ0gZvfWo8T/kK3zZM0QmJffNLFibarKAaff5/ri/Yrv/JC4KwMBp4GwasAZadexfXpjuv62VKYpdRnIO5fWFFu9pAIi/A3RzWQNHJUaqywwclNlCj1F1mfTytaKXFDyqr8NBG4Au7CvF5/YK2Z6jwUpmVLqGeLceON3PSsd4Ho3cPG2naLOokhTZvgdPZfb5fFsOGtfa+wRJpZdIqZffDhfMMXzgVw3mWfxc1K16g38W9Z+Gb/oAJSdpsqH00HAGjYx5TvFWnIStUqH+ZuzQrIJp59YtqjzbE74+iRytsv5N4isrItCAJ2Qo9oonlCGEy8fqrgrsxAXk58IqCSC9ur8DtecdKPuu4vwNyHZrois8M1BHsihpum6TljDz0vo5WDe05hgkarPmlLDeeaAEkKnLNS5Q/W/VM6UEYB73d+4yC0ReboSBhv0936TiHFjeE2LhDwy4xKr0cqPCzkXth1MuvqlMd6y0O0qY3mmSEwuccpzbj2O065OSe//KFHoMygXQPhG5SwpoxJStDXzir0GIyKkjswr9uPf8U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199018)(33656002)(86362001)(9686003)(186003)(966005)(26005)(6506007)(7696005)(71200400001)(38070700005)(478600001)(55016003)(110136005)(54906003)(316002)(41300700001)(66556008)(66446008)(64756008)(66476007)(122000001)(66946007)(2906002)(76116006)(8676002)(4326008)(8936002)(5660300002)(7416002)(52536014)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?z76F6qU4UiTIxcXkmMn0Kn0BcKfXF97tvhuqECaXODhymErCX6vib3eN?=
 =?Windows-1252?Q?dYVqvJjBBBECmtNBULflCqw5Vh2sdHkap7GaWnL26c57eYcHstZYnn83?=
 =?Windows-1252?Q?fzmcu/zfzhWXR1Y8q/djptthn2N1D/BUIFVGjpGdhOo3DNgqM/eGtXsV?=
 =?Windows-1252?Q?VTOpe6u3VaRbIjMHEYN3jpGg5Q3bZZ6ukLRnpouxEFxT0w3eYyEW6P2m?=
 =?Windows-1252?Q?oniWTwtzOIE0uF7at4wisP4OB+Cgm2YCg26RskHVTwFzUhmyWoPu1kbL?=
 =?Windows-1252?Q?Ma3xIL9bjnYyRtUEtn0cLuF2itdlm6qCZg+RWOB/Zs4FpX8Td9B6lITz?=
 =?Windows-1252?Q?RV+h2NDwdDpdM23fw4dRu6DKgwax8UK0IpP+T0OZ7LczIjxknb9p2gpY?=
 =?Windows-1252?Q?S+wd9AisJ8mZNlodK/lipobVzPtw+0NiJajZDWQRd2JES+clI8uukhS0?=
 =?Windows-1252?Q?GzyuskV3gTlShv/YGa/JRp/wzGUkzcpMhhBrYdBbP7edfk8iq/yoQu9y?=
 =?Windows-1252?Q?viD9vpMyaXuopktL5ZZwkIDFFbySMCwPPZES5e349CFaCfqVwap2HYBH?=
 =?Windows-1252?Q?5uItU+uFWzlsV04Y8Vf+baJshAsvE0w4hQ3kgL6Dt7dLTsiWnKOmFeKZ?=
 =?Windows-1252?Q?l+alCiT73o44IwVdnRS3CpQwiOGPl1rGZn9DpzhOcoh3MHFPzXyLueFk?=
 =?Windows-1252?Q?GOpqwO1IpW3ZhwV5YMnz7UHrZDX0ksjRuUJ7fWOrpeIgOT6Bw98aQNBl?=
 =?Windows-1252?Q?U0X3F4gj25FKLZSimvbNxqYstEcZWTCI8VXe6vTk0rXzUeWIF5nsC/Dh?=
 =?Windows-1252?Q?5chBn6joZdwG9hVRqcSEqeG6SBW2/OdrG1om+bTHE1GP9asSzD5wTzGt?=
 =?Windows-1252?Q?UHTfEnYaLSX8F+z5avqq4un/EnDqyiF9hvcIktUBevxmrZNcsfKBQPM8?=
 =?Windows-1252?Q?qjVLtfkt1TnT1KNKQVyPpX2S2pIJVmO/Zq7BV4J9EvNks4/L2nIMQTo8?=
 =?Windows-1252?Q?lvFPtymVim7NXXDE6AosrCHpmjmQ7/7eGd9pQEMhlVZC0qKAla2oPdPF?=
 =?Windows-1252?Q?cpjEmTDRYwwAYt97KF69/GasvSDx1NXJQdh9p15H80ZCORy1wSZ4pufI?=
 =?Windows-1252?Q?ODntBJdvkpYrnxiiLrCh3nrLZXaa7W43zHs2z1gaovOgeMcvwdQ+DfrF?=
 =?Windows-1252?Q?QWmfkDbfNvuLcRUITECpk0sPULXU3JT09FllKKLS3uW3ySfv6OjY7NJ6?=
 =?Windows-1252?Q?H8Puta55h+c+sEJf9qojwsH8jva7/6xFH/QLkH8QELiZii5035wz+Wy+?=
 =?Windows-1252?Q?s+fOTiuSrNh7leH+FThzwltMdTqnOeTPBmPeXnXwGAo2R0pdB4DQMxAA?=
 =?Windows-1252?Q?XvnymZQyMu4gjJ+t47nYCXrInRdnOt5eO388Weud2g4schjjTEisfDX7?=
 =?Windows-1252?Q?WovxU4WH3Uc3A25lbW7Q1I3fuBYxgk4tY1cSzWCDEtgzMBDp/STXLuFk?=
 =?Windows-1252?Q?9kapG3/AewUYxUhXO5g9qpjZtFb8AU6v0kJ2jb0B8WhGWXLe1gsRTIvd?=
 =?Windows-1252?Q?G6S0k3uLuuzPYZpKJwSvQoFdvxZ+/8qhhWUsbc7+wftV+UAORRxxecEe?=
 =?Windows-1252?Q?M7TzxzMlyfSpex8c1JXK6S8Z3TiZkaYYXM2nCabq38sYU9dQJZShQqkg?=
 =?Windows-1252?Q?FR+MZ97MiwHzse301+0XhZW1alZjvavqvpE2oxzaBrvaU3N8x48cmA?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9423ec2d-1f89-43fa-be04-08db256167af
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 14:27:28.4058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g7JbHfkCyFBNchYvJd/+CAvGoVy3xvlkjenpxihmoyhmgnxrUvL68kZ3RFut/AMm0Uv/ag7uk2lh0gSVQPoqdySIfk3eXw4U0bgmITK5DTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 15 March 2023 12:12
>=20
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>
CI Pipeline:  https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci=
/-/pipelines/807195748

We (CIP) are seeing some build issues with Linux 5.4.237-rc1 (543ff97e810c)=
.

1)
For arm multi_v7_defconfig builds we're seeing a some errors when building =
the exynos5422 device trees:
arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (pha=
ndle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference t=
o non-existent node or label "gpu"
arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (pha=
ndle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference t=
o non-existent node or label "gpu"
ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroid=
xu3-lite.dtb] Error 2
make[1]: *** Waiting for unfinished jobs....
arch/arm/boot/dts/exynos5422-odroidhc1.dts:238.10-241.7: ERROR (phandle_ref=
erences): /thermal-zones/gpu-thermal/cooling-maps/map0: Reference to non-ex=
istent node or label "gpu"
arch/arm/boot/dts/exynos5422-odroidhc1.dts:242.10-245.7: ERROR (phandle_ref=
erences): /thermal-zones/gpu-thermal/cooling-maps/map1: Reference to non-ex=
istent node or label "gpu"
ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroid=
hc1.dtb] Error 2
arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (pha=
ndle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference t=
o non-existent node or label "gpu"
arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (pha=
ndle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference t=
o non-existent node or label "gpu"
ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroid=
xu3.dtb] Error 2
arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (pha=
ndle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference t=
o non-existent node or label "gpu"
arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (pha=
ndle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference t=
o non-existent node or label "gpu"
ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroid=
xu4.dtb] Error 2

Log: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/3=
939400038#L8368

Presumably caused by "ARM: dts: exynos: Add GPU thermal zone cooling maps f=
or Odroid XU3/XU4/HC1", but I haven't had a chance to revert and re-test.

Kind regards, Chris

