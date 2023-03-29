Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FE86CD491
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 10:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjC2I2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 04:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjC2I2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 04:28:36 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2135.outbound.protection.outlook.com [40.107.113.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B478C0;
        Wed, 29 Mar 2023 01:28:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpyNqQXlFPHIW+/mR1S3fQ8MZ8+JQ/5obUp8nlNKjIFJJn5+ZcEIy/9YbYHthtz79AwfyKYoflAV9pAGyj17t/nGQE5E/uHE2Q2+tv3XSm2qIDLgMYHO1Rc3ZkZ/0ilTMV6E7xznheYDCEzAwZhHV7poEHhWaLJy/SUEU7VYDPNotkpRIPB1TZqC/H0YXdRE2vc1+Zp4xzdBh0Za4FZ9/vwfpT8f+onwz5FO8/K+zMJ+DEc0AyP1627ijejpN7JBirhSw7mpd7EVhLd1ToYT287XbTKzmetz6isdjkhioRuvhLw8rtbvT92i6rKH0L29obZ8VZXO/IaFYBksJ3BvgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQIe492E+TxVx5wwzJjSY3gtsPC+DffUVMOYBelpmhs=;
 b=bJ4Pmcv7bC7Bsp2CmzuSBSY2KR9XUxj2KWHp/NKfS3nTSvcrwBf5ZxcKXsYhaKfcYIUK9SPF5LzDDJmI+G2PicwcwG/0V7hc6rEy+F4rqZWRL4+DZ/0FgwMpuxUZQcT+K9lpfb1z5ZodKDho9j71Wy3ngAdV0tuaZx3KLFeq91aEE5h80TTbQIpQ3pfSSfof6KTTsopIHwHG+9dBJ/ypBfd/pw5T+g7GCt/zFUpdemVeQRhG4g64eubIgrBkLk1WPHhYZFtJhslUzS8ek9Cgr2mua7Nl2d3RVXZ16yjAfM7fzAahUmd3HF2pOe3cywTxjYPjT4kHBY59bVdC5mNv7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQIe492E+TxVx5wwzJjSY3gtsPC+DffUVMOYBelpmhs=;
 b=KHUMKJ73bEmkJceT0mUWbkJlciYqwkCET4h75vBGXj6rQkuhlJGBFekjTUv/yfAEYCJMnSETXYNz+mH6iWUMJuRXEpliTp2kh/74Frgc4shobyA1LY0P1VD2EpBtvfTwixud09b3YMY+x73fJHCxs6HZp8gPafg0Ptctiv9tV6E=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by OS3PR01MB6168.jpnprd01.prod.outlook.com (2603:1096:604:d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Wed, 29 Mar
 2023 08:28:32 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::1dc8:5434:72a7:eeea]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::1dc8:5434:72a7:eeea%7]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 08:28:32 +0000
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
Subject: RE: [PATCH 5.15 000/146] 5.15.105-rc1 review
Thread-Topic: [PATCH 5.15 000/146] 5.15.105-rc1 review
Thread-Index: AQHZYYeJvAvfqqAMvkyQFwU70Hk7uK8RbSRg
Date:   Wed, 29 Mar 2023 08:28:32 +0000
Message-ID: <TY2PR01MB378837CFC52C5DEB2BFAB1CDB7899@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230328142602.660084725@linuxfoundation.org>
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|OS3PR01MB6168:EE_
x-ms-office365-filtering-correlation-id: 9ca2c90c-b00f-4a87-17f1-08db302f94e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NWm7DBmgIDszuIb2n6kBHbGxIV9fx9u13Lwz5kHCmMa/Hph4GvGZiANp95CQRDjZy4mwSYZMfupEq4WBSlsAAl33KOVmWXCYplQ91bWEUpS9U5KFzu1+oDb6YMa1kzaWwftxHUwTGuL5pzwOTg5wrLR0lSaTUnH+DKJqkeu6FGj6D/seOBWR3f1slOmXT7HBpOj9Sef8IaGfIewAMcsDHs1O0DiO9LVffDn8NPwzhD7zxQgUo4G7a3TL64XwwCz/nzpalgsD9cab/kbVcxNIsQP2yzOV5saeBHYlEvWUv+pmhmf54owdMMDIjxXr/S6PYr2YDHsNcLCUuwqGPxQUdwmb6nTY9q36Zid+2WYomXVyxmejjtRpGvon7UVk0mF4lcNXXGis6A6B9nOyrSqwnw81ZzBWBczDBTJ8waMxJqVevimNvQaARKwU4wXD8FS67u3xQ5QrC5z7ZvNeSAINmPn6stA5DpPe+dpwok3xYJryenaNtiEvi25aulD3Qm4udLGjnMjjLftFqHLjcsV1kWcPnWDnbkmLtX5tRXXus4VuEH5Wvw+tOVlQhzUTbH8OlK+aXiAvbsthoAiu6BBjHovclb/+OFzHPC3aXZqGUBzS9qNfADZNDQSMChQecBwi7p5LEXbnf+2QvchIGw0hBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(966005)(41300700001)(4744005)(76116006)(64756008)(66446008)(66946007)(66556008)(4326008)(186003)(8676002)(66476007)(7696005)(7416002)(71200400001)(5660300002)(122000001)(86362001)(2906002)(38100700002)(26005)(6506007)(110136005)(52536014)(8936002)(9686003)(38070700005)(316002)(33656002)(55016003)(478600001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?XzOrIxlgHVQolHyVynRYxkcKVLo9qiMoMpoSYTkVkKBlKciepbafe6F/?=
 =?windows-1254?Q?plYD4Wfu3ml2lrgysm8MN8dD3NUfT1EpeAKYHU2FJNgZwv12lufEZn9y?=
 =?windows-1254?Q?SqPjPkc8sAkLG9S1/ZXcpunkDeX0QXTb+tYk1/zBW1+hYurZ0Cve8DYN?=
 =?windows-1254?Q?+u06TBz++45X5TNf7/aV3XVek/IyrEDh6YG7yqekq6lMy1tLmHv3A6/p?=
 =?windows-1254?Q?tYtoFOc5YU2TzkZlSvuNANHxQe6EkC9vCpi6KtMV8b2S0l2GNwCiz/7A?=
 =?windows-1254?Q?D8hAw6F0nCxyl6+El1291Sh1dsjpJUmi7e0jvwl1lJxlmXppg9wgT/N0?=
 =?windows-1254?Q?SRwbH+pnNEIi5HPsqSd8j/S7h7PPbgvIoA8nrJn7mGKqnJd2QG7+6V6b?=
 =?windows-1254?Q?reBVrp93EvDwTpTgCXX+A+OWEc1hB4HnSLbnQfbx7TXRVCu4w6b5k32a?=
 =?windows-1254?Q?YY+qiql8H8tLUu9NMUja6Xg8VWBborMhavTAYvxB3Id3p7eEAN+mjREi?=
 =?windows-1254?Q?zttFgcdmApaQKGi1j8K4fpuYCjVLPwVdqMok34ve/2X3pDPTVDXP+XYJ?=
 =?windows-1254?Q?LHW6zgTAX95V9KK0UXLaQOuQ7epN9d+vSQ7/1N8kpb2sPuFicY+HMfyM?=
 =?windows-1254?Q?k7zO8OKsq5eNuhiu6QiYJA2fEy1CJvmC0d6bOfupiZydEgZbox3+/vLs?=
 =?windows-1254?Q?+8QoR8NjTc5LLzRBvOuRvBHRHozIByKKNMHb0aqwbmqzty9hEJRMMQMx?=
 =?windows-1254?Q?CC1wqVG+thmh/N1tr+YIoJv2P3w8nHWK++J4OrwwHc8S7nKXvh+zAnDQ?=
 =?windows-1254?Q?VClWEpwqAh+g3u/TOiT/uRaDNB9swzVHUh4al9a5ct7zs8BTMXpJYP7c?=
 =?windows-1254?Q?YLkowk/VcElEpmCggKBY3HfSOvtBTdlgQLopCfovtSZQEQfORlkHyqL/?=
 =?windows-1254?Q?rfYxmImbCeFcIC03RaxjY1WjUJGm012Jx0Q7rloPhoQuQ+jQRCUtsu2N?=
 =?windows-1254?Q?4b3Dwp+XHTA+i4ASFAyYivPUM6v37WLilDCRhLdpX7z6BniHebX1m5Vm?=
 =?windows-1254?Q?pUJ4E8Q+j4t3QEUUt//BD+I4mIBnSvCZs7nPsICr6NxNqOwaH2DNdSyC?=
 =?windows-1254?Q?aiLVDHYiVfbZ1wLkJYUknw4RksvPliwNi5z+11mr/tjK2tKyJkfJuF22?=
 =?windows-1254?Q?vlFznt7cyOD7c+dmgOyQBsUTj5AvIIKo/tVcsw4SIWR1Rx7gN+qvHcZL?=
 =?windows-1254?Q?HXT6QvBGp2+alVl8jF+q93AbdF7+D0NJtT3GP+5OIZ41b+l8wYUXJCsO?=
 =?windows-1254?Q?PNe07PdwwNT0/yfkZdvaY0MrVAbJQFuiKfAE6u+1BP9R2nxwtVYFen1T?=
 =?windows-1254?Q?fm2S2YDi+UZ+QXvdsrEHRbYot2+20FRaXg4mQycIzgLb9XJP42X3WNbJ?=
 =?windows-1254?Q?fSJ6Kd/RMEoZvZZmw6Eh+6EkxssxV5Vf8OjLaoYQmuBppl+45peyXXSo?=
 =?windows-1254?Q?xnZok5bSUk2pR60TDLu65trupkTkXkwggOi6fX9nt4GkfYbo2t6oX66G?=
 =?windows-1254?Q?SC60dhAb8b7BxXzQndktPUt7Xx5CF9zWBS2lmySxcPWKQl4JsgAq3Cfd?=
 =?windows-1254?Q?O/RMJHaHPIat1WD+O8hlAz2pRxoI9b0zbHaF8oUoFbYIQHkPxPKbY3s6?=
 =?windows-1254?Q?081qf0+jTw7cenG/ddk3xQD2SU9nTfFdeR+q73cxVizhUlroXbX16w?=
 =?windows-1254?Q?=3D=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca2c90c-b00f-4a87-17f1-08db302f94e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 08:28:32.2407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRGdwddYrfMItjar5zx3SMtp6U1boeFELUYwTXyXrEaic0H1BtHem7IWGtw5LtbcU1GhInGYnvC3k8d/zSP35vG5UfUGZSBRX96ElzfAtNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6168
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 28 March 2023 15:41
>=20
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.15.105-rc1 (ea115396267e):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
20594995
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.15.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
