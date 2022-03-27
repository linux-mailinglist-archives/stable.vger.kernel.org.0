Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4244E8865
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 17:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbiC0PWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 11:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiC0PWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 11:22:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2110.outbound.protection.outlook.com [40.107.243.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1231F13E96;
        Sun, 27 Mar 2022 08:20:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcISe3gmizKT5Zf/oXlawRfCMNJehFzkryWgfuPuYt14OdSm1ItWJ3JHvcCjl1o3N0oYjzS0PIxzfGwGkaldt0qU33bnx6CbUPK6zc3Tf1jO+5itaYwDT6wnJxnv+iUCt0GR98jdZprYuhFFJ2A+fvM0w39YBESEyC/XgxXLwIQHDk2EeFlRdmeLzSG5jCoIEApDEqIm+SmMW5M/CtjFFdjnzfn9KWSpdc29vj/vL1tDx++w/4Wh37uMZeCY2gcYNw/c4TgO//s0DvLk0MVq6KM49aye9PzTvzZ0MShKY2DjrTUc9Gh2CpRP/E2JB6IHMPzzhKruss8xYYDwcJ8pAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0Y5THeK7aQhIlC6FNTqAm0JigJj7wNGfQ16RIxb4I4=;
 b=ccucpuJr2Wy3i6hM2T/8foonHbxy7BLPkrDdnaGnaIutxkFbKni5xwAZPhhIefFFcdimciPNfideTZ+YDt+iK/ssJz3gBH59UEQ5pR5mPHwkFOdbEBShcn8VddyMCcOFaNOG0WV0lnW1ojUpL3mlSRPO/emwCRHvkYK/ZG6gVCwxZPE2lq4Ak50b0IA54ANcnxoKOMie23rIvUJqSX2qlcmyD8KjBEe58AaK+tmME3PLck6hslGv4Z4aBzzkERL2bsMCI7GBKZ5HqPLGdd8eqRbCQ5w1O2hFTSpMAGJ3g7V/Gn6cCxJBKGipcDvpcdigKPGhYgMGUnSs8uQ8dBknfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0Y5THeK7aQhIlC6FNTqAm0JigJj7wNGfQ16RIxb4I4=;
 b=ZRt9j0bccjW2eW1KXazkDfEVIGQmK5m3y3KNjR/yxzf4YrOiO0u7dg3W64KTZh6VNQAoOvyAJMzG/JyCg2NwfuO3pMbpknIkstAYW0zHWcPPpQkiZS2NXUEy4okJlqd2YCM8PMQu2uXB7AyjFKITeQuFrmI2KDZQvgNrTlXCA6M=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by BN6PR13MB1825.namprd13.prod.outlook.com (2603:10b6:404:144::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.15; Sun, 27 Mar
 2022 15:20:43 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006%7]) with mapi id 15.20.5123.015; Sun, 27 Mar 2022
 15:20:42 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "anna@kernel.org" <anna@kernel.org>,
        "xiam0nd.tong@gmail.com" <xiam0nd.tong@gmail.com>
CC:     "bhalevy@panasas.com" <bhalevy@panasas.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bharrosh@panasas.com" <bharrosh@panasas.com>
Subject: Re: [PATCH] nfs: callback_proc: fix an incorrect NULL check on list
 iterator
Thread-Topic: [PATCH] nfs: callback_proc: fix an incorrect NULL check on list
 iterator
Thread-Index: AQHYQbEIv3QbmQbNHEGPE23RAen3xqzTWQ6A
Date:   Sun, 27 Mar 2022 15:20:42 +0000
Message-ID: <436766b6fb5f3ec513629d4fa0888b77c65cfa16.camel@hammerspace.com>
References: <20220327080230.12134-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220327080230.12134-1-xiam0nd.tong@gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff563f5f-609b-4227-d272-08da10055be8
x-ms-traffictypediagnostic: BN6PR13MB1825:EE_
x-microsoft-antispam-prvs: <BN6PR13MB1825E65D631953E1541C066BB81C9@BN6PR13MB1825.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: csgfWO6YL1vjjJjuxu8KEax3vWkMrbd756BNZepMY7MxZwOagMDu6nMLINBFfd152MKcXzFuXH2UcY2sbB0a9lAmEyeGTPRrly7GyYuzvR2aFE6a7qjTsrzTsv5mWfXo2qKs5DLL5/jP8sEKyeccQ4K81fvNg3o+FTl1zgaOX5hiT6j6pWPLbrkAc1Jsml0fZ53Fmar4/jtVxodMo7+fwTRGDxzII1bwDFQfvns42rdqljmYslPTPR2blvJybobEmnBevtwj1zDHEJAUhh0HLI8aCZR4RiFQizr/5I2cRv18hbVTPA0GQJT6Tm11aq1KxGukToHlK05dHabvW836znZKCMrNzfhDyGf0MR0jWWK8vZ+fa9MpqJvVrTnXrexqG8/U3YIIh3zT6XaS4S0dMG72UtU09hJ2hHO1ww2RNT3ru2+DTp9KHBstdtJoqmE1WHHJCOpl3B6BNLTreyGf7WL1vd1d2Kg4zcW451Ar3vGk5v8hxzrLuvgZCNipjfaipiS8C4hURiHowLZndRN10RBo9qmleRVNuwo0fPzz+w9p+YK0UimsrGR/rQ8xCuPAS3g7T+PloI8PoEKbP/nX5MK7sVX0Y6gbJXrNvhiU+y+7gF/mnb5TWjZyc2+HO8kwjaDXP3NhovubFATEUiLEaNK4yfKto3zeoYL0BbAy8UIDJxfdernRFIsVgSVrka6fK5ksA3VvI5P8lPDjtoDAvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(8936002)(5660300002)(6512007)(2906002)(6486002)(2616005)(110136005)(508600001)(316002)(71200400001)(26005)(186003)(6506007)(54906003)(38070700005)(86362001)(38100700002)(66556008)(83380400001)(64756008)(4326008)(8676002)(76116006)(66476007)(66446008)(66946007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzQ5L01tL1JFcFJDMjNMVm8xTVMrY0dDblk5L1ZXSWF3ZlZ0QVpscVJ0bThF?=
 =?utf-8?B?OEZEYjdGOGxzc2laNFFtaitid2tvWWFWTC9EaWNsZWY0endENFdCZEZUenBq?=
 =?utf-8?B?VTFpMmJMb1c3Zk14S1ptdmd0T2hiNUVYLytaamtHWkszbHlPa2RPaWZQUnVZ?=
 =?utf-8?B?eFlkSHB5endsRkk1Ry8vSWsxcU0vUXZnSmZkSHI4RnRjdk14WWVQZlAzKzhV?=
 =?utf-8?B?UE9ZWndnenJyNnFPS1h1Q1hjRVVWY0lGMXdOQlRCWDBvQmJiYXh1NlhCRHJ0?=
 =?utf-8?B?b0JDbVErUXdHMlI0djJ4Mk50WG1kTk41SFU5RFlVZmtJVGtodW80SExHZ0No?=
 =?utf-8?B?Tm1teG9IbkF6ZWFoNU45ME15dW9reFF2WDJra2I2emt6dldWZnJLTEhTNVBB?=
 =?utf-8?B?Y2VDb2s2OWZoaWphems4OFRSSWlmSGljUmVhWlNjS0hBdkhsVDc4RU41VEI2?=
 =?utf-8?B?TjJTOHIyTm5sYUlYUFluM3FnV1Y1M1RxVFVFMTVUMTArWks4WGhSQ24wL0Vy?=
 =?utf-8?B?bE9kY3VmUkZuWE40MjN5eW1hNkQrdHYza216UVZGbkNVU2dhcGxqaHdnaHFB?=
 =?utf-8?B?K0RISDRWWHMwTTlNQ2pjQW1vUUh3aDk5ZHpIZkdNSEtKcERiZkZUMDh0SUF0?=
 =?utf-8?B?YUE4T0VxMk8rLytqN0tvUjV6a2xGR3NsMVhNakNVMXNwL2laTlpJajJrWmFm?=
 =?utf-8?B?RWxUMmo2V3gvNVMrak40Z3o5Ry9oSzlJQXVjK1RwRVhoMTkwWTZFNTdHbk5W?=
 =?utf-8?B?VEQ5Y3RwVGxkY0UwSy9CY3ZLTzFodVNnQng4NmNIaXVzWmhDVlM5RnBjMytX?=
 =?utf-8?B?MVdXQS9HNERPS2tlMHhkdjUvWlB4RG9mL28vSVNmdHJVSDBUVFVBK0U0bk9W?=
 =?utf-8?B?VThuL0dLZi82ZU16QjRVczlvd1Zyck51WXNLeEg4ZElycE1CU0pxYmJqWUl6?=
 =?utf-8?B?VGtTWE1wSjQ0bWQySnZNaE9GeXhqNVl3dnlQbkZ6bnJQTW9MZWczLzJUZXRz?=
 =?utf-8?B?bE5XYThCNGVRcStBK0FxTlZJcVdUOTdiVEFYUUhwVVkrYWJwVzhRbUE3Yllp?=
 =?utf-8?B?bHRuUC9Nc3kyOTVUMmEwZ0FlcmFudXZmRGN1b0hQYjg5cnhkc01mZEwrZy9q?=
 =?utf-8?B?cFRvWVNZN3VzUlg5cG45OFkraVY4ZVNJU1RCaUFrNnFEa3RSdTk3VFVSZlpz?=
 =?utf-8?B?aTh6eEd5R2VoN2l4NnBwVUFwWjFjc2RTTWZXN0Nlc25GRzA3b0VQdCtkUFBu?=
 =?utf-8?B?d0dkNUpzRnU5WWo3UzA5UlVsV1pUYnRBODFWM0RYRnJVbEc3czgwRE1vTlZY?=
 =?utf-8?B?ZE4xaVEzOXhyZGJ5OU9wUlB2c0dEb01rcndESCttaTMyYnVUbHpVZDltcTdl?=
 =?utf-8?B?S0p3ODdVNEdUbVN1eUgyWG9renR0b3BpUXk1NEh5WExhbWxXNGFCQ050Y1cv?=
 =?utf-8?B?aXFWTTdVUFp6UzBJQ1k3SFppUlF6NXJCR1MvZFNnZ1VFb0F6emg2c1g3aGlp?=
 =?utf-8?B?ZTdVajVFOHY3eDdGUm5PM3BQYVN4VjZnVmZhTjRJS0k4WDZmWGI3dTE3WFd5?=
 =?utf-8?B?amJkRS9sZjU0WCtYVGs4OW56THRaM2lhU2RzK21uS3VRS2tFK0tpeDd2eDdH?=
 =?utf-8?B?Mzg3c2Y1UDNWd0dVcU9xb2gxN3FVdlhaemJxOE9CL2VrbVlPKzZITnk5dzdk?=
 =?utf-8?B?MTVSdFByU3ZpeUptS1ZWNTE4c1Y3UTBBN0Nsdy9WSEE2cU9nemF1RmVPdkhO?=
 =?utf-8?B?MmZFS0VacEt4V2p1dGEzVnRoRXpaNlRTaTFKbElpZnZXVFBXa0RpVjNGSjVI?=
 =?utf-8?B?VnRkYmtueXpTbjJ6NGpIR3MwV0k1WnlkRTZQMkZSOWdxZzJwcXlXQUhHcEl5?=
 =?utf-8?B?U3FMSTB3VHZsWDNlSU92U0tFQ2RXbFBiTHFOWksydlUrRVp0RGN1ZkpJNjlW?=
 =?utf-8?B?SlM4Y0kxUllRYjRnS3NDYnFVQzFubnZ2ZHFIVGJVMFVOMi9hL2NkZmJpTXVk?=
 =?utf-8?B?Lzk3c0RYOHdXZzhqR2h4TmMwM3Z4RE94eUM3aDMra0pMVDhYS051WUNpdVJQ?=
 =?utf-8?B?S2pHMi9QQnBRcUlKU04wcGt5YjdJaDhacHExcFROVUJxcHFreGxQSko2aWY2?=
 =?utf-8?B?dlA1MHlrRnVFajVoSWJnSkpTTnBxWFVWUUQxaXJtZ3BUY1c4QUQ4TmxXa1Iz?=
 =?utf-8?B?QlFENGpjaDBHc0o4QTJyWlQ0cFhaYUE2am9sM2pUR0swUlVLL0FGWXd6Y3hT?=
 =?utf-8?B?T0RSbVZsc2VTTDh4RUlVZ3dPOS9ZeVBvUm1zTFJzN2pIa09ISXgvNTQybGRp?=
 =?utf-8?B?aWQ1d1NTdHY5NzMrN20wVUJ5REJiNGdoUnR5Skh3djRDSG9ZRlo1VlRIdHdP?=
 =?utf-8?Q?210kUMy8RUF8s0WI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF854E950B739A4EB837EF941DADC7DD@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff563f5f-609b-4227-d272-08da10055be8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2022 15:20:42.7181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GfHm5DDOPsz1jQ8j7IhEqcT/HWrkm3bG1I/UmcE5MQiNW805v/B4sdb5xzUvBd18KwEcxyHLforhYQmSFbOKYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1825
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU3VuLCAyMDIyLTAzLTI3IGF0IDE2OjAyICswODAwLCBYaWFvbWVuZyBUb25nIHdyb3RlOgo+
IFRoZSBidWcgaXMgaGVyZToKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFzZXJ2ZXIgfHwKPiDCoMKg
wqDCoMKgwqDCoMKgc2VydmVyLT5wbmZzX2N1cnJfbGQtPmlkICE9IGRldi0+Y2JkX2xheW91dF90
eXBlKSB7Cj4gCj4gVGhlIGxpc3QgaXRlcmF0b3IgdmFsdWUgJ3NlcnZlcicgd2lsbCAqYWx3YXlz
KiBiZSBzZXQgYW5kIG5vbi1OVUxMCj4gYnkgbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UsIHNvIGl0
IGlzIGluY29ycmVjdCB0byBhc3N1bWUgdGhhdCB0aGUKPiBpdGVyYXRvciB2YWx1ZSB3aWxsIGJl
IE5VTEwgaWYgdGhlIGxpc3QgaXMgZW1wdHkgb3Igbm8gZWxlbWVudCBpcwo+IGZvdW5kIChJbiBm
YWN0LCBpdCB3aWxsIGJlIGEgYm9ndXMgcG9pbnRlciB0byBhbiBpbnZhbGlkIHN0cnVjdAo+IG9i
amVjdCBjb250YWluaW5nIHRoZSBIRUFELCB3aGljaCBpcyB1c2VkIGZvciBhYm92ZSBjaGVjayBh
dCBuZXh0Cj4gb3V0ZXIgbG9vcCkuIE90aGVyd2lzZSBpdCBtYXkgYnlwYXNzIHRoZSBjaGVjayBp
biB0aGVvcnkgKGlpZgo+IHNlcnZlci0+cG5mc19jdXJyX2xkLT5pZCA9PSBkZXYtPmNiZF9sYXlv
dXRfdHlwZSwgJ3NlcnZlcicgbm93IGlzCj4gYSBib2d1cyBwb2ludGVyKSBhbmQgbGVhZCB0byBp
bnZhbGlkIG1lbW9yeSBhY2Nlc3MgcGFzc2luZyB0aGUgY2hlY2suCj4gCj4gVG8gZml4IHRoZSBi
dWcsIHVzZSBhIG5ldyB2YXJpYWJsZSAnaXRlcicgYXMgdGhlIGxpc3QgaXRlcmF0b3IsCj4gd2hp
bGUgdXNlIHRoZSBvcmlnaW5hbCB2YXJpYWJsZSAnc2VydmVyJyBhcyBhIGRlZGljYXRlZCBwb2lu
dGVyIHRvCj4gcG9pbnQgdG8gdGhlIGZvdW5kIGVsZW1lbnQuCj4gCj4gQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcKPiBGaXhlczogMWJlNTY4M2IwM2E3NiAoInBuZnM6IENCX05PVElGWV9ERVZJ
Q0VJRCIpCj4gU2lnbmVkLW9mZi1ieTogWGlhb21lbmcgVG9uZyA8eGlhbTBuZC50b25nQGdtYWls
LmNvbT4KPiAtLS0KPiDCoGZzL25mcy9jYWxsYmFja19wcm9jLmMgfCA5ICsrKysrLS0tLQo+IMKg
MSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKPiAKPiBkaWZm
IC0tZ2l0IGEvZnMvbmZzL2NhbGxiYWNrX3Byb2MuYyBiL2ZzL25mcy9jYWxsYmFja19wcm9jLmMK
PiBpbmRleCBjMzQzNjY2ZDlhNDIuLjg0Nzc5Nzg1ZGM4ZCAxMDA2NDQKPiAtLS0gYS9mcy9uZnMv
Y2FsbGJhY2tfcHJvYy5jCj4gKysrIGIvZnMvbmZzL2NhbGxiYWNrX3Byb2MuYwo+IEBAIC0zNjEs
NyArMzYxLDcgQEAgX19iZTMyIG5mczRfY2FsbGJhY2tfZGV2aWNlbm90aWZ5KHZvaWQgKmFyZ3As
Cj4gdm9pZCAqcmVzcCwKPiDCoMKgwqDCoMKgwqDCoMKgdWludDMyX3QgaTsKPiDCoMKgwqDCoMKg
wqDCoMKgX19iZTMyIHJlcyA9IDA7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBuZnNfY2xpZW50
ICpjbHAgPSBjcHMtPmNscDsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbmZzX3NlcnZlciAqc2Vy
dmVyID0gTlVMTDsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbmZzX3NlcnZlciAqc2VydmVyID0g
TlVMTCwgKml0ZXI7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFjbHApIHsKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlcyA9IGNwdV90b19iZTMyKE5GUzRFUlJfT1BfTk9U
X0lOX1NFU1NJT04pOwo+IEBAIC0zNzQsMTAgKzM3NCwxMSBAQCBfX2JlMzIgbmZzNF9jYWxsYmFj
a19kZXZpY2Vub3RpZnkodm9pZCAqYXJncCwKPiB2b2lkICpyZXNwLAo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgaWYgKCFzZXJ2ZXIgfHwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBzZXJ2ZXItPnBuZnNfY3Vycl9sZC0+aWQgIT0gZGV2LT5jYmRfbGF5
b3V0X3R5cGUpCj4gewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJjdV9yZWFkX2xvY2soKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KHNlcnZlciwgJmNscC0KPiA+
Y2xfc3VwZXJibG9ja3MsIGNsaWVudF9saW5rKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChzZXJ2ZXItPnBuZnNfY3Vy
cl9sZCAmJgo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZXJ2ZXItPnBuZnNfY3Vycl9sZC0+aWQgPT0gZGV2LQo+
ID5jYmRfbGF5b3V0X3R5cGUpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KGl0ZXIsICZjbHAtCj4gPmNsX3N1
cGVyYmxvY2tzLCBjbGllbnRfbGluaykKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoaXRlci0+cG5mc19jdXJyX2xkICYm
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGl0ZXItPnBuZnNfY3Vycl9sZC0+aWQgPT0gZGV2LQo+ID5jYmRfbGF5
b3V0X3R5cGUpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJjdV9yZWFkX3VubG9jaygpOwo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzZXJ2ZXIgPSBpdGVyOwoKSG1tLi4uIFdlJ3JlIG5vdCBo
b2xkaW5nIGFueSBsb2NrcyBvbiB0aGUgc3VwZXIgYmxvY2sgZm9yICdpdGVyJyBoZXJlLApzbyBu
b3RoaW5nIGlzIHByZXZlbnRpbmcgaXQgZnJvbSBnb2luZyBhd2F5IHdoaWxlIHdlJ3JlLgoKR2l2
ZW4gdGhhdCB3ZSByZWFsbHkgb25seSB3YW50IGEgcG9pbnRlciB0byB0aGUgc3RydWN0CnBuZnNf
bGF5b3V0ZHJpdmVyX3R5cGUgYW55d2F5LCB3aHkgbm90IGp1c3QgY29udmVydCB0aGUgY29kZSB0
byBzYXZlIGEKcG9pbnRlciB0byB0aGF0IChhbmQgZG8gaXQgd2hpbGUgaG9sZGluZyB0aGUgcmN1
X3JlYWRfbG9jaygpKT8KClRoZSBzdHJ1Y3QgcG5mc19sYXlvdXRkcml2ZXIgaXMgYWx3YXlzIGV4
cGVjdGVkIHRvIGJlIGEgc3RhdGljYWxseQphbGxvY2F0ZWQgc3RydWN0dXJlLCBzbyBpdCB3b24n
dCBnbyBhd2F5IGFzIGxvbmcgYXMgdGhlIHBORlMgZHJpdmVyCm1vZHVsZSByZW1haW5zIGxvYWRl
ZC4KCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIGZvdW5kOwo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmN1X3JlYWRfdW5s
b2NrKCk7CgotLSAKVHJvbmQgTXlrbGVidXN0CkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwg
SGFtbWVyc3BhY2UKdHJvbmQubXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbQoKCg==
