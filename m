Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21D047685A
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 03:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhLPCyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 21:54:21 -0500
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:21378
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230252AbhLPCyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 21:54:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bx4gEg1BJIuSZLGymj3ZRYHNDe3mR/A5BKnXZpvy/HlqbJzQLugwC956oO7RQ6IZOhbiuLVlFYZwRYsxMKTr28UjORi6GNytxUJVuZY15Xxt3t8l1Tnr/J/v7p0AnIzB+EZgbhWh9/kRz047OE/5t325q2ptnmBy2LEj44rnDYbtVaiuMqWty5aAR6tn7ueDtNOH8OjQ73tA8SKMr3gy/15QhsZs7QDjsrabV6qW4Zz6SMqdf5dQ7MgjdRCTKpCK2uw3gRrEXSFSO2oIZp/ipA8jU2mIGUuQ/yxBb1qdXs3Ug3VXYWKWSj7GqJUiMqmMHQBftIKkaFunYP2LGqi0ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rk/fPi3zNB51SnJ/FKKjlUNAWi3cC4aua1iZg3LjZ8s=;
 b=TAgBXHKBuIesocEPvU6GZ7GpbcgdJG8dgKMwUWM7OpqHUAh1pUMX5DBW4Q0faNdoS89u2zRAZa1qS8XYvkFjOVMPvz8BGhr722gskqYJtlgTfM/z4mI1lBR8ZZPAXt1wF/peatDkK8GaRrW/gCs5aVQLqpAWxYKEC14EbODCuDrEkmrFVpfPet3IG/4s3bt8rlR5gFkP4cdwDcsFCKnZQKsgiDOAEBQz1eSyALNYwX0cN7m6Tr5QxTg4Qp9ethC0oIRYEJNZjW57+RxoWhLlzTJgNsdm44NsfnzhMNOLsiIwHVpPgWa4LGtgOZ9EWKED4v+c2VqblxiaInmDV1IHQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk/fPi3zNB51SnJ/FKKjlUNAWi3cC4aua1iZg3LjZ8s=;
 b=DE9Og3+iFzYQtOPlqKCtUxzJb7OCMpJk/VACm+2OpuVzxEY0WW6TKDMB3xxABnP8G8FWI7OHG0T08TshkrMU6moZNmQg7d6rj/UDugeT8wa5UFTZuIjDAqGWzh20TIdaiH0pZfdCn6oUTZh8Nynuz/+gkGRnEWrSOzKGNqNHllA=
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by DU0PR04MB9273.eurprd04.prod.outlook.com (2603:10a6:10:354::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 02:54:19 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 02:54:19 +0000
From:   Aisheng Dong <aisheng.dong@nxp.com>
To:     David Hildenbrand <david@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Jason Liu <jason.hui.liu@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Abel Vesa <abel.vesa@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "lecopzer.chen@mediatek.com" <lecopzer.chen@mediatek.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shijie Qin <shijie.qin@nxp.com>
Subject: RE: [PATCH 1/2] mm: cma: fix allocation may fail sometimes
Thread-Topic: [PATCH 1/2] mm: cma: fix allocation may fail sometimes
Thread-Index: AQHX8YpPLY06ZVezCkulrdtZ3OawN6wzfB0AgADtyGA=
Date:   Thu, 16 Dec 2021 02:54:18 +0000
Message-ID: <DB9PR04MB84777DDC63F5D2D995F7F5E980779@DB9PR04MB8477.eurprd04.prod.outlook.com>
References: <20211215080242.3034856-1-aisheng.dong@nxp.com>
 <20211215080242.3034856-2-aisheng.dong@nxp.com>
 <783f64f5-3a55-6c42-a740-19a12c2c7321@redhat.com>
In-Reply-To: <783f64f5-3a55-6c42-a740-19a12c2c7321@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65dc7815-dd17-45b7-797d-08d9c03f5af1
x-ms-traffictypediagnostic: DU0PR04MB9273:EE_
x-microsoft-antispam-prvs: <DU0PR04MB9273084934E808B66D5C4A4C80779@DU0PR04MB9273.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ejBSupGnIX79zO6BOPtoP1KO4FlSiz6X/zIflR4yEqWLPbOQfZnUsfR+n36j/JsMuGHT9as+/Yn+FDzvxZrqrcUGJFXvth++tAI4ggI3qeGGoGPnay1x+W3Y2dF/NzZA9MPuvq88Ev9k2tyqr1sE4rSMoMVGRMfbF0xEWO/7pCViKgNvaY5t2CYnnIcr7WQGZRGleViN8+dHCJsaeeqG8ReDxT4LyE0j0lDyG/MiWwaZWjk2XNfOmxeop//Ou1It8qSeK972uVjoa9rtM9zPBYeOW1bLn1dsAC5nGwCaZQ5w/TFdpLf1Wk/LFKZytzclEAVzqkvnaPty6sHLSYOg/BrUTSC+S0J4Odd32Uily3hy1BQKRSqztPGJB3iMDQ1sNHXTv7LpmbhReT/MPfxs/9+f+9guWFq4VJr/2puyWpybLKzu8xX0IVbmQVrkvXjImOSBYSrotl1rAD9AUp48dUlBeCfgYpw+96c7C6zJyf9MBVdwAbPuO79SeEp7TNC+o1xp1nrizhEbgTXGFrIl1I1FnklbxcMx/cvBe4RFldbxNm3TYIgkEE4NexTx+26YXhAVf6VB6gxekYNNLlZgzA4s6MUIL+DrJwGqI+TNhScnJcbqck46/hJjuLo6Gloqv60wp2JoS8MORblIyPA3PF6JoS8lE3yhfBr5OBy22yGp1jxa7OK8+9OFq+6Jt3GSSbo2pf6Tm6qMvXk8FWxMrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(66946007)(508600001)(66476007)(44832011)(76116006)(5660300002)(86362001)(71200400001)(66556008)(66446008)(26005)(38100700002)(122000001)(9686003)(316002)(186003)(55016003)(8936002)(54906003)(7416002)(53546011)(83380400001)(38070700005)(2906002)(64756008)(110136005)(33656002)(4326008)(7696005)(8676002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVVEUmI1OWxwczh6NFYwQlI4d3M4aTh6OEE4dGhNYTY1ckNKRjFvRW9mcnoy?=
 =?utf-8?B?M3czVEx5REh2aVZxcTg1bVFDcDEzZ25SSkcwSlBlbUg5TDcxWk1LQ1AwQkw5?=
 =?utf-8?B?Z28rUTl5TlU1cU4zdGpDYlBxaE42bGY5UVZJZmdvTWJlMGFVMW9SaitqWW5D?=
 =?utf-8?B?TDJZVmw5a0k2RWFKUzA0SGE1TlV6d0lDUm1CSnVZV2QrTzN5cDdrOC9TM2ZL?=
 =?utf-8?B?ckNFcUVCUmoydXZLTTkyMlFPWDRjMDRVK0Z6MDJ4OC8wK21IMnQyWkJBRmN4?=
 =?utf-8?B?d3BvMm9jWWFoRFE3bWxwclJlT1I5RGNkV3FaamZtQXl2azlYdUx3RGd3bHV5?=
 =?utf-8?B?Y1U4dWhOZFJUbkdGcEI4OEZmaFdEckk2bDNRNWlSUWJ5RGNmQnRWV011dU9E?=
 =?utf-8?B?ZkNhWlBDd205eURMeDBBQytLTG9wR1NxSlRjbHRDZmxvL0pmT0dPSE1qTXVN?=
 =?utf-8?B?cWt3YTJlU3piRW8wTTB6ZkQ5OWJ4cWVqYU80b0xicEJnUkFlNlRERmN5dGM1?=
 =?utf-8?B?ZVo0b09HN0lCTmUvL080SldKdUtvNElXVWVLOGNNaUFySUgrYTRMdEgvZDVV?=
 =?utf-8?B?bGV6ZHdQWHBLdzRuZnZ6a1BEVUJISGkwanNNSngvbm1ZRW1HcHFSMmw0bllP?=
 =?utf-8?B?ZkdyMVFkNnRJbloyYUgxSXlVbzZPaXhkS2NDTjZKVGtJN3Q2MkU2a213K3ZY?=
 =?utf-8?B?c1krUlUxQ0FxSitKRlZrdmdIb0JWa1Z1Q2hGMDFSUTBYSHRyU1BLU0xYSWo1?=
 =?utf-8?B?YnFRQ2hiVU53WXBqN2duUVBlSzludnBoQ2hqalFOb1RkV3UvTHBoKzJHcjhG?=
 =?utf-8?B?bUU4TWh2Y3R1UXdjYVVmN0JYTGFWQnE3YnExZTVCVFQza0ZnaXRtTEFxU2dI?=
 =?utf-8?B?Wk1rTVN3TG9CaFNadyswQnpYb2dtMUhZV1RWenl5MXNFUlQ5QisxbklINlhn?=
 =?utf-8?B?YWxNSXF6MFhJL3V6anZIU3ZqRnB0UXhnWm52Qm9TRHBrV0xUTU1xTG9KdElN?=
 =?utf-8?B?M01naXBKUzlVUXdpUGszOEMwR2ZSVlgyNEZDWE5CWGtoVHdzYXZMU091TnYy?=
 =?utf-8?B?TGJZdU5UMXpvd1VmV3hLMngzdmVRMkRnNGdjVVkxT2tJdmVwR3FzbEp4K2xB?=
 =?utf-8?B?UGNlTTd0MWRGYS9NbXcwU1JEQVBpYUl4Z2lpRStVVTBQTFJyclFQUE96Vk1Y?=
 =?utf-8?B?ZWppeEhxQ0RBaTR2dmdjbExJUUhFZjA1YVI5SlJWQUdzenl4dERlRnNGWTdr?=
 =?utf-8?B?T3pvREYxY0JWa0pTaUg0UFUrYnhDZ2NRaFFZbHhra0pBcW1VeFZQdm1BWkg0?=
 =?utf-8?B?elJqWUYzVEV6M1JvYVN3a0RvbXVEMURiWVBkbTVjZy9UcHdDNVFIRjRnTWFN?=
 =?utf-8?B?UTV2MlMwVkU1QTdYdVhaMXlNUGxPWEJqSU1UV3VuKy9KNnQrb0xXbWxrU1Zy?=
 =?utf-8?B?NUdRT1pnOTVHUk4ybmsvYUFjNEljSnVJbGFibWNEZyttQzBhM3hpRTFSbkJM?=
 =?utf-8?B?ZVgxQUFQMFhodkEzRkExUDcvRmZTMnE0dlFUTFYwcWI1eWhIZHl2Mkw1V0sy?=
 =?utf-8?B?c3hvelV1NER4UjEvQXFCeW04L2ZjWER2dWtFYlhJVDFKeml3OFV5TjY2L242?=
 =?utf-8?B?alF1ZHBaTXdmMFZXZmk2VGFLK0lCanlCRnFtQThYNHpjRkM4NkF3MVB4RTBz?=
 =?utf-8?B?dkJHMTA5VDNWOUU4VHVaSlB3aSt2d0VpMVpod2xQNSttL2kydnVDZll6VnNN?=
 =?utf-8?B?UEZOMDFzY3FCSThOWTh0Uk44NVdXVVpPVUxkanRMUGpiM2hWZURmVFVCTmlj?=
 =?utf-8?B?SlJuRUtUeE5LbjJmelEvbjZnZTZTeXREWC90VFdwb2lyWjE0VVoyRllBSXJB?=
 =?utf-8?B?ZDFSRU81ZjA3czRIejFsdEM4RUZVVkgvTDlLcnlUK0E1T3g5Wld4aTBTVktv?=
 =?utf-8?B?cGlVQ3NmZm4yRE9IOWNSLytlbEZQZ0thaGV3NFQ3NXl4OVVaSkJrTU81QWhQ?=
 =?utf-8?B?c0hBdEIvR0psQUR4cGxUNnBrT2lSQkFhZlNmTUhEQ0dFL0wwWDE2azViZGRa?=
 =?utf-8?B?U1hWOWFzVVBUeFIxZXFrbnBFVEd2cUgwdDd1cXpUUFVTUERjVFNTbFk0M0ps?=
 =?utf-8?B?ZmJrbGdsNnFNUUMrcGMrWktXcXVlY2dueCt2N2dRRHVtMDUvWVp6UUxoL253?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65dc7815-dd17-45b7-797d-08d9c03f5af1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 02:54:19.0375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dc7hoj7ISDwNzK5LJLvN+FvnWVPqGa7l79RqelGFcQPmqvvN1yJ4O8xLOgT08RtNvC29arFs6a1VkVrRIsbeNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9273
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4NCj4gU2VudDogV2Vk
bmVzZGF5LCBEZWNlbWJlciAxNSwgMjAyMSA4OjMxIFBNDQo+IA0KPiBPbiAxNS4xMi4yMSAwOTow
MiwgRG9uZyBBaXNoZW5nIHdyb3RlOg0KPiA+IFdlIG1ldCBkbWFfYWxsb2NfY29oZXJlbnQoKSBm
YWlsIHNvbWV0aW1lcyB3aGVuIGRvaW5nIDggVlBVIGRlY29kZXINCj4gPiB0ZXN0IGluIHBhcmFs
bGVsIG9uIGEgTVg2USBTREIgYm9hcmQuDQo+ID4NCj4gPiBFcnJvciBsb2c6DQo+ID4gY21hOiBj
bWFfYWxsb2M6IGxpbnV4LGNtYTogYWxsb2MgZmFpbGVkLCByZXEtc2l6ZTogMTQ4IHBhZ2VzLCBy
ZXQ6IC0xNg0KPiA+IGNtYTogbnVtYmVyIG9mIGF2YWlsYWJsZSBwYWdlczoNCj4gPg0KPiAzQDEy
NSsyMEAxNzIrMTJAMjM2KzRAMzgwKzMyQDczNisxN0AyMjg3KzIzQDI0NzMrMjBAMzYwNw0KPiA2
Kzk5QDQwNDc3KzEwOA0KPiA+IEA0MDg1Mis0NEA0MTEwOCsyMEA0MTE5NisxMDhANDEzNjQrMTA4
QDQxNjIwKw0KPiA+DQo+IDEwOEA0MjkwMCsxMDhANDMxNTYrNDgzQDQ0MDYxKzE3NjNANDUzNDEr
MTQ0MEA0NzcxMisyMEA0OQ0KPiAzMjQrMjBANDkzODgrDQo+ID4gNTA3NkA0OTQ1MisyMzA0QDU1
MDQwKzM1QDU4MTQxKzIwQDU4MjIwKzIwQDU4Mjg0Kw0KPiA+IDcxODhANTgzNDgrODRANjYyMjAr
NzI3NkA2NjQ1MisyMjdANzQ1MjUrNjM3MUA3NTU0OT0+DQo+IDMzMTYxIGZyZWUgb2YNCj4gPiA4
MTkyMCB0b3RhbCBwYWdlcw0KPiA+DQo+ID4gV2hlbiBpc3N1ZSBoYXBwZW5lZCwgd2Ugc2F3IHRo
ZXJlIHdlcmUgc3RpbGwgMzMxNjEgcGFnZXMgKDEyOU0pIGZyZWUNCj4gPiBDTUEgbWVtb3J5IGFu
ZCBhIGxvdCBhdmFpbGFibGUgZnJlZSBzbG90cyBmb3IgMTQ4IHBhZ2VzIGluIENNQSBiaXRtYXAN
Cj4gPiB0aGF0IHdlIHdhbnQgdG8gYWxsb2NhdGUuDQo+ID4NCj4gPiBJZiBkdW1waW5nIG1lbW9y
eSBpbmZvLCB3ZSBmb3VuZCB0aGF0IHRoZXJlIHdhcyBhbHNvIH4zNDJNIG5vcm1hbA0KPiA+IG1l
bW9yeSwgYnV0IG9ubHkgMTM1MksgQ01BIG1lbW9yeSBsZWZ0IGluIGJ1ZGR5IHN5c3RlbSB3aGls
ZSBhIGxvdCBvZg0KPiA+IHBhZ2VibG9ja3Mgd2VyZSBpc29sYXRlZC4NCj4gPg0KPiA+IE1lbW9y
eSBpbmZvIGxvZzoNCj4gPiBOb3JtYWwgZnJlZTozNTEwOTZrQiBtaW46MzAwMDBrQiBsb3c6Mzc1
MDBrQiBoaWdoOjQ1MDAwa0INCj4gcmVzZXJ2ZWRfaGlnaGF0b21pYzowS0INCj4gPiAJICAgIGFj
dGl2ZV9hbm9uOjk4MDYwa0IgaW5hY3RpdmVfYW5vbjo5ODk0OGtCIGFjdGl2ZV9maWxlOjYwODY0
a0INCj4gaW5hY3RpdmVfZmlsZTozMTc3NmtCDQo+ID4gCSAgICB1bmV2aWN0YWJsZTowa0Igd3Jp
dGVwZW5kaW5nOjBrQiBwcmVzZW50OjEwNDg1NzZrQg0KPiBtYW5hZ2VkOjEwMTgzMjhrQiBtbG9j
a2VkOjBrQg0KPiA+IAkgICAgYm91bmNlOjBrQiBmcmVlX3BjcDoyMjBrQiBsb2NhbF9wY3A6MTky
a0IgZnJlZV9jbWE6MTM1MmtCDQo+ID4gbG93bWVtX3Jlc2VydmVbXTogMCAwIDANCj4gPiBOb3Jt
YWw6IDc4KjRrQiAoVUVDSSkgMTc3Mio4a0IgKFVNRUNJKSAxMzM1KjE2a0IgKFVNRUNJKSAzNjAq
MzJrQg0KPiAoVU1FQ0kpIDY1KjY0a0IgKFVNQ0kpDQo+ID4gCTM2KjEyOGtCIChVTUVDSSkgMTYq
MjU2a0IgKFVNQ0kpIDYqNTEya0IgKEVJKSA4KjEwMjRrQiAoVUVJKQ0KPiA0KjIwNDhrQiAoTUkp
IDgqNDA5NmtCIChFSSkNCj4gPiAJOCo4MTkya0IgKFVJKSAzKjE2Mzg0a0IgKEVJKSA4KjMyNzY4
a0IgKE0pID0gNDg5Mjg4a0INCj4gPg0KPiA+IFRoZSByb290IGNhdXNlIG9mIHRoaXMgaXNzdWUg
aXMgdGhhdCBzaW5jZSBjb21taXQgYTRlZmMxNzRiMzgyDQo+ID4gKCJtbS9jbWEuYzogcmVtb3Zl
IHJlZHVuZGFudCBjbWFfbXV0ZXggbG9jayIpLCBDTUEgc3VwcG9ydHMNCj4gY29uY3VycmVudA0K
PiA+IG1lbW9yeSBhbGxvY2F0aW9uLiBJdCdzIHBvc3NpYmxlIHRoYXQgdGhlIHBhZ2VibG9jayBw
cm9jZXNzIEEgdHJ5IHRvDQo+ID4gYWxsb2MgaGFzIGFscmVhZHkgYmVlbiBpc29sYXRlZCBieSB0
aGUgYWxsb2NhdGlvbiBvZiBwcm9jZXNzIEIgZHVyaW5nDQo+ID4gbWVtb3J5IG1pZ3JhdGlvbi4N
Cj4gPg0KPiA+IFdoZW4gdGhlcmUncmUgbXVsdGkgcHJvY2VzcyBhbGxvY2F0aW5nIENNQSBtZW1v
cnkgaW4gcGFyYWxsZWwsIGl0J3MNCj4gPiBsaWtlbHkgdGhhdCBvdGhlciB0aGUgcmVtYWluIHBh
Z2VibG9ja3MgbWF5IGhhdmUgYWxzbyBiZWVuIGlzb2xhdGVkLA0KPiA+IHRoZW4gQ01BIGFsbG9j
IGZhaWwgZmluYWxseSBkdXJpbmcgdGhlIGZpcnN0IHJvdW5kIG9mIHNjYW5uaW5nIG9mIHRoZQ0K
PiA+IHdob2xlIGF2YWlsYWJsZSBDTUEgYml0bWFwLg0KPiANCj4gSSBhbHJlYWR5IHJhaXNlZCBp
biBkaWZmZXJlbnQgY29udGV4dCB0aGF0IHdlIHNob3VsZCBtb3N0IHByb2JhYmx5IGNvbnZlcnQg
dGhhdA0KPiAtRUJVU1kgdG8gLUVBR0FJTiAtLSAgdG8gZGlmZmVyZW50aWF0ZSBhbiBhY3R1YWwg
bWlncmF0aW9uIHByb2JsZW0gZnJvbSBhDQo+IHNpbXBsZSAiY29uY3VycmVudCBhbGxvY2F0aW9u
cyB0aGF0IHRhcmdldCB0aGUgc2FtZSBNQVhfT1JERVIgLTEgcmFuZ2UiLg0KPiANCg0KVGhhbmtz
IGZvciB0aGUgaW5mby4gSXMgdGhlcmUgYSBwYXRjaCB1bmRlciByZXZpZXc/DQpCVFcgaSB3b25k
ZXIgdGhhdCBwcm9iYWJseSBtYWtlcyBubyBtdWNoIGRpZmZlcmVuY2UgZm9yIG15IHBhdGNoIHNp
bmNlIHdlIG1heQ0KcHJlZmVyIHJldHJ5IHRoZSBuZXh0IHBhZ2VibG9jayByYXRoZXIgdGhhbiBi
dXN5IHdhaXRpbmcgb24gdGhlIHNhbWUgaXNvbGF0ZWQgcGFnZWJsb2NrLg0KT3RoZXJ3aXNlLCB3
ZSBtYXkgbWVldCB0aGUgc2FtZSBpc3N1ZSBhcyB0aGUgcGF0Y2ggMi8yIHdhbnRzIHRvIGFkZHJl
c3MuDQoNCkhvdyBkbyB5b3UgdGhpbms/DQoNClJlZ2FyZHMNCkFpc2hlbmcNCg0KPiANCj4gLS0N
Cj4gVGhhbmtzLA0KPiANCj4gRGF2aWQgLyBkaGlsZGVuYg0KDQo=
