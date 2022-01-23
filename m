Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC57549728C
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 16:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237597AbiAWP3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 10:29:38 -0500
Received: from mail-mw2nam08on2090.outbound.protection.outlook.com ([40.107.101.90]:41457
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237596AbiAWP3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Jan 2022 10:29:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcGSVlH49rVHIfANbgXAzNylbglEE+38MN/fd00nuJ69Q2vozlsBlbZ+JWE3qUF+FsRmBEqgZIx80jwoEq1M1nZ0EW52QeyFf+vU+3/Kme1UQEU6wE7GJoCiOLISapluHs+J7VNXenxlaxM3NEtVoUA+ZhwuLu/3m3jdn8XI9G0If+4rjX2uDmr/a9W0VTm6ONN4Dk0VaHeUPvLKphT5vv8VwjB0JSTLrTivBigJjF/kGNpjKEp4eA2NT9rRC0jINtvfkFpUw3tx9Wi63YyGkhtV+tyWeDinx1YzWaQd2F3QNgH7JsnB4B9nW4pa/8HOnRk8AOI1Csyj+lj4qqY2Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HfeY/49ZrOpr2U0QI6KetxSAkdRbq9KYn47fa68R14=;
 b=HeoFrME2nb804Q7gt9CQhIye4MpVTbnzmG5P60GVVH6j7/rHjMDSRLtQgOr8kzIjKf+8DMfuJ9Rp+6RLwr5kkWtoQ2GXoS/4bXMl9g3EQspt+lZBcMT5Fbgln7NIz/St7QuD+jp0TyqhWrcQ/C2PBzXHW7gLpQ2afGwxbJXmL4pRxOzh+6OXmE6h2tgIH0k3QwK3tp7aAiyHoieg7xDBaS9gYoKW7BIHmG7yX/6ZWmMu1Kw9VlsimZx+yGoTLvoL5Tj3tjpCINGN5ECBptLvbKEfcOxyzIiFruHCn6yOnFw3LP9hrCrIvw9ikjRswqQfHnlTqH9gmqlfbXv3nAj9pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HfeY/49ZrOpr2U0QI6KetxSAkdRbq9KYn47fa68R14=;
 b=JUPchwGEeqdDQ9kfOUaD89LkUz/UYhoC47t5WpQPIAQ8cYNJPY6hAbSkPRZ4V/BLOg72XNI0s59ZSnb+F41wb8HqMlGsPGN5KKZYEELB7P7KcHZ8zPxOWPkZPuU8TDyytP3fDkbN9lZGvBaEdET/wYcKOEnAzlffscz+fSL0YZs=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by DM6PR13MB2988.namprd13.prod.outlook.com (2603:10b6:5:19b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.14; Sun, 23 Jan
 2022 15:29:35 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::ecb4:77ee:a645:9bae]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::ecb4:77ee:a645:9bae%5]) with mapi id 15.20.4930.014; Sun, 23 Jan 2022
 15:29:35 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "dan.aloni@vastdata.com" <dan.aloni@vastdata.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Anna.Schumaker@netapp.com" <Anna.Schumaker@netapp.com>
Subject: Re: [PATCH v3] NFSD: trim reads past NFS_OFFSET_MAX and fix NFSv3
 check
Thread-Topic: [PATCH v3] NFSD: trim reads past NFS_OFFSET_MAX and fix NFSv3
 check
Thread-Index: AQHYED6pGTsuAwY3o0CcN1/+0O7c6Kxwu42A
Date:   Sun, 23 Jan 2022 15:29:35 +0000
Message-ID: <58db6c327e2c72776f051a987f9b813606c53a71.camel@hammerspace.com>
References: <ADEC85C2-8D72-4E25-A49B-2039C1FF82F2@oracle.com>
         <20220123095023.2775411-1-dan.aloni@vastdata.com>
In-Reply-To: <20220123095023.2775411-1-dan.aloni@vastdata.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcabb44d-6264-40c8-5efa-08d9de852968
x-ms-traffictypediagnostic: DM6PR13MB2988:EE_
x-microsoft-antispam-prvs: <DM6PR13MB29882FCA50DA308B545BE39BB85D9@DM6PR13MB2988.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vBBaKjTZZF234bvSCCVn9e74HzVHAK3J7Mkp1zlDsf7YKVu7BFHz9Bf17l8LmkvoasnMsQjNfKoxsLtguITkqx0CPKZ6ufXFjnhCVRGtCUMgPJ2ndqogONS4FYE4gGFE6SvMkgibUYubyD43JMyg4q6lx77Suqmr5u9UjSLqhyQ+FaHDBUyGZUlmb/OItSxaOpycg2u+b9cT/zEKiI4/ZKqcmTK4kNK+XxASo8hayxR8Qcfj/fYdfKlj6wCPgSGZan3xfoGz//FHEzScgNShG2wIWdOtScTXnm5fmWWUnsPM2t8UKWqb/KG/PNE7d0yqi0dxnBbDP68FWrAY6peyUyFUAmlNAzbQF1PrC3rUBBDAdKK0lRXAtrdHp7tC8gS3K8pgE8r8zQo57DhqhCkGkNkIA97v483GFcI0cFla8f3fwATjv7Gihghxa1bT3wgNzeXoGzJjW6k0VyGfSiscJNNIVYWhsOPBl9220bEgHjPzDsJjyYnjGmtNwhSu5qYL3qh4LGn1zpwTLmXQCBAYxPXydP5YR6Atj0rJZiLWl8l1m46v9lEx9lDLTjlNrtumFAkieGZNaQ4/2RrZWcy53+EAhT4x7HPi06fMd+y/ND9hDQMsu31XFs2ZYPhEUTtHp0T/1aSXy7EysLaW3s2njm1kEB1JidnIPgIF//51QXfWdZX1/mYXXPY5gQz3rM2OFuHgZVmKQ7UUNzdc56qYTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(136003)(376002)(346002)(39830400003)(38070700005)(86362001)(6512007)(2906002)(71200400001)(6506007)(122000001)(8676002)(4326008)(8936002)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(110136005)(54906003)(316002)(508600001)(6486002)(5660300002)(38100700002)(36756003)(2616005)(83380400001)(26005)(186003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDE5Y0d0R0VLRFVMOXZjWWZVSmYrZHU1QmVaMjQ4R3FyWlNQZFJCbjVDVmdP?=
 =?utf-8?B?VnlCaHlFaW5qTzhPeGtCa0pScGJlbFE4akd0VnB4QjRKL2VIOVdZRkpBWE9t?=
 =?utf-8?B?dGVqMXlIN2tEZzRjTk0yWHZQWlNhcHlIQlo3ODZZUG9odm1nczdRMWJCTElw?=
 =?utf-8?B?UlkzSU1nNFFzVFB5bHIrQ3dPYXdUbnprZ1ZHVjFkU2xjSmozWmVtVUFvcmJy?=
 =?utf-8?B?dEI3YmNleDZ5b0oyM3B0a3RQdjZ5bjI5MlFXK0l6Mk1hNWVyVmFpZGRvUG5h?=
 =?utf-8?B?NVlUOFluYzdWZ1FFMXlpVVQyN0MwdzBaV3RSekZOMlAwWDBta2pWK0pxVkM1?=
 =?utf-8?B?YWFGRnpUYnlYdStBMitHVWZsYm9QMkd0WTFSQUNOaEg2MWw4dmRXaHJmTzFs?=
 =?utf-8?B?OUdPWE5leWphMFhmZ1J6ZHFCRWhnaE9DVm5vUEdmMTFBbklEYVJ0SWJUT2dx?=
 =?utf-8?B?OUEzaUxtOWxwMnhOaHVxeTBZWGxvandES1EvTGUyVTJjdTI5YUVKL3FlL1BH?=
 =?utf-8?B?YTV1dmFGY0s2Z0hsbVBPdkFQN1BKNDVYWmpWYVRNankvVmJaaTNFcjZuMlZQ?=
 =?utf-8?B?QktLV05CSU5xczgrZ2d2andPTTdpVm9iNUxoTGIzaE13TzVFSlZYbDBscmln?=
 =?utf-8?B?TVdhTjRUZ3lxbzNrRXE3N1FhaW5EWjArK0VqZHpSZ1BWbDlzUmJ6dTFRV3Bq?=
 =?utf-8?B?VStHRk5BQzZ1Qkc3YW1iSjdIeEVVblYydXlPUG5SOE5LbGJ6Q1pQaTUvUnFx?=
 =?utf-8?B?eUdBb1pSM0FISnhwSG4xYVdOTFloMDAvZDBBQXRwbjNzeUdEcFJwdnFWRmVL?=
 =?utf-8?B?d2l1L2dLbG1XRTJpUnc3YldScTFDRHRQRVlDNXhtMmN5YWRWRFhQMzMxbjg2?=
 =?utf-8?B?a20rb0lsSCtzUWZrK1laYUdSeEtQT1VMQ1lxa2c5WEdvRWduTldWN3Q0a3dN?=
 =?utf-8?B?cXRMQ052bk5JeVk3VEVYMEZHdnJ4MmtxbU44Vzc4aGlyVDlpN1BSaTlYTnVa?=
 =?utf-8?B?TGJrdk1SNU11Rk9OZ0I2cERFdGtzQzcxOURCRnpXVlhYVGJZeGsxR1NlRUdX?=
 =?utf-8?B?dFFDMzAyVk5FTXo5MWdpYkxlNXY0cFcrTzJqMHYzdjgzWElEMXhPNWpKMUFD?=
 =?utf-8?B?QjBXTm51T1JYQXcycUg0OG5ORmM1TlFCd3B5NTRnR2dIWVdsVERxWEpZM2hI?=
 =?utf-8?B?QzFqME1DdWJhaFNXdzBPUTNEbkpzMy9ycFd5R3FVcW9aSDNVTk5keFUrT3Bm?=
 =?utf-8?B?UmNqT0YwVXZuYnlTQytwTzY5akM0QkJnaUk2bHo3ckJDMGFaRVQwc0l1ZTBi?=
 =?utf-8?B?T0JRSGVnUmpoSUdCK2pGQzA3UlduNHJVVG03VGZqcnIwNmRQUFNxeVQ4MEM5?=
 =?utf-8?B?UEhkRGVHL1hOWDJ5K1B5L3dkWUdjSE9pSis2NmU4b1dzU2tTdldWazNoa2gx?=
 =?utf-8?B?cy9UR0paT1kwc0FhVWFGdlpqS2FzN2RuR2hueGt2bEk3SmZXb3d3bzQ5Nmlv?=
 =?utf-8?B?U0E4ZjJZOFdBMC94U0l6QWRzRWx5dVdPSGhHZDBGUXAxdzhLci9VaTVGVzcz?=
 =?utf-8?B?RElVd2VNdkpSY3NmK0ZsSlc0NE0yRGwvVlFuV3RPdVNBNFdRSHZIaGRWL0Iz?=
 =?utf-8?B?d0txaGFaMDJwV2dtUDNWTDZHWnFvV1ZVM2drWE8xelNNM2JqUms2eUYzTDF0?=
 =?utf-8?B?NnVKRDdPVmpIeEVxY0lXVnpKNjd1U1YwZ1ZLZ25kMFFVWCtRMmplbW1ZeXc1?=
 =?utf-8?B?OWc4VmdHMC8vNXYyU0Y0QzJCZWswaHcrQUhyc3hjQW5qTnQvdER2Q0dnNW4v?=
 =?utf-8?B?MGorcEx4VHR4aTZaTzJhM3htQTZ6cDVQblhUdkttTlR1anNvUG9tNDFOcEtG?=
 =?utf-8?B?Q1BKK2dhTGpTNU0rUTYzekdMaDRpWTZ5VFVSYTk5Y0dwOTV1VjNaT3ZWM25X?=
 =?utf-8?B?STNiNmNXajF1Y1lYZVZHV3VRTjlEZzM5UkpPVWEzelh6SjllbWg2WDJ0WEEx?=
 =?utf-8?B?RWxFMnp1SnZpc3lrWkJsWi9RMjV3S1U4bzdhNE1BNGlsMmY0ZWpNeWgvMkRz?=
 =?utf-8?B?VEJvR1NPVVpFaklwWjJpdGFjdTM2LzNDRURWWmxVWVZUR2l6bHpjT3U5VzFy?=
 =?utf-8?B?RnNTRDlvUjNOUGpUQjdVcGU4TDVRcytNT3c1OE5GaTA4RTdKZzRGOGM3VWlU?=
 =?utf-8?Q?71DMIlvx69Bqr3g6R0974WI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <609555C5B9FBDE4D8C9990FE95FA80AD@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcabb44d-6264-40c8-5efa-08d9de852968
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2022 15:29:35.5264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jv3RTfvTY/Ht28VH9A+B9Aki/esigt9Bl/Fk+c+swte6eZCiYexGmznA1eG2MIHZff+w6iwPZF3MD1ECWV+tKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2988
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU3VuLCAyMDIyLTAxLTIzIGF0IDExOjUwICswMjAwLCBEYW4gQWxvbmkgd3JvdGU6DQo+IER1
ZSB0byBjb21taXQgOGNmYjkwMTUyODBkICgiTkZTOiBBbHdheXMgcHJvdmlkZSBhbGlnbmVkIGJ1
ZmZlcnMgdG8NCj4gdGhlDQo+IFJQQyByZWFkIGxheWVycyIpIG9uIHRoZSBjbGllbnQsIGEgcmVh
ZCBvZiAweGZmZiBpcyBhbGlnbmVkIHVwIHRvDQo+IHNlcnZlcg0KPiByc2l6ZSBvZiAweDEwMDAu
DQo+IA0KPiBBcyBhIHJlc3VsdCwgaW4gYSB0ZXN0IHdoZXJlIHRoZSBzZXJ2ZXIgaGFzIGEgZmls
ZSBvZiBzaXplDQo+IDB4N2ZmZmZmZmZmZmZmZmZmZiwgYW5kIHRoZSBjbGllbnQgdHJpZXMgdG8g
cmVhZCBmcm9tIHRoZSBvZmZzZXQNCj4gMHg3ZmZmZmZmZmZmZmZmMDAwLCB0aGUgcmVhZCBjYXVz
ZXMgbG9mZl90IG92ZXJmbG93IGluIHRoZSBzZXJ2ZXIgYW5kDQo+IGl0DQo+IHJldHVybnMgYW4g
TkZTIGNvZGUgb2YgRUlOVkFMIHRvIHRoZSBjbGllbnQuIFRoZSBjbGllbnQgYXMgYSByZXN1bHQN
Cj4gaW5kZWZpbml0ZWx5IHJldHJpZXMgdGhlIHJlcXVlc3QuDQo+IA0KPiBUaGlzIGZpeGVzIHRo
ZSBpc3N1ZSBhdCBzZXJ2ZXIgc2lkZSBieSB0cmltbWluZyByZWFkcyBwYXN0DQo+IE5GU19PRkZT
RVRfTUFYLiBJdCBhbHNvIGFkZHMgYSBtaXNzaW5nIGNoZWNrIGZvciBvdXQgb2YgYm91bmQgb2Zm
c2V0DQo+IGluDQo+IE5GU3YzLCBjb3B5aW5nIGEgc2ltaWxhciBjaGVjayBmcm9tIE5GU3Y0Lngu
DQo+IA0KPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IERh
biBBbG9uaSA8ZGFuLmFsb25pQHZhc3RkYXRhLmNvbT4NCj4gLS0tDQo+IMKgZnMvbmZzZC9uZnM0
cHJvYy5jIHwgMyArKysNCj4gwqBmcy9uZnNkL3Zmcy5jwqDCoMKgwqDCoCB8IDYgKysrKysrDQo+
IMKgMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9m
cy9uZnNkL25mczRwcm9jLmMgYi9mcy9uZnNkL25mczRwcm9jLmMNCj4gaW5kZXggNDg2YzVkYmE0
YjY1Li44MTZiZGYyMTI1NTkgMTAwNjQ0DQo+IC0tLSBhL2ZzL25mc2QvbmZzNHByb2MuYw0KPiAr
KysgYi9mcy9uZnNkL25mczRwcm9jLmMNCj4gQEAgLTc4NSw2ICs3ODUsOSBAQCBuZnNkNF9yZWFk
KHN0cnVjdCBzdmNfcnFzdCAqcnFzdHAsIHN0cnVjdA0KPiBuZnNkNF9jb21wb3VuZF9zdGF0ZSAq
Y3N0YXRlLA0KPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHJlYWQtPnJkX29mZnNldCA+PSBPRkZTRVRf
TUFYKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBuZnNlcnJfaW52
YWw7DQo+IMKgDQo+ICvCoMKgwqDCoMKgwqDCoGlmICh1bmxpa2VseShyZWFkLT5yZF9vZmZzZXQg
KyByZWFkLT5yZF9sZW5ndGggPiBPRkZTRVRfTUFYKSkNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJlYWQtPnJkX2xlbmd0aCA9IE9GRlNFVF9NQVggLSByZWFkLT5yZF9vZmZzZXQ7
DQo+ICsNCj4gwqDCoMKgwqDCoMKgwqDCoHRyYWNlX25mc2RfcmVhZF9zdGFydChycXN0cCwgJmNz
dGF0ZS0+Y3VycmVudF9maCwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWFkLT5yZF9vZmZzZXQsIHJlYWQtPnJkX2xlbmd0aCk7
DQo+IMKgDQo+IGRpZmYgLS1naXQgYS9mcy9uZnNkL3Zmcy5jIGIvZnMvbmZzZC92ZnMuYw0KPiBp
bmRleCA3MzhkNTY0Y2E0Y2UuLmFkNGRmMzc0NDMzZSAxMDA2NDQNCj4gLS0tIGEvZnMvbmZzZC92
ZnMuYw0KPiArKysgYi9mcy9uZnNkL3Zmcy5jDQo+IEBAIC0xMDQ1LDYgKzEwNDUsMTIgQEAgX19i
ZTMyIG5mc2RfcmVhZChzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwLA0KPiBzdHJ1Y3Qgc3ZjX2ZoICpm
aHAsDQo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZmlsZSAqZmlsZTsNCj4gwqDCoMKgwqDCoMKg
wqDCoF9fYmUzMiBlcnI7DQo+IMKgDQo+ICvCoMKgwqDCoMKgwqDCoGlmICh1bmxpa2VseShvZmZz
ZXQgPj0gTkZTX09GRlNFVF9NQVgpKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuIG5mc2Vycl9pbnZhbDsNCg0KUE9TSVggZG9lcyBhbGxvdyB5b3UgdG8gbHNlZWsgdG8g
dGhlIG1heGltdW0gZmlsZXNpemUgb2Zmc2V0IChzYi0NCj5zX21heGJ5dGVzKSwgaG93ZXZlciBh
bnkgc3Vic2VxdWVudCByZWFkIHdpbGwgcmV0dXJuIDAgYnl0ZXMgKGkuZS4NCmVvZiksIHdoZXJl
YXMgYSBzdWJzZXF1ZW50IHdyaXRlIHdpbGwgcmV0dXJuIEVGQklHLg0KDQo+ICsNCj4gK8KgwqDC
oMKgwqDCoMKgaWYgKHVubGlrZWx5KG9mZnNldCArICpjb3VudCA+IE5GU19PRkZTRVRfTUFYKSkN
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpjb3VudCA9IE5GU19PRkZTRVRfTUFY
IC0gb2Zmc2V0Ow0KDQpDYW4gd2UgcGxlYXNlIGZpeCB0aGlzIHRvIHVzZSB0aGUgYWN0dWFsIHBl
ci1maWxlc3lzdGVtIGZpbGUgc2l6ZQ0KbGltaXQsIHdoaWNoIGlzIHNldCBhcyBzYi0+c19tYXhi
eXRlcywgaW5zdGVhZCBvZiB1c2luZyBORlNfT0ZGU0VUX01BWD8NCg0KRGl0dG8gZm9yICdyZWFk
JyBhYm92ZS4NCg0KPiArDQo+IMKgwqDCoMKgwqDCoMKgwqB0cmFjZV9uZnNkX3JlYWRfc3RhcnQo
cnFzdHAsIGZocCwgb2Zmc2V0LCAqY291bnQpOw0KPiDCoMKgwqDCoMKgwqDCoMKgZXJyID0gbmZz
ZF9maWxlX2FjcXVpcmUocnFzdHAsIGZocCwgTkZTRF9NQVlfUkVBRCwgJm5mKTsNCj4gwqDCoMKg
wqDCoMKgwqDCoGlmIChlcnIpDQoNCi0tIA0KVHJvbmQgTXlrbGVidXN0DQpMaW51eCBORlMgY2xp
ZW50IG1haW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9uZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2Uu
Y29tDQoNCg0K
