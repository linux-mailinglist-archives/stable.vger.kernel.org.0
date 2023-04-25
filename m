Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52046EE335
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 15:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbjDYNhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 09:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbjDYNhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 09:37:50 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2138.outbound.protection.outlook.com [40.107.114.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B545BFF;
        Tue, 25 Apr 2023 06:37:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUie8CN2RAeGqXjXZEFON2DZZq4bcJ2L5TXeZB6JGw5mqNH0YQbjjOCUITfyQtNNctHCjyRnHXHlMHR738yo6awS2kcVVikaxqtK8YFsvqEwJZxjIo83k3rrgLKY+68zj9zIMOD/baE1Jyq9eKK8g5CdH+meg9tmiXnUIP2EyJxKmMmjhFQBclwQTPyr3I2WFdnP+FS4qC3m4f07H8AFCc1PgBXKNNhv1OUXHu+f9M59tGnNoNEjhp3rMwT8R2tqo+PrqH4Q0xMLtZDEyqlEoKbCbkBDDUARrolNfO+O5iNQ3HuFXoc76C+LfUuLkZSyqDvGi936rAsTAzb+7bAbfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7/3IUEmvM3VV7GQnqPVlV9LKNxpgRdDn/M/kPLBBZs=;
 b=QAJji1mn7tx9ZPNvrE3GUFoqgciqDQU006gxO3dNLseBJmbLRuBEd12x8q1DxLdXrbC8ZT9u8lRV7QI+n5jAoyZp3lSmpZTHN+wXN2X+UpD9oAi7Wo5xZeQNPHifKM2qhsXNaulzImX22XpUk3ucoUh8dNji1r0krZNZ1s+W6q5/RJPiOK/WG4u4AEG8lgeUMCNLbbmTn52qni8TIHAXeV8Oh34nGxgwqUKXXKpOkJ23bbAfBwqRZxhBkuAkA4wUnF8U/Esbx92QSNO3AmeHyUKpGoHEJkyz60dQBxMWtfVawikELKAmqqxbB22N35PoTyPi4Bj4Rw3mTrXkkhAzMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7/3IUEmvM3VV7GQnqPVlV9LKNxpgRdDn/M/kPLBBZs=;
 b=auuvCKBvk2efmscSHbenmc9fWqdNpREe0i43Uixmzjl5/Pn3MRI15CRo/eTOViDubrakDaEbtI6gugpA1Bar1GrS7TGM089EhW7G1HrHD/hXcEUaYQ5xDYybZn0xwiBMcgmh7pFgw5/pqkdTm+z6a0MOhLIGiosa5WjB3Mk1COk=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYVPR01MB11118.jpnprd01.prod.outlook.com (2603:1096:400:369::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 13:37:44 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 13:37:44 +0000
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
Subject: RE: [PATCH 5.15 00/73] 5.15.109-rc1 review
Thread-Topic: [PATCH 5.15 00/73] 5.15.109-rc1 review
Thread-Index: AQHZdq+ExIt8BQ7g3kK43vosOxlwOq88CI7Q
Date:   Tue, 25 Apr 2023 13:37:44 +0000
Message-ID: <TY2PR01MB3788325EAACB5FE73615B084B7649@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230424131129.040707961@linuxfoundation.org>
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYVPR01MB11118:EE_
x-ms-office365-filtering-correlation-id: 21ed3a3b-0b34-40da-843e-08db45924044
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 011pdRZrswYfoaCFRAezI/7DBvvoxPsg33E1DDZ+5YraGoxSC0kHOyxm3P31erl/yFiRGSYG9tdxsptNiV+6KIsC8723gnl1sZDxkkITzZjfwMW5ugZy2sGJvQGToYlrhrFAgDnqYSx/jVRH7LAxT/05yHh5sC69zOKYrmrae4teXFZflUA/4GAB41RlgajZZgPDMLGMGWA2gLG8ZJIhMim4xINtf8B5atuNdHyTyV9Zjr+xaLhD9DNiWNp/ePTcifJJD3OAhRKmye8XEBE41Na+jyUzCHa9CrYDnxq+sVYMc/3SAvLYKvZAeAuowTHcdDvmFa0KPRXOrtzXjOcSbnS15QQmtzHlOHBkEVALm3MJAUZGc/3ICS1xWInGKqj0I6+Bh5wK1qjczt4M14XLk/ilfTemRrMoL0GrCPrNM5gVCdY8TbmRZqDn2Pi55+t7xRS70sXXBe6sFHpHU3PGC0NjXOqoyGHGeI+MsVR0nOKqHX9LlnmkAmObrDdm9qtz8XwTg/fk3Xb4SzwJgn7hkpLXtcJcJyBMaF+q0DoGbrNHy1eEPGRHaaAoy/x4x6PpIWmie1a8kkVNDUfdN4id+nlpmH5xVTM67Wl7bYle3XXKkaUzoNkHq4GqP8czrjGJhCcebQwltU4PrPAqMNgjow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199021)(9686003)(26005)(6506007)(8676002)(8936002)(54906003)(4326008)(316002)(66446008)(66556008)(64756008)(66476007)(66946007)(76116006)(110136005)(41300700001)(33656002)(478600001)(7416002)(7696005)(71200400001)(966005)(55016003)(52536014)(5660300002)(122000001)(38100700002)(38070700005)(86362001)(2906002)(4744005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?btkqtncs+LyLNJrQYj47Y4DqJp2Ja+VY6EDLDtUt5B4qzzPQ15Xi5/c/?=
 =?Windows-1252?Q?m+Gqxh+0qIE20MKZiNYHUHRc/Surj1HD0uA84B+uZKjmM/RqjJf3NwDO?=
 =?Windows-1252?Q?gNXTFION58HZ0B5i3nN+PsGKBOdslRmfY4da0Ua5gBW8yvnPLQuyw2mL?=
 =?Windows-1252?Q?wcFI3B0CgUKmCNsw9u4ZcbnrcTujVhf9XtsUrrfq1mkgBtFMpLIntyBb?=
 =?Windows-1252?Q?VY5fb1TUxSg3uv2RECzVcEJ1JMNReUe4rrfncJXAPIFZvJtypMUgQwqT?=
 =?Windows-1252?Q?HvkNfCQZq0Ux2WqOW6W+ViRnN8zsWm6cJBk5e1oiBYwSoB4Yj3E8O7UI?=
 =?Windows-1252?Q?LXeVNDtzAHLSbX4BSgUfMtm/9N2nudqiuBXKGWfl13E3pdDKcRg3LyZz?=
 =?Windows-1252?Q?AO50uMfTFfspNDN2Anlb7vo8YYRpT1r0oxAZay1hIhFhanrszSGo3w4r?=
 =?Windows-1252?Q?/ZQ28nBQrYONqlpCrGDYxEjM6e3/+46SSoyXjSkSk4VjdBlBkLfDmlko?=
 =?Windows-1252?Q?jQbwpK5zl9PaUAcwmG8FRu6FLlDLhpVb7scm6bAvcB26rqQfNJG5+AsY?=
 =?Windows-1252?Q?Q5jYWvr134L11HRwr5QIpSfHh6KSgZ04xf/hiQFEETS+thn5AbVkFw+2?=
 =?Windows-1252?Q?re/HJtLI4KNOG2IZJLoqVFQBLx5trl0UZIfNUn2CzAYeUVkv/NDhUMKO?=
 =?Windows-1252?Q?dB12EMMT2PhFUIiZlfyAvwdFN8ympymK2G45YrjizuHeCOguL5+5sBFl?=
 =?Windows-1252?Q?nqaDGFOAU1K5+J0UwHtaVcwKihGlLH//6EFkh5cDdm6sQBdwCV9DaLGM?=
 =?Windows-1252?Q?0lsRzc4bXPiPaCsEBsddiV/4jSEzT1a3IBfRqqSWP/qzotx249pcduim?=
 =?Windows-1252?Q?e6DyxpLCO7jTVJ6CU3j+yqLgGnvjl90UnTp69WuMy5ByQpYFJCi+1JcE?=
 =?Windows-1252?Q?fOKZ1baG2Id8evqeLHpBoOkjmvQFcuulGkLZdBcxJqQF7ufBGWbZopIl?=
 =?Windows-1252?Q?k99/YeAmrEWCQBpEYvnfaGXzxJGpiPmTUcZt/7psUG7R6iHvsJdkO44w?=
 =?Windows-1252?Q?7/r8kmBQwF6qB3H64J2CtZ17dRQUniVgRJenWqbjYj5NK6AaIdhgFrRM?=
 =?Windows-1252?Q?LZ46r/FsVf6dhlwTNMH42PTs7+iTuW7MZQG3yzU3FoNGDkI9c5jbnYGt?=
 =?Windows-1252?Q?0q+N9bmKTpronyBeCVXlpAfNF6rat63Tc7UHad0cZY9vKHGEPORtQvsw?=
 =?Windows-1252?Q?e+JX4SSl2HaRVSha/mGoCHWT9UeFzbTSzWQCM5tYPTGGXJit3fRflrua?=
 =?Windows-1252?Q?VclV5Xwe401pOK8tzQYDSXRM2vKM8kpRmqRe+TdUa2cIlUSSXEmqGYXL?=
 =?Windows-1252?Q?NYujRPwVyeyV2Iv0ZqlFIbC6VNq5gKTXLCPx9Np1gb1hU2M4EqN8TUdX?=
 =?Windows-1252?Q?orFz3ViEfcrD3UfsuXj17Eowvt4pai2TZ0o0Agmo7/+qtrVQudmAKLB7?=
 =?Windows-1252?Q?i799U7phWteQ1UYRyHAPZKWay/Shhs5O11JFSezXlJuSLt0eVVC2Elas?=
 =?Windows-1252?Q?uZbSVAYpNYtm06LEotyN7Nj1pWJKDOtN5jz9/SBjNNihQQ/xqxmGEKDC?=
 =?Windows-1252?Q?6oGIDs73KwM+Xao9l+wMawA7N1bqeN3qlFeikOJzjtn9lHxjV9kA5sB1?=
 =?Windows-1252?Q?mN5bUiJR73jA4y/Qf9/LLP5ylEau5TFKRpvnCtRD/v0SfTa1XRmxYA?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ed3a3b-0b34-40da-843e-08db45924044
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 13:37:44.8405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2NSTzFNVVPIGEem7pt5N5pFOOPvtxbHqBy+DTjWPAjo2JOjPUHZbmbDjAgS5aQft5VlJ7Nk1Z3iw4ckw/oJV8V+9Pk0D2KVwb0CScUCB1u4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11118
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
> Sent: Monday, April 24, 2023 2:16 PM
>=20
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.15.109-rc1 (579deb859f24):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
47553283/test_report
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.15.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
