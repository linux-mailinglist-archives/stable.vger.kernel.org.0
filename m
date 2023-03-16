Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1786BCE17
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCPLZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCPLZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:25:34 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2120.outbound.protection.outlook.com [40.107.113.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E1BAA71A;
        Thu, 16 Mar 2023 04:25:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bG/hRUYlCWyxzsodwb8QWrKVOL9kt2UHor7zjK7PKf1i9+ckl7i3pIdShU9qwElBODuSIsanFCw5az3oyAG7nVD2PBH+Lgt3reqaxknWvQwn/gFKU4UCvDY7foCWvS7NC0r8JvGycxH8gpYCzLI2wv9FIu6lQ2M2DCgHBSdHD2zWOMHVhGAYH8pE4tUt7DcS/Iv8cOx3y6c7Fa0trfQ1941WuMdKvbdYp+QSA7ePTruhF4RsBrydRuCz/xNZEtzlpGWm9Kmlq5aZQ72GRLeSWxAnqlIPSKRomI32eZnHD1YjZec8qEoZb8uaBN9gBZUHWDr7SuXs2OQM+pXn0Z7fwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qgG2XHmfypNEAcBCXYVuJynpE2xpLblnmpKja+JDG8=;
 b=YbhENHO/z/wNFqUus74atc+PyV14qVVFPNTgVeYUS+aES+sAes386PIVD9dXFzWuo2rdRn8sEIJ27laK916pqJZ7+eaFlmaxOutxBJ0gXz8b6ayf47gaFb+25H/zhTCi8J0tg4/OF5OS3FTCWMe51hgHDnW0fMM49yZP5C1Ian7EGmcgDKriHd1wA/tJjMlszrf7UAhyJjVaiQudPVitcIzov9QrM7QP42XqVgnEjv5OUFSdiKKVRIhy+hRbj2+eI4qmUlRQACtsI503BJ4gZIZZSXb7oLUzzd4rBxWi9+tLDgGMLBikstN9rZJcnpavt1UDeKmAC7VnVB9W2L/2qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qgG2XHmfypNEAcBCXYVuJynpE2xpLblnmpKja+JDG8=;
 b=Pc9h2Y9J+8m/GD6eXWdFw1JaBtw9Ducx4yJqKpmjVX3XpIASEI0gCs5IO0rTJP2GR1EDpaNIpGbXqrlaA+oP2XQg+Boen70Sna2pV71wtjKtVEYxP/ely+xupn06pqRcb836S4mHy8HZ4d9yTbvldyhUl2wc/w6+fFtATEV1YyI=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TY3PR01MB9763.jpnprd01.prod.outlook.com (2603:1096:400:22c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 11:25:29 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.030; Thu, 16 Mar 2023
 11:25:29 +0000
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
Subject: RE: [PATCH 4.14 00/20] 4.14.310-rc2 review
Thread-Topic: [PATCH 4.14 00/20] 4.14.310-rc2 review
Thread-Index: AQHZV+RUy87Uo7cV7EWFQvyxi/S8sa79QRpw
Date:   Thu, 16 Mar 2023 11:25:29 +0000
Message-ID: <TYCPR01MB10588DFCA0CABA9028F2FD723B7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230316083335.429724157@linuxfoundation.org>
In-Reply-To: <20230316083335.429724157@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TY3PR01MB9763:EE_
x-ms-office365-filtering-correlation-id: 135e2b7f-0409-43a4-c54e-08db261125f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bi3PMXOZN63XkioKfIGL3ATfZWcSTvs1a91RjVQvmAG98YUTSIN01bfv6fibX+zAK0Cp4BpWuC1IVtbRjkraudXf8HZN8tzKS9CXMZex9HCNpuflJMqvLqwA/tzng6YDi5b/B8i8I2qYX+MA35yiSs7j5+kUT3EWLKJSgbQ0jyjvb7uLdvn7K7q/T6ro0xX/Fcjm2PJ/hjRfv1MhUN9jGEhmoGMbvtIPHX1VnBEJQqGKL9Cpu/dmRImrIzL4OLOFq6SAxt9QaMALmmhNyEp7cb/HAud8sv2eEeJfzfDdNNywSaH9cYh3VBft4sYPD6RaduBE0CRerHALqrDVOXrD3RQyRXFlzsdldveGWihccGELAfoBhU3U9fiW0W9xUoC6BI+yIxyOAw+7aag6Azp9ypkt+5wOETvTwhaK0Pn4XkHOkS2pAhsmFl4fNRskG6Ul3OsZZZ/y1T7jVyV4S0THYBHFdqOwnxnvpVTfMD+RgMswlg5e84koWzBvv8L7FQxr3D/TW3wswGBweIKCgZJlAZgiWflQHR/ub4/2W2yIbRwpL9xVw6tS8ZuSncyT6SoLIvMzimXPtDmB3/mKlQ9JLZ8NzUYhqjEnH+4CIvsGUoA8kFx8OMM2rt3xhQtLb1pwM9OnEOowsTY0rDXcH+758Cy4xO21a6vOJnXvGy00bjKpLyEO5dVNjMpAofGcR9lgUGw4eaGM8Wq/O0PSNLDB7xqWtm6RCiM93IjHMKBDPBg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(122000001)(7416002)(2906002)(4744005)(33656002)(5660300002)(66446008)(52536014)(38070700005)(41300700001)(86362001)(8936002)(64756008)(76116006)(66476007)(66556008)(66946007)(110136005)(38100700002)(316002)(55016003)(4326008)(8676002)(54906003)(478600001)(186003)(26005)(966005)(9686003)(6506007)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?d2zwg+OUldNMqHXjZARILhKO8U/YbqyfQqfPjxcnMeCEJGvJlr/Eaxhc?=
 =?Windows-1252?Q?ziMo7OiPtDbz2dUGeC22QzKmWEKiqelCK4w3nO1Gt53sR60O1sDWxkE3?=
 =?Windows-1252?Q?1efwI4NLl/gW/w3zB1r00y+YwZ6GVd/ZgzgUhblFMdPxjwjgm6qiypc9?=
 =?Windows-1252?Q?eUHbkrF9qVVQFGwLzQ7oQUK1fdZoOEDixUJ8kIhzSTzDSHBQ5V5/WHkF?=
 =?Windows-1252?Q?83udDo7HLnFjAf2sFVzLIpjBEB2yPAfefW+SfZhcQD82iDbHdxBVdABb?=
 =?Windows-1252?Q?BDTCfDfAxVvGkQKkWgwImd9eclrHSMI/qh8lNcz1Qz8RKDMyuEW1zt49?=
 =?Windows-1252?Q?KRb8nQE5lyOeFkUE9UtJFDylDbqEX1MWU/MAkYgnBrBsTkAmjskPxXCe?=
 =?Windows-1252?Q?VQTsywD4Oz9kEQ7sICD5lqhW8yEVMOfHwCM6hVkgmzcOqUJwHTcBmTh4?=
 =?Windows-1252?Q?mKkWhF7FaXDS/frmyv2Tcgqy6rlpBwI6Nc47brS7jY2tcApzolAFe8sO?=
 =?Windows-1252?Q?V+rfo0M5cdtNnY9hcuKHguE4kTggFrq7lIPP5aRTYGqRCszQQrAsl8ee?=
 =?Windows-1252?Q?70oTy+K8irgaR3r/+/KDc44w+FyT9DLglIR911eJgXfYKi5/MiHu8JHV?=
 =?Windows-1252?Q?ZiOsWN17noNQDKBWrNeIdd+Sfm9XWvMS0B5gbXo9OLUarBRzOnQhmFRk?=
 =?Windows-1252?Q?HHXejBuzwiZvrFk4ixVSUPwM5zRSr5TY4D5//phKDFI3I3ft6eZOtISf?=
 =?Windows-1252?Q?SEC5E2rcnKtlWWB7hnz0DKrctCUvnV+y/9Ul7afcWr9k2Bjp6auo7YsB?=
 =?Windows-1252?Q?Z3cVCtg5NnPeRSRrRKbiINaSju8B/npSZNjvwY2yV+E9WAg1Iy0PQZ8W?=
 =?Windows-1252?Q?+g/ZhPG1ElJy5jFAL7MkntSxTxXTR4ruDGlW69aV75euJQbjjdpRA0fn?=
 =?Windows-1252?Q?7BECZQZF+IT1uS8Uj4NyFetIqOKZYFUGBEileIC++J+mrjSCD9BVZVVt?=
 =?Windows-1252?Q?X4wVJrYPRvsr8vWL/y11TvRVYGrxmbGmcyVUz85y8Up800JD0qjl9urQ?=
 =?Windows-1252?Q?BOmY7E7ltiF4FxUymA546R05XuLwuwgtzqnuO9zF6oa7cFSK02O6rfi8?=
 =?Windows-1252?Q?HNGBC5WEdfzAlxXrM/PIE/sMHGbnaAF42YMxjxvvuFCPswpfNYNh1/pN?=
 =?Windows-1252?Q?4qF62QzRyUhn+cO5Npe32yt4RC9mrHaTIjBYGVR7gARIsbOf57mo9b4C?=
 =?Windows-1252?Q?AitIMm7b5Dcp8HQs2HDqRnEWHGBjWyc5w1GWgd9Qx1Hxt1TSvRn3pafP?=
 =?Windows-1252?Q?L0lF0hX4Jpo8cj8sJTTOKLIqEOVZw8oUtROPZDkZIvPvWNp+f/PwwfCJ?=
 =?Windows-1252?Q?eav7AuRVhrcbf+gG2nMrZVFS7uJUZ7fuxm4siTf+mFyMYMsjhSZNqEQV?=
 =?Windows-1252?Q?Pm/xatJXGYHC48lPUrZTAxomjQ+YFXdRGPjJY0aJKTLNCz2uuDkE2FPp?=
 =?Windows-1252?Q?yIKgLUSePT5aP9uv9UjY4a5Y+gvxhb/gqhLEtYwxW96BTEQsC9gxIhQq?=
 =?Windows-1252?Q?apQD7zWfvU8SkN2kC3XED/VgPVsuF/40lUPg1C3SV306e/2mcOGct/b6?=
 =?Windows-1252?Q?zily1POOgNpJtTDbHCp15cRiFXHgkqwfDP+dFbmqVhuTU35tKR2TuT1H?=
 =?Windows-1252?Q?qFp+efqGgYPdvvXP5Obix4mL2T6/VfB2AKVDDQmIZlA6eXhdspY85w?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 135e2b7f-0409-43a4-c54e-08db261125f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 11:25:29.6129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cHG+kLvuaxtoIYVKni3ax96Y7Zhn+Qt1lWPCr2GlJU0CQ6Km2LEmx6i1ff9rL8AXQKSq5a9RuvWPaDAHM0WcZ6LeJaDfE5Y+T7mK5jScCqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB9763
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 16 March 2023 08:50
>=20
> This is the start of the stable review cycle for the 4.14.310 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

It sounds like there may be an -rc3 on the way, but for what it's worth...

CIP configurations built and booted with Linux 4.14.310-rc2 (12379b7d143a):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
08352628
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.14.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
