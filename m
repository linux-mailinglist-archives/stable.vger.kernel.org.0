Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5819F6EE082
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 12:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbjDYKln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 06:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjDYKlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 06:41:42 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2111.outbound.protection.outlook.com [40.107.114.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABE713E;
        Tue, 25 Apr 2023 03:41:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aab8dxG5cCGnXefHxZ/KXKpaODxYvsAWkHJNxL0pTDsYIL52elcloWXrd+a/SpZZk9hejF7jVjgsoAFSncv0MRMByYl5/J4eKrjJxS8Uh+GgeGPjBT/73K5GCWZMoF37gj/j9JFS9GbtPuqx1qOgbxYM7PGozQNZ0nkTzCgTXtfRISXs/h+/cK9DXihyEtiqygzs8CqRTAFWlD1IZujmzniwEvs1+cPAgHccevKwiHp7ypxeeOEgxMHsMrF+AAJ2qQycRDaZcm/3pzo4xJ/4kIsBiwWSPyhBZXvvUwtE91/MHP3CS1ConWnnbWuYdPX2M3jBBp9fsSNTRHuM6csuHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jos/K94liUnzBImKNUMK8giZReuBhkw7+KcBaeb+VYw=;
 b=ZWY4Q6CIYtL+tHyg3S704vLZhxpW0D7ipHMPK2KGyktJyURFfU4mm7LGnSHh9T8iCfVAWXGj/YrFDYJH47cTAiRXl8bRvtJqwDccEHHa7ZBQEbwVPykDy9oBR1KQBUuu1MRzlrZgROMo7V+nvixOoXHbGob7DQdcetkdsUdI0wwN4JlXOZNNtTyOKJd61d7PV+qFeqs+D+WlLTJT/Wa86LERE0zIeqS+99WU1o4DHawr5jcoCs5LKp33aWefr55wB/XKQWg//INzMpgBjjH/O1PELZtW/0wOvycm9OYjGYcZ8tqBnRWBPxImCyD3wojCG+l3uFZRIFaulx2kLb6jAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jos/K94liUnzBImKNUMK8giZReuBhkw7+KcBaeb+VYw=;
 b=pj1iyLJO8YuwrztjC3yHDyEVHHhqFCC5VYREFPhSp+KrF8F9go76aE/tkkjztdDhjwSFVNwuKxpnCU3XiyvlwglIjzAHQzKGYFg35jPuL7lUwIE/ml6XbYk8ulC2mRL5/laG8ylO2IZFbICeMc18fwOGB6NJHED7u3EK0u6LtOQ=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYCPR01MB5613.jpnprd01.prod.outlook.com (2603:1096:400:47::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 10:41:37 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 10:41:37 +0000
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
Subject: RE: [PATCH 6.2 000/110] 6.2.13-rc1 review
Thread-Topic: [PATCH 6.2 000/110] 6.2.13-rc1 review
Thread-Index: AQHZdrDwS4G+/aGp+0K7GDL8X0FuAK871z1A
Date:   Tue, 25 Apr 2023 10:41:37 +0000
Message-ID: <TY2PR01MB37888D459DF15E745C1B4677B7649@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230424131136.142490414@linuxfoundation.org>
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYCPR01MB5613:EE_
x-ms-office365-filtering-correlation-id: e6a22e68-aabd-4ae4-1ed4-08db4579a5a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fPfXpx5cf6YKKAOrzp/yXIXpnw+ifAWAKTevZgH4l/1zONLAvPDP6KPmBsEJbgnDDJgwyfItx0yXTidBomjyv5eZKFelveOMS4+jDs/lNHRis6n4iIETQQ80hpotcYAKZvXY3vgcWuJ5tT3btuxTo81K98B7bu1SDRo5DsgceEa//WNF4lOEDKch9Ht3jah8q9jev0GUuOJCFdLmxLJJ1gQ9C83jLpCkQyeHn6NKeXm4rVgJIIsX8aCi86/1XFraHUuXmN1Ki+V4EdrbM8zWTU+zN4/lH+wDfIrNvNHaA21akoc/1yMVumS082EKBwFKReHT0eDwocDe9trrC9wd2bMXgUizFpfnZjCnlcMbdywXc2WDkrLFVQHxm9Yi0Snq7nj4hhqh4zisEhzRJRvBGCXi7PDVt/Mlvk5eQxxV9dHHzZXKKX7rsyMxKDNLhtNDi94n9kgoifU2PnRdcIvah4yXG8vayoK6VxYfZ+uN52cMZbNmv5mhSm2XIUU1iDs9OMziR6wzAhSM6zlXAW5xwKcSpo281LLQvruJvz5aS6VWolT2Vu5Im/ocBBvyPJ30pLIGJ7ehCpBb5lmcS8eH6+11GPOEPeiAqfGqkzb7cKOL53EU0sYsVlLc5wZ+kuIu8ucAo7mNG1BXf3MkQ3xgkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199021)(4744005)(966005)(55016003)(2906002)(71200400001)(7696005)(86362001)(33656002)(8936002)(8676002)(66476007)(66446008)(64756008)(66946007)(76116006)(66556008)(478600001)(41300700001)(4326008)(316002)(26005)(9686003)(6506007)(186003)(38070700005)(122000001)(38100700002)(110136005)(7416002)(52536014)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?l3aUnz/wDb22F51Rm/GDQ2UexwIY899fyEyHG6xvRmx8CYl92XdwhQC3?=
 =?Windows-1252?Q?P1bxaXc3qSA41wBT0nV/Rj9jGAGpNbeoRCBbTvA/IsGLaaVuHdZkZVra?=
 =?Windows-1252?Q?4yQGATY4NFUw8jlwO6PERsjm22j3JsDqsJIyW1SOyd1PhIrq5fnFQXQR?=
 =?Windows-1252?Q?0eiGZ8Ie6e5QFBWNQ+dFlYcdmg+IOzj/8BwVYRD5IyiQU0Re0Kg3+2s7?=
 =?Windows-1252?Q?TPBnToEzufAa9/KUyjvP0s+gfOBlyrJCGXJHINGiW36Kr4a/V6XRxNkN?=
 =?Windows-1252?Q?CDWr+SC5WDxpP0FL/9C7Estcs3pTWIeFdGm0/ERJB7rKw0uf9f7UKdJb?=
 =?Windows-1252?Q?4bGf5hXzdsxb8SOlqRUryx0Zbh67hQgcWwYCrc/w0AJv8Jjy00M+ZFNw?=
 =?Windows-1252?Q?WY/ivvuzLKNIiX7KnIMk/alpRdwaooe0FkwqbEt66m/EbtSk5uBPfR8t?=
 =?Windows-1252?Q?QwD+LDkOrJLddOPkhEEzyxRuxRKOIpI9AlULXQu4AL/NNs1neXGXUEsg?=
 =?Windows-1252?Q?7x/D9y1nM+0FjGbe/FY4TKCCMHA6BS/GqiDP2R73nuIdz0+BZn1l4hhp?=
 =?Windows-1252?Q?wWao8QKbxDfn9hAeClgeCK+ItQmyQJ/a7YhEYcgWpcbQJUGg5qJNgtpM?=
 =?Windows-1252?Q?ya8qgNkvHDFfxReSk15ZTumj3onM/oBZ/XB0IlaQ9sC8jc8TqihOdA5O?=
 =?Windows-1252?Q?hJ0arp1oGu2w8wzebsunuY1KZT+vkOzlEaUflrReJh+IaYj5/z6cqYLn?=
 =?Windows-1252?Q?DavF/sEbYvUojYV/CEftwiwMUju10fMuM+O/E+4fmgQibpPV7pBIl/dL?=
 =?Windows-1252?Q?w4ZbepNUVln6ETsIhyrDpWfEW8LbI0M6ebVzZ3AYco0ALCDC0t402I5h?=
 =?Windows-1252?Q?PXBq+lsq2SoYQ9cqdsbFQs31tCRNbjKqyotN75CqkXu1nTPIIwa3FQRu?=
 =?Windows-1252?Q?BZAcXBBk6HNdspOQ31I/3UcCNrq0iNqlvWTjHJvlJFQ3JzkvTMDRuukc?=
 =?Windows-1252?Q?CXRgHVjGjKjtDkWzwek5k0Q1NTGD+8epWWUukwb5dBdGCM/e2LH/LbKj?=
 =?Windows-1252?Q?eHoAZf8egeUuWh0YZaHyhjorgTO4HVq6rTY6rpJt6EkG0fvQsl7s2QUO?=
 =?Windows-1252?Q?15SCB0V9+cxOy9dPozv9DEfyHu811mc1uYgOF7v5colOdIkO74C4wxcE?=
 =?Windows-1252?Q?CIQGvXMf0zZp0LzifOQtEw3gddpp/yDIN1mh6tRr2FUNWO8VoMyGZOd2?=
 =?Windows-1252?Q?aP+oWU3XskPW9xN+AZ/Y5DEGe6K6MxFHqSX+Jm4x7sx8w/Fq1HQDdeq1?=
 =?Windows-1252?Q?tHqFjNRYdaHC60sm7tMagEMU2JnK+Q+if/89o9nIt9WUsUAAzm9IR9WT?=
 =?Windows-1252?Q?j85M75xIuq0wMoNPGo9kDQPopALKhoW04LhgbT6FfeVjs7upTxWATy0Q?=
 =?Windows-1252?Q?PRwHgTatkUbBq02Pqgz44VGRZkJTzUo1bTxEcwiyusSbONoauoHsGPTO?=
 =?Windows-1252?Q?Uz9coLyX6hpfkgBRhCaCI50uAvXNnfW8vbwFdsFq1Zr7gY1N7dbNd7MO?=
 =?Windows-1252?Q?q9aWDburQIQtXXHQoZvZNNcDI+9E/FkwmYWFA+QMFG1vgOsv+EC5RsFa?=
 =?Windows-1252?Q?XKeMBXVCGSRz0KEiz07Fbvp6vivC0b6k5GkZmmuvMpuUYlXWBruf8o3X?=
 =?Windows-1252?Q?ueMbAY31Z2W5SqCIrh9JxgSp8OJeGqe0ziaGORhehn5EGP80HNPpdg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a22e68-aabd-4ae4-1ed4-08db4579a5a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 10:41:37.4878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fe+xxOLBD+PXTYn9hhb1lQl5nvMyF8BQcfvaqp7jRFagkKn79h0IjiGJOqr7EiXvVRRelO2/ggiQQrLRIN88DwigxYntqjzDMxI7/XsyIV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB5613
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
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 6.2.13-rc1 (9e5d20c13940):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
47554821/
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-6.2.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
