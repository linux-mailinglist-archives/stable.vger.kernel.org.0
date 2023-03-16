Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACA06BCECC
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCPL6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjCPL6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:58:00 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2126.outbound.protection.outlook.com [40.107.113.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E8649FE;
        Thu, 16 Mar 2023 04:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwapyZ6qLMjU0kTxhZJFNb3wXurQyQJchjLU5KjeDLzEdm7akLm7WA0OfpmGiUFMWKUk+lta+HqDGjwM33eB3Ab/UAQn0RLAllc4NWa1r5ntUMmLgU6Rudy/TMKBc7arVCrri4eLgyMbr/j7NQAPir4cbLVeu/TbcMPWCnE4gKDC7KVNSX/cB5qzRHVLrDKmcgTzdohUaSaw9PEVr2X/LJz2biO1lqLbqpI8gd0XZ4b4v5rFs5WJ7sQC+jXcmrvPu1YiuyQ61t3AlV20fAYBZfZJHcBh2X+FGFTiVlxoKMocXI4T5vpVTTCCxk9xzi2Lzms5JLPeBdalWzk0ygSDvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qih8xd2oS+vybo2LdHCJXggrBLLrRo7A7u0SuEUXgw0=;
 b=XVrhYSfDjRgi/mPaDHTneOHmWjcq617/qYVNmjdC+Yg8Cc+9YeJxwIDuKWohpEnotMV3i5V3tr03FXfPCs2uU8Moi1oLTJuyOUJGf7yCwDAItGwn8XK6Jm1vpI4Cf2brQIj+yuk+QaRfxPT3lGQz/xosN6wpFhgJoT6KzfbU8v/xuQG8HRw+G0X74g8gxmZrmp3g++RkdRUWtbYP9mGwI1DiHkbZ9BuhgVSSOExnCRsWDGffVAXmC+ZSjZXm6IyvS8wsEgmGij1kTVxlJhsHc2PkoTIXOHva5RFXLfQE9NdjGzA0sQ7O9tt5rmx4oaIJ46pRhgCE+h2kaHlF8DYVyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qih8xd2oS+vybo2LdHCJXggrBLLrRo7A7u0SuEUXgw0=;
 b=DFatHnk0PJUyfSUea8qyu7Tq30EcNY6k7wEsYM2unf89pOCwEfcHwm8mBeMKAxeL6SU/FV8YNI76mCqWsNfi26D7ysl3KHqyQ5a6xfnMfyDdHcnwxoAN6lQ6dNVSjqk7FM8W+qgulPB4n3Krfngm+syF5PKaiFTDWFphaCtc10I=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB10459.jpnprd01.prod.outlook.com (2603:1096:400:2fb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Thu, 16 Mar
 2023 11:57:55 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.030; Thu, 16 Mar 2023
 11:57:55 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
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
Thread-Index: AQHZV+RUy87Uo7cV7EWFQvyxi/S8sa79QRpwgAAFmYCAAAU4kA==
Date:   Thu, 16 Mar 2023 11:57:55 +0000
Message-ID: <TYCPR01MB1058859F0D4457BD3BCEEB868B7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230316083335.429724157@linuxfoundation.org>
 <TYCPR01MB10588DFCA0CABA9028F2FD723B7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
 <ZBL+ueZuSk51GhFE@kroah.com>
In-Reply-To: <ZBL+ueZuSk51GhFE@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB10459:EE_
x-ms-office365-filtering-correlation-id: 24793e1d-15d6-4d3a-dfc7-08db2615ad8e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B2sC0va+RGhTpPnNEMaWD5ZXaOI0Jt5+qdZiEfIeQOsImAXp+kDVv/gQMx230xjrNN2ycwpLGmZZKv5373jBuJPbPT4/d/bWi3FgLPt6O+r402EC/nveRhTZA6AJprZP1DQe2R0+tbW720XRq+yFFBh2p2Wafi8se1RtY7tmUDKFeWT7q245B7WUo6RcWG4qH7GR6QldEkPKghgqduCz9YcslQ06jMV7Mqx/2aArZyCYFtjkvtblth/iQ1B5i1HlVAH7rqBYmuNUqOQKaKy6JXji/esy1sBFdpGRDHLroWcs7lzOGaH7gtoOT9+GWaTDam4bZ8BQZvi6cXaSPnsFKPEvGcPFDRLFqzDaVq54vxHXiBp8VZ/eaYsVTsIbOcrS+lHZBNRTWApzNUGLcdwk/2D+DsCPGrqeFZEFS8zcPREwjgpJWRJiiHPxg9Er72PQt9S7WWdP/Tw3R9h+ARamv3znDLr6ldDxf/H0tfJbOU/qRJPvfY6hOeRrOrJ7FN7kf+EkShs3PZ28g5zpe32DAcUdbfQz8bylH+k7VwQiNT01OaqadMhXIw7E242xOXhUGemrMfIzwrbUUrMClTzlobJLCVYSCk7VifcEXSeSCNDnOKAqr/fY8/6gUKtcjEGBT/v1CKxAWgGqm/QkBYG/XQXIAN8HqIN/hl1VdLZ1xGk0EimiNRaJTwJ59BM1IjH5evLCZSqxv/3mjFtrNzdKmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199018)(52536014)(41300700001)(5660300002)(4744005)(7416002)(8936002)(2906002)(122000001)(86362001)(38070700005)(33656002)(38100700002)(7696005)(478600001)(71200400001)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(6916009)(55016003)(83380400001)(54906003)(4326008)(316002)(9686003)(186003)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?2dQ0bmqyc+DMHmKNEW63WWlBK0KHPf/D2u+q+365s2ah/WRC9zVpHRWl?=
 =?Windows-1252?Q?P3aCweYSG+yf8Np6bX2PkQKjSdsNGtM3qgLs/AQTz9gGZ9hGOV24lvy0?=
 =?Windows-1252?Q?L5mK/5oV7lr0vdn0DTj6oUWheqaEZ+mSLlckV7I8rbFsdQfnEH+iHVOK?=
 =?Windows-1252?Q?2RTP9rgxN3y924YoKfksKi6AV3fp4TUkX+DIfxIaBKmzW8cdJgJ+eFk1?=
 =?Windows-1252?Q?57AqZUGguV+PioNtwXm3EeqweM0qCyn8QoCpkcGtMNbhCtk9Bel3+k/P?=
 =?Windows-1252?Q?A6nRyoKlGDmPhHp9j+DF/gV86S65TPw50h4eSHUcBurH0AFJc2dIVFgj?=
 =?Windows-1252?Q?hz56WHhTAzZrFUq7DfDdnWfVAcb7x6wEkz3+TBebc5f3Tg7GrOglyn+x?=
 =?Windows-1252?Q?/b1LMmxcfgV8tFuTXNEeEaNknybIMTNginRg28aYG1kIdnZunQJ/Rcbu?=
 =?Windows-1252?Q?9OCZlu0Ksx7dWiTO7jEjxUFks7mrn7aRsQ97S6aJh7Lz7o2myPuO7vYl?=
 =?Windows-1252?Q?ixfv7WvnemjmYeSMC/h8KLjf+uWt8K2U8gKpHn9JHvmdyztUTwPY7Fsv?=
 =?Windows-1252?Q?fvkUhevBnPGiXQ3Hvfc0nJLUyuZA3mHhNeHrUJTq5M7dJSKT17zJqSZ9?=
 =?Windows-1252?Q?xiiPoO1udh8Jhx4B8ZNNj2vNwxtK1zXFTGTsqoH3cibtFm0PqCcC1MFo?=
 =?Windows-1252?Q?YQYWkpQR5BNZj9140DxoHkPzZwcSPw0AEn7hLZsHmXRaGmrzFkrqTdso?=
 =?Windows-1252?Q?juWu0zsjU7fO4Eon3PdIb3XoG9pmzs6tNtZ0mydSmezzmdigBgAamHs6?=
 =?Windows-1252?Q?7MakVs8d6RvCpG5w65o7XqIMy8g4iV3DZfkFOiusA5hC1h2IGNS6Gjbe?=
 =?Windows-1252?Q?D2sWGGPWT498ofeCcanctl2Ns0m2XjnBWtqXdrwoji4Zeqbu6VEByssN?=
 =?Windows-1252?Q?8AucVyQ7fRTbei+GiL9/aVBGTq+jO+6Dor93W57TaA/fWgo1A4OSX3LF?=
 =?Windows-1252?Q?E0GLz3aj1uf4FkyocTK/MaGZEZ7eQZTiFHHyyBu8aRiGQCc9EH7XHsE9?=
 =?Windows-1252?Q?A6HHNgNelwbi7O54GKk9spk/j6wE3ioFpaHcF5VgeSvRNya7aR4TGoV/?=
 =?Windows-1252?Q?38JFJXrB2tiWC1KaNTFenCCNf9l/5L7mjGHIYlYzk5K0E/EE6MAb9HSg?=
 =?Windows-1252?Q?Mm74aiBrkVJohuvXnK0limo9SYPNJ75cmej1KYrWFPFUsRiQatIgOsTx?=
 =?Windows-1252?Q?AeqvJp6HxgawQkceWMn6qpjcYjhDVdAr3ortD0Czkeu1Ofe2hV2rtgp0?=
 =?Windows-1252?Q?r3dqd/nBgxH1R8nleJR5bTLLmxIR54Mx3hmORvaDRQWvPNhO59Of3ftv?=
 =?Windows-1252?Q?EPeCrX7VpH10FZUZGBUuZxJEY9nnIvW0ctSn6eH4U/KFwklEPOiw1/H/?=
 =?Windows-1252?Q?5NIFDzJV7mUezjzM9tKSrkhaEx2BBkb6abigg+lLoNN0d1ucUbXt7QPw?=
 =?Windows-1252?Q?ByQaYwM0Q0+D2nzyxuUIQ+PkP4PTumar8UKiW8s/Q/WTlgXZacUvqDDS?=
 =?Windows-1252?Q?nadcrh0mEdKd0OBShC08I1TTFNG57lfmy+U/OFik+b/vi+jmaBC8W9KO?=
 =?Windows-1252?Q?TfA/aECT/CDQzHIJeWSA3KXOJ/vGRK7smO4l6xJH14r0A2CIlPTRxpUg?=
 =?Windows-1252?Q?k6WLBKZJ0UxI7a+CiJHsKgNy/REPs+ndNahJDpwknVo/g2O7/XfGEQ?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24793e1d-15d6-4d3a-dfc7-08db2615ad8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 11:57:55.0578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CtNFOTGVkUeUotUiREde+s/8y1f4e5CrFCZQz4W8nsYHPnk4kQRJ/T2Ynec6hFX9aoVjFwTFdZ3DGxIbqgEZgbCTPox5AWmnc2N9DV05FEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10459
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
> Sent: 16 March 2023 11:34
>=20
> On Thu, Mar 16, 2023 at 11:25:29AM +0000, Chris Paterson wrote:
> > Hello Greg,
> >
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: 16 March 2023 08:50
> > >
> > > This is the start of the stable review cycle for the 4.14.310 release=
.
> > > There are 20 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> > > Anything received after that time might be too late.
> >
> > It sounds like there may be an -rc3 on the way, but for what it's worth=
...
>=20
> There is?  Only for 4.19.y.

Ah, I was referring to you saying you'd drop "clk: qcom: mmcc-apq8084: remo=
ve spdm clocks".
I was assuming that meant another RC.
/me must stop assuming things...

Chris
