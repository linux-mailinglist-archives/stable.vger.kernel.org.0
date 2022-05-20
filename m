Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD8052F0DC
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 18:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiETQke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 12:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236405AbiETQkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 12:40:32 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2113.outbound.protection.outlook.com [40.107.237.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B061611CB;
        Fri, 20 May 2022 09:40:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrDLByAor4ELNJATAghIYCiQfVsP4TVUc6/XbuRxiB96KldOHG1Rbupm2fmB85KVw2Pn5pbaVNDKpx4AkgSq0hxADoPaBw07YwoUiHmiOOsGVfc9jXeYzx7SA8Pa4w6SvOF3+nkLpJZE+mqLJkNm6WWaovoSAIDlBxVG8fxsUix8E5PljtMRzuxzy9aOv0XgcSwqE0YH5/ZzsvpuNZeOV05oNdvWDl5UgcfOMR1sbiy5pCr41CCIb5Maq7OTLYWZsxmScCwDoAxW6MMFFAIF/dzRL/Xc504t5cuoVmE3FNaK3tV7t2KdpBVbrY8a+H93n41faNj13ROb+qVyNJEsSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwMZD1HqUa//wfrSNQr/8aUbhWWMOzRj3KTSJ25Cgoc=;
 b=X7fB5te9poZ4FSyQ+DxZh7MxM5+G76qlKjDqp45AlHixJp9wrt2A2o8uJzhYgPJyYOBXH2f9AjHlRM18Mh0iSsBD2su3lrFjqi2jIezphxXyrgxnRfMVcCOY5DM9Kpu/9pfzuKMbAIyNpBUSIkFhWTY/TtZkFgIf1cWFz6709ZwtDNpvVdrTC2Oc1bAQ5kzLf7mQJRIi3sZ9RrFDkWoB6c7QsxsNfveVZJw8D7NG3uScaalNK5PKF+GhlMjVLaka0jeBDa3Fq9x2evUrHEQmzM5eMLZBExLFmlRXX+B4wLly/3gWcXqcbqRHz8PSb1bLxrEu6NjUdrAhuPy8Hx3NeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwMZD1HqUa//wfrSNQr/8aUbhWWMOzRj3KTSJ25Cgoc=;
 b=MeOLWkXBuCTQYZVXU+7ug4DZ/MQZk4AqqQNsWBP/x1GA+/lanw+lpnNHdRZ654ofINZMmklx8GB2afMU4sz4qaqOZR3WO/lnXUjpsXDr2+cOKAEfaJd2M+EUT1nq0fhf+haEzCvi2akhSj7lN0xTOfI597RUuEzhIiVi5/WbXzI=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by MWHPR13MB1408.namprd13.prod.outlook.com (2603:10b6:300:121::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7; Fri, 20 May
 2022 16:40:25 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5%6]) with mapi id 15.20.5293.008; Fri, 20 May 2022
 16:40:25 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "linux@stwm.de" <linux@stwm.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR858YHu5BjXv06IiZjQIhNS6q0Zna2AgAAbcoCAAAIRgIAAA5uAgA41xoCAABHLAA==
Date:   Fri, 20 May 2022 16:40:25 +0000
Message-ID: <1792eb49d2a9820bbcf7b240f53158170041da6d.camel@hammerspace.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
         <YnuuLZe6h80KCNhd@kroah.com>
         <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
         <YnvG71v4Ay560D+X@kroah.com>
         <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
         <59118799-0148-41F3-BA03-BB69151B74EE@oracle.com>
In-Reply-To: <59118799-0148-41F3-BA03-BB69151B74EE@oracle.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ec403f9-213c-40aa-01fe-08da3a7f70f7
x-ms-traffictypediagnostic: MWHPR13MB1408:EE_
x-microsoft-antispam-prvs: <MWHPR13MB140804F4C35F1225BFDE6773B8D39@MWHPR13MB1408.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P0oohmqpYru/BqjJGZ646HjEga6Ws51tNRpKoGWHXTteEw4bTJ/iwVpYdl6I8uM41g/GSpRVggu86Y//diOYF8LSHFfSsvhy6wH/J6Ctn4+Z0FOyqmbb5hLTjGRPHEs2PO+gFE3IMoRRdT09U2WhkMunPFzZLVe2dvutyX8R1n2uj6U27TJIg95L9jq/3Q/LMzCD1sSJbqfIJgspwjPrSfutSF7eJMzdEfwxLDwkeCitWulLMsh8/YIWu4quglE8xCznHZ26YGZyRzicgWT6AoyDWg+/4JV7r/BfAjS1pRB0ls/GOHmw1ddRRe70eJNJSBRieYCDpn3N5pTiQ6V4h0aPig8arxz15xQ2MdUUCdOJXXOQ498Vf7lKxjNnnoFRq0rtLnmPTiSr/GngOmZS762wWJ9Fqx30hd9OJbEhaRqfNDVdaBO4kL8iTKV2SKJlZWNDAFtwllMcR8u4Z0HBWUt5BHOgdaxynfY4vd3t+YMkj846EJuR0bYt2W6x7rx9apvCznHAl22eKLJEfDlKGf4J0RCE9BipZxxcnlkdqY2bwUHzSrfrAL7Y+XPTSmsgUToCK7o9SMO9m95mFv/EI8xA4SBh2x3M8i0twsnDKxoqQuvj8LwLe0s/hocPGx4WyVvShK1N9fj30ibZlQ3QSPPkpxCzV81nodv1icJmTolo9OklBiN57Fg7HuxOh4c8ic7+hIEC92b1cRMzJPWbodKgFcxa13Yxi00Ja1NXxl1KxHVe2EzcNNBDpSnXsVatyOnuayyD7jH4/9ACXrqDoIhCRjzvd5SJx5Co0YwPMAIYbQN3gIQ2ExrWQynJjl0w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(366004)(376002)(39840400004)(346002)(83380400001)(6506007)(316002)(186003)(8676002)(2616005)(41300700001)(36756003)(4326008)(8936002)(6512007)(26005)(53546011)(966005)(54906003)(6486002)(508600001)(5660300002)(66476007)(66446008)(64756008)(38070700005)(38100700002)(110136005)(66946007)(76116006)(86362001)(66556008)(122000001)(2906002)(71200400001)(14583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OU1iRUxVUExOaWUwODJYWHlQQThBeGhCMmVEcUV5aTVKeTZHaVJkUmpBOFVE?=
 =?utf-8?B?WWY3VCtmeG9STDBTSEhBTWp6dlRDOVJDVFI1SkYzcjJXeXdDQW0yS0pEWTlh?=
 =?utf-8?B?bzhHWit4MWFoMTNENTYrTE5YTlgwYXFqZXhKMHhQNDBPVTNVZWRVdFZLa2Iy?=
 =?utf-8?B?RXFaandmV2RIZXZiRHZveTNKSVhxSDFmZjlWL0RzQkxZQzlQSmpVaklKV25y?=
 =?utf-8?B?R2J0ZVhmbFVVRFFGSG83TXB5N2VHRTMxdWp2aFV6dHA3cWV2bE5nMXN1YU5t?=
 =?utf-8?B?cjByZmtBQVJhUDMzb3hOZ2FIRloyVUY4Q3JXOUNpRUVKVHljbURzTkU0MDVr?=
 =?utf-8?B?SzNGejZLc1FTQkVxV1BKNmRIY1Z6eTVuWWU3U3BWelloQS93YjZKRUtVVkRM?=
 =?utf-8?B?S3JzQjVZZ1FhNlVCOTBJblVnNGkrWGJsdEZ1SWJOdWE1TmdGQllybGZVaG16?=
 =?utf-8?B?SVZ0eTlwa2ZmQmhxN09QUDhWL3UvQ0YrVklqM0E0bXdMaFpoVSthNUlSUStW?=
 =?utf-8?B?alR0amo2S0FOTFViVmYyai9LZ0JsWkRrVjFLSnh3SVVYVXFhNm9RcVpMRTA4?=
 =?utf-8?B?MnlSTXhrdjg4Y3lRaHJDeTZhRk16M29NdGVvMVpDUEpFUjRmOGFFZEJTOEpH?=
 =?utf-8?B?c1EvRlYxZlZpcjNxYzhPbmEyYUhvdmNFcXZDQ3ZsSnNvMDdyVG5udDdiSklW?=
 =?utf-8?B?SnhDRnk5c2VjajlBTFo4bnhvNzVjaStqZGF5ZTdtV0xuVDZPbm8yY1d1WkEy?=
 =?utf-8?B?eWdUY1dUU3hPdDJxSFd6OVFlRWVEZHp5ZUNPdUM2S1R0WlY4SURVK2F3L2lD?=
 =?utf-8?B?UUxYbHNlM1UzWENKbDJYZVU3TlU0VE1HOTJCNFYzR2JzNTk4cXdtVzVWdW9J?=
 =?utf-8?B?alJkZTJLNVBkZEF3d1ZtSEdTazJsbFA5VkdyaXZDaHRGSjRpbDRva3hLVFRs?=
 =?utf-8?B?UE1HekhMZ1VCN3ZVYnE1NW9iUmFWMXpkVTYrbFdKRDRUZXB1dnRUekxMc2ll?=
 =?utf-8?B?Y0hsNUl1NjltL2Y0TE9veUtWYU1Da1lxOXZ0Q0NqNWp2YmczQ2g2b0tCSVRW?=
 =?utf-8?B?SG1Nb3dUM1lDaGRBTFVPTE9OeFJwMGx4MWs3Tm1DdzZ5YXliMUpnbTJkSi84?=
 =?utf-8?B?bGNoTXZYVHBIQ0FTNCtORTFJVFhSYjNwMGZJeGdaQ3RaejhGclZXMkcrZUx4?=
 =?utf-8?B?M1E5SEV2MGR1aHVEaUpOK0tqemduUlByMndwL1dwRXorV2doYVQwVHNxRC9y?=
 =?utf-8?B?SzVGUGxBdXVhczNkY0d2NkhQK1JMMS9EK1JmbzVKMm5QVy9qRzB4T3hxemhH?=
 =?utf-8?B?MC9oT1lUYzNHem5PSW9PZUFLOUdRVklsdzZLTVZhMlVpbS9KbkxFbm16WEEz?=
 =?utf-8?B?MkpDZ2NsWDEvaWpLTUtkZEQyZHk1QXBPRVN5R3ZYbk1qWlBFTDhnd0RPRGxV?=
 =?utf-8?B?MWlVUktET3hmNG9DbmRqL1lMaVk0Vkg0aUtTVjFlcERCb1kxaWgraTUwK0Rr?=
 =?utf-8?B?VUJsaEN0d2FOc2YwQTZGWE1Tbk0rYkQvOHI0UTZyL3FUemN3WnY0TWw2QUNv?=
 =?utf-8?B?L0lsNWpjYVJ5WnU4dWkwV09uWlF4RHIyaFBzdllqZ3lsTTlvbVk1eXVuc0Zn?=
 =?utf-8?B?bnYvaVV1YTlLTk56THEwOUhRajFKZ2cwWmFpM1RzL2lpZmVNU3N0Zi9MUUJD?=
 =?utf-8?B?T1Q1bkU2STgzZkVGNXFhR3FTZFMwTmRXZ3g0WmpWSGhhSVh5VFRPUGJBbHl5?=
 =?utf-8?B?M2JrR2xUbkxJeTN2MFBUUWdpWVBDVmQrUEJ6VTNJMm9lTjhSbXBtV1FvQzFN?=
 =?utf-8?B?WmhRcEpBdElOUWdkSElJSWdpM0c0VUNkOGpIOTY1ZzJSRXhpdDJ3dzNmalRO?=
 =?utf-8?B?eFJkWVNxb0lhSHp1bTh4bzFvNS9jNGRQelg2dGZIU2hrdHJwTGNSQS9zcWlI?=
 =?utf-8?B?Wkg2c3Z1a3RaSjYrN2lPc3JsWlZTSTQ5SldlVWczMHgzQk54SFd1UXJhNk9W?=
 =?utf-8?B?VmRzK1FNSHhTWlozR1hvV0t2VXo0Y1A0cGxTU1hsTERkZ0ZaVzdRVXJkaVFE?=
 =?utf-8?B?SENMb0REdThtZnNoSEFYbG43dkdGN0ZDZUJaS0orSDhMVUMyaVdMRyt5eVZh?=
 =?utf-8?B?M3RVTEVIOEJvb2NhUFhLcHFFaVhyUE5BYVUwN2JTNURpeC82N1Nwbk4rQWlJ?=
 =?utf-8?B?U0d0cDRSYlM2SUMrYnArY0dLMmJMMFhwZlJ1M1c4emcwaCtHNXkyZUhOMHcr?=
 =?utf-8?B?NDNueWJJbmJkcER1bUU4ZCtna1dtcE9KL1hXcE42VGVNaFBpYjhrNUVONndh?=
 =?utf-8?B?M2Q4TVM4UnpMSzF6bHdTakhxQkY0Rmp3eXYraXFDVkJZdzQwMC8walZrZy9v?=
 =?utf-8?Q?0WThABybZM5ZM8g8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82257D281467914BB8A4D5F7402050EB@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec403f9-213c-40aa-01fe-08da3a7f70f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 16:40:25.6215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AriHbDIbrlyrhisqbUIQDGXB8+kjGJ9E/38RO0MyUM8jm06csLagzHf5vd5gj3RGcVO0dDEPNVKuoe6eF+QTQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1408
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIyLTA1LTIwIGF0IDE1OjM2ICswMDAwLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6
DQo+IA0KPiANCj4gPiBPbiBNYXkgMTEsIDIwMjIsIGF0IDEwOjM2IEFNLCBDaHVjayBMZXZlciBJ
SUkNCj4gPiA8Y2h1Y2subGV2ZXJAb3JhY2xlLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gDQo+ID4g
DQo+ID4gPiBPbiBNYXkgMTEsIDIwMjIsIGF0IDEwOjIzIEFNLCBHcmVnIEtIDQo+ID4gPiA8Z3Jl
Z2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBPbiBXZWQsIE1h
eSAxMSwgMjAyMiBhdCAwMjoxNjoxOVBNICswMDAwLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6DQo+
ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gPiBPbiBNYXkgMTEsIDIwMjIsIGF0IDg6MzggQU0s
IEdyZWcgS0gNCj4gPiA+ID4gPiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdyb3RlOg0K
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IE9uIFdlZCwgTWF5IDExLCAyMDIyIGF0IDEyOjAzOjEzUE0g
KzAyMDAsIFdvbGZnYW5nIFdhbHRlcg0KPiA+ID4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+ID4gSGks
DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IHN0YXJ0aW5nIHdpdGggNS40LjE4OCB3aWUgc2Vl
IGEgbWFzc2l2ZSBwZXJmb3JtYW5jZQ0KPiA+ID4gPiA+ID4gcmVncmVzc2lvbiBvbiBvdXINCj4g
PiA+ID4gPiA+IG5mcy1zZXJ2ZXIuIEl0IGJhc2ljYWxseSBpcyBzZXJ2aW5nIHJlcXVlc3RzIHZl
cnkgdmVyeQ0KPiA+ID4gPiA+ID4gc2xvd2x5IHdpdGggY3B1DQo+ID4gPiA+ID4gPiB1dGlsaXph
dGlvbiBvZiAxMDAlICh3aXRoIDUuNC4xODcgYW5kIGVhcmxpZXIgaXQgaXMgMTAlKSBzbw0KPiA+
ID4gPiA+ID4gdGhhdCBpdCBpcw0KPiA+ID4gPiA+ID4gdW51c2FibGUgYXMgYSBmaWxlc2VydmVy
Lg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBUaGUgY3VscHJpdCBhcmUgY29tbWl0cyAob3Ig
b25lIG9mIGl0KToNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gYzMyZjEwNDEzODJhODhiMTdk
YTU3MzY4ODZkYTRhNDkyMzUzYTFiYiAibmZzZDogY2xlYW51cA0KPiA+ID4gPiA+ID4gbmZzZF9m
aWxlX2xydV9kaXNwb3NlKCkiDQo+ID4gPiA+ID4gPiA2MjhhZGZhMjE4MTVmNzRjMDQ3MjRhYmM4
NTg0N2YyNGI1ZGQxNjQ1ICJuZnNkOg0KPiA+ID4gPiA+ID4gQ29udGFpbmVyaXNlIGZpbGVjYWNo
ZQ0KPiA+ID4gPiA+ID4gbGF1bmRyZXR0ZSINCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gKHVw
c3RyZWFtIDM2ZWJiZGI5NmI2OTRkZDljNmIyNWFkOThmMmJiZDI2M2QwMjJiNjMgYW5kDQo+ID4g
PiA+ID4gPiA5NTQyZTZhNjQzZmM2OWQ1MjhkZmIzMzAzZjE0NTcxOWM2MWQzMDUwKQ0KPiA+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gPiBJZiBJIHJldmVydCB0aGVtIGluIHY1LjQuMTkyIHRoZSBrZXJu
ZWwgd29ya3MgYXMgYmVmb3JlIGFuZA0KPiA+ID4gPiA+ID4gcGVyZm9ybWFuY2UgaXMNCj4gPiA+
ID4gPiA+IG9rIGFnYWluLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJIGRpZCBub3QgdHJ5
IHRvIHJldmVydCB0aGVtIG9uZSBieSBvbmUgYXMgYW55IGRpc3J1cHRpb24NCj4gPiA+ID4gPiA+
IG9mIG91ciBuZnMtc2VydmVyDQo+ID4gPiA+ID4gPiBpcyBhIHNldmVyZSBwcm9ibGVtIGZvciB1
cyBhbmQgSSdtIG5vdCBzdXJlIGlmIHRoZXkgYXJlDQo+ID4gPiA+ID4gPiByZWxhdGVkLg0KPiA+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA1LjEwIGFuZCA1LjE1IGJvdGggYWx3YXlzIHBlcmZvcm1l
ZCB2ZXJ5IGJhZGx5IG9uIG91ciBuZnMtDQo+ID4gPiA+ID4gPiBzZXJ2ZXIgaW4gYQ0KPiA+ID4g
PiA+ID4gc2ltaWxhciB3YXkgc28gd2Ugd2VyZSBzdHVjayB3aXRoIDUuNC4NCj4gPiA+ID4gPiA+
IA0KPiA+ID4gPiA+ID4gSSBub3cgdGhpbmsgdGhpcyBpcyBiZWNhdXNlIG9mDQo+ID4gPiA+ID4g
PiAzNmViYmRiOTZiNjk0ZGQ5YzZiMjVhZDk4ZjJiYmQyNjNkMDIyYjYzDQo+ID4gPiA+ID4gPiBh
bmQvb3IgOTU0MmU2YTY0M2ZjNjlkNTI4ZGZiMzMwM2YxNDU3MTljNjFkMzA1MCB0aG91Z2ggSQ0K
PiA+ID4gPiA+ID4gZGlkbid0IHRyaWVkIHRvDQo+ID4gPiA+ID4gPiByZXZlcnQgdGhlbSBpbiA1
LjE1IHlldC4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBPZGRzIGFyZSA1LjE4LXJjNiBpcyBhbHNv
IGEgcHJvYmxlbT8NCj4gPiA+ID4gDQo+ID4gPiA+IFdlIGJlbGlldmUgdGhhdA0KPiA+ID4gPiAN
Cj4gPiA+ID4gNmI4YTk0MzMyZWU0ICgibmZzZDogRml4IGEgd3JpdGUgcGVyZm9ybWFuY2UgcmVn
cmVzc2lvbiIpDQo+ID4gPiA+IA0KPiA+ID4gPiBhZGRyZXNzZXMgdGhlIHBlcmZvcm1hbmNlIHJl
Z3Jlc3Npb24uIEl0IHdhcyBtZXJnZWQgaW50byA1LjE4LQ0KPiA+ID4gPiByYy4NCj4gPiA+IA0K
PiA+ID4gQW5kIGludG8gNS4xNy40IGlmIHNvbWVvbmUgd2FudHMgdG8gdHJ5IHRoYXQgcmVsZWFz
ZS4NCj4gPiANCj4gPiBJIGRvbid0IGhhdmUgYSBsb3Qgb2YgdGltZSB0byBiYWNrcG9ydCB0aGlz
IG9uZSBteXNlbGYsIHNvDQo+ID4gSSB3ZWxjb21lIGFueW9uZSB3aG8gd2FudHMgdG8gYXBwbHkg
dGhhdCBjb21taXQgdG8gdGhlaXINCj4gPiBmYXZvcml0ZSBMVFMga2VybmVsIGFuZCB0ZXN0IGl0
IGZvciB1cy4NCj4gPiANCj4gPiANCj4gPiA+ID4gPiBJZiBzbywgSSdsbCBqdXN0IHdhaXQgZm9y
IHRoZSBmaXggdG8gZ2V0IGludG8gTGludXMncyB0cmVlIGFzDQo+ID4gPiA+ID4gdGhpcyBkb2Vz
DQo+ID4gPiA+ID4gbm90IHNlZW0gdG8gYmUgYSBzdGFibGUtdHJlZS1vbmx5IGlzc3VlLg0KPiA+
ID4gPiANCj4gPiA+ID4gVW5mb3J0dW5hdGVseSBJJ3ZlIHJlY2VpdmVkIGEgcmVjZW50IHJlcG9y
dCB0aGF0IHRoZSBmaXgNCj4gPiA+ID4gaW50cm9kdWNlcw0KPiA+ID4gPiBhICJzbGVlcCB3aGls
ZSBzcGlubG9jayBpcyBoZWxkIiBmb3IgTkZTdjQuMCBpbiByYXJlIGNhc2VzLg0KPiA+ID4gDQo+
ID4gPiBJY2ssIG5vdCBnb29kLCBhbnkgcG90ZW50aWFsIGZpeGVzIGZvciB0aGF0Pw0KPiA+IA0K
PiA+IE5vdCB5ZXQuIEkgd2FzIGF0IExTRiBsYXN0IHdlZWssIHNvIEkndmUganVzdCBzdGFydGVk
IGRpZ2dpbmcNCj4gPiBpbnRvIHRoaXMgb25lLiBJJ3ZlIGNvbmZpcm1lZCB0aGF0IHRoZSByZXBv
cnQgaXMgYSByZWFsIGJ1ZywNCj4gPiBidXQgd2Ugc3RpbGwgZG9uJ3Qga25vdyBob3cgaGFyZCBp
dCBpcyB0byBoaXQgaXQgd2l0aCByZWFsDQo+ID4gd29ya2xvYWRzLg0KPiANCj4gV2UgYmVsaWV2
ZSB0aGUgZm9sbG93aW5nLCB3aGljaCBzaG91bGQgYmUgcGFydCBvZiB0aGUgZmlyc3QNCj4gTkZT
RCBwdWxsIHJlcXVlc3QgZm9yIDUuMTksIHdpbGwgcHJvcGVybHkgYWRkcmVzcyB0aGUgc3BsYXQu
DQo+IA0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9j
ZWwvbGludXguZ2l0L2NvbW1pdC8/aD1mb3ItbmV4dCZpZD01NTYwODJmNWU1ZDdlY2ZkMGVlNDVj
MzY0MWUyYjM2NGJmZjllZTQ0DQo+IA0KPiANClVoLi4uIFdoYXQgaGFwcGVucyBpZiB5b3UgaGF2
ZSAyIHNpbXVsdGFuZW91cyBjYWxscyB0bw0KbmZzZDRfcmVsZWFzZV9sb2Nrb3duZXIoKSBmb3Ig
dGhlIHNhbWUgZmlsZT8gaS5lLiAyIHNlcGFyYXRlIHByb2Nlc3Nlcw0Kb3duZWQgYnkgdGhlIHNh
bWUgdXNlciwgYm90aCBsb2NraW5nIHRoZSBzYW1lIGZpbGUuDQoNCkNhbid0IHRoYXQgY2F1c2Ug
dGhlICdwdXRsaXN0JyB0byBnZXQgY29ycnVwdGVkIHdoZW4gYm90aCBjYWxsZXJzIGFkZA0KdGhl
IHNhbWUgbmYtPm5mX3B1dGZpbGUgdG8gdHdvIHNlcGFyYXRlIGxpc3RzPw0KDQo+IC0tDQo+IENo
dWNrIExldmVyDQo+IA0KPiANCj4gDQoNCi0tIA0KVHJvbmQgTXlrbGVidXN0DQpMaW51eCBORlMg
Y2xpZW50IG1haW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9uZC5teWtsZWJ1c3RAaGFtbWVyc3Bh
Y2UuY29tDQoNCg0K
