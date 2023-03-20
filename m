Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E986C1DCA
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjCTRZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjCTRY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:24:29 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2072a.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B583A1E1CC;
        Mon, 20 Mar 2023 10:20:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0sC4iLwYtUwUzWnNcyYNj/rfCXChOc6MZFSHfWj5yt8uUI0m35Gch/XzOCpkkqqNptqk2M2D3kZJqCpi3WIh/Fq46zwtL/K8W3VuEi4NYle0uG9sUunSMM/HCKLuomer8JQxzYB/fb8CV7I6iw5D5uWXS87pDs4dgH0iiL8xEUpDZ/EJl9uS0YHicuhF2fg+VDZa/JhnAb7FpuFNhLHVEoUjsjvfBnkHRq7Zg7kxQVVQDnQ4ZewzSfC259HypdPalImUCD+M0jcvUK34657jBx3Uja6+ymq187wAvdnpgXK5eGhfOm3Uw/vOPfeoXs2YlOAc2OiLG8Mv9REKKQHFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ly+6ojmnYRrJLwhcnPpmVCrvs4r/zYZEwVKNFUhFvqY=;
 b=UJp5r3yT0oWGwNDfyiJ1m4kY4Mnmn297+ykOo/Ri62g7GfoBWAhOiUP/yAfVug0p9uoUTjTkT54ay/7Zntp6npSZCmSmDJo2AIpNEoW3xZhUUU8RzWHGR3YcJDQ1KDHlOn5hiI6X7a3z9pYQz+njMVwa51vBt0rIT5rl46KdJFni/V4mMjawumo1miRwGGhCVnuj6fDNZLt74ds9E/Fn66pJ2hMUaXSUlFZUHrE7fubxXnVw4t9x0L13oemE73KgoeJkhYXP5SD2lP3Pjk3lGgwDnIuwzjpKTBNQmjA7T+jMyyw1XoRgokSOi+AQcO2sbWloFLbBtvA0WkL4RJK1ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ly+6ojmnYRrJLwhcnPpmVCrvs4r/zYZEwVKNFUhFvqY=;
 b=OH+LmOO1cbObsQlbp3JCCgCllzvLGE1xlD9D/ynVS8EcVFDh1W054sd3xZvo8MnKppXE5uAYCqF/uY5WqMPVIH0NC679VGr+ma3GFYmpBeTGMnXbCmaCJpIEqQRvWmGH2QjqLQ/WsL1dRH9X0axd//+M+ZPNndc9eYZdSoWfXx4=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB10457.jpnprd01.prod.outlook.com (2603:1096:400:2f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:19:19 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:19:23 +0000
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
Subject: RE: [PATCH 4.14 00/30] 4.14.311-rc1 review
Thread-Topic: [PATCH 4.14 00/30] 4.14.311-rc1 review
Thread-Index: AQHZWzyNibbdLQpU10W/B0G/GL9AQK8D4vaw
Date:   Mon, 20 Mar 2023 17:19:23 +0000
Message-ID: <TYCPR01MB105880E98ADFF37A38C71C655B7809@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230320145420.204894191@linuxfoundation.org>
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB10457:EE_
x-ms-office365-filtering-correlation-id: 16fbdf98-2ccf-400b-c5d1-08db2967400a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XAHU0U91Oxex3NK69kkYEjaiSShJR1tDk/XUPzjQ5uuC6FDWs0cRKTAO5JFIy4wR0JYSA5G3D9rJr7xwIkVwxD7UlUlUmFdLACBBWpxzmGKLA9QXwdC8RHeT8wqCy9Hoc4KOjFuZSUHmuwLmzEo7gAX6aFfS8C6fEhFrVYBuHkxs8OLyoYW4EHkOPIpADefE/nZEqpsq4wn0nLPZ5alA6HTDzNN393Z5MPHV2mfBpxSEwntfxszGH25LeljWVHCO2tDAfLOw5sRFXbgskzXN/Sgckd49+Rt0+TQj4y7C3lYVQoY0K+OT10ozMH2YDuX9B/CKxgpmS4KJRU8xE5XqJRPc5LtY263aL+XpdXoV0bAu0QVhZ9oV+DxBTIAD6VqOi5KAix+BWjKI43npjuGU9mYYDZdoBk3MydrLtkgEvyLxoLGuSM5j/YEUE+gdbZ8l5gkrSiIn21+kClTFFYq9x+ahErJtKBSivIjYvoetLp/p5A9ConZbsjJikWUI8Wm39bYcn63F94JqZDOeV7IhXPAtLvx+Ra6UUu6i3v5voJedQj4vA62OnhjrNUCJLoV4QVQ6GwzI+JjTpo/azigvNoWO9y7Bbgd+hQaAksjQqJRo/KgBt6y8sr0ndoXFKDQYzvsVz65zQs2CfRHA/UdPd3vHG9dPlObRpIcIVhTE49GIWCwYpBcT6EYU7VLkEw6vaJe5cq+4fapeEIpSY0anEtxEwV6lUBLIGTp7fGn6Soo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199018)(966005)(7696005)(478600001)(71200400001)(316002)(8676002)(66946007)(66556008)(66476007)(66446008)(76116006)(186003)(9686003)(26005)(6506007)(54906003)(64756008)(110136005)(4326008)(7416002)(52536014)(4744005)(41300700001)(5660300002)(8936002)(122000001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?KbVJZSG1liNRgvPFVqrpgk5tGOHh/U/q9vix8MK5z+/oI9eyFivBGSch?=
 =?Windows-1252?Q?o8/2LrkUq5+V960ExymuOaLP5kMsF1nrc20rX38SgXB/2Q4/Q/EwOlFY?=
 =?Windows-1252?Q?N0oOQEygYldcatR+5/m0hcGoZdXmSrcLrVIXkV74ZXmmIKlbTwL3cdGS?=
 =?Windows-1252?Q?caCKeSGZ6vjHn9JFw6k07UxT7jZQUOZ7Qz0MHEC7BtjZgNrphhHuRcjE?=
 =?Windows-1252?Q?zlt4G/wbhVEkaP6qj+QPQCMPvlcUg84lE0TTmY5a3lGhAJ4F2G4UWET7?=
 =?Windows-1252?Q?N24CewLv9fTWpMGmN+FoLnyDj7aqywYpr7BD2FZiU05nvri1jHxNwOJW?=
 =?Windows-1252?Q?3q3yEkEzIAcrygqVfoiiGVsoqK1dxLr3rYFtNlszaaSq7i8JVe5Qgc/a?=
 =?Windows-1252?Q?lExirBnxbaY/uzDFTZyw/v6u1TKv49tM1B9HnXTtqqHIZANuSY+Irq7D?=
 =?Windows-1252?Q?kF7PPN3MlzWZsXqR4NqASsiOo88CUblRs1xGVJ7q9gGwaUOUp+IItTOr?=
 =?Windows-1252?Q?hWfeJ11C00pCeCvmb6YsPqdAKdvuF3y+ETIiEtyEaFt6UQ+O8I0pnTF7?=
 =?Windows-1252?Q?y198gJF+e9TjTbehIuKkCXmn1v5rjAIXKxdWBQ9F/l2wIQ3p/6xK/3wB?=
 =?Windows-1252?Q?fFAgMzVtwZRzfF6dCIw1au/atyqZ0ie1dtp3olal1swOnpRxps+WbC0B?=
 =?Windows-1252?Q?ZfR+tW8Qz7BNMw+pgLmnoTQ2EUfVgY3oOgF9D5iiJSzJwb3WyeU6h1ue?=
 =?Windows-1252?Q?Nvg/yNcUQGH4QQIJnxkqM61ShhS5iUBBnySBrln8h8YCTBpEn1WEulA7?=
 =?Windows-1252?Q?hT8CJf0u0zMqSehEAjqWU8TEG7vbFr0jeXHj+qgu4FtxFAB/PlNPQS4N?=
 =?Windows-1252?Q?Z+V/dEn81TmQL6GPaB3lN7CTtJnbwcvFcHalKcTM+prJfC/KEiAS3DmO?=
 =?Windows-1252?Q?IYroU0w7FbaMvym7jN8Yp4i7vsWqQFCNzySYwDZyPmGmC3NksWXA9KPX?=
 =?Windows-1252?Q?fbJS4o5YTUmMBoxiDj7ifuAEQzr3NMhOIn8GAzeeFCZC3pBFE3Pu+RaB?=
 =?Windows-1252?Q?5zLUxcgrpA8FsvFBJz9b33CLiK8sFuHxwYFCCN8zDL3FdFtygW111yZ1?=
 =?Windows-1252?Q?htGPLiqJKTKZYRPBxtEHJ5TV/wCVcDHcCr6+gwlbzM0YTWEKI/KYbUgw?=
 =?Windows-1252?Q?03pXz3WuEnf6TRcZuukCUdlM28H5zazVOdQssqyoSEYBLoSoGnOVLvH2?=
 =?Windows-1252?Q?7GZ89IWaZc2qUGK0ge7BOM6T06X958RlvpJE3AXl6JBWxVq41AZKXHjP?=
 =?Windows-1252?Q?fv/P4hVbUo0RGbPikEqG8opKKBWpVVuokW/OyUbMIXifF6Aj7UixCfjl?=
 =?Windows-1252?Q?ynf/MgR4auKfppy/+FjKRiwEpg9gdAT+EcG0xLRLfFdg3GKhQRq+3TYy?=
 =?Windows-1252?Q?9gwVF7nT86qqyO86NGjFsb7AylOTiSDsn3oce4QEm0fis1H1cHfy6N/V?=
 =?Windows-1252?Q?vr8Ib8r/eG7B64nl2nJ2XUCS2ooVSBRV/dD2Wyw0/ikCGnG+7hbhKXKc?=
 =?Windows-1252?Q?uVJwpHOkcHps64QiS21wUNYlbHAdH9m7UOxjw7EDblZfzakvmhfIu5/q?=
 =?Windows-1252?Q?TacHkGQ35ixa+H+Z1T5/RTeLO9hxedl7Tv3ePgbJX0+9N4eLdr0lEdVe?=
 =?Windows-1252?Q?O9kTiKK7+AyL1VQNlGCpJrnpDKNbV0GpzW8P05KIK2n1bxXYeBN6Lw?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16fbdf98-2ccf-400b-c5d1-08db2967400a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 17:19:23.5250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c6nT3NmJdLJ2AWmY8lKDjt06deQ4lfOsJv/OTBaPtPD2dETixWoXjk9Us8pKVkL0bwVFZH23GotUWJLz1HuU+euPjBIODfAXvwhdkOPM128=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10457
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 20 March 2023 14:54
>=20
> This is the start of the stable review cycle for the 4.14.311 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Mar 2023 14:54:08 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.14.311-rc1 (771f7d636cc9):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
12171990/
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.14.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
