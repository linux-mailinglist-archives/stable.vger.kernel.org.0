Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C747C6D5E00
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbjDDKtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbjDDKs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:48:28 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2128.outbound.protection.outlook.com [40.107.114.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F82F30FD;
        Tue,  4 Apr 2023 03:48:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNxUDDrz9oeQ6ynhYXLBDtgjlnp7RAmKVaDeUFpZSnbD0qpHpDT9rKsH0yBZoeqfKylnvmGWCAC8C+VAGitB0Y9EUdzkjZ1f+0NUcPghJVRzNdJEqT2LU3MdPC24434Y9mVHDvpAUkeAUSnHWZP+BIYRz0fOTqgHqlqyW9NbBZRgETA/yOypT/u76lPKnbeFuaf92XcoXvBHBmCoNqo1s0v2FGIXTWJaJsD409y0cIZQ7iAcqdUtGU5WVVzOY+48ngrxfoCWsC/I3eBFzu+BqeCMQF4nl3GUyar5GOcd6ob2HMIEVs6xNY4+FnqAR6X7jj+YajImVRU74hvkSXup/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Qrj9KbbuDDOD3TAy8ipOtCq+gt6I2LmiSr4m9qcZ84=;
 b=d8j9jqBPZA/HVVym4s3smkyeh8FZAF89ZkOm0l1poff2ACv42uY8u0BeXI70PJkAqDAL4jhCbolPuzLCp5yZ6p5CEWkH6FF/xaa8QIRg6aw2Qqhx8iKZ5y9QXuD8TU47RSJc/Lrprkf0gp8+X8DWVcw+8NM+wXEVh/kfkG57FfIXUfQLhNqduRXPRomxUWix4ipzmC7VAXkmhIH/4NqpOshNvtjr+Ag+t6yA1a2PJgaGYR3Y49yeNEKKj/FjaM/n1Mb9Zj5usg/ThJQecgpZUL889j1lN2WmYAs7+HErMeVAjb76qGLvNmbYxoL8bep9ZBuZURuirPmM0XIRF8F/Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Qrj9KbbuDDOD3TAy8ipOtCq+gt6I2LmiSr4m9qcZ84=;
 b=R2N9ut+4Ohz0SrEfSlo9x+3BTwuNZYeNyBqUiN370nNhoTy0Y7yTTL4qC/2pAQhMwgjS9v+iS/wBMZN2/gxHDd+Y+9wgLowFJbzPucNrgOcSIBxNG/ez4/vOmla1h8G99RcGZWjTzk4WhHgIBSIn5qwFBas96j+QyoE1qfC+7yY=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYCPR01MB6126.jpnprd01.prod.outlook.com (2603:1096:400:49::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 10:48:19 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:48:19 +0000
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
Subject: RE: [PATCH 4.14 00/66] 4.14.312-rc1 review
Thread-Topic: [PATCH 4.14 00/66] 4.14.312-rc1 review
Thread-Index: AQHZZjZE+H2fKhdck0SDr2kADteWgq8a+S+Q
Date:   Tue, 4 Apr 2023 10:48:18 +0000
Message-ID: <TY2PR01MB3788D751BE56E51B5DD69811B7939@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230403140351.636471867@linuxfoundation.org>
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYCPR01MB6126:EE_
x-ms-office365-filtering-correlation-id: 57338285-ade0-40b8-dc74-08db34fa1a4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IbXKWjjMDk5sl9Xp5wvSvYXeqbZ1URxOuYMdcuAVSpOPz3JAcg/20vOtAPNiGVwUNx941zgCy4we78xtphpFpRp9K6O2g00+BMENpDg81/Ba/+7uq8bzpTgafdW2QjfhLBmy0Xz9U1MdBVkDfkg+1ug5yq0Vi0uOGucZRZRjksiC5cpq7kBilejcPi90/Ag4wPRNjs0Yq3/PaygAGP97BdKnGe8jRb+pzSc1ZRtoBMZs2YoVBoQgbwysQKY5LsFS08hvt8BnHyNb9mbz73E1GhzmI+8WRSTYaC1VgCI5oBCkfsQl4EQoXRttKt+TvwS+C8api82mL6UMCMlCZszvwdD6DAhithQ3rSDCvYERajSm/VUo4mDXdM4T/WQn6G8mIbwtaL6SEfvdMwStQp58PhEJSVxJ32rAyCP+NlQFzMJxjB3h4P5fuzA8GArbK581Bnq0ReDJspQUAXKs1SLr4vb8K0RBE5M+0RtcOm4D9YO6X23uT4rve5YjVcrdhgCzFobBOYqDvgQ40Rh06SO0Bn+Px911BoHIdBZNJ7EEAnEINcgS1J1IYK7tbweJyJJdoectYPxhFyvlxCbX92jRZy7yyPhvxmlHI/Ynpa0LrI3NpmvmF23De3eeG7ZQyoOiVMZSPbw7AVVLhYhR4BSQJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199021)(55016003)(186003)(26005)(6506007)(41300700001)(52536014)(54906003)(76116006)(478600001)(66946007)(9686003)(316002)(110136005)(4326008)(7696005)(66476007)(71200400001)(66556008)(64756008)(966005)(66446008)(38100700002)(8676002)(122000001)(33656002)(7416002)(86362001)(38070700005)(2906002)(8936002)(5660300002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?oCJkMzVtqHqL6IXB7Yc9JvUhJ+zWZXJ9TwqxsxxNewHSx0ZAOWgkPfB4?=
 =?Windows-1252?Q?x5EdW/AJde5qwbUwtyUMQ+eSK7+xsptMIB5ndYeWdbdG1RvqG+43isc/?=
 =?Windows-1252?Q?f7XT+thYapr6GvyYsR8JDZnyLXtuzIv7w19ANOrHfSi4eMtFP/I0K0z1?=
 =?Windows-1252?Q?xf2FVF+ZcyeRJN9k3JHN0+0HbyR8+dobBR84bZaBauzI/09bCHQXvpuH?=
 =?Windows-1252?Q?HssOTVFhZBWhv6J8T76MD2wU06z8KQs3ZJgtTj/Z4zhrsNBAewFOPXj/?=
 =?Windows-1252?Q?dXjT9NNly97kRyOWPzkf6tW7RBdZXEUBFNfgfUNnLl3ezUKv6TVuEPJG?=
 =?Windows-1252?Q?lfKFkG3GuorlGYfjZRrHM8kVLgHygxrBpyHTjfnS0Bs1jhVpdpP8WRTg?=
 =?Windows-1252?Q?YawsduNdwoM2W+v+XetKDBmbTOKkqeipeduyxbEPimrCjHgkbeFd2tFo?=
 =?Windows-1252?Q?1Dm/qN5bj13M6I3/Mpw7xL4MLfddUvf2i8EXuBqTmS0Gt/AYjJna6ejR?=
 =?Windows-1252?Q?ZvCtIrO04Np9zqIq2jSPKHuXuWOK0OqfJam8FONkSxCh5EFxVHdSha/N?=
 =?Windows-1252?Q?zB9SBrNRuONAgoiJBoVq2ZXi7eEFfxdoqnE7iAXtlG4ADGZU6SJUX7gg?=
 =?Windows-1252?Q?mkqmkNSlERQby9B9q45unE+2CYTvJ5WsyAjTYvrIQNhGfSLnpieSjoZL?=
 =?Windows-1252?Q?oqgkO6QHKr8jyJCnwcMd/GWK46lcjzMvGDWz4ll/oGr6AsYMMuGCx9BM?=
 =?Windows-1252?Q?tk5hP6FXp+MHrDMC0oIWaR5UNvFLasyrXO4MqEQL8yKuOC3bvmGzr4RS?=
 =?Windows-1252?Q?CEnlo3AlDdOQOs2r3ggNx0EC1NSQCASQne/u8T1buelLAkEttlfI6O7W?=
 =?Windows-1252?Q?46E5nGrNNYH5MXqvLRxU8HsR2bnt81iwY4Z1ZDiHGXFL7gi2SHIqT+Ln?=
 =?Windows-1252?Q?WkB85bdeiGEJzr4KwQ25iPNQD1j1mrql2bqPc74YN96dV+Aw72Qaw5s8?=
 =?Windows-1252?Q?OIZnl/wEyUIJl/5eoCNmMPQFcSUxpJYFL9NpCGc7ZUPC2NpfwepvNubn?=
 =?Windows-1252?Q?P0kaMQI2SF1Mwg8Pp5+7AdW8dFHnyy3+aShEY6t0xdvDUrHiyqstqpUM?=
 =?Windows-1252?Q?iXwdrKqaC2jwSVG90ETgKX3R7ziJn1HbMuX+K6NKkIANxLsMtLOKAXaZ?=
 =?Windows-1252?Q?u6nuEhz7dKOSStDOJKPZcsMcxoiCZFblNUeZWpMVeZqVCn9aloNbUbrN?=
 =?Windows-1252?Q?I2byBshdF5C/kG5dGYMCKCOw6PFU5qyeS6FzugW581lBmtxH8Xym2k+5?=
 =?Windows-1252?Q?xd6wcm1kp5URCT2nUc9E9IMLUwD26h2eBV/BVyfhCevuX9PmgKx3fR3Y?=
 =?Windows-1252?Q?KsXBgqFYMJ2TkaT1z8b7rl03OzxfiBeWnewmjfRBiK+ooZ4K3ROpdlbr?=
 =?Windows-1252?Q?27CmxnbwbdcorKY8aIlLBd18Bp98/7rJOrZT3gUXBFclflMethLUzNPX?=
 =?Windows-1252?Q?PO91lwHmIwQVOJlErPPxF43lQVWYZOi8HIErjhB27eT9uLwq5XDkjLYF?=
 =?Windows-1252?Q?XDzuaXuM+NEdTNHmI8Ap2+EW7cCJ28BiFMerhoQxPqMx2HSAEB3OA6UB?=
 =?Windows-1252?Q?OjTmw3mj3tgJj1KKkdlcAJ3q2fsGlJFh/OUUaHbVq9vo3OtlmpGYFObo?=
 =?Windows-1252?Q?wGUOIwljwio81UKWdfYJ+kvrL58tqtL+uyY5vwRuy7jBx9p/OUlRPA?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57338285-ade0-40b8-dc74-08db34fa1a4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 10:48:19.0157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PC847ffA//HmQ6sJ+2Umf8m7kTcvGIh31Ibh1JpEngZjDbqe7nBK6fQbg4mXA25Wz/XdsviBYUKGa1/Jlu1jkOqicndsqNblMrXD2Ufrq9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6126
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
> This is the start of the stable review cycle for the 4.14.312 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.14.312-rc1 (f4c3927dd933):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
26399224
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.14.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
