Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9136D5E10
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbjDDKvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbjDDKv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:51:29 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2122.outbound.protection.outlook.com [40.107.113.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A63035A5;
        Tue,  4 Apr 2023 03:51:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bb+3RHQyFZmcnzCjEuXTdrJ3kS5lGYOaGgF+NxjUpEdMTKbxeGXn5q88N3xcaJ03oLnlwiHlFFkQzeGAMJ1kXwAlIS3jQJplKNSZbnuP1QE5Ajos0m7fhUo711EwSfUQ1deyM+OoHVPf38eDY3UPJrOYgIAW1t0FUl9drAnTPD/n/LJ8lfaK8vnTUwrjFbWwl4Pu+rXdvy9kFrSs1SVK+XMtVbS46W5g2zNYDBY8RBN0NeWC1iuVik0mRuE5c8/yWBXEGlfSxBmAfhudYKVOKU6a19ROFgkSFtCVWVeqSJOt7/2482NHqfdThCtgwGkvwWtzO+WnndThbfkyBaiLqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCbmcbaq9QZZsN+dTeEBPKbr9X8SOu36qi7KBjOhej4=;
 b=PLXXwMVYWd6nWaQKQ8KsQ8LWR533cjcEpk0NlCL1TubGN5TB7W6Si1Tg1UCYsjYT2cVjqFuPmXoz33zUP/YCA3CEwZF7sqsZouqkiEQcbjLpji6GzTbkwYT/Z6kUtFE3ZswvorSpSMqsGMudzhdRf2RsO2L4rsE1Z+iwgEtYW7ADXy7yjqIP19wUCaXUmEQrOwgWp2GMdVF45b4NJU1JEcUlrtv40TybKZtVCPJ10HO7zI0FpQ1/aCIeNCZKy00AmMNTdZ0TPuC/NwnbPChDjpMAHp5xyz46QMaoO3bjalcr61zxisGl3Cv6FG35NNgEeDMiCyVNo0w2tQ/+dGT8Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCbmcbaq9QZZsN+dTeEBPKbr9X8SOu36qi7KBjOhej4=;
 b=cfs+EdRa4w0ZV17eLjEeepvbEQ80gnd0aSaL3dP4w1TJOWqWy0TJhs5ISSVT71Uit4rLoBJPDNzGjPgsblYL+Q7/n8wOs7kJToFNxrWFiKA3NttHDl8ug2WRXmpTnctRs5slucfqnxgROeRtE7bFx4Vn8ZTkecW1s779u1OePHY=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TY3PR01MB11971.jpnprd01.prod.outlook.com (2603:1096:400:405::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 10:51:02 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:51:02 +0000
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
Subject: RE: [PATCH 5.4 000/104] 5.4.240-rc1 review
Thread-Topic: [PATCH 5.4 000/104] 5.4.240-rc1 review
Thread-Index: AQHZZjdpPz3TD40cb0+uVrHNuaEm2K8a+ewg
Date:   Tue, 4 Apr 2023 10:51:02 +0000
Message-ID: <TY2PR01MB378853B96379C848EB20F3C1B7939@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230403140403.549815164@linuxfoundation.org>
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TY3PR01MB11971:EE_
x-ms-office365-filtering-correlation-id: 52aab177-0f4b-49e1-f347-08db34fa7ba7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W1i3XUOBd4HcrjlKwZDhcyGxtQ6y78GLRoXAVi4+YxjadosT5g1pcSUjM4Ug43ysuxJAeEa7NK9zC7Xrx5nq1ggYYvYjN0CyCVA1+niI9lIu5slT9ktBWyB849vc6mXhfGllX4ihfy1ZAIVmU5u5zgOUmi6rqQhAVXWzrcEITFeBHbc8/WbFLudXUd2L69PqD6FJezZ4AiWpc35vgREwSXf1tpJi6N+58Jy52LjWgnzlUSYreDQgP8JRP2ThJjLEiY+HRbEYSZr9VslCqXwbKptd3QUv1cwrc4N2SLCJzEdeLo/PXecbsHL/xzzMQXARq0TVZ360BvpJkw2CR055zmvGab/v0WlmceCfJqFS9vQupgH0wYh1Y/n9PcN60LU3suZuSA/hClHHKKKollNG33Xs+cVu9PxMjHQZbzDzg4q3pEFxUVFHmFUlcI10noZUkxVjExGHsp8zjhtQdAEkXFR2kzilhgvRuMOBkOWQ16mg7SujrAGBFu306tJFWiDVdDQzrDEaUlNp+pvSnHtIIWypkfg1sYrL4qo42FX2A8JK+9kOx9jnXZr7r/fIRNmjxxb/ADcx+qylyTbfMjvoTByRGCTJjMPqy4fp4pUMpdtlOVkf0F+gXsSLOMCWBxPqx8ehd4N45atkT+z8ui9Jjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(451199021)(55016003)(41300700001)(66476007)(66556008)(64756008)(76116006)(8676002)(66446008)(66946007)(316002)(478600001)(52536014)(4326008)(4744005)(8936002)(122000001)(7416002)(5660300002)(110136005)(38100700002)(54906003)(186003)(7696005)(966005)(71200400001)(26005)(6506007)(9686003)(86362001)(38070700005)(33656002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?m39h7OpMMbcjOS819Os5iUPOlmUfZS70erB8+IaJ8K3nCx1qk50AYdNW?=
 =?windows-1254?Q?GTtpEGIjcdnRVu5PHb7N/Pg3+qD3N1BRZ2va26ZuAz7apWib3zAJWZyd?=
 =?windows-1254?Q?cuxLfdBt5Fw4yPeBjvXJOQI1ilN/bQ9cVBQo1/X4YU35DoEaN28GeLxy?=
 =?windows-1254?Q?ovLQMYcrpG+O7ZWWKy9Cx/o5zsc8vJAB5YdIs24Pjl3YPYbuFGc5qm08?=
 =?windows-1254?Q?Inu8Cl5AQeFTi62k2MxHitL0Y7p5wpdz0ojQk+8K+Z4GKAZAufmLIi5A?=
 =?windows-1254?Q?7u1bY7tZZfcDNacUTgeQFKmWHIDFCYCBpGkiBLulBjU9YdOO1/L68o9g?=
 =?windows-1254?Q?goOSPTPBRGXp6jkYFreNfnYLzM27VNpz4emJfKCPk3Dt7eFK/FlbOfDT?=
 =?windows-1254?Q?XPrkDQOLv05o5C0tvded5dRf4MI2gyFR40n0/uIIWDBxp8ED4cQpIWe9?=
 =?windows-1254?Q?30+OIA53fogeAgTv+nOqE6+co0lMCKP830dgO6dcmSGs4zprYNdR3FMg?=
 =?windows-1254?Q?HlEe1He3jJDeRrL6zVQ/beOe4nj9bhUjc/vuCyYDPjzQtK16iIr/mJuV?=
 =?windows-1254?Q?0ASlIt3Xz0Vzi1DnIxz46SDYgy4oM4nOu2yFYQZGknQqF/DZSY1KTQlU?=
 =?windows-1254?Q?erDcDnhDPUkpFN+QWO0s7ycV8T+95JzaiTBlu8rfs0+usOTQbJSyO1DW?=
 =?windows-1254?Q?0Dzge3czuhL36BwOllaa64FcLmh6RVqz9DIFW+tuC+hK/pJzUP/afqdz?=
 =?windows-1254?Q?Y4q5ZmKB0S/Myx3QQsXzeR/bHs72efwhrf+ftjGRS1WlDQICjQpe82Sk?=
 =?windows-1254?Q?EKiQ6J7hMT62YxUYdkCMruKEYzP6FEFEJre/4mbwjgbSBu+q9ZpPj+aW?=
 =?windows-1254?Q?H6OqKM3VW7uUdf9Q9o2pRKavMn1cAmlncDLo7oJi5ynbLVW9PJVpGuAj?=
 =?windows-1254?Q?DXRoT6QvP/wyLVW9CeL0c+v6L2PzbfUSXqnQm3xNcal+BGg9myF5CAkH?=
 =?windows-1254?Q?WjKXNytUp2hztHasxelW3+2J7gLiZ39gZ4uj/Gb08/SpQ1onX+/2LxN3?=
 =?windows-1254?Q?I0PB3U1yw0MZVt4554aVPngysS+bevw4fpz8crISE9DvuZWV/w+aSByW?=
 =?windows-1254?Q?pJaXLtEXyLUwZxkAZHvfbNm95POGG7/UVEpxwPRtmJvaoUVOxaesAlWt?=
 =?windows-1254?Q?HiOCqulfXZ5OgcmLI6lPpaCXe63rp59XW/90Pa2m7o7ZZ/O3iHIoHzU3?=
 =?windows-1254?Q?VoByJNL2PTpkjcMOmVik16P/5EUwBGetpw29e73TcvDHulStFBhFPbno?=
 =?windows-1254?Q?YuhmqPFubZMDdaj7VZ563Kix4/HcsoKFdriBVL6Xt5VAbMU5duRkVXl9?=
 =?windows-1254?Q?32xIkYA0nf8JCraRRqEP5mUaLa8WfvJoyQgqD5BerQUWC89A2cX3apbj?=
 =?windows-1254?Q?Xs/kp7Lf+lngviFRkcS1ydvgxuvjWVWu2Q87vZEWCNWHJbMKngv4gQcP?=
 =?windows-1254?Q?u2R4eSS3IJNIWvKEmK0vRCIAZwG0Y0L1dm56HQqZt5Ic69Gzt9aZ4kLg?=
 =?windows-1254?Q?bCyAnuOvmyi/SwkPg4fHhv9jTmURREPv1M62ksXz+dD3xvKSNMnYK42d?=
 =?windows-1254?Q?JlQcGysEUeSAw3Kd/Uaqy18/CaNapVabnu9Fqo7MGDCNNUFHpPOw9hwq?=
 =?windows-1254?Q?Y+/v72pJiasZT4LpHD9GJvU7x2/oWQJmP1TFEt69UfxZ01ajNu0JCw?=
 =?windows-1254?Q?=3D=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52aab177-0f4b-49e1-f347-08db34fa7ba7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 10:51:02.3573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zvH1Kipl/OYWUz55EAv9kPs31v+YjXEKlgpmVfI/H2y9fhNZbBqxXEpekLnGCwUpStIh5ES6KrQcF1YXcmE71WkxzQ8KmEtUQyiulBvLTGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB11971
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
> Sent: Monday, April 3, 2023 3:08 PM
>=20
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.4.240-rc1 (73330daa3393):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
26399665
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.4.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
=20

