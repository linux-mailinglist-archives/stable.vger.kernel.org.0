Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCA16C1DC8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjCTRYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbjCTRYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:24:19 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2071a.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::71a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E183736FEC;
        Mon, 20 Mar 2023 10:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gscJL2ycjE2EMfTga6fRo0zNGGa3n4OJ1PbFcHwU7ahCfR+lKHoIjpaNsFqxk9LirPqTd9cRO2Jw49cgO2SCEhEm1TRwvLzkWCeeO1KxD3MP3LbkaeWz0Si6hErR2OFqy17Rh5fZAPsIFU4xzfBifongHtKaRqwztAIzK8NpQi1AwCKiAjkGi004PBtEGxxsXfT4XhNlxahLBoY6xm7dfJckHq+U9aRQmzuV8wGDLRqaYwLXqYANJ6ShtrtGBTwyb7KF3RVJbEHCh4f17MVJp9nECMlHVtasBM2KeZvhfR2j/7j7YLhzFPVnEelShQGQscHuswCr1+CEncF4/ifieg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sAsA/tylnsCKi9iSEoX94Eo/WDdHund1fFlBktqygSI=;
 b=AgMmNTZFN6g70+3IdhwU0ubItdSrCq3bhb7ABRZClve0nxnedfMWpK+3t/HEs6AS3UDypWP5oTxD7PmiufULnR5kE7wRHEE89GT2EFbiMXAqoS7Sb4po2FgtblRzwV/UXHuuG6qWFGVRwAMLNzVRE8kkXAg+EnNPVd3aNL2h83lSlZhWTjTXFElKE1jFBWGq3e1IIg7IAU6epw6COMJL9JlRNgxqxJ7ITT4ByCdlOgsg5ZGiNk6EBYjcAzELduCo9GAT6l9H0zIAlQ0mX8Dv3VEGaGIZQucCakx7jJnZ+QY3uiNTUoaZ9hViaHkvLggNxBJ72DrUH8ZbjHdofyg40g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAsA/tylnsCKi9iSEoX94Eo/WDdHund1fFlBktqygSI=;
 b=dhlb9E1cmmLTPr2Z9OMn182/qHZLE6XCaESCldp45wFnc3zq17umCO3gRKph+Pk8mkYSAukWNzmMme0UrrNrT9BgXNvekMwlyq5BuX6LInwhcG+kpXa98eKElxbewlbCuE9KnmX7LprcyaADCre/D5cDjKKi50PCY91uO4B20Qs=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB10457.jpnprd01.prod.outlook.com (2603:1096:400:2f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:19:13 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:19:17 +0000
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
Subject: RE: [PATCH 5.4 00/60] 5.4.238-rc1 review
Thread-Topic: [PATCH 5.4 00/60] 5.4.238-rc1 review
Thread-Index: AQHZWzyJ3Su0rMZRZ0y5oU0n4Ouo6K8D5UTg
Date:   Mon, 20 Mar 2023 17:19:17 +0000
Message-ID: <TYCPR01MB105888FD7CFD49C0CA13AAC99B7809@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230320145430.861072439@linuxfoundation.org>
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB10457:EE_
x-ms-office365-filtering-correlation-id: 72631184-2a2e-449d-8fc4-08db29673c77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u5sdO8Rg6jTm0q++Y4bujY7E1pp0/QNWlOj8tZtav6JngQQi5nQbyXMG3n/WTlPIfBOCFHPpekiv/YX+DRHKzws2PeVFu63+nk4ymVrD2MMPiO47KIkf7KHaOVstm6+Bvyv/WBT9W8BmnM2AAeQWw6pb9l+36gHL0hL8yMZG35DCEKq43ZvDBZh6BTYb0Pb5RdvCcqwprAFwrxM+LJSZJHLh4XFfv/SeghDRjd+jKXRD1cqqQQWz2ILFe1n2KN+jYgnoWIGHhzR+3KohHx2IwkijUd2xAjX+QuOT52dZjCM6yLihbc2NPStSMG5LtlnP7aB6hTTlbrU7Lhx6yfbo2DgIC9kRcU0NH1n0nB5rsoI3N33rDFiAcDDG2TnYxDHALgtGi8v7S2WdSifSMXq/kCBBettoVZT1zZSfhzt1GC4v9WzwPi/9X9f+9rruHQohxolzk3gy/fE8gzyoFXLudGK054TNnamULRGPl4Sax8D2CaRDs63344fL3gwa0Rk4rWEUZAKp2LKMs94ruJSY4QSHmJJJa9F3Luuv7RqTwENvA6MmYRNtVxS+jV5k/fof9fbBYysFVkUl4du+nHGPjxFfQbwkVR1DDX32Byk3NhQhOIwro3zc9nLYCWl5tM8Qe2RVOOKWWbN9xpsx56OvTAsvTXGxtrYPRTLGLJYaDJvOK6URir6+KOtaUuBQ0H/SijOY9sYbuFoMMLai4to275NebNF14InnV1YIZgVNZPg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199018)(966005)(7696005)(478600001)(71200400001)(316002)(8676002)(66946007)(66556008)(66476007)(66446008)(76116006)(186003)(9686003)(26005)(6506007)(54906003)(64756008)(110136005)(4326008)(7416002)(52536014)(4744005)(41300700001)(5660300002)(8936002)(122000001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?+JFVdiHXMDytl7jA+LzsQ8WOsYrqw1hhY8pS8eQPKxg9pCi9FVZT8Dar?=
 =?Windows-1252?Q?v/SC3F0r1cOTLmV0NNQK8jKLUg65QOghoJctJ/uMfLsJ8BHYsVu5AUZx?=
 =?Windows-1252?Q?VzLpwtFnTr1Udzv9HLkqPGnGUyAzlRCBkkf4MsfcUdNc72P3xVGVRPFX?=
 =?Windows-1252?Q?Hcgbp6QpkDV9q/Tl+2peNbbADDEz9I/JOIThQP3sBlqM4LF7/PUgF50A?=
 =?Windows-1252?Q?FF3YQxIEf04iSuoNbGHDduoS3FFCr0LEkJiQ66hS7bFE0/+1nRSQe3w3?=
 =?Windows-1252?Q?c5JcZ24a6I6uFgVTQJsn7ZyWhPVK4kFJ06k+f6NALOP2+RdSJY/2+J7d?=
 =?Windows-1252?Q?wvwCWJUqbHv+kPr/qyC3uFaE8jUcvnYISkn3NZ3wm123arGs4HOfr2ji?=
 =?Windows-1252?Q?LCvzp3WM4uMVcVYqqbntYql10vmUF/u5YWnZPNo6lRVnuFCMi74gto2Y?=
 =?Windows-1252?Q?EhNMvj8d7s7/KYQCCBwkLY6L7qPPh/beoL/M2m0m3ZXgTL3pcZHnjpPU?=
 =?Windows-1252?Q?gHQvAJ9bG5b2O4MCvxFUFQ1soY0aX2IpPDoLHAIPztdmQhlYEgIyhVd/?=
 =?Windows-1252?Q?0qRswSt7KrHoF0tnUCSBg0sYaV6qXzIs85WgtlAibudi7Wzobz1ljtZt?=
 =?Windows-1252?Q?ZLGT3ukQsseVb7Qi9EtgnECW4i6UnVMUw37Uvo4HFdnzlwjg1YT9zS7P?=
 =?Windows-1252?Q?CUT8donLJrmqusoweOgEw/+hMnX6UO/h33bM8ijHaEfjMe3QJ1OmZ52X?=
 =?Windows-1252?Q?OUknJPJC9UWSa0hnu8nBRMPoaGfaS6NAmYO6Y7xrcFVmaXamqHazlpzF?=
 =?Windows-1252?Q?jbGxtYRQNw7sn4QG/0+9VXRxsxeWI3vkRtFkY/MwZLET7M4lKjiSknox?=
 =?Windows-1252?Q?Rt9W33ZCFGQTPadEtN4Uwhit/D5qPzbAd026XIVS+hQkekAbiyzcl4YG?=
 =?Windows-1252?Q?UC3tTJE/rlfrOt/XGooc+1pfiHPmb6N2WgqLDV7VyaCLepMQizGAsxpq?=
 =?Windows-1252?Q?QvkcU2ySu0tZSY5cRSOsKRcegxftrcvdgKsBBgm/SA0VIgPJyeOUdxkP?=
 =?Windows-1252?Q?mEb6hfk3ZQxiJBWSvZzIzqM04e0WxKf3pisuzRcvMzvkc7bVfPDDN0Og?=
 =?Windows-1252?Q?n1i2XtQLJ+qn5qE1fj9cZqh+4K6ku5Ie2oYPfB+99h6O8aKTuFmnGONO?=
 =?Windows-1252?Q?EDOGW0HzDxwxXa6MQDGqkBphJtFQyQsN+okANKM0OjC8G5lTPtFBsHlO?=
 =?Windows-1252?Q?Ox5ecvgU46ULkiygrwBlzRhd88pfY8n9+0sHgPFk+UWyV0Jp9viBiH6L?=
 =?Windows-1252?Q?a78FitUb1QveNbidiQoDfUteQOxnAzWYj2+de+h6Y0IYczJfPlCPoZgG?=
 =?Windows-1252?Q?3DleS9RAcxOSwJwb6cdCT/EFZV9jRNG1QxgOEHzI2vblJ6w6gjvSAMuE?=
 =?Windows-1252?Q?sqghZVz+i0sPuYs0gwhC+J/OUA4BEFUYcNoXanjc4JVFt9rr53MWBJnh?=
 =?Windows-1252?Q?K15NOYYNfWglQS2k/Bw8Ki6xV/iIx9T0e4nmsQqwgZwWhJO1mqNH1/ku?=
 =?Windows-1252?Q?wcG/p/FUPoRIxbkhB20cRJ4G0yB6uNEo/Vmi/VK7kJUVYGgrvvrKlXnC?=
 =?Windows-1252?Q?VOafnsfY9yO0kSTSFngeIBpvMfW33IZc7hlSk8Ou8MUJ7sgF8wSu6HJp?=
 =?Windows-1252?Q?McDFWx7gqiWx96HXyNQi7QXoDnyTx1AFQ6vQ2CrGdCLZb+q/f2II9Q?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72631184-2a2e-449d-8fc4-08db29673c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 17:19:17.5584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sF7xNWxIX/3DMnyACsZgzELd5/mNxjGSsSZ1BEwlAnZ4F5usXuMSts6lakkZHxLCrknWcsHPU6KGLeKmFkROjglzLwYfXIJW90BZu7DzHR8=
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
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.4.238-rc1 (1f8869b1deb8):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
12172171/
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.4.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
