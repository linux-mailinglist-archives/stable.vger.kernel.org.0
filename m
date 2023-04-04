Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45CF6D5E09
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbjDDKuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbjDDKu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:50:27 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2120.outbound.protection.outlook.com [40.107.113.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFE140C3;
        Tue,  4 Apr 2023 03:50:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkqFQz+GBpDCwE4/JPHYuS/h0Jrw81D9SayhpgzH8FPKf4FUyzGQI/5RTuNl+JKkRIE3/y9xd7BfA0efst9cfL3u+S+Mx7qqMC7ufv78+zyVaZb3vUNjVjPH0ubMVhBuwVgYrUcY0fEqgANlmNhtZa5IPyu63VbgKyzNXB/yxms7z3GPKnFkR6mF3Z9MNT6z6XCDi4vWd3iq2pmTx96P6OfjhZk1Wi8nVKBKxDWqStlqJnfuk0uk5APLp0eNcoN82Rv3c/52a57Cdfiyw3PL60StLI838wLdVtwuGIc1neCvxVMFZY7KtMY7ngsYaEA27TFt8PZruaFYJCjnotyfYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RW58veIIZs+kdnbNVdqHjuuimEL6gotP1THlErEVaC8=;
 b=Rlaf0AbdKs2aomaijmUod3NUVc9LxLQGzCpPFJ0k1rB+0aZ7gcKXqyneyscSI6hHZgcPqcDF+kz2uTZxOlFaOsZLj1d8x45zntBouhrMpThI/XwKcSsAvLdd75c2lttVGprrCK2alaMNOkdJxnKlQdqreR3bWTHEIkLsMODsa+BI3UjIpBHQFCT13L60TxsU/+QUczgFvs2GR2EepF5SLlDZzD7Pagvt5OdBGDI02dPLNJTu8xLKwCiV2i13hxg3902duhKsZKwHR/9IJA7SBQ85JBy07bQbHUU0W8esq07aHJYxQZHFZRf+Jy8svm/4UU3TZ5bx3adn3AIznCR85w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RW58veIIZs+kdnbNVdqHjuuimEL6gotP1THlErEVaC8=;
 b=gs0b7EQIQmXGbWv0B+4576/TO/ITpz+TOQVAcAHjx3nASp3orzLqO5zDaYb5PZSUmONIDEUI9VYMJ3YG9OLL2CPq6z1GEMa6pl/Nghu7Dh8Lsc9kcmM/Qy4sTPnolTQPaLaZppJh+vrzonNaXZCg8ahk+UWT2R5+truiT6CyQPE=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by OS0PR01MB5780.jpnprd01.prod.outlook.com (2603:1096:604:b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 10:49:39 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:49:39 +0000
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
Subject: RE: [PATCH 4.19 00/84] 4.19.280-rc1 review
Thread-Topic: [PATCH 4.19 00/84] 4.19.280-rc1 review
Thread-Index: AQHZZjbfhqtO5kuD8EqHnkNHCPcRI68a+YjQ
Date:   Tue, 4 Apr 2023 10:49:39 +0000
Message-ID: <TY2PR01MB3788BEA8A62EA93FF44DF052B7939@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230403140353.406927418@linuxfoundation.org>
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|OS0PR01MB5780:EE_
x-ms-office365-filtering-correlation-id: dc47d857-afe4-47c0-6d87-08db34fa4a07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dl5Z5dPz/7iyFWLsY8rSXQKT0X+/YijrcqeWtEPl7BE9M2rh/s2vO7ui2oX9K23GRnd7fcx3Upc2Z8a1nPm1OiInqXR8lsuQoUJLfWv3vfJeP9Bhrn2Fcm0wYMc9ve29UTbdfSfHpTRAoAEtuwJ7UPUg3ZGTQMi3NvQuEYAjzS8kbdlHfXraKbIk1dUpNMh8mecg33FApVezBMgraIv8EAca5EUFMYpgqvGOoK8+sfsrplbpjQjfAJpGm0s9PL+cOGR6bEzts0zv3wA9Thtv0tDaIFjR53LArEHn66kGgIuMvYIpzYXFMCWPaCbIuBstoY/4YOwqoQGtmnJriRnqYtVGHPSbhCn8oG1jHIQ8eP+28tsSIUS6FnBqLRppigDbwXSv6GRVRDFzPmegdg/XLymPTPaWNNxvT+ZoHzV3CbpiPJ/DWQBpp4Vmdsc7c4vNmHEKSZxG1ipZM/F3Rxy0esizqXIXGIlf7xQArnNO7ImdK2CuC1hrM3dC/Gx9T/bUou7S24tgzVgF009sdIi+YeIVEJD1mDZIP0ke70niKqJNI7Z1uPvoJs1RibSy1Zy1WhS89Dnan1Us1lF/Bgbv+9WkUniDrcwCMN5kIg21eeoKW+XvZTpgXw8vfdVZAic7Eyer36vnmIvLqsNcmXcKzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199021)(86362001)(38100700002)(38070700005)(55016003)(33656002)(966005)(26005)(9686003)(6506007)(52536014)(7416002)(186003)(4326008)(8676002)(5660300002)(64756008)(4744005)(66476007)(66556008)(66946007)(76116006)(66446008)(71200400001)(41300700001)(8936002)(7696005)(2906002)(478600001)(54906003)(316002)(110136005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?jYnrbX61VncHzCMk8Hu1KzNJ7AEDc25TEtRUkJWFPoi8G0/fWpGIIfcP22?=
 =?iso-8859-2?Q?+HVzYqFQonBWABRq6usNKb57s4pbfWv2Dobwh3STkj/+raJ95mNl3rEQCH?=
 =?iso-8859-2?Q?ikEOteMNdhKz4sOyN/xQcpkfk+iYtZ73L8Q1qrkHAUAL4+NKB3qX1Byl8A?=
 =?iso-8859-2?Q?1+jsV/RAJWZF9YlOAxNBxZDkqFILHw/PVOPsonls5HkWZyHfruEP8o4ylU?=
 =?iso-8859-2?Q?p5tD/DiW1+vgpoGL7c9tmGJT+peWGNScbYJrh6MiKpRnGiU+JYSJhpFwwv?=
 =?iso-8859-2?Q?YpFYSetmmyY4ilXGK1ESPE1KyYUTW6I8aq5RRH/RzbZc9yFaxud69kQi6B?=
 =?iso-8859-2?Q?+acUiWTxT23s41NgSCMx6ZMx/MdUT7BLsvvuK0WBr4BsFkyF0GhyJfoLuH?=
 =?iso-8859-2?Q?CGvH0tFlYjfLAZcEfihHY6CL9+JsjgWabR+kxQSdHUVVGzisyjbMHl8Slb?=
 =?iso-8859-2?Q?wzksDAlR30CLw6lyD7+FQa6YmPXlHdu1BR+kF9I059JKMscex2NrLWLqOL?=
 =?iso-8859-2?Q?dZae9YRie0diLYUqsGwVZFywlvGFCfYZ+7OIoToDmCSXg5w7eNoND9iO1G?=
 =?iso-8859-2?Q?hnwMAz5tbwy5Wjz7rsUvbTPYI7RNIjJBn5Rh0IRR7PH9reH0TCW+QzjunG?=
 =?iso-8859-2?Q?3syrxdQRIxOL/R6UZ2qEHJjtXRp2AhGK+iJ9f3mhH3udz8CHYleCacObrl?=
 =?iso-8859-2?Q?ImD6Q7jzg9+F38TRHVopyv5t4qd/o8UXOiK4cvLHxqNAIRF7Cur2/euqv7?=
 =?iso-8859-2?Q?Y0fkTN8H1DCOuv6lUlyqJeb3rNKJxt9CheIgvYh4Fy0attYMecxr9xSXuH?=
 =?iso-8859-2?Q?00ru/25Cp6L1EhfSiq4QlY+IY3vJU2QxgNFAY2IWTO4Yot6j+BQ0U1MJJH?=
 =?iso-8859-2?Q?EpOpRqQE0Wfqyc7puikcRGxqHEVMeo4EOw2roGqaIePlgSLqJy696WjC0Q?=
 =?iso-8859-2?Q?s5tcVVhR/usRTVLpL0qTnulztoBvCRvH8eGUjsy7JffzMeCX44GysDTWwa?=
 =?iso-8859-2?Q?N+7/qv9h97bh+wsAWGeP+wo17huusPQTQe/06cFFPq2IuqCXidTxbdJ3wy?=
 =?iso-8859-2?Q?dEU1GaccTy/tD6JoM2Ijk7iQmprwt3yMziNhhv4JcpSHvwVwX5iW/FrEEI?=
 =?iso-8859-2?Q?bimhGNvcaJp6iqciX1RllTQf9jdHkIQAMecY6vPWmwU+FRWXDEmBJZuHhC?=
 =?iso-8859-2?Q?BLHjRiZb/ngBt2RyzLC3K53VXCXfDsRDCRWasG9t1o6rCTnbzpMW8PwuIC?=
 =?iso-8859-2?Q?U7cGcHm22IOwZka4WXpMZt5p/s0OFxFNVwdWKHvjKKwHKr8N10CQ2ZwRxe?=
 =?iso-8859-2?Q?GsRFc8Vyh/7hT9vI5VzJ5z5UNhAb9xwnhUkp1I4CvJNLmZuUUA8Gadn5kD?=
 =?iso-8859-2?Q?JL9SqV2sPXuhtnCNEATc3U9M2io4PzDmkOR4/tl4CM0E9E9hrxKjwKJDf+?=
 =?iso-8859-2?Q?JD5k+futjcE9LT9YFSzJ3TRfNgqdEft7NI4GvZgRkbqxsZy1plthj5P0VS?=
 =?iso-8859-2?Q?5UgjFRmGowtZ+w4p1/EiPXhbzFpehRiENk/48iEVCPhcA1nFoa3Fg9ts3O?=
 =?iso-8859-2?Q?RpXJugkfQVfiL+RAATTHY9Kn/938QBYzuNtKg4llM5bQdGX8GM5HI3cVFt?=
 =?iso-8859-2?Q?OS1BIJ87k6CkYWtbnGwa1+TlJqWPFwkVgHlORPTPXrIvsNcnbFv1vkRQ?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc47d857-afe4-47c0-6d87-08db34fa4a07
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 10:49:39.1400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nq03TQ0/kRztCavJ2wo+Y798BB3g/Xw+me7tgmdWZIN5HKeuDCoJ8HWrD8tCEt6ks+oD13drsIvPbNJAOvIfBMmYeTaLEdc7Q8DjCiBIzEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5780
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, April 3, 2023 3:08 PM
>=20
> This is the start of the stable review cycle for the 4.19.280 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.19.280-rc1 (e4a87ad39c98):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
26399478
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.19.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
=20

