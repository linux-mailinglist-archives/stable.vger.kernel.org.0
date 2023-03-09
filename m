Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEC06B1FEC
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 10:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCIJZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 04:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCIJZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 04:25:52 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2093.outbound.protection.outlook.com [40.107.114.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A07D8863;
        Thu,  9 Mar 2023 01:25:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhAxmqaRKVCQ6pUgGa2e0laAo915dnhvf0Vm9hhMinP4MFJI+9tSRwYWsTkczqY731hDn4iAXV4yjwz46JRCndmrzyKDmy3zh4vocvvG6bV8HwRDT7y4sfbEBidqetX6JMssc/XT0NbR2kAprVM5a7uiDZufh2LUe3QOFPjfFXVhaKOVb4nPIjnNKdMvxjxBofid9/p6vPZFWoyvyBxbxliDdnp8WaMovX/ZMm527TiZbT6PFaMH3NMrRK4norb8xEUMY9k/vUvBpBgNSDrX6fX+LVGhzolJ4pZ/CjlkDGxt4t5eedB2ydb+hyQVjeWljJL/+/UwU8pi87YJuHPcrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXJVe5akaLPJV7TLWR3IfYLEyTqlCzf5Gpxlu862djA=;
 b=mA3ZofAQ/hFn97s0eV9Xvwrn/S+UXPfAuB+7NK0olt2TUjCqKYO6KulPkwgaH6jfJEuOT2DW0HVNirFpS4Dj91uBNeDRZ6DEhwWmaS9h9sjgDrpPCwE7biTxNBa54/BbPpq+MJepj4lK9mYHMA0oaItz1Bf1ZKgnpLPfr9FDm1Eu8QHggVcy8775Co4kg+ZLu27GhrsQ7Lyqyc2SioF9pHP0f5hVqhVFKEnTEei0z/YE5U/c8Hp84fOTvFBRH2NF+LbiYlVVKcVaxf9shJaQl6WF/SzDU518J6+L797Q0kS3TJ6shGAPqlWRbVaAFkZ++95PFOjLB8L0y0nFYawL8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXJVe5akaLPJV7TLWR3IfYLEyTqlCzf5Gpxlu862djA=;
 b=odRTZ9IRDE1sLDf4tqE1mtlemDWCTLpkjzKiqB/yLUMLUzFqQgiyibB+61IoQ+c33EkUAqpROqLFLrC1a+15yMVn7ACZ93nQKlKz9iJmvq5t7qDnWzgDoygKr9Iz2+e79XENWSqPYIKDRaAaG7sPTgPPnbLmOOWBxBPwBIrDgx0=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYCPR01MB7893.jpnprd01.prod.outlook.com (2603:1096:400:182::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Thu, 9 Mar
 2023 09:25:48 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 09:25:48 +0000
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
Subject: RE: [PATCH 5.15 000/570] 5.15.99-rc2 review
Thread-Topic: [PATCH 5.15 000/570] 5.15.99-rc2 review
Thread-Index: AQHZUaCkaLKRSF4pmUOm8PmzCOntha7yLl0g
Date:   Thu, 9 Mar 2023 09:25:48 +0000
Message-ID: <TYCPR01MB10588D2B346F3C5946EF28F72B7B59@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230308091759.112425121@linuxfoundation.org>
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYCPR01MB7893:EE_
x-ms-office365-filtering-correlation-id: 1c13f9f5-8f98-4bd4-4232-08db2080448a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4y5OvRx6n3CPvWCQbX/NqPX+Huc3TzOBMlV0xs8JJjaFQfxHJV41mF74K/FUd+pnjVYlJjeGefdNNnpCNKENm3q6Y2VlbdTfgGsWsRWBNmTwOi6jiN/9jMJ6ZRehZ/159OO0hDpm3BKckBhgDYxvLsZyMr4wFCu5g3zeeZ6x3FiPrIbNGQ4e18BtiZA8UkVZ30hUdtd7JmWIfyPlWop/saV1qWX/eyIReGKtc+R/eHeVuDaax50+B+zzOZk9uuP7VOIaqB/uNq7Jz2Y+SYsh7rlGCEhy+tGuICfixgnXNB2DOH19puPZD16GOU1/BKLx3K3GGoRYfROQ2hCi6HHPe07GP0GowRIGBuCEbpZ/h4oOBW+H42c+r156gkdfJvq4IC5UCK+ybAy2H90u/thUDTZ4oDLN39hiozlNFnWTq/JX+vo7ZUH30hDNlVD29jKGQStfzvlGJrQ2jsqaXee5PPXXtXIbHDzHgVD5WK5zA6kBm0d3jTomqHpi8GIk9zZkc2j6Ys64e9SSyMGjSyPbTzObxWwntn9mg0BdpbBArYuKCU8HTC50FXatQYnKbz5v0iJE5R524+xcm7NdM4F9sj7oKMSrDhFKO140c+RAT04J6Zds1wahNxRT5Xu48bzucXaqxPybTeaxyVSILDwOwoaiisO1qXEJomlpd/V2gDB587Rp+rwa6y0TPCUmX+kK7Fs5zeC4cdBjrhY0ifMDj6021dTRMJwA9Yyiru6DYBg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199018)(33656002)(316002)(54906003)(110136005)(478600001)(966005)(71200400001)(7416002)(52536014)(8936002)(5660300002)(7696005)(2906002)(4326008)(66446008)(66476007)(76116006)(4744005)(64756008)(8676002)(66946007)(66556008)(41300700001)(122000001)(38070700005)(55016003)(86362001)(38100700002)(9686003)(186003)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVF6eDVxNThUa01RcXZDZlhTY2FXQ3ZkZXZYUjhYUzgxaE9DOUM0dXJYaGo0?=
 =?utf-8?B?NHhEYnJYcnVGdnJnUkJmUWd5TE5yUEVkMzVGZXBFOHFrSkd4WnZnYk41WWwx?=
 =?utf-8?B?UFZDVnVmQlArWlNuY3BZOWErdjRHMmVQdFJ5OVdaNFlLNXBUNmdJU2sxMUh6?=
 =?utf-8?B?YkRjODMzRkVCODlXQU96a2JWbWk4YXVrT3RFODgxQk5iSzZpK244MXFuV2FO?=
 =?utf-8?B?ZklyUHZabGx0NHR1T0hNYlBsRmQ4b2NrNFo4U0RNZnY1M1hUaGI3UTdDMkNs?=
 =?utf-8?B?UzdNQVQ4UWpvNmpyS0FEeGxpRHluYlBXUGk2Tlp3Z09LcjRwcExjeEdoMkxM?=
 =?utf-8?B?a3FpUU5zM3FHQnV4TnZGVld5K0xna3hUZ1VpY3NTTW9ZbXd0RU9QamtnNEI1?=
 =?utf-8?B?NlNxZGhLNkpuL2tOSml1TlpRb0toRXl6L3J2c3RSN3dWZDd4eFY4UXA0cnVL?=
 =?utf-8?B?NDl2ZWIxSk9peS9KNFBnc25zZFU4U2hFeklxc2gvbTNQbDBtd0JMRm9GOHV2?=
 =?utf-8?B?UUhlRXh6WXJVc2VBNjNDQmJMUkkzaHNXSitZUllGZVhFcmFqbHJDbmpCVUlV?=
 =?utf-8?B?YzV4YlI4cFNVc3NRTk82dllIMHpVR1pISnF5TFZMa0dyMDFDY3RvYmkxYWw1?=
 =?utf-8?B?c1VnUXhWS0txSGVtRituUk5INEEvcFEzeHlZcktpZWhYTWFtbElBakwrTTJF?=
 =?utf-8?B?Rjlha0U0TWNwaVlzS3RDanNjUTJZTytlTHAvQWlYb3BtWkI2ZFF1VnAwQWw5?=
 =?utf-8?B?MGZLcUx0cnV3NWNBbUtSeEkrRlFuTXMzTDQ1b1BFdzJodVVaUVYyNDAzd1pp?=
 =?utf-8?B?U2h1Q0FrcEJRTTlEMmk3RkZNUVIvdHRvbVRvZDYvazlnb2pYL0FrUWhMSDVP?=
 =?utf-8?B?YmpBOU9NbEZTVWxranBWOWd3VnJ2L0xJb05PSXhDQmJ4ZlVQN1J1MnpoN3NZ?=
 =?utf-8?B?R25VajNUb3dWaG14c0l4NW5TV0dqVDFCUFUwdld4RFluZ3pPcTRmK0pSYmt1?=
 =?utf-8?B?a3UyTkh3dXhXM1dCT0k5VHFpVWRTcEFxZS9Pb0hHV2gyVUtzdVZWMXNRYU9j?=
 =?utf-8?B?dEtqaVJCOUZ5MWJJNW56NXdDUFRrb05lOU1GS1BpOWhmWjVxSmwzUE9yeHpS?=
 =?utf-8?B?aW53N1VRRUJ3aGVWZmN2S0JDNFFBNjYrTWVnRXNEb3JBNWpUMVg5RU5pRk0x?=
 =?utf-8?B?Z29TYnJDYnR4NnpNNWppakY1RU9GajVsK3l1RHI0ODFZNWN0YzkyVWhVUXhk?=
 =?utf-8?B?cnNRVVNrY2hIZHFEY255WmZpYVdnbmZpR085NVpuNkFDci9LVytEWElVN1RU?=
 =?utf-8?B?a3NBaHNZYi9NbFNYTFZvNGlkT0tKVnJBbDdtcTV3Yk41VXg3SzBvelByNUhF?=
 =?utf-8?B?RFV5Um1hcE1XbkRiazI0MmhzQjNXTUUrWkt3SEdFU3o3d3lXajlrMmZhbklH?=
 =?utf-8?B?RXNtN2V0WFNZNmF4MUxndzdPblVpOE5sZ3FmcnFka1gvRjhUME1NcXd1U3ZL?=
 =?utf-8?B?eGRuYTNjTHM4dFg3YUR0c0twQW94UHZVK21lWGNKSHJvTXl4WUlYNTRpbXVD?=
 =?utf-8?B?NCtlcGZDblpOUVJIYUpaRVFpTUFwNXc3OUZuaVg5aEJkL1JjTmRNNmJidHZr?=
 =?utf-8?B?bHJUWGZrOXpudjVERHZtUklyb2hIVnFRRktPcTVmRFd3MTdLQ3ZwQ1F4eDVN?=
 =?utf-8?B?ci81ZDRlSmVxNnlwMXpQbmt0ZjYrNDcyVlRqQnpLS21DMkNDcC80VGRRdHdk?=
 =?utf-8?B?cnRpaWxVSmFEeEwxZWRzUlB4SmtCMDd5ZU1QVHBFVVY5K2Zta3cveGp1Tmls?=
 =?utf-8?B?TVVQUjRJdVdEbzdPTFdqcVE5WkxWOTM5eWVRd0xMQnhqRERFU0pZTEh0ZzZP?=
 =?utf-8?B?RVlDNmdlSktqa3RVNTZIMlhGcWVlZkFKZXc3SG41ZzZweEZPYlFrRjYxd005?=
 =?utf-8?B?aTVSV0tzSEF0UHlMMUN5NVlzSjd5N0h2QTdlU2hSK2d0bTIyVkUveVRVTldQ?=
 =?utf-8?B?NnVSU0p6em1kSU83dmx6SE5aVFZUL3VFTFJwUFRLSms4U1VoZVZkeHZEVDlQ?=
 =?utf-8?B?WlpkM05wWnhHNTJTQ3BpaSt2WW9tdFpJTksySUp4WUpXLzVIY21DWGpGUlJo?=
 =?utf-8?B?QjAvTWNvU2FSMk9ZaTI5YzRRY2h6WVhNL3NFelU2MklTOU9FNlVrNEkyanZ1?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c13f9f5-8f98-4bd4-4232-08db2080448a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 09:25:48.0245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pW9ztMkwJ9L6/IO5L197RzObuGlB2mX7FMAf2zNvYyJKJVNDRTybth9DHVYlNZSdW8NCd5V27I0pXs17aZEbuxVYDbNF7ovtwO4kILrQFRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB7893
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPiBTZW50OiAwOCBNYXJjaCAyMDIzIDA5OjMwDQo+IA0KPiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDUuMTUuOTkgcmVs
ZWFzZS4NCj4gVGhlcmUgYXJlIDU3MCBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBhbGwgd2lsbCBi
ZSBwb3N0ZWQgYXMgYSByZXNwb25zZQ0KPiB0byB0aGlzIG9uZS4gIElmIGFueW9uZSBoYXMgYW55
IGlzc3VlcyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQ0KPiBsZXQgbWUga25vdy4N
Cg0KQ0lQIHRlc3RpbmcgZGlkIG5vdCBmaW5kIGFueSBwcm9ibGVtcyB3aXRoIExpbnV4IDUuMTUu
OTktcmMyICg5NTQxNzcwM2Q4NmQpOg0KaHR0cHM6Ly9naXRsYWIuY29tL2NpcC1wcm9qZWN0L2Np
cC10ZXN0aW5nL2xpbnV4LXN0YWJsZS1yYy1jaS8tL3BpcGVsaW5lcy84MDA4NTAyNzAgDQpodHRw
czovL2dpdGxhYi5jb20vY2lwLXByb2plY3QvY2lwLXRlc3RpbmcvbGludXgtc3RhYmxlLXJjLWNp
Ly0vY29tbWl0cy9saW51eC01LjE1LnkNCg0KVGVzdGVkLWJ5OiBDaHJpcyBQYXRlcnNvbiAoQ0lQ
KSA8Y2hyaXMucGF0ZXJzb24yQHJlbmVzYXMuY29tPg0KDQpLaW5kIHJlZ2FyZHMsIENocmlzDQoN
Cg==
