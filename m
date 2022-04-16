Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58507503470
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 08:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiDPG3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Apr 2022 02:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiDPG3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Apr 2022 02:29:18 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90049.outbound.protection.outlook.com [40.107.9.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92392E8874;
        Fri, 15 Apr 2022 23:26:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOLTbDQWaOpMuXqcwTRIS41uTrd5Ha6aKHUnJdaqTXkXKh1ZgFAgI2WoLQ8I048Jj7Uv0A1Hb85VhOrevpsjVzm4TtMmeM5NOHZx5hUlFeXFXdK2B+Dcrj1vQlEwaiD102WIE9SVTeo7heRbfBXdW555TxWHnr1TxOkOYckYm2aMklyCVXcmBTQZ0MqG6tI3cQeDNn1UJ5GoFfevhQP4SW0J5t9xUexhBO460zQmJyVdg1z06Jn0okt9Yp3pkhLurItdt/2/82XCLo4xl3uPM/m2tDu2Ry8Vy+kMQqYs195IrUoxqMEF8qdCECOFqpnjxUH2iLGbYhxQZzQVZz+L8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewK6ynUX3IT0+1TUY8GxG0KPuSgN46Md27GzpQfbr5s=;
 b=Oov2jpehw8LXq7olkdzu9Io4xY/q1qQLiC9+/V86W0Pk6rBAB9vI1gJ+A8OVSKvAKTPkhNtmZaCJwMCCMQ67LN9nEorBPMZMV8QIrGSRuhbJgAMhubGecMYcgGGeVXjUld/5Q8YvPXx4iyPcDohaHH8ZIvWASC5FpJAVhWwPCeBb3nQ4oA/CIuz0E7Ok0yxSrK7d1CrCncBUGO56cMdEAaFCe7bFTqojzMb0TApM7AC+U8F/io+6Oj3qZb7RoM0w7WYXCArVYA7rnRSUSZpQCz6n2JL5gdZFR6a0YbcRI4Y+lW+2kpL8SSuK04Uexn+r/ZG5ZHUIvL3ZIEhmUgiDCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB4259.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Sat, 16 Apr
 2022 06:26:42 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c%8]) with mapi id 15.20.5164.020; Sat, 16 Apr 2022
 06:26:42 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10] mm, hugetlbfs: Allow for "high" userspace addresses
Thread-Topic: [PATCH v10] mm, hugetlbfs: Allow for "high" userspace addresses
Thread-Index: AQHYUNd8NrewNF7+0Uq1IxdWLzIplqzxiUSAgACK6YA=
Date:   Sat, 16 Apr 2022 06:26:42 +0000
Message-ID: <63e716ee-ad77-c087-20a7-4fda06ec1f68@csgroup.eu>
References: <ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu>
 <20220415150929.a62cbad83c22d6304560f626@linux-foundation.org>
In-Reply-To: <20220415150929.a62cbad83c22d6304560f626@linux-foundation.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89bcde87-4798-4485-228e-08da1f721292
x-ms-traffictypediagnostic: MR1P264MB4259:EE_
x-microsoft-antispam-prvs: <MR1P264MB42592830AB64F866C537962FEDF19@MR1P264MB4259.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rC//U6TuU2h3kSwOhtzG3F0m/smxx2IOfloE3rvmv5Ld2XCGLPRS7u+M3es+sDW3jNiXQomoxaglVkPWyKdb2ZtddPf7SDk4vKUlN2hlQQy8Qcksqc0jK01QIJf0Wj6LV3FceQjK6udjP2t2nyxQCPG0VXK9fVdxvI47PLAxAdx353k6/ZNZxS/bvAt3lQLYZA8GK/J7a1zY9mUsLv9hCmPVW8EY4yoT/s/+2kpJYeM8dvxdzwn3S2k2Hi5R2V6JXFzEz80JJ5cGpIHJ3tQDpD9mEQCFDz0kNykcmfaBNO2emuk6gtybzZfDNo0+r9iJtk27QhzEQA/0eajIMdqAy6t7s1wQs5FEM7WNO5mFzBxLVLaYwxe2kd2q6d2dZgPoT28qnBILhWNYuAK90drOmjzr9pV/fVnrrNeDcvC84FyUDqKiCgMk1qekTfrnkk6qnpQm1YSgftCY3sw/fZinI3mhPF7VOPqjiPrV4rR9gDMCzA4x/cxL7qrJSZYwCHn7p628GECtJ7OGSApCjuPQzjMu0hY7KH0MI7vPsgfCfymJP7dUxa3i1ymaUTkjz0hPRpt5cFTXaEqa5OFpKMGKDZPaNVoIdQKYR6f+tMnRUeUVYsJbICDaDCI6YqyE6mOmxd5IsCfmua1egKgmt1FDRlj4P33HonNY+Y3wbXTokn/LSjp/i7djowZd/LDJKAP6Z/xtKh7wMLbgDfTRLJ6h5j783ZT0pPts/1+ZUzgyzYkcNlTLMTWfDu87ttCzWu6Np8XnkMSpD0f+Lo6XAOoak+U1Mmlfug8v1iWCbvbo+8nrdjFDiiRpelqTXTnFqzPCR0hrhDT3P7JPUNJrHO5WJPZdmy7jaPNiRdt82TPgsycQ510avcJ8Sm9Sy2EUreH5lJHPqY2fveik4JLclzxysQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(84040400005)(8936002)(38070700005)(8676002)(4326008)(2906002)(66446008)(38100700002)(66556008)(66946007)(66476007)(6512007)(64756008)(76116006)(83380400001)(31686004)(36756003)(91956017)(110136005)(66574015)(6506007)(122000001)(508600001)(316002)(6486002)(2616005)(54906003)(5660300002)(186003)(26005)(86362001)(44832011)(31696002)(966005)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UndwOGlIalBSd2tuVjh0Z1NCME01NklYKzQzYTFRc1YyTHI0RWpPQUJVNHk2?=
 =?utf-8?B?eXFOMUd0U21BZFRleTdzSzBCbnJ5VmJDOFQ0R0dwenFXbDJqM2pkbFZSTXFL?=
 =?utf-8?B?cmRMZmpCaTcxL1hJSCtpOGxzOEpRK3E4TzQ4MW15b3pRbGtMS08vNU05UUw0?=
 =?utf-8?B?QjQ1dG00cGRoVklBK3hLSzFrN0Rtdjhxd2w0dDBJak9GSFdzM0dXeHkvU3Ez?=
 =?utf-8?B?WnNudGNvK2d2cWdoNnpNZHBjN0VKM2xjbjk3ejFWM1c0dlMxOHlDNFVKQ3ln?=
 =?utf-8?B?Y0lxZ1BaRFhwbGFFbE9aMjNhTllkcmwvUHJtaHV5VGh3SnRIOVpWM2tvMEdq?=
 =?utf-8?B?ZmFQVDJyUkFMSGh0MHllYVJFOFdkSW5QZEt1UDZtZnM4QTJmbGtab0UyczBk?=
 =?utf-8?B?S0Q5K2tSTzMvcWNkUjRQdGxmNlBNQTIxOGZMUGQyZ0pwem9sVHZab1lIdWpv?=
 =?utf-8?B?YUp3cEM3a0FpVnoyeHk3bVJPRmQyL2w3UWR2dFdJTHJ1VWZ3c2F2OXdhUUQr?=
 =?utf-8?B?bXdsZmVaczVyMFBGYSs2WnQ0UlpBUmRsdlhXVHdVaEJMT2Fpb2ZPZVVUc21V?=
 =?utf-8?B?WE9jQVNIcFNNK3MrV1JZYmtMTTR4a1dzZnE0TDlGTWFDQ1J2STNCQzkyZmpQ?=
 =?utf-8?B?bWxrUHdkeFdqMDdwcFB3YU9SaTBRSlJ1R0hZeE53UkVYQ0cyaHVnNXMwbGlq?=
 =?utf-8?B?QW5DNWNrSGcyamVTUFhxQW8yNXpZcm1FVnhZYThQT2V2amo3RTh5UStuZW5p?=
 =?utf-8?B?elh3TkEvcTRFQ1ZJR3orWmkvVFBoVWpBV1EwSkdJeVpIMEZxaURXbmozQVFr?=
 =?utf-8?B?ckJqRFhtVVNYaVFLV0dFOUFuYytHelVUT0hjZGRVdjNwNWUrTXBza3pLN1Ni?=
 =?utf-8?B?ZU80RXFJeGFQUXZLOUhsRnpycld0S1RxNldzZ2t1enY1Uk5mNFFKWTk0WFAz?=
 =?utf-8?B?dWJrd0lVM1NMdG5kQmlDQWFmZTBFdVlyalFtempCVm1VNzlxMkpUVW9BbXBr?=
 =?utf-8?B?WDdENUpyRkUwN2NkaFlOZjh1MEIxelk3MUVLNHMyQy9GSnhmUEZJbGtreDRk?=
 =?utf-8?B?OXo4QkJ2OFBadzJuUzBtYmdmZjdSTnlYSmJ2ejJFTU83aE13RHMyaEQxdWN0?=
 =?utf-8?B?dEdVQ1p6ZjY1TmFxUm45cUd1SmM3WUVIZSt4elNJSVVvSExCWjE1MHRCODZp?=
 =?utf-8?B?enFCbjRteU16NUdqSm9vTTNqd0l4QTdtOHNaTTNhMWc3QjROUEVyY1QzZWlw?=
 =?utf-8?B?VWhoa3dGQzUwZGFrK0g4N1oxN2QyNFdiWm1WdzVlTmJlTG9WK1o4Umg0cHFk?=
 =?utf-8?B?WnZLSUJ5YlBjc1ZnM0J1b0EyUVNSbmMxaHNUNUdpbm5RcnlkNENic0tKdnVI?=
 =?utf-8?B?bDJyZlhFYWU5Z0F4dGZJb01MdTRqd2JXS0g0VDAxNUNhLzRLS2o0WXdlbzRX?=
 =?utf-8?B?cjVycWVlMG1MaE03TGl0dkZ6SUFISzJSdkVtYWk2cTNlVWJ0ZXc5TENpODNv?=
 =?utf-8?B?UTl3UWsxTVlESGtxUWt3SUw1WE90bUdtVTI1SC9RK2grY1NEcVdINmFrOEJq?=
 =?utf-8?B?N3gzQ3g1OUptOExZZHBFdXk4VGRaMTVMU2M3RDlFb29nUk1DeCs5d3NNQTRr?=
 =?utf-8?B?OGdXK1YrOXo0eTM1b3MzTmJ0TWVCSllwSSs4ZCt2YkE0QUdORGZwQ2I4bmtY?=
 =?utf-8?B?YlZEb2NoVkV0RTFWMjhRODdDbkRrSTZ4bnZSbnFQaGJDUjkxZEVsMGRzWm4r?=
 =?utf-8?B?ams4cXlJWGloZXhtMW15eUFORE42WmFpWGROcEZ6WFUySWJucG16RGR5VWVU?=
 =?utf-8?B?eTdrMXlWcTlUVHdDQzh3THk4K0ZMcUxsc3pPVzAwSUd5bW9qbWdPYWFyeDB4?=
 =?utf-8?B?YXh0Z0JEaFREbDEyelc3Zzl2eS9tRVllcWpQeFl0ZGpDMmVpWGlyOTY4VUxL?=
 =?utf-8?B?aUpvV1V4TTRaaDB5S2pONCtHc1VONU9ZNDVWRmphZGhjMTRPd1R1QldZWDlO?=
 =?utf-8?B?bDRyTGFwVkErSUZ2c1o0Tzc1Rnp3c0ZyVnhLYjlIc0EyenFwRmN6ZkphcmJa?=
 =?utf-8?B?TWQrZ2dPZDQ1OVlWQ2F0MjNrTTJrY2J2SWJvbXFPOFdTOHFnWERjcDlRekxY?=
 =?utf-8?B?Q0RlNkZEOHBaQ2Q5ZUhpaDFwR2U0MTZFTXFLODhmdFlYcVBUTmFmbGlKWEdJ?=
 =?utf-8?B?b1pTZmdmRDd2TGE0TUsyY2t6V2MxR29yZ1JNTVp2THZLN3NYcUQ2elE0b2Yv?=
 =?utf-8?B?R0VKSDdaMHo1cTlrb05sSEFrcU5NVVFXblJLWktJajZXY1BIbThUVjZPNmNo?=
 =?utf-8?B?VUtXS2NtaTVyRVBmSTc4THM4R2MrQWUvMFM2c1h0TnkzeXhySEVHSnlQbHVD?=
 =?utf-8?Q?hCrhoffB1zLCVMSwbRYPt1OFDq08UBmQ0FLyt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BF63DCE02F5C2408C1A3CFCF0D33FDF@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 89bcde87-4798-4485-228e-08da1f721292
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2022 06:26:42.3552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5vGqxmJcOcCxeLs7bOMBWrBVJcXUVa39JU3hFNJ2X1k/6r7HXLm0bZj25bpAffybFVDgNKPUKViLIangVjLmigyzSXxCmF9gbCdwg4eQJDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB4259
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQ2F0YWxpbiwNCg0KTGUgMTYvMDQvMjAyMiDDoCAwMDowOSwgQW5kcmV3IE1vcnRvbiBhIMOp
Y3JpdMKgOg0KPiBPbiBGcmksIDE1IEFwciAyMDIyIDE2OjQ1OjEzICswMjAwIENocmlzdG9waGUg
TGVyb3kgPGNocmlzdG9waGUubGVyb3lAY3Nncm91cC5ldT4gd3JvdGU6DQo+IA0KPj4gVGhpcyBp
cyBhIGZpeCBmb3IgY29tbWl0IGY2Nzk1MDUzZGFjOCAoIm1tOiBtbWFwOiBBbGxvdyBmb3IgImhp
Z2giDQo+PiB1c2Vyc3BhY2UgYWRkcmVzc2VzIikgZm9yIGh1Z2V0bGIuDQo+Pg0KPj4gVGhpcyBw
YXRjaCBhZGRzIHN1cHBvcnQgZm9yICJoaWdoIiB1c2Vyc3BhY2UgYWRkcmVzc2VzIHRoYXQgYXJl
DQo+PiBvcHRpb25hbGx5IHN1cHBvcnRlZCBvbiB0aGUgc3lzdGVtIGFuZCBoYXZlIHRvIGJlIHJl
cXVlc3RlZCB2aWEgYSBoaW50DQo+PiBtZWNoYW5pc20gKCJoaWdoIiBhZGRyIHBhcmFtZXRlciB0
byBtbWFwKS4NCj4+DQo+PiBBcmNoaXRlY3R1cmVzIHN1Y2ggYXMgcG93ZXJwYyBhbmQgeDg2IGFj
aGlldmUgdGhpcyBieSBtYWtpbmcgY2hhbmdlcyB0bw0KPj4gdGhlaXIgYXJjaGl0ZWN0dXJhbCB2
ZXJzaW9ucyBvZiBodWdldGxiX2dldF91bm1hcHBlZF9hcmVhKCkgZnVuY3Rpb24uDQo+PiBIb3dl
dmVyLCBhcm02NCB1c2VzIHRoZSBnZW5lcmljIHZlcnNpb24gb2YgdGhhdCBmdW5jdGlvbi4NCj4+
DQo+PiBTbyB0YWtlIGludG8gYWNjb3VudCBhcmNoX2dldF9tbWFwX2Jhc2UoKSBhbmQgYXJjaF9n
ZXRfbW1hcF9lbmQoKSBpbg0KPj4gaHVnZXRsYl9nZXRfdW5tYXBwZWRfYXJlYSgpLiBUbyBhbGxv
dyB0aGF0LCBtb3ZlIHRob3NlIHR3byBtYWNyb3MNCj4+IG91dCBvZiBtbS9tbWFwLmMgaW50byBp
bmNsdWRlL2xpbnV4L3NjaGVkL21tLmgNCj4+DQo+PiBJZiB0aGVzZSBtYWNyb3MgYXJlIG5vdCBk
ZWZpbmVkIGluIGFyY2hpdGVjdHVyYWwgY29kZSB0aGVuIHRoZXkgZGVmYXVsdA0KPj4gdG8gKFRB
U0tfU0laRSkgYW5kIChiYXNlKSBzbyBzaG91bGQgbm90IGludHJvZHVjZSBhbnkgYmVoYXZpb3Vy
YWwNCj4+IGNoYW5nZXMgdG8gYXJjaGl0ZWN0dXJlcyB0aGF0IGRvIG5vdCBkZWZpbmUgdGhlbS4N
Cj4+DQo+PiBGb3IgdGhlIHRpbWUgYmVpbmcsIG9ubHkgQVJNNjQgaXMgYWZmZWN0ZWQgYnkgdGhp
cyBjaGFuZ2UuDQo+Pg0KPj4gPkZyb20gQ2F0YWxpbiAoQVJNNjQpOg0KPj4gICAgV2Ugc2hvdWxk
IGhhdmUgZml4ZWQgaHVnZXRsYl9nZXRfdW5tYXBwZWRfYXJlYSgpIGFzIHdlbGwgd2hlbiB3ZQ0K
Pj4gYWRkZWQgc3VwcG9ydCBmb3IgNTItYml0IFZBLiBUaGUgcmVhc29uIGZvciBjb21taXQgZjY3
OTUwNTNkYWM4IHdhcyB0bw0KPj4gcHJldmVudCBub3JtYWwgbW1hcCgpIGZyb20gcmV0dXJuaW5n
IGFkZHJlc3NlcyBhYm92ZSA0OC1iaXQgYnkgZGVmYXVsdA0KPj4gYXMgc29tZSB1c2VyLXNwYWNl
IGhhZCBoYXJkIGFzc3VtcHRpb25zIGFib3V0IHRoaXMuDQo+Pg0KPj4gSXQncyBhIHNsaWdodCBB
QkkgY2hhbmdlIGlmIHlvdSBkbyB0aGlzIGZvciBodWdldGxiX2dldF91bm1hcHBlZF9hcmVhKCkN
Cj4+IGJ1dCBJIGRvdWJ0IGFueW9uZSB3b3VsZCBub3RpY2UuIEl0J3MgbW9yZSBsaWtlbHkgdGhh
dCB0aGUgY3VycmVudA0KPj4gYmVoYXZpb3VyIHdvdWxkIGNhdXNlIGlzc3Vlcywgc28gSSdkIHJh
dGhlciBoYXZlIHRoZW0gY29uc2lzdGVudC4NCj4gDQo+IEknbSBzdHJ1Z2dsaW5nIHRvIHVuZGVy
c3RhbmQgdGhlIG5lZWQgZm9yIGEgLXN0YWJsZSBiYWNrcG9ydCBmcm9tIHRoZQ0KPiBhYm92ZSB0
ZXh0Lg0KPiANCj4gQ291bGQgd2UgcGxlYXNlIGdldCBhIHNpbXBsZSBzdGF0ZW1lbnQgb2YgdGhl
IGVuZC11c2VyIHZpc2libGUgZWZmZWN0cw0KPiBvZiB0aGUgc2hvcnRjb21pbmc/ICBUYXJnZXQg
YXVkaWVuY2UgaXMgLXN0YWJsZSB0cmVlIG1haW50YWluZXJzLCBhbmQNCj4gcGVvcGxlIHdobyB3
ZSd2ZSBuZXZlciBoZWFyZCBvZiB3aG8gd2lsbCBiZSB3b25kZXJpbmcgd2hldGhlciB0aGV5IHNo
b3VsZA0KPiBhZGQgdGhpcyB0byB0aGVpciBvcmdhbml6YXRpb24ncyBvbGRlciBrZXJuZWwuDQoN
CkNhdGFsaW4sIGNhbiB5b3UgaGVscCBhbnN3ZXJpbmcgdGhpcyBxdWVzdGlvbiA/IEl0IHdhcyB5
b3VyIA0KcmVjb21tZW5kYXRpb24gdG8gdGFnIHRoaXMgcGF0Y2ggZm9yIHN0YWJsZSBpbiANCmh0
dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcHJvamVjdC9saW51eHBwYy1kZXYvcGF0Y2gvZGIy
MzhjMWNhMmQ0NmUzM2M1NzMyOGY4ZDQ1MGYyNTYzZTkyZjhjMi4xNjM5NzM2NDQ5LmdpdC5jaHJp
c3RvcGhlLmxlcm95QGNzZ3JvdXAuZXUvDQoNCj4gDQo+PiAgIGZzL2h1Z2V0bGJmcy9pbm9kZS5j
ICAgICB8IDkgKysrKystLS0tDQo+PiAgIGluY2x1ZGUvbGludXgvc2NoZWQvbW0uaCB8IDggKysr
KysrKysNCj4+ICAgbW0vbW1hcC5jICAgICAgICAgICAgICAgIHwgOCAtLS0tLS0tLQ0KPj4gICAz
IGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KPiANCj4g
SSdtIGEgYml0IHN1cnByaXNlZCB0aGF0IHRoaXMgaGFzIHJlYWNoZWQgdmVyc2lvbiAxMCEgIFdh
cyBpdCByZWFsbHkNCj4gdGhhdCB0cmlja3k/DQo+IA0KDQpXZWxsLCB0aGF0J3MgdGhlIHNlcmll
cyBpdCB3YXMgcGFydCBvZiB0aGF0IGhhcyByZWFjaGVkIHYxMC4gVGhpcyBwYXRjaCANCndhcyBp
bnRyb2R1Y2VkIGluIHRoZSBzZXJpZXMgaW4gdjYNCg0KdjY6IA0KaHR0cHM6Ly9wYXRjaHdvcmsu
b3psYWJzLm9yZy9wcm9qZWN0L2xpbnV4cHBjLWRldi9wYXRjaC9kYjIzOGMxY2EyZDQ2ZTMzYzU3
MzI4ZjhkNDUwZjI1NjNlOTJmOGMyLjE2Mzk3MzY0NDkuZ2l0LmNocmlzdG9waGUubGVyb3lAY3Nn
cm91cC5ldS8NCnY3OiANCmh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcHJvamVjdC9saW51
eHBwYy1kZXYvcGF0Y2gvNmM5NTA5MWVhYjlmNThjZWU1OGRhMzc2MmE0ZGM0YzU2YWI3MDBlNy4x
NjQyNzUyOTQ2LmdpdC5jaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXUvDQp2ODogDQpodHRwczov
L3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbGludXhwcGMtZGV2L3BhdGNoL2MyMzRjZWFm
ODFmZjM3NDQ3ZmVjNWM5ODEzZDRiYTVmYzQ3MmEzNTUuMTY0Njg0NzU2Mi5naXQuY2hyaXN0b3Bo
ZS5sZXJveUBjc2dyb3VwLmV1Lw0Kdjk6IA0KaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9w
cm9qZWN0L2xpbnV4cHBjLWRldi9wYXRjaC8zYmI5NDQ2NDIxNDA4NDFjMDY1ZjFjZDZlYWU3M2Yw
ODRmYzAyNmQyLjE2NDk0MDEyMDEuZ2l0LmNocmlzdG9waGUubGVyb3lAY3Nncm91cC5ldS8NCg0K
VGhhbmtzDQpDaHJpc3RvcGhl
