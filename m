Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108974F092A
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 13:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243611AbiDCL4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 07:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiDCL4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 07:56:52 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90057.outbound.protection.outlook.com [40.107.9.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F0A275ED;
        Sun,  3 Apr 2022 04:54:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWGYwwYLI2ssjOqrwc6wX1512Ie2sa0+iai0Kr61v8ZPIJfEBt/iRrGDep35NnY6Jg0v39Ejgv3wIWkY4oSbp2rgHP2aqeguXa+5MIguRsn4IUh1zzLx1Ta6KWnuMmTvp8kvy5rpk3tJmz38Nn1Wv/RNV6FqHiaX3MJGLObWRsK09Ry1g09U/dDexmMI6Yrs6L6nQrDAeV8gkrYUrkTTmfHp8y7D6uGYwJIWcu+mbfhx80Ci97BvIg/xU5/Xusz9566z22+bNECuPaLFHqwj7qxPt4WhPTFNgNuW8OkTkBjXOXtQmRbk3yszpl8kN5V1KVajFnlmgiRJrjKhF3eLeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wl/OXEjccLNdydtL9dsDxBWGqWmRvvCt6qiG3K+w3UU=;
 b=YTnPT++aDkEtznh+e9JR9nmN+yk69DlGB5jDxj+XYLmvc8+qziij8yTHp2nA0qxKwDXpksg/2xm/hlpF5IdGKwz+eYSR6s++CGUTB0UzyUCk1Nt/U2Uf2GTQaHJ9FTr0EWNwx93yJ/24WMWCu26uGWBEfevgl4EX2gKN7eyOce4nQqGBbZOaQ08AkEBx1Tt2p4vFy0Xc1YzJyM58mtZup434q9H6pj5ng/zZiAHg7BcGYIvKF7cqxwtlkxFqL3qcObHrXnagltS6KMwYL0lYGT4uNf+bc64aA8mU3nayRrEj5ru3wJR0LK+3hn7qwXlCUfYqKYU0oq6DwDNeXeqrSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB2663.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Sun, 3 Apr
 2022 11:54:55 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c%7]) with mapi id 15.20.5123.031; Sun, 3 Apr 2022
 11:54:55 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Chen Jingwen <chenjingwen6@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] [Rebased for 5.4] powerpc/kasan: Fix early region not
 updated correctly
Thread-Topic: [PATCH] [Rebased for 5.4] powerpc/kasan: Fix early region not
 updated correctly
Thread-Index: AQHYRqyoyiJX2QwM4UePChgZHf1ri6zd/N6AgAAZC4A=
Date:   Sun, 3 Apr 2022 11:54:55 +0000
Message-ID: <fd2c0d7a-e194-1ce4-4a5f-2d66ae0d350a@csgroup.eu>
References: <fc39c36ea92e03ed5eb218ddbe83b34361034d9d.1648915982.git.christophe.leroy@csgroup.eu>
 <Ykl2C6DmSKWxlOWE@kroah.com>
In-Reply-To: <Ykl2C6DmSKWxlOWE@kroah.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 705ce689-3aae-4ab9-2739-08da1568c503
x-ms-traffictypediagnostic: PR0P264MB2663:EE_
x-microsoft-antispam-prvs: <PR0P264MB2663F4E78C6288DD551CF2D9EDE29@PR0P264MB2663.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u43Y6iyaJl5VVMLdN/oXgHtKMURzhyTOnDRIKSsFivy3/021ttd9Wl9VPP+oxyPNp68DiyMAHuAt4jtQj1nRztKmqJ8sHhZNI1e/8plmOwJ8LLN96LKHyg5VT79Wcnu//acnEdVYUFqbYcQSThKp5sIGELQ6GWA5bq/zfRwOkARytqcuTE2voC0YNNTKgS0H0a7OVx5EG60WlMwYeeZEwUqTBCA4PQzGxjSyJGNyKx66Rdl0WIqIxN3xCTGI2DKmLiRBXog+I/3G1em1hKhSxj5BLLgXF0GUXPDbdSj+iwNcM/vITYZkEUKoFyHK+fiLyUs252/fI0hX3UuvtebYBRe9xOKvQrfBki/qR0I1xy/W9GOx/Mgi8hKjHoHOTPsbR8kihYgVNOCtSulPG5hECpC0BL63h+NFMqtAu/ThHH8vMotPnIfMoGd10bslkqtCdJnXkSbSjhaXEY3gafNQqgJQavBvsVcHoVb84hkvCVFZqPi8JtCrSniN+8GrHEf6TNQPNLQSOD10w1m6eJK/xWxH1AgT9d4HIdeiDl2aCvaCmiL8DvFxHo9bTg5pB0+aNUTfm0QBiUwkd0bSepBn89YClNqkoURtB5L2Fkt4+Pw3Vt3bfTuReXyOQlxO7x8VOiZVApI2u04PX/EEYPV/rA6WV6bUQcQkDYRiykMuEMDQ5u89lgcGsE6eUOonfo7e7xOE6gdrYHKvV7IRFKxsa7lE0pKtkpqLOiPcO+y2S3WAbaXcbzMTqBw2aripE7WqmAwIcJvJ/9KrFpk03i0bSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(54906003)(71200400001)(64756008)(6486002)(86362001)(6916009)(4326008)(8676002)(508600001)(316002)(38070700005)(31686004)(122000001)(76116006)(91956017)(66556008)(66446008)(66946007)(66476007)(44832011)(6512007)(5660300002)(31696002)(2616005)(8936002)(4744005)(66574015)(38100700002)(6506007)(186003)(26005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGtoRVlHY1MvVmlwVCt2L2lKK2V5ZDNvV0kyY1RxM09sd3dpQzdHYkNZN3Ez?=
 =?utf-8?B?QXB4TUVOLzZ3NGVIeWI3bDJLazBLb3JPZHY0c09LMFpaTTRQVmxBOG10Nnhl?=
 =?utf-8?B?S3pBOE41cG1iRlFYK3ZHdkhCNUwrRXd3cmpicVp2Ymw0SnJZdzhDVzFKd2tx?=
 =?utf-8?B?SzJyNXp5TVRWVXc0Q2ZUN2ZQRVFPQVFsa25IS2dTTGZtVlNibGZibDFJUzhy?=
 =?utf-8?B?ZHprRkpNR0dHakQxa2lCdkpsbUlyZEsvdEd5eFBmU21KbEdHYlExV2dhQ1Br?=
 =?utf-8?B?SDVjZ3VNVW1MTnY1OWgvdUxoL3VxZkRWTzdoQ3lsYTltVDhkcE56MzJZRFEv?=
 =?utf-8?B?SU1uc2tzTUNwa0hDZzRhbWdZUktpeEtER1Bzc3JyTmorbVdGWi9uUjBKTk5W?=
 =?utf-8?B?NElMbHdLbjFUV2NpUytya0dSV01lSUNSWmpZejg1TGEwOE5MemtKREdxZHZQ?=
 =?utf-8?B?TUhoalBlM3VZNGtDeWY2VDk4dlR6ZTFGTUNVUGJhenFHVWJHMGpibTgrU0Nh?=
 =?utf-8?B?S2ZXMTF1cVJrUnJtT2kvSE9XNk10NUduOW1KWmJ0QjE5WDJYeCswNkhkZVdW?=
 =?utf-8?B?bEpmYzZ5THJVb2pWbEZvcjBkRTBlNUhuYWlPQzlTNEN4ZVVvT0ZDMGdleG9i?=
 =?utf-8?B?SlZIaTBxdEF5VmJEa0Z4amJOdkVqTmhXM0JPendEWHMveDNKeVhpVkkrOWNo?=
 =?utf-8?B?QngzL3dXcHdwVkdjSU5peEs5WmM3VSswNm1nUUw5QVZ6bHdiYnhzd2RacCtu?=
 =?utf-8?B?c0FDR3hhczRjQk8xTXA0MmFLZ211ZVUrRXpFUkdFRU1XZjYrcnVpU0dNTTVn?=
 =?utf-8?B?SDZLTkQzTnFWYWxISGtDaVBFN0pUQm10K25VM2ZoYVZUMEtxYUQrWEhKUUpG?=
 =?utf-8?B?NDhGQjlCSUtnbkV2TGxWZlRpeDdRRnNrc1FYYkZ3VGRhYzlVbXhPUGxOWlh6?=
 =?utf-8?B?bUFMR1hkK3lhVUkxTlVYSGszaUg4czMzNzVrN0RZRmJIdnBjM1hKMndvUmFF?=
 =?utf-8?B?KzJNQW1tb1lJSHBZOHhrbjhabS8rbjVPSUdqZE9FeFFzaWZTcWN6Z3QxUHhn?=
 =?utf-8?B?NDR3Nnk2Y0RPTFdSdzY0aVd1bDFkQWd6cFl4ZWExRWp1WWRuUDRNcnBLT2dW?=
 =?utf-8?B?QTUwLzRHVmFFS3hHQVhONVZUQTdwclF4WXdEUXBxM0VhRzc1d0pwbDFxN29j?=
 =?utf-8?B?bUhjUC9LbnEzazUxbkZGL0FobU04L3BNQ21ELytmenk4bk1KT29NZndNdFl3?=
 =?utf-8?B?K2xwUTZrcGZPaHg2cDI5cFFCbGxIRXVza3VtVC85emxPcU9idnQ1K2ZOYlRv?=
 =?utf-8?B?NHJBK2xzR0lEakt3cHhVdEhQLzk3b0pFRVFPTkdPWHUxZ0JRbVZqZzVnUnpU?=
 =?utf-8?B?aXliUHFqei9icVI4ZGU5ZmRWeHlVVTBiaVovUGNzbnR0bGNDSTkxdTVqeXRm?=
 =?utf-8?B?Qk84YkZnSmgvVXlDTlBNYXM4TGppYkdsdmRVbU43SW52ZEhhRnRvcEk4YlVT?=
 =?utf-8?B?a3lERWVJYkxuRXFQMGVJd3pKTmhaWVh2MzZ5dzBnYXVBRk1MR3RuZDQxUXVN?=
 =?utf-8?B?cFpGWjA5ODN5MS94NjdpeTI1TEcrZHpZWWY3QStKREV3anFEWE4zUjBkeFlk?=
 =?utf-8?B?Mk1qTHBRa2tTYjYrOUZySlVNbm93ZGtFU25XM2dlMUJBeHc2YnhnMFR5b1R6?=
 =?utf-8?B?NEZXY2FuWVlnNE92V3dlaHZQcTNxSnhXWmU4Q2VteGVsYTBiRWhpRlRQb29u?=
 =?utf-8?B?QTVWS0FuQlNCZnpoNDF5N1dDZG1TR0pVaXFZVmhOM0lqYUZ6dytQaXlNWnNj?=
 =?utf-8?B?N3Y0SDE4M3hSZTRZUnRqYzNPWmxTMWdXa09wUVh1MGxQb3UwY0VvdGg2YllD?=
 =?utf-8?B?b1FNejFibzlldS9zWUE4cXF4TGU1VHlMWUplZFNOd1JNQjJDc1BHWHVyKzhN?=
 =?utf-8?B?LzhLRVBxUnRTNU5SeW9ybk1CKzc0QmVjVU9QcUtYUVlyUlZ4L0FNWU5TMG41?=
 =?utf-8?B?N1h5cmNSRWtaM1pvT0Z1NmhuS2FmaW5GUkNLQ0taVjg0WS9iazJFOVUwZ01r?=
 =?utf-8?B?MDhFWGJucWlKbEhIRU5DZUUxSjBjV1UxWE1YdC9yd253TWk5aHVNaVJTQmRZ?=
 =?utf-8?B?aUpoMFFqOVE5OHFrZThxR0gvaU9WQjBmMDBlcGt5ZlZib1Q3aCsvOU4xWEYv?=
 =?utf-8?B?dnJNWVYzVUtucmcxMFJIYUhITWw1c0hYcVduU3NSRWY1ODVXbzVHTy9vUFRF?=
 =?utf-8?B?UjR2cTRPZVFmeHNzREZKTndzWHZrUlJZeXovNFFPWEdETWQ4TFVHaklrWnpV?=
 =?utf-8?B?ZUhvNnNZcVNORHk0VS9TTFI2bkI0RGdWYkxqaWJ6YVZTNytwcGxuZ2ZTbVN3?=
 =?utf-8?Q?6wBSaNn8bomfK9kMLYVffj+6zNXmu6lPT9+hy?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE2DE76F0852E94AB11EC5BA7D98A8C1@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 705ce689-3aae-4ab9-2739-08da1568c503
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2022 11:54:55.1665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UpBnptCvxYL5Y6S3f5es1/4p1QMyfw6Y+pHpghcyfHcD1EXA88Z5+S7T2Yo7hwaqS7WCVvHab+IUi6Lb2pDAwVms6KHYSFgAE+7BVcjT6CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB2663
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDAzLzA0LzIwMjIgw6AgMTI6MjUsIEdyZWcgS0ggYSDDqWNyaXTCoDoNCj4gT24gU2F0
LCBBcHIgMDIsIDIwMjIgYXQgMDY6MTM6MzFQTSArMDIwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90
ZToNCj4+IEZyb206IENoZW4gSmluZ3dlbiA8Y2hlbmppbmd3ZW42QGh1YXdlaS5jb20+DQo+Pg0K
Pj4gVGhpcyBpcyBiYWNrcG9ydCBmb3IgNS40DQo+Pg0KPj4gVXBzdHJlYW0gY29tbWl0IDU2NDdh
OTRhMjZlMzUyYmVlZDYxNzg4YjQ2ZTAzNWQ5ZDEyNjY0Y2QNCj4gDQo+IFRoaXMgaXMgbm90IGEg
Y29tbWl0IGluIExpbnVzJ3MgdHJlZSA6KA0KPiANCg0KT29wcy4gRG9uJ3Qga25vdyB3aGF0IEkg
ZGlkLCB0aGF0J3MgaW5kZWVkIHRoZSBjb21taXQgYWZ0ZXIgSSANCmNoZXJyeS1waWNrZWQgaXQg
b24gdG9wIG9mIDUuNC4xODggYW5kIGJlZm9yZSBJIG1vZGlmaWVkIGl0Lg0KDQpBY2NvcmRpbmcg
dG8gdGhlIG1haWwgeW91IHNlbnQgbWUgeWVzdGVyZGF5IHRvIHRlbGwgaXQgRkFJTEVEIHRvIGFw
cGx5IA0Kb24gNS40LCB0aGUgdXBzdHJlYW0gY29tbWl0IGlzIGRkNzUwODBhYTg0MDljZTEwZDUw
ZmI1ODk4MWM2YjU5YmY4NzA3ZDMNCg0KVGhhbmtzDQpDaHJpc3RvcGhl
