Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642636BCD90
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjCPLI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCPLIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:08:25 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2135.outbound.protection.outlook.com [40.107.113.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F76E2385A;
        Thu, 16 Mar 2023 04:08:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GcS12MlpRPW6J4yXo5M8N04DA+9fRZnzAs1BHOkO2gnEzAB1JOGB/GBl34CxKQBkPHoxMnV1mehKGx/elpfXASncUdi+Y2+Iar9WqXCWmPrO47NSgNYG1mRWaY8FrdzOBM1vwM/bYC333IHNu0S30LkxhjzY4/c9ZhD20xqMQKqkELNJ4TOqAzBl9qPjTzs0atyuPlH5xp0tIRqn4/M0074qOp6Q9CjTF0y3DTvufN8z60hjWtXiuoWx2QV4cIFcG8Q9ifHVx77LLbaGwt9DdcMok8utYWw3FmRRYqT7pg7L2VaXhVUzMqw7IdV7CcZmGUTBT1WDdQKspAacXALXtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x03/wRFlSij/caXxnIo/AGC90ib52kScc6s4i8uDu2A=;
 b=NpPW4xJOP0iGvXRL8Io+xFJ95iZ82RxNeqI/oGqVnzto2gjxd0L5iV1wBhzp8FWCdV13MHsQUNChY7rT8ehhMQO8heHnPhRncWAQuTGBuPfepfjsUIVDOcLt3RBCs6PpR16mjdUGSBNZ7rFdyvVIQe+WOINQnll01zK0ON+z2B5DURSDoXxxg92sHmsRxx8CpHZvHQlqzH6k/3lyv4wWcFrNIcDIcUibQtOLBNfzJqOvPxL60TuC73iJVvQxRDot5d/dqSIrKfoYYpuAZua0Vc7wZpR7BYP6lbWkZDB0MQ/K0lta3p+Kw1P2HwbqhQHjcnbDrHeYbTMSO0Evill+6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x03/wRFlSij/caXxnIo/AGC90ib52kScc6s4i8uDu2A=;
 b=ZqOFGaJsaHLPD5s19FHeT28DmQ2LE+J+2v9xrQyjk9nWkRePbn/UkZF6ROwoV6xlaL2vWkajYgLEUBlbxOsNaV/ep3H78Wnv8cDDgIy4vb39jgE72PikdCZWRC5FO5ANozWRYiQH9KA9ZOIAVlQAE/8sj1njbwM17JJA0O9Wdvo=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TY3PR01MB9859.jpnprd01.prod.outlook.com (2603:1096:400:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 11:08:21 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.030; Thu, 16 Mar 2023
 11:08:21 +0000
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
Subject: RE: [PATCH 6.1 000/140] 6.1.20-rc2 review
Thread-Topic: [PATCH 6.1 000/140] 6.1.20-rc2 review
Thread-Index: AQHZV+Sb3KYt1UpITkO3dN7eeQoGCq79Pz8Q
Date:   Thu, 16 Mar 2023 11:08:21 +0000
Message-ID: <TYCPR01MB10588BDD8E0B11AF649CF2CD3B7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230316083444.336870717@linuxfoundation.org>
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TY3PR01MB9859:EE_
x-ms-office365-filtering-correlation-id: 666c8497-0bda-4670-0f8a-08db260ec109
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /lIVAFvWcu2CPLhDD5+kf4LOXxZkB3K1eTccMXCn4oZltvkpvEwN5GUexr2SipMR31FTBSuihbLWhJcSOWvXgEf1SWZbSr/52F8ZY4Mxi50YvyGFuZIquf/yrh+DE8dqYc4IUtP9tIE7JTXbk43SY6/VF58P94zHXXVQiVlPRfjctLapZwinwll+8fnDiMY1L66A2iQXONc/+S6Iac/Aq5JuZX5Z7OMQcJ3KPpeNmGb2Q/UAO2zEshq3OBlZUbMDSHvshYURAb/xjCfTIKKKFrlC3GtHwO9PIRPytr2j74HFeHx6mZW1EZeMUWgJfFLAWog/wzc9jEwGaSC4hHs5nCdDHuVc9V54+LCxkbbLnCI1mipAYyK9T3BJgV2iCafJX2AdmWvnDOuMqx6tK1y2r6fXTgGXiUdi2DnXlGD8gZSUWfYRugx+o1FkUxzP3ozLvARDRePCyvzFHwgOAUOxp32J8xWIcXJwRZbjaNFaERjtayC1JV3YJQI6BzCOgReloOUBfeOezzw9dazJJy5Jl+SVJjtGWGadSagS00f1aamznqGKUoX7L5q1dDQtMel72u4kJVPHvlHWHOT44HURmKKMxSTkWfA7sIAa5G/7AMV8W2uWZ0Gl4rxEtGWjmXTevb4ruomZnqvZO0YP8Wg4G/8fFOpcR/DRkACAqI0PIjOXuLRbnVgpUCsCjOZrChB62bY+WORmlCDzKQknlpCckhxaVJ5clJ51qj3kR5UKfE4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199018)(86362001)(38070700005)(122000001)(33656002)(2906002)(38100700002)(52536014)(41300700001)(4744005)(8936002)(7416002)(5660300002)(7696005)(55016003)(64756008)(66476007)(9686003)(26005)(6506007)(186003)(110136005)(316002)(54906003)(4326008)(66556008)(66946007)(8676002)(966005)(71200400001)(478600001)(76116006)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?IQzMaRA6vk62FisMv/t7ozREFpxasnksxf7N0/3IwRazFdm1BJDf8hgpgX?=
 =?iso-8859-2?Q?+m9ezct21sNHJMS8rrDYFQvi4gBQCEJ6TC2cGE7RujPZ1vXdpy3krcQ6E9?=
 =?iso-8859-2?Q?rAxyev/aIxehthQd9MzKiuz9sA2nIU8nxOohwNZhniSmuheUJP3nG3hley?=
 =?iso-8859-2?Q?XHXkeKiVkva+a9e6am1nn78NxIeMylH3NlwHX+N1z/5sUTtXH1EDfLllvs?=
 =?iso-8859-2?Q?zQxrNxl7MhBC00lXQLrzCVr7f691yv9M3/tEr6S+QVuZLexUgxmceG8MsW?=
 =?iso-8859-2?Q?Ev60jIhBmU0RXreVJb45JP8iq7AM0xxGuYPIvkR+F3Fqa8ZFet/Cdd6GOi?=
 =?iso-8859-2?Q?Xn/xlkYtfB3v550ddz8BnBlga+gDnejdMm+Pu44RkIRlqgLmZYvTjAZ02f?=
 =?iso-8859-2?Q?c0uRNMo5fV3rDW3YdNLCUa47ctO/PALbryuXERpSrkrUXVKufUONn/qipj?=
 =?iso-8859-2?Q?yWLcs6YuXX33Aehme8Mkp3ukVugtm08cr6akYVLPi0jEzEPYLy0Rj7nOQA?=
 =?iso-8859-2?Q?Mb2LNFAsX3up8XT2QNviOm604z3cXQPoJr0xxMhlVj34Uozh9xKBj5is6S?=
 =?iso-8859-2?Q?cQhGYUkaddDSduGaS4HgttqlqEf0eqmwl8Q5R0JEOY9aoMSTOZtYmAG6XG?=
 =?iso-8859-2?Q?FXrIF4jlmoPLs0MFEzMArb3T1RafGm93AZrJR+OkD4Tpl+JFTkaLwLrWR4?=
 =?iso-8859-2?Q?cw34MjYmh4EtTRV6i3k6h6P5h8XTU9/XKhCQj+8Pft1J3p+WRmFTAOgwAF?=
 =?iso-8859-2?Q?wMdG4zBLbNDFm7VYYVvReqSMFwo1VcrwJEQVpF06fdUDgtWKpVdltBweH5?=
 =?iso-8859-2?Q?oYG0VJ32mIWnJl1UsCAusMIB2qMBKSDXfR5JdsRcuymLozK1bsjxC0p83I?=
 =?iso-8859-2?Q?azbPopJkgI3l4R4Ez8EQV2Ee3GTNSSF2mKkS7RlBXG76VeILkuYRT1NEdU?=
 =?iso-8859-2?Q?MG2JOqWAD/j9BMzElYwc2CJVgVEnswsWYQ4RkPWWFnWB8ysk51JjjBNP3O?=
 =?iso-8859-2?Q?FAQ4Di2kX0bdFNxvIbA2GOo29/aVPeMi8l0BZvcNGayUxVGBvU/C94TnSU?=
 =?iso-8859-2?Q?ANGqwntLg5ipbfV0sUMbwZIeJZ1nzeTlVW5/IXK9Z26VafAYt1gnKas49Z?=
 =?iso-8859-2?Q?5/hJDMeLvsDMFWLppdAoWPwvh7E+TCm1i8WfW8rWpLZyyqZyT2T0oorP4a?=
 =?iso-8859-2?Q?85K1xeibYuaRePYJHyA98hC96uh1rckLwBIX4Pnz5TR3BXX4I5Ll/mWf08?=
 =?iso-8859-2?Q?OfCkTRxqxJ22xEpRtedZqdWFZQNnXJc0Q13rS1uUOUt9IUnPbktW+I9VdJ?=
 =?iso-8859-2?Q?YkXH3cbb/LxiHabMkulh/5CCMHwsfct9RVd21VZRrRDAs0Anljvey+a8N4?=
 =?iso-8859-2?Q?tsAnHE2ZTM6AaqLaMAUZ2E6eFcsfM4Uh0/HMxxusAuR8rczRB12mJh+S+x?=
 =?iso-8859-2?Q?/dugH0E0De3bRvO/2O0UPbGLBc711sVt6Oz93N+/LmajTBfElGJFqHsxpn?=
 =?iso-8859-2?Q?+NxBpq4l5vc7DEuaWl33uK5qxHmxiSSoPziKY32KRqChYPA3P67IKEFbiD?=
 =?iso-8859-2?Q?mRN7lR2R9vtGdmFGQiUBCLTunB+vDzNJjPdgLG45AP9slbg89U+7O6NyPD?=
 =?iso-8859-2?Q?s6fGlyqvQlD5e+LRub1iGN9MUP2UxhQNz3B81KzThE/xB5AedSA8DIpA?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 666c8497-0bda-4670-0f8a-08db260ec109
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 11:08:21.2738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YRgrsIYnllDNqQ6WNchj2X+Jh1vnZ6kICL2VZ4AT9Vps/pJrI4VtM+qjASNdnRJVll7Q0me90/pRza4YW9LxOEqEidOie8bUk9VLnqFe+fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB9859
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
> Sent: 16 March 2023 08:50
>=20
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 6.1.20-rc2 (7887563347ee):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
08352718
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-6.1.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
