Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7742B6C1DC1
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbjCTRYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjCTRXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:23:32 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2072a.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5BECA12;
        Mon, 20 Mar 2023 10:19:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAxjOoDDaOpycvmjrK1Il7ELj2xiF3UoMd4SxvS8PshhdA6qzbY9SBF476fQUIKZ2olkx6XX+pxBJKG4vWsFV08iztPlcZm5gaJkeoEBTO7qDAOCr5VLsFJt53vSLIXPmupFRKqubbuo2LdefMxVBGigS5+VoaGhySTYPDQUPqTTKwQgxAIp2bjD3lkfh6zkXKdnfX26S29P4C29AyXANlpSNqBcJYE3sSRDEekoA4/WKKr0/y0cdf1e7dPCrm0tp9GDd/GZFa0xFVDxxt0STha3Rn4VzayYJwqr5O6KB8OMk8kM0LKzw1MYHPELBGYZks/bIOoNdM4IFp+NElqTCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7sjXJMNM6dgXXHCjwucilF/IyJwUfRlMSDhy+Dipqk=;
 b=FY9QFK/e3hp+cOb9i7VzO+QK+k+Bbh1Y/sRizlTw/wBA+PNYv0vE5O0ef4+hAPmNgtCulnJZOhWXoTO78eZY84ZQmFv+AlUL+Z6+LqQM0W6ED61Zu/Ga+h3TrUzpfuFVoAI5pjuVmtIeissSmOEWflz4gT1PV3Y8bcZ3u9tZtO3mzec9elO8nt+XImDqe+4HZGCsKEDqjcYFG2FwlPthyo9brSi1QvbPVHpbT1h5S2A0RpQwbNhDLoHY+xxmzeQJoHHGRc988fhzMaA7V2HzV+6NdiAAos4a2hQ0tgXj2SFb8NEDk83+yoKFlnbxEOS0w9LcmC5WuuaUECmn+MTfWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7sjXJMNM6dgXXHCjwucilF/IyJwUfRlMSDhy+Dipqk=;
 b=FVu9E5KnfqfjQbExMcidEC53O+kbiW33GFwl9yUvLNv/ajVUJbdGF0FFiskdjPWWi59THLjDbnDn0fqKMekQVfpGylU7DJFy0FonToIJrec8CTAP0I6m7qrmowOxeKJdxkvQzz7dQ1+f47V94lOjHvLfzLPH0ebERepPjWkf/Fs=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB10457.jpnprd01.prod.outlook.com (2603:1096:400:2f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:18:53 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:18:58 +0000
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
Subject: RE: [PATCH 6.1 000/198] 6.1.21-rc1 review
Thread-Topic: [PATCH 6.1 000/198] 6.1.21-rc1 review
Thread-Index: AQHZWzyN1TnLrFAPIUelSmPIXtnZvq8D5yFA
Date:   Mon, 20 Mar 2023 17:18:57 +0000
Message-ID: <TYCPR01MB10588CD355D7E5CD12AD576B6B7809@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230320145507.420176832@linuxfoundation.org>
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB10457:EE_
x-ms-office365-filtering-correlation-id: 1e59408d-076b-414e-189a-08db296730d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Mkuw6Xg05mK2z/rgyaGEcUZ38TvPCWDDLEH+1CWLAl6w5j+rXBIA0LkFEGUmk7srIFKBP8dlUYIO/0bvOOBMOXVhhQ+3yQgYXzaQwWE66vGjiMSl9M1+XcYFRPNsHQsiMnze5bvYFmEmGbq9tSxLPmZwEdqR3a+TBEoCoVWCh935VHEowLxwrIRTpaOgvRH+jHaV+E32FBa7NDd00PnRMueqjJEsfGf7uhwR46eLnvkY8M66I395fYspyuHhnVrf+Ovif+7h5JEX96Gxnv5zONOOzYMNfWqVPeKx8E2EOhfgaReR/Uv9I6/cJ3yp1zcvgfRKAznXco+VhJ8BHYls3CezmtiwyMpasd0kgx5f0WH5ZCaiV+PT567ReWrpROirbC3OwGzyTjwbHAw2dizWqq6scrtXXbCGPRouSI8YflLkyhIYpJq4Ae5U+9/nMYABRNb1bNezX4IdL94vetvKO5Cua0ypguKpNUFq3pWJdxuDPUJexng36GI051agnBnCUiMhua0pVt9eP9rbPkKUJ4gJLAZgcyFxPQImWJitoofYu+DXnDTgFSQ2u4jFk4G00ufFyM8scdxSbX6SNrOLlnFZp5rSOQ/WV+N+EiWIeB16h2WbxAq+Kxkm6/4Vzgks9pNjmjLw6dQ8Y4RROkwCis/nYTgswckfjcjrgYl6JhJZUIMYK2sgv9q1FetdObzGpBXolbbDHHxCFem/MvSqV/64MiGrKAgi6O3qeJaqEE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199018)(966005)(7696005)(478600001)(71200400001)(316002)(8676002)(66946007)(66556008)(66476007)(66446008)(76116006)(186003)(9686003)(26005)(6506007)(54906003)(64756008)(110136005)(4326008)(7416002)(52536014)(4744005)(41300700001)(5660300002)(8936002)(122000001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXo0UU9LYmNwV2dTUTV4TW91Rk5LUmdvWmt5RVc4VlB3VXdMSEZlUzAxc0lT?=
 =?utf-8?B?dy9MT3pVQUR4dklsWVdPQUdiQWVrcSs3amRyaklvWnB0d3EzSkVsOERUOHBt?=
 =?utf-8?B?YjNQdi9YbUcra3RtMGtmUXIvYVRkcnlTRFhrYXYwbjZQM3BYcmQrYVdqOC8w?=
 =?utf-8?B?REZwcExyeFhXakpPQUk2SFhWNWZucGpQSENEaSt6enBQUnVrVUZTNmRJSndZ?=
 =?utf-8?B?eVZpT3F4VUxQQmU0N1JRVndLRzFqa1ZudVlXN2xrcGVqN1V4M3EwT0tndmF0?=
 =?utf-8?B?M2Y4aGsvRlVTbXYzdUVNc20yZ3FEV3hNSGZCRDZjbVhwRjlBWG1CYXVDOEZZ?=
 =?utf-8?B?b0poSWM0QjNFNTFwTWM5Y05hUkdCeEVjcUt6eFJTd1FwT2paR2U3NlpMQU5x?=
 =?utf-8?B?TmJOZlFMbmZ3Tk9HUFZ5OFkvQ2JNZnBocTNvVEJZbUhFckxXSnBCd2FoNGV0?=
 =?utf-8?B?QzM0UEVOc21TTkhaS3pYVnp1a1MvNWZVVDVDc0JIUno1ZnZuemt1M0NWMy9Z?=
 =?utf-8?B?emRsNTVwOXhwWGQ2eWpjUDUzb09ldmQvSzRhQ2hTeVpFWGVFK2VVQWpUN2NN?=
 =?utf-8?B?ZmdWb1EzaitUM1VNRkRCeGk4ZURwZDZyUm1vSG9Ic0daNXhUSFM0SjBFWkJv?=
 =?utf-8?B?SnRKbUNBY0R0MDh0K25tVDJSdmlaSzYwK3V4ZW9hbE40RXdQUFZGL1V1T1cx?=
 =?utf-8?B?Tit4eFFRZkNGRnNRR2xPRFcycGxLZWhEZXBuTWo5KzlsditqOFFoVXFtYTBi?=
 =?utf-8?B?YWw5SFNpSFlWcXIxbnlXbnJZWXRYWXhtcTVPaUMrVVNQeXk4QmQ1dlNUNDMy?=
 =?utf-8?B?Vyt4aWpJcXU4QjV0TVk0aGhMZG92NjN1N3BOL1FoNkJjVk54T0dGOFZvRkR0?=
 =?utf-8?B?dEY0cnhCWmQyQUp2QTMrY2JCeDRocm81dVEwci9GdW1MVDc3VzFKRjJjejlS?=
 =?utf-8?B?YXMxdGw4MlNSRll6Y09ZSTMxbVJwMm5iZFJsVVZuVTNIY1dJQkZYbTE1WTFn?=
 =?utf-8?B?Vk5Gcm9VZXFUdi9teG9kSS9PWFhpV2RySXBsc3dtbGhkNXhmcGY4cmJBYXpK?=
 =?utf-8?B?VDVidWdXMXVCek1NSW1VMVJyOFQ5Q2VvSlkzYUltaXoyUitvbFNoMXlEc25O?=
 =?utf-8?B?SVYzdHZDdVJCUEM4QTAzWFFZcmczUFF4VHNORFgveHpEdXRxajdIZlhLUzNm?=
 =?utf-8?B?aGkzZjhMZVFialJKOHZXZUpVMitkZGIvVHRBY0VLakZDcUlZTUZQVzVuc0Jj?=
 =?utf-8?B?ejVpTmk2UkxvYUpXbGh0aUYzbXlMcXZVOUZCRjF0aVVKc3Z4TDBIMzBBbkM5?=
 =?utf-8?B?VFhIaUpFOWlpSzFsNktTQzYwKzN3d2VHNDJWU0NxTi9GbUYyMVhFWTVmaVBR?=
 =?utf-8?B?Vi8xSVdHU1FkTGhra0duN2RIeXl4SHhNeFpGcXo0V0d2dTVDSlVvczVIeFdK?=
 =?utf-8?B?TEFjZVpOaXNYRThtQVpBNjgvN3BhNnJueWN4YVBld0xwQ3FjeitoanU4WU9x?=
 =?utf-8?B?ZVlGWmVxTlRFcGZIcGdXZU40dGkvbzJTOHpmUnlFU3BBeVJVNDhXWmdVbFZo?=
 =?utf-8?B?VmxOTnRsZlVVZTdCQ1pwYmlnUVM2SDNTblRKajFsVXRCWCtHcURnOEttSFUz?=
 =?utf-8?B?YnhpWFQ4QjdkdXp2YjlhNmwyQ1Mra2V3RjZ3Zmd6RmtvZVVPVkNMbjdHYmRM?=
 =?utf-8?B?TmczdU9MQmtrczRrSGVLNG1RanVnMG1xdTlTWEpzK3RWR1BjTENKcWNvMURS?=
 =?utf-8?B?YjNWU2tVRFc1MW1MZlBWejlUVnZyYTBsZ2xJQWFheEx1clo3ak80UFN0cUZi?=
 =?utf-8?B?YVorNUdqM1ZXN0hXMFQxUVBIZmw1bWRvRjNVdzZpYStrckd2Uko2WnpPZktK?=
 =?utf-8?B?VTlLVWVCMnRySGYxaVUxSlEweThGQ1d0TkdPb01qSVVyS2JTcld4NnVmdTh0?=
 =?utf-8?B?cE9KRG90QjZ5bmJGRXNpNDc1NHQyQ3QzTjV2RFozSzVOZTBsSmcxSFRCQkZj?=
 =?utf-8?B?VlBmanR1NlNRalZhQkhuc1Rjb1lMVWgxRU8vUVZCUThtYSs5blBPNjhwRW03?=
 =?utf-8?B?OFhTdHh1NnROR2lyVzNZbktJdWpZWmtORUdXYm43YTkrbXNLYnZYZ29JSVhw?=
 =?utf-8?B?T1hLWnMrci9CZEdrUkVQRGFVVGVlSGN0VHl1LzEycUtYbG9QT1RvaTNVbldh?=
 =?utf-8?B?WWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e59408d-076b-414e-189a-08db296730d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 17:18:58.0124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cEAgkDP9z5swA8SBQBoeq30gu1GSeOBfEVqj6WRMcAF1/hAHNvfPpSSD6Qh4OXTg7OKZPy0HSOBJhOJ9bSOg31gacDiRHd8d87aT7Iff/gE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10457
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPiBTZW50OiAyMCBNYXJjaCAyMDIzIDE0OjUyDQo+IA0KPiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDYuMS4yMSByZWxl
YXNlLg0KPiBUaGVyZSBhcmUgMTk4IHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMsIGFsbCB3aWxsIGJl
IHBvc3RlZCBhcyBhIHJlc3BvbnNlDQo+IHRvIHRoaXMgb25lLiAgSWYgYW55b25lIGhhcyBhbnkg
aXNzdWVzIHdpdGggdGhlc2UgYmVpbmcgYXBwbGllZCwgcGxlYXNlDQo+IGxldCBtZSBrbm93Lg0K
PiANCj4gUmVzcG9uc2VzIHNob3VsZCBiZSBtYWRlIGJ5IFdlZCwgMjIgTWFyIDIwMjMgMTQ6NTQ6
MjkgKzAwMDAuDQo+IEFueXRoaW5nIHJlY2VpdmVkIGFmdGVyIHRoYXQgdGltZSBtaWdodCBiZSB0
b28gbGF0ZS4NCg0KQ0lQIGNvbmZpZ3VyYXRpb25zIGJ1aWx0IGFuZCBib290ZWQgd2l0aCBMaW51
eCA2LjEuMjEtcmMxIChhNmU1MDcxYjlkOTYpOg0KaHR0cHM6Ly9naXRsYWIuY29tL2NpcC1wcm9q
ZWN0L2NpcC10ZXN0aW5nL2xpbnV4LXN0YWJsZS1yYy1jaS8tL3BpcGVsaW5lcy84MTIxNzIyNjQN
Cmh0dHBzOi8vZ2l0bGFiLmNvbS9jaXAtcHJvamVjdC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUt
cmMtY2kvLS9jb21taXRzL2xpbnV4LTYuMS55DQoNClRlc3RlZC1ieTogQ2hyaXMgUGF0ZXJzb24g
KENJUCkgPGNocmlzLnBhdGVyc29uMkByZW5lc2FzLmNvbT4NCg0KS2luZCByZWdhcmRzLCBDaHJp
cw0K
