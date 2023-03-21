Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5160C6C2D89
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 10:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCUJFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 05:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjCUJEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 05:04:51 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2103.outbound.protection.outlook.com [40.107.113.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49993149A4;
        Tue, 21 Mar 2023 02:04:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckamKmx4o8LSg9qE+yFa5G/EdkuPXoZIUXfaJ9CT9BbMn5Wdo85Se7my8B5XSjkOPW+WJ7YBloYpizjCuybRo9jIE8us0xbnjIMU9S+legrOotR5kTkxq0laBVnR3Ukm4q3jlDP5KsOiRAUwd6nymLy4JBLWEeQJ3Pvat8NZ86a/9pGKpAnV6PAgIs/0lYBFr1FCZyncbCIWaWC6OfcNMe+TlVGATJK5ZY8aVg5tlJEputeYfeVURgH0MgG5usfFs60ghtvCyH7c+sLW7FSVuKM6P2ZvwFKDv+O9P9OBJFkYGvs3Qke+wRxHiq9wcvGAsjWeGss50ciwUwNI+7qC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIIekmyqCrjmSW6+cstJ6eKOkNUU/lCNJSquw+yFw5w=;
 b=dGkRhZhSzHNYCs8zQ6ACmn2SjSv4407OmwdeHiHUuZK7U0o46daShy68J9ofUVR5uMhu3/NbIWZqQS4B4cWz2mvPc8EWboUaCPBV5HHkmBxHS9UK4zpDDAFj8LTcjECOLczCkzbh0IaPe7CVTgMnDB5UPMj/dfADCA/bQHDLod+uX6wht3rWcvy4WEyULwoDfZpu50GLYaDJBlRdffibT0X5riKM3RZrM38dnuGeIZZ7rvpj9q6vM1s7Qgpj1ZvWVeUZbsjnXt3CaB0whaiExK0fGGoWGVXHGOBHwGHUsCclKrljQW8vJWl6ulfXcrb0alGVKn7F+QbpuNMlv/2oIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIIekmyqCrjmSW6+cstJ6eKOkNUU/lCNJSquw+yFw5w=;
 b=VzkYq3hF72ullXQ93dGaWZ2aF+opK/PJPtMEyMLeROO5yPyge9zTfksjlqOJ+HQ/Nh/C5xkSFaEUYTBDjkRJVBEz+h39krYcT9c1f3BDtA5ly8BpS7Wrl9HKx/GsdkP2Ckl4obK2t1DnYC0SxrmpVM8Qcu8buW3w6XmqdQfLPdg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB10331.jpnprd01.prod.outlook.com (2603:1096:400:24b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 09:04:10 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::f54c:4b2:9c7d:f207]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::f54c:4b2:9c7d:f207%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 09:04:10 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 3/5] tty: serial: sh-sci: Fix Tx on SCI IP
Thread-Topic: [PATCH v3 3/5] tty: serial: sh-sci: Fix Tx on SCI IP
Thread-Index: AQHZWxpEBzEtfnJlG0aR90FC5MD2M68E4s8AgAAOJgA=
Date:   Tue, 21 Mar 2023 09:04:09 +0000
Message-ID: <OS0PR01MB5922D7D4566D2C418769DD5186819@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20230320105339.236279-1-biju.das.jz@bp.renesas.com>
 <20230320105339.236279-4-biju.das.jz@bp.renesas.com>
 <CAMuHMdUqd=cwefG-AK-RqtN_aWKAqy6Rg65imHGgGKXvn5q-Bw@mail.gmail.com>
In-Reply-To: <CAMuHMdUqd=cwefG-AK-RqtN_aWKAqy6Rg65imHGgGKXvn5q-Bw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB10331:EE_
x-ms-office365-filtering-correlation-id: 37112593-224d-4c33-e5f1-08db29eb3bca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7VoVrX7QsG9q+MuB4ajgVwvrFjCRVQddOTSD60ORJZDn8BrfDhQP8hSvgzE7kfFhR8f64qK/7yvhtKjJH33lnsv/1nWKfKn5/dGzQxXWZa7fK7Amw7YR3+NiTr9TXTnQbVcBwUap39J0PVwrtk3DLjzgqCWj2NH+QJITTVVmPShjAoTkgaQcvfjXNByYh2dDNShzaKTqqpjkNVGpt9RwJPCc1GcRm8iS0TRwKxNrqwsAz3t7uGhpvECLVAlelJ1qv8kUwSzoUKPHetyt0QJsPlNm0z3WJ7Mux2kYEaVn6Q1bilBwJ7/e7JzdyIwqOq4uXG1gmOW3NKSVMzeZuyInfZKlvhqdv9kL/mdnJOHs5XiSQdwzV9tpi8O87hDRg6kPMEg0lQ+Ptf9NfaOFGmxkE5p/+05KXVDiRP6cBUkx+qu4qadDwIZ066ujuh4MaA3eC3T1bKywE8558z94l8YFMOKO0FNWJ5BEAVoCgEXyjSf6LtQjEMoA9lqLvHS+KGlywIxIVUCLdUIIMM4M5iqd5Sgw3rCjnZlM1RKJHdi4w90QpVIlko7TRXMZ4kTGaulXf3eDovi2T/x/IUFg/Wkb1Owhc5ABW68CQ0BaU+xpOSzSdpk3hyizXdMER9PGusXk0OHGZKJ9BVr0tUJJkTqoNSKhKOpvnYHYgUatyqTJQsXd+CAFxBktk+mHgnuSmujCHF1uIBylHGXLNAuMN4x81A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199018)(38070700005)(6916009)(478600001)(41300700001)(33656002)(9686003)(54906003)(66946007)(8676002)(5660300002)(52536014)(8936002)(66476007)(4326008)(66446008)(66556008)(64756008)(76116006)(316002)(26005)(2906002)(86362001)(83380400001)(38100700002)(71200400001)(122000001)(6506007)(186003)(7696005)(53546011)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGQ1bVQxenE5ekh1am1sRzNPZkp5SEg3MmJDUGtjVGxvN2JaOVQ1MWNQTkJu?=
 =?utf-8?B?bmd2NS8wRUM0Um9BNTluRm1jTWRGMDJ4ZnYzV25BaDR3bU9VWG9SdFB0Q0V1?=
 =?utf-8?B?KytDTWYyUFAxSnZFU3NWd1VXMVd5ZCtmVHJ1N3A5eTExK1JWZDBVVU5JQkpv?=
 =?utf-8?B?UFV4M3dpZk01aEljTVFoVkNld3RrR3FoOVBRK0d0c0xvRTNvaFhBZU9rMVM4?=
 =?utf-8?B?a2p0VU1qZ1BMZTdBbVBlQ2ljdTdBOWpLQUtxaEJNdHFqN0RJN2NMcHh2WDQv?=
 =?utf-8?B?TURmZGxHQllvSTU3ZjZVdEFwR2YvdUxuYzRwSkxzYm9EZWhBOHlGYmxTbFZH?=
 =?utf-8?B?Tmh1M2wwK0JWajU4bVA5NEtJRkNKSnFvZUZVSnRUeUtMVnk4WGNpS2MzdXJM?=
 =?utf-8?B?Z1p6eU5TeExDUGd0eGpCcldpMjNNNXF3Qi85eDAxeDdHbHpLdG5EU3Q1NnJs?=
 =?utf-8?B?aWtIUCtpLzBMdmZsdW9oanU1elFQTHAxbS81WTJ2dFBjUVVaOWk1YzJjdTRq?=
 =?utf-8?B?cnBUYk5MQXBKaVVyRHBDaHJPVW9YRTFrRnY0NEJSU3V2Q0JrRzI2RXFGRmRz?=
 =?utf-8?B?YzZEbGl2TWxWNnFmR0UrWDliQ1BvY3k5TnF6MVVRdDhOcEhRa2lBOHZjcjRK?=
 =?utf-8?B?YzFqSTR4YUd1NVdzblZpUXNxR1k1NDFjZkkwYndRd2tzMHdqVUh1N296T09z?=
 =?utf-8?B?MkNTLzJSK1AyVVdSbW5va3JCMTk1ZjljbXN4R1Y3L0VHQjZ6dGdQcjdYWllL?=
 =?utf-8?B?eUJjMXFMTVpZUWtnck1OUmRpNzM2QmtTMmxkWGhNR2NPYldJRUszenV5VnZs?=
 =?utf-8?B?TXFEMWE1ZEcyd2hmaU15a0ZVdlRzak5PcWpoalJjYnBJTjB5T2lkRS9tYmlR?=
 =?utf-8?B?RHIrWkJXREl3NnB2eWdpZEhTNXZOdkRPVzFoeUNoSkxRYjZWcTg3ci8zTzhS?=
 =?utf-8?B?bmQ5WkJaSHJGbm14K0pUM3lNQzAvVEYybGNDbVlhbjlYUCtXN21SMDdTVEg1?=
 =?utf-8?B?ZzZPVmRaQ3ZuQzQzNE4yb1ZVcTRXcHl5cW5mbDlyZnp4bFIrSE50SDhLcHp6?=
 =?utf-8?B?ZlZlclhaMndPeVpzNlJPOGdTTjRqc04yYUp4MWh5ejFVNXFkRDVFR2pjTDc5?=
 =?utf-8?B?aVhxRUV5YlVsekYzTzhGNTl5UitiTGY5KzVlREYyUHRKVXNEK0w2VXppZzJB?=
 =?utf-8?B?ZzluSU1jUExlUHB0WGZoTVh1VkNrRjBIdEFxL0o4UWU0RHlpdCt2dzJvQ0RM?=
 =?utf-8?B?NFJncng0Y1hQWGltRkw5QVFGMTVuNTd2Q3g2UnYrUFA0OFR5QUU5akx2SlNt?=
 =?utf-8?B?ZHorcjVJbXdUVk5IbjVHV1V3Tm9wQStFMHR0SFVwK1dWTWk1a3BHVlExemsx?=
 =?utf-8?B?UGtFSHhiSU56Qkk1ZFozZHhxbXAzTXdrcVZ1R0pkQzFrTzlMcjhlemduMlY0?=
 =?utf-8?B?TFJwMHcxOGFkK1JlRy9UUUlFYW5YOCtHMk1Hc1NhbFdncmIvanRXN2dxaHRD?=
 =?utf-8?B?RDdTTzVNaGJqcTcvYjBENnoxSHF4enIrbDRSSDZWeVdDQUJ1Vk5mTGRRUHo1?=
 =?utf-8?B?U2JwL1g1OUlsWWpCS0dSUmhqWnJwZjU1ZURsOW5SQjVNa25lMTROeVgyY1dw?=
 =?utf-8?B?V1dxa0k5czRzRlBzVG5iUEduWDNIUHpHR0t5SWZnMjVYdmhObFAvcWthbkN1?=
 =?utf-8?B?S1NJcUtTZ0ZKeDdZb2R0dmdibkM4Rm5Tc0NkbjZrMnVSeGFpVXY4bmlTMllL?=
 =?utf-8?B?VU02T0dBNmhpUnE3WTlpRlhncHhkUWtCSVRBamFnOVNCOHVReCtzYzFHbEU4?=
 =?utf-8?B?L2xaVHZzY1QzNTFyTlJZMjdWOFU2dUUvN25jamRVVWhiL1FSN0R1aTVBaU9T?=
 =?utf-8?B?VEd4SHp6UnhzelVFdGE1aVdQV01VNDdGWHlIMVNSbWZFTUxpSTZBOU8vcEo1?=
 =?utf-8?B?SnBxTmRqaWtsdFRrcU4rU1ovL1dBSnUxS3E1ZDRvZzJORDFTNDBRRzE3OFBT?=
 =?utf-8?B?YzVaVWJ6bm5jbUtPcUFpd2QzOHlsOWdESWJyRHNVWlc5L2VqMFdjS3dFT3B5?=
 =?utf-8?B?YXVZWnk2Y2ZFUEhjU1FZTS9UbGpWdE5sK2hRdTNkdEplRWJSd2JlVFMvNnJD?=
 =?utf-8?Q?TV65Ibb5gzkBAEyLfbQMEPeTC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37112593-224d-4c33-e5f1-08db29eb3bca
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 09:04:09.9638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jCEl4RGQIzZBDtWREj95mBhxUBhE5u3onLgBZEZ7l8eSpD1WoFEgWCbSpWSTRHVUJmJXbGjbwWLQ07qJBZWmnKLl+ziXvCETa4QEdSrEh5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10331
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjMgMy81XSB0dHk6IHNlcmlhbDogc2gtc2NpOiBGaXggVHggb24gU0NJIElQDQo+IA0K
PiBIaSBCaWp1LA0KPiANCj4gT24gTW9uLCBNYXIgMjAsIDIwMjMgYXQgMTE6NTPigK9BTSBCaWp1
IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+IHdyb3RlOg0KPiA+IEZvciBTQ0ks
IHRoZSBURSAodHJhbnNtaXQgZW5hYmxlKSBtdXN0IGJlIHNldCBhZnRlciBzZXR0aW5nIFRJRQ0K
PiA+ICh0cmFuc21pdCBpbnRlcnJ1cHQgZW5hYmxlKSBvciBpbiB0aGUgc2FtZSBpbnN0cnVjdGlv
biB0byBzdGFydCB0aGUNCj4gdHJhbnNtaXNzaW9uLg0KPiA+IFNldCBURSBiaXQgaW4gc2NpX3N0
YXJ0X3R4KCkgaW5zdGVhZCBvZiBzZXRfdGVybWlvcygpIGZvciBTQ0kgYW5kDQo+ID4gY2xlYXIg
VEUgYml0LCBpZiBjaXJjdWxhciBidWZmZXIgaXMgZW1wdHkgaW4gc2NpX3RyYW5zbWl0X2NoYXJz
KCkuDQo+ID4NCj4gPiBGaXhlczogZjlhMmFkY2M5ZTkwICgiYXJtNjQ6IGR0czogcmVuZXNhczog
cjlhMDdnMDQ0OiBBZGQgU0NJWzAtMV0NCj4gPiBub2RlcyIpDQo+IA0KPiBUaGF0J3MgYSBEVFMg
cGF0Y2g/DQo+IA0KPiBJJ20gd29uZGVyaW5nIGlmIHRoaXMgZ290IGJyb2tlbiBhY2NpZGVudGFs
bHkgYnkgY29tbWl0IDkzYmNlZmQ0YzZiYWQ0YzYNCj4gKCJzZXJpYWw6IHNoLXNjaTogRml4IHNl
dHRpbmcgU0NTQ1JfVElFIHdoaWxlIHRyYW5zZmVycmluZyBkYXRhIiksIHdoaWNoIHdhcw0KPiBw
cm9iYWJseSBuZXZlciB0ZXN0ZWQgb24gU0NJLg0KDQpMb29rcyBsaWtlIHRoYXQgcGF0Y2ggaXMg
bm90IHRlc3RlZCBvbiBTQ0kuIE9LLCB3aWxsIHVzZSB0aGUgYWJvdmUgY29tbWl0DQphcyBGaXhl
cyB0YWcuDQoNCkNoZWVycywNCkJpanUNCg0KPiANCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZw0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2Fz
LmNvbT4NCj4gPiAtLS0NCj4gPiB2MzoNCj4gPiAgKiBOZXcgcGF0Y2gNCj4gPiAtLS0NCj4gPiAg
ZHJpdmVycy90dHkvc2VyaWFsL3NoLXNjaS5jIHwgMjUgKysrKysrKysrKysrKysrKysrKysrKyst
LQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3R0eS9zZXJpYWwvc2gtc2NpLmMgYi9kcml2
ZXJzL3R0eS9zZXJpYWwvc2gtc2NpLmMNCj4gPiBpbmRleCBiOWNkMjc0NTFmOTAuLjkwNzlhOGVh
OTEzMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3R0eS9zZXJpYWwvc2gtc2NpLmMNCj4gPiAr
KysgYi9kcml2ZXJzL3R0eS9zZXJpYWwvc2gtc2NpLmMNCj4gPiBAQCAtNTk3LDYgKzU5NywxNSBA
QCBzdGF0aWMgdm9pZCBzY2lfc3RhcnRfdHgoc3RydWN0IHVhcnRfcG9ydCAqcG9ydCkNCj4gPiAg
ICAgICAgIGlmICghcy0+Y2hhbl90eCB8fCBwb3J0LT50eXBlID09IFBPUlRfU0NJRkEgfHwgcG9y
dC0+dHlwZSA9PQ0KPiBQT1JUX1NDSUZCKSB7DQo+ID4gICAgICAgICAgICAgICAgIC8qIFNldCBU
SUUgKFRyYW5zbWl0IEludGVycnVwdCBFbmFibGUpIGJpdCBpbiBTQ1NDUiAqLw0KPiA+ICAgICAg
ICAgICAgICAgICBjdHJsID0gc2VyaWFsX3BvcnRfaW4ocG9ydCwgU0NTQ1IpOw0KPiA+ICsNCj4g
PiArICAgICAgICAgICAgICAgLyoNCj4gPiArICAgICAgICAgICAgICAgICogRm9yIFNDSSwgVEUg
KHRyYW5zbWl0IGVuYWJsZSkgbXVzdCBiZSBzZXQgYWZ0ZXIgc2V0dGluZw0KPiBUSUUNCj4gPiAr
ICAgICAgICAgICAgICAgICogKHRyYW5zbWl0IGludGVycnVwdCBlbmFibGUpIG9yIGluIHRoZSBz
YW1lIGluc3RydWN0aW9uDQo+IHRvIHN0YXJ0DQo+ID4gKyAgICAgICAgICAgICAgICAqIHRoZSB0
cmFuc21pdCBwcm9jZXNzLg0KPiA+ICsgICAgICAgICAgICAgICAgKi8NCj4gPiArICAgICAgICAg
ICAgICAgaWYgKHBvcnQtPnR5cGUgPT0gUE9SVF9TQ0kpDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgY3RybCB8PSBTQ1NDUl9URTsNCj4gPiArDQo+ID4gICAgICAgICAgICAgICAgIHNlcmlh
bF9wb3J0X291dChwb3J0LCBTQ1NDUiwgY3RybCB8IFNDU0NSX1RJRSk7DQo+ID4gICAgICAgICB9
DQo+ID4gIH0NCj4gPiBAQCAtODM1LDYgKzg0NCwxMiBAQCBzdGF0aWMgdm9pZCBzY2lfdHJhbnNt
aXRfY2hhcnMoc3RydWN0IHVhcnRfcG9ydA0KPiAqcG9ydCkNCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICBjID0geG1pdC0+YnVmW3htaXQtPnRhaWxdOw0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgIHhtaXQtPnRhaWwgPSAoeG1pdC0+dGFpbCArIDEpICYgKFVBUlRfWE1JVF9TSVpFIC0N
Cj4gMSk7DQo+ID4gICAgICAgICAgICAgICAgIH0gZWxzZSB7DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgaWYgKHBvcnQtPnR5cGUgPT0gUE9SVF9TQ0kpIHsNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGN0cmwgPSBzZXJpYWxfcG9ydF9pbihwb3J0LCBTQ1NDUik7DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjdHJsICY9IH5TQ1NDUl9URTsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNlcmlhbF9wb3J0X291dChwb3J0LCBT
Q1NDUiwgY3RybCk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm47
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgICB9DQo+ID4NCj4gPiBAQCAtMjU4MSw4ICsy
NTk2LDE0IEBAIHN0YXRpYyB2b2lkIHNjaV9zZXRfdGVybWlvcyhzdHJ1Y3QgdWFydF9wb3J0ICpw
b3J0LA0KPiBzdHJ1Y3Qga3Rlcm1pb3MgKnRlcm1pb3MsDQo+ID4gICAgICAgICAgICAgICAgIHNj
aV9zZXRfbWN0cmwocG9ydCwgcG9ydC0+bWN0cmwpOw0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4g
LSAgICAgICBzY3JfdmFsIHw9IFNDU0NSX1JFIHwgU0NTQ1JfVEUgfA0KPiA+IC0gICAgICAgICAg
ICAgICAgICAocy0+Y2ZnLT5zY3NjciAmIH4oU0NTQ1JfQ0tFMSB8IFNDU0NSX0NLRTApKTsNCj4g
PiArICAgICAgIC8qDQo+ID4gKyAgICAgICAgKiBGb3IgU0NJLCBURSAodHJhbnNtaXQgZW5hYmxl
KSBtdXN0IGJlIHNldCBhZnRlciBzZXR0aW5nIFRJRQ0KPiA+ICsgICAgICAgICogKHRyYW5zbWl0
IGludGVycnVwdCBlbmFibGUpIG9yIGluIHRoZSBzYW1lIGluc3RydWN0aW9uIHRvDQo+ID4gKyAg
ICAgICAgKiBzdGFydCB0aGUgdHJhbnNtaXR0aW5nIHByb2Nlc3MuIFNvIHNraXAgc2V0dGluZyBU
RSBoZXJlIGZvcg0KPiBTQ0kuDQo+ID4gKyAgICAgICAgKi8NCj4gPiArICAgICAgIGlmIChwb3J0
LT50eXBlICE9IFBPUlRfU0NJKQ0KPiA+ICsgICAgICAgICAgICAgICBzY3JfdmFsIHw9IFNDU0NS
X1RFOw0KPiA+ICsgICAgICAgc2NyX3ZhbCB8PSBTQ1NDUl9SRSB8IChzLT5jZmctPnNjc2NyICYg
fihTQ1NDUl9DS0UxIHwNCj4gPiArIFNDU0NSX0NLRTApKTsNCj4gPiAgICAgICAgIHNlcmlhbF9w
b3J0X291dChwb3J0LCBTQ1NDUiwgc2NyX3ZhbCB8IHMtPmhzY2lmX3RvdCk7DQo+ID4gICAgICAg
ICBpZiAoKHNyciArIDEgPT0gNSkgJiYNCj4gPiAgICAgICAgICAgICAocG9ydC0+dHlwZSA9PSBQ
T1JUX1NDSUZBIHx8IHBvcnQtPnR5cGUgPT0gUE9SVF9TQ0lGQikpIHsNCj4gDQo+IEdye29ldGpl
LGVldGluZ31zLA0KPiANCj4gICAgICAgICAgICAgICAgICAgICAgICAgR2VlcnQNCj4gDQo+IC0t
DQo+IEdlZXJ0IFV5dHRlcmhvZXZlbiAtLSBUaGVyZSdzIGxvdHMgb2YgTGludXggYmV5b25kIGlh
MzIgLS0gZ2VlcnRAbGludXgtDQo+IG02OGsub3JnDQo+IA0KPiBJbiBwZXJzb25hbCBjb252ZXJz
YXRpb25zIHdpdGggdGVjaG5pY2FsIHBlb3BsZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4gQnV0
DQo+IHdoZW4gSSdtIHRhbGtpbmcgdG8gam91cm5hbGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1l
ciIgb3Igc29tZXRoaW5nIGxpa2UNCj4gdGhhdC4NCj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAtLSBMaW51cyBUb3J2YWxkcw0K
