Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747F06E6D8F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 22:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjDRUi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 16:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjDRUi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 16:38:58 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2133.outbound.protection.outlook.com [40.107.113.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21158CC17;
        Tue, 18 Apr 2023 13:38:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2IJQzDiF4DLo2q54amAAT8RO+Qgmv5pMryJJbVDfaTHJzhzwz6yxLedrouQnmd62IvHwxSWyMmRzNba9Cn+IhmpzZs7HcvUD6GaftX2fgwepKOOipdAA0xYeNvmvrjo0Tph6DsRvvusin6ZY67cvhf1JFuiLcKA4UZ/wFepJYH69fxFjh9btV4DXbIkjEuGlNCaQft/1lqJgQkF5/7aJWJX91+74Zgx90xgxqy9lTm4OxeWsLEbigDpji01CiSzEI9YUewOBLLPlnFPcRKe4Nq6eiq7h6yTCYLlfYOyiv72W5YW39mkFvRhareGnhg+P5DqtJPA4vcr3HHAArwpMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvqrpv8F2OgkUQfMmTaEL9yKVG12RbFVEJVn9uoTzks=;
 b=ZA8fXwid5nwzCia9DFS90jmBSXkcFYstHEJ6fdoNVtBTpe1MlJxXMb5HvupMipEwgfOQ8KBTi4ZlGVUCccFafUVPEmgP5sVNzbBvRAdC7/9RdItgZruPTxvumIzHbxQPpbRAHmXgxSTIiOrv9/b+7z/QTCF3ylseKbziqSzJTue9P1jJAfBkrvqE8VsdCgJOW32shhrskka/rTEvxmxz1jtIYtrpYGNWuUG+Iics2fdJQwFkCO40SW4NdUKjTTrb+rcFOTlqSXldku5W7U+qRDj0iqqbt1lSd/oRIeRVnuhtXvS2YOE1mlctPB8VW2h1a6zD5McE/x9WE5Ff8r/FjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvqrpv8F2OgkUQfMmTaEL9yKVG12RbFVEJVn9uoTzks=;
 b=YOZHTFRuWleExLQxGmIVdnTOtrMNPO6nKgMaiXm6qzlwja8m8ftjh5kp8h2+7+BoVR3Bgz9E+RmMG354xgtu6/V99oxOLkZ7jtdZUKTt+V8zwnVTfAva4cKD1hYvjyE++Tobqxt1zohN25il/I+Z1tKFl9bxKKTWLxIxiD4BuU0=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYCPR01MB6047.jpnprd01.prod.outlook.com (2603:1096:400:60::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 20:38:40 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:38:40 +0000
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
Subject: RE: [PATCH 6.1 000/134] 6.1.25-rc1 review
Thread-Topic: [PATCH 6.1 000/134] 6.1.25-rc1 review
Thread-Index: AQHZcfNDln8IQLN7gECECIMAOT4v968xh0+g
Date:   Tue, 18 Apr 2023 20:38:40 +0000
Message-ID: <TY2PR01MB3788FB2AC6A31F3F70336107B79D9@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230418120313.001025904@linuxfoundation.org>
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYCPR01MB6047:EE_
x-ms-office365-filtering-correlation-id: 59b4e1b5-e8e3-452a-3f18-08db404ce4ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bm1MRRxLwVbJT2P18Ms4sHQZ6qzvK1AGC0v8u1aBFIvcHNoe5T0/jeyILSQfDvaj10Z3Yi/EMfqOxcIvu2znUXu+LgrSOyrpJ3lGEacNN57JbUfr1K6t7D9W76gK1tvDs1VfwaJ/9yBjDkDafQEXyLU1uiQex38x+fZQ76bcM9a/ySZAATVqFumcJ7dDVfQ1xEInU2PXObMg47aZ94OgNz/VtEg10zcMEM5DM/QOlebEApTQM8ycrIy3WgEJXHmWFpFjdKLwG5lIZrO3mET7V8waU7gSHvYKAzpqlWEncsh0SDI4NlgwzXyGwbqf2tKHFPNc1AO9QcCMrP5rTgbw4kb8BT9vAeOLT1xjdfQB9/xGK3DujAAU1TkR9F1mPXs6o30LyJGUUdpm3ibd12XcmwsPwcQv3oZ5MiwBMnMDDkm/wgQ3GndyKvM4mOTQKx6HENfObDabPWYqzDnl5/RFSMHXrf6fAwRxlL4uiI3zE3s6PM8o64wl/wJ/ne2bH0v3gQl5OmUkrmN8OaMvBNF5a7gIvuE8YaMw9PWwe/aROmpQueGhSzT0dCTjzeYp5gFQiSFwtMonr+Ji7FQFJE+jbpn5MN4+kZLVgTO2e7RDmIicu4Jcf9omKKaWV4KrwGLa3SlvB17KodVEakUDXkXIVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199021)(66446008)(66556008)(64756008)(4326008)(66946007)(2906002)(4744005)(66476007)(86362001)(7416002)(5660300002)(52536014)(8936002)(41300700001)(76116006)(55016003)(54906003)(478600001)(33656002)(110136005)(316002)(71200400001)(7696005)(6506007)(26005)(122000001)(9686003)(186003)(966005)(8676002)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?g8qZFeD1CTHuf8mbZlqLl1RfC3Sd/VfSx54MwXAxVjd3UrbuDhO01mBJmu?=
 =?iso-8859-2?Q?Lql5FNpXjBQT58u2a4D8FGKAnfMUu8EOefQ68MjUVlKWbrjpF6XY3EUJs3?=
 =?iso-8859-2?Q?INPtQunODZRcRk+eKI4Gvoul2vbVVGxr3xwg3GWlZTZPftYaNBrZ7K+jbR?=
 =?iso-8859-2?Q?mlEvO0oSs0qnwnhDxY6GXQs0FMWQ9E4L5yr2nSDsU79Mjn2NBuLoFXm6ib?=
 =?iso-8859-2?Q?+emHIajIBavKE9LLrfa9m7J3tZ7QXZbZ4FuIYLZ/ock+8CUmaZ1FG8xkQe?=
 =?iso-8859-2?Q?Gmr90leICa970nIDhHHk5G0NXAvSAMRmaEf0sF4xeweAh+BBbgsdM3000p?=
 =?iso-8859-2?Q?ITIBXJ1yxbUZeJGvOiNRXR+fZcpBkdOjkWEH/YU1Y6HM9it/tCIF2F8Qje?=
 =?iso-8859-2?Q?B9kvms5Bd+/KpIAZ+TfKPJmNTjIMCl4CHbjlpibOgN13Grg+D1Ae4xmyQC?=
 =?iso-8859-2?Q?OZ6F55wZd51A24NsqIuSB3COkF+tOKo0IGAtHtaVLI3FDKMNG4VWsPXtoI?=
 =?iso-8859-2?Q?PwMVINR1qvzX7jHg/iZhjI4xUhu69itoW7b3EhBFcMo+E/iclBZ4RyDiE5?=
 =?iso-8859-2?Q?TX7vRM45+JxOCNTl6hcc5fTWBoEHV7V83eo9qWVpUOnH7H6MdRIAR/jiR2?=
 =?iso-8859-2?Q?ra9B1AKUgjOHR5DRDoxynmOSRrlvwtnkB6YAmg6uNN6P2nxy55/K+g2769?=
 =?iso-8859-2?Q?fr2pWJQy9fE8nfatSpmA5KGQIxf/lVr5MVWOYCxX3A3C8w3WVyR9ypKvOt?=
 =?iso-8859-2?Q?GYNjqDyv3RVYhdIUuFmfd6foAGWNsJGfDJC7+W3liY6hK5poqIQP1LwiLc?=
 =?iso-8859-2?Q?faAcHYfBkvAFyGcbj+VeMmz0kbtgk6suvSsQDNIq6g10FQ7i6qb5KANic7?=
 =?iso-8859-2?Q?GD1XgksiA7tG6M5Tg5FgasEqv5jQcydUV+tEFViPLVhX4BseynRbRGNcdk?=
 =?iso-8859-2?Q?ZQdPafcZQ/tyMI+oIyR5cRuv2ZDniYyC8V0WrB2NgvLPyaRuLlTOt64iH5?=
 =?iso-8859-2?Q?jusF1yKAuwHDGL4SxOV/4K5GaOqpnwys7/BQqbKfei+dVdRCUFT0MdBd61?=
 =?iso-8859-2?Q?V1KLceQwHGTKpi2iSFd6ygUFcdSiPf//OLkqqmA0puhYvtONpVzrVpPFrG?=
 =?iso-8859-2?Q?e6/ybyiMG87rrNILxi6DGiUnXfUN2I8QOVHgnPn9HPgIzpo4wCIMiChV10?=
 =?iso-8859-2?Q?wf8F6pcnZMDFPp71zQ6yyWIyshoTmUdyPYrgHRQ07uDpmdUYDgOncxI+6s?=
 =?iso-8859-2?Q?sUgjL/bc8+PwfNYJPeDkiQlckZVbkV968haGy+Ak1ZD0QxClk4+V/ovHIQ?=
 =?iso-8859-2?Q?vr9U2i26Xlgf4z96BHzc6ly1+WHOjLH9NBbrFahBKvRYXJK/F7MK33+slF?=
 =?iso-8859-2?Q?+nVN6ZShDN061/lxCA27EKyRd5sCw708aIQAWlfYNoBwp4AVfzv/CIAtWt?=
 =?iso-8859-2?Q?8LbBVm+8xagIAFkosXog8moq+L69hQIdPDArR0JO33m79lheJAbOLU+gil?=
 =?iso-8859-2?Q?6C/lmBDXH4P2Vi0liaepIR+oolIyWJWSL3gREEvDniQcysm9FbyKNHNmcC?=
 =?iso-8859-2?Q?ZRPz6e6zY8UyUBH8MhJCCahco2nuVVwfAK4szW72gX6x/bI3AScjJ9W/I4?=
 =?iso-8859-2?Q?hcugxg2AZoz7tRCR6nK8YrcdS4ORMirj9KQ3XSgc6kemwqMOFVv705cw?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b4e1b5-e8e3-452a-3f18-08db404ce4ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:38:40.5493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KYBAvG4l5bK6/+/tfD7hm3GanrC0twN5h2dyLbZLeawNxPzP6e1RI3Nd6Rn0bdJU02eWi8/xSnPgQ6SHLmNohYDOx/bw8y58uEu5uMK0RZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6047
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
> Sent: Tuesday, April 18, 2023 1:21 PM
>=20
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 6.1.25-rc1 (90c08f549ee7):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
40945625
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-6.1.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
