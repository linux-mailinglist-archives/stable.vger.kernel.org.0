Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D729E6BCDB5
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjCPLNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjCPLNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:13:48 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2128.outbound.protection.outlook.com [40.107.114.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3B12A990;
        Thu, 16 Mar 2023 04:13:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7HeRBZhnMiKNeCk0n34JVQx61HzLupNsABTE9q/5jFbcx5Jp2RjVkkEFRJuuHcj9UVdPMG2KqHegiQpSbmLiwpuXWy1dVjYMjuLcyMHHwxIwslWn0q/u6ZqIzXLuxjVh+otNY8v75mPt8dnZa6v+PngheHf0IxASsI6/0f/WFe6vjzVYWTjv3j2bH2/Ath4M+EYgvfQyV4eVqkEsA7x9+A2MAdoawp66dQ86UfZ1WGYWhOZi7PgVI9RDIazq7A9bnzBPNPB0wanuqG0IsHT07ftiDvYXnM6wLqJm+RoECMPvHWBAk222jStNS2uuUe/tAX34CzW9c6N+iCZ6VD6JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7lJZsGyZX4ZloHAAkCleHVQCkX4I407tUroTb40sksk=;
 b=TKpbNrlV7aWdnoj6lI85+rrmhQUllZ37cj9DPrRrH+zyFGC9msA8w7VjuhSBRwP5w7jPMUU3UD5oYGjIqG6xGgdijsoSbIdr9Y20ffKpG03Cmhq2ZsyyhuZNuHSv9kIWPk7ouugYqhNaLZGP2coF0Rq7HFGN/mVow5b1V5lQXz0ZjaxkPwYcdB3aFDypNHxE/jS53/EgmB+hQ3gy4nKDh3aKM5C0ZhyeYcus2TvZkrN4HGliXCMUWWYwI2Hfhyxr8i/rzLLmXiZSFaR/s9ZDGXyLZDqA9FN2ScUZA9zC/eeSQJkJZSoDbXjG5m4JvTOQA5quT5+A88uFTDqWh31SNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lJZsGyZX4ZloHAAkCleHVQCkX4I407tUroTb40sksk=;
 b=PlGSKvzzR6esK9XJ3AX9T5tCcCt1GQCb7svRvIopZItwqsL719zXiiJOdIAq+ocHolCci22yKb3irUO4T5Bm9EEw2hO2sbWB5sDHXVI1T0vQKCLi4/363KVD7wOnU7Zcjp+7CRtk/sZXpv6ftz9/cqCOWVKjVyJjuZ2B4uToknE=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by OSZPR01MB9633.jpnprd01.prod.outlook.com (2603:1096:604:1d5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 11:13:41 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.030; Thu, 16 Mar 2023
 11:13:41 +0000
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
Subject: RE: [PATCH 5.4 00/55] 5.4.237-rc2 review
Thread-Topic: [PATCH 5.4 00/55] 5.4.237-rc2 review
Thread-Index: AQHZV+RTRTu3S7Y1OECCZQyw0OUida79QJAg
Date:   Thu, 16 Mar 2023 11:13:41 +0000
Message-ID: <TYCPR01MB1058858745E9067B2D2B3F046B7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230316083403.224993044@linuxfoundation.org>
In-Reply-To: <20230316083403.224993044@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|OSZPR01MB9633:EE_
x-ms-office365-filtering-correlation-id: 15e3a12d-46b5-400d-b6af-08db260f800c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3RpIao2HJV7h80EPJ0E9InXyD7TFHR/IX2F0e6nEcAftR1bw2fqw/pIYWdS1LDDqWzHoGRLxuZl8D8kbeLBZMtZtcSlfBpV9BTJTb1oaY/SOPf0qCHm+440GC+u1KFgr8DXPyKG2KcDaKqkluB7LmijF164KKMXoIJ9M/37mle2o9lLo4EXgj+FfXq6q6qkzTf0eOjDpeNDuX3cAjxgC5+8Cs1BXwJoLZHZ0Bs2dfMa2uzIY8WXvEHihqpFhfeupknZot3Upmv/FeKQN+zrLCZqwYzNO1NH0VwWd4dsI3qgSoWCBYbTU31ZhrXikGQ1SGBvoEilu8AE3+BDJD6cLAhsUr5lyAy8wGfINRk0RTAiuq4CKopjWIh3zsyuMxXYBksW8/pUau6wnAgcwb/2VjnEQ/55Vue4xS5mKCWPLEtBv4h/VxkKxf2DmxRjvx0akZKFCF6fb4bgb0n/wMNhhBrMDGICuMzpLEgy5Uar/tXjmIXdT0quV0dojt06yO+wMKP/uH1xCEotRiGJI2EHeFhWDgyPDaz168pGGqIewo+nzeNS6CgQt0xqgLV5Pso8haYct5glTB7hE+H5/rIq4Xkwtm7NJ5h2Iknq27vzdhXEHvLpAvPC3Yg25dStMbsrGMsdMX8liGYXinL6Mef6alaVPfQoNI8J7Ms+Y7oqXRrDv8UMr6FVvmYLqJ5mBLn8sziUvLyN9RJa+0GQuVQMGEX823aDm6Z3Zk7laIXA4p7I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199018)(8676002)(76116006)(4326008)(66556008)(66446008)(64756008)(41300700001)(66476007)(2906002)(4744005)(122000001)(66946007)(38100700002)(5660300002)(8936002)(52536014)(7416002)(26005)(966005)(6506007)(9686003)(86362001)(186003)(55016003)(316002)(110136005)(54906003)(38070700005)(7696005)(71200400001)(33656002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?KiVHWYPRChK3v13BLJwIQc29286yGOsY9wWXkqWLy0ILmstITMGanDOG?=
 =?Windows-1252?Q?CuaEE10kzhSUZ7yIbfqkSwpDbw65eQ8QDC2x5nRjgFoErDEywSYloBNH?=
 =?Windows-1252?Q?LE0KiKD/H+V2mCI2jhoHONqaCSWEWGuePvfMbHabbKrJ1tJXdd4PODiA?=
 =?Windows-1252?Q?xbtTz2kxTaQCck/ELRXDRIuoMWhP5gmfEy9mjoWSrJ+nUrEitCMMU8IO?=
 =?Windows-1252?Q?vvEit9pGOMjyRi1kBNEI24ZzR73z7RO1tZZfycm/Frpng6wAzed1borY?=
 =?Windows-1252?Q?xprzP15nW3/Vl+kBTxC0Olwr30QvvFUOlv6TkrRFVFB5yl7RMWrjvaAb?=
 =?Windows-1252?Q?p3W1zZc2o5PJqxpTxqAzThK3f1Oaqnl/MiM2xN39gHTdwAUXp6WO2WfD?=
 =?Windows-1252?Q?OFJw0TRPbAWGotGcZIRtRjhySxRNeCcPCW8n/ioheBkXiZ4MaPP6oa8q?=
 =?Windows-1252?Q?jCBV8Y1JwzC8AxCMmGA2sJlrAFG35KgyljGuzO9iyCAlsxFqRdvUV9dq?=
 =?Windows-1252?Q?hpof16e/6Nf9zjx3+6cuWeZQ+YJFYiuLKEDPM4YWBKABp4ULAZYdVYAE?=
 =?Windows-1252?Q?CT74frFCh5Mrwb07nKlyDpxorTQn4O60BMwzM8UvQep4j0Syd5PejtOm?=
 =?Windows-1252?Q?9Z6OQGDn6RqUfAmxq6hmoRiR6JT5M3GSkkshVPl+OTjQSg9UqxKgXKnL?=
 =?Windows-1252?Q?RKPUrci1Xi68dAItFGVDmprIt32XcSf66KQ7NBytrupFOzfktl2/TQt9?=
 =?Windows-1252?Q?NK9d+RVgiEFcMf888mveYInjYnU32Dcoje+VJOHge23No1r7duM820yP?=
 =?Windows-1252?Q?YKyN0YVYjNC38N3PZQFfVnt8/hJcRZiw90QS85XfE6oni5qtKBE6/HEn?=
 =?Windows-1252?Q?By8ewuNAQeySeyHSdkA4f6mU4KYZtukCyNID5+jhY+XkidRX4jBwD1Yo?=
 =?Windows-1252?Q?+zjEdpHVJD41mjgx5tEtaLqfL19pzi68FBcnn9R++m5FlrxcsHY5j+5R?=
 =?Windows-1252?Q?A66xYE4BiE7eUnlR1vuBKE3u4hw+jyhjar0DjVpCEALWh3GXXuvcrcGO?=
 =?Windows-1252?Q?rE6rM5/CkOd4Uo5MmXA84/iJbWMnqR7DmKb6KzrgnYS3a5I8IVttmDZ5?=
 =?Windows-1252?Q?0bC2UgFxVab9aHDJOgA76bXe0yGvGJr8FqRxnnW2mY51N+gerHOwbf8q?=
 =?Windows-1252?Q?B8/Y14mokEeM0C2dmNK0z53kIHsZNcGSBTjTK+bj3V2c6YM51nLAY23J?=
 =?Windows-1252?Q?be5le2YPm4GYD6d5+20zI1VuZQsCB0daKbjgxGduXyVxMGXusxGOFP4s?=
 =?Windows-1252?Q?r+3pu2PKRAWhSNsXi7SXzVHfXltlhUxZmyKI/opx5KJ4sWkQvj94UWhQ?=
 =?Windows-1252?Q?VAQ1ouqTlEkh10P0+LoOPNEimELHpcXs77PiueKkazqYRCu+utmIbi2o?=
 =?Windows-1252?Q?zCFnH89kklCBi/l7wblhv/sTiB6HyCx8NS9o59BSmmL775/1FY5bmn75?=
 =?Windows-1252?Q?9zS8ocicTsqsQCh9pReSFIoV869ALgI46lDfzsUaaOnzpjcJCpTNDXhv?=
 =?Windows-1252?Q?FuJI02VUSJsGxWMmq+tyrXLNFW8/L8GRR4Qywc0ixebDPMR2FpyMSE9q?=
 =?Windows-1252?Q?4owRaQcybZ2zC5e9flqvmF9PXUtHzSboU/CteAA3+iYsYlteXwBBZCCX?=
 =?Windows-1252?Q?SLhPpwcUkg2UvAvb4g256oNyNOe/tYsUhOO9HD951Mx1lffTHpr0YQ?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e3a12d-46b5-400d-b6af-08db260f800c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 11:13:41.7582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UJyrehgCxpskuRsaloaFtnQ83KvHd77EdRbU8BRKX5dgjBFSMAnY7i5oIMb9B5rsSz3BmKLptPaus+QUTz6LdjrgpDJqhc/Hu10nz9FqW7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9633
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
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.4.237-rc2 (1baba0e91ac5):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
08352559
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.4.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
