Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96676EE330
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 15:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbjDYNgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 09:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbjDYNgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 09:36:23 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2123.outbound.protection.outlook.com [40.107.114.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C6414444;
        Tue, 25 Apr 2023 06:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAVBjnkhKW2Po5Owtkj46Qv3ciK+3cug2CsrwmWqVnMA6P82pUhaZQmYSDd03PocPlQKjSMNii2Qq5Y3/sG/yJJ7t5w27ihCGdVxqEnJhIDbPHQgtlcwqrMZDWC5yPxfUtO9u/fDpkoTbx7o1ZCKf25k6mq4h1BWSIfzDswSCTb1IW0sp4apsEVaVibVNItpzq/iK09oTsDRwujRvwf8xiobMK7fER0UC4Pwv2ZUA8VRD7wFjU+77tJ1eBKW0Y4d3W/Cdv6yhT+XTa+5a7i4cj8OEhLpHoisDDFrvbZ2xSKKvNPNkAJ0d7nRxgVtmOhggy9aIgKYatas1UThw3XrMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wWuSidTNPkVm9d/OPtsKYz1N3FuGh7TMHF9995ATYI=;
 b=K7ZK8C0g62HIJ+FtVI0IlTXop5k2SPZY0CA6II33gv6eXhrtpS8cibqLvTCSzBNC8zBvOaq1u35FwaIqtK0xz3Cvg6FMJtm1Y4LXVkXjHuWGBQDDVvWtSPoIhTNSoOsMSwojtshJSX2vQERzNBkmYg7KP9k2L+7Ot0F05D8k0EsJ2unU/IwjIRCg1JZ6mqthwleSegerPJ8TcD1oPmtp2JlVOKSfTk+Jp7zkiYlugiuxwGgkp5GqGZPhDhQJLLkNLfAw8x50gsnczk8C5U89jUd6QUkhEJ/rElsRwGIbOmpIhvs4VS/KOkWZ+JNVHehAPyweBgJe3KYhj0lsPUpHRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wWuSidTNPkVm9d/OPtsKYz1N3FuGh7TMHF9995ATYI=;
 b=buyMTyldPR50cfc6FFEvQe+jXvrJ+NqqwAtIBYU7mZm5eMuJBSW3mG34kv4HCcXlccebqZoaTkVs+EoJsFOgMpGAxzjblaitWzI+WxxGwPghcGaBWVkA9vMsVwu9P5xxGDCwv75q/jAcikxo2mebN60/54+3iDh4wsrh70ApoEc=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYVPR01MB11118.jpnprd01.prod.outlook.com (2603:1096:400:369::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 13:35:46 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 13:35:46 +0000
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
Subject: RE: [PATCH 5.10 00/68] 5.10.179-rc1 review
Thread-Topic: [PATCH 5.10 00/68] 5.10.179-rc1 review
Thread-Index: AQHZdrGoYBaZelzXmUmuVsq0zVTyc688B/jw
Date:   Tue, 25 Apr 2023 13:35:46 +0000
Message-ID: <TY2PR01MB3788824EC4732043ADCE2303B7649@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230424131127.653885914@linuxfoundation.org>
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYVPR01MB11118:EE_
x-ms-office365-filtering-correlation-id: d1175ab5-2be4-41f5-8342-08db4591f9df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gq7hNReVPUdvaMC/5T5rnrRijmYlvnrAFC70p52aUTu66XAH5K9BnHoaFA/oITAAthUyHHxHqFVZg8FMgt+YXYzdnOXb2lbPXmm2B5yiavE+Xu+eCPFcVNytd5HKVvPsnzZG86a10wuyomxsCDLgKVzHNcziEzB20GwJABzwaRFvyir7mylEWJnRGb9x7sp5LYkC2cWw0543H8cL1gOgYTm+EVvzbim+qPeDRhD3vmiQsmffA+WGIYTb8f0DfQQH7xBEzrlpugCeewp7rFff3RlhVX3wpy/J5nbD5XnXVG5Go7Kf0doO2fWoN8v+EIYD3JvjcNeJx3GkZMv3yrX8Trr74mGdsUEzHbIRgzRjTzVKpJIppvlmEjCv8TfzzMLsQikIx+a4ori4mazEfOgUP7iV0Cl+zM0DjyaHBU3jdg7Lsa4gxL7YgMWc4m7bEuLCKPzRKP6gb3xqrdO3A7+Uo37S87Z7lfuoqTdh1EEn2m0XsMK+ovrd7jVtMGNBQv7aBADyXVJ0tD14JWSrGCx37oHHIy4IX0BbpzaAK2dZBzoEVhtzhylyk2f/rScdjaxnNoaAfRpeArRhYE9G3edNehNBEUozoBioyx3DF2iFUCTUB2TUvQeXXA8Gg9MvURDFk0z0CHzIpuHTu5SHBUZNFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199021)(9686003)(26005)(6506007)(8676002)(8936002)(54906003)(4326008)(316002)(66446008)(66556008)(64756008)(66476007)(66946007)(76116006)(110136005)(41300700001)(33656002)(478600001)(7416002)(7696005)(71200400001)(966005)(55016003)(52536014)(5660300002)(122000001)(38100700002)(38070700005)(86362001)(2906002)(4744005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?pkyK6rH5UU4yGjSbnLy3yg/nStgcnrXnsby7nVWR0w8cbx2ew5DQjriq?=
 =?Windows-1252?Q?0WHY6ZhefG/sb2TDHel2qZF0c4dm3w7Ohei1c8N/ZerIG9MSq1BREqgc?=
 =?Windows-1252?Q?krL19KyokGKz9O5crc4uuHpFzPhmQPOK0cw2SleKRaazNIqfFsgapEw9?=
 =?Windows-1252?Q?lNNNh1/dpHRmLUmeKZ18iLcO4dxklK1bLji8sN7FJpUKvpiHdGqM5i/H?=
 =?Windows-1252?Q?2AacjeKl5LZwIKtTSjDR18RBQJ6qX1lVNp2xQJuIiz8odrN60gBc2r1c?=
 =?Windows-1252?Q?2/DuZk6qaabNVyE5neJJ/ySFTBkqswDk5InEFSBgXP2L8MRX+Sf0HjmZ?=
 =?Windows-1252?Q?/xmPnfkEDNo2mAiJ9O584E5E1Heo16JrzF/W8rihA8qeENg/b1hCVrTE?=
 =?Windows-1252?Q?zjgXUXf0qZKylUTl+a02SAVnvlq08bhMt96d1SJNgtbJkszlxE9XhRaW?=
 =?Windows-1252?Q?KA8ZBui8KA54cyeYDV0qO5KHYwhUk6dNyE6tEz5rgW8obPk4OInymDX/?=
 =?Windows-1252?Q?M2/B+4f4DjjbkmuyTu9biwV5kNxfa/EnmqpYz9lTNmjscxCtwj+YTtN2?=
 =?Windows-1252?Q?LB7FaSf8bl3eGX7G9+71CVDij95uitCJA4jeWNPyqm+wzEyFprICLCVL?=
 =?Windows-1252?Q?ZdJ1F9vT9bHmf3ygfbF3L8X8+MgJjte+e5idTmPdcOUxAsDcXUvxoaCO?=
 =?Windows-1252?Q?kQMP9Fnj46tR0gTO1AlXt08I4lx/LHYXollulLMuTp0wl5lUdF1cJtLD?=
 =?Windows-1252?Q?lQv+9XEPhP4YzgK/Rtzg4Gz16qzllauMhmt11WZoV2tV9udhD9Q+26v0?=
 =?Windows-1252?Q?H3M7yM/Cp0kfDNR+qpZlwCojc0rIZQ6iRT+JD9l5E5KrEEPjwvomOrCk?=
 =?Windows-1252?Q?GLbMpuftbYHxXaZ8/joldVAWe3RkcSOh6fIS7yd5Jz2n7px3Nl25ndVt?=
 =?Windows-1252?Q?q7OHmhxdVxI3/gaEFkVI9wjatm10qUsZuP4kv11V+84Kh0Gx/cdVM6Nl?=
 =?Windows-1252?Q?mNxc6s1wcRdaL3sW8xu5LuQiDs7A6jlr2/yLu34fHYtytLVCFxi0tboM?=
 =?Windows-1252?Q?Oj0Ovn7PALYYddy181E53/N7gCcHxBiSlnWhe2GcD4DF7r3SpANhvMlc?=
 =?Windows-1252?Q?Qy44AfaGye3+8Gq81Rj3LSJy7BBUCuBkc1jY60iBlU/TnkTtMCpgBF3y?=
 =?Windows-1252?Q?W+MU91vgpEbx4gQyqsM5fo/WxKaoqVDxuYZBaGMIb7Hm3s+ErtrjGa5j?=
 =?Windows-1252?Q?il6hwOPEOJO6zJ45AuUDhhjjc/SCtCoYphD+jAKXtBqC/wZmbQYaZXll?=
 =?Windows-1252?Q?mnGBe6iBTbR3MyY0RnyC/3EUm5KmNfPC4167hIpd6zJFM5vkVI39EdYl?=
 =?Windows-1252?Q?i6mCCpJidRPABTlmkW5gd4oYvpI36EfchC0iygpHuLPthWE4pfEw0Ebp?=
 =?Windows-1252?Q?9ZVvInm2KUhFRDhTZGaoWYD0aHEKY2Ze2L7iLVHcJRQ/oxfVC1B59y5T?=
 =?Windows-1252?Q?B1ExGHZEAVXpvdeEXLc/QNQ3zxiY/M7WymBlViHlxeaj9U69+rusgsVm?=
 =?Windows-1252?Q?NlqZnCg8U+sMnSdYBEQ92aAw5JWbZ6x+IamyIRUOgBcOWKFERlypxbxt?=
 =?Windows-1252?Q?ODazRnukcdSVJr3lW5sMa25yurJKSCzKlfJkrYVblxzxEI+XfCLb+GUX?=
 =?Windows-1252?Q?y4XFrNqom/7oz5Sj1VQfC6Ut0Y/Z1sbG+jyd/4pTDIXCJOOGl3DjPw?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1175ab5-2be4-41f5-8342-08db4591f9df
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 13:35:46.7569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XQh8atCsnJbiZ/fN2h+kH07+g3kCncWeFN61xdAQ8y4jqvbPPuyepebqUwlS1OiMiwwjC3tS9xEcfyD4qVhdm/7zkUJuQUpf97aFQzVPeW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11118
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
> This is the start of the stable review cycle for the 5.10.179 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.10.179-rc1 (1ef2000b94cb):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
47552705
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.10.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
