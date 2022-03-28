Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EA34E92F4
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240453AbiC1LDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240452AbiC1LDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:03:10 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2060.outbound.protection.outlook.com [40.107.113.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004EA5521E;
        Mon, 28 Mar 2022 04:01:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WumX59JMCEhtaaEjpAk1uDeqZHGbgYce/Jt5eGg4YOv7OoWBib+oNESRu35BZrNxHS5TqDTjy5TD8QFR34zLczDyK+j8MXc8dkSofIVvE0xa/Y/0xaTfX6AbA9ospQJ8BuTMWWRqQI+WAXO+SCfMjpraraD4hIOkI6RYzf5A2ML3g5XOALTY6okcWZd6EmxcNL9ItbR8UoRL0A0I8JAiTH5hvA+Qg2BQ9o9kl+bSlUdIp8Rw1+Ur8xKARZUHzt/7bqWgtkfC64F8s0kv/Upkrt3nB5P0dvtF451GS+IFcX21fyjbX8MdeRRVDTxawV/nNK2DpaNgt0ojFHMTMm4WZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hwhwQaLWpgSSV1z6iy7+34RqnyOxrHOOJb3tWjrfzE=;
 b=LkAtQEF0i3YdEm9YQY8i/xBoEBEKG6KF5tzpl16opP6tnZDt2u3RcfHYOAuvTfR6s8pw6b4Apzf4CuJjMgqeENqWDa6+jalo2f2HHsNsy+/9s5gaASuLxbdLx0Ww6ILzkftMUd0K2ClXMlmGJ1V+AL5uWavN3iS2PY+s7vkV8FAsV0vxtCoCksdO8+ayjzlbvj8fJc+9/H91w6AjRXD6aOAAisYJX2tio+LZWRguZ4BiFQsgVZdZp4HCUXW+yDCLk5T0kHKwZb6hP/LkEhL6VME+80LKjXce0xAI1GLp2j9nScJQaQBvrSRRKYtDeg+yVGk7aD3p+Ghu8BysLlMEeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hwhwQaLWpgSSV1z6iy7+34RqnyOxrHOOJb3tWjrfzE=;
 b=YYhdKcAGDgRSHOBzQEbmsc1m/GkddtS1jf5FDLi7sOAScXXaXHlEF6dxjS15DztYE+3YnHf5J2BNvBk9aEo80bNfThyY51QSDkzsD3BmMFKJ/p2wPkChG85NuDLyvZJo2sb/Zly7dMzt6+2jlGW/eQtPaqb8SRJgeRhdGg5jHSU=
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com (2603:1096:400:13c::10)
 by TYYPR01MB6666.jpnprd01.prod.outlook.com (2603:1096:400:e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Mon, 28 Mar
 2022 11:01:26 +0000
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::cdeb:f61:5132:905d]) by TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::cdeb:f61:5132:905d%8]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 11:01:25 +0000
From:   =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPo+OAgOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>
To:     Rik van Riel <riel@surriel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm,hwpoison: unmap poisoned page before invalidation
Thread-Topic: [PATCH] mm,hwpoison: unmap poisoned page before invalidation
Thread-Index: AQHYQIT9LB1AymBaSEOrZ39xevSI16zUpUcA
Date:   Mon, 28 Mar 2022 11:01:25 +0000
Message-ID: <20220328110122.GA414586@hori.linux.bs1.fc.nec.co.jp>
References: <20220325161428.5068d97e@imladris.surriel.com>
In-Reply-To: <20220325161428.5068d97e@imladris.surriel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nec.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfd1155c-4c75-4a98-6cfe-08da10aa4d74
x-ms-traffictypediagnostic: TYYPR01MB6666:EE_
x-microsoft-antispam-prvs: <TYYPR01MB6666DAC3004E832508D68DD8E71D9@TYYPR01MB6666.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Og/1N8JTw4SuVr8AqVlXD6oux+XjXfKd8V3P2+z6dTiOyC8yUMIjhvxeb27qHHdq4RrEZ82ALZFXLvkmh29Fyhh8aFxUyqdj+5sA7xUBbWzIRsXUsVuKHHKucmgOkooevkIrTm/eF5dMCN46ilWE030+Wmzr3CxpWULCxNHOgMuzifcPvWDcNHvQCSpdB6+1Hy9oZYd6FBmE8Hu/rYuFIvucgT7xM8ywjGPPuY8FP6x3f1u3h44TUcJWloIA8If+b+FM8saCHeoI/mbnRKlWMROzMIIicqtLyhTLyZocH5elWE/htucz31FyAwlbWG24eQQJWz2cPfZxzjUhiD8SW6+1bL4hxtSAj5ftX7f6Tgc0q/kd4cHrse6LgZZM47t0fht4TGHEigrLX/atcMN7cvq0xuHDuKW+6zI8cKVx2PW8HNE6/70A4qd89hKaL1YkspthYZ3Rqd4QG7OO74ZozIWfyQD2+Jz4vSgXQnRXU6Vfeo9gt3eLmFHOeWc3Azl8WGsTaTRdPTvhB+kq0id3g2tTPc86pwaqhaY82cs7m/JOPGNU/4rSa7Fwr2Hy1d3P1+MIHK7h50KwbXOoSBmJJr6bfuS1ED1p8khHefW95uGT1+SeUBxF6nDhsC2YmuKZS9eIGsUZL3WMS9jlWIhh/GXkE9ZTw2XOYo1h7VhuT7as0h9R15PorJpxPaIaMOGAmR/ArtYZYGGfDJ6WjzCjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB8591.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(66476007)(8676002)(66946007)(38100700002)(66446008)(86362001)(76116006)(82960400001)(54906003)(122000001)(6916009)(508600001)(33656002)(316002)(38070700005)(4326008)(7416002)(71200400001)(66556008)(55236004)(6486002)(8936002)(6506007)(9686003)(6512007)(1076003)(5660300002)(83380400001)(2906002)(26005)(186003)(85182001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlNXZXFLY1hRWGNaMG12MEhORGNnRE5YcUZLdzR5Ni9wa0NiYkhSUGRzTW16?=
 =?utf-8?B?ZTIrcmNob0NrMmNDbmdJMnNIaU13WHRPU0c0SU50MHZwNzFCeWE2U2VTZ0pC?=
 =?utf-8?B?YjhmbFlFVE5PZEpEcXljNDB1a0trdUxxWGFPWDIwclN3OHdYT0FkVzhQc3dG?=
 =?utf-8?B?bzFqdk5lazNwRG5pcjBXT2p5NHpaV0FKME5ocDlIWGVKK0FSSWluanh3UkFT?=
 =?utf-8?B?cDlqTE96bnpoWmpkMzRRdXZXdjRNelZBT3VTbndyU29SaE5wdWtqOGZ4RnJR?=
 =?utf-8?B?K01CS0tVTHhUUWY4N0djL2dyNTBrQndCekhWNTErcDVRb3E1UkZjdVg1dHJz?=
 =?utf-8?B?S3BFdFFmbVB1TzQyKytab0dpOWRLOG92VU1Ld2FJamt5ZWFKRW04clBsSDM3?=
 =?utf-8?B?VDJXTHJmdUlTNW16b2Q0RkNoYnl6QWFsRmlFcFRtMVoyWFhqZmpSSEFtSlRq?=
 =?utf-8?B?a2djMFE1cm1wK3A4MTNKb05Va3dmM3B2VXVIRTcxS0dUZHJYOEwvdFBSYnB3?=
 =?utf-8?B?VHZLQ1VPN2I1bVJTNzk1N0Y3Q1NhUDZlRmxrUW1QSS96dk5XZzUweFdYU2FY?=
 =?utf-8?B?enhDOUFVV3BOMnNFUzlqMnRDc3F0WVliUmdHTmZKbFdNRUlUakJKT2NHOTBP?=
 =?utf-8?B?OVZ3SzB1U2x0MVlxTjdlYk5NNVhUQzNZRTBkT3Jhb1Uxa0tvb0tYT3I0Mmwr?=
 =?utf-8?B?TkwrZEFHdUt1ekkwZVI1R0lBallYajZiTTlOWWpBdTVRUW5xRmFTb3Z5ZW9j?=
 =?utf-8?B?U1hBUVdxMVRCa0NHWXY1TTNlNzYydy9VYnp2Mjd3RVhkVFgrM05SOUFIbTZO?=
 =?utf-8?B?SDQrZG95OXNGWGlUWmFyYjFTRGcwNFlXSzlQbUpXMVVOZjVGOHhuVWw4ZkNw?=
 =?utf-8?B?RUR6MEkzQ1hSVnp5bFQxSDZ6QzJiY3JNVDdrdEc1bzRNMFQ4Q1FDakV1cmky?=
 =?utf-8?B?eW9XZXFEN3kxQSt3TG5vbk5JeVExU3NtVEZ2bVdLM2JxZXJyUFJSOGF2VGIr?=
 =?utf-8?B?a1hJUXBWVnZibURIdmg2V25EOHlwaGpvdjFZNi8wWlgvd0MxdXl4dGJwZFhV?=
 =?utf-8?B?ejczUTVZWFpJeTRiN1VIV1NIcjN0OG1xaWdUci9VTm1qNnBMZmFYMEhGSlcx?=
 =?utf-8?B?d2pNeW0xN084aEoyYmpua2Q3Yitabm56QTZFZmRVYm1xSWt4eUd1eHAxdlBU?=
 =?utf-8?B?OUpncm1BSnBTemI1SDU4K0dYZ1hyaVcxcDVBa1ZqTUJqLzdxMm1wYmxyV1Zt?=
 =?utf-8?B?SUpLdW85MVBnRGlXMm1RM0tWM0cyMFFrYVlrci84UzE2ejRkY2RLekhyMlFQ?=
 =?utf-8?B?MWhma3BDSlRUSkdGS3BRQUZienpGYXdNclhmTXV6QWlhZS9jMW1FYkJ1Y2to?=
 =?utf-8?B?YnpyOWJBanFJdGZsVDlaTkFiaFNNSkJNZ3BWRktoa29KREEzUzFpemF4eEE3?=
 =?utf-8?B?cm4yUUFIZWZCU1pMYVlyL1JFdGw3djJxemtSQS9OSmliV0VPS3FuNzg0TXFn?=
 =?utf-8?B?bzRFY0JNN1dKMnFKTnlKb3N4STRlc3BUYlJKN3lkdlVXVWN4alBqdDMrZ0Vn?=
 =?utf-8?B?c0lmcVZzVnVSZFFkSlVveGR1M3kwckU3cEpLMkxydkp4NEVTMDFtQWh0Nldo?=
 =?utf-8?B?MGdFcjNPOWFzTVllbXNCa1RCVHhEbFp4N2ppamhXNnhtdllITmNlNzVScXpy?=
 =?utf-8?B?OTBhUUZQcDM5Nnhac3puYkRUNTcxZUg4ZDNLTitScVJNQWdyVVVqZXA2b2xa?=
 =?utf-8?B?RkJaa2FWc09Dd2lPUnE5QVpWN3NWeE1KWlJCRndOQnZpWjVjNnFRWjR6NTBK?=
 =?utf-8?B?NUkvR0FRajhsQjg2NVkwd1liQ1duY3JVYUV6Y0JCUHJsV2hGbmxMeE95V2hF?=
 =?utf-8?B?OTlpSGxiUHRjRGFQUVlnTVhsVktGWnZvSTlPazhtTUtSUlFzSW0rc0EzcEMz?=
 =?utf-8?B?NzFtaUx2RERpTkNaeGVkNEorbTJSOVdTT0N3QnBTRk5OQ1ZmSXBkOWhQZTM0?=
 =?utf-8?B?R0p1bGR2TElhQzNmRWY5RUFFVDBqckd6VHBQVGdMV1FWcmRjY3RQWGxSVFdM?=
 =?utf-8?B?cDk1TWZQYWduelJibzlONzNZVmpvM1BqaE82V3FFNkFEUmZXd2lPa05pR1l6?=
 =?utf-8?B?V3UxRjVMVW9taXJyQjd3cXFCYS90WU1TeXl4cWszazRzTXVpS3NaSmlJQTMz?=
 =?utf-8?B?bmM5ZXdiNFFCWVRqQjBTWDRPT2pSL0wwK3orQ1hsalJEc0o1THBpQjIrVkdX?=
 =?utf-8?B?aElocGFnc3Y5UnVXN1RXakRUdkYyYkl0Y2ZNamZpS3ByRHB4UEZySlhWeGVp?=
 =?utf-8?B?M01HcktUT3VVWDFDWTF2UDF1OEdTZnZnbzVmdlNNTktIQ04yd3dQWHN6cFNo?=
 =?utf-8?Q?BaWxeOA5znf/EdC0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F252AF9B8C724439432A54235236BB6@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB8591.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd1155c-4c75-4a98-6cfe-08da10aa4d74
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 11:01:25.3182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ULACtbjJaOwZdnNy9GVE7R2VVLD1LUiUwWRxFKYUFFeCYyZzfra8RGNU5JlapaK8sJGHez/+VLVYflsKJeo2ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB6666
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCBNYXIgMjUsIDIwMjIgYXQgMDQ6MTQ6MjhQTSAtMDQwMCwgUmlrIHZhbiBSaWVsIHdy
b3RlOg0KPiBJbiBzb21lIGNhc2VzIGl0IGFwcGVhcnMgdGhlIGludmFsaWRhdGlvbiBvZiBhIGh3
cG9pc29uZWQgcGFnZQ0KPiBmYWlscyBiZWNhdXNlIHRoZSBwYWdlIGlzIHN0aWxsIG1hcHBlZCBp
biBhbm90aGVyIHByb2Nlc3MuIFRoaXMNCj4gY2FuIGNhdXNlIGEgcHJvZ3JhbSB0byBiZSBjb250
aW51b3VzbHkgcmVzdGFydGVkIGFuZCBkaWUgd2hlbg0KPiBpdCBwYWdlIGZhdWx0cyBvbiB0aGUg
cGFnZSB0aGF0IHdhcyBub3QgaW52YWxpZGF0ZWQuIEF2b2lkIHRoYXQNCj4gcHJvYmxlbSBieSB1
bm1hcHBpbmcgdGhlIGh3cG9pc29uZWQgcGFnZSB3aGVuIHdlIGZpbmQgaXQuDQo+IA0KPiBBbm90
aGVyIGlzc3VlIGlzIHRoYXQgc29tZXRpbWVzIHdlIGVuZCB1cCBvb3BzaW5nIGluIGZpbmlzaF9m
YXVsdCwNCj4gaWYgdGhlIGNvZGUgdHJpZXMgdG8gZG8gc29tZXRoaW5nIHdpdGggdGhlIG5vdy1O
VUxMIHZtZi0+cGFnZS4NCj4gSSBkaWQgbm90IGhpdCB0aGlzIGVycm9yIHdoZW4gc3VibWl0dGlu
ZyB0aGUgcHJldmlvdXMgcGF0Y2ggYmVjYXVzZQ0KPiB0aGVyZSBhcmUgc2V2ZXJhbCBvcHBvcnR1
bml0aWVzIGZvciBhbGxvY19zZXRfcHRlIHRvIGJhaWwgb3V0IGJlZm9yZQ0KPiBhY2Nlc3Npbmcg
dm1mLT5wYWdlLCBhbmQgdGhhdCBhcHBhcmVudGx5IGhhcHBlbmVkIG9uIHRob3NlIHN5c3RlbXMs
DQo+IGFuZCBtb3N0IG9mIHRoZSB0aW1lIG9uIG90aGVyIHN5c3RlbXMsIHRvby4NCj4gDQo+IEhv
d2V2ZXIsIGFjcm9zcyBzZXZlcmFsIG1pbGxpb24gc3lzdGVtcyB0aGF0IGVycm9yIGRvZXMgb2Nj
dXIgYQ0KPiBoYW5kZnVsIG9mIHRpbWVzIGEgZGF5LiBJdCBjYW4gYmUgYXZvaWRlZCBieSByZXR1
cm5pbmcgVk1fRkFVTFRfTk9QQUdFDQo+IHdoaWNoIHdpbGwgY2F1c2UgZG9fcmVhZF9mYXVsdCB0
byByZXR1cm4gYmVmb3JlIGNhbGxpbmcgZmluaXNoX2ZhdWx0Lg0KDQpJIGFydGlmaWNpYWxseSBj
cmVhdGVkIGNsZWFuL2RpcnR5IHBhZ2UgY2FjaGUgcGFnZXMgd2l0aCBQYWdlSFdQb2lzb24gZmxh
Zw0KKHdpdGggU3lzdGVtVGFwKSwgdGhlbiByZXByb2R1Y2VkIE5VTEwgcG9pbnRlciBkZXJlZmVy
ZW5jZSBieSBwYWdlIGZhdWx0IG9uDQpjdXJyZW50IG1haW5saW5lIGJyYW5jaCAod2l0aCBlNTNh
YzczNzRlNjQpLiAgQW5kIGNvbmZpcm1lZCB0aGF0IHRoZSBidWcgd2FzDQpmaXhlZCB3aXRoIHRo
aXMgcGF0Y2gsIHNvIHRoZSBmaXggc2VlbXMgdG8gd29yay4NCg0KKE1heWJlIEkgc2hvdWxkJ3Zl
IGRvbmUgdGhpcyBraW5kIG9mIHRlc3RpbmcgYmVmb3JlIG1lcmdpbmcgZTUzYWM3Mzc0ZTY0LCBz
b3JyeS4uKQ0KDQpBbnl3YXksIHRoYW5rIHlvdSB2ZXJ5IG11Y2guDQoNClRlc3RlZC1ieTogTmFv
eWEgSG9yaWd1Y2hpIDxuYW95YS5ob3JpZ3VjaGlAbmVjLmNvbT4NCg0KPiANCj4gRml4ZXM6IGU1
M2FjNzM3NGU2NCAoIm1tOiBpbnZhbGlkYXRlIGh3cG9pc29uIHBhZ2UgY2FjaGUgcGFnZSBpbiBm
YXVsdCBwYXRoIikNCj4gQ2M6IE9zY2FyIFNhbHZhZG9yIDxvc2FsdmFkb3JAc3VzZS5kZT4NCj4g
Q2M6IE1pYW9oZSBMaW4gPGxpbm1pYW9oZUBodWF3ZWkuY29tPg0KPiBDYzogTmFveWEgSG9yaWd1
Y2hpIDxuYW95YS5ob3JpZ3VjaGlAbmVjLmNvbT4NCj4gQ2M6IE1lbCBHb3JtYW4gPG1nb3JtYW5A
c3VzZS5kZT4NCj4gQ2M6IEpvaGFubmVzIFdlaW5lciA8aGFubmVzQGNtcHhjaGcub3JnPg0KPiBD
YzogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gQ2M6IHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+ICBtbS9tZW1vcnkuYyB8IDEyICsrKysrKysrLS0t
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9tbS9tZW1vcnkuYyBiL21tL21lbW9yeS5jDQo+IGluZGV4IGJlNDRk
MGIzNmIxOC4uNzZlM2FmOTYzOWQ5IDEwMDY0NA0KPiAtLS0gYS9tbS9tZW1vcnkuYw0KPiArKysg
Yi9tbS9tZW1vcnkuYw0KPiBAQCAtMzkxOCwxNCArMzkxOCwxOCBAQCBzdGF0aWMgdm1fZmF1bHRf
dCBfX2RvX2ZhdWx0KHN0cnVjdCB2bV9mYXVsdCAqdm1mKQ0KPiAgCQlyZXR1cm4gcmV0Ow0KPiAg
DQo+ICAJaWYgKHVubGlrZWx5KFBhZ2VIV1BvaXNvbih2bWYtPnBhZ2UpKSkgew0KPiArCQlzdHJ1
Y3QgcGFnZSAqcGFnZSA9IHZtZi0+cGFnZTsNCj4gIAkJdm1fZmF1bHRfdCBwb2lzb25yZXQgPSBW
TV9GQVVMVF9IV1BPSVNPTjsNCj4gIAkJaWYgKHJldCAmIFZNX0ZBVUxUX0xPQ0tFRCkgew0KPiAr
CQkJaWYgKHBhZ2VfbWFwcGVkKHBhZ2UpKQ0KPiArCQkJCXVubWFwX21hcHBpbmdfcGFnZXMocGFn
ZV9tYXBwaW5nKHBhZ2UpLA0KPiArCQkJCQkJICAgIHBhZ2UtPmluZGV4LCAxLCBmYWxzZSk7DQo+
ICAJCQkvKiBSZXRyeSBpZiBhIGNsZWFuIHBhZ2Ugd2FzIHJlbW92ZWQgZnJvbSB0aGUgY2FjaGUu
ICovDQo+IC0JCQlpZiAoaW52YWxpZGF0ZV9pbm9kZV9wYWdlKHZtZi0+cGFnZSkpDQo+IC0JCQkJ
cG9pc29ucmV0ID0gMDsNCj4gLQkJCXVubG9ja19wYWdlKHZtZi0+cGFnZSk7DQo+ICsJCQlpZiAo
aW52YWxpZGF0ZV9pbm9kZV9wYWdlKHBhZ2UpKQ0KPiArCQkJCXBvaXNvbnJldCA9IFZNX0ZBVUxU
X05PUEFHRTsNCj4gKwkJCXVubG9ja19wYWdlKHBhZ2UpOw0KPiAgCQl9DQo+IC0JCXB1dF9wYWdl
KHZtZi0+cGFnZSk7DQo+ICsJCXB1dF9wYWdlKHBhZ2UpOw0KPiAgCQl2bWYtPnBhZ2UgPSBOVUxM
Ow0KPiAgCQlyZXR1cm4gcG9pc29ucmV0Ow0KPiAgCX0NCj4gLS0gDQo+IDIuMzUuMQ0KPiA=
