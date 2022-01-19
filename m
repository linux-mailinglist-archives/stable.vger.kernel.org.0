Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB5A4932CA
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 03:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350886AbiASCQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 21:16:02 -0500
Received: from mail-sn1anam02on2082.outbound.protection.outlook.com ([40.107.96.82]:32837
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348177AbiASCPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 21:15:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czGHfOabca18WsET95zAdff+wrWEooZIEh9wunXVCeqU9sB5NAwBsd70HpHZPvKto7dCqO9Ly+z89KDrhVrdOUfzLMG7j51AH2Hi+ckMM8Od8F1ZiScUPwzVhH5ZhuG9pk4I2MYGFX96s/hf07/nU0JIDsRXxPBHZbySoX3d7mWQ/NKYfWFC9mWbqeFVtpTF/CuiHqk2u+PI//fugWxDrLYSMxG4+reOjt1wo89fVlNDomXvKuXvU8OiA3UZqUIPBWgJnzBsi+znwjcmMC3M+zH1DhqOtOSTaiG7/N7OgQKz4ycNdamdzjrFJN2tKEmB9aWZaQVfQP7kQap1QFoc4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkkvSJr5PumDFSyRSq13hPIru17B87IYIL+JBeQvxZY=;
 b=TCQgq5m9ZCad5jOsgOWRrBPy1zvaMdwEvyjm8xDGdUPuKZ+KNnaaK7Hf9J4LJTGDBtVqDvSTbNLAh+si0Ml8BErZzV8j5+boaRT/vr/k8DnovCgf1yqmARR58WqJ4Trx2S+c/fKqwKRuI+uuUw+K+Fk92gF+TGlKkH4zowtGmxhdwv/KTw0SOBN/v/EYUYOAbLf0blH/NJ7nRxRMUnTOBq3SE7HNUxegBfZYOb0OeQnuGt569AqPgolSnT05bLXLFUG5qFZMSUhIZiZe/Tsapr/xihM65eE70P2wCHRANWN/ve8Q/C0JEuSuvhKr1+ZiVdN9xOQrihHGmRAF/Z3tzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkkvSJr5PumDFSyRSq13hPIru17B87IYIL+JBeQvxZY=;
 b=kjp5+ptZVKxJ03KHdNV7eB2kAXNwWWM8Qs1ohMD8otX+JBemyBTHTVzg+lzgYlU5bOYlH+07QI4EXUNjX1XFp6deNAoWspTMI2Apx43fUCcXDRA1k5AtH2BICEMQ4w7hTatCQrvjoOWDBZNMYZX9L6tp5jlHYLSaU9GnVjb/Fqw=
Received: from MN2PR05MB6624.namprd05.prod.outlook.com (2603:10b6:208:d8::18)
 by CY4PR05MB3222.namprd05.prod.outlook.com (2603:10b6:903:fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 19 Jan
 2022 02:15:53 +0000
Received: from MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112]) by MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112%5]) with mapi id 15.20.4909.007; Wed, 19 Jan 2022
 02:15:53 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "javierm@redhat.com" <javierm@redhat.com>
CC:     "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Topic: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Index: AQHYC8yinmr5RRCrG02Gv/mSECQCTKxpI6WAgAB5uAA=
Date:   Wed, 19 Jan 2022 02:15:53 +0000
Message-ID: <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
References: <20220117180359.18114-1-zack@kde.org>
         <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
In-Reply-To: <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b7d4d6f-aab4-48a9-1caf-08d9daf19e9e
x-ms-traffictypediagnostic: CY4PR05MB3222:EE_
x-microsoft-antispam-prvs: <CY4PR05MB3222B296953BD6F2C2FEB7C5CE599@CY4PR05MB3222.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TZQa/2Uh21A8+UNbYTIJLZYdoIQPlvF2prmbEi0L7djmtnUVcDMDazmKWYpI5A90EgT6dSODViraKq5MtFd1v82m9MtFE2AlfmFayQ7bdjFBLm13dm2sdMe58FVT3wKcLn+wsnK5DFDff9Xj+l62a8MATMGZSTBtQDIMpmqY5XOBCnUwhxduMIRiSjoSi1kAtmZtQtGcwPqZi9msFWuurOCeUfYXV6fCnuhx5cqpuTZwFmSs1IqfRByQZAATi1u45oek+DovprP+wBChKT0TcVtfzjQp/Rzq/1Sx3Dr32IDrSeTBxwqOQMomJirXGss4wP7pwBFAPvmI5hedHlrIcTsoG+Qk6MCEOLHrr7/Ilb3a8V/cLAzPCp7ZuZXV74/W96FgZX05WZ2YTNBw8/XyhzO1poROOfjElMEl0IyYhD++2Ea4XGSjzBGylawvEJkHW64m7h8jQRhQVUY7m6n/Av0XJ3tWbFfk9IqDv0RzUzZidIMSXNqzOPpCADYnFJbK8WHAE9/I7M1K0C7MB2RZv+P9nBzCjBp7g7vYjQEWYAdoaTlvvAzHod1CM3REjYPOxqPd0ancTCPw2e2XiBeGX440esdFJidXDbYbIXFZpon8M7kn/7T+kSHKqdWVD2V/3DPF7v6x5tdAcal39ENnZfvee7fj1SJVpV9mvKKR0luFoq7X3y8h/5XGnVFrfI4emrbI2WoPxlRBy6JFvHS5PjiNEacSHvBR7ihQW9NeiFFddKjiQzSbt42uvEH+7/OOJ0Dk3V7SDW6A0ZoEcAW+lGhzN2ycWA5rdS4xrgiLYDEzfOIrslUZxd93cSxFVsNripqYM2+xQxgLtnQUxJ1Xew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR05MB6624.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(110136005)(6486002)(38070700005)(8936002)(66446008)(38100700002)(966005)(6506007)(6512007)(316002)(76116006)(66476007)(54906003)(86362001)(66556008)(66946007)(64756008)(91956017)(8676002)(4326008)(5660300002)(2906002)(122000001)(508600001)(107886003)(83380400001)(186003)(26005)(36756003)(71200400001)(2616005)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ym9JeWpmd2JLeWJIN2ZCKzM1cVh0Q2tzeE1BWWIxaEV4RFJqanpxZ0lFSUZR?=
 =?utf-8?B?SW5lL3RMRVY1M1BXbjBVcGcyR3c4VjgxdSs3R2xGSzY2bWt2eXppR1M4blZy?=
 =?utf-8?B?ejRUdkVsdlhpY3h0c0o4dFlZSHVCZFR2Zk5SaXJjY2FvS2JTajBMTFAxM1Zt?=
 =?utf-8?B?blROb0IxcWlUU2Vza2ZvRUpZSWgrY1RqT3NGcFk1UG5MdzNTSkNTTEZkMTYw?=
 =?utf-8?B?aWR0V1c1WEhyUjJDYXNyRzd5aXg0T05oVW42M0dIMHMwVkFkL1FReTRQRC9T?=
 =?utf-8?B?R21SdVVZRFNnbVRDYm9lZWxpVHVJMTVPOFFEWDVSZWZoWEo0ZEF1NkJGK0xT?=
 =?utf-8?B?bk9uWkU5WVFqU0ZsSzZpamREMXEvK2pWS29TdWtUQUpCODBaaXJhY1ZLRXhL?=
 =?utf-8?B?VWVNblp0Rk90b3ZtL2wvVFFtdDhHQVFDMDJCeW8vbk9BYmNLTnJlV21SbGl2?=
 =?utf-8?B?ckhZZWdXelB2YkJKWDdkeGhWOC96SXdLNUdCdVB2RklHUWpvd0VXZTlza2tU?=
 =?utf-8?B?c1pNSHkwdm1GVXN4cUJKLzlhT0ZnQ1VRYUY2ZGYrcGVaUXhxeVMzQjZ6Wld2?=
 =?utf-8?B?M2JkSlNLcGtsYmYzNkhTNkk3RWgyT1FpeVpMZC82V0RGSEFXZEg4aWRZK3Ux?=
 =?utf-8?B?bTlTM3lWWktoaFN3dlF2cDBuM0tqcDdyK25XK0R1eGpnaUtXQUorRGdPSHRJ?=
 =?utf-8?B?ZjJrVFlkM0ZJUXh0bnhaR0I3eGFxZ0kzZWdFMEVvM1lTa2twdlY0ckRXcEhr?=
 =?utf-8?B?dGlZcS9USDBoWnhacHdEa0xYYUsyZlVkUGdaQjZaOHhxMkltaThyNzNRUzlp?=
 =?utf-8?B?a2locDJJNFJMcmFqTTZLQ0w3cVZQeFVHTjV3SE1XOVA1L1FWc1BpamdBVXBy?=
 =?utf-8?B?NlloVmViaHV6dFowOGlTckorQkV1eHRBT2VnclJRYWFBa2ZnRDE4b0RvOGJI?=
 =?utf-8?B?ZDdkai9reDRGN0NDVEhId3lLMVF4WmwvQkpCcjFqSWFRSThYWENBUFVOd3pn?=
 =?utf-8?B?OVdyZ1pucGlxc21PN1kvQlJ3ZUpmSjI1cHl4L245VlNqMzU5WDFwZjlTblA2?=
 =?utf-8?B?cGpudnNCd3Q3TFBINi8zTzJoK0dWTS8rcVdBdjlvVW1mR1o2QUE2a0dUbldn?=
 =?utf-8?B?UEY1R0pvUW9MKzNTR3FRUU5XTmx4U3kzVHl2cWtxTVRVSzYxSWJQVkxISU5K?=
 =?utf-8?B?cldhb3QyQWtPUGFWTTZCKzM3UGRsMWZ3Z2tkUnR6K3VqbndDejNhNVE4dUha?=
 =?utf-8?B?TEJkbzR0OTVoMUN0L0haQWk4bzJXaGlUdHdqZUNIUGNRVFRFN1hrODNub3E2?=
 =?utf-8?B?UDdLSFRpa0dYY1BZdTRiNzBXc2FPNUQwc0NIRmpnckJSNWdYK3pYQnpHaUNy?=
 =?utf-8?B?d0diV3hHT2x2UkJCekljZkk4aTUxU2I3M1NLK25Mc1NFcHFGUnA2MUttWGlC?=
 =?utf-8?B?alh2YUk3d1dETEc5SDVKaG96ajhRendOVHR5UnZzbDhaYnZ3NHh2OFdRUmtU?=
 =?utf-8?B?Z2hJVlcwbHlvZHQzbmRISGVHUFF6UFhhUVFXU3ZXcTVDbk9ESUs3VzJwU0dL?=
 =?utf-8?B?V2hsMC9vejBlRHZZK1hyekh4WU0reHFaM1pTREg5Zy9qUjNaS0ljeHlISXJk?=
 =?utf-8?B?RStGdjZXR3FYTG15WU52dWNKQXpPWmRRYmZDdWZsbi9NUW0ybWt5d2d4cUZN?=
 =?utf-8?B?NktPbER1L2hyZmJlY29zY0pxTDZFUUZZanRxa1Y0VVIzbi9Dd1UyTjVCellh?=
 =?utf-8?B?YSs4YVR4S0ljSWJhbFo5VW4ra0NFUzJaV0w3VVVaNm5aaUZyekVhU3JYMEU3?=
 =?utf-8?B?Sm0wR3FWOGxlekQ4UEsybDhMMG1rVGk5bnN4U0h1NlVHVEhlMkdPb2oxb2to?=
 =?utf-8?B?TXRGMDA1UW91K25wamVUOCtVeEVsek0ya1RSK05FOVl2WWg2ZzZwQWxNR2pF?=
 =?utf-8?B?aWRkK2s0UVdUZnBrUEpmMFJQd01wUUYrdlRyNHBUeVZwTk1kTE42OCt6YTdI?=
 =?utf-8?B?VnJxTzRVZW0xRngxYlV0NEZ6VHVkWXpleEk3ZnNrM3IzYUVNSTRJMTNEOHpz?=
 =?utf-8?B?bk1QMVNxNE8yTEYvNWk5VHg0dUZmTkluVEFaRCs2emxYZlVYT2xILzRwblZE?=
 =?utf-8?B?Rlh3NjVVdURVeFFkZkVRbmJpZTFZMHZtMlRGTzh1VE5jNjZORk5oR3A3YUM0?=
 =?utf-8?Q?bVBxack3HPAjcES1O10KyvM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80C506118A1552459C43CA90E131F946@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR05MB6624.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7d4d6f-aab4-48a9-1caf-08d9daf19e9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 02:15:53.1052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8L6yTKLJ6BVZhRGtnR80rxawVKXDA3XUXYp+dSfKseLbQdb8tVeI87y4uOove817gWAwskCe5RuyHP67CBC+JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR05MB3222
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIyLTAxLTE4IGF0IDIwOjAwICswMTAwLCBKYXZpZXIgTWFydGluZXogQ2FuaWxs
YXMgd3JvdGU6DQo+IEhlbGxvIFphY2ssDQo+IA0KPiBPbiAxLzE3LzIyIDE5OjAzLCBaYWNrIFJ1
c2luIHdyb3RlOg0KPiA+IEZyb206IFphY2sgUnVzaW4gPHphY2tyQHZtd2FyZS5jb20+DQo+ID4g
DQo+ID4gV2hlbiBzeXNmYl9zaW1wbGUgaXMgZW5hYmxlZCBsb2FkaW5nIHZtd2dmeCBmYWlscyBi
ZWNhdXNlIHRoZSByZWdpb25zDQo+ID4gYXJlIGhlbGQgYnkgdGhlIHBsYXRmb3JtLiBJbiB0aGF0
IGNhc2UNCj4gPiByZW1vdmVfY29uZmxpY3RpbmcqX2ZyYW1lYnVmZmVycw0KPiA+IG9ubHkgcmVt
b3ZlcyB0aGUgc2ltcGxlZmIgYnV0IG5vdCB0aGUgcmVnaW9ucyBoZWxkIGJ5IHN5c2ZiLg0KPiA+
IA0KPiANCj4gSW5kZWVkLCB0aGF0J3MgYW4gaXNzdWUuIEkgd29uZGVyIGlmIHdlIHNob3VsZCBk
cm9wIHRoZSBJT1JFU09VUkNFX0JVU1kNCj4gZmxhZyBmcm9tIHRoZSBtZW1vcnkgcmVzb3VyY2Ug
YWRkZWQgdG8gdGhlICJzaW1wbGUtZnJhbWVidWZmZXIiIGRldmljZQ0KPiA/DQoNCkkgdGhpbmsg
dGhpcyBpcyBvbmUgb2YgdGhvc2UgY2FzZXMgd2hlcmUgaXQgZGVwZW5kcyBvbiB3aGF0IHdlIHBs
YW4gdG8NCmRvIGFmdGVyIHRoYXQuIFNlbWVudGljYWxseSBpdCBtYWtlcyBzZW5zZSB0byBoYXZl
IGl0IGluIHRoZXJlIC0gdGhlDQpmcmFtZWJ1ZmZlciBtZW1vcnkgaXMgY2xhaW1lZCBieSB0aGUg
InNpbXBsZS1mcmFtZWJ1ZmZlciIgYW5kIGl0J3MNCmJ1c3ksIGl0J3MganVzdCB0aGF0IGl0IGNy
ZWF0ZXMgaXNzdWVzIGZvciBkcml2ZXJzIGFmdGVyIHVubG9hZGluZy4gSQ0KdGhpbmsgcmVtb3Zp
bmcgaXQsIHdoaWxlIG1ha2luZyB0aGluZ3MgZWFzaWVyIGZvciBkcml2ZXJzLCB3b3VsZCBiZQ0K
Y29uZnVzaW5nIGZvciBwZW9wbGUgcmVhZGluZyB0aGUgY29kZSBsYXRlciwgdW5sZXNzIHRoZXJl
J3Mgc29tZSBraW5kDQpvZiBjbGVhbnVwIHRoYXQgd291bGQgaGFwcGVuIHdpdGggaXQgKGUuZy4g
cmVtb3ZpbmcgSU9SRVNPVVJDRV9CVVNZDQphbHRvZ2V0aGVyIGFuZCBtYWtpbmcgdGhlIGRybSBk
cml2ZXJzIHByb3Blcmx5IHJlcXVlc3QgdGhlaXINCnJlc291cmNlcykuwqBBdCBsZWFzdCBieSBp
dHNlbGYgaXQgZG9lc24ndCBzZWVtIHRvIGJlIG11Y2ggYmV0dGVyDQpzb2x1dGlvbiB0aGFuIGhh
dmluZyB0aGUgZHJtIGRyaXZlcnMgbm90IGNhbGwgcGNpX3JlcXVlc3RfcmVnaW9uW3NdLA0Kd2hp
Y2ggYXBhcnQgZnJvbSBoeXBlcnYgYW5kIGNpcnJ1cyAoaWlyYyBib2NocyBkb2VzIGl0IGZvciBy
ZXNvdXJjZXMNCm90aGVyIHRoYW4gZmIgd2hpY2ggd291bGRuJ3QgaGF2ZSBiZWVuIGNsYWltZWQg
YnkgInNpbXBsZS1mcmFtZWJ1ZmZlciIpDQppcyBhbHJlYWR5IHRoZSBjYXNlLiANCg0KSSBkbyB0
aGluayB3ZSBzaG91bGQgZG8gb25lIG9mIHRoZW0gdG8gbWFrZSB0aGUgY29kZWJhc2UgY29oZXJl
bnQ6DQplaXRoZXIgcmVtb3ZlIElPUkVTT1VSQ0VfQlVTWSBmcm9tICJzaW1wbGUtZnJhbWVidWZm
ZXIiIG9yIHJlbW92ZQ0KcGNpX3JlcXVlc3RfcmVnaW9uW3NdIGZyb20gaHlwZXJ2IGFuZCBjaXJy
dXMuDQoNCg0KDQo+ID4gTGlrZSB0aGUgb3RoZXIgZHJtIGRyaXZlcnMgd2UgbmVlZCB0byBzdG9w
IHJlcXVlc3RpbmcgYWxsIHRoZSBwY2kNCj4gPiByZWdpb25zDQo+ID4gdG8gbGV0IHRoZSBkcml2
ZXIgbG9hZCB3aXRoIHBsYXRmb3JtIGNvZGUgZW5hYmxlZC4NCj4gPiBUaGlzIGFsbG93cyB2bXdn
ZnggdG8gbG9hZCBjb3JyZWN0bHkgb24gc3lzdGVtcyB3aXRoIHN5c2ZiX3NpbXBsZQ0KPiA+IGVu
YWJsZWQuDQo+ID4gDQo+IA0KPiBJIHJlYWQgdGhpcyB2ZXJ5IGludGVyZXN0aW5nIHRocmVhZCBm
cm9tIHR3byB5ZWFycyBhZ286DQo+IA0KPiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMC8xMS81
LzI0OA0KPiANCj4gTWF5YmUgaXMgd29ydGggbWVudGlvbmluZyBpbiB0aGUgY29tbWl0IG1lc3Nh
Z2Ugd2hhdCBEYW5pZWwgc2FpZCB0aGVyZSwNCj4gdGhhdCBpcyB0aGF0IG9ubHkgYSBmZXcgRFJN
IGRyaXZlcnMgcmVxdWVzdCBleHBsaWNpdGx5IHRoZSBQQ0kgcmVnaW9ucw0KPiBhbmQgdGhlIG9u
bHkgcmVsaWFibGUgYXBwcm9hY2ggaXMgZm9yIGJ1cyBkcml2ZXJzIHRvIGNsYWltIHRoZXNlLg0K
DQpBaCwgZ3JlYXQgcG9pbnQuIEknbGwgdXBkYXRlIHRoZSBjb21taXQgbG9nIHdpdGggdGhhdC4N
Cg0KPiA+IFNpZ25lZC1vZmYtYnk6IFphY2sgUnVzaW4gPHphY2tyQHZtd2FyZS5jb20+DQo+ID4g
Rml4ZXM6IDUyMzM3NWM5NDNlNSAoImRybS92bXdnZng6IFBvcnQgdm13Z2Z4IHRvIGFybTY0IikN
Cj4gPiBDYzogZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZw0KPiA+IENjOiA8c3RhYmxl
QHZnZXIua2VybmVsLm9yZz4NCj4gPiBSZXZpZXdlZC1ieTogTWFydGluIEtyYXN0ZXYgPGtyYXN0
ZXZtQHZtd2FyZS5jb20+DQo+ID4gLS0tDQo+IA0KPiBUaGUgcGF0Y2ggbG9va3MgZ29vZCB0byBt
ZSwgdGhhbmtzIGEgbG90IGZvciBmaXhpbmcgdGhpczoNCj4gDQo+IFJldmlld2VkLWJ5OiBKYXZp
ZXIgTWFydGluZXogQ2FuaWxsYXMgPGphdmllcm1AcmVkaGF0LmNvbT4NCg0KVGhhbmtzIGZvciB0
YWtpbmcgYSBsb29rIGF0IHRoaXMsIEkgYXBwcmVjaWF0ZSBpdCENCg0Keg0K
