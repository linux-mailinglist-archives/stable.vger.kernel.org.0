Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80826E66DD
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjDROOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjDROOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:14:07 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2090.outbound.protection.outlook.com [40.107.114.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2200814F47;
        Tue, 18 Apr 2023 07:13:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVbt4N1jOSWYoK7Pey3HzHBJMYTE6oBdDxVEDp/b3tKJRkQELpuRCVfcj691XlQVJIG7AXDFBRFtUxg1BvhWyxuvC2SYP7gaLMsisYWbtFxIxD/SyNO4bFu0HQ96HnvuFvZQZg2q0Z8bBtqkWFsk/7g0hXTbBOFA8rmPAdC6b00eKPDg0PDEbqVQPVF3jaubjN4NKDEAWtamC0MjXAwoNm0ePctgGU+VADd4+7DLCzoADvgP1ugosuSfbIq0urBXdnt1PWCAc2Q+7OZf7hWgP+1qvYugeLoRENNa7l73ZTRp2G4ACydqTYbspoOsmNAmCiEg2zn6fpLZNlWhLwdlBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IIR1IMFTXr8nqs0nAHmEQ6USCm61i63rWGGYlzyaIg=;
 b=j1hczsjvp27v+yEfREzw7reTlceXpHMxe5bqFC9AHibYZUwKB5Y8plX92TuxoWybWEtZnfZ1KODghNXgp1mPSzudK+ekWHyoDzQFMhh5Rh2mrIiuhQdNRXLXdqZx32HOCnKu47hQHQfOErB4qgSLw3CuH4YDBJHn2E0JviY4Llaj+OGwgX1+ypKSX+3lwU/4aUBFa4Csbqq0diLuAMdNY3Z78+cgugDHguIayCGdapkvTfjh8fEDwoDfmcs/CQleIuu7L0VTYXxSBtAmXcp+eIGI0aTZ5M/xZCVa/0lyV8sA52wn+2PRiU29Ab4fUoiCMqbO54Sb7H4BUXZZ8onOmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IIR1IMFTXr8nqs0nAHmEQ6USCm61i63rWGGYlzyaIg=;
 b=kVMjQ/+MxtokcJO13XjZuQRpP0b/WZ/mjsEsVwsiJRV5ZEElctflnN0s0Xzv1ivYUO5dtCApxkOgPNoCc+Hrp25sQDI4Xz8obG06MlCVlvbiIJNEcj+/wcDPf4VHO1gmeE0A7st+A1T6zEBPBY9AjVL4YAKdhWJ9w8wL/Q66Xm8=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYCPR01MB11801.jpnprd01.prod.outlook.com (2603:1096:400:3b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 14:13:44 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 14:13:44 +0000
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
Subject: RE: [PATCH 6.2 000/139] 6.2.12-rc1 review
Thread-Topic: [PATCH 6.2 000/139] 6.2.12-rc1 review
Thread-Index: AQHZcfQH5b0mteCZlkSin2KXvs7LW68xG8ng
Date:   Tue, 18 Apr 2023 14:13:44 +0000
Message-ID: <TY2PR01MB37881454469F77A35B5EC2FCB79D9@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230418120313.725598495@linuxfoundation.org>
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYCPR01MB11801:EE_
x-ms-office365-filtering-correlation-id: 1aa8c479-32ca-48c2-e044-08db40171e81
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kTIF0U0M47GaXmdzPwbkeQe5VN/nw/cwlGcZN2WjDDxHMkcU4uq32cbhxrekiSLNaDF2mKx7Pbr+yApGHXnfvAmCAW+TBOvZghKldAm20ugxFRWINWZMU9YEAixszlG9TsApP7n8Z8PG2SbYikhNpzxi7MDd8JkVG99sQPhazBWRfByy7PMFVCWIwXL3xMqrtQaFDcn6fO6+XqekHlwE/rQmWuTOpztjB2rUAtcWSvLyTWufTv5PWPZbx0J8aC3kiAE/nCNR4ZUcWdQKu1pZAy7KRa+/YR5Dx0vcDdd64i8VKR1Isa6Itot67OOsqliKHk/wm2NT/rO/vi7j84A0GimghX6LWmIJkiU9eHNixw2txpXdv1d7kzupwVDTKQ5sCAauD0tIfdM9uC+eI8ZbEG2bJEicBAKTXFNXaE2i08K/gyyf0Y41JG0SMEMf1YVpCyz3cIQmn5pvvDX+/nSitOIaduLtgPQuOwoLsxwZbV26VG5KGubrcKHwvPjj8gjUuqdr0emnp3DawTz4WMSj7yZccNsF6+eZhshRj9HFIkqql5Zk1MCG5Xnu5Ii/p0BdGjGzVd/xkPZIHKV+TsyR4bJ8zo5H8cwNtCnCjN9lJh9d0WokmThRr3XE/2jNwHKupTYl/a+hGpPiWejkrxfilg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(66556008)(4744005)(2906002)(66946007)(66446008)(4326008)(66476007)(7416002)(64756008)(5660300002)(52536014)(8936002)(316002)(54906003)(55016003)(86362001)(76116006)(478600001)(41300700001)(110136005)(33656002)(7696005)(71200400001)(122000001)(186003)(26005)(9686003)(6506007)(966005)(8676002)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?TkdiJvg4zzhv4GL+/MNfvuihkA8HuDhrqMxGKJpXTRKNA8IR/ugqJJq9ms?=
 =?iso-8859-2?Q?nIwx1N1SY/zyK8s3hhlSZilW0hRFFYRyOGXur1KgNWwmvBPvqGx+OTIPLH?=
 =?iso-8859-2?Q?DOkgYxyTYzzRHt4FqV5Bq6tsMUBI4OSlinZodgBm6wEvfRxDxWLTum35Td?=
 =?iso-8859-2?Q?v9ofGuG5Lx7vG3GWaSZRkuerUYtSHg/h8wb2YKR116cEwpzvBAcLwDo5Vw?=
 =?iso-8859-2?Q?GOv47OQunBFwM65aZHT6IGM5fj/yFDBOZgzso9qJ9CH2eYPXED3TDJo2Tx?=
 =?iso-8859-2?Q?elohkKwrpjGbgahHza7asbFuvmgI1we6HN52gxRThysnnuzh2Uu+nP1Ljt?=
 =?iso-8859-2?Q?Po+eBxcNbECe47Mf2wc51B/x0T/bFjRPLRPHDqW0TM2ncNgmX/VNl8vbkW?=
 =?iso-8859-2?Q?91cLN/QtuDePptaxDoBwAwPyud0UODSaR/lM5asIgDqTv7by6k1yGJ4qiJ?=
 =?iso-8859-2?Q?fjsLDVa/cgZmg0ERv2BXBcSzqO2ztYihuOldfuS3Qmw/eUOO20VW50RZw9?=
 =?iso-8859-2?Q?IIbuU7YyG0k6SuYxvfa6aiI9WjiSIT8p0ATm6amleJI9zWPLdeASPXyFiB?=
 =?iso-8859-2?Q?8r8w+451c6hmUPaKMLTp7YfSwFpgb1N4A5Mm7nqcKwc7AUu6XBQjctMsYs?=
 =?iso-8859-2?Q?L+ozJIDpUDe5+mEOtPn+niN0F4JHHVdsAf8kFZx+VbirKUPAGPJsRs607P?=
 =?iso-8859-2?Q?WF8RwR6LVGSY7bMyqCRLuQODhIMt/FVLn7sDSwaBXhyhGtUnw5/dJDpxeF?=
 =?iso-8859-2?Q?yQgDU9BAGJAzTOdEj2M2W3xr+rI5u64IgZPNLbqRu1Z37W5+k+EIaATy1A?=
 =?iso-8859-2?Q?kUdH+6cfr/1fkppZgVoWy9HZ0g+NHEvuev9iytZsaGc8tgPYgMW7U/66T5?=
 =?iso-8859-2?Q?6tXrQ6TrpEZDNR+DF9En8qNYzEOGnoO+CSYeo15/+FzcdraNxyWoUT3kgO?=
 =?iso-8859-2?Q?bes51ug5aEXqbGKZSSUZOejjd40hw5OsCJaWs31Vpc0Ht5KNDxGsHh5fR4?=
 =?iso-8859-2?Q?E7wiJy3iHrmz/jVdRhZeFqW2w9j6Js4l+jnRob//kbewI1Mk8iITlznYdu?=
 =?iso-8859-2?Q?Ebfd3cXDkaqtxkecx7IMn6KgPkvTOdKnSSGUD/Y0eycFRNe3wNYB4atXdt?=
 =?iso-8859-2?Q?p0zoHgOGm1dfnsLYqHlY+TCCkwxUi9kATl0x18wWjo1pB2Blv6oTmf1wuJ?=
 =?iso-8859-2?Q?X9YJ4Q9jHTKTSU4A8zJ7FoTOAleJ6ucdw+u5zi/tCY22ZEPIRH+TqMI+TC?=
 =?iso-8859-2?Q?fVR94xW5ou2gvcJ997NSXM/dTnjUEFeVU0ExDK6sX2GzPeeN79ONNguojn?=
 =?iso-8859-2?Q?GmoSn2biL314jp0duczJbOY+2kyt44S0HnYpsONhfQh+nRXlJgd2pYCvDb?=
 =?iso-8859-2?Q?C0u1P2oL9wCFP466pS+JACvxG68j0jal6yMe2RbghkLiutSSJPSB5G+veR?=
 =?iso-8859-2?Q?z98I+SpvD+MjKLZY/8Gq4EZDXs0U3QZwjNibUIRoNxiANYubm9Poru3dCo?=
 =?iso-8859-2?Q?RL5WaWfv5LOEMb0Red3SjdVqfDrjWW2sVz6Qw6Byi9UJsTTO/XJqsM0Rx1?=
 =?iso-8859-2?Q?TgrYNaKNgR6NvFApQquoxeBILs3lwZJW23k3uvW88tqLex1j4FLhmuCauy?=
 =?iso-8859-2?Q?36lVsuWGpxQv+timAjyc2LScSI4whXYkYfRyGboexGLNWl9/sNAQwWMA?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa8c479-32ca-48c2-e044-08db40171e81
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 14:13:44.3109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UnZsDZi+8Cc3zP3toSlV1YsPHWAl7tdtuAuvYMxV20XIfs3BarNH39Zrx3Fy4xyFJdsDSYUNV928jNZx4NZPKCm2Fni36YMcnd5Gj/kLUUE=
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
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 6.2.12-rc1 (0b816653f21b):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
40769306
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-6.2.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
