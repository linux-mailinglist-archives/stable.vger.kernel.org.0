Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A616D5E1A
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbjDDKwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbjDDKwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:52:41 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2133.outbound.protection.outlook.com [40.107.114.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A2826B2;
        Tue,  4 Apr 2023 03:52:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AiWZ4zvjW4HS0nn+Jng7xv2S+XkkZlAKP0FbL8hQ2Ou6V3vs1CsoEINuroqaBmlOm+iGV7q/qw6H9s4s1Fa2hqJjfeZX8s9+a5QYeRMgQGvDc+fys8Xrb/fLSm2vGfYoxu+k36/S2rLl5WsHZYyM4ekNCmf+xld9Daj0lxVabWx6GrAxaPSQOBqCMolnkoijxtZBoGOBL6LgbVKDbrHKO4LVi2Q/npzWfoFRN7d/q0MCTNPkhOCTL3io5YkzayE4FfRQLwj1oG9BP9KL28BvBw894bjZlekhpcYRCsvEoFR+oojSRybxo8iVY9VHQtX0erG0YJ9yOSCG7PmolhDQ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0QAI7Qb7OpNBPmu4o93pBC+sKNpWBxOlkL9B+gHAUos=;
 b=Ivg+Z3qtkx3wDIHuLq5i0S5HyODvBM36Z5irpjYllZkmtHUa6f6b2TF1s1bRK4X+hlRg+0pq7TkQ7nmw//qzGn36iR2MSOkLu1s+bc1Z7u+fFyTNx9lh8yxT11PwgSD4+M8M0i/VR+2JL4OziKB9rNqOKDF1FmWHWLq04LNWuBouUBv30DUUIV8b+p07NS5ektJTKHFtyNMromEfgmCujLmUlltVBnUninFsyvkUyH6BYPNm0sMoLHbMoS3rL59K2tkgJYvom0r5WmrI/13C+0IRHgyHAAliMT4y8Y/c4fFvOHuAjc4cq0GPNALtO+j1mCPOCbNhNrVF4zp/Vh063A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QAI7Qb7OpNBPmu4o93pBC+sKNpWBxOlkL9B+gHAUos=;
 b=Nqjp2/0gDcd+Yhvyk8UF532RpPOePz4eUH3iCqTSERbIkumG/SQC11+J3LCxAzbh+48FizknamuYO9xh6jfymmesrIeIGxnbDwo7UCmPd7L8sAhl3NsmP9rP5APayApnFiGzbFi+MZoC8P5inrT78knqounrPjHOzY91Z/LETeo=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYTPR01MB11064.jpnprd01.prod.outlook.com (2603:1096:400:3a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Tue, 4 Apr
 2023 10:52:23 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:52:23 +0000
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
Subject: RE: [PATCH 5.10 000/173] 5.10.177-rc1 review
Thread-Topic: [PATCH 5.10 000/173] 5.10.177-rc1 review
Thread-Index: AQHZZjfzqfPuphfPEUCX9dmNyso+mK8a+kzA
Date:   Tue, 4 Apr 2023 10:52:23 +0000
Message-ID: <TY2PR01MB3788E041E4406385C5C503D5B7939@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230403140414.174516815@linuxfoundation.org>
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYTPR01MB11064:EE_
x-ms-office365-filtering-correlation-id: 4c8b8759-b55c-4cef-f1ec-08db34faabd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pNKjFvpKLrS/24pwPa1ENBSZZNhCK0IegTJu2L5eFfFTYE0RUb2Pq8kpTtwhiN3dARGC/A+z8ZF3ots5W5AVfgo3hMwC6Xf2Cm9f/S12GORQKld7G8U7grRT0Xq8Ms3Inb1M1ziMAIBX6B3O8wUz/Dg5rNwVOiJaJuW0w95H4AYkRka7z+DsnBWBeXmX0kR71bTIB8QVdFPSRaXPnl8HxRrPmXhJNd5P0upHgCd2/3soKyoIpO+YwHiUe3iAoFCwtsMb+Wsw+6w6nCFCY6QqFhCEasUM0kGIJk4E+2JLs0RXELbSnPq2Mb6ed2LIkKn0JSrioffTJwu0ktuuQEPlDOzL0nB1WOhH/5oGscm3Qgmle2ZJ1E3ImSIWpVwL/oGT56v7/iKuqB6E9oKAEYPOl7jtoSa4KjQbv7h1V5mpT5siAMozUKU8vcFu4GnbI5MjULim8qUrZjayjtn/h32g1pJ3LMaYQycmR3oL7XkpIDaGV5acB8YTDIHJRYfRwIVUOIxZBntlHFqeBnEabecFuAqSB1CoIw0RClyVqdW9Wk8gj+IaVJlTvbK8j/RuW/xzIkS+nawUEvca8uXpuCsQAQ1kh/iVpwJTDMuoa0bKxNi/928EKuXQ2Gyd4IZwnagUKgU9USxkMkLVHJNKljEzSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199021)(26005)(6506007)(9686003)(86362001)(478600001)(55016003)(7696005)(33656002)(186003)(966005)(71200400001)(7416002)(38070700005)(38100700002)(64756008)(76116006)(8676002)(2906002)(66946007)(66446008)(66556008)(66476007)(5660300002)(4744005)(52536014)(8936002)(4326008)(110136005)(316002)(122000001)(41300700001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTRhVU5oNkY2SlE0TWl2VENXbVpGT2pqU1V3bDZYNUNXQUlOWXhwSjhZUWRh?=
 =?utf-8?B?cFVpZjY1RlUvVEE4Z3hMVzZxdlpzWldDMjJMUG83VDB2SVVjbFAwL3FpR04x?=
 =?utf-8?B?ZGkrUUN0UUJZL0lOU2pVb1dKbWlJbmlOQStsZktVM2NmZHRDV1FRRlozZHJp?=
 =?utf-8?B?a2hPQ04veFlYeWJLVDk5U1ZuM3ZNMkRhZWNvS1c5M0g3VUY3NTZnTlA1THNo?=
 =?utf-8?B?S2svSVpXN3BCYTJYVU5rWTJLWWpzTUlyKzY3cmZSTDlWNnNGbnMzdW1BUXVV?=
 =?utf-8?B?NGF3TVRYa2tUN3dOendxKzFCdFZTV3FHSk5BV1k3VDZBTC9DVVg1ZFNpNWIw?=
 =?utf-8?B?UFkyaFZBZVg5MXhtSk9TQ1pGdjZVaGhYeWNIVm5MZ3Bmd25WUWlZdHA2ZXZZ?=
 =?utf-8?B?Slh5bGIzU0h4eDdZNTJOTEVmMVZyWWhoWUVGcHVVZy9EaGRRckNwWFpNaGxJ?=
 =?utf-8?B?TTJ0RzlwYjBMKzVZc2FsTE00Q0JqbllHSFFMN3VxVzFsb1dLL3N5QmJDZFpw?=
 =?utf-8?B?YVNyMVNOQzYyV1FxbksxbTdCVHBnYUplTDNqL01XMElHUTl2TWxxbHc4NEdt?=
 =?utf-8?B?OW93cUY1aXFuNWdmMWdKMEl0aEpYeUJYLzNwSWxQbCtiZlMrbVkvVmp2WGVl?=
 =?utf-8?B?UjlDbmhxZkJwWmFScnhJNzVVampnVno5ZDVTVXV2djVMeGtnQWI3cEJOOXRI?=
 =?utf-8?B?OE9QZUNNYWNzWm9YRjBuL3ZYNy9nOVdZaitQajF1V1NCOTBSK01tbE5ZdUFi?=
 =?utf-8?B?TWRHOEJIdWRnWmhYRS8xLzhMVGlXQTdlaWtFNzlRYmswR2tPMVROYzVidFlt?=
 =?utf-8?B?T0J3SytEdC9PUTZWS2xwTGpRblJ4QjhucSt3eDRHazlLcytBNWJ1b2JPK0I1?=
 =?utf-8?B?amFqQ3lFcDNkN2grNGo4OElGanFtSlE2d3lxQ2xtQjYrZmU3QjNGYk9kdkls?=
 =?utf-8?B?eUtoaUU3SXlRSitRZ0o0aDFQNUZwOTVBTXdEeHNKWkt1TFJVM1FUeHJ5bmh1?=
 =?utf-8?B?ZTF0QWI2M216S3l5dVhxZ21EVkJwMVM5ZEtFOFFKZGtRdFZ0QzBNYXhlRkV0?=
 =?utf-8?B?QlA2a2tPUmZaOUNQaWlsWVdzdVVuQkE3UkZQY25Mbkw4QzB3WUdrRGQ1NDBo?=
 =?utf-8?B?Z0lsMEk3YjBoaGswMzlHdkZDTXhTdG05bXE4TWFPakp0aWxIaThYcEpxNHFC?=
 =?utf-8?B?d1NPR3RrZisxTnFBS2l0bjlia2h3cFVpNmR1bFpaMmsxVHJMRlZWUk9obWN0?=
 =?utf-8?B?R04zc3VSdTdiWkdsUzhJcXFBWVFlV1MvYVRmZGkzNVRUV0F6VkhNanJLRWlW?=
 =?utf-8?B?SWhNQzVqa1N0b3daMzZtcldZMSt0WXlFYlg5SWVTYWtVeVdSQnphZXZyemxG?=
 =?utf-8?B?Q3dxQzFIbXJYVVltRDV5Z3BIYnZnRFgvQWdJV2V2Q1VEOFd2UzgyQWtpbzJL?=
 =?utf-8?B?Y2htMUNpV0FXVmZDdFNNOHNORzJXQzhUL0FnM2tUenZ2bFhxaU9jN20xZ0RR?=
 =?utf-8?B?RTZqSGhMVmZHMGdwckRVRVgyTThZbU13SURLaDF2TStaOHRUMU9kV1NNSHpD?=
 =?utf-8?B?OC80T1NoR2lEZ1hoWkpKMjRzN2tXdWlMZGF0WEFMRC9VNndLNlRRdWZvYnpa?=
 =?utf-8?B?Q0p6dCtINEtUWVFob1ZiMS9xVDlpLzhpZWwxeXhaR3RTM3l3UTFUNFdnMmtq?=
 =?utf-8?B?Ulk4N2VyS29FSjZvdTN6VWNIZ0JPZGYxR0tDd1owWkN0THBWMitLLytFR0Nh?=
 =?utf-8?B?azlSSTVWYWR5aXZ3aVJtUVR0OGVsWVlld3oxVm1uTi81aDJjZGE4Tk5zeXlq?=
 =?utf-8?B?NjRGZTFkQ3Y0Rk9UYXlJd0JaaWEvVkhMenc5Slh2RWlCK2VKMitNbnlwa3Zt?=
 =?utf-8?B?bnFIWThDNVoyTTVKNXgwR2dJOTZVN01ZRzVPN1RjWVJIL3RKR0RaNU5KdlY2?=
 =?utf-8?B?d2JwampGL2wxNEt0c3dLZk1PN2IydlY2djMrcWdheDIxVXlZdTFyWmNlWDRa?=
 =?utf-8?B?MXk5SkJvUHhMV2NPelNOeERrQ2owU2VRM1FzN0ZVUkpVcjBzd1ZBWCtZbThC?=
 =?utf-8?B?cVlsblpIRjhyVExjSVJlSGtEVGNiWVJGbW1XQjY0bDZHeE5ENGV2R01SbHor?=
 =?utf-8?B?Rmp1K2VDQW4xbk5OU3kxSE5sRCtHK3c3TUNseW5IZFhBM2lUc21ncjBrWDNm?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8b8759-b55c-4cef-f1ec-08db34faabd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 10:52:23.2375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3iM3tQNSpxyHTG4bujg3bafU2sUuGr2bFOG0/vKuB6plfOg+/PUEzt9BUQeFcT2ybayyAjIicEn2TY5NAmWQTdkJFZSi7oEIIr3qYySbyao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYTPR01MB11064
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPiBTZW50OiBNb25kYXksIEFwcmlsIDMsIDIwMjMgMzowNyBQTQ0KPiAN
Cj4gVGhpcyBpcyB0aGUgc3RhcnQgb2YgdGhlIHN0YWJsZSByZXZpZXcgY3ljbGUgZm9yIHRoZSA1
LjEwLjE3NyByZWxlYXNlLg0KPiBUaGVyZSBhcmUgMTczIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMs
IGFsbCB3aWxsIGJlIHBvc3RlZCBhcyBhIHJlc3BvbnNlDQo+IHRvIHRoaXMgb25lLiAgSWYgYW55
b25lIGhhcyBhbnkgaXNzdWVzIHdpdGggdGhlc2UgYmVpbmcgYXBwbGllZCwgcGxlYXNlDQo+IGxl
dCBtZSBrbm93Lg0KPiANCj4gUmVzcG9uc2VzIHNob3VsZCBiZSBtYWRlIGJ5IFdlZCwgMDUgQXBy
IDIwMjMgMTQ6MDM6MTggKzAwMDAuDQo+IEFueXRoaW5nIHJlY2VpdmVkIGFmdGVyIHRoYXQgdGlt
ZSBtaWdodCBiZSB0b28gbGF0ZS4NCg0KQ0lQIGNvbmZpZ3VyYXRpb25zIGJ1aWx0IGFuZCBib290
ZWQgd2l0aCBMaW51eCA1LjEwLjE3Ny1yYzEgKDdkNjE3YWQ4OWI2MSk6DQpodHRwczovL2dpdGxh
Yi5jb20vY2lwLXByb2plY3QvY2lwLXRlc3RpbmcvbGludXgtc3RhYmxlLXJjLWNpLy0vcGlwZWxp
bmVzLzgyNjU2NjMwOQ0KaHR0cHM6Ly9naXRsYWIuY29tL2NpcC1wcm9qZWN0L2NpcC10ZXN0aW5n
L2xpbnV4LXN0YWJsZS1yYy1jaS8tL2NvbW1pdHMvbGludXgtNS4xMC55DQoNClRlc3RlZC1ieTog
Q2hyaXMgUGF0ZXJzb24gKENJUCkgPGNocmlzLnBhdGVyc29uMkByZW5lc2FzLmNvbT4NCg0KS2lu
ZCByZWdhcmRzLCBDaHJpcw0K
