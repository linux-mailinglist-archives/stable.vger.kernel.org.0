Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D01D6BB541
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 14:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjCONzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 09:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbjCONzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 09:55:09 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on20712.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::712])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAB038652;
        Wed, 15 Mar 2023 06:55:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POO+Jh643uhHKt0mV1ZkCEs+bVsbydL3vuumT0nPgG/oIklGSLU/TvmRDZpcK14pY2H410ev4UsVm/CDPayYRpZWW71zIByQ64Iqk9NL3XRUlwKIQPF3gABgG0V0Zinb/mc5i8Sg0jztSFPwhrewvRnSYiCcYJz/CVblun4KdCsCe/sKQHSRU++o3lIpXUy3rfK3WZRcLJ//c+IsS44/vGrFrU2dhUtlw9lbY1ZJA7IIiRPk9dzAwy5h7SkKjy1OTpkBQgNC9vKm2pDucGL+JOHCcBnbBgAErr19UZY2bdZEmoj7urEYNAVwMvkcD5hw1COWfXIXwg7yP0xaUqzRww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cG362mOuKw+rbNGCzHf//9QXI/jBLWh2913Pc4ENtU0=;
 b=agTzCLMOc94wex6q3amV+45u4tLUZ2P5Acr/NexGSvctvfmeu9l20gtIzA9VN/JdM44JySIo2G0miQpk8LrLF+4+Pb39nk9RRJqZh7MsmfK5lJ6sABCPeSxIv2WOj86fcV5qJGFp/oUj7kX2eGDpSdRg4cJ9an1crB2xk/A7ZCcN/7VPMlst/vyF9Rgy1ywOQU664N0D4MKyBEIXEhaNlsg8Rppm30CMBHJe3mLW9lD+SgRM4ZI5WqgOvnFlbnkBaf67JlO9tQO+k85howo3cGjWbF59TU6oF10P/VNal80nysKZDRINxz6yjCMzzg+bELoihCxHQ0MT/QGdacKkPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cG362mOuKw+rbNGCzHf//9QXI/jBLWh2913Pc4ENtU0=;
 b=bRYpGiR6L+O95rPDo/6TRGXaUD5RAFA4D5/50ArG048+vWfOa3Kc+UCh7XOqyuSvpVj3S7gZnlrBh5X4q8/jFVbQ4skk80Yp4fUwfoPlBG+jHGamVdzgOvx6cEqegg9Kx6XPfFQnNILl9BDu49nUtDyU4tsaXUOkzQ7roUfoTI8=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by OS3PR01MB9977.jpnprd01.prod.outlook.com (2603:1096:604:1de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Wed, 15 Mar
 2023 13:55:01 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:55:01 +0000
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
Subject: RE: [PATCH 4.14 00/21] 4.14.310-rc1 review
Thread-Topic: [PATCH 4.14 00/21] 4.14.310-rc1 review
Thread-Index: AQHZVzfV6/eb0jknbkCimRmYoxhXlK772+qQ
Date:   Wed, 15 Mar 2023 13:55:01 +0000
Message-ID: <TYCPR01MB10588B1641FDE1D7718BA523DB7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230315115718.796692048@linuxfoundation.org>
In-Reply-To: <20230315115718.796692048@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|OS3PR01MB9977:EE_
x-ms-office365-filtering-correlation-id: 14618780-b72c-4e2b-fe1c-08db255cdf1e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sYBw4VKybavXSColfHDAqOVGMUZcmpqCJk49o8UGe6mtck+27cAF8Sh0UCBfqoDjk3qyCyXP7IKoaVAjc/Oy5seQHqZzvbMQVBXgitJl6Hu+qgmL8Vw+6MGhM+sX8YLpIBzqTP5VRrQFM/ByeH6FgEAlZjx4T/lbLY/nUmoTydg0K1Bw4UzThC223Tmed4Rnmit5yCMJ4l2lf1DuZaVZb3HQ1WrYUqrXODoNsEycRVSibEqO9XObJ8Lx7qYeaXrfWs+z+KXOwqCxRRtbCMnjUrs9+iGJvJDvgc8kOuZnCiDVe1e4/gTsIILqTpzFmGGINneTTBIXxJaFNVTT0Gy1VPzWK7oxtGwbLq+WFhzW1ThZwLKL6CV+GiCemtev6l0cuSgIoBqWU6VxWFQ7GISrn+H8LgFZrRjkzHK5OY5lfw09aF7qkyZF1t/T0gQ3pp0tDgBo+vMlC9AoD8jng4P7S324AQa4tRaQxwuY5cA9e7P4HoYk5uVsNDCt2TiVXg/OKiivw0j6tJMeNOSGIq2Gh3O87ZVUs3k0BVK6EYynzk9N9HcXKmTc9O/BLsnO0uyEcHniXWYX3JrE1czmR6MGThy30+SLgRULUqc254oqCkUr7qBPVpRWxKK48HcbR31R/kBH1/4RxUyei+r5BGK6LEEATws74Ojfy5MmDv5JH1wn3ufWxWdOvRGUR8bPCOsot7V1qacpYdyvQaBtZxnU7oja2qA3Qoi3VMFB7gEh1hI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199018)(33656002)(86362001)(38070700005)(38100700002)(122000001)(2906002)(41300700001)(52536014)(7416002)(4744005)(5660300002)(8936002)(55016003)(4326008)(186003)(9686003)(26005)(6506007)(54906003)(316002)(110136005)(76116006)(66946007)(66476007)(66446008)(64756008)(8676002)(66556008)(966005)(71200400001)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?yy3iuUO7dUcwO0Iy+lk71tSPsDk8qMbPGrg5L+zOzjWGjsJY/C7DT+HQ?=
 =?Windows-1252?Q?Yc0YQQZ2egl7MPcGj9B00vU0YEMwJdQvwXexXSLlixBmhkc/6c6kocIr?=
 =?Windows-1252?Q?DkXWxZcdfz+LbgHLbMYGsstr47Y6NQSOsV3Tr8ANGExObF5Fwh2eoclQ?=
 =?Windows-1252?Q?foUerbkey4Eq8LXDgAi/FdutEdq3p/GUteX9c7e/aWh+2ISZXU74fp/3?=
 =?Windows-1252?Q?ZHBmuo5xjO3YnID6cQVKAguCimS04AAaGSV+hFt+Fq0ASlLpfg99uDJ7?=
 =?Windows-1252?Q?pyIJYBFJ1K7yWPn6FX2FdewXY1gOknsei98x/P8Gds/6K8z7SVkew/YZ?=
 =?Windows-1252?Q?dPP7g11fPWnqhrBW712hmVL2ycsrTZeMf2c+8tCGMa8lNEI8cDsN8KlY?=
 =?Windows-1252?Q?LacM8qO0pMltIT+ulHnDELMKjd9zlJ287i0ogR5oy1L0PdxlKqMEhFV2?=
 =?Windows-1252?Q?5H1u+eQHmIk+6sWNxfqVma+U1jUblXFOmvAIDCtoK5ymVs4g6V8LWocI?=
 =?Windows-1252?Q?vPIhE1Qry5F+y+ik312cZEzuTAdzNonXYS7IfRbmElwOmfaLjXHFI3pB?=
 =?Windows-1252?Q?p1RCUoC1YnuzJxrARoeyMplO7yhpXd2mmleQDztzeZj1tgbijlLYzbZB?=
 =?Windows-1252?Q?GyGtzDMHU5boKjaee2wjwPE+frA85s3YTT/sLQEWUeY2HoHM9TMIJQsF?=
 =?Windows-1252?Q?lPGapj2tqxy10YlLHoQrUIB6+9zKCh3CAD6S5UCaqNRziWQwgbQMjPOq?=
 =?Windows-1252?Q?OgjKpu/jHfnXaxzihUDo+uTukxuO/H1nggvVV6xHn92B4Vd7XqgPAwBN?=
 =?Windows-1252?Q?PUKuKJKWAefO3U8QoLXHydM7Zxav9OOE4dVF8gnHnOfLaiUefWYm4Ell?=
 =?Windows-1252?Q?N+fXlDgZBJsQJ/hpsfdx//8xmYNk8kHfrWDS+3vpyf4i/DmeHBsNYSvp?=
 =?Windows-1252?Q?GckNnkNHkvPp5JwD9uJcGgHKuFJeENIN+gbeYPC54QcuNRJo2uCF1S1Q?=
 =?Windows-1252?Q?udlUBO/h/1ZnaVwjU5ud9GmKZZ9lZr4mHaL37h+OB5qmX+aP4ls1G2xz?=
 =?Windows-1252?Q?pTVUAan+2Qk8pqoVmgDerQv4b3mpoavH4U/7HWLP1t0E2PgYqYIwoaxj?=
 =?Windows-1252?Q?HZTARnfpHVyGhOGfOCY42Sh5yQU4qd7WkgxJoL+Sfy8hsY+zM26K4ruP?=
 =?Windows-1252?Q?sn+yavdDAPtgwq3d8/dmYJBXECwhWZZBeKaBJSEWP84GxF+xHPLb9EJS?=
 =?Windows-1252?Q?um5F0t5ANgW3SmnhBwhqMQy+H7GRk92JmGyGYNbsHGDdKCOs7o0iMxuy?=
 =?Windows-1252?Q?I3YgsshY1DXKcE9wuEKdWWafP6P1ueVmlMmIuf8HKx65swHcBNi3Ob9f?=
 =?Windows-1252?Q?BpI9NKo464LDFYmhk/SeJGUD922wdZC43mQqZ4k1RtyJGP/xFmhW4ZjN?=
 =?Windows-1252?Q?Bnqzk5BeX/idSa3UQYmT1UIX/fuFAxL0kS4Vghp8Fyn8Ifb073F7Ukgy?=
 =?Windows-1252?Q?+zMRU7rrGIiFuxD1CkaYfQaLVQOtc+h9rvkh+oFSfjGy43AfyH3rWSVx?=
 =?Windows-1252?Q?hviW2O17vsi3tL/BCbj3Z74lLVJ2xiyJ11C8o4NfPUC3Brae40NEMvnd?=
 =?Windows-1252?Q?gf2fnsdYWSmWClI8TWtfWUmfCwGPesn8icSpqgX1ZrGCSWA3nZsBrgpO?=
 =?Windows-1252?Q?nYb3DEoczPF1lym0qMbv6Qt9iNuA+oD0EbgBf0pa/s2/dzM9xV09pQ?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14618780-b72c-4e2b-fe1c-08db255cdf1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 13:55:01.3470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FetKq/ToQOM+lySgr/Tx/y+JjqbE4lrTmAyyhTA05NZBGwM8dwUe+b/Z4/a5VBGOohRMqnWmRaBxRFMrtzZr0VWWNUM1h3aWqnoYcqSx6jA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9977
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 15 March 2023 12:12
>=20
> This is the start of the stable review cycle for the 4.14.310 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.14.310-rc1 (1f84872fb75a):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
07195539
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.14.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris

