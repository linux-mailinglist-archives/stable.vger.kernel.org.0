Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C796B250D
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 14:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCINRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 08:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCINRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 08:17:17 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on20731.outbound.protection.outlook.com [IPv6:2a01:111:f403:7010::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC4EE3CC1;
        Thu,  9 Mar 2023 05:17:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QETyD/hdrkruAG8hjpDPNoA4e7OryefVQVOZ6Ixlm18CiwTBgVhnYsk8jvAkvbAm4IsGo46J21FJwOdF8kUs9t65CIsj8wAVeuXnLOP0koWSZLR07WzrZ7y4FsjqAs6js7UyzFQj+2LMkJzTSTBmAWj3UmNwgqWHHBVaDjmeo6oGq0wU2xiXniPplJ+iINEJbRA/LsSq2XRSx3p08PFa1WIyMpj55nYh1zbyexunBb+lhOAapfWl/PAKoluChb9ZmeNKY9Z4/i91ljXAa+HWqFobyxqw3IEhJai7LumQGP1gFGTzGbRqzzp98zxbAGSzYuGeeSvp4nS2DZiBmdo9Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTNRQ0lwWHLsFGCUX9Q0H6Sm8Twr0DcULf3YKPUdPbQ=;
 b=k345v7/pZayMjEHeO05j8T9i+qqD/D/2msHqTHWFsa5fJr5w3NIqAq5KzW0YYXkjsvt2f/7vpCPh9MVH+oGSyobbTDLjYuicuz6OAM1bHUwsvg6Onw7+vs1G9ySzfN749IlyTfaUmp671gZiruG6tgtRP/CCDnxNqGCLTQxlMI1qmdjLQhwY+XQlhz/rMA/+lcSwJcEUt6Kusb1xqSDXQRPKX3y8J35+2DHXSqEBawCHtUBf0Xu4q5DrXv4wF3QToOXNQvgt0vA7kwIOTfU0pbc6zCBjFqsjCjol7cY5BWbfrkobOc7LEv9/UIka9RCI57mPlrtWxjLJKIEXk41xkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTNRQ0lwWHLsFGCUX9Q0H6Sm8Twr0DcULf3YKPUdPbQ=;
 b=hl78VMLfttT9L77562F9a+pMk/wcTBSLdQCFkRT4SA+WiqH/+vYKEkzSayJs2VvcmHYRN/hdMKyVLLUYXE/SpwQz0dxu6NIrumOzujK0EH5RJvDB0zzvM6lUeByAzHrmDFHpR9wRiJuScUHxPdUoQJcgVPpRMHWcO7LpbCOrQQ4=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by OS0PR01MB5668.jpnprd01.prod.outlook.com (2603:1096:604:b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 13:17:08 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 13:17:08 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: RE: CIP doing -stable kernel testing -- was Re: [PATCH 6.1 000/887]
 6.1.16-rc2 review
Thread-Topic: CIP doing -stable kernel testing -- was Re: [PATCH 6.1 000/887]
 6.1.16-rc2 review
Thread-Index: AQHZUaClVZXqoKAMQ0a1aIet0CU8O67yLIbAgAAlUQCAAB1SAA==
Date:   Thu, 9 Mar 2023 13:17:07 +0000
Message-ID: <TYCPR01MB10588E326890AF5042E7A1A8DB7B59@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230308091853.132772149@linuxfoundation.org>
 <TYCPR01MB105885F25AAE8A2FDBD2E577FB7B59@TYCPR01MB10588.jpnprd01.prod.outlook.com>
 <ZAnDVIl09wDaFNXy@duo.ucw.cz>
In-Reply-To: <ZAnDVIl09wDaFNXy@duo.ucw.cz>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|OS0PR01MB5668:EE_
x-ms-office365-filtering-correlation-id: 133c2710-3e35-41d3-06be-08db20a095a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +5pQp+e+tM0UJgi0o2GmB2NDOswMdE1odHPzICoWxbT0ubvjk0LIaLEweHeYi6HptkXMY6OGhYXRoTFHtR/AZEYLBBw6/3ujbIpgwGZsZfugG+kPqrOtlqz+L8H18/QG8hsisEM+18k9SylkLwHqLS4CwzlkGaingJ5rHkMYjEyc0mFm7mA5EA1iwmJNf9r9UGyzqsd3tskfiBpRBEcty+optUBBsrUMCDzrLceiBmfTISzLuQ/JFLx4SNvrquTMMWkJ+3glC1pIuAEVuLO/IIGe9gkEXL14p4zSc5sjXfdHwCfsWiBvZ1840qI308YRkuy+1s6iTeeCPe+2UxdeMKEF8Z1HTN0YvUAA+ax2zWMCRrZbu22jXcdcwlKCShd5D5HDZPiHnmOxFyBFYIlUUTkJK4PTstF24BGB/BhWOZZtpqtzg7zFNreUW9xbehOLVJEQ3lrAImNJ9Q2LFlF3iVeRKCN5vVRriYzTf/48IGrC3YAV4+7YgRfQcu8wrg/JTKf4/qPQnokYdsSvEZ7VO7YbQKhsJF+fLlFfK5ji2Of3hw5kD9YBtK//y41G4lXmhrQ+QsM2PaO+EiV7J//wojEe8lyTjxeBv3N4sXC0sEev37j8tDfZkz5tyKSGy69PVes9a9TI6XZCVYyRSQfsqPum6L3gAlLqZWkjI52IgLALevUlFH1K22CG8a6GuEfA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199018)(33656002)(316002)(54906003)(478600001)(966005)(7696005)(52536014)(71200400001)(5660300002)(7416002)(8936002)(2906002)(4326008)(6916009)(76116006)(66946007)(66556008)(66446008)(8676002)(64756008)(66476007)(41300700001)(122000001)(26005)(38070700005)(55016003)(86362001)(38100700002)(186003)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?wrq8brPvtxI9GOrgOaAWO2gZp2v91bJ43BwXrqON7mf0VnJ63tPQBm5F?=
 =?Windows-1252?Q?A3JiBZzcKwLwC7SShzfu/W+6pls1bEQAmYH7OuJhhgpwUV0mlUgK7hyh?=
 =?Windows-1252?Q?ebSHdz03JQhiWnwRneMmCklc9eWvL0+vBTCH7qv6XHEdhnhYwUIl5Gak?=
 =?Windows-1252?Q?N2Y0MV2NyO4nR3K6vb90Q9pUhM264U9NlOHmpBANgkki+J0k1gfn87Pk?=
 =?Windows-1252?Q?4QV7sP+3rfV/8ilIn4Af/flpMIt93YAyj4i2oDBpnCXJmDxj/pXLjdll?=
 =?Windows-1252?Q?x98LVris3WDm3yTkldfjNDjEqFz6yJxVcJYL9LKKlzQgxp1h7x+U/zQL?=
 =?Windows-1252?Q?qOfYwYMNLLIDwDy2zh67LxgN+LaODh3gVNNojgEludIgbJdf0VsOaKva?=
 =?Windows-1252?Q?9J5yeViWfQyDU5TUf0WWfmQR08Be0kC8SyUF8qf4HX/bfWp9MI/aXGko?=
 =?Windows-1252?Q?TBA4dF0Mrw2XWkzO0bx1bkw7jKp4e6sIfUDsi++9IhRB8NOdKMt+Bi6X?=
 =?Windows-1252?Q?htY/+ulDJKr7TsSaFRjL2uEE6lReHOUegw9xKD+RTVnD4CzG03/Mw/xB?=
 =?Windows-1252?Q?Uf6ub7XLn0X+u8fm5paZ3ZoxJKRYwWwqEGbedvquq2aNuq6CdyMoMpN3?=
 =?Windows-1252?Q?RvYX6lGMZz+19RNXsrQ10xRwEZPbrcMC1JhVOiLZ/6t9oLHO1rVSX27G?=
 =?Windows-1252?Q?Du+Su3/i0T6NB5R1NTsMLeoSfGDlIYZ6VIZU8YLZhPUigdDTNLCnr4ZD?=
 =?Windows-1252?Q?wQko+hinKepvAf93KN3B6aksMFd6lv9RU7x32f/F8gY43ha2dTfde/em?=
 =?Windows-1252?Q?QvOiWUYJOuu1Q6hRHlXfMKYed1LTG+DSVAO/tLc8hqQgETDU3TUuYIn8?=
 =?Windows-1252?Q?QVsPE5cgZNv0W/UsZZ6fOY4ztH4TDgCoG4sjwN9jclA7wspHcARh8kkF?=
 =?Windows-1252?Q?eP45jfkQtpErsTqrPLtwOoWTJaiUcDQEExrt0n+avGaGPQYOMm9jTwMd?=
 =?Windows-1252?Q?xRBIyIuAOQocdSZhvEnZsFZ3sfkthkSfFNwwV5UdcABwmgo5CajxjpiB?=
 =?Windows-1252?Q?AZgACVUwtZMPlaDsgshTeE3pWDR7FP9uUEdNFHHf3rJ5Jla5u/paCYBl?=
 =?Windows-1252?Q?ox8OMrkeIqdRthApKbu3N7lhzSmHpU44FEA/gu2WYRC2fixFDvQ2vi95?=
 =?Windows-1252?Q?x8WYMGZOpMvvzi2B29nePoiQHk76B3+0bkM59uzrxdjrZkgRRVmi+Rs2?=
 =?Windows-1252?Q?Ev7VMwNPP15jbKkWWJtZa0qUX0NaDyeZt/p/GsokMWrqR16ePCAG8dLY?=
 =?Windows-1252?Q?4s3f3MBo+3BDccsnTMt8NkuVzlJWckde+8wO5W/8THrbmakVo9cZgkoW?=
 =?Windows-1252?Q?bH7MSRZaXBegveEGkVJOc15qFAoKZNSTDWmkA19ILqePXCHWS9kIpayc?=
 =?Windows-1252?Q?zIQ7+SzpLYaiHYrZuWU8Nac8PmhqZuoUO/ef54JHNA3YGlScqd0eV/v7?=
 =?Windows-1252?Q?W4hn4oTrUNRN+ZzZYFm1zjNGNwaVl2HMW9xRv9ES+pqP5cPxEguqPRrD?=
 =?Windows-1252?Q?8bCxajrd0nXF3Mj1ybT0vQ+bLE/1X0IexzMfy7Kvf/La4jl3akWV16ll?=
 =?Windows-1252?Q?Hj0ZkBnNe7+47ARIqakRthGmgQe76BDVgn8s6Rg+wUplHPiqUyUsdsvp?=
 =?Windows-1252?Q?VPQ0XiPE4hS2SLqp1StNHgdYocspKOOuo4fpubbvQeEKgHrNwrzhbQ?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 133c2710-3e35-41d3-06be-08db20a095a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 13:17:07.9959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: anMtD18o7xisj7G1rX68FhTdJjxu6SeklidCrkX//q9fJIqkEjSnXGU4vjdAbqghAkK1sdLotCd9iKreX0/f/I78gOpfV2IW7V5NJrKGVSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5668
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Pavel Machek <pavel@denx.de>
> Sent: 09 March 2023 11:30
>=20
> Hi!
>=20
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: 08 March 2023 09:30
> > >
> > > This is the start of the stable review cycle for the 6.1.16 release.
> > > There are 887 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >
> > CIP testing did not find any problems with Linux 6.1.16-rc2 (bb4e875c8c=
41):
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-
> /pipelines/800470660
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-
> /commits/linux-6.1.y
>=20
> Hey, that was supposed to be my line! :-).

:D

>=20
> Well, in fact Chris is doing testing for CIP, and I was just
> announcing the results. We decided to test all the -stable releases,
> and due to increased ammount of emails, likely Chris will be
> announcing successful tests from now on.

And unsuccessful ones! :)

Chris

>=20
> -stable is rather important for our work (and we'll likely be
> maintaining 6.1 for 10 years). We do have some resources we can
> dedicate to testing and stable maintainance, so if there's something
> else we could do, let us know and we might be able to arrange that.
>=20
> Best regards,
> 								Pavel
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
