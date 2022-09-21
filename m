Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D097C5D19F2
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 20:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiIUSDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 14:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIUSDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 14:03:16 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11010012.outbound.protection.outlook.com [52.101.51.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA85C2E684;
        Wed, 21 Sep 2022 11:03:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YR2h+qiLU2RqNHTYEAj8xa5XPZB41paoA4kLmrekgZ6xr+/ZzwU7y1jhgeuPimSlE/i/Hq+5lb9/4wHAD0P1kFi6DO2mFHM/O7AyBF7hiJCQ3oBSPQ7k8q+b2JAW8rycz7P8jrw/jilbRdph/2NZa8eD6+Aj6J66aMqj/Y/fpLFjQvKkvNTZjEsFyIXNNP7Rxnk/Na5KbpzpqyQySVOxCs0Mh2GpJuqII1krToVDbFduDnSqfB8RDOv233Aoz9/2lspWO2WDABCDRwRO3Yo7H30Zp5hy3nJ7yuiUCv8AQNUoRonKUHo99ksWkBHV3df2Iap//U5MEriGd+xANHLkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S40fa/ZAT1XsHAcoxtgv6r/xGgSncp6+/huAvMqybUY=;
 b=NUoGyNi6tKZ74Vw/fjfcw+k2iMa0XrsveP/uHs3gYGBTC2mllrTg1nHAVWUHprL+Xh9rMTHfMabHN2PKVD9XuE74GKI+HrrQ3RgbVNA0BnQvajicIdbenWv357fZgvrLvGqBCGADzeciEVcNSjL2vaLD1zIYbzPU6dcfampG+IQkW/4q005xaZQliRKV+uZ8HxlBt5BrFFPw16QVa3hDaTz9GqpCkvX07OUc2Wd/uIPMv3/bCi5ZX0/zzEXLP2p4U0D/1WstTH59Xg2s4/1ucjDyQCJh2GsYocX85Ori9BmkyFdIfn+mi0c6ALhdxCrFiBwU89GQThPgkb8vB7dzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S40fa/ZAT1XsHAcoxtgv6r/xGgSncp6+/huAvMqybUY=;
 b=LgCKS1/nAdm85CtojBWlEQADzdbq861sbVMeY3WCyF6gR1Up6AcZLgF1mMWQiPqNKeC1rgFu0ZPezl6bEb3nKUL9vFg61ZHtKeip5RYczf5AyKF0h+UAvNbBghk33Dx69BUwQFdpqchgMkbDvblMmSsK30odtXBmlOj0D30EjVs=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by DS0PR05MB9447.namprd05.prod.outlook.com (2603:10b6:8:11c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.7; Wed, 21 Sep
 2022 18:03:12 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6%5]) with mapi id 15.20.5676.007; Wed, 21 Sep 2022
 18:03:12 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "# 5 . 10+" <stable@vger.kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH] x86/alternative: fix race in try_get_desc()
Thread-Topic: [PATCH] x86/alternative: fix race in try_get_desc()
Thread-Index: AQHYzUKsetLOm0hn3UuxTjzL+E3efq3pg5gAgACqtYA=
Date:   Wed, 21 Sep 2022 18:03:11 +0000
Message-ID: <68350BC2-074F-4776-B5CD-1335311CC1D8@vmware.com>
References: <20220920224743.3089-1-namit@vmware.com>
 <YyrCrN6RwibR505Z@hirez.programming.kicks-ass.net>
In-Reply-To: <YyrCrN6RwibR505Z@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|DS0PR05MB9447:EE_
x-ms-office365-filtering-correlation-id: 192e7fe7-2f78-490c-b871-08da9bfb8c55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wsaIziBKidNTKfsmi93j4mxWi1tpr0q+AAlCo/S0CKYxc6UaaYPPFBdCNDiQkZVPvO7lwBkOaLbz4d4sCuo41uVl/IdLlGWSLKj7eEnufpB8NqIO21bGNqUom/5v3M411SSTrhPMx142bUruyr2HocKj+d6TD8qqRwy48NBDZTtrmGWNZCujXtd3H69V3/rOsmq8LSReN9nRbtr4a+VVFoH2Ey5kqKd/Ju7mT3Wp5z8z/tQ37y+7w1MXzmg87EYvvoSO4sCrm7Gt4NuCTWiwVMbUZrDABFUNTY1m5OH/0qP0fk/8U+GMfXGvVEYsHhEQP6G07gCLJMZrXchzSESE2bTjxwTm0lE3Z6ns4XffG5Hm3l3YDJx7FUCTtc8Gh1P8pceUd4hCKKLq5K0mYLG1tC8bNpgGjWJSm9Cai/D3rHqOCwmlAGAMTGDtrALadpUm7y1r8BzfPJTDkAPSgJ9YBQnI0e5IaAz4YIkLKtHOh4w7bMfNS1bGdBP1iVLpLg06zaMuXYTZmCUR7GUpmUhJiWQ3RlB2Z62zhIf1YOvsDmHbE5S8eagjwh6FUwjgO7Ataxto+FR264T3eOgLF73hu1JJcSEJV+eQ16qRItSye64VCmg1EeAetf4kE0gUmzjxfdU+Ieu4LXr8lCr+i+gYH2in0ymsxIM8qMeAUco8G/Jwj17AzYO3WkZ0SiRWF3fyOwaSN3elh62dZIpzpmfAVfu2Nk0CKQsIYLH1pMO8uAPwl6WOi3TVHC4Js1xbx5oEWPkcYdnc3XrSSLEfotEYhFKOl/2Q1Mpw2u/rxBbss8VWKM8QXLl0WKKNsHN1u364HSjTvYqMFA+wQa76Oh3MaA31eJXQI6WgPz22VwvDku8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199015)(53546011)(83380400001)(8936002)(38100700002)(316002)(6486002)(122000001)(76116006)(8676002)(66476007)(6916009)(5660300002)(66446008)(66556008)(4326008)(38070700005)(66946007)(71200400001)(64756008)(6512007)(26005)(6506007)(2906002)(86362001)(41300700001)(186003)(2616005)(478600001)(33656002)(36756003)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU1mem9HS2lPazFSL21BOE4zczQxRDdIYTUrbUNSeitrWEFpWUZUdWhPZ0No?=
 =?utf-8?B?R2RkVzFBVUJoNThhbTJ4ck84TW5iWmoxSUpqdzVqUUtBNllvUEtqL3o4eWFu?=
 =?utf-8?B?ejdyVlZCcVpQV1VXV3IxRzVTU3VmaUFoV1ErSWxNaWxNRnZwSU5mejJQOG9l?=
 =?utf-8?B?QlZ4czV1RXM2cnBPM1JLci92b3FXYTF4WVBYc1RaclNlUm5MenM0R2xlSGJH?=
 =?utf-8?B?YUlKaVJqRGdRUTdIMEcwMDl5WFFrWnBFNDhCOFZJclNYSXRMSEg0SjhsUW1N?=
 =?utf-8?B?RFRHb1hYVGxtVEp5dFM0NWFuOHpoZmhOb3Z5RW9SR0hiVkhEWE5kNHJyUzhB?=
 =?utf-8?B?dW0raXlFYjZzb3hZb3JwTXppVUVpSDJQYzRCSUVRNmtRS2dadkUyZU9ZREg1?=
 =?utf-8?B?WGxpUmp4QjJhcFNTdmJJa0JBVnNZQ2NRUzZ3dVM1TlhZOFlmMCtLU3Y4aTF3?=
 =?utf-8?B?UFZ6UVlEZnA3QzYvc3NKTzZiejZCZGU2NjhaRWZmWnVnem95WkhkbUh0ZW9s?=
 =?utf-8?B?VmNuUG8yWG1XY1Jpb3NyMDhuWENtbE9QcVNRNVA4VDFsWnN2Y3FyRW1pVUdU?=
 =?utf-8?B?NkJiZ2ZxMktEYXo2a0p6YXA2ZDM0cXF6MkVmRGZYQXozUFNhMldMSS90MHpG?=
 =?utf-8?B?dkVWN0xZKzBhNUZFWnRzWVh0czdBQ2NlRUZKOUovODNFSDhUc2MrWUtoZmJl?=
 =?utf-8?B?SGN3TXZaV29TRHZwT2tGOXJ6MUZKeTBTa21Od2txcno1UllQeGpFM1V2Vklv?=
 =?utf-8?B?c1JCV242dHVuS1RTWi9jbFZJSHpET2t0bU5WTHFETnd4N1l1cldIVGJIdzFQ?=
 =?utf-8?B?NXRBKzJ1RVFEMm8rUjMvN01wWlN6VDdsQ25IVjhrNEl2NHZWLzdtYmc1QW5y?=
 =?utf-8?B?TFhzMjY3TVpwWlZOS3hzR2kxdWphY3hQL1hWZkpnNGRORU9hQTF3NXRqRFdB?=
 =?utf-8?B?R3dxOEJxUG5XbDltT1JmODM4SjdOS1pVaHB1bE8wSkhaN256K3VxOG1LQkJT?=
 =?utf-8?B?OUVGM3hRVG9rWjJmWWVsZUFLU1NwS0p6eWtoVzVETVorOURRRGhzS2lTY3Bj?=
 =?utf-8?B?ZDZyQkQ1QTFBM0Q4bllWaTdmZ2M0NWlzNUtDOU1FdTFTVjVZcTdCbzh1QWJC?=
 =?utf-8?B?YUxMUXY2S0RLNGxPeTk1V2NucVluckExM0d1eXYzUG1vRnN4ZEdWSXlxZ1Vm?=
 =?utf-8?B?ckRyU2VGMzBHZThTeWQ1M3ArL0EybmI1eWhvaGVteUFMbnpGTU1jVHJNUkxw?=
 =?utf-8?B?bUhMZzR3M21IVzJFQSt0QkJpMDZISjByTjFlayt0aThoUllWdHBXNGZYakxo?=
 =?utf-8?B?Zit4dVNBdDBSWFZ6SlFtZDdKSXRmczh1UWRMKytUcFREd1EvbEZ5VG1VVjZY?=
 =?utf-8?B?WGhqQmgxZExKRVZKbFJ6TE1JNlN6clI0QXR2bzdrbDRZNzEzNnpxejNvRmZ0?=
 =?utf-8?B?MHFYWXdFMk1VczJtWWZERmJhamF3d0xJUEFCYVpXWU8zYXFwZXNBanJDVkVw?=
 =?utf-8?B?NUszd1pDQzR6WUhWSGpGbDdMaHBlNGxiS3FIVzQwWDJ0d28zMWhzcmZIMFlX?=
 =?utf-8?B?UmVMa3hJSklUNHdsSC9hbGtSbWZBQ0xDME9SZW9hNnlJZ0RCU056L0Z1WlNj?=
 =?utf-8?B?OXZOaDRPdTZYTEFUcFJJaHZ2SXgrNktqeUJrS2pQaHNObjFBMS9zbzlsSkho?=
 =?utf-8?B?a0FOS05aRUcyVmhKL3I4VGVKdGhGaDdvNFhvT1BlSXNtWVBiVjhHQjl3THNw?=
 =?utf-8?B?ck14cmpBK3dpRUc2ZklQVjg3RDkwNUpwVFB1c2dSVjNLNVlqbWxzWE5sKzdw?=
 =?utf-8?B?ejRGdzBQK0xUZThoUWdmK3hWNExVakVRWTdKRDlMWVlCREJFbzZ4R2ordUU1?=
 =?utf-8?B?clMwN080VWRsVmpsQ0ZQY0FaWjZPZHFLMEFyRkpwTnhzckhHK3pUcjhYcHpi?=
 =?utf-8?B?VEluWGwrL2VFVkhkcDF0UFhuUVlVRTFBWWYvd2JJV1phblhyVUwzZElUOGJF?=
 =?utf-8?B?dDJQSjdYNzYyMjF3d0RZeDI2bVJSRjRTS2FRTzBTUDUvcHZ4dFNMaXBPQkR2?=
 =?utf-8?B?UUJDRHhtZlVUVXhPNldOcDI4Tkh4ZkxsMTh6b01SL1VuN3NqWXQ0TStUQUVw?=
 =?utf-8?Q?uXwYytv2a80UEhiWpOFXvGOln?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DEB75039BA8944B87629513762DFE4E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 192e7fe7-2f78-490c-b871-08da9bfb8c55
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 18:03:11.9402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t3Z6vveDPw4JU/FqwsBmH24BRM/YRsFqCsA581vte8zlM5qBx9jSpr0VWNKO9LKdDW0gZ8tLvSfs/kMSoCzhqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR05MB9447
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU2VwIDIxLCAyMDIyLCBhdCAxMjo1MiBBTSwgUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZy
YWRlYWQub3JnPiB3cm90ZToNCg0KPiDimqAgRXh0ZXJuYWwgRW1haWwNCj4gDQo+IE9uIFR1ZSwg
U2VwIDIwLCAyMDIyIGF0IDEwOjQ3OjQzUE0gKzAwMDAsIE5hZGF2IEFtaXQgd3JvdGU6DQo+IA0K
Pj4gRml4IHRoaXMgaXNzdWUgd2l0aCBzbWFsbCBiYWNrcG9ydGFibGUgcGF0Y2guIEluc3RlYWQg
b2YgdHJ5aW5nIHRvIG1ha2UNCj4+IFJDVS1saWtlIGJlaGF2aW9yIGZvciBicF9kZXNjLCBqdXN0
IGVsaW1pbmF0ZSB0aGUgdW5uZWNlc3NhcnkgbGV2ZWwgb2YNCj4+IGluZGlyZWN0aW9uIG9mIGJw
X2Rlc2MsIGFuZCBob2xkIHRoZSB3aG9sZSBkZXNjcmlwdG9yIG9uIHRoZSBzdGFjay4NCj4+IEFu
eWhvdywgdGhlcmUgaXMgb25seSBhIHNpbmdsZSBkZXNjcmlwdG9yIGF0IGFueSBnaXZlbiBtb21l
bnQuDQo+IA0KPiBCZWNhdXNlIG9mIHRleHRfbXV0ZXg7IGluZGVlZC4gTm8gaWRlYSB3aHkgSSBw
dXQgdGhhdCB0aGluZyBvbiB0aGUNCj4gc3RhY2suDQo+IA0KPiBJJ3ZlIGRvbmUgYSBmZXcgbWlu
b3IgZWRpdHMgdG8geW91ciBwYXRjaCwgYnV0IGl0IG90aGVyd2lzZSBsb29rcyBnb29kDQo+IHRv
IG1lLg0KPiANCj4gLS0tDQo+IFN1YmplY3Q6IHg4Ni9hbHRlcm5hdGl2ZTogRml4IHJhY2UgaW4g
dHJ5X2dldF9kZXNjKCkNCj4gRnJvbTogTmFkYXYgQW1pdCA8bmFtaXRAdm13YXJlLmNvbT4NCj4g
RGF0ZTogVHVlLCAyMCBTZXAgMjAyMiAyMjo0Nzo0MyArMDAwMA0KPiANCj4gRnJvbTogTmFkYXYg
QW1pdCA8bmFtaXRAdm13YXJlLmNvbT4NCj4gDQo+IFRoZSB0ZXh0IHBva2UgbWVjaGFuaXNtIGNs
YWltcyB0byBoYXZlIGFuIFJDVS1saWtlIGJlaGF2aW9yLCBidXQgaXQgZG9lcw0KPiBub3QgYXBw
ZWFyIHRoYXQgdGhlcmUgaXMgYW55IHF1aWVzY2VudCBzdGF0ZSB0byBlbnN1cmUgdGhhdCBub2Jv
ZHkgaG9sZHMNCj4gcmVmZXJlbmNlIHRvIGRlc2MuIEFzIGEgcmVzdWx0LCB0aGUgZm9sbG93aW5n
IHJhY2UgYXBwZWFycyB0byBiZQ0KPiBwb3NzaWJsZSwgd2hpY2ggY2FuIGxlYWQgdG8gbWVtb3J5
IGNvcnJ1cHRpb24uDQo+IA0KPiAgQ1BVMCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBDUFUxDQo+ICAtLS0tICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC0tLS0NCj4g
IHRleHRfcG9rZV9icF9iYXRjaCgpDQo+ICAtPiBzbXBfc3RvcmVfcmVsZWFzZSgmYnBfZGVzYywg
JmRlc2MpDQo+IA0KPiAgWyBub3RpY2UgdGhhdCBkZXNjIGlzIG9uDQo+ICAgIHRoZSBzdGFjayAg
ICAgICAgICAgICAgICAgICBdDQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBwb2tlX2ludDNfaGFuZGxlcigpDQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBbIGludDMgbWlnaHQgYmUga3Byb2JlJ3MNCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzbyBzeW5jIGV2ZW50cyBhcmUgZG8gbm90DQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaGVscCBdDQo+IA0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtPiB0cnlfZ2V0X2Rlc2MoZGVz
Y3A9JmJwX2Rlc2MpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGRlc2MgPSBfX1JFQURfT05DRShicF9kZXNjKQ0KPiANCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgaWYgKCFkZXNjKSBbZmFsc2UsIHN1Y2Nlc3NdDQo+ICBXUklU
RV9PTkNFKGJwX2Rlc2MsIE5VTEwpOw0KPiAgYXRvbWljX2RlY19hbmRfdGVzdCgmZGVzYy5yZWZz
KQ0KPiANCj4gIFsgc3VjY2VzcywgZGVzYyBzcGFjZSBvbiB0aGUgc3RhY2sNCj4gICAgaXMgYmVp
bmcgcmV1c2VkIGFuZCBtaWdodCBoYXZlDQo+ICAgIG5vbi16ZXJvIHZhbHVlLiBdDQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFyY2hfYXRvbWljX2luY19ub3RfemVy
bygmZGVzYy0+cmVmcykNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIFsgbWlnaHQgc3VjY2VlZCBzaW5jZSBkZXNjIHBvaW50cyB0bw0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0YWNrIG1lbW9yeSB0aGF0IHdhcyBmcmVlZCBh
bmQgbWlnaHQNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBiZSBy
ZXVzZWQuIF0NCj4gDQo+IEkgZW5jb3VudGVyZWQgc29tZSBvY2Nhc2lvbmFsIGNyYXNoZXMgb2Yg
cG9rZV9pbnQzX2hhbmRsZXIoKSB3aGVuDQo+IGtwcm9iZXMgYXJlIHNldCwgd2hpbGUgYWNjZXNz
aW5nIGRlc2MtPnZlYy4gVGhlIGFuYWx5c2lzIGhhcyBiZWVuIGRvbmUNCj4gb2ZmbGluZSBhbmQg
SSBkaWQgbm90IGNvcnJvYm9yYXRlIHRoZSBjYXVzZSBvZiB0aGUgY3Jhc2hlcy4gWWV0LCBpdA0K
PiBzZWVtcyB0aGF0IHRoaXMgcmFjZSBtaWdodCBiZSB0aGUgcm9vdCBjYXVzZS4NCj4gDQo+IEZp
eCB0aGlzIGlzc3VlIHdpdGggc21hbGwgYmFja3BvcnRhYmxlIHBhdGNoLiBJbnN0ZWFkIG9mIHRy
eWluZyB0byBtYWtlDQo+IFJDVS1saWtlIGJlaGF2aW9yIGZvciBicF9kZXNjLCBqdXN0IGVsaW1p
bmF0ZSB0aGUgdW5uZWNlc3NhcnkgbGV2ZWwgb2YNCj4gaW5kaXJlY3Rpb24gb2YgYnBfZGVzYywg
YW5kIGhvbGQgdGhlIHdob2xlIGRlc2NyaXB0b3Igb24gdGhlIHN0YWNrLg0KDQpMb29rcyBnb29k
IHRvIG1lLiBUaGFua3MgZm9yIGltcHJvdmluZyBteSBwYXRjaC4NCg0KSSBqdXN0IG1hZGUgb25l
IHNtYWxsIG1pc3Rha2UgaW4gY29tbWl0IG1lc3NhZ2UuIEl0IHNob3VsZCBzYXkg4oCcaG9sZA0K
dGhlIHdob2xlIGRlc2NyaXB0b3IgYXMgYSBnbG9iYWzigJ0gaW4gdGhlIGxpbmUgYWJvdmUuDQoN
Ckkgd2lsbCBzZW5kIHYyIHdpdGggeW91ciBjaGFuZ2VzIGFuZCB0aGUgdXBkYXRlZCBjb21taXQg
bWVzc2FnZS4NCg0KVGhhbmtzIGFnYWluLg0KDQo=
