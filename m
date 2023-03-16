Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC6D6BCD82
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjCPLGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCPLF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:05:56 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2090.outbound.protection.outlook.com [40.107.113.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1F16F608;
        Thu, 16 Mar 2023 04:05:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LyfCFLOe12ja20pXSJUXRUsm1shesaf9zxtzxQJjGnPsCRx6Tqx/c8q6JCRzHnwBS5abpY2USRPGzHrNCuSJ9r6IfMamOO437UBULMXTe/O6pH/F0mJnoPxCkJ56/DAbhExuyq934j1j+BpMMDB1Z7lZeBDt1VUWH7F2y985fx9HgPTxj1yvJOAAocCW6dABZr1j/l3P6FXZQzQ2bko4L4cgo1EIvVF2RtC827I9YC57GD0BnaLJvbfresQB7UqMeOdlLxj5RqaZcuvnXowWl0n7ErY64li5JGNCvwoOvOD5DSft5kMYPHvMgdppt49uIWOdUZ5cqk2EDMgjmxKzng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mx6yXbZ2yNL6GRd+nCOo++V1PctaMM7Rzb94TYRUUE8=;
 b=WI3BMRokVlqJvsmxgxoVq+UCQYXVw8n6JizBcWx+V2AgE0aLyT1E3Z5NRMSGjo3Z0x70lEpUbibZnuH6kJxposq8WZPnBydUnIK1YNwZAJQI7E9QWuBk58TvMNZqdYNZQhGImQlJ9kfN3xRN8agmFj1yJ37yGivzgBGqHFPlUg+HPsDcVfYo0ZAa5LNG4XgJ3yni5dPRaUBNJWrdaRiyYBhOJdmtk4NAKfLlkRXut+jSTWZyr0tcft7Z1CWkRTVfSBawZzzahucnDXQCcKXzgMEK+ml1O3d8UOCZVUZPvZmN3pYtCmVC3je2xRZdQHnxeY1x1smB8R0yiyl+mQPvrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mx6yXbZ2yNL6GRd+nCOo++V1PctaMM7Rzb94TYRUUE8=;
 b=gJQn8up2LW0EIrww6x9Ej0KYbe2JkIq7jO8YpPE9s90uFjDmtB/t7OVfAOaJU/lZpOaFtz0Au+gei4rFllPvdwcgl9veoeZf7SCmTd9DjSIiv5g+aNBjZ6y/yU+UVJe62dn2JAJLt2zzejoBTahWx5+3k9pWQjbUkzyWOoGETJE=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB8805.jpnprd01.prod.outlook.com (2603:1096:400:16b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 11:05:42 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.030; Thu, 16 Mar 2023
 11:05:42 +0000
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
Subject: RE: [PATCH 4.19 00/27] 4.19.278-rc3 review
Thread-Topic: [PATCH 4.19 00/27] 4.19.278-rc3 review
Thread-Index: AQHZV+ufgF0U++m0H0e3GF+0SboyRq79PjnA
Date:   Thu, 16 Mar 2023 11:05:41 +0000
Message-ID: <TYCPR01MB105881E013AFC3DF4341CF89DB7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230316094129.846802350@linuxfoundation.org>
In-Reply-To: <20230316094129.846802350@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB8805:EE_
x-ms-office365-filtering-correlation-id: 8663e8b4-31e3-49fc-ca4b-08db260e621a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +adJZ9Cax1BcIAA9sUW12b+3XK2sVavuccX17BHIrk/SHd84i9ZSEwPbRMmSUWP2r4dOVuep1eIXbMd8KPnq4YX6c8R0HDYZEznJ5d+0wYtAQK/0tAU59tvUSw/DZOb4OW8ktxafOIOjJ/ZyMMMioOBnIxiJH9pE1OIv8KCetFHSqU5wnNHG28RjssPZeqEH+A8uoBrQEoyYBx9SHs1ZF/q8P8hOKYdegiXnH7/KrGcdBTJ6TTZBVkJuXKt5JcCub83ly5e7O6ucintF19JtRH80MSHBcLX/MDYBFf9sy/iAhJSlDLn+ARPcZdOwYmSarsVh4V8JGzzdt9rF/fKhgDxRJGShuVtTdc+sbu2wT9JeXIXlboB4p2w3gfnbwAxrEUxg95vS8zyMbRtl82mGeUEfZyuBYGtd3IqCZbWySKCgS1VOfUWmLA6ZPjR8Qe/0bOPJveGk2fouDJa7ccGXVWfVOzDJMiNspoGXeQksjpPAp63nVZOt0zsAwGz01/PJfVVDdb0WaQfOEvLgi91Xz0wssfa7ra2yrI7Z5gI9T2HzeRtu23z5fn8Xa74o414eOtRbuijNnRqBBJpTfLEDYxCOK6AtIcrFCBVJKixq32bV+t6RB1uNXAMVYD/3VSQPxu3gkA/kHq4DeR7jT6s0XNyFNNPcK35oqQk7a+k5Zqu8YfkYEM5atw1M3szXK1nrRM9KxCmeT3Du5eTC/iVIw6aoGUsyy8wCZstlaKVzHGo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199018)(33656002)(86362001)(38070700005)(38100700002)(122000001)(8936002)(2906002)(52536014)(4744005)(41300700001)(5660300002)(7416002)(4326008)(55016003)(66946007)(9686003)(186003)(54906003)(316002)(26005)(110136005)(6506007)(66556008)(966005)(76116006)(66476007)(71200400001)(66446008)(64756008)(7696005)(478600001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?hdTVkw/+4K/jyaHkTV97VkR+h4kiRO4d33BeCaoAzxQjlVOkYhytC4Hy?=
 =?Windows-1252?Q?3Ka5KCGmlFhjmgVgu8MbuHJS+r032GfTTMuQSSCaEY0udITcDThD/XlN?=
 =?Windows-1252?Q?Me7hLHfgIoG4dEtyoXCJHO8patjgCoZ7yM54e8AHmQr+MryQMVkDh6HP?=
 =?Windows-1252?Q?OD6i1q6aZ8CUnsf7+Kui9uUceYtuE9veK39ck89cXmm9L2sgy9VHm8ej?=
 =?Windows-1252?Q?K9PIOUmGUxjSTesn1sdFiVVDeOfKu5JX67eLY5yd3toJG2Eu2kLUl2Cg?=
 =?Windows-1252?Q?8lznU0lE6JwCfEs0wOms/MAPTsnCD1+n19lF9wI1KkEAo4S8vKn9IML6?=
 =?Windows-1252?Q?h4mrR5QJh8ocL6M+CNt1Os/cjBOWJUSyCabymbmT87+b42x641ALiYRP?=
 =?Windows-1252?Q?ElHo3HzZhrbGOmMmWy2LR+eOhumczNwVeL5S3vd3/G8vOM8FfQtT+bun?=
 =?Windows-1252?Q?d7xgrmn9j8BDOrTMakRcI/cK2ZbT19nbtTdf7W+o9uq25mS2uesOzk4m?=
 =?Windows-1252?Q?qF5vDaCj00ykf/wO/1k6w+wjQ+DQufxCXed1rijFFzBUDXkwXYYazknZ?=
 =?Windows-1252?Q?9dczDCEi7Z6KcbK2yMO3Kw9sW+mLpRmiVrbV3tmdOYgs354YBwVRvQ8h?=
 =?Windows-1252?Q?eq6NXN6yRble8u3UC5VgmUYwFWflSXgi2aEZpKKouH6Iq+K31Wpph2Fy?=
 =?Windows-1252?Q?OGswRRpiL3o6MVPafCLfI6JQb+KjXt0Ra3D3RTm0OrJhmXqj0i9wf1ay?=
 =?Windows-1252?Q?h+kA3y96L0aF2wFAP4fBXsDhERLb3S14ftGr3rw61wgVzkzrX+EiYm5g?=
 =?Windows-1252?Q?dqdtDKaQhxJM48q0grW5WT10HSC0bhg/pu+CI4ZdlCHrqZcFcNHGDl6B?=
 =?Windows-1252?Q?Y7rwLaaXLuj2pCOeZrdlxTskE8lyTUMKFSZ+lJgUpXXqUhvlr2D68+2k?=
 =?Windows-1252?Q?Jxu/kFWDLMZwBzNKG1zbyqbxSft8fxAmqsvRh8Ry6c540xyiazArFVqi?=
 =?Windows-1252?Q?2+IoFJSiBR5B9XLPsUyXBJ+lQO9VyBlalGXRFcnFP+tcdTNi9Jf7g/dL?=
 =?Windows-1252?Q?KY3U61jZhWCq8Qdp9lZQnm5EX9VGZd8FQc0eLUUEnpV9vycc3jYFalzE?=
 =?Windows-1252?Q?jSafOp7VWTtAqYIxRYUU7oTFvSmGjR+YQeP5qM8frs6KGDOqmtszjNJ6?=
 =?Windows-1252?Q?KkqMfQ7PLmgoerd65AdlFswDVbOTUx4uOxgO5KMED44k4eWqnefxSyKB?=
 =?Windows-1252?Q?JNg7mxDypUIm2wmVYs2PflaYNqGajZWDwPhuWKnCEPiYfqdIMIOFpx/r?=
 =?Windows-1252?Q?kk7lkNnOrg0TxfxOYN5xEVBD7mc5EpEf5mVIlJvOFg9FDm7Aan/mzD9T?=
 =?Windows-1252?Q?1s2Si7Ao8U3lldeL6u4alVpJw/xQaWOKQsIgl46hTm6eJNlgSLGXHUbJ?=
 =?Windows-1252?Q?gMMrh9CIMMc+pYrWfYSIJRyjPzI5CaHCceI3qiksPoXVx7NVtFjG/7oW?=
 =?Windows-1252?Q?NmzmixFrRkpCnefw7Cg54ngl8wEcfm7Fd1Ghleo1KD6An4zwlf9PRwv2?=
 =?Windows-1252?Q?WPr+Ha0D5A9dEn25rbYZVvEd2gUQBgpw3Q99FsajZNf4bRzGpeHNZ+7B?=
 =?Windows-1252?Q?TVrJ3jLGRc/75xBPDEwLyaTffhmISgY0s39ja8W7s4MsQe6dg+Csp9QA?=
 =?Windows-1252?Q?h5IoRjymh+B4wNkgwzP487jb1OvNpXLzcrlAk4khYBPykwZ6F4rPTQ?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8663e8b4-31e3-49fc-ca4b-08db260e621a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 11:05:41.9909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hAoQ70oHheMEmUbegXqi5Oz+xGHYyDB6miz/inD6gZgl8ub7olf23C95VfNw+5IVpBLc6617wvEBfXJ748Z8zfZRSNFj0PPCSIOjIq5aGRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8805
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 16 March 2023 09:42
>=20
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 18 Mar 2023 09:41:20 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.19.278-rc3 (0233a363477c):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
08414819
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.19.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
