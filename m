Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DA06E66C6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjDROLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjDROLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:11:15 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2112.outbound.protection.outlook.com [40.107.113.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0311B1025C;
        Tue, 18 Apr 2023 07:11:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cm28c2eY3Nv8qwCK3wxj3ZrMoMnLFPdtLXxdmASqPxZUToErQvm3S8jeRWJH2NMvUPb2VztQqZK6nh0hEJ+k1AGSkN+guY4GZgbafeDnDmGCZPmDfYjcQE3LF84dVnIl20UvxbvJ4rA0YxnWrhss05dPqiesMpUzQhHtMSo55REK4zuVrP0CwF18HeRaIPNEIk+/m3ZUuLMg/iBaSY41aE2tRP6CVPgEhiVkNHeMmO2nAHloxkvSAsAktFZblaLETJ7sGlDLJaa6rqtIk29b7Kcva/6ZrBGwj57bPLvXzxf2z/nIGs6By9yUXI0NMpYT5gLWqFpqYCjYEGqEhv6jeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kXx0SJo1IsmBc3/dllXiWrG27OQj59HtM9spSF/uaA=;
 b=Ublu4cmDn2q86atCdKFT86XJbxL+krV+ysw/+GkLFpkD9ocPjyR0v7mCABIHpY6wB80PwTzj+KFn2CdxWDlS5E1kZLWHyczJ0SFamoLAT2CQqmaB9+/tVn/55WsWEtTl64x+fa3M3abolYmq92fF4hrAyYfJH3wbt6Xwg9Y/C1xZZ727JEVknoszjOWto+UzQYbpQ3eTuuQn4wv1nZwslssHuTp0wYZ4yVt3PSSC+U5TUPtxXkDilSfUpWsr4GdjLYzVg/4hArSu07JMDbtvADT+J967nhBxzXUliXB+YA/eBmF9XLL62M54QBtf47z/GXddsN6PEG/Scz00MhePNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kXx0SJo1IsmBc3/dllXiWrG27OQj59HtM9spSF/uaA=;
 b=F+/rAdFiuL5n/xijXLqv1WNQp3x62qawvivRUPYWMENA5oKIdgEv15hruzY3WP+TMYRfMEyC9urWbIgFk9VKbh7W/xdcyCjg0yeoMZ0DFaikfXT3s8ylOYfiPZp62I9TS/72LxJgN0XxXChNIWIpd7CJ6rjQvLT0E8wFvYH75+I=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYCPR01MB11801.jpnprd01.prod.outlook.com (2603:1096:400:3b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 14:11:10 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 14:11:10 +0000
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
Subject: RE: [PATCH 4.14 00/37] 4.14.313-rc1 review
Thread-Topic: [PATCH 4.14 00/37] 4.14.313-rc1 review
Thread-Index: AQHZcfCtGpcmBaAPR0u9y5HG+ZTs/a8xGw7Q
Date:   Tue, 18 Apr 2023 14:11:10 +0000
Message-ID: <TY2PR01MB3788BED0AA52DA3F628B804BB79D9@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230418120254.687480980@linuxfoundation.org>
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYCPR01MB11801:EE_
x-ms-office365-filtering-correlation-id: 12f623f8-f058-426d-df75-08db4016c2d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3LbS1rkSXAr6ueZ5bURnQcx5nv+8ODA7LReJSoUJ5eb2+tW1WUsG+DP1bT6r9Tv15HyurLb3V6iMJ1GhS9HasxLEIEOTQXAd8oy2Lm1YEIdfByaiRb9GyC5WV2evf2sNqdyF6bZpf5g5/dqssY98YNBcyL18bBQtq3A2tmNVQaN4bw6xSB8CS1C9EA9t3tsMYdCQ1qAEeyNMTA7ZFMdc+SoEA3DqBZrfarAzxaS8CI/qjY2iY4J1tTD+5fOtZgZJS3Sh6zWxGHG+QHPyppW8jivq4iYfNJZWCZI0HidLR9HDlmIXbK77SK7ouUImMXDm33OOvqpVOYMip1/5LirhyKEGL6P+duStJ+CZaTNrlOqcXLNM4mH41ydNSpbD5tytmWECc/mMyIpHCyX31ejM2G/JB7Znq8v+ZQsWMHwoIKQ3k/1F2m4hvybWzR/iK6waLpbHvWeygE2ZYNbibEEIXwfifKVhPMViX79pMmzQC8+JflxneL463RdHQcQdRXGaGsbSZ/Z3dIAfPQobC8JpDwqel7LftX3VCpOa8I5mjWZL3xeBe0KjcQoGueJThCJaDegJQsNGyFhxDYELW4RswcZGC0/H7x20GaeDi0cWNzBKixPC1l7ozIbnylH4ipEpoFMt08vTQeVfPlPKA3XKPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(66556008)(4744005)(2906002)(66946007)(66446008)(4326008)(66476007)(7416002)(64756008)(5660300002)(52536014)(8936002)(316002)(54906003)(55016003)(86362001)(76116006)(478600001)(41300700001)(110136005)(33656002)(7696005)(71200400001)(122000001)(186003)(26005)(9686003)(6506007)(966005)(8676002)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?fpIBP5FQBGAK8+a7+Q/lbXzClhaj9Ycw/kRANhY/S5hvQyIMeXYS5Ktj?=
 =?Windows-1252?Q?ynuUKVej27n4fu4Rzx/LlOMwQBpaqAgliCcdbAGniPyzBbsXMXIEgrTD?=
 =?Windows-1252?Q?s+Em9PsUw4wmpZYMXk7NSmKHWuGJFuuuA+HUWIjfArRf+GFuqUGNvwYt?=
 =?Windows-1252?Q?pf2mIZyRBgtTslAe6W3BfXD5+91p5vDjdRSA+NmgSm/obl7073l5/uv4?=
 =?Windows-1252?Q?pdWzZSFppnExDZBkcm3FihNZfwanTrvlkB0w0ECEhi6Sc35aTqgfypnd?=
 =?Windows-1252?Q?f8SbpqULcHkpRC8q9uqV41KltviEBiv89tE6qvhHzbOH64vTnPzMw+/y?=
 =?Windows-1252?Q?jagJIAswVNaiZaToXFQ9zdXB8h5kQeAsGaP7n4sahLzmX+lCyUevW7WL?=
 =?Windows-1252?Q?TWxVXYsmxyRNsJFx3znvtSMag5Rj5yOFTjQ+cIN4OmREz1hbsH+GChPg?=
 =?Windows-1252?Q?a2cc4G8KdnwhsvX7J9ydTalBVZFJRwzrTtBZFMCo2S+lw0lL/K/JGm4b?=
 =?Windows-1252?Q?4mXpMQjc96gQdr+ZrddG3QH6093+ZP7BQ2rRYpoAmbq6u5oYhWYhM1EZ?=
 =?Windows-1252?Q?jKPPtoOQysoS8VGsvLPqlS2cuoqFdhRhqMcDoUfXaXuAo+SO5P041QsX?=
 =?Windows-1252?Q?yfpiLRF3gTyufI3jT5l3gwTl293lAgfNAJ3TyBnG4B9cft+sN5DpAU6l?=
 =?Windows-1252?Q?rNSmj82Fjw8duh7fBhfqqSpvAG9yhrPCPJT5IkpCm5jDaW5H9VOYASra?=
 =?Windows-1252?Q?bv9JYyo3O5ZHCxiExIEYh+e5u3jBOCUbIPWw5D8s0TNArwK9zDd94iTz?=
 =?Windows-1252?Q?nyT+d+bdMsRhNdYrsVLbAAwsN8m3T1MF0XKkYmF6+Kmq/Ng1/FYS5YIY?=
 =?Windows-1252?Q?Y1f3X1NNxX+XJ/ibHKUV+RrJC/Gd8PYdvmU+9PimYQHPzQs+Eisy1XG9?=
 =?Windows-1252?Q?SzJBu1tNbQQcf1B8OScydbqokR20bH1bVN6pBD6vc9Z78DMYs3LFtIts?=
 =?Windows-1252?Q?4MFIQQwuAsDNpur4NJrhFZrXTk5fG2Q6Hq9ki1XelSUUAlANx3s/QOmR?=
 =?Windows-1252?Q?93Svlp52/CmRh2i57VXXlPlwR0Dsot2KfQYVhlKtt2dPZV4kWY104vBp?=
 =?Windows-1252?Q?TJtDxNNncdwQoi6n/SMfGBMdvv4CpB4HULuRQlH/uMVCa4gRxd3I8/jT?=
 =?Windows-1252?Q?SrrYfvkRKZoHZpyteXYXxOGvXvYX112IromTUHWL+9ugd72rj2UCZGFf?=
 =?Windows-1252?Q?IWXz+CGov7punKb984LMTgy8rM+ziUlFEi6cTHWZHY+nYlo7AoBvrONK?=
 =?Windows-1252?Q?k4wzbXdbgCnhYlBrCWxgNgAfSKAileDqd9hpA8MaKQ0UTa7gafRVoPqq?=
 =?Windows-1252?Q?JWfSLXgZ4sCeKD5do/nRx8YCseTHNIVGqdbRk8B5fSRDjJzU/4/4Q3fz?=
 =?Windows-1252?Q?cC32hLHp7spKkcKC2r/zkJtapKY2aBw3ihaAbHbJ4qXrifVuW10stNry?=
 =?Windows-1252?Q?9QyVXAPK7nVZht79jc4v9gqWl0LUvOs11ZgUXIeBPqcpmHrTyqx1Thme?=
 =?Windows-1252?Q?ONRYnxHmwbSKo+umY3nbvnujdIuvuKrBMCMv0d5h0j+CqxKVcTsMEDRj?=
 =?Windows-1252?Q?DVoAwci52uj7PbZBF07YKz9j7fHri+jq7oCKmFOsx2mWdNp5NWpuoqWI?=
 =?Windows-1252?Q?3cGpnkqmE9KzNtWjbIXbmQi23pDK8E2t+SjKAHlaFNBlnJ1BLGgzUg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f623f8-f058-426d-df75-08db4016c2d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 14:11:10.5094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t1JFUqWDPhyHAYYZ0fxHBPm6hXkuegxSO6Xmio7AfOd+YjB1X6JTqxIn4CBx5Mh46DhQWB+wB5m6wFsVSzAvmsN3qCjYq9pPeggn/PA8VIE=
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
> This is the start of the stable review cycle for the 4.14.313 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.14.313-rc1 (cdc53f89dfa8):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
40769024
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.14.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
