Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE436C1DCC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjCTRZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbjCTRYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:24:51 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2071a.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::71a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCF32698;
        Mon, 20 Mar 2023 10:20:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfjPMsDf2pVDnziCN28qbiP6szmbTOp0kCO9kooRILfAS1Yi9jk0cOUOTdqVJREHxtIQmmfmRhBMrITc9x6Hq4wh5GGmY70iGepn9RKt51CMdK1C5j6nc1rqunkcpTm1eNDycR6ZQ6cwPXTnIynruionll7zQNdt42/O1M9B5aOv+6uVvDQJlZ+Gtil74b214nsPHFkOLzueP09zawH39mx2DE/gVg7CNZxBSV05fUC7Bw5xTtoE/BKa1tG+zV8Pr0ueAdU6kB6RQsuCNHOguu0ITxzTwayaIlVtAZYSgKjRDVQ9tyHjn/y++V+ieN5tZouAD5Q1rt1FDiY6mZdnFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oUOUE7du8nObPzIMq1q+jzB5WJ5bPu9S4dQ2p+NK45o=;
 b=iY2hhxyBqLK4Qe7gmJq6qm5ccxlm4EzNfEikDq9Pz98y8ullr3ZPsLsXLBYszeCT+xTBMJxsK7q9xZVVGPB6jtFJjD3iUx/pCvbw0NOsXD4R2R699a2S2cFnIFpPQGjt9pvzKQ7nVBwdGuD2JEqZcVB1qjJu3snHtGUh255qCJLVc3DbJ6E8W87WsPcMH+tr/NVMPE4UgQOftB3hCpgcWtZ3hSBYk4bbnTKtqDXkAWvFWF5GW4MlogkXKyMD7mP48bFuGI0JmOg1gbDfPi9dKTkmvuvf1Ra6PwehhAKmFHn7Bvsv1rATfJbFelrpImL+WevY4LpZqc/ARvlOVVPepg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUOUE7du8nObPzIMq1q+jzB5WJ5bPu9S4dQ2p+NK45o=;
 b=gNS7AtuLIu/sLhcw7OWQV57LKKLX6FL6f9R5Q1x/9pAMG5/LcLhO/WaH74zvjeHB5H5lgmFAhuhTSdmnrRACFBcnFCmCdrZR/9LcPySenIWTE+Zn/kikbPyQiPzn8JpE03kwBbqXaCLY2kWofip5Fz5nmDkwCMujesnaF1ec4p8=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB10457.jpnprd01.prod.outlook.com (2603:1096:400:2f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:19:24 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:19:29 +0000
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
Subject: RE: [PATCH 4.19 00/36] 4.19.279-rc1 review
Thread-Topic: [PATCH 4.19 00/36] 4.19.279-rc1 review
Thread-Index: AQHZWzyI0L54ZYYWTUy76gCjwz3rMK8D5G7g
Date:   Mon, 20 Mar 2023 17:19:29 +0000
Message-ID: <TYCPR01MB105880C8BC0F8969F499275F2B7809@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230320145424.191578432@linuxfoundation.org>
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB10457:EE_
x-ms-office365-filtering-correlation-id: 7c612957-e9a1-4a24-1c1c-08db29674350
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F7KhIqZYIPKcuueRTctog75PnTFZvbOwkg47vdl5WJL45dnwF8lDLWzOzzV9lmXbFXhcWpZa+EpyPb0ftQjqvMroPdtSW+pGpGX9wP32toxngzZ9NZHZr6NZb0AUIsV4kAVktQVM8ZSgFk0YtERY+8UQTwbqdQj1IaZZL3fCsRvAiDgOdaJtku6Fl4ninedB1AejKk7f8jJO2PMift94vA2OmCYCKSFQUKoyjiUpCNc7TMGE0ChNIviZW1w/+Hsb3KECkZRHwsuyrQqWJ7ipXKGWPUSMNvlHzlFkI2QD3CDrFzWiqf2r0dlPjYTECgN1PSnADp7zaO5FoCMW3Y9NOKLUDJf09dBannH3vPwxjj26nwxMKN/4LDbARdORN+drstyXvGb6wAAtkUPSFI9LaTbNenCHjvyoFpgzROVFFaNbkCy5qCQ5hWvK0RcWEc5ECJ2OoD8E+WvRAHV/qqSNkOQa8Ct05RQtjaT45rOiSESiGwAhLVqrpJJMxCZITiTfbM8BVjwmgSlkaf4a60sUJ5QM2g66GY7GgDmT4C8PI5bJ4t3Oe0HQj/1lJoduN5ATVJMB9et8spcttk9b5pkOj8E01ANgBzu8GTsKpTI9ZQb/UeLtXzW9huBwwq8V4ot/zirgnsJPHjWr4pTQDbMqRRcSm258pe3llwvcv8fNpBZSzotYZ0OaI9k/VpRoctvLfLivNKiWZeYWyXHd0sUz+svHiZgpUyj4IreOdmGjNbQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199018)(966005)(7696005)(478600001)(71200400001)(316002)(8676002)(66946007)(66556008)(66476007)(66446008)(76116006)(186003)(9686003)(26005)(6506007)(54906003)(64756008)(110136005)(4326008)(7416002)(52536014)(4744005)(41300700001)(5660300002)(8936002)(122000001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?Mw1aHt2294CwjEAsfO2j5yQosPLrxwSLDX5jENrGMa61kInWw0c3P2np?=
 =?Windows-1252?Q?0HrlX3HPNIFfb3coKza9Y9HEtvCAuHbcxhCR2jKcw1DcSrRHSgP97JGJ?=
 =?Windows-1252?Q?r0EJ591DWJb+5D1cNJxkaD9LEjXmYv/AD9iYXXlilnwiKxbsFd4cxS7T?=
 =?Windows-1252?Q?BeV/1fFbqRIuAKX86wBwtE/N53WyQS/EvpnQOoZEq5Mi5+tedvdPQ2d/?=
 =?Windows-1252?Q?vdW1h1rJk2WHUrxuxpX4fe1gxr54aq8cPZCAgxymNF1TNC+x6F+Y0egr?=
 =?Windows-1252?Q?fRQY6verFhy+WNRe/wmb6oaOv4AfUfEflEGkL+w1ATO2/YN78d8i2RrY?=
 =?Windows-1252?Q?3dZifMZnaE5A2BdmXQWRKCNyWUO44kk9ZI54Gvkj4SUF6IrmZfNFDhXr?=
 =?Windows-1252?Q?TQxukbI+hfhS7wy0xtf2Vu5VsM5xsWlwy7nvuN/OtCbeRnz+OS4v1Nor?=
 =?Windows-1252?Q?oaudaFlZW7iXUYocGY/Af63hKT+4ZDrgPDk4sNnJ7UeGVycGUzGgDuDi?=
 =?Windows-1252?Q?U2Emzvh7qnw6R9bKw2uSpe8IFsBlCPnZezCgFgvHNp54nPexc2HNK1We?=
 =?Windows-1252?Q?c8TPevlVC+JaTHaFjjFVRiIUcjAdYhJoYNlAge0w6i7YhAsFa4y+YBFX?=
 =?Windows-1252?Q?D0X9nolBoTlha2HNaORYLTf1DAGZWaSBoEVchfHFJWel9kJmclXlkBDw?=
 =?Windows-1252?Q?F/mZYikQzQ3tk5KqVtEcuBUHOBWXx96Bx73ABYVW5S8rAgbs5BvyGHlJ?=
 =?Windows-1252?Q?mexLi1Suh5Aee10KR5Qc3rJSwhReHm5K/l76i8M4qSOWEQyF9l5Srx/V?=
 =?Windows-1252?Q?4b5WN/e2vEkSpcXrMBbOCL1dr8w8/CpXZLVig5fX+zRd8flhJIkQqfEF?=
 =?Windows-1252?Q?A7oshQMKPD0Kvee6fCxFFzj3W2csNkrFNTdCwwDRoyUao6ZsHMH3P7aC?=
 =?Windows-1252?Q?67vR3yAxKUWECEgHs6xzM8udiNIgDsMBicW4Zk0VQMGOxcLZegmzCe+H?=
 =?Windows-1252?Q?RQ5f4o24HadOgb5PTIa33bZfTPgSfMjGhqwqaICuu+ayaX30pD2s2W25?=
 =?Windows-1252?Q?JbU3tTuih/2AUoDA6mJ5TW9NAL9JrtmYd92j7CW1kqSeRgVMnFPnai0N?=
 =?Windows-1252?Q?mEUd5aYSxkkKJ5wdZRgDw6iZJjq23v2T6kf0iH9PMxYoEjykSekK6cPP?=
 =?Windows-1252?Q?3tbVbdkGFIM7bALh5etrnCqpynfGBIFKVnrYQ44rHFOtcxjRB8eD7nXy?=
 =?Windows-1252?Q?Z1WeaHBy3Ospe3cWw0kEDyoCRtWTZ6Ts5kIfRsaXqEPCAnwcYOZX9pSJ?=
 =?Windows-1252?Q?RUijupmNqmS0m4/jQJC1RHOceCANjw8yoOppJYe0K9KhMQlcTGuaNoGV?=
 =?Windows-1252?Q?MhpinMco+EWSj02t5Cr7U9v1/oO6Cmjum6Y0KJ5m4qDI7jKhx/poW7Fn?=
 =?Windows-1252?Q?4nNr7pUISPCWNUdEL8YGpigDFIKcMKMRelt7WpndP9PwtYtefqz9C0c6?=
 =?Windows-1252?Q?NrhdvJ4UvFXUkFiSOKDE64dLZESZQdyxrJ6lZ+6VMyvfyy4n2xgEpnD3?=
 =?Windows-1252?Q?0NIptvLUbiwCl0whi0g5QlzZYcuNYKLFhUPS9T22Z/igZuMac+GBiUX3?=
 =?Windows-1252?Q?ZgYK3uMH2DRbMpnHoAL/DFjBPk0JGLcaEdistD40gIMSKsCptrTbTC8J?=
 =?Windows-1252?Q?SFVqvAF75Y0mAjgQufhGVpbiR8QFs22n+rc/TtOb0PNEawjZk001Sg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c612957-e9a1-4a24-1c1c-08db29674350
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 17:19:29.0438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K4kaXJsZNy/Wa7ySEgEu8fb7/upE1XrEZbmT1uBWyePEdP4KUXHn42qqhPF6Cue/povG5dSjzIsCCyY4XNYyPooOIo+nvV3cAMw5Epg5em0=
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
> This is the start of the stable review cycle for the 4.19.279 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Mar 2023 14:54:13 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.19.279-rc1 (c1beffa09ae6):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
12172003/
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.19.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
