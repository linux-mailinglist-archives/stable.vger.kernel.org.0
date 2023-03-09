Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B846B1FE3
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 10:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCIJXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 04:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCIJXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 04:23:01 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2137.outbound.protection.outlook.com [40.107.113.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F9B1042F;
        Thu,  9 Mar 2023 01:23:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVjT7v/7MZ14fxCMj9LKEv3G+PI7PKRLwt15bzvkGA8dPusVT+pGvO2E6mpE+7C9+vjGdv92KuCRkwAs9VEbIOCKIdCFum19JRPTG0ssHzLeoerD/xZOCa9p3W4TG2EOmUYKC0bvlR8tU93e8Y7P3fUDnQkmORmqCcjLg+OkOpsmy3H+4UdtslbFDQ/ognfPsNBtNDERxJvQz3QrUClO/UC7a9CtzOG8Hg+hpKalkzrKSqPyR4jLyC3GHYHZV2soD2t24tAEYns9I7uZSqBgglT8UHXQSVzZGDpWNMGuFao8Hd5t8ZVnKY7xhWk/HeLrkTpnvbcB+/j6wnj6QrrDpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mxwFGMzUiTjEZcw5r7mPJ5m4M0P4nuEnaXEp6h44hv4=;
 b=ZuQBI5gUHViQKjSe6tRM8e2PrvIIWplcFIV4iAi1AsxidpTh98jrRO7qMg+e2uwa116iH74AhAwtuCwQ7UaNdb1+bSBmLb7haJQveg2bLwpiMpGXPnscW2dUfJjXh+abgWVgVpHxWqPwT1B3FJMaIKlYPfdC9v/v1ihC4SsjCch7AR35EiBX5O1hzPN9QAfqXjXswJvSoQ09obBtQDdYfGhkFSZjq44ryhCTmHVnegdbW6sRKnKwX8X2hdApvw2iTlCydbd88UouSGC0p8DQHRm5qXFkMXCGZfcozjKqHcLe6P9/Lgo52wAN7hDINUrGTOEefX37C5UWbWnIpSTlfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxwFGMzUiTjEZcw5r7mPJ5m4M0P4nuEnaXEp6h44hv4=;
 b=gGt47CiCjSFUNbpARzZJuShERvpi/cdT9WXurf5Wvh2L7Q9PdhFRvU/Up/0GD4VVXaZZTrtGCm058hec/aR4G8rGRbBj4nmOZ0frEmK8WKyQqWMoaMQynVgO8rihV8O7EuzX1ZdO9ON6aLnu+XizOO2lvwzZN1OvBi1Izs0ErEo=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYCPR01MB10924.jpnprd01.prod.outlook.com (2603:1096:400:3ab::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 09:22:57 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 09:22:57 +0000
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
Subject: RE: [PATCH 6.1 000/887] 6.1.16-rc2 review
Thread-Topic: [PATCH 6.1 000/887] 6.1.16-rc2 review
Thread-Index: AQHZUaClVZXqoKAMQ0a1aIet0CU8O67yLIbA
Date:   Thu, 9 Mar 2023 09:22:57 +0000
Message-ID: <TYCPR01MB105885F25AAE8A2FDBD2E577FB7B59@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230308091853.132772149@linuxfoundation.org>
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYCPR01MB10924:EE_
x-ms-office365-filtering-correlation-id: 1ecbb71c-fbb1-421e-90aa-08db207fdec2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tU8Uz5OFVIxGCejqKiQeVAtg0/71qJiPI+SJw8la/9jPoGahZIgYz36LfU1GI8W2H4WzBu65aHbRbXluAtp+ONCHGYsrNrodYiDoTQ6ZjtdF779zVKEmXl8GeBqSWzx5YAtlVysZPMTVYlbZ0imnwq0Ek/hhr/pHMuBNgPFv1HLz5u4K3jsxsM6MK6gwggmKGOKGt6MZH9V13ISqzV6XcOP9ajo35pxbnM7nW9TggFIeQMhsNmqJq+wHTNo3Un9Zf0Zvrc0Nue5x7Oz1AMeE1gKVoRyx95C5Ly5jD1LuFg1jNuU415F4zTwvckteaY6in7zB0MuHZUcsfMSa4RugoljvZNi3e1saeL3OuIrEnTCCb9UVsUV9cQMHKo77f8Kp52RrY9A7GpWkbYBSCuI/treV8ImMz/uSwfH7ceqGJyZKVyCZN7OXTr/tXRRNYBo31A4yqcNVurr+SEkyK0hqNVhHKkkAot4V5wh9Y86z3zjW1R4w4ccM2ygENSXxgyNyouXZp6XsmvPaeAUkTRfYi+jxvKg1fRblwVNifSxq6B9RxZ+9AIPE7lXJbgRNdbTPguk62JppKPHPsd/wq/RDiQnn1SgYSzo6hPqEybZVUulzgNgx1LU8QF1+GHJrmadNnG7t7NHJD985qaWqWrDoBnR9EkEyb7NZx6aLd6ke6w8UqlUZy7Iu7iUI5bM1EpIyWs2Ay/AJU/DjgZaFYhszVX/uMcdSzLZWI22ndXdyFTA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199018)(4744005)(8936002)(52536014)(26005)(7416002)(5660300002)(8676002)(6506007)(9686003)(38100700002)(122000001)(186003)(55016003)(54906003)(86362001)(316002)(41300700001)(4326008)(110136005)(66556008)(66446008)(66476007)(33656002)(76116006)(64756008)(966005)(7696005)(71200400001)(478600001)(38070700005)(66946007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1257?Q?ArW5ylwSTzxiI2YeMyBoEjKAwib/fF5J1bHZjsu5e03WLBSx5wrD5k1E?=
 =?windows-1257?Q?3PTBj+PtCyh6N5LhmYEAJ8Xg/zoz97XOzFdHYbpF0DkhifjS1QDlPO22?=
 =?windows-1257?Q?LBKv+DO/FPBfNczvBfJpB9Lkz5XhImNwxCqFw8R/gW1u2NtMO6dR4pLC?=
 =?windows-1257?Q?lUhcHZxni364WKzSNXo2cWfTqmvR+H0KmA54P4zdwdYmQLb/AgpSZOkR?=
 =?windows-1257?Q?cbbQPcR0bLd6w3Th+iVeKTVMQx8A2i7JSatFfSWDAsebpAsimGCRDyXF?=
 =?windows-1257?Q?JPJBAZUG08QXzt+ER8HeX2ujVfjxZnhTf5Xvo4k4oVduc6EeR2J1pnsW?=
 =?windows-1257?Q?E8gYuKTZOTnLWoiVVM2sSbawIcS2xOJVcTduvk8bydh5lkezE81wpHik?=
 =?windows-1257?Q?fGqhC+iqgPcO3AzOjJXo244xmXuhNNSAr5rw/rJndRKnyMQ5m/AwCgrp?=
 =?windows-1257?Q?+1VGA4J5AlCa1fmFPB2GqxxEyriVR2d6Qvo2V5StkpboilU6PGk0JmIW?=
 =?windows-1257?Q?adzeK4cM140v87MWSeoWBHxfzlZu06687bcYmfXZEb72IYcHPn2Cxjhv?=
 =?windows-1257?Q?Gl8aG78rVAz/CujFvhtyoTLJy4NuhEg13kEdHXD37xXsk0nkhIC88aE8?=
 =?windows-1257?Q?HbLwvLsO6gQz3+/S/EPr47PqVlZnqo9ZyRdM9ubG/7U9JO7sHq6vTtfX?=
 =?windows-1257?Q?ex6Sv8rOZCPKlLcdtDFACwz62WKAcZkZ48JOUT5nHwEVTnVuM0sXVMgF?=
 =?windows-1257?Q?CEAhbBymkLIzgJoTskTUe0kQ1rIGS07vqs5SWHxWPVF8gWn4PkTgynOL?=
 =?windows-1257?Q?YePmrADcgb7kqIal35EmPnobvIjCU2XQwGKnMAE4NVRDHfo/fLaeIItd?=
 =?windows-1257?Q?9VWtCYaz6XpxWA+hiUSpDor+wyuRFqFahLJIXJan5c5ZD+zL2H4a9gv5?=
 =?windows-1257?Q?9NZxmoxXMvCOXZyLS1a0OvDezwwOX5ow7Qxac32ej94vevdR1imuIixZ?=
 =?windows-1257?Q?5r4lrrATCFUG67koDEwqFceaPNKykLspYivkY1Ig5jVEXU00aSHXGaND?=
 =?windows-1257?Q?999oDwwLLY09mD8aGN+gthjMNyTiJs1Ti+6OTzJ0ezoiEH1yStjmEoMj?=
 =?windows-1257?Q?7pYfDOTLMvSXGh4JhzWNzQHJegQh9kCqQN0xsZr5dbPmj3oqB2A8oNg7?=
 =?windows-1257?Q?F8Qnmep6RlCsxdEeUXTYaFygwqbDf3Hc0tVZB650Pqp3t9Giqq2hOZvv?=
 =?windows-1257?Q?Gkgh0tnjmse0FqmcCIsxgK/jR8Bxio7ukLhe79PnqFPORXJvjXdTecPD?=
 =?windows-1257?Q?38CcdyU0ESfeB72VsTXA+yDRR/23pfQA1i231MusU5M1GxHMk/n2AOXa?=
 =?windows-1257?Q?ejGbg1cX5xr4n7DfuVuyK/uCfQ9b6ZpMcy+imNdrzpfI6rsd1Qep+brg?=
 =?windows-1257?Q?NsOCCsMMjaEfNrJNe1ah4d2zLIX5ALUQKa0wEYMl3SzRXAuUO4HgdmNE?=
 =?windows-1257?Q?fPwIXr5DEYD9420yW7I23RhBLuB3hdI7VZE/zdztoVYx+cjO1JNziSEk?=
 =?windows-1257?Q?4yeIyCCDt7BY/X/3QqMIEKHX5wfnmWBWMm52fpeAVAcB4fbCPfNOar0k?=
 =?windows-1257?Q?DK7r+V+I4zHQ9Bru1KpMQJKRQ9JYnOp88wYLbQxVw0mk/Y0ff4ATLXgq?=
 =?windows-1257?Q?tP1jATfNSIhI/YJY+BqLX+QiTJHlSUo17mKKjlp886K4cDpyqjfPCA?=
 =?windows-1257?Q?=3D=3D?=
Content-Type: text/plain; charset="windows-1257"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ecbb71c-fbb1-421e-90aa-08db207fdec2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 09:22:57.3129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8GKc9O5MyZ3Si1BKpfzzv0c/l0W8awr1A2SVKm9BW60QFpPVKwSr3qSCZAad/p3wlj0nAKcZlNcxaAg9R3tK13A7l7xXTOQAMP4fos+udrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10924
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
> Sent: 08 March 2023 09:30
>=20
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems with Linux 6.1.16-rc2 (bb4e875c8c41):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
00470660
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-6.1.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
