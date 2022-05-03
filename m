Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E96D5189F2
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 18:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239595AbiECQdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 12:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiECQdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 12:33:32 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120047.outbound.protection.outlook.com [40.107.12.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875B93CFDA;
        Tue,  3 May 2022 09:29:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtHUsAB5W48taibYShd8Eu8jePsMpj/OCcbNFkJcv9+Cp7aceej5oJGWux1pn8uxe5EA1GsORGZIp3zXmwIuIDnm0rCXz9A2zkvt6QcloZEVlT6acWQyfuyHkvHCHnMgJldX0bsgn9DxN+TaEXKqNXprZejPvZj9+2QNortTe1fUNsYDs5ZbgNc6cKXP83H9mg7UhWTwhQFy0h+6hPyCgHFZYxpjHVIm/HlClytTqbzu4pMyJ5K+nVpOIkLSlNgEk8UoP6OGGLOpo4nVaW7M23OY/jgA7tc9fO958cpfBRJBDQTcz6BH3poQKbKWZpRPA/5C/+TBuOdqcKouUI0+FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNrfKt7HG/dG8l1hoKvQxLMGwlcLcC49DCWLtMJVBxo=;
 b=Nf+EXBoLVQedIbQSr5PEJH8c0aPTnM0dB9cg2Y/MWuxywER/vcwciAjnrUEfqtidRJTADhVI4lZCUg15UaVk37gkEl/pSml4BaQqu50P7vXPUXZOBYiJ5TrsF7QfTL1zmWmjb5FTFr7Ouz/NRG1kqgEtkZoLR6NquHs0wsBOWZB6dYmcB88rjT6G9dBFaai0cB8nCgvy1LRU27xZ44qFaNqElXEGB3qH2bjQ1v7CQaITPRLCMCP8HSfhi8F7lZcb0iHOWWitonQEE0j6Bpce8D5hYKbmS5T3ARhAkt6F29lfjHe3H/BvHKv6BJWs14XVQjJkYzQ/dTs95OyUz6+Ptg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB2282.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:b::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Tue, 3 May 2022 16:29:56 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::d572:ae3f:9e0c:3c6]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::d572:ae3f:9e0c:3c6%7]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 16:29:56 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v10 01/13] mm, hugetlbfs: Allow for "high" userspace
 addresses
Thread-Topic: [PATCH v10 01/13] mm, hugetlbfs: Allow for "high" userspace
 addresses
Thread-Index: AQHYTDXTc6nJz/9FiUetEQLF9kSaY60NfZ4A
Date:   Tue, 3 May 2022 16:29:56 +0000
Message-ID: <78cf869b-1b28-5a4a-682b-50162c978e6d@csgroup.eu>
References: <cover.1649523076.git.christophe.leroy@csgroup.eu>
 <8b82565b407d04b6e6c4a564423a4e68bde6e39d.1649523076.git.christophe.leroy@csgroup.eu>
In-Reply-To: <8b82565b407d04b6e6c4a564423a4e68bde6e39d.1649523076.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfa154f2-123f-4783-8e86-08da2d2228b2
x-ms-traffictypediagnostic: MRZP264MB2282:EE_
x-microsoft-antispam-prvs: <MRZP264MB228249B9AC3285E4B93E06DAEDC09@MRZP264MB2282.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XrVL3wHXgXvVnD3Tcu8D7IondR/5HomN+QSqPaNhoCCrbF3z9I+NSfr9ev/hXtmZdUQxfEmLaGxTTsdZDRGyHckFUX+Uh9S1X9qkuFedz4SIPapz7ysAMYOlUObmtHmAo+ZdeiFgu9cLXqB2wUzzftGzCz9Idk7pupKVT/uuG8uXp9+PlPqrZ3i2ih8e0b/rAJGXKaGTrBG009tJ18w4C/2levJfy2i7qG3dufQ15wX+A2GMGf5KxCRez3Txr4Nt6Hny7d0W5hcS/X1dqrP94Vu0SertTHPEAbUsRW0wqZxKociS+8Eo+87a+jLF4wXQHlD8oG4kLhE8cM1LLfAPGCGjPLCFdFzYGZ/lfsStfCCYYHBkexvQpJRrYStdpG0XLuWdM26u2qYPkDvtCSwz3BalzXtKJfNM/w5bfP0x7w0EZ9qFx4SMc/SkrHhapQNNwsXmyYnwP+RzppE5z7Kyc7UyoN1wK15Mw0acaFpjzHohng9RefDbZ8VZ4lRxRpuPPyH71SRyn49CWN1asb9ttTOS2+/AELUfdbYt/2qQ2FqcYUjbI1Jh7amT4E7iEq9RkN9bbeY5qJhzT+dBvi4n40uT6ICzmYFbkQvV5TvhtsGEPk3LMvZfhUifveFNUgEq1cm71y+qlvd3a5xTcc8Jex+KNiWSGVBVxZEQLALPJr2ShzZvxtP9H6MzkjNwen6Os6QRu5VtW6sASQxBrYXp7uQfiC6hh1jjm93sW8GJNQhfx8ms7UqBPyU3CEKxwWPv0cRDGq9Gp8wnnbt/O4yA72WRbl/6vb71kU6TES6faMUb5/0zZJCs/6DuHqQ2jrrNonYLhoEjbqRs80w9GJYqW+j6+HJ4S8gLcm4WOY8Ices=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(66946007)(66556008)(66476007)(66446008)(64756008)(66574015)(31686004)(91956017)(8676002)(4326008)(83380400001)(76116006)(2616005)(54906003)(110136005)(186003)(316002)(6512007)(26005)(31696002)(86362001)(2906002)(6506007)(36756003)(71200400001)(5660300002)(44832011)(38100700002)(508600001)(122000001)(6486002)(38070700005)(966005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2JRUW1KZks3Y2tYMlhHVityaFF3Y3VhOExGemdkUDhzQ3FOOGpKNGlDTTha?=
 =?utf-8?B?UTgyZnhSOEpZWi9qKzVIRmIzV1ZId2FuOTlXTXk0OGlEMTFxdTNMdU9FSG9T?=
 =?utf-8?B?NmprL2lpRS9PaHBvenluQzdVcHlURVRXbDB3SXF3dC94UzlibW9yRmZyMzFR?=
 =?utf-8?B?Tm9CY0FLOUFsc2pvL1BIWkY4akY5SUJtWDVMNU43RTBWWVV6L2FoMGNoeXF1?=
 =?utf-8?B?ekhMc1RSQlVzOHZHcFIwSmtiNmFVTGliLzkxTXZKVis0cUdHdWIvRzEzeFdY?=
 =?utf-8?B?N3YxalRoVzRXZS9KUko3VlBJQmFHdUdHenJuK0lpZU8zQ243KzBjem00dWJW?=
 =?utf-8?B?NUVJaEU4dTMxTkFCNzg3aHE4TVJoL0hyT2ZSdENQTSt4U2xpTDNTcXBscDNs?=
 =?utf-8?B?dzJTbTVuSnFkbDd6U2R5Nmh4Ni94VllpSW9CZDlyV1NnQUxvczV4UDkzUHBv?=
 =?utf-8?B?dE5OK0IxK3p5ekN3aHdyS2tpYXdYNjdkbVV4cHRCZWVFME1ITkRKRzJ5OVRG?=
 =?utf-8?B?Q2dYV055VjJBUmtkWFZDUUdtRXZSZ3Q3RE5RalQyVmlvcHU2ZEdaQk54Qjdi?=
 =?utf-8?B?akE0UnE0YjQ3V1oxQXJiUDV0eGpWZE05SWN3MmJ1U2xRdGJjUjB2cGptTzNz?=
 =?utf-8?B?bi9vS1l6UXJYZ3dxa0phRC9QVWowbXRMWmwrTDQ1S1hPQUhXRWF6NFFNTTVH?=
 =?utf-8?B?VWxodHU2bTRPMExGN3Zxb0R6TlRJUkpJL2ZHdXkvN3lpYUFLcFBpYmF6by85?=
 =?utf-8?B?ZVlzUGhLbmZJRWNZbUxuZnBjaWZpWElOWVV3UTRsZE1LbE5qdVMxNGtkdHY2?=
 =?utf-8?B?ZXdKU2s3ekpXZldZOVovUVdXTVVYTDloaENTRkJTV0hGbjZuQnFBcjhuZ3Nh?=
 =?utf-8?B?S0M5RERMM09pS3o3Z0NFRmNRUzBBS3RDaEVsVjBlV1k5bllsOVZYS0Zzb3hP?=
 =?utf-8?B?RUwvdFVPUWdsRXZLR042NmhENWs0ZDZlZmRmM1lhZmNIdzNJSTJMTkNmUEE4?=
 =?utf-8?B?WnZBdWN0dXVaTGN6bkFadFRRVWlXUVZVbXc2SkxHSUZZQVNDVW1OeGwvMWFZ?=
 =?utf-8?B?WjNCV2RteDd3VHNJR01PeXI4Q2JvdTdmc1VZTURXK2VIbVdxUUEvT0dnd3Fk?=
 =?utf-8?B?eFpYTzR6RGxobE1GTHJHU2JKZy9MT1RXVmNKWXR4THJodVg3VGxuL0dPb3V4?=
 =?utf-8?B?WXBLSWxYbHFzVWlTNkpBTWVHZmtOOFhuQzBUcndzOWtSWUhyekwzT2RpaHlC?=
 =?utf-8?B?b1pDdmlYR0hBUXF4V2ZDNW1EWDQ3U3JUbjhwV3NSVVRZajd2ODA4T3p1V2xO?=
 =?utf-8?B?SFhaNXBpS2lHeUpUaXp0WUxQaEpnV0ZWWnJuZTdUcXZpWU9xUUloVFV1Unkr?=
 =?utf-8?B?aTBsTjFsQzdyUzdLaGNSZnZQTTNPdmFqbjZEY1VObDdINWxQRzM4SFd6WllG?=
 =?utf-8?B?Nk1HckhudU0xOVYzeHJLTTR3VlNiMW1zdStEVEV1K3FnTHVsL2ZBenlSdSsz?=
 =?utf-8?B?cDNtd3hqMlVkNjVqdFZBbGhCSGp3ajY2NGVYS0ViN3ltTktXTWxER0VwcWQ1?=
 =?utf-8?B?d1ZFSFAxdnhZTDVDeFZONWt3NUVMQlpManRHN2pEaU1Qd2NGbWR5WG5sdmVa?=
 =?utf-8?B?emd2clVEOHlyRlAzR0wwNTBGMHJNVWl6aHoyMFhuci9iQngvVGRPWnRpMVlI?=
 =?utf-8?B?ZlBKSUt1Q2RXV3NidlA1eWw2WWJHd0Q4TTVGbWp5RU9VYTM2T01hY29UMmhH?=
 =?utf-8?B?WnNDRFovT2JIdjJWYzdRZ2RYWDU0V0ozZWZmdWJjNEZIMHdvKzFzL2UxZVNz?=
 =?utf-8?B?N1Q1MzJwMmVsUWpmaFlQNVFtY0JXSlAwMFVRaVhraUhORms1SGNNNmdOdkhR?=
 =?utf-8?B?TklUTjB4aW9wb0ZEZmlldkpyWDNNbHExVG8zcHdDVUZBMnhoTVhnWkVDYXN5?=
 =?utf-8?B?KzNURGw5V284YWJXWGkwcHUrU05ROEF5b0pLcFpveUswV1ZwNGFNY3o2WFVa?=
 =?utf-8?B?MEdCZnRRbVlFc3dqdGN6QkNMV2xRUU1tREpBWloxZERGdlNsL3c1UmJLd1dj?=
 =?utf-8?B?NWdscm1xTDdDVitTc2JXQlhvTGVIYVVHNWpWSnloR01BZDBiOWdNc3J4azdE?=
 =?utf-8?B?T2Y4dk56dWQyc09NWXUvNTFIQjJRczQ2N1MxTzEwSGVEOTdZWGNpbC8vVDVU?=
 =?utf-8?B?NGgrblorS0FNdjhDOFVnL0lmV3RLQjhZZnIwNitoV2xoL0txRno5Si9CME9t?=
 =?utf-8?B?NDhTVnhaNkRwQWFXc0dOQ0c3QS82L1NxdVVZT21RM0NNaVI1RWFleGo1QmZ5?=
 =?utf-8?B?dkkxcHpRRXFUeVlkb3hNZmp3eE1GNHgwVnRTVUQ2dTBZaSsvWmEyRXJrcEFI?=
 =?utf-8?Q?plhwEEaw6B6sLdozx7XN6q9i71ctHO518jAPK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2EF7E0D06A66A438F43A1136965FC43@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa154f2-123f-4783-8e86-08da2d2228b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 16:29:56.0805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i+PxqVe+QOXnpeCoDJB60HdY7I2vA0wNIbiVzFduojYQYWz8gMdnw3qOxL+QqvtxyHo3R1So2xXMutc1rBzLMMMZ6PS0Ze1zQEjFVn8qtqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB2282
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDA5LzA0LzIwMjIgw6AgMTk6MTcsIENocmlzdG9waGUgTGVyb3kgYSDDqWNyaXTCoDoN
Cj4gVGhpcyBpcyBhIGNvbXBsZW1lbnQgb2YgZjY3OTUwNTNkYWM4ICgibW06IG1tYXA6IEFsbG93
IGZvciAiaGlnaCINCj4gdXNlcnNwYWNlIGFkZHJlc3NlcyIpIGZvciBodWdldGxiLg0KPiANCj4g
VGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQgZm9yICJoaWdoIiB1c2Vyc3BhY2UgYWRkcmVzc2VzIHRo
YXQgYXJlDQo+IG9wdGlvbmFsbHkgc3VwcG9ydGVkIG9uIHRoZSBzeXN0ZW0gYW5kIGhhdmUgdG8g
YmUgcmVxdWVzdGVkIHZpYSBhIGhpbnQNCj4gbWVjaGFuaXNtICgiaGlnaCIgYWRkciBwYXJhbWV0
ZXIgdG8gbW1hcCkuDQo+IA0KPiBBcmNoaXRlY3R1cmVzIHN1Y2ggYXMgcG93ZXJwYyBhbmQgeDg2
IGFjaGlldmUgdGhpcyBieSBtYWtpbmcgY2hhbmdlcyB0bw0KPiB0aGVpciBhcmNoaXRlY3R1cmFs
IHZlcnNpb25zIG9mIGh1Z2V0bGJfZ2V0X3VubWFwcGVkX2FyZWEoKSBmdW5jdGlvbi4NCj4gSG93
ZXZlciwgYXJtNjQgdXNlcyB0aGUgZ2VuZXJpYyB2ZXJzaW9uIG9mIHRoYXQgZnVuY3Rpb24uDQo+
IA0KPiBTbyB0YWtlIGludG8gYWNjb3VudCBhcmNoX2dldF9tbWFwX2Jhc2UoKSBhbmQgYXJjaF9n
ZXRfbW1hcF9lbmQoKSBpbg0KPiBodWdldGxiX2dldF91bm1hcHBlZF9hcmVhKCkuIFRvIGFsbG93
IHRoYXQsIG1vdmUgdGhvc2UgdHdvIG1hY3Jvcw0KPiBvdXQgb2YgbW0vbW1hcC5jIGludG8gaW5j
bHVkZS9saW51eC9zY2hlZC9tbS5oDQo+IA0KPiBJZiB0aGVzZSBtYWNyb3MgYXJlIG5vdCBkZWZp
bmVkIGluIGFyY2hpdGVjdHVyYWwgY29kZSB0aGVuIHRoZXkgZGVmYXVsdA0KPiB0byAoVEFTS19T
SVpFKSBhbmQgKGJhc2UpIHNvIHNob3VsZCBub3QgaW50cm9kdWNlIGFueSBiZWhhdmlvdXJhbA0K
PiBjaGFuZ2VzIHRvIGFyY2hpdGVjdHVyZXMgdGhhdCBkbyBub3QgZGVmaW5lIHRoZW0uDQo+IA0K
PiBGb3IgdGhlIHRpbWUgYmVpbmcsIG9ubHkgQVJNNjQgaXMgYWZmZWN0ZWQgYnkgdGhpcyBjaGFu
Z2UuDQo+IA0KPiAgRnJvbSBDYXRhbGluIChBUk02NCk6DQo+ICAgIFdlIHNob3VsZCBoYXZlIGZp
eGVkIGh1Z2V0bGJfZ2V0X3VubWFwcGVkX2FyZWEoKSBhcyB3ZWxsIHdoZW4gd2UNCj4gYWRkZWQg
c3VwcG9ydCBmb3IgNTItYml0IFZBLiBUaGUgcmVhc29uIGZvciBjb21taXQgZjY3OTUwNTNkYWM4
IHdhcyB0bw0KPiBwcmV2ZW50IG5vcm1hbCBtbWFwKCkgZnJvbSByZXR1cm5pbmcgYWRkcmVzc2Vz
IGFib3ZlIDQ4LWJpdCBieSBkZWZhdWx0DQo+IGFzIHNvbWUgdXNlci1zcGFjZSBoYWQgaGFyZCBh
c3N1bXB0aW9ucyBhYm91dCB0aGlzLg0KPiANCj4gSXQncyBhIHNsaWdodCBBQkkgY2hhbmdlIGlm
IHlvdSBkbyB0aGlzIGZvciBodWdldGxiX2dldF91bm1hcHBlZF9hcmVhKCkNCj4gYnV0IEkgZG91
YnQgYW55b25lIHdvdWxkIG5vdGljZS4gSXQncyBtb3JlIGxpa2VseSB0aGF0IHRoZSBjdXJyZW50
DQo+IGJlaGF2aW91ciB3b3VsZCBjYXVzZSBpc3N1ZXMsIHNvIEknZCByYXRoZXIgaGF2ZSB0aGVt
IGNvbnNpc3RlbnQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGhlIExlcm95IDxjaHJp
c3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+DQo+IENjOiBTdGV2ZSBDYXBwZXIgPHN0ZXZlLmNhcHBl
ckBhcm0uY29tPg0KPiBDYzogV2lsbCBEZWFjb24gPHdpbGwuZGVhY29uQGFybS5jb20+DQo+IENj
OiBDYXRhbGluIE1hcmluYXMgPGNhdGFsaW4ubWFyaW5hc0Bhcm0uY29tPg0KPiBGaXhlczogZjY3
OTUwNTNkYWM4ICgibW06IG1tYXA6IEFsbG93IGZvciAiaGlnaCIgdXNlcnNwYWNlIGFkZHJlc3Nl
cyIpDQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyA1LjAueA0KPiBSZXZpZXdlZC1i
eTogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT4NCj4gQWNrZWQtYnk6
IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+DQoNClRoaXMgcGF0Y2gg
d2FzIG1lcmdlZCBpbiA1LjE4LXJjNA0KDQpTZWUgDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD01ZjI0
ZDVhNTc5ZDFlYWNlNzlkNTA1YjE0ODgwOGE4NTBiNDE3ZDRjDQoNCg0KVGhlIHJlc3Qgb2YgdGhl
IHNlcmllcyBpcyB0byBiZSBtZXJnZWQgdmlhIHBvd2VycGMgdHJlZS4NCg0KPiAtLS0NCj4gdjEw
Og0KPiAtIE1vdmVkIGFzIGZpcnN0IHBhdGNoIG9mIHRoZSBzZXJpZXMgc28gdGhhdCBpdCBjYW4g
YmUgYXBwbGllZA0KPiBzZXBhcmF0ZWx5IGFzIGEgZmxhZyBhbmQgYmUgZWFzaWx5IGFwcGxpZWQg
YmFjayBvbiBzdGFibGUuDQo+IC0gQWRkZWQgdGV4dCBmcm9tIENhdGFsaW4gZXhwbGFpbmluZyB3
aHkgaXQgaXMgYSBmaXh1cC4NCj4gLS0tDQo+ICAgZnMvaHVnZXRsYmZzL2lub2RlLmMgICAgIHwg
OSArKysrKy0tLS0NCj4gICBpbmNsdWRlL2xpbnV4L3NjaGVkL21tLmggfCA4ICsrKysrKysrDQo+
ICAgbW0vbW1hcC5jICAgICAgICAgICAgICAgIHwgOCAtLS0tLS0tLQ0KPiAgIDMgZmlsZXMgY2hh
bmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZnMvaHVnZXRsYmZzL2lub2RlLmMgYi9mcy9odWdldGxiZnMvaW5vZGUuYw0KPiBpbmRleCA5
OWM3NDc3Y2VlNWMuLmRkM2EwODhkYjExZCAxMDA2NDQNCj4gLS0tIGEvZnMvaHVnZXRsYmZzL2lu
b2RlLmMNCj4gKysrIGIvZnMvaHVnZXRsYmZzL2lub2RlLmMNCj4gQEAgLTIwNiw3ICsyMDYsNyBA
QCBodWdldGxiX2dldF91bm1hcHBlZF9hcmVhX2JvdHRvbXVwKHN0cnVjdCBmaWxlICpmaWxlLCB1
bnNpZ25lZCBsb25nIGFkZHIsDQo+ICAgCWluZm8uZmxhZ3MgPSAwOw0KPiAgIAlpbmZvLmxlbmd0
aCA9IGxlbjsNCj4gICAJaW5mby5sb3dfbGltaXQgPSBjdXJyZW50LT5tbS0+bW1hcF9iYXNlOw0K
PiAtCWluZm8uaGlnaF9saW1pdCA9IFRBU0tfU0laRTsNCj4gKwlpbmZvLmhpZ2hfbGltaXQgPSBh
cmNoX2dldF9tbWFwX2VuZChhZGRyKTsNCj4gICAJaW5mby5hbGlnbl9tYXNrID0gUEFHRV9NQVNL
ICYgfmh1Z2VfcGFnZV9tYXNrKGgpOw0KPiAgIAlpbmZvLmFsaWduX29mZnNldCA9IDA7DQo+ICAg
CXJldHVybiB2bV91bm1hcHBlZF9hcmVhKCZpbmZvKTsNCj4gQEAgLTIyMiw3ICsyMjIsNyBAQCBo
dWdldGxiX2dldF91bm1hcHBlZF9hcmVhX3RvcGRvd24oc3RydWN0IGZpbGUgKmZpbGUsIHVuc2ln
bmVkIGxvbmcgYWRkciwNCj4gICAJaW5mby5mbGFncyA9IFZNX1VOTUFQUEVEX0FSRUFfVE9QRE9X
TjsNCj4gICAJaW5mby5sZW5ndGggPSBsZW47DQo+ICAgCWluZm8ubG93X2xpbWl0ID0gbWF4KFBB
R0VfU0laRSwgbW1hcF9taW5fYWRkcik7DQo+IC0JaW5mby5oaWdoX2xpbWl0ID0gY3VycmVudC0+
bW0tPm1tYXBfYmFzZTsNCj4gKwlpbmZvLmhpZ2hfbGltaXQgPSBhcmNoX2dldF9tbWFwX2Jhc2Uo
YWRkciwgY3VycmVudC0+bW0tPm1tYXBfYmFzZSk7DQo+ICAgCWluZm8uYWxpZ25fbWFzayA9IFBB
R0VfTUFTSyAmIH5odWdlX3BhZ2VfbWFzayhoKTsNCj4gICAJaW5mby5hbGlnbl9vZmZzZXQgPSAw
Ow0KPiAgIAlhZGRyID0gdm1fdW5tYXBwZWRfYXJlYSgmaW5mbyk7DQo+IEBAIC0yMzcsNyArMjM3
LDcgQEAgaHVnZXRsYl9nZXRfdW5tYXBwZWRfYXJlYV90b3Bkb3duKHN0cnVjdCBmaWxlICpmaWxl
LCB1bnNpZ25lZCBsb25nIGFkZHIsDQo+ICAgCQlWTV9CVUdfT04oYWRkciAhPSAtRU5PTUVNKTsN
Cj4gICAJCWluZm8uZmxhZ3MgPSAwOw0KPiAgIAkJaW5mby5sb3dfbGltaXQgPSBjdXJyZW50LT5t
bS0+bW1hcF9iYXNlOw0KPiAtCQlpbmZvLmhpZ2hfbGltaXQgPSBUQVNLX1NJWkU7DQo+ICsJCWlu
Zm8uaGlnaF9saW1pdCA9IGFyY2hfZ2V0X21tYXBfZW5kKGFkZHIpOw0KPiAgIAkJYWRkciA9IHZt
X3VubWFwcGVkX2FyZWEoJmluZm8pOw0KPiAgIAl9DQo+ICAgDQo+IEBAIC0yNTEsNiArMjUxLDcg
QEAgaHVnZXRsYl9nZXRfdW5tYXBwZWRfYXJlYShzdHJ1Y3QgZmlsZSAqZmlsZSwgdW5zaWduZWQg
bG9uZyBhZGRyLA0KPiAgIAlzdHJ1Y3QgbW1fc3RydWN0ICptbSA9IGN1cnJlbnQtPm1tOw0KPiAg
IAlzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYTsNCj4gICAJc3RydWN0IGhzdGF0ZSAqaCA9IGhz
dGF0ZV9maWxlKGZpbGUpOw0KPiArCWNvbnN0IHVuc2lnbmVkIGxvbmcgbW1hcF9lbmQgPSBhcmNo
X2dldF9tbWFwX2VuZChhZGRyKTsNCj4gICANCj4gICAJaWYgKGxlbiAmIH5odWdlX3BhZ2VfbWFz
ayhoKSkNCj4gICAJCXJldHVybiAtRUlOVkFMOw0KPiBAQCAtMjY2LDcgKzI2Nyw3IEBAIGh1Z2V0
bGJfZ2V0X3VubWFwcGVkX2FyZWEoc3RydWN0IGZpbGUgKmZpbGUsIHVuc2lnbmVkIGxvbmcgYWRk
ciwNCj4gICAJaWYgKGFkZHIpIHsNCj4gICAJCWFkZHIgPSBBTElHTihhZGRyLCBodWdlX3BhZ2Vf
c2l6ZShoKSk7DQo+ICAgCQl2bWEgPSBmaW5kX3ZtYShtbSwgYWRkcik7DQo+IC0JCWlmIChUQVNL
X1NJWkUgLSBsZW4gPj0gYWRkciAmJg0KPiArCQlpZiAobW1hcF9lbmQgLSBsZW4gPj0gYWRkciAm
Jg0KPiAgIAkJICAgICghdm1hIHx8IGFkZHIgKyBsZW4gPD0gdm1fc3RhcnRfZ2FwKHZtYSkpKQ0K
PiAgIAkJCXJldHVybiBhZGRyOw0KPiAgIAl9DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L3NjaGVkL21tLmggYi9pbmNsdWRlL2xpbnV4L3NjaGVkL21tLmgNCj4gaW5kZXggYTgwMzU2ZTlk
YzY5Li4xYWQxZjRiZmEwMjUgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvc2NoZWQvbW0u
aA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L3NjaGVkL21tLmgNCj4gQEAgLTEzNiw2ICsxMzYsMTQg
QEAgc3RhdGljIGlubGluZSB2b2lkIG1tX3VwZGF0ZV9uZXh0X293bmVyKHN0cnVjdCBtbV9zdHJ1
Y3QgKm1tKQ0KPiAgICNlbmRpZiAvKiBDT05GSUdfTUVNQ0cgKi8NCj4gICANCj4gICAjaWZkZWYg
Q09ORklHX01NVQ0KPiArI2lmbmRlZiBhcmNoX2dldF9tbWFwX2VuZA0KPiArI2RlZmluZSBhcmNo
X2dldF9tbWFwX2VuZChhZGRyKQkoVEFTS19TSVpFKQ0KPiArI2VuZGlmDQo+ICsNCj4gKyNpZm5k
ZWYgYXJjaF9nZXRfbW1hcF9iYXNlDQo+ICsjZGVmaW5lIGFyY2hfZ2V0X21tYXBfYmFzZShhZGRy
LCBiYXNlKSAoYmFzZSkNCj4gKyNlbmRpZg0KPiArDQo+ICAgZXh0ZXJuIHZvaWQgYXJjaF9waWNr
X21tYXBfbGF5b3V0KHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLA0KPiAgIAkJCQkgIHN0cnVjdCBybGlt
aXQgKnJsaW1fc3RhY2spOw0KPiAgIGV4dGVybiB1bnNpZ25lZCBsb25nDQo+IGRpZmYgLS1naXQg
YS9tbS9tbWFwLmMgYi9tbS9tbWFwLmMNCj4gaW5kZXggM2FhODM5ZjgxZTYzLi4zMTNiNTdkNTVh
NjMgMTAwNjQ0DQo+IC0tLSBhL21tL21tYXAuYw0KPiArKysgYi9tbS9tbWFwLmMNCj4gQEAgLTIx
MTcsMTQgKzIxMTcsNiBAQCB1bnNpZ25lZCBsb25nIHZtX3VubWFwcGVkX2FyZWEoc3RydWN0IHZt
X3VubWFwcGVkX2FyZWFfaW5mbyAqaW5mbykNCj4gICAJcmV0dXJuIGFkZHI7DQo+ICAgfQ0KPiAg
IA0KPiAtI2lmbmRlZiBhcmNoX2dldF9tbWFwX2VuZA0KPiAtI2RlZmluZSBhcmNoX2dldF9tbWFw
X2VuZChhZGRyKQkoVEFTS19TSVpFKQ0KPiAtI2VuZGlmDQo+IC0NCj4gLSNpZm5kZWYgYXJjaF9n
ZXRfbW1hcF9iYXNlDQo+IC0jZGVmaW5lIGFyY2hfZ2V0X21tYXBfYmFzZShhZGRyLCBiYXNlKSAo
YmFzZSkNCj4gLSNlbmRpZg0KPiAtDQo+ICAgLyogR2V0IGFuIGFkZHJlc3MgcmFuZ2Ugd2hpY2gg
aXMgY3VycmVudGx5IHVubWFwcGVkLg0KPiAgICAqIEZvciBzaG1hdCgpIHdpdGggYWRkcj0wLg0K
PiAgICAq
