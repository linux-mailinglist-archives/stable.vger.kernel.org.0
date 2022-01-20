Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031B349464A
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 05:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiATEIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 23:08:12 -0500
Received: from mail-mw2nam12on2089.outbound.protection.outlook.com ([40.107.244.89]:29025
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229787AbiATEIL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jan 2022 23:08:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haqsCKmbYuLIuIfVSy2g3BhpNce5Gf9CYl7et3xZJ7OMllLjp88lQtDtZZTmOOZhR6t3C4eUOIMUlv1zwDMi0S9k6RL6uskPtg44SjCChJEd+u6FPHDIgOTJHYtIfQtdKlKmQKq3bpiSsOKh7p2HItMbD0YrgRPI72x8kSpZK85wB4M/wR9Z2DSCBftehlvuE5GTHDu0u9paNL4Gq0RGZ/I7qFW93KW2yWT2VYMlSeB/8fqK4GXJBHvvzvNaW50AsrI/ya2lR4Q+u+BmHFw3rAINUyvbyaaCM+JrUWQEDJ3AV5y4fPEMKZcKgcvK87AQiMEqHNTGtCQb8zm6cvvPtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7hbIxu8sJLM7hJojzVg35s+8FmO1R3WoRz3tMWnDx8=;
 b=hBewk+dXTFxglc6GTFuQdbqSUm94/oUKHurbrCBwBsP+HyeYRLFiolHDzo4WM388/fd9CABk7JPLExsWbIAKMkh/2hZY3hnkFUzIe2oPEgV6q2k7Uf80MfQAjQWFAKYhM6FLX5tPXleSgfH72YDnIS6yLPLneaUr8jd7UlaZReMqcP4vzpMK7CXw4002HxK6A7YfKbMA6Bd9v85Gq6jyH83IJzy9BnVq7xSsVHYgSdnYJKNRJqHrJDovuKxTeteYntUDMI+i8DiLa6+2Bsoh75tb/rriCha/z/IvavnHHJcq8q0/hmGE/++X+V5NnxWgMuD/m6U2nemvgB8SStl+UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7hbIxu8sJLM7hJojzVg35s+8FmO1R3WoRz3tMWnDx8=;
 b=TlShNzKNT5bW5jneWYJB8C5JoZr6lHweu7Ex+q+t9sUoDyKiYxNkYzZO8XPF/zdjOxrUZrsL7tw32C4/uWDWulnxKQ15hJJyq/XbPd6qX9gtv9w24aSDpoIGflIyU53OCvp5nAA+yGXf6WEWpI7z3HGlfNCWfilDONiRR+t9JAg=
Received: from MN2PR05MB6624.namprd05.prod.outlook.com (2603:10b6:208:d8::18)
 by BN7PR05MB6401.namprd05.prod.outlook.com (2603:10b6:408:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.4; Thu, 20 Jan
 2022 04:08:07 +0000
Received: from MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112]) by MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112%5]) with mapi id 15.20.4930.004; Thu, 20 Jan 2022
 04:08:06 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "javierm@redhat.com" <javierm@redhat.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Topic: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Index: AQHYC8yinmr5RRCrG02Gv/mSECQCTKxpI6WAgAB5uACAAHSWgIAAUE4AgAAUKgCAAAqSAIAADN6AgADBMgA=
Date:   Thu, 20 Jan 2022 04:08:06 +0000
Message-ID: <ae8faed17403e3285763d21d0700f6f908046190.camel@vmware.com>
References: <20220117180359.18114-1-zack@kde.org>
         <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
         <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
         <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
         <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
         <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
         <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
         <e1861bd2-f59d-bfba-2a07-2e4359a6774a@redhat.com>
In-Reply-To: <e1861bd2-f59d-bfba-2a07-2e4359a6774a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69a836ee-9866-4cb2-448d-08d9dbca7693
x-ms-traffictypediagnostic: BN7PR05MB6401:EE_
x-microsoft-antispam-prvs: <BN7PR05MB6401BFDE660E716842DE0870CE5A9@BN7PR05MB6401.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2WQWTAb00bnYR+J12CbSylmFzgkd88425tk9o6XeYa5oc4NkCHdQeV88sQxIMW0WMouIeW831OauOjbVL6wKgzqOWeT9yikcaYGD6so+laeZUFJGCCg7yfubWeCuF9220+l9+NFekzscQPnK/8h6cKfFARj6Il1AWQ3k1hKuMwV6mPZvV2GN9lFba5J376oSg3OuWt1vV0MxWAv3XxiOdZMCgLNEM1Eygc4oI+k6rjP+QJbxJyZvM4rzDch2TVAl6U4ULe/06wQK1GVhGRqvUNRP8f/dB9TR4eKpoiBMbctnXaGl36ruvap1HmFGNVPnblG8vDWxWlfziF1uhWZXxfLZfU+afk4vwvQJUd6dBM4xh8c/3G65hqSTysZlZStT1N6tS7jcdSCBi0wANpypdrRspjSXPNK2qLCCKuvhzcHmxFD7aEzbbQyT28iH8Bwxk0UKs4C+9kPOqqrqDmrK6Kd2ieAk8WUPd3EWFZMHoJ+FccPzUyOPvuLxXVZXDRcO1PDMAveG0GyCoPZoLlL8CDHDGIVbOzViupauBKEu9oyFfWrOWvDhT1BdHniM7AtfrsWPa4zsOlHFuu5+BhxpcdnnoWR1z9DUKQXbib0cKFuvcUlegQcttUZ9v1Zgti0G/s3m7rfUbhEcLzvAVodY48wsUzSf6bWHSlM8WTDa6s2wZGjlxNBaie/4oX/unXRLdJwiq9c+miRm+bm1UnwNC5Wa2k6BJhIaXsW6mF8uBZvm5diLtNoys03t1CJ45qBT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR05MB6624.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(2616005)(2906002)(86362001)(36756003)(5660300002)(107886003)(71200400001)(54906003)(110136005)(6512007)(8676002)(76116006)(53546011)(186003)(8936002)(38100700002)(4326008)(26005)(66446008)(64756008)(66556008)(38070700005)(66946007)(122000001)(66476007)(6506007)(83380400001)(6486002)(508600001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NU9XS1Y3cDRPQ2RQUFNCQjVBOEZKWGVYR0cyQms0UFYwcFhVcUkxWGVtSm54?=
 =?utf-8?B?N1liYi8xcVBZYWc2ZGdUTjB1NytNMW1wR2dNa1oxdHVXYnBBVW4vOEFIekRD?=
 =?utf-8?B?YWo0MjZMN0JIaFlkQkl5aHBBMVI2cVR4aTc1TVZ6YVczNmM5d3I0NVJjQ1hC?=
 =?utf-8?B?WDkvSFZqcWJFQ3hBWTkyNTFOeVhoU2hRM1huSmJSZ25PdExxU3pzUDlJUmVs?=
 =?utf-8?B?YTIzYUg2dHBNOUd2cTRDRUhUS2pNUVdSUHEzdGhCaTJsNmxXM1d3VEJGWHVq?=
 =?utf-8?B?Z3MrcS9pdzNvVU1haEwzbUJQTWY2RitHMXd2bS9wME84VUtuYjhHQWdzN0xX?=
 =?utf-8?B?ZXVWOXkvcUU5VTM2UmVxeHRDSjVvR3BQdEdibk9Pbys2M2REZzBjeHVvTGJ6?=
 =?utf-8?B?NENSZFFSemJFcnFHUGxFR0krUWRKUTQzZlJZVlAxRUc5WGVjcWNRWFM1WnVZ?=
 =?utf-8?B?UHBjYnVVTFB6cDZyWWJlZHR0MGVRT0YyNndYanlLbTBBSXEwaXlWbTZ2OCsr?=
 =?utf-8?B?K2twMUw2U24yM3NKMElOWE5qZU9NMjBUZDRmVXVBUDdXRExKbUU1Wk9BMnQz?=
 =?utf-8?B?cTN3YkpQalZOai9LUndkeVlUNExLbi8xb0RzUXFrTEQ2Y2I5R3FjY1NVcVFi?=
 =?utf-8?B?RnVxZnhmazEzbFhpQjloUURZdjlXeUtFRjZXL2I0emN6YjI3b1dKUFhsc1Ey?=
 =?utf-8?B?dHlFY0lhUVhTemtsRlpPTDY1cjZyNUl2WmZ4VjhsVVZTTUxibVBTbTJRR0Ux?=
 =?utf-8?B?bnhTZXRLUFlVa1Y2Rjg3L241T3AwNm00TWlqcWpOUHRrUC9nTWZtYi9IQVZ3?=
 =?utf-8?B?MnRjS3d3Lzd0YVZCOXJhZHhiZ1FGb3ZqYzcrQVcybGkzUitaUERHMlVwVDZl?=
 =?utf-8?B?cFk0ZlVrT2E5UHVTL0lNZDEvUWx4U1dEdUQ1a2cxMndpOGNxQUQxZDZrQm9H?=
 =?utf-8?B?NTJ5b3FTQVNPcytJejNoQ2VWdXJ5SG55alNCVWVCQjIzQWVNSndORUVhOFQx?=
 =?utf-8?B?Y3JIdjkxbk84aXpOUm9ZMlRRYTB0czVpcUJ2cmd1KzlkME1UazFoWnUwbmFa?=
 =?utf-8?B?M1dVaEw1NGgwZHl5Vys3YXlFdUpMNzN5YzE5U0VRQmQrL0E2Rm1UTjZCckFY?=
 =?utf-8?B?VXphRG1oUnUvRWxHYitNblVEWTNrWkdxSE5zcWFrOVlPNWJBZ1p6Vk5MMHhF?=
 =?utf-8?B?M1psaGpadnBUVnJoZjJDZWJqNW10U1dVMHZWcnp1UjlvMWFOck9wa3d6TnpS?=
 =?utf-8?B?QWhKOFI5REdqQXdERFZadUVoK050VlVWdjU5L0dCcDFwd1ZqcHR0L3RMOGM1?=
 =?utf-8?B?YmhtYXlsV1lYczdOd0o0YkNHN25VVHpUdzhHa014dlcySU9NTVNJckM3aGdp?=
 =?utf-8?B?MHZMN2VhQlBBQ0JveXFQcXFBeDI5M1lGZ1ZFMXdZaFRydjV3WEV1RDQzUkVw?=
 =?utf-8?B?Y2hVSmR4UUZLSy83bWtPQmsxNUNHWEJUcTlRd0ZNRzdGTWhGVXp3a2Q2ZUV0?=
 =?utf-8?B?OFFKM291dG1rYjBHWFpJZUovdFo3SE9JTU5xQnFCRUVOV1grSkhSbHNCWmUx?=
 =?utf-8?B?TUs3T05mMWtLdGs0bVozMDJSZDVxbk51VldJZHZSanVOVGdlSk1uVGpMNXk3?=
 =?utf-8?B?M1MrK0t5SERIby82MjMyYjRDdUU3K2gvR1g3TXZoMksxL0NlZmt6TVlSbGFx?=
 =?utf-8?B?WkhFaExWbVdvMGZSSHZxa1d0TmpiQXFtS2lKMnlYQVg3UUt4VkxkeU8xNlJm?=
 =?utf-8?B?TlJ1Z3lZVjFKQWxhTjlWUWhVWmpuZmhOZ2RWQUVyRGN5SWRvczFiT1ozRk5m?=
 =?utf-8?B?Q2tFVXFiZjdzSld4Y0kxVGlOaThXN0RoeTF1TXZQc0NnemtlUTI5OGtQd1Ny?=
 =?utf-8?B?alJNai9WYW9LZndISFd5cWxxV3hnTWZzdnl2WGkxa3BpODRRaEFQbURQS3Fa?=
 =?utf-8?B?cjNaM2R3RnlmeWdlYm8rTHhDWFVNbHkxaHROYW54aERwRzQ0NkJ1cWN4L0JD?=
 =?utf-8?B?SWpLbjY1WGptejR5VGM3d1E3aVV6MXd6a3NWZ0xuT3FHKzlwQTB5MmtMd1dV?=
 =?utf-8?B?MDlteURqUVZsM3lPWVd3NnVYSVd1bnBBd0xra2llbmRjZmNhOHhnUWFvb1c3?=
 =?utf-8?B?SW84dHlMT2s5aXkrUEprZnErUUV3dkJXUU1wUlhzd2hvbUpPeWxNS2JJY0E0?=
 =?utf-8?Q?68m+UUpFrq5ucCtGBWFdBH8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <928DEAA9E20D484DAD49F127D2841CAA@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR05MB6624.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a836ee-9866-4cb2-448d-08d9dbca7693
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 04:08:06.7937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vL0xwBHm12cBnTzMOtCStoSejMX1Cmu3WaazSDnl+TPdA93iPpt8QuQ9ffHCeDcpMjUZ4G7/H11iAfUOJV2mwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR05MB6401
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTE5IGF0IDE3OjM2ICswMTAwLCBKYXZpZXIgTWFydGluZXogQ2FuaWxs
YXMgd3JvdGU6DQo+IE9uIDEvMTkvMjIgMTY6NTAsIFRob21hcyBaaW1tZXJtYW5uIHdyb3RlOg0K
PiANCj4gW3NuaXBdDQo+IA0KPiA+ID4gPiA+IElNSE8gdGhlIGJlc3Qgc29sdXRpb24gaXMgdG8g
ZHJvcCBJT1JFU09VUkNFX0JVU1kgZnJvbSBzeXNmYg0KPiA+ID4gPiA+IGFuZCBoYXZlDQo+ID4g
PiA+ID4gZHJpdmVycyByZWdpc3Rlci9yZWxlYXNlIHRoZSByYW5nZSB3aXRoIF9CVVNZLiBUaGF0
IHdvdWxkDQo+ID4gPiA+ID4gc2lnbmFsIHRoZQ0KPiA+ID4gPiA+IG1lbW9yeSBiZWxvbmdzIHRv
IHRoZSBzeXNmYiBkZXZpY2UgYnV0IGlzIG5vdCBidXN5IHVubGVzcyBhDQo+ID4gPiA+ID4gZHJp
dmVyDQo+ID4gPiA+ID4gaGFzDQo+ID4gPiA+ID4gYmVlbiBib3VuZC4gQWZ0ZXIgc2ltcGxlZmIg
cmVsZWFzZWQgdGhlIHJhbmdlLCBpdCBzaG91bGQgYmUNCj4gPiA+ID4gPiAnbm9uLQ0KPiA+ID4g
PiA+IGJ1c3knDQo+ID4gPiA+ID4gYWdhaW4gYW5kIGF2YWlsYWJsZSBmb3Igdm13Z2Z4LiBTaW1w
bGVkcm0gZG9lcyBhIGhvdC11bnBsdWcgb2YNCj4gPiA+ID4gPiB0aGUNCj4gPiA+ID4gPiBzeXNm
Yg0KPiA+ID4gPiA+IGRldmljZSwgc28gdGhlIG1lbW9yeSByYW5nZSBnZXRzIHJlbGVhc2VkIGVu
dGlyZWx5LiBJZiB5b3UNCj4gPiA+ID4gPiB3YW50LCBJJ2xsDQo+ID4gPiA+ID4gcHJlcGFyZSBz
b21lIHBhdGNoZXMgZm9yIHRoaXMgc2NlbmFyaW8uDQo+ID4gPiA+IA0KPiA+ID4gPiBBdHRhY2hl
ZCBpcyBhIHBhdGNoIHRoYXQgaW1wbGVtZW50cyB0aGlzLiBEb2luZw0KPiA+ID4gPiANCj4gPiA+
ID4gwqDCoCBjYXQgL3Byb2MvaW9tZW0NCj4gPiA+ID4gwqDCoMKgIC4uLg0KPiA+ID4gPiDCoMKg
wqAgZTAwMDAwMDAtZWZmZmZmZmYgOiAwMDAwOjAwOjAyLjANCj4gPiA+ID4gDQo+ID4gPiA+IMKg
wqDCoMKgwqAgZTAwMDAwMDAtZTA3ZThmZmYgOiBCT09URkINCj4gPiA+ID4gDQo+ID4gPiA+IMKg
wqDCoMKgwqDCoMKgIGUwMDAwMDAwLWUwN2U4ZmZmIDogc2ltcGxlZmINCj4gPiA+ID4gDQo+ID4g
PiA+IMKgwqDCoCAuLi4NCj4gPiA+ID4gDQo+ID4gPiA+IHNob3dzIHRoZSBtZW1vcnkuICdCT09U
RkInIGlzIHRoZSBzaW1wbGUtZnJhbWVidWZmZXIgZGV2aWNlIGFuZA0KPiA+ID4gPiAnc2ltcGxl
ZmInIGlzIHRoZSBkcml2ZXIuIE9ubHkgdGhlIGxhdHRlciB1c2VzIF9CVVNZLiBTYW1lIGZvcg0K
PiA+ID4gPiBhbmQgdGhlIG1lbW9yeSBjYW5iZSBhY3F1aXJlZCBieSB2bXdnZnguDQo+ID4gPiA+
IA0KPiA+ID4gPiBaYWNrLCBwbGVhc2UgdGVzdCB0aGlzIHBhdGNoLiBJZiBpdCB3b3JrcywgSSds
bCBzZW5kIG91dCB0aGUgcmVhbA0KPiA+ID4gPiBwYXRjaHNldC4NCj4gPiA+IA0KPiA+ID4gSG1t
LCB0aGUgcGF0Y2ggbG9va3MgZ29vZCBidXQgaXQgZG9lc24ndCB3b3JrLiBBZnRlciBib290Og0K
PiA+ID4gL3Byb2MvaW9tZW0NCj4gPiA+IDUwMDAwMDAwLTdmZmZmZmZmIDogcGNpZUAweDQwMDAw
MDAwDQo+ID4gPiDCoMKgIDc4MDAwMDAwLTdmZmZmZmZmIDogMDAwMDowMDowZi4wDQo+ID4gPiDC
oMKgwqDCoCA3ODAwMDAwMC03ODJmZmZmZiA6IEJPT1RGQg0KPiA+ID4gDQo+ID4gPiBhbmQgdm13
Z2Z4IGZhaWxzIG9uIHBjaV9yZXF1ZXN0X3JlZ2lvbnM6DQo+ID4gPiANCj4gPiA+IGtlcm5lbDog
ZmIwOiBzd2l0Y2hpbmcgdG8gdm13Z2Z4IGZyb20gc2ltcGxlDQo+ID4gPiBrZXJuZWw6IENvbnNv
bGU6IHN3aXRjaGluZyB0byBjb2xvdXIgZHVtbXkgZGV2aWNlIDgweDI1DQo+ID4gPiBrZXJuZWw6
IHZtd2dmeCAwMDAwOjAwOjBmLjA6IEJBUiAyOiBjYW4ndCByZXNlcnZlIFttZW0gMHg3ODAwMDAw
MC0NCj4gPiA+IDB4N2ZmZmZmZmYgNjRiaXQgcHJlZl0NCj4gPiA+IGtlcm5lbDogdm13Z2Z4OiBw
cm9iZSBvZiAwMDAwOjAwOjBmLjAgZmFpbGVkIHdpdGggZXJyb3IgLTE2DQo+ID4gPiANCj4gPiA+
IGxlYXZpbmcgdGhlIHN5c3RlbSB3aXRob3V0IGEgZmIgZHJpdmVyLg0KPiA+IA0KPiA+IE9LLCBJ
IHN1c3BlY3QgdGhhdCBpdCB3b3VsZCB3b3JrIGlmIHlvdSB1c2Ugc2ltcGxlZHJtIGluc3RlYWQg
b2YgDQo+ID4gc2ltcGxlZmIuIENvdWxkIHlvdSB0cnkgcGxlYXNlPyBZb3UnZCBoYXZlIHRvIGJ1
aWxkIERSTSBhbmQgc2ltcGxlZHJtDQo+ID4gaW50byB0aGUga2VybmVsIGJpbmFyeS4NCj4gPiAN
Cj4gDQo+IFllcywgSSBiZWxpZXZlIHRoYXQgc2hvdWxkIHdvcmsuDQo+IMKgWmFjaywgY291bGQg
eW91IHBsZWFzZSB0cnkgaWYganVzdCB0aGUgZm9sbG93aW5nIFswXSBtYWtlIGl0IHdvcmtzID8N
Cg0KVW5mb3J0dW5hdGVseSB0aGF0IHN0aWxsIGZhaWxzIHdpdGggdGhlIHNhbWU6DQprZXJuZWw6
IGZiMDogc3dpdGNoaW5nIHRvIHZtd2dmeCBmcm9tIHNpbXBsZQ0Ka2VybmVsOiBDb25zb2xlOiBz
d2l0Y2hpbmcgdG8gY29sb3VyIGR1bW15IGRldmljZSA4MHgyNQ0Ka2VybmVsOiB2bXdnZnggMDAw
MDowMDowZi4wOiBCQVIgMjogY2FuJ3QgcmVzZXJ2ZSBbbWVtIDB4NzgwMDAwMDAtDQoweDdmZmZm
ZmZmIDY0Yml0IHByZWZdDQprZXJuZWw6IHZtd2dmeDogcHJvYmUgb2YgMDAwMDowMDowZi4wIGZh
aWxlZCB3aXRoIGVycm9yIC0xNg0KDQp6DQo=
