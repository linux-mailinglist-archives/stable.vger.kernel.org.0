Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA58B6C4719
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 10:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjCVJ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 05:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjCVJ56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 05:57:58 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2105.outbound.protection.outlook.com [40.107.114.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C44319AE;
        Wed, 22 Mar 2023 02:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7hu2NkL84B50MfGpMI29QzV0zZGuL6SHtimmjgUy54vjyEZBFvBE+x5wJMdZc5kJmwTn3qL+Oa7Yx6Oe9PQp4dNg91Z+PCHMPMThhvxopZba8HwrUeHwQs2Bji9FOlu+tLM5c75SIv9jCDg2OowL1u9ajn9VPCk3mje1bd4/EVP/8KO+nuvixFWNMJ8CEalaAhNzKjO92CoDQeXUZGUvhv/Cy1X1jqRWaZcrCndvGr6l6pWuJOTyXMvA6TteW4Rkk0hBjQe5OONULPdzrppgPxAt1PONHw0zQQwh/u3tAESuk5kEqwrshMGD5y7jpJkLQBa1XiPAtNOWicqVftR8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+4GpW5DYsaQcQ+3dYG+4hXW0WJgJxPgkvHG48XFQDI=;
 b=UJ+ffxzbm61cWN1OQeYsNNOl5/Aql6szSaPrZszj/PLHG2Kb2T6tc0F7ndcTqUlEkaXkHsi03jBohN/OkuKcePzdkFJEhQqb8NOmmnBmnO39V70Wpn9in8DaYJWUG3MtQ9OuJNY4TWZiVb4m4aF8zlrSzi3hbKQucE3FmJ8nJWc0tYPKtZg0PBTcvzbX3G2w5HYIi8UDg0jd1pq1qZa5zHd/P0hvX2o50+uZSPWdRhkk5zKiy+JaaLLmLDOs5GGYFIBP3R2mJoxuMi3//Qu2z3lpPG/V96YeL0G2Zho3N7h4spH7ravpVeIlwr1PXt5wndo2wf/ZTjkzddZ8UZMGqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+4GpW5DYsaQcQ+3dYG+4hXW0WJgJxPgkvHG48XFQDI=;
 b=VX5nuOXMoIbbcxzd4pqbqwXjM4+2PmO7SKIO9C2z3CYOZlOyUupofAZ3A5kYM0Y2zyl113rqZ0SlaP0fbmizrBmBnxhYtIOhfO899GXE9wjOwtjgCF+wZS4631mHXI0kgdfnw2mFTxc2jPqGbKkkdgQ4f4Lr1CmZAYAFQcQta+8=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB9574.jpnprd01.prod.outlook.com (2603:1096:400:1a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 09:57:53 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 09:57:53 +0000
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
Subject: RE: [PATCH 5.4 00/57] 5.4.238-rc2 review
Thread-Topic: [PATCH 5.4 00/57] 5.4.238-rc2 review
Thread-Index: AQHZW9CsBB1P83+dx0K7MvCs2yBKrq8GkYbQ
Date:   Wed, 22 Mar 2023 09:57:53 +0000
Message-ID: <TYCPR01MB10588043DBF3183B098CC4461B7869@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230321080647.018123628@linuxfoundation.org>
In-Reply-To: <20230321080647.018123628@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB9574:EE_
x-ms-office365-filtering-correlation-id: 28716cb9-cb69-4900-a177-08db2abbe790
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: adMqxLtqhyKimvsUxtsk1blV4kDLD72QPv+sPayuvWqHsvG4JcEoF9BF3PlzVedxMeSsB55dNy67OLADW/vI8f4FDRE+Hkw/eVfpFgMfo7haKRiXBX9MdHg7VEPxe9hQCaRK8EO+GshpSjGJpfJf5SiGEHcutBFmZO+/h5jV5Np6ykYQR2NCUYn9kmolgatcnOgZkXDGxBYxdoftrGfbRC0Az27iBug1Wz6oXft5NRFhEtTZVpN8cYVZIR5859g2wVW1mu5mOiLs7bYaMPfma8D3dP65NrH8MFiW6FdE4icHNt54nB0kOBKOhzmpa5SD8WGma+dn8OcbaO34MNGctoHRIsG535dvTbVbw6J9Ss5A9B8n/5VyRS/Ais453TcX1wAr4G1neZEZEQnPQaKkE6nkWC25iraVKLJmstGdO/cMgC4TRTfupihdJxG0/MUHbi4f34DbqaPAhKB1ctPw1tD6uxE8ybVVcaS846MVRd3ZTgq7F+8P8GlovUBmaWcctzYKsTDD0QlMb7aCO5+Vqu5ymwbF7Yq+GW6DnevqyTU9LzYiTOpGpo4b93hqkOxSUGoBCOrrqoTasOvsmLmgIexvMVcY5MJFrfyYD7sEX8Wunqzi9or5KIahKu2L6NV40Isfyy7SmLebo3Rs9fot0DtdgRxshvuhaNSyKU8yTfcUUjPSu9dmbrjINiXcSrLZH7HPqqVxrLn/1RU3QGku6iaedh3sVcFGW2jUS6mrZTQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199018)(7696005)(86362001)(55016003)(33656002)(71200400001)(54906003)(66476007)(66556008)(4326008)(66946007)(186003)(110136005)(64756008)(966005)(26005)(6506007)(76116006)(52536014)(316002)(9686003)(2906002)(38100700002)(478600001)(66446008)(122000001)(38070700005)(41300700001)(8676002)(5660300002)(8936002)(4744005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?TsigEiHI13sF+7QiC+PhYSmM74J21jQVSgw/tzt12NWKuyCU59gFMJ2t?=
 =?Windows-1252?Q?bPq1WUXRc9uMdMJ4+V46ILk/DpUM6QgbdPq4ALC99o3Hslx1ja925nw2?=
 =?Windows-1252?Q?purjmK4zzcZL3Oh9sySo6oJgQD7BU1/IGkxK9QiJbAL3isCB1sLqqpkT?=
 =?Windows-1252?Q?RUjgFNvplw0v3Je36fobYGqoXGUr9hFpj9WlJ+MSdptILaiRfqZOu2KP?=
 =?Windows-1252?Q?4MD+mg0VSze4BeY2sqXQhtfLhftgiQ4qSMTCg8FWD0L/i9OYl4rMqQDf?=
 =?Windows-1252?Q?+iOmsw4HlL5uHXSitj1prmpfzl160bUXx/vF+xS2IJie4EucYlA8W5pj?=
 =?Windows-1252?Q?FuJC7FgXxre79vb+vOZSOUtN6dSud2C87zJ9LMYtmVXYq+aSPofG2fze?=
 =?Windows-1252?Q?wJPrS0OWQ8EqKM0FXTczNv4X/bazTLa982eCfK4QDNALklq1Atz1n1Mq?=
 =?Windows-1252?Q?Tsa+J220K4t93eZaTv2O4ET3689UaTGMTSqLhXsVgy8ZXDT36J3Xgc2m?=
 =?Windows-1252?Q?Megl5yWuWdCiBIqpAOuhOOMA7IA3hVd6SnrnXaABEqQALu9tVOYBWXYq?=
 =?Windows-1252?Q?ensll1h284COwBJTwIeUyD6tXd+fz2CYAwMby0ngzuYEntAtmys911cU?=
 =?Windows-1252?Q?s/DMSyqJyXAk58g8lVKwF+/u3qPPLloSp1N82hSFcn6murJ86JsG1NCu?=
 =?Windows-1252?Q?CSt8Pg5gNnLIOkIST7fCqUnWFOeDCK8aLs+RoxQSMxSPa8VLUinPEbxQ?=
 =?Windows-1252?Q?zD2LUzC0t0gLeMDlmugSk/QvilOwpaKUBcMntVEyGMF64WbXp2JlBUB4?=
 =?Windows-1252?Q?UVv20yZ0wXy5RxzSdBDL6j/KAUKn4QGwd0Mk/PtPCj6j4OtUBj1pHKGA?=
 =?Windows-1252?Q?/rB0A03gJNHg4a6YdRMd0GA/8GDg9QJM3nFkzNANCPplC2oqXzkCwT5Q?=
 =?Windows-1252?Q?aMvdZoymIr90CisOlOjtjuY15yHpTSf0sSneD2cBgE0H0y57iQvNk7Yh?=
 =?Windows-1252?Q?gRa6Gok+j+F5EiB+guZIVDqNrWatDEfFEhUkda64ftjx5/oV7w5JNv6q?=
 =?Windows-1252?Q?5Rm/eDJpjfcQmVQ+zrUCzOivMLNsmbZG1GROXv6YdGgJ0s5s7iVte1si?=
 =?Windows-1252?Q?vSxCTWiqWYDOy9L86kL9t7ziKSgWN/5G1LvyCdlWwVMo9BgKMaX0NuvP?=
 =?Windows-1252?Q?e7dPGSFsDsJbbrxxWiY3lqDmaiTMCSimAcPOIH+JsO1oC/20gYIUDIOn?=
 =?Windows-1252?Q?peHxQqK5QuBlorHE1jiQW+kfro1A/pKey6PT1vizSXgPbGEBx4RV+puq?=
 =?Windows-1252?Q?fYFzONmPLBBXbsHC8Z+wOgmqZAf6mFGS7eb6UbHFf1okryFw1LSX9yuT?=
 =?Windows-1252?Q?Xn/tniD9mgy9G+q8+kTE68Aj8W9AVzwa7wKzfEa9GYUR0UjgT4iAw/Ip?=
 =?Windows-1252?Q?ESMyp3PpPWinPruf143F8wWBGzdYnrBq4atSu645q/+65t0yG0l8eL4f?=
 =?Windows-1252?Q?d5MUg/8YPUelwpkvf6Dy+a5DIciJzTTfSJVLFtMrIDf9InEkDD1OrayC?=
 =?Windows-1252?Q?JHtXLuLE52ybXkmRGhWr5rpcIxkIAbg87TA3IpfKLzPs1my1VFC5dWM6?=
 =?Windows-1252?Q?rvA8ib/Le2Yc12EMQZFHBPt3V7ljn93xGB211hMgO7E5/MLVxOrcrLMV?=
 =?Windows-1252?Q?cTnALB3hawYTSVH7Tlya9kiVM+JgPMKqbdJqpXy+TCceoVogWV+vTw?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28716cb9-cb69-4900-a177-08db2abbe790
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 09:57:53.5011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1MVFP7vlneELb3UTSq1V9akNNIIPUZvUC8ch3sf1v/xHx3iPuXs7qKHtASef8t8TEB4/sjMZ22GHQ1j+VkcN1x5KV88YAflDGVF0C3/0lgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9574
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 21 March 2023 08:39
>=20
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 23 Mar 2023 08:06:33 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.4.238-rc2 (dc3bb2fad2c0):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
12924901
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.4.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
