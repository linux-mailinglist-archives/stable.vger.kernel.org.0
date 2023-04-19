Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEE46E7608
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbjDSJM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbjDSJM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:12:58 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2104.outbound.protection.outlook.com [40.107.113.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F57618A;
        Wed, 19 Apr 2023 02:12:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pd8M8YeASnGRI7yVK2M/8E+i0YYiS3NiSytKllHIfox9TjcWxzB+nVFWPecPvWWZUSJ8WCOupBAikOo2D63PwIxDnmgAMbJcJw1CiiP48cjY+fZ3fX5wvo7+gPO3LQdYeIN8Nef3CpwUKA3dEw2fUHkWPMBMBJmkyLF928jb5m7wwPOF5N0pyTYXNI9SYttILN5YJ3wGwnrIEk7CVN/jzFgE4XNQPW4eG7v5ng3TERDBC9rbATvMqchbNW9unmRDRbw/4s9nWDiWryobOuuP1ZuEn0YNXOiP6HMM7xL+cWu0xaH4erYsKM2Oqhq5H0DNSDaHnlQ1z6kPra99xrreJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWJWbc90XcoBJhvuQOx3EClJgEbsHEwwgdkKBCGh7eA=;
 b=RnTcKOrbAPThnMvL9DOPIYO35bpjqE21igZVdia0GefsjgD+JmsGw6EHoiK4dFh9ojRca0yTXSakR2PkStWWLR7XeoZUBYSujMUaf11VtFJ/GqbOzVuqGZA9vn4zNxz5ZPnChxHbdBPF3Nauw05An3AHI0oszzMxFWkXkM2mQphn13T4cIK8B2j8w1Fv4WyAiYO86O2btNIboNKoSlcnnoJj9R09o3mCCqga6wnsv0iSw7OFaHs4X2MJezBQ34htuoIXr9NQFH+Hqtoi3XUrv4QY92QsGGAHsWQKTJO3q4294aJcpbm9wK5Tq3pm8ZNFf9EmNhW4X3vpHKD8KqG1bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWJWbc90XcoBJhvuQOx3EClJgEbsHEwwgdkKBCGh7eA=;
 b=hZUzu6Bo57EC/dj2Ai5NCCR6ybMmj9LDB2t95BHqW1JKODCKqAkJfAIvbmO2uBe6uZ9e5msXxOt4bRxXYTCoNernIZE5cgSUCuDekORdo3veRa8FeHHMn4sVlm+2IHiLTNwxce+6dkO5GSIqGvKMdf7p0iHg2pXm95hAjtRCRdQ=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by OS3PR01MB9753.jpnprd01.prod.outlook.com (2603:1096:604:1eb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 09:12:53 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%6]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 09:12:53 +0000
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
Subject: RE: [PATCH 5.15 00/88] 5.15.108-rc2 review
Thread-Topic: [PATCH 5.15 00/88] 5.15.108-rc2 review
Thread-Index: AQHZco/8LuBveZrDs0GDtxa/7Hh8Dq8yWOuA
Date:   Wed, 19 Apr 2023 09:12:53 +0000
Message-ID: <TY2PR01MB3788AC6447117B1A8B232FE6B7629@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230419072156.965447596@linuxfoundation.org>
In-Reply-To: <20230419072156.965447596@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|OS3PR01MB9753:EE_
x-ms-office365-filtering-correlation-id: b33dcb3b-469a-4be3-01b6-08db40b641d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3WFlM0jQDOifMdJhnbYTmQsbE8pP3kEbtXojpwVmn2uPWoRo0Am6fXUuRgP+xiKzdH2Gn1Q3tBlLJ3OTE8G2YVyaSDB7o3pEj+oKAh5Ms+Tku+H6ctFNuSZils+UATCh4FyMHtbqkIbd2oDdGF93R5avTej3I+NKE2kngXrtXlV8Q38VTXZjvIGcoKYPrv+SL5m5qZ+V65DRH0De/g2ekkqjtS52Qe324FKUUDcyNjEJwddixKMmgF80HucvMvREUmAjmxUW4Fst4P/EAKWoqczBlKjL56rPU4oKKDFN5Kp3M75PdiSVfS27UF/rF4MdaGS0LJ/UpgnOVwWj9iWoKwPGH7mizLR7CtJwlkRybMrDkB0teGe757AD5G5u0unf52puMP+f+VgPpElGZdxNz4GUKWnpg2WMmeOHV9TAwOqK/DxB5JKf+4R0NZ+IZQNjhkPtWb1s2Z7eQEPRjt61Dcr0ZQC6RLkWyeJ87TBp+HGFkpIP1FvxxHXVohMZvcoggJ7r8gDMd+7vNpV1uxcvMMKGLPV/0sgQ52YqQtcfZ7zFOMvr7f8u1fFC8+MgwaT08ZokXtV7hrk/Yhu0uvdozkO7ZPgoCS8Zotaoo0Z8n0p5b9YB2qPmyFRoEWURlSKZwko7117VzWOoC6o6fql02A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(451199021)(186003)(76116006)(4326008)(110136005)(54906003)(316002)(66946007)(64756008)(66476007)(966005)(66446008)(66556008)(71200400001)(7696005)(478600001)(8676002)(8936002)(41300700001)(5660300002)(55016003)(52536014)(2906002)(4744005)(7416002)(122000001)(33656002)(86362001)(38070700005)(38100700002)(26005)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?z2wMNT8z9KO0u6Os1kpdKy9tjhtAN1L0+JrioastAX8a5oswmNjVzJKs+u?=
 =?iso-8859-2?Q?fQXJ0hLC0LGwXIBlvrJRHlYKOfdHNLS1+NbJUWc+9Ix+NjWwUlqgOBTqZr?=
 =?iso-8859-2?Q?nVza9VbF2P6USO+yOhVx55bEYurQWJd9xttzKQQBUA5uS0wf4ZihGlFqO3?=
 =?iso-8859-2?Q?kfon3ODz8I2wT9WI8GvLVY5Y3s9nIIoc9i1kIK1uvUWfqBU7jw5fkhLlzy?=
 =?iso-8859-2?Q?eXWmv+UJiA9dMK98oJ44lVvYWb2miHhJYA1tL6Me+zT4i9G6g8f0jO6O03?=
 =?iso-8859-2?Q?tIQ3YS/lUzLOGFI4x++TbRAa/txzA5CeAKL8p4c8N9bztEt/pBnqaRKE5i?=
 =?iso-8859-2?Q?aai9WoQRgxM8hoKkV+luynaOs+bBIujgPuHkuA7yPsFNni/ZQjdp8J380z?=
 =?iso-8859-2?Q?pEOJo5w7rmI23k0yyZmifNIZpWPH+0+7/PQmOgluadaLcLZ8wpsiCopJiN?=
 =?iso-8859-2?Q?XlAn1UekwUEZ7yYakTlgBQVMGGchfbxT94X29FiVylUL45PSMxQ8OCuE2b?=
 =?iso-8859-2?Q?s7dWlxupwS0jKOR4o02tmPumRERfN6XpbvqM+vQzM2L9dM1JUNc/xGFnzd?=
 =?iso-8859-2?Q?n4B4oEzauK8uBtMAnvmmseM3ff0IWOAFqn0Be0w/sAjfmAwqGye2Qmp9C3?=
 =?iso-8859-2?Q?mXrMdW1lYHslTTMT3JqOZ31CUnSjEBlKrQ7M8mf8MWfqVdcRvCNG2PKOvD?=
 =?iso-8859-2?Q?vx0ld1WjGF5EfQJ5BW2mKmR92uZBcBcFK7MaoQiyb/4wgsuygf85kQxESU?=
 =?iso-8859-2?Q?/jRyArUzrSRjyTk9C/qx7hhhT8iYBBqBKxMwBwSsUn+/5C1AJTDBgfP+rG?=
 =?iso-8859-2?Q?xhzyq9EBRugMTAIcC+ydiBqCkUKXfhJ759T51fTzJa/Y+xZ4/HO0l1KMC2?=
 =?iso-8859-2?Q?illGDB7XicQlG+9Tjcnsm0UUocOVYC2vS9ceL+edv86Ed2AXug2cSyrP6X?=
 =?iso-8859-2?Q?IooEY6uf+PBFHNPnp/Pqg0ZUPwJ8nPVEgB2VBhO3uu1mJSozrV0zOfeL70?=
 =?iso-8859-2?Q?pAWvSQnpTIB719bVVxCIWTCbCwzzygvAJpoIQWYtDplAxDLwN6ojQdNi2I?=
 =?iso-8859-2?Q?Bt1YYM6JECd1YGA2QhXbjl2cUrO8ZrUJMtrJZV2s48WC3SFC7uirW/d/qt?=
 =?iso-8859-2?Q?jvsngyW2qswjQF+gFtXU9rHMJgDqYakDxnEG5JTsIy7tfvVZisKJ+XttbC?=
 =?iso-8859-2?Q?khfJeltswiYORcHUkoQOvzj+mCY8JpeTDUiWO9F92karqYhRfDdlHzPc5p?=
 =?iso-8859-2?Q?tZWwOoWOdBSmCYBWBJQ0vExTSdJswrpUr6O3gV2GSotHroE/OE8i6qrFbY?=
 =?iso-8859-2?Q?6tUYL+6OrIRrliw8sUJHqje7/uYYAj4zLDkXDeY2pG7sGE99ZC9TYeyCov?=
 =?iso-8859-2?Q?1jcrcfu6hCg52/GpqlVBdEaQznVEPTn/TZI6enugYMUyQP+OeZPEwjJzHL?=
 =?iso-8859-2?Q?WXFJdMORyT816EpPORI934icttVzFdjuOZLQn4rhufCdoeOKBgeo00iZsG?=
 =?iso-8859-2?Q?R2F8WJd1y2cQ90sg5i9c7ekI/vUEnoD8ivJk9/spckIF0u2Y5hd3rsjtAF?=
 =?iso-8859-2?Q?czZaPnruAmCAjt+A9QirCg6JpfwVQejLr4pvJjLHTFy5mcOZiCw15fzbyS?=
 =?iso-8859-2?Q?9o4XWLh5hsFRprLUO539oEORwk6pR0KPGnwLvmP1XKHTqojuTYoFwbJQ?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33dcb3b-469a-4be3-01b6-08db40b641d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 09:12:53.5315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +hwkHPoxkKnJcP1f8c+Dzux0kDs0UTAHXZ6UZfXfGCUYrxYMvRJJqezt+8tG1XWbdiZwFlDFg3TjxsXQoM6UVsqLnd8/0H81bUlRYuZiWjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9753
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
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 21 Apr 2023 07:21:37 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.15.108-rc2 (6405847d6038):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
41747822
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.15.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
