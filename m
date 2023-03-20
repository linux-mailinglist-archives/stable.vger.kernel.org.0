Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7A26C1DB6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjCTRX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbjCTRXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:23:04 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2072a.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738BA12BC2;
        Mon, 20 Mar 2023 10:19:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMUou0XdKovqQiKqXoyFjRKK8q6nf6u2UBibXnNjr62qIl/L5GN6ckrCu+Y5sYJcegGE6n/fwAuWGAEZvx48uGYsSX5GuewCKZvhRsJTk60goyseUQ046NhlQdJxXs+fp9/x7CFI7NqdObYrCgY8pg5pCFBuenEydAbvfsfDCZ5w+E1TL/8X8+QVr0mg0YJqj0yY7WGMTmW9yM7tcpSmpTTrE+kXhRvYllsFHnRiQfT5kTeIJ2imHO1m4TVW+LIzGzWu3KMnA6/mm1tJ8POW3RJlLir4EPvRHXoV/PQGa3W0+mpRN+bTc95N5Tu2WMklanl7YLOhhjjldcajbhGagQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOvKJ3cNgnA6sea2LtZDmgUPz9slTEmWATWj/juWgng=;
 b=fLHZ/tmr+O2h4D5+9Lw1pQOhNRBTseaBIRQ/10ZmjTp2lvoo0W5ev+pjxDWVcsG6FbLO5U4zxwLTJ222nvSR+OqaxdlWyJVS/WogmLoP4x+yLKQ6mSIx2WBFEOEBZxoUrdZLtZ39uT5m1Wkx91VUD1dd0toAOBSaSU9XnlAQ1e8IDbBnPerc2slHWhzjhMXtDbsRtefmu3lbXgnTXRGqacEZWv50Gk3YrAOUpRjtqnw3343zAIK6sxDPODSDA2JGRcC+CRghgauRNkq2IzSWng0KOkwygV5M4tFuAd/muAiZ5lLn+vMv9ZAeRgAli3CqpeUHDPK+8H3GQ5BtAZpG4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOvKJ3cNgnA6sea2LtZDmgUPz9slTEmWATWj/juWgng=;
 b=ol/xGltrNwmnQjTftrpMNB8VGbIMENqpDudePQkHUG7AN49+qqSrhAtQFSGWu0Vtwblc9Ow74iyUWOR7fp2iOw1hiFUblBu/UbEcNJBJWjsnDmCuBzqz5qd47GKoibM7Tn6RNSYDc3OS2di2DwnWEzJKaO1xBnKnSVGqyfjCE6M=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB10457.jpnprd01.prod.outlook.com (2603:1096:400:2f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:18:34 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:18:39 +0000
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
Subject: RE: [PATCH 5.10 00/99] 5.10.176-rc1 review
Thread-Topic: [PATCH 5.10 00/99] 5.10.176-rc1 review
Thread-Index: AQHZWzyK83Cg971TrUqJDm1YjvCVza8D6K9g
Date:   Mon, 20 Mar 2023 17:18:38 +0000
Message-ID: <TYCPR01MB10588B82217102F99CABCB7C9B7809@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230320145443.333824603@linuxfoundation.org>
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB10457:EE_
x-ms-office365-filtering-correlation-id: abeddd5b-e1b3-405e-70da-08db29672578
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rxt6HiIOOMIurtrkbrihsMnwBlL0JSo2N/Ku2Y5MkKkBcwy//KFS60U67fLd9ykTgjOrWLem06DBj7fri/AkpEXOP3eP+H9lrWrCcykkUHxxsuAQF4fARFMQct+wRgE2qcQiI6PT2hzFhJIozmJfMIu429HVfYDDlGCCxZz7eSQhQ3bMR0tF6h4Vn2aeIZpKA7/8WOrOKTZ3VRRHoVxe5tcQenmw1q4B9S+Fv6fELWjeA/ZtOkJP8TwaKZl2+S7OBcY4ctE7N+iLQ1wLjtc3T3DrgltuvpHhgMK/mMrvrkbPTauXZGFSUYQV+bpoh7i7aO9hKrTUmaP5Uwp53MGgCqTqZW+JXYyLpUzQY3vd/+z69y5Sn8Qyl+4WnBa3fYYXeJyJ2+Q2/NogfDXVmmEf3UE93x+WVo6rkqvSrtv+9+epv9OHJQCwHke1yJWp49wHU66BVMg27pOThR59xCAdIFa/Qo2N2O5xlI42BDq6rfHZhQCTMnyHgqc6Lb6NURm9u4yGKi0nLX8fex+qtgidLXxsDpyamfJ17qYT70OYh6Y3d9+mbo0jb2D//jlUIBZhz84H5sC+wrBupUpJkYnMeSakZDzlEPVB9zJMSD+NoJpY0K7SqNSsrQXg5w/ilOT+blS389olQRdh09x9kTLlLuIflAS1K6CcDek6wEoO2XJJ4vxpXeEiztSKS41j+3BkHa1RWECHiB33TxvZKXjN4I8wLbTMd71Jh0qmJbDGYBs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199018)(966005)(7696005)(478600001)(71200400001)(316002)(8676002)(66946007)(66556008)(66476007)(66446008)(76116006)(186003)(9686003)(26005)(6506007)(54906003)(64756008)(110136005)(4326008)(7416002)(52536014)(4744005)(41300700001)(5660300002)(8936002)(122000001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?wsTPZuvW7/yyZxIkJnnt8JOxUmP/JMmbdPPDSBZ0PwAlknieysUcm6jk?=
 =?Windows-1252?Q?M2sSmNJ8ExE1F5Pg7dm9K+4XM7s4tpS1qt6jMlDtEY3kEIxRRXFxmulh?=
 =?Windows-1252?Q?Ha2iC7PocR45pYQIurYVPW8HEfrKKuW4s2g2g86M2M8BgqsGG420/6yc?=
 =?Windows-1252?Q?IXfnauxhVtkEAmB+OFLaDZGg1rzf8O3FQF6KI5+Z4WZKR0DOMwYfnseQ?=
 =?Windows-1252?Q?2ma85IYaRySXcxHAFH3iZbS1itK3m4VCl/V+SReUM10agvy9Cw/rcTT6?=
 =?Windows-1252?Q?IL+zX1jpQukUllLD2Z66lLQiZYRfVPRqFXmNlpwu596ZotS6cSKCuAqv?=
 =?Windows-1252?Q?pRUT4WBfB2Lun82ezPt+jPKWJ5rtYgpS7VITI5D8bTL5uZ6vPUinwuXd?=
 =?Windows-1252?Q?KHFyucLsxdDuBgbqV4VyLNuTrNtyb7wG6U+AAkjtQJoa8VtjDTGjcEvi?=
 =?Windows-1252?Q?ArN0F8KUNdMA7hsvMlw1hiTIIyXgqEhvuwcaHxM+za6RO2Bu49Tdb1cK?=
 =?Windows-1252?Q?8jMosdcWZvsFxup4BkA8z0xDqGqE5f/PtXYQV76ZEchpl1MVKnzc7tvT?=
 =?Windows-1252?Q?a5bUYl4PO/pGI/lCroz68DoTS5K4eKHmk5cvNrq8b2hW8trUL5/KtWgp?=
 =?Windows-1252?Q?+ZMEN2ep+b6J4ikEYJjD4XoBcsdEakVL2T+3Bew3pqiLjCbQOsBFr2Oj?=
 =?Windows-1252?Q?r3wXhldMSs9KIXMlakacM3n+xqyFODmD75CcA34T1WnKSWilTNg97hj4?=
 =?Windows-1252?Q?tKAraeWqf6t5XmxctuIyavUJKB/Gv+UxuDMW6nyOyXh0rI152d5SfdT5?=
 =?Windows-1252?Q?pNyDvKBpnH2tJRdoDA+TM5Tzh1OQQvb4xVMDBXSHICxMpxo1nX4Q5Q+r?=
 =?Windows-1252?Q?WuyfUKNVqfRhuyRN++DrrL8hyCUgAA4oGqj26Jo41Ta0eRxUT+vCOflc?=
 =?Windows-1252?Q?KBX85FguYOg+rGKd7AOddpkF8BzsR4wCiYq4TAeUiaBAYrYS+vxavOde?=
 =?Windows-1252?Q?IcIiZszgHjqNWW2HK7uBDOQbsj0MS653tJAtbEy5oJDDfKTT/n9qQBy/?=
 =?Windows-1252?Q?7SJTQZ2nru6G5g+GolPmS3LzLGcBGEvnTvi8gKsk5ljijbdC/R8iorCe?=
 =?Windows-1252?Q?KkU2BDRdWxB2tohXOiSQ0doUN5Q2zKmQdxQnjEqHv+XGyhiAECLRfGlF?=
 =?Windows-1252?Q?JZ0Mxcg3dMxgBdy0OD/FbhFjPk1e6vbtUFeaoHuRaILfXph+jMq2Vv/x?=
 =?Windows-1252?Q?fdB5ER0KN033ZiCzMNqn2xxQEYYkP9DrdZVXC3PkdSEe2zfyY7figYpm?=
 =?Windows-1252?Q?kdE05Fh/0aqDayxyqtUVsImaZkIE3wK+HcZWVqjZ/KhhBKklMaXiJMfO?=
 =?Windows-1252?Q?sw1n5AuirfZ0iwEQCA4iqb5CQrCb5kUffY/hW5QUvjPB8Q8ygPDQdH56?=
 =?Windows-1252?Q?vdyL0EYXzuJBrewzX+OaPcqXzqxoiT4ntrIM5/jWvfQ8MkC7Nd89HUY2?=
 =?Windows-1252?Q?0K/48sY0PwtMp4AejcM9zfNFZD6uA/fpA3B5tAYrunSgszVPATNP5fM7?=
 =?Windows-1252?Q?SXlw6stDNoYpWafrwuij1DSO1l5NDNgsl610Q3dY4Jl1Ts95yZeonCM1?=
 =?Windows-1252?Q?jbOcVujzv57bMw8SPaCKGqT5RMupPxFYOz1sKqkzvY1XnIseGtjJ3Sob?=
 =?Windows-1252?Q?hEmxt3EY9iB2B+WJ+p+H/dDMsBMMwAyOonfkbww7vDz5qdLQqjxdDg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abeddd5b-e1b3-405e-70da-08db29672578
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 17:18:38.9920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xjG4hFimTD63WUMiExxTCVjKZ6Z3frE7VjJRL+/sSw7xLy2l96snL4/89jqp/JvV3pKSC33ICYPQpQUrKueRJPtmnpMzxXosS11iByXjHYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10457
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 20 March 2023 14:54
>=20
> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.10.176-rc1 (1686e1df6521):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
12172029
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.10.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
