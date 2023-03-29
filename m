Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC9D6CD49A
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 10:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjC2IbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 04:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjC2IbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 04:31:13 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2136.outbound.protection.outlook.com [40.107.113.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F298A268B;
        Wed, 29 Mar 2023 01:31:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEL79OHC88DcRAJPscLwlQz9k8P9Duu9iX8CjMKAUCNQM1POMmaZoH9K4mmdY/jmJXKp8x/i5H18VRxYOKig64wgHSpIzx6Y295rrulV3VTvuafMouckdYaIAC8KWEin2AwtUIM7lQ3muym7G+QKXPM2L86FebkvKI30BD80cVf/w2Bzkm/X8NxUmdBluoFTLeaOdaS9cLfTY7bfAHRCqeR9U68U4d2RXEAKhTDD1ZOvCb/79ASybc4se404Gy5ECCBVnG5u7o7ed2/1qD3V50iLxUrYIdz7PZzswdy2wk1ylYtsxclkoVH8nWqKYlVzMUossi6rtO2iBpbzmGrpag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecpivRJica1KXNcfplhH4LNK27B+U5qeDK4OzYPJFDk=;
 b=bXPmLNs2oC2HZTcBY3T3R7yJnaW9viR8rFzlJAa3Zo0cOPh59/x9Y1XHmZuqgWGbjDH//0LlO10Ddf1wzG8cx9CeOe1BfOs8OJ2ymoUknnBF9PeRc3xHMi8RTWyYpP2qlxraExtuq/Q2v00lMJHUKM+cvV7ndv+Zx3QRyM749UI93pKLMt41TU80ameNyblETf7+zBNw3isBo3zOScBRGX2q1WW4s+1M3RhbF6kdp10q1Zllx1Vpzrz/+8O5UHzlK2hBDN8fzbb0xoBw/HM8AMFoJwSPxxh+B1k/n7fobrKQcE2wBggPDOEX88CKo/QDwY9uN4HRDxMGMAcNOn1Yyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecpivRJica1KXNcfplhH4LNK27B+U5qeDK4OzYPJFDk=;
 b=YdnH202WYvzGOd9E3WwRlHjaWiepp6g4cqVmnMzIIV/RITV2Ob0AxZxK9IwK9zCh4jNES5urgNfaHE+kkUYp623Q8O7THYkcVIpWt5s56JOYXKPKhnwHax2dsBIJ8LfWWHI1zgxWRw0TURJXwPqzj6OL6a0Ag/4pEISDYimys0I=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by OS3PR01MB6168.jpnprd01.prod.outlook.com (2603:1096:604:d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Wed, 29 Mar
 2023 08:31:07 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::1dc8:5434:72a7:eeea]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::1dc8:5434:72a7:eeea%7]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 08:31:07 +0000
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
Subject: RE: [PATCH 6.1 000/224] 6.1.22-rc1 review
Thread-Topic: [PATCH 6.1 000/224] 6.1.22-rc1 review
Thread-Index: AQHZYYVyjrGHSz+0DE67p/rpdMmXnq8RbfhQ
Date:   Wed, 29 Mar 2023 08:31:07 +0000
Message-ID: <TY2PR01MB37888311CB309E2D946AC108B7899@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230328142617.205414124@linuxfoundation.org>
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|OS3PR01MB6168:EE_
x-ms-office365-filtering-correlation-id: 15c3f8cd-010b-4c5a-d94b-08db302ff148
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V995xt7gkbDxIXRAQ236JzOipQwuP+U55skGl0liFd9Aw+di5B/WG3kCZeKjkhnx47g9sm9q/iBPsBDXWF//hU4IwRlFChI/C2LHnxoivGQrbajy1ouqEAn8Ou3D/l3I4MInB4FXmQMXeL+jByNdp+QqnFKSex51Xz5ffZTzivyfHs1tx255xod2S+O7huadoR77BEdAC6mUToGQuvjM01+JOP9p6gfxxvbGHPk09gPsy+FWcXKOv11JDNGQIEX9VYt5CyhUkSVmfQGpHxzS8dnDGu4CrFKd5Betw1WH1ACJsdId+A2tv5+VV2RrhYDoS/Hn2Kp5uPKyQmeI3wISHE3FIqsJroqEtUj8vfvR7KwhnhKCKyY1BaS8nYlFKPr/MTr0O3tX4MwBIWUWsQNvZXF/6mlarmiKF+O+1InHnM2bFEjY6f7nw51UXtMmW0UGpbqXM6aVL1q9gFABB4oj4Z1wLrKez22zY03jVJt++bvn3Aucx3Nz3+OePMAq1BHBwkys9mZzW6ezxX5XajmsYXWgCV3Oe+Qir6hIBLXXH0BoQ6ckXLxaRo0SQzpTAcxeZYbtpTFwaUwQcVC/cZ3ebwedGFCc+fx8I5E3UyQ5QOtGkFIJnYBorV4L7GNbB/4hlU6dOXtkPzvl+7yFXZWpSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(966005)(41300700001)(4744005)(76116006)(64756008)(66446008)(66946007)(66556008)(4326008)(186003)(8676002)(66476007)(7696005)(7416002)(71200400001)(5660300002)(122000001)(86362001)(2906002)(38100700002)(26005)(6506007)(110136005)(52536014)(8936002)(9686003)(38070700005)(316002)(33656002)(55016003)(478600001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGhnemkwZmgzNWtZbzB5RlBFNFB5a1BVRjJheXM5Q0VXYTRNc2VMK0FYQUZw?=
 =?utf-8?B?dzk3bGdnR1hYV240dUVyMTF6cFM4cDBTdzdGdEFEbVVOVUhIajVOQno5Y05M?=
 =?utf-8?B?NEpPLzFHNmRjOTVqSkNlV0tBUVROZklldW5qVFBoeEtPd0t5QnVTMjdkY1ps?=
 =?utf-8?B?ZFgybk9kc0N5RVZEZFlkc0xDbEp6S1dmOWlkRkdxektJcWlQbWx4R3lYaktU?=
 =?utf-8?B?Z2dFVWxnU0R3dWNNamsxZHhUYVIwYnI2YU82YVB5MTBJR1g2NEpkaTQ1SmNQ?=
 =?utf-8?B?NjdWRVhxUndpTldRK0FBbmZDUm1ORXlkNHVnc3N2Q3NkbmhKaC9SZG8wUDE0?=
 =?utf-8?B?bElzS1JoYzBHd0dYU1BIWGViTGU2NmIvejFqQWhXU0tVYmsxdi80ZEk3aCt0?=
 =?utf-8?B?cWVFWXh1Tk9Qa2gxNmdqUSt2L0dBLzF3ZG43bFhWeWxTOEo4QmpPN3ZKcnho?=
 =?utf-8?B?cFlCMTVkZitESmo1WU5zc01xc2E4SDhaajJMNVUxNktsUVRjMHd4VFZVYnNF?=
 =?utf-8?B?TzhrSWVlVXRHZ3lnNHF2NXpLUmdmYTRtT0E1amFqMEgzZjJ2L01JTzJXU1Yy?=
 =?utf-8?B?eTdEMDFPenVuaExxcTlnaVV4V1pGMlkvYnA0UFY0SzVldE9EaG9MSkVZWFRp?=
 =?utf-8?B?UXVJNE5WMDYzZDBiakVkMU1rVlhVYkwyd0Z6R2IvYlZkOGR1eWo2Wnlvb0RL?=
 =?utf-8?B?bkdLc09kMzBYb2E4S3p6YzBSdTV1RGZTbHFITERkK1I3U0JKbTNRSjkzSlZC?=
 =?utf-8?B?bnNROG9sbm5FUFI3N1FheFFiWWFKMkxBTG9rSmNSL2t6SXFud0Vwa1dJdWNN?=
 =?utf-8?B?ZGh1TCsrVkVQMmlIT3N6NVBORktpaXJkbExPY3Q0ek5wZjR6WFlvSyt3M3Vy?=
 =?utf-8?B?anVJOFBQMGdrOW1lT1VvZEZQU0ZMSzkyMHdUeGpaSzR3UTdXNVJaWXFyeUZt?=
 =?utf-8?B?a2J3L2dWeEpxRExaakVwa0ZScjVNdFpFU0x1N1RXU2lzNG5WYjlyWm81TnVH?=
 =?utf-8?B?d3dZUzlEdDdVMWkwVEYxaEx0L296dEZTYVkyTTJsOXVsZEtkUmJzNitweUp6?=
 =?utf-8?B?K1UzbHduOUgxUDd0S095VzJieXloWWltK3JNcHJKQTFOTCtXVWVMY2RlUWRr?=
 =?utf-8?B?eEZQVm0wV1ljVjVMb0dKaHpHZk1nL1BKazRocE02RStYcDdLV2NsNHFBajNm?=
 =?utf-8?B?N095S0VDNzlnT3hxZEIraDBHZFl3QTlVQVZuKzRGYVZETVo4bkJ5RUE1L1I1?=
 =?utf-8?B?MzhlbDJjcnc4VUpLYVMwOUNYTlo1V0VSckdYUFB6MnJnNUloV3hSYzVZK1RP?=
 =?utf-8?B?MmZzdG5rTXduc3cwRFVXcjdDbEM3WE05VWlPdlhIRjl1UHhBU0VIK0dPVXVS?=
 =?utf-8?B?cWdYa0EyMXRpdld3V292WVY0VVgvMzZobHJBNDV3SkVDNjl0R082cmdRbEJr?=
 =?utf-8?B?RmZjUmhzakpjd2QzYjRwTys3eVc4ckFCak04czlDdm5UWlNtUnRoS05VWHVn?=
 =?utf-8?B?SDFkbjlBV0pNeXRKUGN6dVE0cXdjeUx4cFN1RFBmUWVnRktmbEt6THU2a0pC?=
 =?utf-8?B?RlcyTTlRK2dCSnovRG1zN2szdHNoS3YzSWVQUnpCc3NlSjdWUFRtU3dnN29y?=
 =?utf-8?B?aVJsRmpHSHBLekFJaEVFSXZPQU83djdUS0RjUWdGL2thS1YySDl4ZndZdHNr?=
 =?utf-8?B?UDhFN1lSdXBFdk1Lc2FlVUpaMDIrcmI4NEJtVWpqRytFNyt2bVZkemo2NEZ3?=
 =?utf-8?B?THYrcTBDMjM2UlkwT212SW1NMTBoeFhiM2NMcmlvbHh4bTQxZnk5NUd1R2tv?=
 =?utf-8?B?WTQrSmRFYlljY2FBbHowRXhZelRXdVRjZnhxQThPVUw5ZnQ5SjNybzhzYXlQ?=
 =?utf-8?B?WWw0OWdwUFFXUXBHNXVMMy9IeHZaMTJPaWF4ZUcyNXE5Wk5ZcnhGcC92NHJs?=
 =?utf-8?B?RGdqcXVRTGFhVkkyZkM2MVJaY2dtbDZGQ0UwZDlCbHV1OHVneVhOcTdvUk9R?=
 =?utf-8?B?WnpxWUtzYTFtOUdZZkxYYk1RZGhObmI2bkx1d2RoY2xxWitlVHFnWS9EVmdy?=
 =?utf-8?B?QW5uaVpZcFF2L1Z4ai9QRTVHbFBqK3BPc0dsallxZlhTblYvaFdNUmc0TTlG?=
 =?utf-8?B?S1VYNm1yRjUrUmlZR2JvbVl5V2dENTJuMXF3U29MY2xzYTArVjF3aUhUeGgr?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c3f8cd-010b-4c5a-d94b-08db302ff148
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 08:31:07.2728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NeYTEHViXOYQunpafy1uzqUVCk+EdwEPd3zlysFKcLPHBa6+tReE30RgyXk2Q8vEjgeYoqMsfzwbRndheBVqCubok8jw0zxaPBgdGb7LV80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6168
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
dW5kYXRpb24ub3JnPg0KPiBTZW50OiAyOCBNYXJjaCAyMDIzIDE1OjQwDQo+IA0KPiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDYuMS4yMiByZWxl
YXNlLg0KPiBUaGVyZSBhcmUgMjI0IHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMsIGFsbCB3aWxsIGJl
IHBvc3RlZCBhcyBhIHJlc3BvbnNlDQo+IHRvIHRoaXMgb25lLiAgSWYgYW55b25lIGhhcyBhbnkg
aXNzdWVzIHdpdGggdGhlc2UgYmVpbmcgYXBwbGllZCwgcGxlYXNlDQo+IGxldCBtZSBrbm93Lg0K
PiANCj4gUmVzcG9uc2VzIHNob3VsZCBiZSBtYWRlIGJ5IFRodSwgMzAgTWFyIDIwMjMgMTQ6MjU6
MzMgKzAwMDAuDQo+IEFueXRoaW5nIHJlY2VpdmVkIGFmdGVyIHRoYXQgdGltZSBtaWdodCBiZSB0
b28gbGF0ZS4NCg0KQ0lQIGNvbmZpZ3VyYXRpb25zIGJ1aWx0IGFuZCBib290ZWQgd2l0aCBMaW51
eCA2LjEuMjItcmMxIChlNmJiZWUyYmE3NmYpOg0KaHR0cHM6Ly9naXRsYWIuY29tL2NpcC1wcm9q
ZWN0L2NpcC10ZXN0aW5nL2xpbnV4LXN0YWJsZS1yYy1jaS8tL3BpcGVsaW5lcy84MjA1OTUwMDcN
Cmh0dHBzOi8vZ2l0bGFiLmNvbS9jaXAtcHJvamVjdC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUt
cmMtY2kvLS9jb21taXRzL2xpbnV4LTYuMS55DQoNClRlc3RlZC1ieTogQ2hyaXMgUGF0ZXJzb24g
KENJUCkgPGNocmlzLnBhdGVyc29uMkByZW5lc2FzLmNvbT4NCg0KS2luZCByZWdhcmRzLCBDaHJp
cw0K
