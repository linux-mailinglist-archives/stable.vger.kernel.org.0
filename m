Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749A56E66D5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjDROMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbjDROMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:12:48 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2120.outbound.protection.outlook.com [40.107.114.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2889146CA;
        Tue, 18 Apr 2023 07:12:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cx1cJA1vdc5sIJIJmHP/04H1ykORovxJhfH0D9TXkYX5Z+WS+s2NQ5T5+FDMFF/gM4pgH/tQUjz0lyCVID9KFTyh9i3l5m1QRxV/GLALuJHsWHDrssCCyiThGH3n21K2hXT9oWw5h4uOZRDy2w4IHtXLftV5EwQf05E2ORhOvCPODtQRYAvMve+xQi9mh9GObClHWI87rv6vwwEqYnIRtWT/cHU9KCbWtRtK4A4vZE39ZVRb8uBjRYa7qDTiRvkEika420/CmGWzKOl3HTrMRoUdEUH7adj9mig6uenYRLdlFqXwl8eZ5jcw9yu8LMkBmFo2t2HEAG58UQSUe63KOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qti0DpFvrpKSA1H9QUFLqSpnVHNA0EMOux94uiE0imA=;
 b=inGHbZ0ss7TziSn/d0M1BjS9nptbYdb8tOprbx4FHEcsttrGKXg+bDuAlQAig0HPHUGsDw1cwlRIqu1Q5ExV9qJY+nNgNWHWYYb4omYVhk1zby2K24cbZtPAVdvuyhdbdOPg63MYpfAUlCYICnZn/lCogUGgruQKwlTHzcsMuC/Tm8qfVk0HUFoi347oshmwIN9oXLShAwWEj9cvc+Z3OIK3N0jzmlxIqF6wfzMg16d0ope2uhRR68qFhVE/lmr+2BvxYyYjjzESQeoZTcnmJzX364gXGyAZH+C84sivm+CYdeo1AMpfnRnfe+FHQOGcqNmTFfyaXLX2p7t9JV4KLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qti0DpFvrpKSA1H9QUFLqSpnVHNA0EMOux94uiE0imA=;
 b=YmII51JXUlGSdXxdTSPsQnCNnG8FjgtLV5BBnFsC0Y8irE5s8Svire0NAhaNcD/FLk7qL0o5zQGVkg2da+LXJiB9dsPDsOZvUewJ5yFoPZkK+g4CSGFhGbAvNTuq5IPA/wUFGWJu11NDN1OMzl6wzviYdaLIlr6PMvHQkCcSMOw=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYCPR01MB11801.jpnprd01.prod.outlook.com (2603:1096:400:3b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 14:12:30 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 14:12:30 +0000
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
Subject: RE: [PATCH 5.4 00/92] 5.4.241-rc1 review
Thread-Topic: [PATCH 5.4 00/92] 5.4.241-rc1 review
Thread-Index: AQHZcfGP4Ovcf4+r2E+aQDkKcgJQ/q8xG3CA
Date:   Tue, 18 Apr 2023 14:12:30 +0000
Message-ID: <TY2PR01MB3788064A2C77CF821439D8A5B79D9@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230418120304.658273364@linuxfoundation.org>
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYCPR01MB11801:EE_
x-ms-office365-filtering-correlation-id: c9711c7b-4c48-4f7e-6417-08db4016f269
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fQF5FgR1mb/CpEkqRtaVklHgVFenlo0xPOVtVJgpvlXqJ95MVPljg7S5+uuznjk8Nzufj150Brq0TmoisqS6j443cQZa39Mq4mZcV9u1HmQHfiYNQ0cZKM/HauEEiLtJBYwjZqbqMl+G39nGmWmOrpMkVhlSj7StGl9AUCPDBIMrm1e9okGHf5LQv6sFM9XbqXLnfYwu5nGH8KH+sGm7NM93F5ynVn+JCV/rXhPFjANw6YpzWOvJlytxF3ud5YtNXA2tTnQulBzDlnhAFWfSbSWicTIrFCnhnyziobBM5ZFZtfKs8c9931i+Q/7apUoc9dykUv88aC9Wn6wbO/5a/SmZdhOaXIW1sXKLDnJMRfHzNuNJ+CHSQOt+QE8865rlz5HtdzkvU5Rd9MOJCoJadtKx7EB5qkphWp6tU2cdUJFszhy/iGGynZg8XObRtTNl+PAuJv4xdT2V4lYJzgH2xLSjg0Q0o0EmeMYfrFdVt1ywHwmM6Ri0/8el6LvPncivJMEMGsv/n5jgZZGtP1Z5m7QiMwF2apKaIfRQSwWizAgHzopUmMWO/4yFXRkNT73WFxpCP9FBwt2BnVZ5EJDFT1zJ80QKPfi5NmkqoDGpvwF57Q3G01/kw7E2UiaT5UD5suHhXeuGsMZ944E7TtFS8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(66556008)(4744005)(2906002)(66946007)(66446008)(4326008)(66476007)(7416002)(64756008)(5660300002)(52536014)(8936002)(316002)(54906003)(55016003)(86362001)(76116006)(478600001)(41300700001)(110136005)(33656002)(7696005)(71200400001)(122000001)(186003)(26005)(9686003)(6506007)(966005)(8676002)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-4?Q?VIZuYnXsd4pI+c+b5otz0ln+XPIcKOsdI0oeQh8B7YvkVVdvYkSrB2DG1G?=
 =?iso-8859-4?Q?jwnPq+ZrjXxd1bEPDbb1LPFvUPABQJ4Fr7zNPxDvFLl6ediATG3YMZCj65?=
 =?iso-8859-4?Q?6qmGri1xrHRtwngwzMSLxo8nNAdFRPcqBMmc3CPv98m7nPncTSR0pAOa4l?=
 =?iso-8859-4?Q?pmKUCNLb2I91kN6NbrZR6+PzQFHEsY39k1lVOaH6VSftAlrusQSMK7Brwj?=
 =?iso-8859-4?Q?4queIyt7FdpDJQjiub/fUuh9+7v8xCs9SmA/oi2rFGCOFVB8NJNDVmCb1A?=
 =?iso-8859-4?Q?t0g6thX603VADWyJufKQjreTLjNeK0rBglwATlF2NzBc5rCaPp24kXQAzW?=
 =?iso-8859-4?Q?c1B3n1gjg/2g03AsDemhNsL+GX6uPt3ir1RJct9AeWUd+Xkz1P1ScP6i5D?=
 =?iso-8859-4?Q?kngNDRdwjbGoH1xvSg0OqSj4p5neoRGA6MpyAbIz3jzpBEObtjyXjkOmcV?=
 =?iso-8859-4?Q?MuRzolm5AupZ6a8+JAL/XjP6ztVzDp6d5wJ6T2ehT8h6j+0okhnPs2Yp+k?=
 =?iso-8859-4?Q?OQ4UgSx7Zjv/HepzbbpQDrVexOmsPEvs4bP2Fq+zi7+HxO0AH6omlOOewP?=
 =?iso-8859-4?Q?a8UQRo5Y4urJRJSUmtP0RBEtdEySosXehESv2slUJ3C/XXQgBUXvvn8RuR?=
 =?iso-8859-4?Q?o1rnoLeAzk6LSuGms/xjH3S04W2if6utQY0gkAKshfTG1CSblQ+qOBMtVe?=
 =?iso-8859-4?Q?PAMz3O4V7FQWREybSg2OM4A9QDpF6uZ3YfD0UgydxrSGxVTlpJE1cYgwA2?=
 =?iso-8859-4?Q?f9ib+pOusZuv89fqBet5MjLyUSOCtpbcYJOP5F5Qt3JVOi+BpbL8jwVLi2?=
 =?iso-8859-4?Q?rUXJgSAWFCSP6x3WyU9DgMJWlLV9zEn6mvx32R4K7cKXQxSXv3se3ng26U?=
 =?iso-8859-4?Q?Oq7sUsTRHbhuCq/Sq9sc+4t7/etuK5apcZ/cMHUL9q55TAXT7eG7G8/6hD?=
 =?iso-8859-4?Q?YR2wElZ9VbyzG/HtoDsiqXRN0PBQ+/MW8ML7rGlYricM2GaHyfXsWS4mq4?=
 =?iso-8859-4?Q?Da67HnfZltlOIkBveAGnwDP7Q5kSNrOR23zLGuU17xfaKRTzSSDhLV5BU0?=
 =?iso-8859-4?Q?/15TOT6qLTk8hFJvgLlYbLki02FNtDxJBhOMTNNtpou8Sdk5Dtue0nESrA?=
 =?iso-8859-4?Q?skeCsapFAswuG7lk8p4oxEIG7bT41nd6yLz9xlAIOoxtIE+qjVZC3LQ5ky?=
 =?iso-8859-4?Q?mZ3QK+MGzc9LG0xyg9snS4P0fRLmBJuchu6wGwmDgBUhM7Q946VkQY6cXk?=
 =?iso-8859-4?Q?pNBD+Ou4tXSoIt6EF7Sy0066H9M1BlcPTqSBthkKP2EBIDfpz5Zbdulczm?=
 =?iso-8859-4?Q?fL3y9Ezr+VCic+AX/+rEk+LE8/dTVRV2o/tV4RbjsXC/pXWyZ3uYiM8gPt?=
 =?iso-8859-4?Q?CnpabQi8CVhB0j/1f5X/ijRgBYIpwqBFUShONwm8RArPS9MkMjm57FxTdn?=
 =?iso-8859-4?Q?JLBbTZv5RBZVGtrgg/hRvpcgcJhLjUurLGUA3aAs9Fr/kq0rISSF6ZBwT/?=
 =?iso-8859-4?Q?o3PT35O8vE9CCzKpHncJ4/3Pc4tUJXDk++0c9amh30YW2gk480kFwFoyrv?=
 =?iso-8859-4?Q?EEc9e+tXdSu8AJe1Ijv6xbbzMkQyb1UMiJENWYabf0wPy/upK0ACfN27OF?=
 =?iso-8859-4?Q?uolA//XDHXCVhODp5qxppInk7TRvBMABOuX2nTJp+5E/TeN4l4w43mnw?=
 =?iso-8859-4?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-4"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9711c7b-4c48-4f7e-6417-08db4016f269
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 14:12:30.3282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CvZod/Rq8Y49NC4VoPckO6ZAY8YCptC1FAy4iHvH9bnebIN4ZcJHTnWzw5nbqCHrp+PbEmgOwlm90GvJCAdDxUAPX6nPmrIHAGh8q0V5GPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB11801
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
> This is the start of the stable review cycle for the 5.4.241 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.4.241-rc1 (230f1bde44b6):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
40769223
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.4.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
