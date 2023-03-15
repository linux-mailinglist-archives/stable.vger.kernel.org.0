Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A7B6BB563
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 14:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjCON6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 09:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjCON6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 09:58:17 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2098.outbound.protection.outlook.com [40.107.113.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775C67C3EF;
        Wed, 15 Mar 2023 06:58:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epPa8aS1bmGjgsD/KCnpVn43MKhtTDRYj4FAeTjeabWMN/tuXVwtIU14+qxuBZqR4bsIgald88+KFasJsRobwOUErgCrMgjhHUb+PRLoYktH4V9kir4YM7J2yDGzA3jfyzGQDXN/Vnjr8ue6jMs+n58mS0FDs6ZYwGxtHf+LBBX89iu3/FOZnbXIU+f6kiYqIFygjAJZVmgm/48chPMLInzB73f9/uPKQSSfKF8sFHYpP6YJDa+II5fewTsofeOfCN3lJs5bPjEGLLVqqn4R6FFr/l+2Zhk67yEuSz0sDHGHkqQHIMyiCRt3WkTPlFzI5vOri9/w5EARuk4XM/FjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUzMCa/NaflgkDps2qNyMJLFHd0hlal6rQrSiaPCcdY=;
 b=GWt19d4GCB6lcekkxvCh9EX6pc/m3ifjlYx95Er13bYvoZE5X9GliuLZxq5DfqV747YXWjN3crVqgQeHDcbO1uxpuR2z5bd5NrH0lgeh/e8FBaWCfCqOLeMw5aXK0+FOGo4ChqTsNyLOAkT5vkvR7/sK6LgOwl99laFLo+2+8igu1oy2/rpA6nzGfzLLnqEZku1czwzRS81nUAvGYaGP1qjisntEKdTTQvdMBB/l+5K5TPIVtYD3v25yCknsepyaZlPRzwb0m6175Vuvnr4aHyTGYYuomYzVG/t3HKwy2w3yMXy22o/sg1kbZshYKCzPAAyOz/gLVVv/t/E0eHYpRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUzMCa/NaflgkDps2qNyMJLFHd0hlal6rQrSiaPCcdY=;
 b=VK8hdj8uIXmF8OVYcck1VauF1KheCEC69tRS9yZW6vahBKyUq0oiTNsh2E/aIohZcvhVg5Cu5nVR1nJJW3/9KndqNlk32NQB0Q/kBBJEYhMuCAnawzq/YYMQkAXKL68XHbLNtSAa1OqUHvB6pIfgB+1kdYirNgkhRD3Ha2Wp99M=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by OS3PR01MB9977.jpnprd01.prod.outlook.com (2603:1096:604:1de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Wed, 15 Mar
 2023 13:58:11 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:58:10 +0000
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
Subject: RE: [PATCH 6.1 000/143] 6.1.20-rc1 review
Thread-Topic: [PATCH 6.1 000/143] 6.1.20-rc1 review
Thread-Index: AQHZVzo+UOwT1J1T1kyNNdVffKXEr6773ZEQ
Date:   Wed, 15 Mar 2023 13:58:10 +0000
Message-ID: <TYCPR01MB105881B3B783FFB4D0E98E056B7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230315115740.429574234@linuxfoundation.org>
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|OS3PR01MB9977:EE_
x-ms-office365-filtering-correlation-id: 335804a6-5455-460a-da7b-08db255d5024
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gIp18Im2j0X0/lp87D5uJOVTHKUNUaSEnOii9EYheShbrhGAFa58+YFRMCr0V46tmD4n/hps72o4NKPXHat74ISwulB++s7B4+YPmEWFlZW4V+524WajjxlHpcX14R5VaZhx2v4/52csZmyvZGhBlDGy/ScXjRQTBhIcgkGR69KOQMn2iIJP/dTtMct2mw/SunHnjWRox8vB2feJbm5uLh5kfyWoYs5kJKVyeznc5ULQZAqOH29/KiTIBgDEL6IQXmytlc+yLeeOe0sN7pvMLdfxeMVKmXcmSRT2kM3qz45rjSYcSLLxajINmCQCyzd00nK63gGhjAnlzf0SSe2FxbHxN5DaP2jSQjJHuHwg5RntdKCXTA/DDUh7Bw8hhp0dQDWn95wa1fVmS0Pziumsu2s8yjHJdydK95VN1Qs+Jj2MO4avZC2NSgotMR+K/k56b31wijmyC05rBU4u4SBgvR+LOOpzSfvRlRLGKvE8IxPYmFsuOjdDBrgiF5XLh6GWcugsetqNtwWQHIO/MmKdSpOPDm7rgkkC54+zSpRcrl6HRhqb3Ytl6UBYdGWX84jl8tsYnap3gtNSHrTans2zX2mWFPaiel9y/26FHUY60wdRLPfSj70GqNGBNrvkD85gMBLV0uTaZAAqKelQ8LholiV1IUNDVLkoGohs7OVuE3lSwEPLhc2aqgqKBx/gKtcEsLh1n2uB9/l3nfRIV4QuOwBJLjyiSWs+RTrPHvzQ+T4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199018)(33656002)(86362001)(38070700005)(38100700002)(122000001)(2906002)(41300700001)(52536014)(7416002)(4744005)(5660300002)(8936002)(55016003)(4326008)(186003)(9686003)(26005)(6506007)(54906003)(316002)(110136005)(76116006)(66946007)(66476007)(66446008)(64756008)(8676002)(66556008)(966005)(71200400001)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?ZeUsuwqzivN4zClIOTGLBRb3GobS/QHiEsCirJiZxioVtrpGrFjqiwcDT6?=
 =?iso-8859-2?Q?L3MmFHdD74GaoJRBQNgk3eatoZY3g0CHKoB68VkR4Lvl8MX6eUQS7gPWvW?=
 =?iso-8859-2?Q?IP+mlBe8sw3nqAs5axWeRAolHNkn1E5oZHz/V08d5jPxQnSKBErpZVXTDK?=
 =?iso-8859-2?Q?yHI69jZ+VSaQhB4PYVtZ+DGsph1C3lIpWZx6NMFo6+3Xi5vDObymMArjwa?=
 =?iso-8859-2?Q?qAVEdH8Pz3lyN8mhaKvmfwxxiTdEdI6B2DBlJx8VGgZMS/QiLcx4MjNsRm?=
 =?iso-8859-2?Q?PefJcCLmDo1IlL+E+Xdl6OgFZ+2HaESDYSpA+eqsIDukgMwFGEgDlhYzZP?=
 =?iso-8859-2?Q?LclrYGNcngYu++VHgrCiCFyv2uuqyp8LCGJsGR5h+recsvX328UO9MCaHF?=
 =?iso-8859-2?Q?PR1GmJnCzTcsvJuff/idnQb7yNEq3Tb+6Z1wQjbe5ApHyqrgEmlIfhpGQe?=
 =?iso-8859-2?Q?IyucQY6LmAIluYd9MvDYv9d7qULO9U0gvQHXV2fLzH7I19WglPW86uSZOi?=
 =?iso-8859-2?Q?1g7SzRtUhVZ32jJomLvXW2faLx9HZQDEUKRk2OVNX1djPVyv61VzAyDMZz?=
 =?iso-8859-2?Q?nwpjYFOZYG2Y6PXFDEHiuGOTcHUlhv3SVrXJYJuaOYQRZl3gwLoKlmz19e?=
 =?iso-8859-2?Q?dp9JomHfHkcOqb6G123sybmNC0ogYpNfdtfBCfLhB5ZmjlpQUamfcbTpln?=
 =?iso-8859-2?Q?8z2bjmM3FwhBYc2kYnW+4R7jVk2t1wbBzW6tpt/r9YPv99iOefw3TL/oKZ?=
 =?iso-8859-2?Q?5+B4swxiP9siXa2qoqI8dEa7gVQ4v4/anONu9pkn3iOrj4vqd/lgwizZOt?=
 =?iso-8859-2?Q?+6Q0RIPygbKzG1K2pJJ3xnnQuy7gApIU8CoAVMWcVtbGP64yIScPfjjrEP?=
 =?iso-8859-2?Q?w0m44ato0QyMDRZW6Z2FJMoxWbDj0nMz1RJ9PbOjOVh/PBupnn2Fp7oahR?=
 =?iso-8859-2?Q?d37Cl3aK+pyGcR7W9aJjOqmD0nA3MkGMeUnXfZbNf3oQ6zepWcvOxTS5bc?=
 =?iso-8859-2?Q?NiLMoUL8EsF4VZmbXSRVUhmiWjCmP37pqQw3JQV61uT7A8rI5Vyu9Dm5bi?=
 =?iso-8859-2?Q?NVJHI1MydppBouA3PtkeuFn/zDttYuU0E9Efa+qG7P3mBcm1kxAJnGWty4?=
 =?iso-8859-2?Q?HCNTaz5v6UZgw7xjQZ6Do4iABJWaiyfUCT7K5EHL0AMEbq3dkHj+BYS4mr?=
 =?iso-8859-2?Q?qOGX2Kw3ZTFrY/ygBXMhcZb29WDVvAKvtOZB+b9ljHL1MPmCZVBR73YtfG?=
 =?iso-8859-2?Q?uNO7to1j6jIgMRsHmKtMMmxT2CMf+BgU6iSTcz98JwFvbspbOERiwq2wW6?=
 =?iso-8859-2?Q?2X+BGU0J0LahNUnrUmZqM3XB+RcZEtx0HAZV7pYyGfiI1wem9vd2+hpQ3O?=
 =?iso-8859-2?Q?xcSG1Y02SYmIJrG6kpY8DvgXUPhtjEP2Ku0+m+PG/8WugFnRksZbYI4DQN?=
 =?iso-8859-2?Q?MNpI1ELcfArBU3N/z2PGoeXw2gQroTTFbl6QBNvRwB4Lr1HxWjtPCfFUK9?=
 =?iso-8859-2?Q?i/ebytY3c9s//LIo6yzrIvITCC891acKoLkGJ8I+UuMrwj/oKuBeqHOeqZ?=
 =?iso-8859-2?Q?UoW5E4MgVH/C/G7Ot5R3j6f6EDdQRzZzJ4vgQA4F6O372OmN1/aTeTb8j0?=
 =?iso-8859-2?Q?cyrJmIw8fy3+B3V/wmcgo6CYUEW07mZe+1aCu87wUud3Pyk3kyzzSKyg?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 335804a6-5455-460a-da7b-08db255d5024
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 13:58:10.9679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WH8rV+Zda7NNFJGX6jjxpSTuGPV5P1d4EGHCCZtdRGWxCPth1LrDRnGwkjmolwETTl+zxECEc757p87qTjqy6RBcTvwg64fN+pzXQ145NlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9977
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
> Sent: 15 March 2023 12:11
>=20
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 6.1.20-rc1 (4b77c9dc7cd4):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
07195824
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-6.1.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
