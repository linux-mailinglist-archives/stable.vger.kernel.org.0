Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3896BB556
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 14:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjCON5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 09:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbjCON4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 09:56:53 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2111.outbound.protection.outlook.com [40.107.113.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22F98A3AF;
        Wed, 15 Mar 2023 06:56:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYZwBEN6Hp6W67OSXLVO1VDW1EEzTprrDuL/gI93ko8mEds9b9e+4+JfvjSyGnyBxMRCzRx88rN43htOzSbUtMfqkEce9um545dYVn6WPkbotFQ27aLyjK4hZylFZqbxnZkCtVGbDk2EnReBOSKLi6pWNMUzVMmyhL4DMfAuqy64uLVVofgSJQoVSZRy9e5OaTzLl1CKD/1mfNXli56rEbJ3TcwAdEl+erUoxn0XM9er3ELt3vOJsuDiNFEK6eSiah7GfApJ5CT6445uHCnqm1hc4ZFVtx/h5SM6vRXbP45x+kFX96oaAsdjIyv7TqVr1x9w9Yd4gz8m3/memR+uzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmR1gdouiFYSqOw6/0xgPuSY5YMoqQX1QnT0I3EE9x0=;
 b=FSrw61OChoDdGOEiRnqyff4ndrijgYenSb1JBcDamsLrWvq0qEhJtZMHJHsHbhoTibXgPY+5MF9/AtUc0Rsn2IUhAVo07bPsCkLxE7uwDxxc2+Rv0SXo77+69y7GyXWI7tboSxIAbI0eaOm1t15VeR4zMwIRY9kYpR9ROwFh9A7Mir9O2AjuO2PSN3cWwKbOm4FEO9oQmPCLXrh70O1ltzI2BuJtZ17xCCvKbR439Capx280hOHhsDqB3Nxr8YJJ88COZFPfwzwJ9o/JDcJG/RGlBC+fJtoOYlmDAmogodwqLf8Tl8l3Pv4rucUixiHOeb3oPP2VvIQEcg9KtKsHJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmR1gdouiFYSqOw6/0xgPuSY5YMoqQX1QnT0I3EE9x0=;
 b=MQaZ6+7aiPpG2cd7sa2hmkzEGREpiWntbps75U76wb9AqdEXyp+jloN/AR5Qk/8gmXjOZQ7DUFrnhU4aX5uhUf3TyRGbtcnrI28xOWBcBd+S8BLS3jBbCimHkQuLrGp84Dji6FhVGsOHWvWX7t7Z6vYCGbSna2WwR7W/6O5Wq4Y=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by OS3PR01MB9977.jpnprd01.prod.outlook.com (2603:1096:604:1de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Wed, 15 Mar
 2023 13:56:38 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:56:38 +0000
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
Subject: RE: [PATCH 5.15 000/145] 5.15.103-rc1 review
Thread-Topic: [PATCH 5.15 000/145] 5.15.103-rc1 review
Thread-Index: AQHZVzlWVNAQul5DoUCnSV6LfPc1e6773SWw
Date:   Wed, 15 Mar 2023 13:56:38 +0000
Message-ID: <TYCPR01MB10588FE6A40C38855DF712895B7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230315115738.951067403@linuxfoundation.org>
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|OS3PR01MB9977:EE_
x-ms-office365-filtering-correlation-id: 4158d9c1-5de3-4393-4c4a-08db255d18da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V5T6MDUESC7kB8VoA5kxuadwIt3vHfqVqP58EocqkDXyf5tLmaaC6zBVeSSdODISEbPQR+gEmwdIW6IxciL9ciCU4jBAHjCQEeDNUHRKVB14auVT6j7JVWQiUkaMR8nypMfWvKE/8B1k+1ow3CpNRsKnE2k868bq2CJyidyahg7aj8Dk9eOWV6Ws9sGo7EV8d46ulTklQEFmMEcrJRe5yLmX5ptoybP/ChiaTHfpRHI4ZUKPqZ4HjckRaNn2CoJ9NR3u9L/oerkY7RJ1YczWrS/m59u/QWeUo8ODnMSqit0ZfQThlAy3h2FUTpzE0/ZXVwWBV95eg7jR1N9oOoyrgTT+NgE5D3IefmgsODppQD2Y5xLh6G7wEWYqDBSn0bIOzeWImKXbjJOlFbxxCBcUpcqkxVVGCqqCpzzD/UOlKRXxCIiylU2vlKDG3e+AFwOMb6olmGBJphgu5c6lyTjEUGkAjh/7m3UG1r6Eis6sAxpkue7AZMUJ5IR5UBmlB57EYnBJ4p9mDCJ2bG4AvWkM6OVNuCnlvvVHogcbg4WCkqAIGshrrVeA0EPxygY5ixl998kgORuBZqMTnPoVl8IvlMmtzrWwzhBVQvozKoa8v+bhsLn+lV577mqByyYe/6DODdVO1pwQw0wK5eTPsM42Nmd8WY4gUAmnItC4VOe1eOOP7D5xB88I5OrQcgvHTwz+EJVTt6ODZEbFRzfWAFSp1kYINVR1V7SA40TyFZEEqBg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199018)(33656002)(86362001)(38070700005)(38100700002)(122000001)(2906002)(41300700001)(52536014)(7416002)(4744005)(5660300002)(8936002)(55016003)(4326008)(186003)(9686003)(26005)(6506007)(54906003)(316002)(110136005)(76116006)(66946007)(66476007)(66446008)(64756008)(8676002)(66556008)(966005)(71200400001)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?b/Xbx2pHyAzoshTSxx+OraFrVdtC79ME4nRXHxlWR8upkcrdLbOz5jh4l8?=
 =?iso-8859-2?Q?gXEG2RY2R+fsns++1Pqa0HCoZ6fTJjIlY7Qcz9/xjNajAXC7gk6ELQdV1L?=
 =?iso-8859-2?Q?ClnccNunPx6mnuZzsIk5r3vAfWabptJw9gWtvQXJtGvp/9lVrhckubUvRm?=
 =?iso-8859-2?Q?4/JL31X//jeYVtMF2AGdDt13n6KUDzKFqub5+gUdg9Ir6bsLIah9JRDMbD?=
 =?iso-8859-2?Q?ACEerGGYXRNFMDx2q2ug151RcIB060aMlPmb1zRLM+fk1BVNoTLlFWpxIw?=
 =?iso-8859-2?Q?EjrII7FEvncKtNuIETv+CaaFAsxnebu6BTNBDbew6Lq5GHqoIoZoXSBB2B?=
 =?iso-8859-2?Q?lSX7RfHDaNNnVyGcQRiTqJzTxhagEW5jmflbvxdWsceuae6YD26XWHjOJc?=
 =?iso-8859-2?Q?wQ9ZaatfKk9kVpUUBuHSIczhaKBqZJFMEPJrWHqoFryOjBkiZsTiOPrnl2?=
 =?iso-8859-2?Q?JSCNYO6Qw6V9a0NUmzLCD+lGAOZ0buWRtHsMMT+UmVRq65os8dGkxVkQ7a?=
 =?iso-8859-2?Q?imuoC/MX8bEWD7UpXmKRtN9TNWPW126I+Rw8iqU9RiWJCm4eJKm08/Qa9T?=
 =?iso-8859-2?Q?mbJV6vlkwuQfSRSRRO37YaPUwsUqQwqBIb380h23FVnF9yZJ719toL8Exa?=
 =?iso-8859-2?Q?a4uJOzsNOEqHlnmIh3mRHQmcOZ75CM5p4cgwUe/U+V4rIoAtvZOqImQnvW?=
 =?iso-8859-2?Q?Z6G1qMem3ltQasp2j4ugTYer8DBeec0RSgF9mAX/8Uj/SRlBY1+TEs1ggG?=
 =?iso-8859-2?Q?D6x/9y2KS9Dyzj4rp7NjQJPtx97xbhJ8e2ZAosnJBkHDIDnjMDZYdE7J12?=
 =?iso-8859-2?Q?nQ2qoLkOJdFxSAx+P8ELutJFgrE3v/JKE8Eb29wD9b0HBho+Ks3BCBR6PM?=
 =?iso-8859-2?Q?7/FAuykJel3YOK6+DUt/z27vqE5lWMcPLVE4HRVjTCJggkH3B+3HxYPW5s?=
 =?iso-8859-2?Q?ecipjHRJyFxDN08sWKEBxz5zd+CnmByHsu0WoLwfxhXgU7HK0PuelR+yNU?=
 =?iso-8859-2?Q?vg7HxLpRhhxO6hfwnAy+vHwSeGc6AuPYpF6vYKkcdz5IeAoODRHuOxOKIc?=
 =?iso-8859-2?Q?UyUKK6uwgrm2FHSqUWqmq37Ix0dwfeTNOSIH10CbdnvLZM7VuV7pGQOnID?=
 =?iso-8859-2?Q?euyFxsXcIfEi0hG5eokGrZ/vdvZcINc0qogka3pnAx1BOclf0tAK5mnQ5K?=
 =?iso-8859-2?Q?wMg5ZdotzvJJdlSnt4w82VEmQ3bmQUc3TE+wP1KgDXHFICyW2uXMYJc/X7?=
 =?iso-8859-2?Q?S6lgFsHIDeyEJtZ/jqtJpjOB9OpOixGU4qg3rPHZC8HZqT4/tnHMJL9C+F?=
 =?iso-8859-2?Q?Uch95OKqv/mSnCA/it0OutRiwgpwjp1hXHMjvfb5gQjEVgPzWPQU1EXI2u?=
 =?iso-8859-2?Q?/pPMSExfeZAmpqLYUVLb9jR7gIHLJYZBauJhVtPhl2reZ9t0+zgp/nJEy0?=
 =?iso-8859-2?Q?tFBV2LLPs2zc75hQxkz6YJROIweCfkbZqUFGPEFbYm+PlBS/f1hK+BTh9Y?=
 =?iso-8859-2?Q?Mjp47Bjvm9oAPHC3KWcowmXKmI8ruB3KqxDVZ3PruEJac/2ti4cA9grvrI?=
 =?iso-8859-2?Q?KOsKc7tPM/+OPJ14g6JpmD/4QeaiyVqB1lnM3EKeRqBhY0SySQgNSwHeDs?=
 =?iso-8859-2?Q?TukJxCmk2PFBAdSHrzYPZJYoi0y79hqAh7OpruHM/M+EDiswKNmje7Kw?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4158d9c1-5de3-4393-4c4a-08db255d18da
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 13:56:38.1578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HjnAD7XtYcptAdQIxd1flM1sgREhdJ1KmeQ5SLnf2l6cr0acR/L8Uai55pO/QFzcr09sxPd5kb+7ZxyMY1wbXLkzVFC7inS32eDnqcGzqD4=
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
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.15.103-rc1 (158686d9d0fd):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
07195776
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.15.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
