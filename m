Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108CC4783BD
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 04:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhLQDo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 22:44:59 -0500
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:3461
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231143AbhLQDo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 22:44:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYjOcBblgwWhhc+/2EC1BqWcaxPifAq1KbK9wFwh3K4I/YO7n7c7BqhCTVIrhPcI5qHsFT7fogovJMFM1pGDteBoJIxzDdO5ZtOZUSJOtvyMqql0p3VBTuUPyWm3DGoKGi30CQKQsoScsBNTeA1TC/7UVrbZlDi4aPghvevq/c4EpFhn81rjGGkyDcz5G1EMHTPlbOHCVndyb+LxW9iuiuyfeFc3AMXIcuBs29sob/O1lUAgmtn97loDOvgR8LP7rcI99po6evPY8Yxk8kPGoCgeSmXd75zBX00ZfEyshoZM4Fq2n5wVpJ88gu9uM4jaOiFNJNQ8wfdNIs7AUDwn2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWjkP/szTXruVDU8m/7AAouLzJfOQGOCBgkUnddkgy0=;
 b=aEZbM1sViuCNIxmPUh2zB0AzXNCPWNd8Wbq2yxRZBA8v1tpoOZe32iaH5Hk0vuOepJ849A3SGMAQef45rAvHDo3uAzABIV9A0R17rM9L6YVSKTxO7CEidbINmAR9pr26VBJIaBFKUxzZx18/ctscuZk+feRBIjfh08cweVS9XLIgmRYqoymFTvFU3Ypno1vNuq7MjjITOK9Ukcd59/gzk+dRe6KgFpogpIg5twKBYAN8Aw8rmE1nKVZ7V41SCOdpuPWAVzIyahH8vcohxxm7fiv/c7MQAEPY0thf3nc+z/3+SHWlD454K7Hp3FXVwENF+o2JjYd6LR1/9C22JgtBTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWjkP/szTXruVDU8m/7AAouLzJfOQGOCBgkUnddkgy0=;
 b=Zv2xSW+qsJ4+oLPVQFf+nWZBAeXsTGhPznthvxJbDWPPjmdReRJ/B8duomoiCFvt7x+d2JGQr7diZEo0yupv1hWNFVPGca0vC7ZTZf8K/Z90nvXClGifx1EszJfGp/RkBifqqXOo6ZU1vic3vWnKdqM8Sq2SHqYyjrH1etyLsbg=
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by DU2PR04MB8773.eurprd04.prod.outlook.com (2603:10a6:10:2e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 03:44:56 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c%3]) with mapi id 15.20.4778.019; Fri, 17 Dec 2021
 03:44:56 +0000
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
Thread-Index: AQHX8YpPLY06ZVezCkulrdtZ3OawN6wzfB0AgADtyGCAAIpSgIABCOJQ
Date:   Fri, 17 Dec 2021 03:44:56 +0000
Message-ID: <DB9PR04MB8477037EE173D98F844DCAE680789@DB9PR04MB8477.eurprd04.prod.outlook.com>
References: <20211215080242.3034856-1-aisheng.dong@nxp.com>
 <20211215080242.3034856-2-aisheng.dong@nxp.com>
 <783f64f5-3a55-6c42-a740-19a12c2c7321@redhat.com>
 <DB9PR04MB84777DDC63F5D2D995F7F5E980779@DB9PR04MB8477.eurprd04.prod.outlook.com>
 <7d9b7e5f-a6c0-2079-90e7-c02aaeb1f4c0@redhat.com>
In-Reply-To: <7d9b7e5f-a6c0-2079-90e7-c02aaeb1f4c0@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43ee5160-eb31-4498-00c1-08d9c10f97a3
x-ms-traffictypediagnostic: DU2PR04MB8773:EE_
x-microsoft-antispam-prvs: <DU2PR04MB87733F0D330A373F92470A0F80789@DU2PR04MB8773.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1aAQOVDV3MEdhjdyR3Z385v28Mag3GvoGcaknzXuwtW3hZxqU9ntA90r8S8Xng/2UmhyrjM2xu3ZhsRJVHuplFwyrPE5Af1goQnV/LJ3hFxfyLC50qGRhM3fkE3ElNAHEDNMF+4Xq6g3vGCTz3JHVtl5xZe0UCOheHdkEBXl+ukT4/kzy3riNhCfy4DSOxiaQKNF7SS4sAzca+S04jK2rENlyfDuB1WJjQJT0AVmk09vRySPZQQDSNNK1RmTEpP225ZSZqPrVVkEHZkvvLfRXBzm3wRMXPQFN6v8iABoQj3+zJ0N8218GINFcFzFIJUzuq9kZglerGptmdtpSEyDp14e9psDq+hlDJCyYjRBaVKcsAL2jT8SEzymGMQ82Ql66/Q0nXbUM2BQoctUeM9l7+ObrIp6dawDmjQtCYgIUWcm2fogatFB+LcmaW9g7XUNh3gQqzZw7ZgWcAICHXYzVh5W84zH62EiML/pNgtKRlsVphXPTyewUwPTvYkq/eX03V5q6RresqpGRds3wITYGmQceBHc5Rymi3KQDHr4ICd+M1ojzht3la033398PkAohdBWqTQkQKlycr4S4VeutLGopP9GVmmvV8cIUZPR2GwzEdYqNpRMMaZgS+8KtENyKNWP41yfevMq739S/lp7e4AOSNhKEbyGeBfjtxUstxoN4qCxsPFm/aYsGoaVlZ3TGkRHd3pjVHSzSanMgOvRQe58YJqggfTQMUHnwLRc1WvXVrIfVINfERYAbLFw05mI46p+2Dxk2DYK9TpRvvFjHhqame52lYMc1UYn5zbwnOY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(110136005)(54906003)(52536014)(316002)(2906002)(9686003)(8676002)(8936002)(86362001)(5660300002)(7696005)(4326008)(508600001)(53546011)(71200400001)(38100700002)(26005)(122000001)(6506007)(966005)(66946007)(66556008)(55016003)(7416002)(66446008)(76116006)(38070700005)(64756008)(44832011)(83380400001)(33656002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VytpUUhNejZOM0FxUVVnOHM2Z3A1cjQxU0ZRZ2hWaUFNRTdNVkhqSlFJMmU3?=
 =?utf-8?B?Y2xCSGtyeVVlN3hBZlM5SE0vR0lSRXhJTTZiU0V2NCsxYmxHU3B2empMYld6?=
 =?utf-8?B?b1RyR3lsSlpHZndDQml0azdhTmlzSXBrUnppQXpzUC9nL0NYYzl2MlU1dkJD?=
 =?utf-8?B?aWRsMUFuNllYaWNNc0EreDl1cGpsZWRPS1B2c3M4UURXd0dRSTZMZDBLLzJG?=
 =?utf-8?B?NktadTU1ZWowcDAydWhpMWg5dlZXbTArbUk0T3JlYk9mRUt3RHVjbWZIOG9i?=
 =?utf-8?B?cVN0MVNSZEhySHo0Uyt0dVJyd2pUeWM3ZFlsVFNmek5HNTRKYUpBRFRFSkdM?=
 =?utf-8?B?eWthY3FnWGNEblNaQTZtQkJKMlMrR3YrTGk2cXBJbTQ0MEFLUnhLOVVVZklw?=
 =?utf-8?B?dlh2QkoyVXdBcHFJdURzcC9FVmlmQ0lIQlREN3VTbjV2WmkzcHFqV2NYc2pU?=
 =?utf-8?B?dVRhWTJDMnc3Yy9RdWgxRWpwSDZMLzFsTW9QTklxeGIvQkVRekNaSTlLUnkx?=
 =?utf-8?B?bU41U1VhM2JxVXZaV2JKM0ZTbys3dWk0SmNGSGR6aC9ucy9GQldBSjlRc3V6?=
 =?utf-8?B?Q3VVTzJpRUhCUHdxWFFZbjZWM0ppcU0wTmk5T05pUEJ0UUZwNFovUjM0akM4?=
 =?utf-8?B?QTd3Vnl3eEdXcm0ycitFRXFUMW1tV2J0SHFvZ1BTZXVUYWlXazV1bldLZSt4?=
 =?utf-8?B?SUQyOCsrN2NSbEtwb3RMeTFMUnBTM21XRHpZMnF1NmdDbTliR3FTNzJ2QTUr?=
 =?utf-8?B?TGhBZjI2dTdVVTY0LzVEQ3F4dEJoZTcxYzFrbC9DVnJCQllCNklpa3FUUDBZ?=
 =?utf-8?B?UGJiRG1EdFhxVkY3alFhMXhTU0pOZWl6dkdibEVlZkRINzN1OWZhRnY5TEtX?=
 =?utf-8?B?eUJ2dklpdVpyWHYxNXA2NGhOVjc4dUM1RXFrUWlHMlNWOHVjdXpKZ29RM2JZ?=
 =?utf-8?B?SjdKenFJVlVCcUVUVjdWZ0l2ejhyWHhxTkNQc0NuVjJQNGU5OXREVU82OU1q?=
 =?utf-8?B?VzdEN281UTA5NDJmay9ESG1FSlRzZUtmQUVXNDFHZTFzeENaZ01UU2ZLaE9Y?=
 =?utf-8?B?M2N2MEZrTmFmc3FBV0t1aVZuNmRiUXJIeHBicm9LSUxHU2Rzcjh0MHd1YVBG?=
 =?utf-8?B?VjNPOVdUdHVySjJOckxuR0ltTTZwcU9GT2RER1l5UHMwa2ozUktJYnZyWFZM?=
 =?utf-8?B?V3BqQjZka0dJY1BtUC9jZnArL25nbng4dDBaUWNxeE53Ym9HZzkrUnZSVkJB?=
 =?utf-8?B?UGpjNENRTXVDd1ZCVXFPOHR2RWh6MnRwMjRvMTJXTWdLU0l2cGJiZjBKVEFM?=
 =?utf-8?B?Y1ZpZ0w5SzlpSlp5cGc0Vkx2TmpUNU4vMUpxQ3VLWDlTOWhGbDFjNEEwbE9G?=
 =?utf-8?B?VVFZQzhLNUZHT1F6SUZQOHJ3ZFNHcEF0TzRrWEpKdkEzNytGMXBPc2dLNnhr?=
 =?utf-8?B?RkNTNVNQQkJaZU9FVGZXYWtNbG5LbDh4Mk1nUVgwTE8ycmJGZ3lXOTh4VFhF?=
 =?utf-8?B?ZExPSDlCN0EyaldYbWM1WTV4OSs1WVV4cStpcTY1eC91aE9vUEdsSEFZd0p5?=
 =?utf-8?B?WnpZZWk1cGJjN0ZPOWdaNS85OUU4RG0zYnhYT2RhazhyODdrM21qVmQ3TkZ1?=
 =?utf-8?B?bFlHMm1vOGsxTnpXaVZ2d1NrWUtjN2RKTEhHQ3VHek9QanB0WXRHdFJWTDhD?=
 =?utf-8?B?SEg5Rk80RlYxaEJLb2FyWHd2U05wSXZNY3RuZnhPeS9wTjJyY3Brc0ZCNUQv?=
 =?utf-8?B?MXY2cVdrWkppTCsrK0oyZDZkZ1Y4TGJUTEhQRXhJbW5sSnYyK0E0Ni9BcE1o?=
 =?utf-8?B?ME13dHprZ1RpckFJUHUyMW54Z2lVZm15OWM4WE45NGJYcFEwTkJuUXA3aHUz?=
 =?utf-8?B?NUtmUWgyc2M2bjcyRXdaOEV6Vks5ZFpITWhnTk5ONC9BOVRYT1d4R1o4OVc3?=
 =?utf-8?B?elh0M0ZVOG5qMTk5aUxJM0cweUVsVi8ydGk2bEZHMFJiTnl0MGtsTHhJZHFy?=
 =?utf-8?B?L1dKR1FlYXVOTEdnSTlQNjdBL2dJeXNIRHp3UDdyWm5wcnJnaWQ3NVBkbXRV?=
 =?utf-8?B?RGJrSTVjWmxlSGJUMEZScXZTK1d2RGVXcEtMVTlCb1Z2b04ycVhYWmY0T0Jp?=
 =?utf-8?B?aGVPOE1ybTlCRlBDaFczelRDYnBkd0tTZmF2UGg1SWM4OTl5eEVhWWJORzli?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ee5160-eb31-4498-00c1-08d9c10f97a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 03:44:56.0645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nUwc02k3yYP4cBB6MeE+zk5fj+XN7DYDuCn7NCG+M/iJU5xOr/BEMLyEn3+153DTqCapeiPJFxDf97C4Y2CdMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8773
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1
cnNkYXksIERlY2VtYmVyIDE2LCAyMDIxIDY6NTcgUE0NCj4gDQo+IE9uIDE2LjEyLjIxIDAzOjU0
LCBBaXNoZW5nIERvbmcgd3JvdGU6DQo+ID4+IEZyb206IERhdmlkIEhpbGRlbmJyYW5kIDxkYXZp
ZEByZWRoYXQuY29tPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDE1LCAyMDIxIDg6
MzEgUE0NCj4gPj4NCj4gPj4gT24gMTUuMTIuMjEgMDk6MDIsIERvbmcgQWlzaGVuZyB3cm90ZToN
Cj4gPj4+IFdlIG1ldCBkbWFfYWxsb2NfY29oZXJlbnQoKSBmYWlsIHNvbWV0aW1lcyB3aGVuIGRv
aW5nIDggVlBVIGRlY29kZXINCj4gPj4+IHRlc3QgaW4gcGFyYWxsZWwgb24gYSBNWDZRIFNEQiBi
b2FyZC4NCj4gPj4+DQo+ID4+PiBFcnJvciBsb2c6DQo+ID4+PiBjbWE6IGNtYV9hbGxvYzogbGlu
dXgsY21hOiBhbGxvYyBmYWlsZWQsIHJlcS1zaXplOiAxNDggcGFnZXMsIHJldDoNCj4gPj4+IC0x
Ng0KPiA+Pj4gY21hOiBudW1iZXIgb2YgYXZhaWxhYmxlIHBhZ2VzOg0KPiA+Pj4NCj4gPj4NCj4g
M0AxMjUrMjBAMTcyKzEyQDIzNis0QDM4MCszMkA3MzYrMTdAMjI4NysyM0AyNDczKzIwQDM2MDcN
Cj4gPj4gNis5OUA0MDQ3NysxMDgNCj4gPj4+IEA0MDg1Mis0NEA0MTEwOCsyMEA0MTE5NisxMDhA
NDEzNjQrMTA4QDQxNjIwKw0KPiA+Pj4NCj4gPj4NCj4gMTA4QDQyOTAwKzEwOEA0MzE1Nis0ODNA
NDQwNjErMTc2M0A0NTM0MSsxNDQwQDQ3NzEyKzIwQDQ5DQo+ID4+IDMyNCsyMEA0OTM4OCsNCj4g
Pj4+IDUwNzZANDk0NTIrMjMwNEA1NTA0MCszNUA1ODE0MSsyMEA1ODIyMCsyMEA1ODI4NCsNCj4g
Pj4+IDcxODhANTgzNDgrODRANjYyMjArNzI3NkA2NjQ1MisyMjdANzQ1MjUrNjM3MUA3NTU0OT0+
DQo+ID4+IDMzMTYxIGZyZWUgb2YNCj4gPj4+IDgxOTIwIHRvdGFsIHBhZ2VzDQo+ID4+Pg0KPiA+
Pj4gV2hlbiBpc3N1ZSBoYXBwZW5lZCwgd2Ugc2F3IHRoZXJlIHdlcmUgc3RpbGwgMzMxNjEgcGFn
ZXMgKDEyOU0pIGZyZWUNCj4gPj4+IENNQSBtZW1vcnkgYW5kIGEgbG90IGF2YWlsYWJsZSBmcmVl
IHNsb3RzIGZvciAxNDggcGFnZXMgaW4gQ01BDQo+ID4+PiBiaXRtYXAgdGhhdCB3ZSB3YW50IHRv
IGFsbG9jYXRlLg0KPiA+Pj4NCj4gPj4+IElmIGR1bXBpbmcgbWVtb3J5IGluZm8sIHdlIGZvdW5k
IHRoYXQgdGhlcmUgd2FzIGFsc28gfjM0Mk0gbm9ybWFsDQo+ID4+PiBtZW1vcnksIGJ1dCBvbmx5
IDEzNTJLIENNQSBtZW1vcnkgbGVmdCBpbiBidWRkeSBzeXN0ZW0gd2hpbGUgYSBsb3QNCj4gPj4+
IG9mIHBhZ2VibG9ja3Mgd2VyZSBpc29sYXRlZC4NCj4gPj4+DQo+ID4+PiBNZW1vcnkgaW5mbyBs
b2c6DQo+ID4+PiBOb3JtYWwgZnJlZTozNTEwOTZrQiBtaW46MzAwMDBrQiBsb3c6Mzc1MDBrQiBo
aWdoOjQ1MDAwa0INCj4gPj4gcmVzZXJ2ZWRfaGlnaGF0b21pYzowS0INCj4gPj4+IAkgICAgYWN0
aXZlX2Fub246OTgwNjBrQiBpbmFjdGl2ZV9hbm9uOjk4OTQ4a0IgYWN0aXZlX2ZpbGU6NjA4NjRr
Qg0KPiA+PiBpbmFjdGl2ZV9maWxlOjMxNzc2a0INCj4gPj4+IAkgICAgdW5ldmljdGFibGU6MGtC
IHdyaXRlcGVuZGluZzowa0IgcHJlc2VudDoxMDQ4NTc2a0INCj4gPj4gbWFuYWdlZDoxMDE4MzI4
a0IgbWxvY2tlZDowa0INCj4gPj4+IAkgICAgYm91bmNlOjBrQiBmcmVlX3BjcDoyMjBrQiBsb2Nh
bF9wY3A6MTkya0IgZnJlZV9jbWE6MTM1MmtCDQo+ID4+PiBsb3dtZW1fcmVzZXJ2ZVtdOiAwIDAg
MA0KPiA+Pj4gTm9ybWFsOiA3OCo0a0IgKFVFQ0kpIDE3NzIqOGtCIChVTUVDSSkgMTMzNSoxNmtC
IChVTUVDSSkgMzYwKjMya0INCj4gPj4gKFVNRUNJKSA2NSo2NGtCIChVTUNJKQ0KPiA+Pj4gCTM2
KjEyOGtCIChVTUVDSSkgMTYqMjU2a0IgKFVNQ0kpIDYqNTEya0IgKEVJKSA4KjEwMjRrQiAoVUVJ
KQ0KPiA+PiA0KjIwNDhrQiAoTUkpIDgqNDA5NmtCIChFSSkNCj4gPj4+IAk4KjgxOTJrQiAoVUkp
IDMqMTYzODRrQiAoRUkpIDgqMzI3NjhrQiAoTSkgPSA0ODkyODhrQg0KPiA+Pj4NCj4gPj4+IFRo
ZSByb290IGNhdXNlIG9mIHRoaXMgaXNzdWUgaXMgdGhhdCBzaW5jZSBjb21taXQgYTRlZmMxNzRi
MzgyDQo+ID4+PiAoIm1tL2NtYS5jOiByZW1vdmUgcmVkdW5kYW50IGNtYV9tdXRleCBsb2NrIiks
IENNQSBzdXBwb3J0cw0KPiA+PiBjb25jdXJyZW50DQo+ID4+PiBtZW1vcnkgYWxsb2NhdGlvbi4g
SXQncyBwb3NzaWJsZSB0aGF0IHRoZSBwYWdlYmxvY2sgcHJvY2VzcyBBIHRyeSB0bw0KPiA+Pj4g
YWxsb2MgaGFzIGFscmVhZHkgYmVlbiBpc29sYXRlZCBieSB0aGUgYWxsb2NhdGlvbiBvZiBwcm9j
ZXNzIEINCj4gPj4+IGR1cmluZyBtZW1vcnkgbWlncmF0aW9uLg0KPiA+Pj4NCj4gPj4+IFdoZW4g
dGhlcmUncmUgbXVsdGkgcHJvY2VzcyBhbGxvY2F0aW5nIENNQSBtZW1vcnkgaW4gcGFyYWxsZWws
IGl0J3MNCj4gPj4+IGxpa2VseSB0aGF0IG90aGVyIHRoZSByZW1haW4gcGFnZWJsb2NrcyBtYXkg
aGF2ZSBhbHNvIGJlZW4gaXNvbGF0ZWQsDQo+ID4+PiB0aGVuIENNQSBhbGxvYyBmYWlsIGZpbmFs
bHkgZHVyaW5nIHRoZSBmaXJzdCByb3VuZCBvZiBzY2FubmluZyBvZg0KPiA+Pj4gdGhlIHdob2xl
IGF2YWlsYWJsZSBDTUEgYml0bWFwLg0KPiA+Pg0KPiA+PiBJIGFscmVhZHkgcmFpc2VkIGluIGRp
ZmZlcmVudCBjb250ZXh0IHRoYXQgd2Ugc2hvdWxkIG1vc3QgcHJvYmFibHkNCj4gPj4gY29udmVy
dCB0aGF0IC1FQlVTWSB0byAtRUFHQUlOIC0tICB0byBkaWZmZXJlbnRpYXRlIGFuIGFjdHVhbA0K
PiA+PiBtaWdyYXRpb24gcHJvYmxlbSBmcm9tIGEgc2ltcGxlICJjb25jdXJyZW50IGFsbG9jYXRp
b25zIHRoYXQgdGFyZ2V0IHRoZQ0KPiBzYW1lIE1BWF9PUkRFUiAtMSByYW5nZSIuDQo+ID4+DQo+
ID4NCj4gPiBUaGFua3MgZm9yIHRoZSBpbmZvLiBJcyB0aGVyZSBhIHBhdGNoIHVuZGVyIHJldmll
dz8NCj4gDQo+IE5vLCBhbmQgSSB3YXMgdG9vIGJ1c3kgZm9yIG5vdyB0byBzZW5kIGl0IG91dC4N
Cj4gDQo+ID4gQlRXIGkgd29uZGVyIHRoYXQgcHJvYmFibHkgbWFrZXMgbm8gbXVjaCBkaWZmZXJl
bmNlIGZvciBteSBwYXRjaCBzaW5jZQ0KPiA+IHdlIG1heSBwcmVmZXIgcmV0cnkgdGhlIG5leHQg
cGFnZWJsb2NrIHJhdGhlciB0aGFuIGJ1c3kgd2FpdGluZyBvbiB0aGUNCj4gc2FtZSBpc29sYXRl
ZCBwYWdlYmxvY2suDQo+IA0KPiBNYWtlcyBzZW5zZS4gQlVUIGFzIG9mIG5vdyB3ZSBpc29sYXRl
IG5vdCBvbmx5IGEgcGFnZWJsb2NrIGJ1dCBhDQo+IE1BWF9PUkRFUiAtMSBwYWdlIChlLmcuLCAy
IHBhZ2VibG9ja3Mgb24geDg2LTY0ICghKSApLiBTbyB5b3UnbGwgaGF2ZSB0aGUNCj4gc2FtZSBp
c3N1ZSBpbiB0aGF0IGNhc2UuDQoNClllcywgc2hvdWxkIEkgY2hhbmdlIHRvIHRyeSBuZXh0IE1B
WF9PUkRFUl9OUl9QQUdFUyBvciBrZWVwIGFzIGl0IGlzDQphbmQgbGV0IHRoZSBjb3JlIHRvIGlt
cHJvdmUgaXQgbGF0ZXI/DQoNCkkgc2F3IHRoZXJlJ3MgYSBwYXRjaHNldCB1bmRlciByZXZpZXcg
d2hpY2ggaXMgZ29pbmcgdG8gcmVtb3ZlIHRoZQ0KTUFYX09SREVSIC0gMSBhbGlnbm1lbnQgcmVx
dWlyZW1lbnQgZm9yIENNQS4NCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9s
aW51eC1tbS9jb3Zlci8yMDIxMTIwOTIzMDQxNC4yNzY2NTE1LTEtemkueWFuQHNlbnQuY29tLw0K
DQpPbmNlIGl0J3MgbWVyZ2VkLCBJIGd1ZXNzIHdlIGNhbiBiYWNrIHRvIGFsaWduIHdpdGggcGFn
ZWJsb2NrIHJhdGhlcg0KdGhhbiBNQVhfT1JERVItMS4NCg0KUmVnYXJkcw0KQWlzaGVuZw0KDQo+
IA0KPiAtLQ0KPiBUaGFua3MsDQo+IA0KPiBEYXZpZCAvIGRoaWxkZW5iDQoNCg==
