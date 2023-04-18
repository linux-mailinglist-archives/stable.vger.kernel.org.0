Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFEC6E68B6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjDRPzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 11:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjDRPyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 11:54:51 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2091.outbound.protection.outlook.com [40.107.114.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A51198;
        Tue, 18 Apr 2023 08:54:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvDduDzQv0LSnX2QZZFOnsZrbwNFs2K/7xa0hEPv+/Q/poO9S+yTd4MGO/ooFFrwR8YZFFiIkyynFwmW6bxY0ZKFQORgmmf6YTfnPd6t6Ma68BOzSLHjz1aDtpz9XfNypk+bInoGJeUlCyRZ9My3AxWpBhjuqCVaDFjjB2KVzLUGL+B4zPUqQK6mmESgU15obe4b+fgrP+JCu3UvZsE6+UGUNClIlxnHMTKIHCisN5rpB7mGP27IDVLiD5msokxgZbYAROaK3WnyJqmZFpEZDwEZVjWEdFwskoGeTplC6fYoYzK6laO++rzS7e59TwU+4MHG7wt0cEMSe+v6mk2w4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvLg20BYLx+MZRFKa5oLqd+kaMiQK2IUOAhlLFDKoFg=;
 b=jmPXUjLl5GRetWOc3gT+az48sSjjI21q5udUklWakgrj5jsS9IHM4GkQT4nT56jSvxCFKdM95Ql8fxAkLGvfvJkmujaEE/cds7BDhmuYnPgZXLnTvyCyeAJkRWOJpAWeVzoqkhbZl85QoBCUR0tBRhoBqav53i6gua68zgUVFxpO+SYXfPgd3aPB1t1GzQthFjUabf+ABgHJ1zwS1RjdMMvH4XWhRNjImrFhMDKyu7ulp23tjdk8452Uujm6UxENA+OETEt4zPHV4VcDF3lCBV+u775fhn3AbJGimTjzA3CDmAZ1DgVm6iI+beOFvit/VJlSQ4b8yx8pnynlmxnqCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvLg20BYLx+MZRFKa5oLqd+kaMiQK2IUOAhlLFDKoFg=;
 b=QsNmEpNhyUgOqgBO6L2K7tEHuYxNECJ6aSPlHh8AQ4NPNx/lsqCZ1libA5N6+i3RhZFiFXgNH9T1SE1rZ8KbgGTZmEi3nh1h2nnLN2Y8WZ8b+EFlAwT17tsBWXQLNlRuBiCk4xlJC124UOOrOkFhdLyI8k5UQc0RyY/Kxn3tChA=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by OS0PR01MB6084.jpnprd01.prod.outlook.com (2603:1096:604:c8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 15:54:47 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 15:54:47 +0000
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
Subject: RE: [PATCH 4.19 00/57] 4.19.281-rc1 review
Thread-Topic: [PATCH 4.19 00/57] 4.19.281-rc1 review
Thread-Index: AQHZcfEP0yR6yM9PZ0+kqds0ygpReq8xOAyg
Date:   Tue, 18 Apr 2023 15:54:47 +0000
Message-ID: <TY2PR01MB37886533D5588F90113190ECB79D9@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230418120258.713853188@linuxfoundation.org>
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|OS0PR01MB6084:EE_
x-ms-office365-filtering-correlation-id: b4624305-e943-4be1-48d0-08db40253c29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nVNt2kTv8vzC/YYpsw5O/quPfRpCVNJNBAVqP7RnnoGSQ+Q2dyC+1rw+isPxQ2WKzyi8H2c9uNc3obYWCXFe7T1ZC0fnhV9LTZkyHssS7+QEKK1Q8G4Msou8fexH+t8y+Fq9gemYA9Im19NHslVWXEsf+rCW6daty8PH5zfOBeWX7hDRZSTqTydNjJnlZrTDW8oV+t8tT/tVKy+JWEiG59cJVjm14QFLLvyCv4mG6vzNf+j9aky2d4RyGqs20mWhw5+3PaaOZzYXQLUiH4MEcmOb38JLNDml83JNdikfgrkwIKNW1/+31aFYr403r9V3bkkeRpzLc3YLFOMljGJmjZDszeC1XlEbwvVJzks8aEptKHLP5EPFWjXCbSM2RGJKlqJTA5Y9i4apnRaV+6BL67+0HhRSruBmWF+23ds1BSYmpYn73RLnDO/fuG68pG5QRLyAzGsgh6+SX3WqmREYTKT3d9qORI+SsZ4qtsNY7G7jxY6DptP1gvdDCv4ny5oIofU00dRPMabUN1PrUcouDwEF2ryFkVnyCF2N6aoDWHIQm6wyJIRSJE21gytx+2fMWaULFPWz8NVe3u2pt4xP3hWi12MAqCeIvKJLrAlE86drPEnN4p90ZBOy5CdaAHn0IF0/EBe6s5SeUWEkrJN55Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199021)(54906003)(110136005)(4326008)(316002)(76116006)(66946007)(66556008)(66476007)(64756008)(66446008)(966005)(186003)(478600001)(7696005)(71200400001)(55016003)(8936002)(5660300002)(41300700001)(8676002)(52536014)(7416002)(2906002)(4744005)(122000001)(86362001)(33656002)(38070700005)(38100700002)(26005)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-4?Q?KsoDCEqrxeCRlvvHemoLtMDCurV93SavtRAShJCORqyOOfmdfnszUs5Oaq?=
 =?iso-8859-4?Q?HLy+6jId/n49znf7b1f6mhgmJCtVp9GfUiY5vmr3PxROFKl0wVb43Z5Zji?=
 =?iso-8859-4?Q?CR1hp/FZDY2cVmYQUMGCCWZnClwChwwoDOP02O54NbUo5OhAsJtGUceXtt?=
 =?iso-8859-4?Q?CbReE4ZdQhFjq+97oG65aXBBijLipBmW5FO33KQgYNFZO9coLEsqFsMigN?=
 =?iso-8859-4?Q?eRL8C0ooPcuEcSRm7nxEbzCbPXiqCnp0FPJT58w5oEjriNliA5a3PvKaR4?=
 =?iso-8859-4?Q?nh/NTlcmjw8ovsYZrNx8VQB3rC0lJndgEVjAslGppsH9G81iWBFAs4SaLk?=
 =?iso-8859-4?Q?sBzXhezZhq4HqkUScZUS3z2wc0mM9f3NAV4j25FEP56q5E7eIC9Iy85ukT?=
 =?iso-8859-4?Q?rKsJag3W6jdvye48pZJeQ4roc4cxsmb9pecntUElftLJw+Sl5It2f0VBji?=
 =?iso-8859-4?Q?aH6lWdhCAO++2Bk9CcmWNEdpA8ip8eb46LRjlczFmOOGZckCwDr7Wyh2fq?=
 =?iso-8859-4?Q?jt8/lckN16aDr0/I0GqeVlCDah69kdr/lz1I4GO2405GT1rhP5vhlTvFLT?=
 =?iso-8859-4?Q?RnWlgGZeOcWLQsB7Y3jkuF++QyAwj8skuVwhB721Wc9sU/Ujy+z4jWVXkp?=
 =?iso-8859-4?Q?N+4Uhql3R6WbVzLFWoXU1XTLy5JVeJj0a2GEBaBvQoe9wRpEZ6i3VuJ19p?=
 =?iso-8859-4?Q?usvvfNE5bZ6ZFmZIbSyNP6kdxy1atADZ7JkkUQ0dSPjbN42e1YjC7LHt8L?=
 =?iso-8859-4?Q?QAKm8FioofQpg+5cYR5yuhzFELR4IYO2/H+spI4fpTKv2uNSeq/HNdqAvu?=
 =?iso-8859-4?Q?kU3binJeHu5PTxeq+jEDCXOkITzImgIertgVXvjUNvxK84sMc948cWiDKQ?=
 =?iso-8859-4?Q?yafdfkbLKQ73e9CDN7bAZ0Ov5hRseQHPzSeBimG0dmVmfkcquPO1c6dRDr?=
 =?iso-8859-4?Q?PZx9qRtDB3zw8r9hRvBkmb3/dV7rsTBJwrx0zpdmiRk3Kijt/wqTFaF91D?=
 =?iso-8859-4?Q?NMuf92k4ckH2e6mRC0jD2/dE2dnmBDoIfl9JKUcXagU0HP5TvAmj3hG95q?=
 =?iso-8859-4?Q?hbHAk0kiJiPbv7kA58s561MChIPp9bKeF5aiClG6vXMuB6X0qup+qjY8Tg?=
 =?iso-8859-4?Q?7g4M7WP+jwssrhA0yjE5tQ5a1OF/FgRjP0BoNX/GCYL0HthiLGtDECJ2cX?=
 =?iso-8859-4?Q?I31IHyN2GEB35GjYc2372h9XdGuXQN4kfG6mOcMV8a1YA8qLDLVPf/zOme?=
 =?iso-8859-4?Q?wdA1qW+686GDk6mg3LRkRyVTKENq+xfyGi607skR+XJxAK2YUPNNFX9nEF?=
 =?iso-8859-4?Q?bNOX6lG4ZxjyOhOVeewGfntN7lT0hkaVBuK6bBI5mKSSEP3h2JNLdhM3po?=
 =?iso-8859-4?Q?a4b876FDg7hjt0ijKgi+4Mhh/mpH43j5pDb+f9+S2RToWrcvW5t6DKjZpd?=
 =?iso-8859-4?Q?gc6mVcqc9WvUuHMnaIyCbI2Bk5/sP551G8e2vvGRu+j8eZzx+AIBG/EkfS?=
 =?iso-8859-4?Q?kfiQSoWNCf3mkvTV6jwVeKQ2BojLaPc0TejYEkyOYU8q0mr7Zb5KJTTxGt?=
 =?iso-8859-4?Q?WikJgQHg3UsadtRo2Z4X1OwxFDmg+V5wvOAkyIQ5l9PUqC6z5WEilaKCCU?=
 =?iso-8859-4?Q?qbNimoRzffKA2qtVXjD/9uQwdPczUCLJRznmsGeGvPsKlpQTlrn5zPgA?=
 =?iso-8859-4?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-4"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4624305-e943-4be1-48d0-08db40253c29
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 15:54:47.0310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DWB3kBAwiAkllv8kbiOe2LPIjSoGwVcL5gfy7ceJ8VdEc81MBdfNP1+y5b3QaivflzjvPMI+fDuwzbHYo8t2CN3l6CNQv3mhdfWKZ2/fCXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB6084
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Tuesday, April 18, 2023 1:21 PM
>=20
> This is the start of the stable review cycle for the 4.19.281 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.19.281-rc1 (cc0a9b81697f):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
40768979
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.19.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
