Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B236C470F
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 10:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCVJzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 05:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCVJys (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 05:54:48 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2101.outbound.protection.outlook.com [40.107.114.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECFA231D7;
        Wed, 22 Mar 2023 02:54:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blMgSEkPgYYvOtC5pIzaLSZUqQDtgt3UqTAipDuUljeujEdpBfOCHNJUp37ySWG6ivy13C8I7DFEota7ZIIsZioBIfa+lbqA19oLOnzYk/d4XssM0X1ghYlz+G7bAYR8cirWZq7MCtyiai6fg6rwfst17+wX+gAU0TZlE1w83nxzzRLkbFPU88i+WAtjId63gOUiLPPGo4wW/FFt58d67G1i+mhGxuUQqCZI+Srx3fR33v9w+Md+SV3Mib6FNtE1rRZWvv8NvjFzGnbvTK1IjNOiU4qUFJr2zp7UY+rzm1ZH9WneR13JyKZlSRL+kOMg8wSPb0qao6lGSismIcXVEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=umaaCcismBTSyky6Qnnj9c1xtmY/osDq3f07AjGVsAo=;
 b=auwhNQUEvICH/vHGS4jLSTiaSLR0Ve6HqdX7++GVByaWDCJvFZnfwwziZ6W7po+XehB1vaLYMapkT6UgcNOrJFJc/C8GS9MP6QbtbSAZLxo9oubh1MPvoryH4AUU8uTPuTLaMwGg9/ehtq4NsnvlhkVqA71vM69Qxp5Wx3N9/NGuy9el6S0y531iPKOfR+f0bjc9kJCxIJbFz2rC3sGMJvibozHa/thJzmLgPU4xNE1yWaVTXrpnKUIAJalOFi5GUWGASIYhmjRkzG+ifYZZRJgf/aOX4Gd7+XpwvyqYBp6s5rASBX9kM+yVADcIc20qFheToEflv3Z99CgTQ1fvBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umaaCcismBTSyky6Qnnj9c1xtmY/osDq3f07AjGVsAo=;
 b=DhK07y8wC2f47ws7a98iT2E0nxmljOeyDL2zgpfBKL8rAMWt3Qa9Az8s9tpeiYltq6nvAnNKt7RijNFAhSzpyzIKwNZ2Q/W+pJwiiguuDNdzfrog8kxBr9r12q9wewkcadjxier3HriCn6YzcPJY5aFMtLKIKiyJxOIHL7nBGFQ=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by OSZPR01MB8645.jpnprd01.prod.outlook.com (2603:1096:604:18e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 09:54:07 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 09:54:07 +0000
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
Subject: RE: [PATCH 6.2 000/214] 6.2.8-rc3 review
Thread-Topic: [PATCH 6.2 000/214] 6.2.8-rc3 review
Thread-Index: AQHZXCA3sribnGktBkC5c0awTSDpl68Gj7PA
Date:   Wed, 22 Mar 2023 09:54:07 +0000
Message-ID: <TYCPR01MB10588425097F7BB5600D90BE0B7869@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230321180749.921141176@linuxfoundation.org>
In-Reply-To: <20230321180749.921141176@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|OSZPR01MB8645:EE_
x-ms-office365-filtering-correlation-id: 09f46f3e-078d-4d45-d484-08db2abb60af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OOLaBi43drm3F2OgJlukz34v1LdGpU3r9Jpl4ITejB8vKrGUnv+m5EVEXruc24dnznQM3WMnsFEIJ4qIpBe0qYbIu11whOHifqXnb8tJri36HoyOtKLcSKAXJZugfJs2CHxlWQwcALTz4MCii5NDjBBYDYUjhlMB027AxMvzQnSTQLw8op8LvSd9KPD5dtox3w/s5rFtt6BlmNFCNrWEwm39iwJtc4mv7aiO9CDpl25ERXw8mZ9zSUYEt3TpzzgHla6/VVtM6ZR+qCtBNZIsCqjmQtNFMFfTV06GNqLAZB2RJceRx1Qsh0x2tjm9QJbNOTqbfNdTWFtdgymO9As0x/5w6krJ/svSy5rUVtccQIium4mDhHnaoGCXtaBFJoAY9QoXHJXBzoX1P0USfX1XDSkJsT0ndr19f+DYwpgNdsoAzSQ8e5Wad0xdPoFECMGbGMhr3b1oR5fgflUBx0mcjBwMD91ngdBa+8Jskw5+uAS8ZZKrdP7bCafTVd1l5bCXfNJ7ZQZC1hMnH/NLhsS+EB4+hQRJHbF1NvdL/zS6iBDPiDjxj6CmvbgCQXFQX1wup7FaAXOEDxSOGK4IKph4UqlswyWdwE0wcKUHJ1nW97r8BlEWo28kgytROEoFRsab1xPUoSLFOSrMfb2wAzpE6+yNcsM/F7hIRrbDYXGe4wZ3M4arnMDfxSlrcpxk/j4kL0k/DL7UujfiXk7wB4Z0dedqmBmvrKsqKhPpVt2uTcw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199018)(186003)(7696005)(71200400001)(966005)(4326008)(478600001)(316002)(64756008)(76116006)(66556008)(66476007)(66446008)(66946007)(54906003)(6506007)(26005)(9686003)(110136005)(8676002)(41300700001)(4744005)(5660300002)(52536014)(7416002)(122000001)(2906002)(55016003)(38100700002)(86362001)(38070700005)(33656002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTFZOEdZUjlEK0RRZkF2YVNTc0xpUnREWU0rTmpDQ1JHKzJZQmZzcHY0Ui9J?=
 =?utf-8?B?UFMwbThzUVZNSklsWmxzdWthMmZZZ1hRVEVlNHE0cEpSUHpra3hWRWZGRnYv?=
 =?utf-8?B?dEhkTkVJUVkxWE53Z3Iwekp6U0ova2ZOSzZ5MVp4NkFWZGkwSVNWOVlYYUNZ?=
 =?utf-8?B?d1F0VVB0L0d5YjdVSHFpaU9UNzUrUUpaWE41VFdPbzlKcStqeE1IZkIyZ1B5?=
 =?utf-8?B?c2VCeSs1eTdEOUdPTmdWdlFjQ0xORjlkYmt0OXc5Q0UxTyszYmNVd1R5VUdk?=
 =?utf-8?B?MjZ5b0w3WGJQMTJtdFpoeHAxODl5ZStTZEhLUERMTGhPNmJtUjFKVnErenY5?=
 =?utf-8?B?UCtnb0QyYlJuOWQyV2FOZURpdWNwa3VPZkRhZmhPaHoxSDJYM3V2azBZK2J3?=
 =?utf-8?B?bGdQRDA4ellJbjFTTHBsQnFSdlhDODkrNno4MUpGUDR2Z29vV1VmMytjQzJl?=
 =?utf-8?B?VEZWN3ZIb0YwODhkajlab1FBaVJRcjYzcUJqdXZIcG5BdVBzWVhzQUhLYzl3?=
 =?utf-8?B?SDR5eXQrckdQVnZpTmFXMGtyTTBnRFZBdVF5Y2l0N3lqOVNvaWJOMzZkNjdi?=
 =?utf-8?B?RDNsOHBEekhxOStlQ3NHK0NnaUhzWkZSSVhiSDlhVk5YOGxuVVQvQk04N05N?=
 =?utf-8?B?SVhPWC9IYjM4aUl4VFlMSHIrdVk2S2NtNVROa2NScm5SM2lTU1Raa2lPcjU1?=
 =?utf-8?B?bldNWVZJbHJ1OUR1UkVhTXVvMkh5dkVzT1dCSE4wbW5FV3ZMdXNxVDJRbDkz?=
 =?utf-8?B?QWF1WmxyRllOMVdZaFVQcU9Icyt5enQ5RGc3NER4R0FCRlovQW9UWEtYMW9W?=
 =?utf-8?B?bG4yYnFWSVNJR1FhZCtFT2lBcGpORFMraUFaRFdMVXR6dmhPM2xHbTg3V0ZG?=
 =?utf-8?B?dUQzRnVxL0V0T1MvQlFXTEpBRWgyalp4djFtZ2xiUFh4aGMyTENQSlpLT1VK?=
 =?utf-8?B?OWdCK2lqaFdGUlZqRklPSDEvVE8vQ2ZKUDd5c3pvV2l3SUZxTFk1QXpNMnZt?=
 =?utf-8?B?Q2JGMjc3QlRRc2FlQXZnMnlCSDNWazBNNUU5NXAyd08xaSsraWtFYlBoRXpG?=
 =?utf-8?B?aGVoNHlsR2VwbFRnZmd1Y01IVHJVMFR2aEtKMU45cUJuZlZNQkEwWTV3Ymx0?=
 =?utf-8?B?ZWxMOWpGdEpQdzFMNTdXMkJxTmlZR0NhZUd3eFluQ3F2N2F5OTlsL3ZtQktz?=
 =?utf-8?B?NDdXVndsR1NRZkNqRFhHWG44bmQ5UHU2WVBxZWQrMFR3UTIxRHFjdVp2ZDd0?=
 =?utf-8?B?a2tWM3NGOEh4Y3NsSnZiTExYWHcvZk1rNkowSXdXdzd3OXpIMGpiUXhicS9p?=
 =?utf-8?B?RjI5cVpWRlhoMXUrRFNBUEJ5SmV4OUM4TTBYN2JFZm1mL0ljc0tKTEVuUUJB?=
 =?utf-8?B?TEQwSVlzRlJqVnhSZ2RjNzFiNEo4YjRUZVB4QmJGdUo4eTFaMHRFZjdDQ1p3?=
 =?utf-8?B?RDJzeWp5NXZLbjJRWHVBM2RvM0Fvd1g3S0tSbmhkZ0FQcjkwcE1ielJMd0Ns?=
 =?utf-8?B?WlFMMzV5WC9CZ2I0MXdaeTRqSE0vSndVdlRHd0xzbGdQZ3E0SlZMVWlkeXl3?=
 =?utf-8?B?cjRyNmpUalAzWlh3UUQ5bVBPRmQxTndjZk1DMEhhV3hQQ0w2WEhpNy95UjVl?=
 =?utf-8?B?SEYvaW9tZ1F6NUx1dm9oUThLMnF2MU9KYnpQYkFtakZaUDF6RFZRUE9XekpB?=
 =?utf-8?B?ODQxbks4UmxCa3g3d2w4VTVaQUpHYURjdVFtQ01ESEtuejFYa2FkaWhlNndj?=
 =?utf-8?B?RzhaSDM2THRUL2h2Y0tTbGlOYkx3eks5cU84b1kxbWhCWjhJK0xSV29vdElM?=
 =?utf-8?B?NXloTytQeHRJQ2ZhQkRUS294TTNSdnlPcmwvUUhabEJFeWJucW5GZm9QWFZs?=
 =?utf-8?B?OXEwSlNCK0NTSHhvZWo0T1FaaVJDb3ZscGtxRXI2OElXdXg0bkN3Rm84RVlX?=
 =?utf-8?B?bnRGS1RsSldlblVFYkRnQmVaRnU2S2xBUVZ3NUo1ZEhtNW5QV1VPQmhpTXF1?=
 =?utf-8?B?RjlrN1Q5SU11OVFmVkZlNkMxeGUwNkVsNEdJYnM5MlhvMWpWalF5d1N6N1k5?=
 =?utf-8?B?THJ4dEl2RUlKSTFQS2loNmNqdytmdVppSzhyWnJVZjhOb0hwZ2tJa1VtQldw?=
 =?utf-8?B?dzZ1c001eEt3STJrVWZmNEZkUUxEZ1JiemhHZ0ZScFZleCtiN2VubEIxbVJv?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f46f3e-078d-4d45-d484-08db2abb60af
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 09:54:07.1975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LXwg6SFw1VUyEh4fXtqikinh+3xTfui5xQCM3U1mmP371+r9Gj4ntIbsB9Rnwg9om+GIz7318v6U4eSNe4cezlVVV0xxMrjLmPFK6PBRLq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8645
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPiBTZW50OiAyMSBNYXJjaCAyMDIzIDE4OjA5DQo+IA0KPiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDYuMi44IHJlbGVh
c2UuDQo+IFRoZXJlIGFyZSAyMTQgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywgYWxsIHdpbGwgYmUg
cG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFueSBp
c3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4gbGV0IG1lIGtub3cuDQo+
IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgVGh1LCAyMyBNYXIgMjAyMyAxODowNzow
OSArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRv
byBsYXRlLg0KDQpDSVAgY29uZmlndXJhdGlvbnMgYnVpbHQgYW5kIGJvb3RlZCB3aXRoIExpbnV4
IDYuMi44LXJjMyAoZDljMjM5YWUxYTU2KToNCmh0dHBzOi8vZ2l0bGFiLmNvbS9jaXAtcHJvamVj
dC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUtcmMtY2kvLS9waXBlbGluZXMvODEzNjkwOTM0DQpo
dHRwczovL2dpdGxhYi5jb20vY2lwLXByb2plY3QvY2lwLXRlc3RpbmcvbGludXgtc3RhYmxlLXJj
LWNpLy0vY29tbWl0cy9saW51eC02LjIueQ0KDQpUZXN0ZWQtYnk6IENocmlzIFBhdGVyc29uIChD
SVApIDxjaHJpcy5wYXRlcnNvbjJAcmVuZXNhcy5jb20+DQoNCktpbmQgcmVnYXJkcywgQ2hyaXMN
Cg==
