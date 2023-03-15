Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305EA6BB5AF
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbjCOOOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjCOONt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:13:49 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2132.outbound.protection.outlook.com [40.107.113.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6718C970;
        Wed, 15 Mar 2023 07:13:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbwK7GEZy/icCYpCxajHhO/wECYvvGe7hN8s7mHRP7Raf8xqRkTjC6t9VUXLAu7LPNsuJu2jVH7qqMuqRxWDhjcN7jHXWvDDRV8CgeaQ7yEJB/6RWsZVF2PtPryH+B+yax/ozSnhl8wdYPM+mC2MvpL/2FxyJr91G6L7PO3lhzRKPBinrVJWr5sM4D1gb85P5KQaRld2k2C9Cu8g6mBtVxR1Kthw5QqZewND9CrClirzFDZkTLokU4brBIQoY0i+SpvTURuZN623SA5dGAmDDNNIanHhjS9FTIyGxKtoNYYxF7Kr4viVIfxcnS2BBp+nFspCdbbqUyV0MBeyFtL6MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uoFxrilnqalAoPThWd2aVPAo408gdNvMZOhaRi51L4=;
 b=TQbdi8xXQ7bMWx9u8wrv2g9ZLyI33nEDPvElNc4HLh7WCJKPNhP2cGv7XSpBdGTSArbpp4gf05A6XZtwrfKrAcGqpD7LXg+FL0/hyBF6PdI/XEAricLY/4oLm7+bWOu7bBcE+7ozp18HbOQV20uu/N/QX8gFTBL5bS8B1TbuPDeKR4fGdMdPZc3iz24qoKoBekg9SA/vE/mzqJ1E+Dah4SjfWMPux88yb9XHKjIMZ/Ds3lmW7K/ILL15ag5/9v5jBevcd0cqRIEnDPMJjOh1jhenEhZSVb/iTRveRohyxmOF74R7BqUQ7idoprKKgIppGTEUgoB5CKOYaCFknRV3ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uoFxrilnqalAoPThWd2aVPAo408gdNvMZOhaRi51L4=;
 b=FgZEvFpPGq0/SKXYELHrpdDPnGNo5P2tUxPrkLD9r2eGGG8L+KQCMmOM6dH18MZUXshkXniiFQ4m0Yr2S2iI+7gPmUXfL9cc8iUaPY2NFQva3qtMNvaxT9Qo1ZUkBJLBV8RuEx5qzIswiYrx+WN9Sef3JFOpAlDoB7wYpYT9YI0=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by OS3PR01MB9707.jpnprd01.prod.outlook.com (2603:1096:604:1e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 14:12:46 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 14:12:46 +0000
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
Subject: RE: [PATCH 4.19 00/39] 4.19.278-rc1 review
Thread-Topic: [PATCH 4.19 00/39] 4.19.278-rc1 review
Thread-Index: AQHZVzfuhR3skiOhnUWjVQ9NMNaQlK773mWQ
Date:   Wed, 15 Mar 2023 14:12:46 +0000
Message-ID: <TYCPR01MB105881FA616DC8A6623140062B7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230315115721.234756306@linuxfoundation.org>
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|OS3PR01MB9707:EE_
x-ms-office365-filtering-correlation-id: c554a381-f43c-4cb6-fb8a-08db255f59ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qMWueu+NWEaA70JIOEHK8iJBNdQfnHr94Kczm1EJJyOj1MmnVdIkv2S5ZOeXtHCZYoDme4D7pVXBsGOtPykoQJUYg1E6Si3zik2CDC1PKD9pnzUb7r28wCZZLbtChxnD+h82t8dYTjUOioHCUog24hlcgIsqQDAQKRfBjJ8jPozebRbw5YuqNGqrkVCxHP4ZjmSe07+UMFBUvsIBHQd+JtNzCqta5iThWkC90dzVefVq7rK/Dp1PtNJYKEJVeOaMlPefuq6cgibMZQyRqQNuk2d3PHpjc50mX/3ASb3rBhSjZrPpu1s67us6NvBxnF9UIkpcCU8y3uZJ9M6xLKtwsa3VU5mnRBcI720jwfB5BdN5AO+0HvIFmlL/KC31Xe35nFzk40RiEMmNEnS+TYW1g1HJ84O7i30IhSFh+uDAldR/S9iIY+N1MBXFDFboleyEHvv5b3x8i53P6kGkb9SyRsvEnx40ngaDfZZ0v0z2xFFN/bQY1JlJumeuTEXkfXzJcX0Ve5lpyR1y51iFNTYcpRlzwy1xUZr18PqrG2GuHN4j02dvGfYTRUFyxfJmh5jOTVJkWIzUPloIUxAkM/cSMd/eC+UuVNTqalc4IrAa56PGO+XEmF4/i3L+V8/JuYkupJXUIamiHzNz22NfuD0KnOoA5EucWgOTxIFa2wJtSqvqeeCrX7Ywd40Bri65WgY7nyRcV0CmRe0FvrmSUwBjHG6FgNrWkGvkhMlb6nTaMZ8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199018)(7416002)(52536014)(5660300002)(2906002)(41300700001)(86362001)(33656002)(38100700002)(38070700005)(8936002)(122000001)(71200400001)(478600001)(66476007)(64756008)(66446008)(66556008)(966005)(8676002)(110136005)(66946007)(76116006)(4326008)(55016003)(54906003)(316002)(26005)(7696005)(83380400001)(6506007)(186003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?LLeuVswBMhEjS4JPwuRasQ8ei5hvlq0dIvFQSwOBcRoWpFeOH1w2aRCH?=
 =?Windows-1252?Q?4Yc6nj1Il7vOcdkbxaJyyxGIWKZw2jcGfLSrTBjAExAC2WWDVj44JCLP?=
 =?Windows-1252?Q?UCZ72478+KaZtJWFln2tyPhvwUNc6XsNtWjWuaV09pcXjZJgyobpg4b9?=
 =?Windows-1252?Q?VTfPsBMhziVmPyVaRouXKejMAD24orEH0hBYM9Lk9eoe9sL0Dxeako/m?=
 =?Windows-1252?Q?YvoMamKhUIzlkCQmiqsa+rU13j2tB2z3tEDkWXXDM7gFRYPk48QpVgVj?=
 =?Windows-1252?Q?34i35Cy+y5lprdJdVx/zUj7Zfd7rPVm/YFe7MjXnZDfZUENRHN3zNUwx?=
 =?Windows-1252?Q?9vJOvoQq1OpjLOoBHjeHSPLO4N3Z6ZVdWjqb+EdxNkar32nN7TtW0e/1?=
 =?Windows-1252?Q?lMaQMflOT9TpRFe5IsDPnvUrZQrJGnrb+6qGoyissRlZLVSK8CiwK6WN?=
 =?Windows-1252?Q?ElVvR1XmoZn9PSwJIlDOVsQr6nopdI8L5lMA9ApNl4Df17cK4GjP0b3X?=
 =?Windows-1252?Q?HtqxPe4+94BcGO1tEkScq/rnZFxpS28EPMqgadh+rE1JYVJ5sGm3zzyl?=
 =?Windows-1252?Q?d5J/FsK3sIsFRkAKSO64igmu278Mcs8ETnNDpYC6vHpzbN2Tg5jq/m+I?=
 =?Windows-1252?Q?awI4qH9JuMLxNoTvkNseNcnZoDxUw0AfyNto9gxCHqf8axXmaBuPkn5+?=
 =?Windows-1252?Q?/dIXWkYdYfxchLukaSeOwZS6egtfuMzdakQLtItAr2QW6VEAmy5cKdGJ?=
 =?Windows-1252?Q?3G6UT1s/FQ27R/EipUAwsexb29nQPggJjSOv4I5UopgAi5r/T47PCQfH?=
 =?Windows-1252?Q?NpnTZBRW6AVPA78RgFMlNPWTp4b0s5jBe8lkeGWukbjrLe51Ww9ovTp2?=
 =?Windows-1252?Q?ibmb1QrVC/PPG/uHqkeb28em2X2/OkFU0Xh6gtCvl0GlVYslRI/JudF5?=
 =?Windows-1252?Q?FVVQ+4NPdlKZ7UikFmtGXS4cTxSGy2Nv4qXlFSm0qlx/SwXpLIK04J1C?=
 =?Windows-1252?Q?RK7lBfpBsWu5ZLLCisckTVbz9sCytwHignQ7oInIsAWxKq9+ilggdB3h?=
 =?Windows-1252?Q?VsIBKN0Y9i3uG9lKjsGmyyLkadZAlAS9tklzpMVgCJWU30u2Dv223cOb?=
 =?Windows-1252?Q?Z0R0IkS8WxH/FRl8ML/flW2x5Bc7K2gdEhtzlM+cVdnq3UvB52Jiy6bq?=
 =?Windows-1252?Q?91k0TyD/H/D48zvIbiD1vIoVqbA+9Pue7I4ixDKeURbNRm1coZsWZZfI?=
 =?Windows-1252?Q?6ptCz2PGYJvxId1ko4yWLE9AS0UmkNtKvrcy8cZMWMxQcjV9kyVxcj9E?=
 =?Windows-1252?Q?sycUZr/5uLE9RvwA/7Vn3OMPXfJwpW/LcU6P8z2aYKfQeDLG7iWRp2jg?=
 =?Windows-1252?Q?/OcdAcFyLdkyhDqMymgJCk9vYwRh5T9P3gDLP9UwASDB2YhB4DxRDy/x?=
 =?Windows-1252?Q?XGxikrq+LXdOkLQhTEoCQRGRPXSG4TB8QTQVIAMwIoeK/lwQ1pW1jKdv?=
 =?Windows-1252?Q?avflZeWNmKdQU/8zn5vX1vyk35SIpSRDoo3zhD4OIvbFSkm8GacMkxMB?=
 =?Windows-1252?Q?WYL5o0MLxOfGcPBfxTMdzd3+aDP1OyVIX4BRMd0ex8bsfVHTY0EZJTgw?=
 =?Windows-1252?Q?P+oOS317TiqHKcaohpi+OHqmhnvxktpotQzFIxT00kuBKsbMl1Nyokck?=
 =?Windows-1252?Q?hLLXBDB7ads99hQF43p0KUVuNIwz0hJuCnKfyQAoNVU0Mnfe47GEyQ?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c554a381-f43c-4cb6-fb8a-08db255f59ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 14:12:46.3609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B3JK4iAiV4fDkfR9bD96xDL0mJS4P4lgPC9l2yN0P3Ur+6HMc6pMKJmmLUDWYIBBo9lhVMdCGywnQX6gyPCvK4BWy8wwLC2S7DDQTD4D6sM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9707
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
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>
CI Pipeline: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/=
-/pipelines/807195668

We (CIP) are seeing some build issues with Linux 4.19.278-rc1 (7cfb8ee7c98e=
).


1)
In various arm, arm64 and x86 configurations we see:
kernel/cgroup/cgroup.c: In function 'cgroup_attach_lock':
kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function 'get=
_online_cpus'; did you mean 'get_online_mems'? [-Werror=3Dimplicit-function=
-declaration]
  get_online_cpus();
  ^~~~~~~~~~~~~~~
  get_online_mems
kernel/cgroup/cgroup.c: In function 'cgroup_attach_unlock':
kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function 'put=
_online_cpus'; did you mean 'num_online_cpus'? [-Werror=3Dimplicit-function=
-declaration]
  put_online_cpus();
  ^~~~~~~~~~~~~~~
  num_online_cpus

For example: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/=
-/jobs/3938632173#L1274

Presumably this issue is caused by "cgroup: Fix threadgroup_rwsem <-> cpus_=
read_lock() deadlock", but I haven't had a chance to revert and re-test.


2)
For arm_multiconfig_v7 builds we're seeing a some errors when building the =
exynos5422 device trees:
arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR (phandle_references): /th=
ermal-zones/gpu-thermal/cooling-maps/map0: Reference to non-existent node o=
r label "gpu"
arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR (phandle_references): /th=
ermal-zones/gpu-thermal/cooling-maps/map1: Reference to non-existent node o=
r label "gpu"
ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroid=
hc1.dtb] Error 2
make[1]: *** Waiting for unfinished jobs....
  DTC     arch/arm/boot/dts/hi3519-demb.dtb
  DTC     arch/arm/boot/dts/hisi-x5hd2-dkb.dtb
arch/arm/boot/dts/exynos5422-odroidxu3.dtb: ERROR (phandle_references): /th=
ermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node o=
r label "gpu"
arch/arm/boot/dts/exynos5422-odroidxu3.dtb: ERROR (phandle_references): /th=
ermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node o=
r label "gpu"
ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroid=
xu3.dtb] Error 2
arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb: ERROR (phandle_references)=
: /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent n=
ode or label "gpu"
arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb: ERROR (phandle_references)=
: /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent n=
ode or label "gpu"
ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroid=
xu3-lite.dtb] Error 2
arch/arm/boot/dts/exynos5422-odroidxu4.dtb: ERROR (phandle_references): /th=
ermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node o=
r label "gpu"
arch/arm/boot/dts/exynos5422-odroidxu4.dtb: ERROR (phandle_references): /th=
ermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node o=
r label "gpu"
ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroid=
xu4.dtb] Error 2
make: *** [arch/arm/Makefile:348: dtbs] Error 2

Log: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/3=
938632189#L8634

Presumably caused by "ARM: dts: exynos: Add GPU thermal zone cooling maps f=
or Odroid XU3/XU4/HC1", but I haven't had a chance to revert and re-test.


Kind regards, Chris
