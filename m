Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E0C6E760A
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjDSJOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjDSJOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:14:21 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2093.outbound.protection.outlook.com [40.107.113.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABFDE55;
        Wed, 19 Apr 2023 02:14:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbJ0peRQvn6aHpbH76Nfw+LU/7zM1sqZPwEPAuY1t+syG+/H/WF6sMjJ0EB1FcnY3mD/uSxbaBbgn7fztMnXY9iakgUZvsQIjKXTknhNW8iy+hQPgGoHKT03dCpJzVuSOlPLgxtDMd3XVC8h9yvKQYc7TZtGTb0dqliGS1klyGWVNJeiDMe1zE9cppeoojkyag4vBsKYbeRYHl3x+7qJscq0WAV0GC3MFW8XQrKBaS1EPPU+YdDZsjEHmEyb4Etk0ZMRnSzsx6hYZ6M4JBrBK8kcSfmC+4a94BxN78VVI2gkpyG92UO/7mMYHuajDXUNimwRR1berQ+LUf+Wt6W4Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bb987isxMWwYa6NW8VC8l9Yh9M7idnzzXudgvI2HmWA=;
 b=X/Xm0t6RIC1TUl19Cw+M+VcQC0k8kh225gqudwKPZeSasF5k3IK+MFATWW8NfZTP12hqGAInUAIziAdNEsKAqbrXF5ajPZLe8D0b9uGSPsawXnTIwxb+fpQ2p0ROHYkVJBLoLv+JC03E3FE2GMQn/O5F61YYE3ONt+5Yof1MfD1vxzQK1+SFj9cX8IKPYx7odZp8DB8fg7vxWOHReNFVs2ye3o/ib9ie8E0/V0Kv2kLtDNy8TaeiKQxFLc2T5lIZKNn9FGc/oekvbWXmgMijb8mgp2r0ulQ1htzM4C/M5Myvr67MO90DDLV0s2OQZrbB/BBxQrOiJJ60peOUnoPXeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bb987isxMWwYa6NW8VC8l9Yh9M7idnzzXudgvI2HmWA=;
 b=aervwaRn8Pm/p4x5Oez3oZLqjLjMEBVlDBUR3R8NW5e8+Zy33MUqWm0xyeI4HUE2/XRWwGWR4Rb62AIHM9Kyh1bY4eEaYXvVkvMPo44EDUQ2qGR+xD7dcVCyTpN11DzJbIdgxdMLnNPu2FVOb2RHFGrL6Nc2Kc3LVUZXMo4VVR8=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYCPR01MB10118.jpnprd01.prod.outlook.com (2603:1096:400:1ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 09:14:17 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%6]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 09:14:17 +0000
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
Subject: RE: [PATCH 5.10 000/120] 5.10.178-rc2 review
Thread-Topic: [PATCH 5.10 000/120] 5.10.178-rc2 review
Thread-Index: AQHZco/yEJfBfBDyXU+uIuchUF7wBq8yWSGg
Date:   Wed, 19 Apr 2023 09:14:17 +0000
Message-ID: <TY2PR01MB378849EE82D1EC8678D7E460B7629@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230419072207.996418578@linuxfoundation.org>
In-Reply-To: <20230419072207.996418578@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYCPR01MB10118:EE_
x-ms-office365-filtering-correlation-id: ea764874-e9cb-4678-1c3a-08db40b6739a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q0/jBBW/dmPlwnrlaAOcFeJNWDhgtwe1CGfOU7u+kdE0CyL5cwDujn1aQsgUJmPSPj6b4oqtFevdOnz69R5YxU/l+QmE3LasKSCOfztUH3RpfZBsLnJN1McBPFdxree2x1LmgdUMw0Z2Zh0DQWylMYszlBIrbzV+7Vl+67RRV3UzH0pGL083dCKmHenCrnB/KyMYv7GuiMI8WYtCZCpiPInrRSuHiMIM7HOMEA7cYR5fZ68uev8M2HboN8FJ0swnfuheYbmS2npTYnBRXeFv2FjmiJkG7pjhpqvtSvg30vILxJ+xED4BSO1yESGZhaalX1jvqUrMKz45axsQnoIfoKeB7tm58NNWmKBB2+g17ogP3j+i53/k0iqarnzfOay87gr3KOiMwFMJFnF7I0ds1/BUWIhpfbuajwk3OZoTpU6YQ/LS61cA+S9wt6hONfa+phJ/0J3okL6PQANiWi+Z7AjhDLSzp2TqqWA34U7pUNkxPAnf0XxwSprvvThdjpkK/Hisn5yfJWdBFXMKhxla+Ff6uDSpP+Mvm6a1WMIpFVc+xTNQcHQPWggPZD2mKgbM56wURIdMSPcl3vksO3mW9zyJbWwlihirWD87dOJYPjfGTcfWyYclw8tWFT3KJDUI5zS8C2oqNb5u7lYTizyhvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199021)(7416002)(52536014)(5660300002)(86362001)(966005)(122000001)(9686003)(186003)(6506007)(26005)(38100700002)(8676002)(38070700005)(8936002)(110136005)(54906003)(478600001)(33656002)(7696005)(316002)(71200400001)(55016003)(41300700001)(76116006)(4326008)(66446008)(64756008)(66946007)(66556008)(66476007)(2906002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-4?Q?Mzu84NGayWjlGgeElpgo+TdPas5VJtzkG/uVy3avciy/s498j2IyEq7UEw?=
 =?iso-8859-4?Q?Syvo+7W6rMC+VmaHx4JnOcWvRFxEKw4XoEjjEfjnVjY88/8xZIP+RPoLdR?=
 =?iso-8859-4?Q?LOBkkQYAPcRlq1uzybpuNjt7yZxcyFr/OS2huwMGKDkTZNbpKyj9EpXxEm?=
 =?iso-8859-4?Q?W1jd8gj9Fh9mhtLiEDv4UptEGC6aCkCZUH/wIIEdkccJp3pg3bx5PaIoGO?=
 =?iso-8859-4?Q?yiN/fgri8Ekh0R4xtZWLNYiE+Ea+BKR3sXHxAK4/12ukNKlkgNVSj+t/Jr?=
 =?iso-8859-4?Q?30yCLwzvTB4H8un9vkDG4qHGXG8xJOgU8VXW/oi1ka4Vbb5R/RVjaJPgqv?=
 =?iso-8859-4?Q?WRebt5dssVQNy+1d0KX58oZkwm1xGk4oPCXHWECxvRy7ITwiPdzRbw7P6K?=
 =?iso-8859-4?Q?l/iTm00ZC10HwGoguz0nXAq789jSDZQ3cJJo7JwtWccncOEw5m2+c9SA/b?=
 =?iso-8859-4?Q?t3idBa7q4+l5HLR8qK10s3m97FRamNd9J2foBaC1otIdsBuJ/NHa6PmdfP?=
 =?iso-8859-4?Q?Nb+yiY50MDDUok1faBlfhZUyyGn3btYfQoPPx5yfMNAKD7R1BNkqNPruCs?=
 =?iso-8859-4?Q?6egLOp332E8YE2A+ruueYbcePLyM5HSHYzqmTiPO1YPHU7JVoYEL3KEfpm?=
 =?iso-8859-4?Q?M+MlGWSZ3EwOnf816+9n8CueXJRRsvHOUit4iJMVrM02PvnB2spzuhtHEG?=
 =?iso-8859-4?Q?CK6+pivOVonP9IH/33CZgXiIIrttjdAAeIx3kTBJlUITRaqkEI86yR/ZnM?=
 =?iso-8859-4?Q?IW98BvYPYK09y71bWp4upZ4fjAMEZGKt1+1bUnP81xu3LZQWlCm3k3ZTDY?=
 =?iso-8859-4?Q?vb/DW7vPSuLvC65jHMGfD9Kkvdhq7xbkjt7/vBvqXF3X0KK36atuzxz3FG?=
 =?iso-8859-4?Q?v4CrdcvHPPxqRx+DjEjYAzqVdc7cpl2XkXM4/7WpwU8DLGDt6z3Qy5DcMN?=
 =?iso-8859-4?Q?SRVjrEy1XEg4SXJpkgi3OBBIzGltV1YMkv4SlhXCtiuJwy/Zq4dKM52jJe?=
 =?iso-8859-4?Q?IOwBapSi4EglS6whC4qws0EV0X90RlWKlPO9rzl1DrX08kjaDRav+Do98a?=
 =?iso-8859-4?Q?55zyvXG8C7kn1DbQlweHar2Ywbxpvd3QBRWqOxXR7dHKHefjwbfoKHmeVh?=
 =?iso-8859-4?Q?9zjV/8bGe1/lK+2yINNBfu+eLlZk5xBLR1+gU4PoI/rLNxauKxxP3N7d2A?=
 =?iso-8859-4?Q?yiq13Z2OpsmBtBlnYaYTV/hQ1niKQ+pKCeiOsh2oOOMy4QbsGPHx1V4wDl?=
 =?iso-8859-4?Q?QsPtmlG5pu2wxJO8V6JVaBFol2TsvGEq7WaIuQJL66nYVtW5kyrzM0re0y?=
 =?iso-8859-4?Q?rcGWIP5u3cV6R7MTVUdaqBMGKhDPuB1ew1W7oBlfsGDPi3rcwzQMDUldhh?=
 =?iso-8859-4?Q?8/upRqbao+cyc0bitL7GDPMaHj9jXgVlhByRLxcE+ny1/uMmSMBR/uxi7E?=
 =?iso-8859-4?Q?1gMGEMeJ56++UOcm1LlF4B09l5GX8Va/N6gXe/FxHXuzu9UxbwclIBf6tB?=
 =?iso-8859-4?Q?11p5CVusgHAdIVdRsTZ1hWPwyr34xQdZfsQuCu3FFMb6pk7s931cv/4B1C?=
 =?iso-8859-4?Q?OJEYqXGhbakH0gyCfAAtpuxhif2aJrbgWV8KeI3kUlZr86jdBK+t/YXFuQ?=
 =?iso-8859-4?Q?XRudiuJ8cDQXSPql31iU/gn8KPp73NYGn4c77RZDslK5ME8m9EKaz8Vg?=
 =?iso-8859-4?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-4"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea764874-e9cb-4678-1c3a-08db40b6739a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 09:14:17.0346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v2pJN6GoCZlTmepKc4reSTtZwTcQNMeHOPC3MnhL9S/HnOzb6s8ySGXSQtv6D9KN7rHp8WlU+h0+qQgXgLRWWIgl0w+PDkxlRkUjGOGM/8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10118
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
> Sent: Wednesday, April 19, 2023 8:24 AM
>=20
> This is the start of the stable review cycle for the 5.10.178 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 21 Apr 2023 07:21:43 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.10.178-rc2 (abbd2e43cd45):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
41747700
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.10.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
