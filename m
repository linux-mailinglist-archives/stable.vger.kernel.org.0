Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D046A6EE086
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 12:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjDYKoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 06:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjDYKoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 06:44:01 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2120.outbound.protection.outlook.com [40.107.113.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D16013E;
        Tue, 25 Apr 2023 03:44:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/QBgxasMyvd4bsHoDS5DXe9fBWKS7MYAp7lgsBebjUJADPyr8zV/+X1QacVtq9SVgILJ+/7n/1vIqurxlCGUm4WH5CPvbya+kOwIoSP+ga9Rf3aNYa1ou611Gfx42mb4LX4a5icFXCaWOg2KlhrFtH5aBhcvSui7kSzYGtaGGmjcbtDKLcb7xttY/8g1cwcAqpOJrG/VLl7LYChm3j2dcPZiRDbx3EXjpHVdTbHekckMeP8Vb+M79vLzXFfk9CWg67AwGGUctwL6Gcfcquatyh560IYDltLPDKOKO5Owe65u3TPQpLdk86EJbSpYkNJbVFzX9Cd7Ida1ZGkvbvIyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDSazI7e/lImjmqpyrYja7EHjkq4zj3oFn4hdfBBDgw=;
 b=LmfWw5dZtJ003/Vkh55MhZcelnxueIY9TW/EoVGOzpOqH09jasht9uFW5zWz6zhAJ5Nr46WhfOa8OiTrNDv+voLHmW61W4xiQFwBZK3ejLZXx1H55nicju/NTogwhstUto4bl7fvGlrjn7pAE3GzsOxUHbXBq1nRRv8rNAOwMVbh5Zze9LXOBNJpWjjGgwgiG7EMfaFKOTfmALzJ0W+BtntWUrwi+Z6Q51s3nsxPI7vUPOiIO0fqyZD6S7R2S4+IMpDYdHcPcuqiG3hx5ILPtEsMAVENfTqypzkx4h6+PdKAiBm8+SaDzjve3apsl5GYyAuQL+5Hrakta06oIXwZfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDSazI7e/lImjmqpyrYja7EHjkq4zj3oFn4hdfBBDgw=;
 b=InGVtP1wnMGfKjzOw1GA3poQuI+JaR7ljReqEmEkoIuTfkqeKMAUy6M2vymxqlCvYObpgsc5fiOuyV18XEU9NsxkZJh7hrISTSbV1bS1EV8nxHa2iTd8KwflNH02VKxrdsY4Ffag9kSWn4jEVawZVsUgMWPBm5vWqW59C+CjrJg=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYCPR01MB5613.jpnprd01.prod.outlook.com (2603:1096:400:47::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 10:43:57 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 10:43:57 +0000
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
Subject: RE: [PATCH 4.14 00/28] 4.14.314-rc1 review
Thread-Topic: [PATCH 4.14 00/28] 4.14.314-rc1 review
Thread-Index: AQHZdrIeelLrVo9VskCTYJL46F2QI6871+AA
Date:   Tue, 25 Apr 2023 10:43:57 +0000
Message-ID: <TY2PR01MB378879F1AABBFAB2B47AF9FFB7649@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230424131121.331252806@linuxfoundation.org>
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYCPR01MB5613:EE_
x-ms-office365-filtering-correlation-id: b5f9042d-26c4-4107-8a74-08db4579f916
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pqE4pnyD3MufzuSQPn4+FjaBDcLTav0QoXfwJmQRiWy8h50JxyeH/ya2won6JvQds1tK5AR3ribAxh9Il2QBBYOBvdPc46OYDBIVo/+ASWGMJcGtFgCjtMtd1CD1OWxwt/RSKypAwb2sXsrSROVH8sNfuWZaJU6R9KExAJ0t1UaIZlY6fZQIpAQhZZ6NCt08bvCEHe6Lf4DZogns/2jg21p9fwRpfwArz7XdH36Yacv6ZETmwo69gYgtkKeNbhFhA75G0AYVf/veHbxFyXfAPFmEiY6soWGvF2SHvisX70SEshC0Mt8wM6ga0hctHjAigBIMulalnsEn/PZMAhdHU64SobQFnkmGR9IaHm4I6Hv5meLS4EnPqETXTmXJoHLF2FV+/Wj2Hpra8ga/KTYmlGw3J8fQZxwyXo5PyONyGkwVwInS1alTMSrWQ7mElvLRwY19bWYcEztzVgLRjtK3ZpiOj3+6b/lNw4LqiFWjCI91G4daFzZdi34+Gh8ijnmxkr1XYHy0dEyWZeMdh8smfb2BwmxWdRXoL1fKcxvriydrySAqLxSOFazJmEl5/Wbt/6pvp0L1NQKyI+8P5NFmdVeaO5yRiCFab3AyhM25p/d3qVxe051HBG8fPYK0TeHi4yFERCm+NiF86MDkgAvhHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199021)(4744005)(966005)(55016003)(2906002)(71200400001)(7696005)(86362001)(33656002)(8936002)(8676002)(66476007)(66446008)(64756008)(66946007)(76116006)(66556008)(478600001)(41300700001)(4326008)(316002)(26005)(9686003)(6506007)(186003)(38070700005)(122000001)(38100700002)(110136005)(7416002)(52536014)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?Wkv9OZvVDX2Ubd9/Dpa8OJDXNpzLaSErVhCj39dYLHc4eJcWf8if+nlK?=
 =?Windows-1252?Q?CDumTRCozbwOVYLcEKU8UaYjxTMcX1IZXcCy2Sr6un2tlU2qKJ9r4nDa?=
 =?Windows-1252?Q?8bqm+fqWfaGCdDDi3ZEP802Q8NWjLS0QryY4ri3tAmpgs/eNuYqzc9ve?=
 =?Windows-1252?Q?nZVAUInmpDdq6Dyjm+9cRQUVZm6o6YZNw48MXebXrc1HGJ9/8PWvlnFO?=
 =?Windows-1252?Q?soS8HUYbheyA4VJT5U3Hhts7hh/HOLpN7BhsLML/UrTMp5zGqbdL8o/M?=
 =?Windows-1252?Q?s6NJ3GwyJkHUqo1o9w6Jt4fsNkwKMEXLXTF1PTSWigUs1LTjzF5UyyOc?=
 =?Windows-1252?Q?TjPR46ZtgJ20pEnnJFAuxhihAclUngVY8jwINeV4uValOuKt+2DIpmgh?=
 =?Windows-1252?Q?WaGNorOVqhaHpSLLo8TaTmyBz9dph4FcgAhYczuUczN6D8qTnHtotTeR?=
 =?Windows-1252?Q?5OKAMk6JVQcU5dxJxJRfPqTSBMMRC4iML35od1Msr5riE5Qi+NimXc/9?=
 =?Windows-1252?Q?PcKk28yr8k9wU3S37B4JzwmSBOMiV2P7VCac9tJ1jO92dFypOwWhXL9O?=
 =?Windows-1252?Q?0nellNOpRyX+MRLlcAa2rq3X/lHacBBBNeFHxWzKL0+/56XkLmuehH5h?=
 =?Windows-1252?Q?B0y2LOSlbDmAvbp6miEyiYnn8Ft/UO2QeKE4688MEAuuwZLQ6iFeHmLf?=
 =?Windows-1252?Q?i9EXMkDaNamxd/WJ3seVOzLx7s3xJGZm0oCcFazolaqODUL4zIsHlSpe?=
 =?Windows-1252?Q?bWiyFuI8pTpUIL2JLSQzd8jSYl6p+rjdhhnG56TC7H6yhC/MCRxz0Mbe?=
 =?Windows-1252?Q?IuBWR4mi7QmgS4wpE5JOnobygCkvztwYZzwP4T/rcEIGGMYqA0YSxIHX?=
 =?Windows-1252?Q?Nw858M3k0GOHQ4CbZ3ELQkJCbvP1Z2bp3sMxm31jgXLrUiklLAWcz+qe?=
 =?Windows-1252?Q?IDxXRUN/+Byou5NbI5EDgBzKb0EqDZGlUfpQT1OrK2hI9RVV3yKugBJz?=
 =?Windows-1252?Q?YPogHXi3CAvaTyAjmDgdDNlk3+VgkXqd3lDffdlTD+3l+vQGfPbmtvrs?=
 =?Windows-1252?Q?clG7SpUM3HVQoCb5UWW5DpQgtEQapZwW6S7yGbqBvmTyPrVJ8lGN/nqQ?=
 =?Windows-1252?Q?mR0rjIhQmBVebG1VspiUdzPM9Xk+BR/s91mSzPdX8T9PC7ejtLnmHZyB?=
 =?Windows-1252?Q?vcnLYEASasnsGlxWqeFxeiVweD0dbk++nAsFNjl/TnJpGCSa60M90+VB?=
 =?Windows-1252?Q?UNWHzXfv8CTHP3/oW356aptLV4Agu7jIaDssDpFfckz1VQ624YBMPEID?=
 =?Windows-1252?Q?91DZFAPCK4AaQtfX5c+gOnVZA+7rz8942X87EnCV0SydbILUj/ckGH8t?=
 =?Windows-1252?Q?lGPaMFui+sx0Mpp+DKAooCEQpoTcEKkR3y/E5+e16RCWqOpMylRzQk2c?=
 =?Windows-1252?Q?GLG0XQHv0xwXYTo3387XVSZkRsi1Yffmg26UGJoUyd2XKMiA4QyiisCp?=
 =?Windows-1252?Q?EhpB6xkW5bhTYXop4niCV5PvKIgxCktPNMLfEs1WP38MAB58lw+GSVpU?=
 =?Windows-1252?Q?249uKo06M1z9usWmiQC7zbC/ih9ZplsSYe5VkOCj1lQ+qlTHMtlDW6ne?=
 =?Windows-1252?Q?Nrxdv+ejCDt2cAAfAgd/qFGQkch8EQm+STqSeY8JXTxnTqe+oZ0hIctC?=
 =?Windows-1252?Q?a1sj9Ee/Clon/ySqk7j6sbPEJt1U57ai1qlbFXVeWTBLaOk3kALKmw?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f9042d-26c4-4107-8a74-08db4579f916
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 10:43:57.5340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jJETyLVQyIc6WPOha9lpboqmBIAk7TKgjWQANssNIis9ZDiUkk3YYYlbGfZ+GIq5R4gsxF18b6KM/u2H4TYPVv5gUnoGAgZWQm2EGhgab8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB5613
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
> Sent: Monday, April 24, 2023 2:18 PM
>=20
> This is the start of the stable review cycle for the 4.14.314 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.14.314-rc1 (05f80276ba11):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
47550609
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.14.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
