Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994AC6BB5D6
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCOOVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjCOOVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:21:40 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2137.outbound.protection.outlook.com [40.107.114.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7A16782E;
        Wed, 15 Mar 2023 07:21:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJRbzSV1YwxXWNOlNS7PqVcLbP4BRcbPqX4KT4gjPj2ALwsxcoRM/oS3kn35XAE5841hhgPsYmuo0kZeFe91SKCdWZdw1wGLahuNOJAqUEIjy4Gfe1J/CqiazGw29SvXE6Ch5QE/e0caGt0cCmKC8jXCEI33i9p/FNJOsLKHDOghzU+d7/i9eFWo/MBfXQon+bLSsfjprOLRG/YJdtlHLGdd6kqIBzflKjaqkOwF3yrOSMS0VJWIYQpznOKRPPw6Ny+8RnF3Ljhp5u89L86Cefuf5ZrchYhU4TOEEXaDsPQWzNpAgTCDuJvbB42tIHWVGuz2xaF66h2HkK5XkoZQIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLdshZtLYvFRu72/3ATQ71drFa0tuY1irlUFuSfH/jM=;
 b=VKX5Z84C5+rLQVoDLoALgMvsXVu4d0mwowIldceYqCwCHzUJZUaOyA2NAjBVG0ybDBBa45NCFRfhdrEOpImpv4aYUbMonb6J6frtl+0mtwIFgtN2duSs78VUGfAglN2aBfYQN9yw/0FxaaqFownY9kT/s7giYLxfZyI4r0W6pKSlInsFwnE7+Dz3Jeup+9EIWtAiz2HG5GGYtPHykllBlH2ermC+/k9MeRuLMKG5Sl4rujBI3DQBTDVpXULLTB5R5UjOkJhTcjAaxSlfb/T+woIcmHF9QernQqgKnwYIWLNdxC2XofBNU5jckc0gs+cKtTCewvlxQMnYzp9wUtj2sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLdshZtLYvFRu72/3ATQ71drFa0tuY1irlUFuSfH/jM=;
 b=WrYaB+NVUmnn2089Ly6/CvzkH/GV+3ttXWcwam1yWt7Kg/lQGpt/OqQzuGxSXCxYS5KXwXLN+8fjh0VEsQJ22eXW6gA9CtRfA3JK9ihNla1So4xp9B+ZHM7o9o0rC1cnEE6pZOtuItD6yJ5zlg3TbJtPbVZorblD8Yq+dTAesig=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by OS7PR01MB11650.jpnprd01.prod.outlook.com (2603:1096:604:244::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 14:21:36 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 14:21:35 +0000
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
Subject: RE: [PATCH 5.10 000/104] 5.10.175-rc1 review
Thread-Topic: [PATCH 5.10 000/104] 5.10.175-rc1 review
Thread-Index: AQHZVziwuRlwuFQqoU28Bhc4ahbYfa774rWw
Date:   Wed, 15 Mar 2023 14:21:35 +0000
Message-ID: <TYCPR01MB10588706C488609CACB02192BB7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230315115731.942692602@linuxfoundation.org>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|OS7PR01MB11650:EE_
x-ms-office365-filtering-correlation-id: 20fb5e95-6533-4e5f-e129-08db25609592
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cjs3dx0kB69MkIwN19IJZsXUrfS24MaM3Ez+ny2YBF5bt+LN19/Xq/c5gOJGi8Ndmn0Ge9ir5zLiHH1d+ViMaNIGlH4y3sDcdTk4QDidz4FUNncp/p36pxj8KC3O3VkPOYvKV83p3xeTgcQ/YDvSPb3yjx9TEqGcMG7/aTVrrCwI3QtPN6/BPAzk5ZahGxQQGfX+FSDWC4m9kJUr0fgbF91f3FAPEvjeuMvmqZ4uJr6h/1HeVzg4hVxw+jzbvLXzy1iE3EdYTTOufWaVGdWsA+RASH+4eqjk5DTqDjnHygCBRz69RH2fmjTcahYsiFoykp7w+nslcdIzi2/Dk578j9c6UN76Ir4YRn/413aD+fju/bSmBUMeQWU2TRjZ8PP81+bbf8GJWUgK4jk/YVDeMyGOaRUv2lsau/aps89J870U9zi8IafvZ2VGuSi2A+aF7Fz0P705Lt4PMApP8zbhKtVHB3wdfGNkNB0zZKQAS4v7I8BDOM+ox2vih9HukpoIMCzFys1AvLSmyzbApd211p6YUzpGL9+4jphWJXFpbInuJK2+UpnovhGZp3Xyl2lSOFLyW5CPJiNI6SNgdlBD1A+NCPI+r4SUo3+ZYldyhR4jin9HctJWR5ctX0tWYirZy3G8C1SPugzCDcEFngXZjDnTsQVWKcDawfxbhHwos7keExQ0geQTCa+m6yh5kWnGHCjAaurjIVtHzHMcWrGOSzmWNvmDs8GJ65PJHDGprcM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199018)(7416002)(5660300002)(83380400001)(8676002)(478600001)(7696005)(9686003)(966005)(6506007)(71200400001)(26005)(186003)(38070700005)(76116006)(66476007)(52536014)(66946007)(55016003)(66556008)(66446008)(33656002)(8936002)(41300700001)(4326008)(86362001)(54906003)(110136005)(316002)(38100700002)(122000001)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?YF02CgbcTC3faUGDs4yoNWZ/Kynl2Z0dd3mP5FHLCb6BvfeTsn9Yzltc1W?=
 =?iso-8859-2?Q?5MEVM08mIW230T6lhGBEoNN2X0JyDiUuGdI4U/s0QjHWOzHpsSpIvwzU0M?=
 =?iso-8859-2?Q?KmZ65YjiRna1PJ7tSfHLwVzs0YgRjHAg4rVRM1hCZUS3UDsVnT1R6xSHsk?=
 =?iso-8859-2?Q?VBrajw3iQrlpfROs0PTl9CtEPyGNLCq4I+NgAApd4/O3JEkpfsM1yNzSoZ?=
 =?iso-8859-2?Q?8mQLIdcdpaMx/T8vYz1xo0u4iHtzEd6LslZ7s4LuOUq7Uxly3Q8FRwPNq8?=
 =?iso-8859-2?Q?05uhVJ5347KFzxkYzLt41HqxIQVFCu7unGW0sOtUHCHDBVexeZ53fteCNU?=
 =?iso-8859-2?Q?VdB4mACgiGdY9WnMYFuLfXm/Ouoj4TwPSliHPmHFM+X9Ez1GlLPyU3wHzL?=
 =?iso-8859-2?Q?UtwNvVGzukky3R5T5FL+OvPcJyrGUKoWzVAH6U2F9l63gWGUu5GKGSSWpu?=
 =?iso-8859-2?Q?chnDdpds5kAAcmvFs2nJ1MqP06BgaxQfnYyTLFWhJ2+8KLZ+VjvBB3b+Y/?=
 =?iso-8859-2?Q?LiVy6ilt7pDvi2BPCpPqwLTR3ZXwndUlj79e03T1LJAA+oGTFaNt3q+cTM?=
 =?iso-8859-2?Q?5KpEuDUh+vtnACuqK6Z9hriX+1/HYTGF83254l0rK6xgpmpbD0pEYvEEkZ?=
 =?iso-8859-2?Q?DMRmH7aWgshd2dJ4jiqnvZo3HDL7kUwjSd/MDeLIsCJ9XxGpiPNgITkuU/?=
 =?iso-8859-2?Q?qP7ylJWQc/5s8SzkpOy2uDZrQN4++YlpM0E4k17bs3qofRRpJnVm7Euh2v?=
 =?iso-8859-2?Q?EK/+sdmGpSzPAwyMEdgpp8Q4koKtTa3z+fWydcJawuSXXT5jhJlMYfuNFC?=
 =?iso-8859-2?Q?fUEqdwqIK2LFkjb0CrZrtIpOBzCqsPpMD19QJsNKVraC+mN4qvSVQgIjUY?=
 =?iso-8859-2?Q?z10sRzGr799jKMbWi95uEMs7Y/7/SkonajutXa6Ht1SPS53zeKs+jenwBY?=
 =?iso-8859-2?Q?/FPTVI3NkLoAnOptWuhm6M72oS31S587VHQ3KnIGhFB1XC/wajbBNp7lFt?=
 =?iso-8859-2?Q?Y3BqMO+FJIk3mKpZiF50emoB8CYEVkVfwqsNnndOlKhuRbjVFeaEx8J8NA?=
 =?iso-8859-2?Q?5jw6Olt+RWirJNAsMlddBmicd7DGZw3Mz7wFLsIsKTwaUOGw465EtAKUeq?=
 =?iso-8859-2?Q?33UGvDr7svSfYpoAIFJvgBIOK/GubXUCTgChSNiim9tuLD0VSAjBxdMC6t?=
 =?iso-8859-2?Q?Ps62r3s0QnmPdTe0ms8ND5Z/LUPRgYhrC27bdrBqzCjwuHvPA6qKoC3uzV?=
 =?iso-8859-2?Q?ZTInjgV4VHSZ0dJcr5RwXZXpuayEanUKyjbNmBSzv6kHTMa1ONlsyv6tio?=
 =?iso-8859-2?Q?awbkknYXtbNk2p3aLYaB8nMsHZHbFAUnzgNq2/Q2D/c8X0S6PA3r+xzo+r?=
 =?iso-8859-2?Q?vPxzwTMTl5LWKir+MjtLT4rYvTo4WVH1irMf2LYjHXCydNTmJgifbfX8Fz?=
 =?iso-8859-2?Q?x5MstfibXRyxnRQ9HuB9K08Cmnj1UED3sToVll+7RPXZS7GieCexQ470vY?=
 =?iso-8859-2?Q?i0dksuKZNCMSdmTpdrI5a/+ArZquhDxT9PYTgejPPRRXqxt5T2FoBGQzt/?=
 =?iso-8859-2?Q?agOo+a8O7OcIhuuXgxE1ag2Qoq7CiyH14uYe3soTrVZBrCyOpiyNWL+42m?=
 =?iso-8859-2?Q?WTkQewWdkF+80jzTGhTJ2UAWCrNmfw+2YxL7DOZsHa0Gy/253uDC3kCA?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20fb5e95-6533-4e5f-e129-08db25609592
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 14:21:35.9107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yI+7jah53YqDW2mM1Y5E7DuxT87iqrmlpBnT76fvlQs2Cj9xmFpEDWtn8a2cPs0goLYHR+2O6xLEQxPNB6YG2L6zblwqtmrrwdP9hn7Q4is=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB11650
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 15 March 2023 12:12
>=20
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>
CI Pipeline: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/=
-/pipelines/807195733

We (CIP) are seeing some build issues with Linux 5.10.175-rc1 (420b6d10bae3=
).


1)
For a couple of arm configs we see a variation of:
In file included from kernel/sched/core.c:13:
kernel/sched/sched.h: In function 'cpu_in_capacity_inversion':
kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'cpu_c=
apacity_inverted'
 2560 |  return cpu_rq(cpu)->cpu_capacity_inverted;
      |                    ^~
make[2]: *** [scripts/Makefile.build:286: kernel/sched/core.o] Error 1
make[1]: *** [scripts/Makefile.build:503: kernel/sched] Error 2

Full log: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/j=
obs/3938632489#L1910

This code was added in "sched/fair: Detect capacity inversion".


Kind regards, Chris

