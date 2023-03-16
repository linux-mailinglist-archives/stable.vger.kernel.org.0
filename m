Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DF76BCD8B
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjCPLHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCPLHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:07:30 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2090.outbound.protection.outlook.com [40.107.113.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C94CA8838;
        Thu, 16 Mar 2023 04:07:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2Pg1rY9vwsFWNec4UZN6xyKx7Y4at8gjausuNUAfsL1TVRr0ltHz1NxEOUrVy13DPWHMk/ta8v0oDJI5tgPbludmR6Lkl9H/xqPhQAIeIMic4JknZqWYEEjiIuWC9k7sxN9mK31rMdY2AUUhwDlYL6XQODn5sl6FBbvX7XoOwOccgYNJKmzsJwMVFvV6iXVAuoKnYYWmCEhSODGUgONaGHiUstpr3gfIT37dAr7XZD3kpSOJOj5qP1fFgUnvINDawmRCrxFdmtA83iEA3pPyBHytEzSCdqKf7UYQx51IObhP91PglGhc9ypHTTwBmDcJRWVzntnD/SVnTWWQ2EZbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHJQL2hnll4SnHPFsi7EgdHTrUdWlKUzKO0uIhWLAMk=;
 b=FRo7ShYS5rMcjWY2inAYtLpZP/yGni1maNrOMnMPm3OvCnCTtyL7U4gBm/wLkM7qYvBz5QTl6qvuBlUaNYe7/2Mvgy+FIOWdrqtYffegEA6SMKNL1PrRujmNkqPy70LvUl94E4wBg5SRkK9feMPtDOU9hxoQ0D+ugzEw0IlmRwAeilGO9IdfXRANZ1oeqmiRb/BZfK4Ifu1wTbW4husZfBfvLNDONyvIaoY+ls0BA3TbGhrlilgPNM9M1eXgAB4ex+TTq3hXiRfR+7AnqS5Qruy1g7PD1PwJD3/uDmyW0wqHVt+rIjG6h0E8UTw+0dH+My/DJJ7EP5ydo/pa/AsXXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHJQL2hnll4SnHPFsi7EgdHTrUdWlKUzKO0uIhWLAMk=;
 b=NsI6/zz/8VJeMvp2qcUfJ4T7dZB12jOOiR1bo6pXDXU4rEG+Hj9hq9rZ41gl5b6upZ89jWjGgkJyk/KxqPQajXTpny3x8vEC3h3Ma1FOU9xBB5XMggJz+EnLHCkwTotYxfScO0IuRDPVV8Sli6EOvPi/PUie1iFEUDyx+bJmP9k=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB8805.jpnprd01.prod.outlook.com (2603:1096:400:16b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 11:07:18 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.030; Thu, 16 Mar 2023
 11:07:18 +0000
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
Subject: RE: [PATCH 5.10 00/91] 5.10.175-rc2 review
Thread-Topic: [PATCH 5.10 00/91] 5.10.175-rc2 review
Thread-Index: AQHZV+RXVgXQ63SjzEKhCxulgF1dT679PsqQ
Date:   Thu, 16 Mar 2023 11:07:18 +0000
Message-ID: <TYCPR01MB10588ECDCA02B3A7D0456761EB7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230316083430.973448646@linuxfoundation.org>
In-Reply-To: <20230316083430.973448646@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB8805:EE_
x-ms-office365-filtering-correlation-id: b4bd2db9-63f3-4573-a9d7-08db260e9b91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lcuXzUmwceReZBkXuyZcvDkSSnPVPP1Se7qZAxdlOR/J4DD405j5pUcz6mxWQMXQZeIDJQS5U07qVPbei1OGT/Mz9PGUsxOTeASw7HfDTMOTUI5+DCsBnzYMgF+U378Kspcd/YhJObr0pK92A7NxTbM2efngUKicvbQLgD2kbL3E+7rWjyJNOWIhhEdrBfCKPTDjU3J8uxw2BZrqZQRk/m+6awbnUWznNm1DahM+NBJYnxNkXRUnpGjkDTphGCfUUxrZm62B8/zQH57JhkSXVE9rKcvq9U6OxBXkNEfI2y3gvZoSYl8mXdZ5AazoXcmWdyK/54m0eyCrt5yj1xzks+GBFkb/VLv+Xmqq0m3R3mVWZN0m2jz9TbRYo5RjB8sH9tcsSyX/XQpUQ+GExIaoMSginfbCwrLrLEF4EFWREwpxMC/PlPlY7F4mtvEULbhahGdjJT3qlCOgXuripsNlutzhOIRync2oDx9q2wpE/k/d0qtU+aWt9cSoPmiiKAQexkPTQuuyHXi0+RazpyOYPj0efIgQ6b2hQA7GQOM4h30yVo3zhlvGfSB5bssaIMn0n3785J2/f3vTzSJm+rrCShofkR3CCjnPtkGn3YgIKKFDV1mDWfwSmW66cgtFdRE26AkzcUZNnRc5kIf0CzKUyQdavKVofDovwri1BA1hq1OxVF0qIbq45B+ClSmkoD7ysSc+33Z18v6Z8/vYjE7GQ8JXsKcb0G+jGioY67rFvqY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199018)(33656002)(86362001)(38070700005)(38100700002)(122000001)(8936002)(2906002)(52536014)(4744005)(41300700001)(5660300002)(7416002)(4326008)(55016003)(66946007)(9686003)(186003)(54906003)(316002)(26005)(110136005)(6506007)(66556008)(966005)(76116006)(66476007)(71200400001)(66446008)(64756008)(7696005)(478600001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?Ojz2Sv9DIOIzrk2I9MYM9zxdBnBhfFVNb6Hg+BXmpUNZJQOAAlbfL745Tq?=
 =?iso-8859-2?Q?oPkfpjOMjYYDlE8ZD7rgd49ADY2ZUoe3qR4k5MvDfxEyM2wnCKl+7ppuD4?=
 =?iso-8859-2?Q?nYHIuhtLzrif6Lhbo27cFrQrdcqz/gfjoS8OSJhPmLHxKeTSuosHqzXwwv?=
 =?iso-8859-2?Q?8hxqB6Er8wri673ij3f2gSrNtVklVZmZm/w31jwF9Trcjxg43QiwUaQDBv?=
 =?iso-8859-2?Q?w1dyFEjJRMXFoS48CURJZbQrHfXN4bZZtUL8b/9GEKqA+rkJ1oovQwe4yg?=
 =?iso-8859-2?Q?lZvGDSQnd8E1zXr91DBzjznz5rDSBVEE5iYTqudF/xb2pxwVjLOB4S4VlR?=
 =?iso-8859-2?Q?IVNbnuMcTLrgAHzEJdMxQO7ptahYZu3ZbtXJTe1QH9TFUQ6t02Y19Iggby?=
 =?iso-8859-2?Q?UejTnnsL+p7/SvC208MWiC02BDx7tAChxyQ8qdGzdaocmjJSeW0koT4HXR?=
 =?iso-8859-2?Q?WustXGqhmGXrw8nYj43aF3aIHq47T9orFnPLudP2tJL+W3HidVnM61smN7?=
 =?iso-8859-2?Q?yuh56REnbk5eutnMvLLS53ZIE/axEAx02lkeM5CZBnFgdpw9gfsR7hF9e1?=
 =?iso-8859-2?Q?XUfIzFTiJWBvaX2fZYwp/K79bG5j4CeWkziv036tOAMIikXYwLNvMpUCMV?=
 =?iso-8859-2?Q?uSibb2vuPhxyck9lbXI3WqMLsyONcdq+JwTtvB+cEe0kzT9NEW+hzMfPCI?=
 =?iso-8859-2?Q?3UDqBQkaYisXbfJJwxbdCl9tSSxJupW1PUfCGzEOttQhAWKuDmG96/j1fW?=
 =?iso-8859-2?Q?ecnbGmbpcFJ5Tf/zLZwe6i/uF7rlBDAojhYsnk42RPuLYGUVuDznPiTSmW?=
 =?iso-8859-2?Q?ezv11W4yp0wB5Edsvw5d+8QEA0mTnfl32T1ltw34WW/v7MvA4BgqkM7H7q?=
 =?iso-8859-2?Q?x30hLLItMW06HX8s0nRVA7AMgnsrTvK4uGLWOAGRAox2ssfatihr3WQ4Co?=
 =?iso-8859-2?Q?YwPdlO5AmpHVhIFpWqnFHj6K06ME9oJxUIZMZFXghPwxmjR+5BgHMU7WEb?=
 =?iso-8859-2?Q?voJvY82b6e4pq1ry8Jx2Bweigh3JaX6gx4/fNM+fEjBPLbM0nfpncoISU4?=
 =?iso-8859-2?Q?atyrPGJ94xFeID45p4b0q6kVKu5F43Tx6+SvfaATzpKI1w4DEzK9hZxDa+?=
 =?iso-8859-2?Q?kyTIODqyBbVtClaJKeNegwvTzWYskwcsQg4yhdzxHv3+UfjiOMxfV92cWN?=
 =?iso-8859-2?Q?xnU3rFvd2iswDQF5gPcMvmSZPapBVm+5CSMVZPjekZibdhJsTVz3F+ASxM?=
 =?iso-8859-2?Q?EtdyU8AnnWiIC6HQNVwvrfwz+QIM/h5xwUDZKDt3WTfEu/mRN7b3ey4TQC?=
 =?iso-8859-2?Q?gDgeQsM8oPOqyHEN1r6LWdJeh338hbQASXYc/r8624qn6zFHbylNFfIQW+?=
 =?iso-8859-2?Q?93ppzDIAhGlQMWYk/BrVltq4+iSswaBa1apPcVfBt53+DxPg5wDUgdd5Zx?=
 =?iso-8859-2?Q?92vbEe8gl+XERrHO/CvcyHblXNugOZoN5s7w9OuEZ3SQA8QBqjo4Ov2ZGV?=
 =?iso-8859-2?Q?61Lh+S7Jy51GYTDr7LlCuhGkyjLKQmaOdGYIHxn/hAEIjWEppKO2Rk9oqO?=
 =?iso-8859-2?Q?6pK2k8IOnPKhhO2cEBW7DmB30+kOEsI44FvqhYI3RV/fX8LeAG//xy+mDu?=
 =?iso-8859-2?Q?BvVrFV51SMwzIFA63mq8m1EKX2Z5hcpLHShtuTfln3FrqjYUEDF08s2Q?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bd2db9-63f3-4573-a9d7-08db260e9b91
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 11:07:18.4000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f/0EMz3FlrEcV7dCN1Rs51c3+ghRcTyax6V9Ee5WQMOp+zFEdshHVXDjUMg3uM8BjwoKee065WE/IcFybNU0ni7JSxUPVzT1xm0acnQ1hoM=
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
> Sent: 16 March 2023 08:50
>=20
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.10.175-rc2 (ba6c29f68bb2):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
08352724
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.10.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
