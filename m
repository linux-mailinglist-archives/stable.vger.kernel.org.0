Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2675B4F5E
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 16:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIKOIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 10:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiIKOId (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 10:08:33 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2108.outbound.protection.outlook.com [40.107.100.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034DC389;
        Sun, 11 Sep 2022 07:08:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3S4edqhRs6ImGm2VgJRsnM5y99cJPihb54IuKByUB3++TKjKy7PeWjkT8IinlCjDp1oX5P4roWwMHY0L/ivmwtaD1WgbSn+OCyAvfnbyuP3Mv8xDu5zr7RnM6udIAXwGeDcqihuoV+iwIXzkeOINy/xyPBM7WrEgiHXlokWg3S8mZjrq2YTMFeXOJfMu10yVltRhHuVZL9K1ZkFLHaM1m9SCl9d6PN6WOAHObbTRb00HWgOsaD+uX6L59ArS64nvVBP5MIrtLSijjD1gHB9hTydnCGnlcy21hKkqkrVd11+w/BhLmz1yOInZxFYGekejCa8cPDlHHqLpNyirUeTJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JVpWAA1OEFl4GjR6hYprwj2sBC/EY5/kOlCryvUPCd0=;
 b=Z79Tal6+A+SCzb/ZNfXU/ylSboqCs7pvdAsWJLd+UHoxSA98CaIb6LdJmhqxh55OPasRKZdMednfYQtKQar66sEP7MlSC3mIoFM8VDbwo+G75t0cVGilQoqKlBYLeseY0GocLyC4ZTJxkZN8rSspvFJkoU9Db61rcUKpQpglAuy5WjlD9nrOLGiR6+HXYSjVhvRGNypOHv5CuW6DBm3wR2syhgA3MHMTMoKArSXQyjJ1pepwL2ehGWTHSdzac+A3WpXJ+9pDmNgnjQqQVULGBVHzLGaddyctL9iU5H7XWU9j4ywHmJip0Xe09WIYWkWrAnfar7hLP5fzCPYoQs6zMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVpWAA1OEFl4GjR6hYprwj2sBC/EY5/kOlCryvUPCd0=;
 b=b/aF5oKEIBbfh2B9OnkWxoEE2rXanJpKsjM94yZnSzy4lIC9KJxwwCM4pg+l71D78QbacmDVYSRMDyECyYiXTswFvqZBk3kdTjM2kc7tkDzw9Tlj9bhEOZN9Uhdz0wrXw0bP4SmzIRlbOVslrdErf3bsMAbwzRvW1KkgbJPvH40=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by MW5PR13MB5535.namprd13.prod.outlook.com (2603:10b6:303:196::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.9; Sun, 11 Sep
 2022 14:08:28 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::f1c7:62d0:a63d:f5ca]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::f1c7:62d0:a63d:f5ca%3]) with mapi id 15.20.5632.012; Sun, 11 Sep 2022
 14:08:28 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "neilb@suse.de" <neilb@suse.de>,
        "erosca@de.adit-jv.com" <erosca@de.adit-jv.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>
CC:     "mrodin@de.adit-jv.com" <mrodin@de.adit-jv.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "roscaeugeniu@gmail.com" <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 4.14 022/284] SUNRPC: avoid race between mod_timer() and
 del_timer_sync()
Thread-Topic: [PATCH 4.14 022/284] SUNRPC: avoid race between mod_timer() and
 del_timer_sync()
Thread-Index: AQHYUyKKj/7AQaJJ/kGOCmyKXNbhzK3U5WYAgACwhYCABXvrAIAAF8+A
Date:   Sun, 11 Sep 2022 14:08:28 +0000
Message-ID: <088bae077d9870d2845e14516253988b2803c8f3.camel@hammerspace.com>
References: <20220418121210.689577360@linuxfoundation.org>      ,
 <20220418121211.327937970@linuxfoundation.org> ,
 <20220907142548.GA9975@lxhi-065>
         <166259870333.30452.4204968221881228505@noble.neil.brown.name>
         <1c8cdc749fa34486abd435a15ec201fc@AcuMS.aculab.com>
In-Reply-To: <1c8cdc749fa34486abd435a15ec201fc@AcuMS.aculab.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR13MB5084:EE_|MW5PR13MB5535:EE_
x-ms-office365-filtering-correlation-id: 48357515-53a5-4d9d-b7d2-08da93ff1995
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WWHEqDrB5W0wlVqa/t/VKDTcport8uMQujg2UjUBOvZPXkOqEO5hS/FxADsvY80NoPeMrD4+G+kWjsbjb7S5jB9UK4f2Q/Q1biFmR8HxTGTFfL65fmHdTz6BTnr20RHwLzkCsGyPjhFSw/DOvZqtdJmULf3M+NxvTo92xzZVpE/5TCicXLGkOpFhhFze5K+Mt/AsjCCwFy0OfGUiTfIMuaEYT7gcBJ7d/Pbds2y6Ciq25cmZYkgly9YEv49W65xzjqhKQNnesm1+TVMXx33/r88We4jMAMGkDjxuBvvc7TLNfUZQi+f38hAEBsHwlXvn4aqPh5oFZiO6b/svbpcgXnHN+ZmLhiy82jWRTaw4lRHn+0sxAc+9FizRBS5oTCZFgTW+w0B4XFtxv+byBrxXvkxTUo7fSlPFaVJWctFkLb6FJhoE5EIZs91I6Dw2hBW8o4V2RSYya2V9U9XMwvz98RhVueaKVAWHDbe8QjrKNGkPp0h7qabS3poMdFnWF5tqRq0X+HWcrsGNusACGD0uH28mYHGKKXjcZCMYRYZnUxvrTChvthT1AIrzPOae7jJjpptUzZ1+/uE0IvN9ImgfFW7FhH/zOXeA0LqMCUMciXq16pOI5H/dSH8++s/EddD35dx3KJ6KOwhxf34UfZn7tOCr3WdVRXWgcfpwqu+xgUTVuiqqD5OzjprbLCBOWy140paCB7SIUkaXmLrkiJTQSvaw2uUATuajG1+j3oVzIkB24RPTLCwiApSJ4agkPaGIyLtIe4Npp45sQ5VS1s+iEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(366004)(346002)(376002)(39830400003)(8936002)(6506007)(83380400001)(316002)(478600001)(110136005)(54906003)(26005)(36756003)(38070700005)(86362001)(6512007)(5660300002)(122000001)(66946007)(66556008)(76116006)(66446008)(66476007)(64756008)(2906002)(8676002)(41300700001)(4326008)(71200400001)(38100700002)(6486002)(2616005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aE9NOVNZa3oxTXk4VFpoK2NneHl5REVBbnp2a3lZWEI0NnNiZFdLcHRORWpQ?=
 =?utf-8?B?T21oeEZVa2tqQlFScWZRc1ZBR29zcjkvWXI4dldxNFk2NU1tZjUwc0dlTHp6?=
 =?utf-8?B?TVhCM0NYYmNNSmtjanhUa0ZYNHVIZE5wWUgrdlVNQ0R4WVRwNktvbkpLaFgy?=
 =?utf-8?B?emZsdnVvdFAvRmZuTyt2bzkxeTQ1WnhBbEZsc2ZBYWF0a2lHRWtMdWRlK2pJ?=
 =?utf-8?B?Y1dvWDB6RFo3YTAxNGVTOTdTVDc5aTFBejZESUR0L3ljRU5wWFFmQVJMYk5U?=
 =?utf-8?B?NGNEOERGcmkrbDVVeTBqMlZZclQ4elAvRlc0NnlrRE9VaWZhdS9YR2g0RzY4?=
 =?utf-8?B?Vkc5T3dFR0ZZOFBtZ0dNUzEyTHhKSjlvb3BTaDFKalp1eTh3M1AzSUgwYkRL?=
 =?utf-8?B?UFg1Q1puRmhRZFFnVDVTNTNZNk12djBPUDQ5YmJjMkl2dE13YW1VNmtqY2ND?=
 =?utf-8?B?ZzZkZFhpaTVjT205cmJ6enJkZmd2aTU4YzBuZUs1RFJvUnJIOHZDSVc3YnJn?=
 =?utf-8?B?NW5zYjdVMko0R3FnTkxZS0VOZ2ZhU3NORXhlL2l5N1ZIaUxEQkVSSGt5akNB?=
 =?utf-8?B?anUwanhVdFdxYnd2cnYyay9xNkw3UDBtRC9ITVJrOGhSSGpHVWRhOFI4QmRu?=
 =?utf-8?B?VFM4djlWSnhWK3ErQmVrSGlOd3dHMCtiNW9CaUxGY2pJODFOWWtGSmM5NHBV?=
 =?utf-8?B?RDBlR0NBUlBoNk1ObTZpdVFEVS95aHJuVVlITVB3dWFyc0dWZ3YrcVpjOVI1?=
 =?utf-8?B?TDBFczFjQXpwUFB2SWljR1ZzZldpYUh6eDFPN3RPalpzeHc0YlRqNjluYmdr?=
 =?utf-8?B?a3pEVGlYVnk4VUUyOVdlb2srRHpURFdpeHlFa25HUCtDVlZVdzIyMzJTcElZ?=
 =?utf-8?B?MTlFYU1sS2hRNk1veCszVHg1N0pLY0FWNFMranhnTjJzUlVUTzBnZks0RzRx?=
 =?utf-8?B?ek9mNWpscExDRlY5UFY2a1hNU3QvNkZmUTVDaFBkRUVud2RSRlZqMXFhZ0l1?=
 =?utf-8?B?NmRlelJSdWErQ0E5c3ViQXhTV3RvdHgzVElhdXhqZ3ZLa21tQ2NDVWFWSzlF?=
 =?utf-8?B?aFBiUGowU2k5WUg2V1ZEMVRpWVFNWGhKSFFTZXYxeXZQemNZdG5BcUoxT3Bu?=
 =?utf-8?B?T1ZtM2h4R1hRUElCSW1USW5WWGJiMW5BVnorYjNaMVZiSnFsMzJYTDl1OTd2?=
 =?utf-8?B?WHdTckRqdGVnbGlmWEp0MGJuNWhRc3JCaW9na3l3bnJ1UVhiY2RwclBLTXR4?=
 =?utf-8?B?TGVaZys3QkRoS21kU1ZNK09tNEUyTXUzU0w3ditaL25RSDRTOTZxK2RPNEla?=
 =?utf-8?B?ZTdodmV2NDdja1BZeitqRWF5Sms5Z0tiTkthU1B6enFabGRnZ3c5UUd6L1Y5?=
 =?utf-8?B?eGg2ZWFZOVRZbjVwOHNnNEFHZ2x3a2pKcWpJNkxhbkhqRFRpMWNndjY4dFNu?=
 =?utf-8?B?d2oxV2tWVnVaVWdlL3M4Y0Y0SlQweUJMVzk1M1lUMVFENHFlM1lJbmFDbloz?=
 =?utf-8?B?SENtZ0RPSlFsUTNRelk1RDNjdDY1Y1hxajdwaExuNkhmWUpCTldla3VuSTVO?=
 =?utf-8?B?bnIzVWc0ck85eUdBaUJZMy81VDV3MHUxVWFJWmh1NnJ2RjBqWHpuRENtSnFX?=
 =?utf-8?B?Z2w2TWsvajhpclA1bTVlTkR6SHN2MlNrb3VUdzE2TWQwNzFkcVk0NEFySFdT?=
 =?utf-8?B?blNGSlpRU0prVFk4UVhZNmJjRUlkWjQxb1doaDcxeC9aNHlVUWlrWk1IVUJo?=
 =?utf-8?B?c3R5bWFZbFJYeWNZZHVDUEptUnpXdElhdmdLYWFTSUlJNlRqS3R3TEdKQThR?=
 =?utf-8?B?WVczcEp6SGFZN0t0U3hmWlc1anlBZEJMWm1vTWpqTXlsZ3gyU0tBTzJhdmFs?=
 =?utf-8?B?U21xd1FQWDFqZDNaVWZnczBNUW1mc3o2WlV0YzhSWERwdGFNeW5rODg3c3lP?=
 =?utf-8?B?WWxDUmQyNmpNTWdtSG5qVkIxLzhwTC9NMkpPd2Y2VGlwK2Z2czgwQUlVZ2xP?=
 =?utf-8?B?cXMvR24vaTR2U1dqNU5QOEZHQTdweW1BenJ0eHlIa0tuKzlGNkxUbmZGaVVz?=
 =?utf-8?B?R215MTc1d05jQ3RrM2c2K09iZFNtaUh3cE9lTmtjdDFxM0tFSHZsNWkzazdD?=
 =?utf-8?B?S2hOVzg0blJ3MEdaTXBmZWY4L3EzdnlOcjdLaXNzWi9yUHhsckplS1ZRMjU2?=
 =?utf-8?B?eEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68878298A54437419382DEF2918B9D5F@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5535
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU3VuLCAyMDIyLTA5LTExIGF0IDEyOjQzICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+
IEZyb206IE5laWxCcm93bg0KPiA+IFNlbnQ6IDA4IFNlcHRlbWJlciAyMDIyIDAxOjU4DQo+ID4g
DQo+ID4gT24gVGh1LCAwOCBTZXAgMjAyMiwgRXVnZW5pdSBSb3NjYSB3cm90ZToNCj4gPiA+IEhl
bGxvIGFsbCwNCj4gPiA+IA0KPiA+ID4gT24gTW8sIEFwciAxOCwgMjAyMiBhdCAwMjoxMDowMyAr
MDIwMCwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiA+ID4gPiBGcm9tOiBOZWlsQnJvd24g
PG5laWxiQHN1c2UuZGU+DQo+ID4gPiA+IA0KPiA+ID4gPiBjb21taXQgMzg0OGU5NmVkZjQ3ODhm
NzcyZDgzOTkwMDIyZmE3MDIzYTIzM2Q4MyB1cHN0cmVhbS4NCj4gPiA+ID4gDQo+ID4gPiA+IHhw
cnRfZGVzdG9yeSgpIGNsYWltcyBYUFJUX0xPQ0tFRCBhbmQgdGhlbiBjYWxscw0KPiA+ID4gPiBk
ZWxfdGltZXJfc3luYygpLg0KPiA+ID4gPiBCb3RoIHhwcnRfdW5sb2NrX2Nvbm5lY3QoKSBhbmQg
eHBydF9yZWxlYXNlKCkgY2FsbA0KPiA+ID4gPiDCoC0+cmVsZWFzZV94cHJ0KCkNCj4gPiA+ID4g
d2hpY2ggZHJvcHMgWFBSVF9MT0NLRUQgYW5kICp0aGVuKg0KPiA+ID4gPiB4cHJ0X3NjaGVkdWxl
X2F1dG9kaXNjb25uZWN0KCkNCj4gPiA+ID4gd2hpY2ggY2FsbHMgbW9kX3RpbWVyKCkuDQo+ID4g
PiA+IA0KPiA+ID4gPiBUaGlzIG1heSByZXN1bHQgaW4gbW9kX3RpbWVyKCkgYmVpbmcgY2FsbGVk
ICphZnRlcioNCj4gPiA+ID4gZGVsX3RpbWVyX3N5bmMoKS4NCj4gPiA+ID4gV2hlbiB0aGlzIGhh
cHBlbnMsIHRoZSB0aW1lciBtYXkgZmlyZSBsb25nIGFmdGVyIHRoZSB4cHJ0IGhhcw0KPiA+ID4g
PiBiZWVuIGZyZWVkLA0KPiA+ID4gPiBhbmQgcnVuX3RpbWVyX3NvZnRpcnEoKSB3aWxsIHByb2Jh
Ymx5IGNyYXNoLg0KPiA+ID4gPiANCj4gPiA+ID4gVGhlIHBhaXJpbmcgb2YgLT5yZWxlYXNlX3hw
cnQoKSBhbmQNCj4gPiA+ID4geHBydF9zY2hlZHVsZV9hdXRvZGlzY29ubmVjdCgpIGlzDQo+ID4g
PiA+IGFsd2F5cyBjYWxsZWQgdW5kZXIgLT50cmFuc3BvcnRfbG9jay7CoCBTbyBpZiB3ZSB0YWtl
IC0NCj4gPiA+ID4gPnRyYW5zcG9ydF9sb2NrIHRvDQo+ID4gPiA+IGNhbGwgZGVsX3RpbWVyX3N5
bmMoKSwgd2UgY2FuIGJlIHN1cmUgdGhhdCBtb2RfdGltZXIoKSB3aWxsIHJ1bg0KPiA+ID4gPiBm
aXJzdA0KPiA+ID4gPiAoaWYgaXQgcnVucyBhdCBhbGwpLg0KPiA+ID4gPiANCj4gPiA+ID4gQ2M6
IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogTmVpbEJyb3du
IDxuZWlsYkBzdXNlLmRlPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBUcm9uZCBNeWtsZWJ1c3QN
Cj4gPiA+ID4gPHRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20+DQo+ID4gPiA+IFNpZ25l
ZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+
DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiDCoG5ldC9zdW5ycGMveHBydC5jIHzCoMKgwqAgNyArKysr
KysrDQo+ID4gPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQ0KPiA+ID4gPiAN
Cj4gPiA+ID4gLS0tIGEvbmV0L3N1bnJwYy94cHJ0LmMNCj4gPiA+ID4gKysrIGIvbmV0L3N1bnJw
Yy94cHJ0LmMNCj4gPiA+ID4gQEAgLTE1MjAsNyArMTUyMCwxNCBAQCBzdGF0aWMgdm9pZCB4cHJ0
X2Rlc3Ryb3koc3RydWN0IHJwY194cHJ0DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4g
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoHdhaXRfb25fYml0X2xvY2soJnhwcnQtPnN0YXRlLCBYUFJU
X0xPQ0tFRCwNCj4gPiA+ID4gVEFTS19VTklOVEVSUlVQVElCTEUpOw0KPiA+ID4gPiANCj4gPiA+
ID4gK8KgwqDCoMKgwqDCoMKgLyoNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgICogeHBydF9zY2hl
ZHVsZV9hdXRvZGlzY29ubmVjdCgpIGNhbiBydW4gYWZ0ZXINCj4gPiA+ID4gWFBSVF9MT0NLRUQN
Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgICogaXMgY2xlYXJlZC7CoCBXZSB1c2UgLT50cmFuc3Bv
cnRfbG9jayB0byBlbnN1cmUgdGhlDQo+ID4gPiA+IG1vZF90aW1lcigpDQo+ID4gPiA+ICvCoMKg
wqDCoMKgwqDCoCAqIGNhbiBvbmx5IHJ1biAqYmVmb3JlKiBkZWxfdGltZV9zeW5jKCksIG5ldmVy
IGFmdGVyLg0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqAgKi8NCj4gPiA+ID4gK8KgwqDCoMKgwqDC
oMKgc3Bpbl9sb2NrKCZ4cHJ0LT50cmFuc3BvcnRfbG9jayk7DQo+ID4gPiA+IMKgwqDCoMKgwqDC
oMKgwqBkZWxfdGltZXJfc3luYygmeHBydC0+dGltZXIpOw0KPiA+ID4gPiArwqDCoMKgwqDCoMKg
wqBzcGluX3VubG9jaygmeHBydC0+dHJhbnNwb3J0X2xvY2spOw0KPiA+IA0KPiA+IEkgdGhpbmsg
aXQgaXMgc3VmZmljaWVudCB0byBjaGFuZ2UgdGhlIHRvIHNwaW5feyx1bn1sb2NrX2JoKCkNCj4g
PiBpbiBvbGRlciBrZXJuZWxzLsKgIFRoZSBzcGlubG9jayBjYWxsIG5lZWQgdG8gbWF0Y2ggb3Ro
ZXIgdXNlcyBvZg0KPiA+IHRoZQ0KPiA+IHNhbWUgbG9jay4NCj4gDQo+IEV2ZXJ5IHRpbWUgSSBz
ZWUgdGhpcyBwYXRjaCBpdCBsb29rcyB3cm9uZy4NCj4gWW91IG5lZWQgc29tZXRoaW5nIHRvIHN0
b3AgdGhlIGNvZGUgdGhhdCBpcyBjYWxsaW5nIG1vZF90aW1lcigpDQo+IHJ1bm5pbmcgYWZ0ZXIg
dGhlIHNwaW5fdW5sb2NrKCkuDQo+IE5vdyBpdCBtaWdodCBiZSB0aGF0IHRoZXJlIGlzIHNvbWUg
b3RoZXIgc3RhdGUgdGhhdCBpcw0KPiBhbHJlYWR5IHNldCAtIGluIHdoaWNoIGNhc2UgeW91IG9u
bHkgbmVlZCB0byB3YWl0IGZvciB0aGUNCj4gc3Bpbl9sb2NrIHRvIGJlIHJlbGVhc2VkIC0gc2lu
Y2UgaXQgY2FuJ3QgYmUgb2J0YWluZWQgYWdhaW4NCj4gKHRvIHN0YXJ0IHRoZSB0aW1lcikuDQo+
IA0KPiBTbyBJJ2QgZXhwZWN0IHRvIHNlZToNCj4gwqDCoMKgwqDCoMKgwqDCoHNwaW5fbG9jaygp
Ow0KPiDCoMKgwqDCoMKgwqDCoMKgaWYgKG5vdGhpbmdfc2V0X2VhcmxpZXIpDQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeHBydC0+ZGVzdHJveWluZyA9IDE7DQo+IMKgwqDCoMKg
wqDCoMKgwqBzcGluX3VubG9jaygpDQo+IMKgwqDCoMKgwqDCoMKgwqBkZWxfdGltZXJfc3luYygp
Ow0KPiANCj4gTG9va2luZyBhdCB0aGUgY29kZSAoZm9yIGEgY2hhbmdlKSBpcyBsb29rcyBldmVu
IHdvcnNlLg0KPiANCj4gZGVsX3RpbWVyX3N5bmMoKSBpc24ndCBhbnl3aGVyZSBuZWFyIGVub3Vn
aC4NCj4gQWxsIHRoZSB0aW1lciBjYWxsYmFjayBmdW5jdGlvbiBkb2VzIGlzIHNjaGVkdWxlIHNv
bWUgd29yay4NCj4gU28geW91IGFsc28gbmVlZCB0byB3YWl0IGZvciB0aGUgd29yayB0byBjb21w
bGV0ZS4NCj4gDQo+IENoYW5naW5nIGl0IGFsbCB0byB1c2UgZGVsYXllZF93b3JrIG1pZ2h0IHJl
ZHVjZSB0aGUgcHJvYmxlbXMuDQo+IA0KPiBPaCwgYW55IHVzaW5nIHByb3BlciBtdXRleC9sb2Nr
cyBpbnN0ZWFkIG9mIHdhaXRfb25fYml0X2xvY2soKS4NCg0KSSBzdWdnZXN0IHlvdSByZWFkIHRo
ZSBjb2RlIG9uZSBtb3JlIHRpbWUsIHRoZW4uDQoNCkhvbGRpbmcgdGhlIGJpdGxvY2sgWFBSVF9M
T0NLRUQgdW50aWwgdGhlIHRyYW5zcG9ydCBpcyBjb21wbGV0ZWx5DQpkZXN0cm95ZWQgaXMgd2hh
dCBlbnN1cmVzIHRoYXQgbm90aGluZyB3aWxsIGV2ZXIgc2NoZWR1bGUgeHBydC0+dGltZXINCmFn
YWluIGZvciB0aGF0IHRyYW5zcG9ydC4gVGhpcyBwYXRjaCB3YXMgbmVlZGVkIGluIG9yZGVyIHRv
IGZpeCBhIG1pbm9yDQpyYWNlIHdoZW4geHBydF91bmxvY2tfY29ubmVjdCgpIG5lZWRzIHRvIGZp
cnN0IHJlbGVhc2UgWFBSVF9MT0NLRUQNCmJlZm9yZSBzY2hlZHVsaW5nIHRoZSB4cHJ0LT50aW1l
ci4NCg0KLi4uYW5kLCBuby4gV2UncmUgbm90IGdvaW5nIHRvIGJyZWFrIG91ciBhaW8gbW9kZWwg
YnkgcmVwbGFjaW5nDQpYUFJUX0xPQ0tFRCB3aXRoIGEgbXV0ZXguIFdlIG9wdGltaXNlIGZvciBz
cGVlZCBvZiBwcm9jZXNzaW5nIG9mIHRoZQ0KUlBDIG1lc3NhZ2UgcXVldWUsIGFuZCBtdXRleGVz
IHdvdWxkIGJyZWFrIHRoYXQgYnkgZm9yY2luZyB0aGUNCndvcmtxdWV1ZSB0aHJlYWQgdG8gc2xl
ZXAgaW5zdGVhZCBvZiBqdXN0IHJlLXF1ZXVpbmcgdGhlIG1lc3NhZ2UgdW50aWwNCnRoZSBsb2Nr
IGlzIGF2YWlsYWJsZSBhcyB3ZSBkbyBub3cuIFRoZSBwcmljZSBvZiBoYXZpbmcgdG8gdXNlDQp3
YWl0X29uX2JpdF9sb2NrKCkgaW4gdGhlIGZpbmFsIHNodXRkb3duIHBhdGggaXMgd2VsbCB3b3J0
aCBpdC4NCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5l
ciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
