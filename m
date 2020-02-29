Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B496174604
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 11:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgB2KCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 05:02:01 -0500
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:12277
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbgB2KCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Feb 2020 05:02:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2SH/2XyIKUpbheFGXs5UKLpu3XuNym7qGXyJiL5VLuS21J1xz0BICE8PMhknSK1EhkT8mAC/kTbgOCL+bsfoSELmALf4iRa3c3VmBHeAtVBK2HLn/gSqteksRAhXqJIVZ16jklRwLhLEbhI69C3fx6VlFrnP8M4Kq2HBukffxE+3AoPbNRIyg9+WAInjQJofyqrkdBkZXUmvSz2uoncXMZqxiCqfLgzODTHhBhELfkaj4SDrgiIDbNK3U64MZjObUAUANuQWW9MrgYvTLMF8mlgB4hWwocEdVeW8NHZ20OJ6OMVYIOX+X3QRmqZ3BvI/AzpiArv0l9WdPWu9JKavw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66I1rq5DBJ0EKebNa8Aqc/bPN762zpLdQ+1CrpOJYug=;
 b=A29pal53cRt4itytoe9chLBjtALJC4BgC24poKYjQwkKyNSbA5Ae9BTwWVwZg6ecPyXUcvm1uslno5j2Y/q8z4Eo3pxoMkYCCDEkFKJD32EVD6UIjWxSFQoOKkVzj8LuOV5kPnAdNQfCQ9JZQhPW4hKzV69cT5Ljtsep2J+FaFo/nfsyU4fPR+0z8BwzMVZ6YB3sEAfRgNRdfQ3dAh17PtMT6a1dEI3RmtYQl4s86IRticzRWp07KFjodOZXV+SODYc+smjqzHbhLZUTjDpeFL0Vbi2yoXShFzod22z0bz94HYXMq2XYpQg1nWbzifkT+9oEJYurlu02G14EO2E9KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66I1rq5DBJ0EKebNa8Aqc/bPN762zpLdQ+1CrpOJYug=;
 b=RRKF3wizmp9rcH65XihqZODBmELeds1bKQQ1u3xjXz7mPa1iUEaZ41UlIfHa0BeG/zUAY3YmLzCucWYk0xADpGHfJ3B9LQdjxighq6y/qDwA1CWWpG5ffFRhRJTEx7lu4IeDRbH0nbPEjwk0zY7BErDMJB3M5BMe3VKAwGEgbGg=
Received: from SN6PR05MB4960.namprd05.prod.outlook.com (2603:10b6:805:e3::10)
 by SN6PR05MB4269.namprd05.prod.outlook.com (2603:10b6:805:31::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.9; Sat, 29 Feb
 2020 10:01:49 +0000
Received: from SN6PR05MB4960.namprd05.prod.outlook.com
 ([fe80::bcbf:d654:ec21:809b]) by SN6PR05MB4960.namprd05.prod.outlook.com
 ([fe80::bcbf:d654:ec21:809b%3]) with mapi id 15.20.2772.018; Sat, 29 Feb 2020
 10:01:49 +0000
From:   Vikash Bansal <bvikas@vmware.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Sharath George <sharathg@vmware.com>,
        Steven Rostedt <srostedt@vmware.com>,
        Ajay Kaher <akaher@vmware.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Stephan Mueller <smueller@chronox.de>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4.19.y, v4.14.y, v4.9.y] crypto: drbg - add FIPS 140-2
 CTRNG for noise source
Thread-Topic: [PATCH v4.19.y, v4.14.y, v4.9.y] crypto: drbg - add FIPS 140-2
 CTRNG for noise source
Thread-Index: AQHV7TN3VA/f39Q7qUqcifTY1ARXB6gunMoAgAOzhoA=
Date:   Sat, 29 Feb 2020 10:01:49 +0000
Message-ID: <87EC78FF-21EE-4921-B819-CBA4D328E159@vmware.com>
References: <20200227055805.3011-1-bvikas@vmware.com>
 <20200227070030.GA290231@kroah.com>
In-Reply-To: <20200227070030.GA290231@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.22.0.200209
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=bvikas@vmware.com; 
x-originating-ip: [171.76.97.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 543265f8-879e-472b-4951-08d7bcfe64e5
x-ms-traffictypediagnostic: SN6PR05MB4269:|SN6PR05MB4269:|SN6PR05MB4269:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR05MB42699A0B7920E1BEFF179785ABE90@SN6PR05MB4269.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:475;
x-forefront-prvs: 03283976A6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(189003)(199004)(53546011)(4326008)(33656002)(66946007)(91956017)(316002)(6506007)(6486002)(66446008)(76116006)(64756008)(66556008)(66476007)(54906003)(186003)(81166006)(36756003)(86362001)(8676002)(8936002)(2906002)(71200400001)(2616005)(6512007)(26005)(478600001)(81156014)(6916009)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4269;H:SN6PR05MB4960.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vn+5e/gigKnG3u1A+8Mmo1Gt6GTx11EibcsgCH3fHVekbzjd4BIe9phTzl6sjhb2wQAQWthsTYd5ovUeOyj36CdKHbgSrsc8ec0SY8ozdmqsLd6WYR+2vQyvltLKvczsIYYYU5TZKyhIZiie1TtUA7Jb+U9ie8yfi20Swyc/rZPUEy26Ni3O++IaOofo46teOnjo3eO/hbx62Kt7UV77Aotwe2eMnvwvUzewjlglrQnTqKdK9zaAOCZCOVPiZRrxsbZ3mVPwhQW/kCWmp5PgBYI9k22KVjSlvY4uFva3queyW9+yNz+3g0u6HU68WF31zc9eeQnqUppS5XSLPmgEcUzzNT/OvtPJHZiF1bRs0FGF7GdItNm2/GEPxgELUUhZX7jCLXDBac8emZ+5SlZA/WpGuHI6P2ynnDqmn35efyH/wQ1/JJhmU63pY7HqFaDx
x-ms-exchange-antispam-messagedata: jQ/B2KZuCF5xw9x/bJyqnz3n2KydLVuHpZQ7415yUc9krFjMOpLa3McMi0OvS/w8kqRV+LoxQVDS4JqE1lExhUBDR2SDFGBSYFzY2qha5nxFhq8XsdDtx24XRRubJ1cuIQ/szkgej7mt3B2Mn9hEMA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4A93D27F1B7B94891BC4815F2173944@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 543265f8-879e-472b-4951-08d7bcfe64e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Feb 2020 10:01:49.5478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sg5CtPQ6x8Vo9CsSkUMXhm9745+3PntYe5wPEdj+fa+Ry2NqHW3sOKMUz3IAayBso5TNX1xgbnth3KYZjqh4PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4269
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiAyNy8wMi8yMCwgMTI6MzAgUE0sICJHcmVnIEtIIiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlv
bi5vcmc+IHdyb3RlOg0KDQogICAgDQo+IE9uIFRodSwgRmViIDI3LCAyMDIwIGF0IDA1OjU4OjA1
QU0gKzAwMDAsIFZpa2FzaCBCYW5zYWwgd3JvdGU6DQo+PiBGcm9tOiBTdGVwaGFuIE11ZWxsZXIg
PHNtdWVsbGVyQGNocm9ub3guZGU+DQo+Pg0KPj4gY29tbWl0IGRiMDdjZDI2YWM2YTQxOGRjMjgy
MzE4Nzk1OGVkY2ZkYjQxNWZhODMgdXBzdHJlYW0NCj4+DQo+PiBGSVBTIDE0MC0yIHNlY3Rpb24g
NC45LjIgcmVxdWlyZXMgYSBjb250aW51b3VzIHNlbGYgdGVzdCBvZiB0aGUgbm9pc2UNCj4+IHNv
dXJjZS4gVXAgdG8ga2VybmVsIDQuOCBkcml2ZXJzL2NoYXIvcmFuZG9tLmMgcHJvdmlkZWQgdGhp
cyBjb250aW51b3VzDQo+PiBzZWxmIHRlc3QuIEFmdGVyd2FyZHMgaXQgd2FzIG1vdmVkIHRvIGEg
bG9jYXRpb24gdGhhdCBpcyBpbmNvbnNpc3RlbnQNCj4+IHdpdGggdGhlIEZJUFMgMTQwLTIgcmVx
dWlyZW1lbnRzLiBUaGUgcmVsZXZhbnQgcGF0Y2ggd2FzDQo+PiBlMTkyYmU5ZDlhMzA1NTVhYWUy
Y2ExZGMzYWFkMzdjYmE0ODRjZDRhIC4NCj4+DQo+PiBUaHVzLCB0aGUgRklQUyAxNDAtMiBDVFJO
RyBpcyBhZGRlZCB0byB0aGUgRFJCRyB3aGVuIGl0IG9idGFpbnMgdGhlDQo+PiBzZWVkLiBUaGlz
IHBhdGNoIHJlc3VycmVjdHMgdGhlIGZ1bmN0aW9uIGRyYmdfZmlwc19jb250aW5vdXNfdGVzdCB0
aGF0DQo+PiBleGlzdGVkIHNvbWUgdGltZSBhZ28gYW5kIGFwcGxpZXMgaXQgdG8gdGhlIG5vaXNl
IHNvdXJjZXMuIFRoZSBwYXRjaA0KPj4gdGhhdCByZW1vdmVkIHRoZSBkcmJnX2ZpcHNfY29udGlu
b3VzX3Rlc3Qgd2FzDQo+PiBiMzYxNDc2MzA1OWI4MmMyNmJkZDAyZmZjYjFjMDE2YzExMzJhYWQw
IC4NCj4+DQo+PiBUaGUgSml0dGVyIFJORyBpbXBsZW1lbnRzIGl0cyBvd24gRklQUyAxNDAtMiBz
ZWxmIHRlc3QgYW5kIHRodXMgZG9lcyBub3QNCj4+IG5lZWQgdG8gYmUgc3ViamVjdGVkIHRvIHRo
ZSB0ZXN0IGluIHRoZSBEUkJHLg0KPj4NCj4+IFRoZSBwYXRjaCBjb250YWlucyBhIHRpbnkgZml4
IHRvIGVuc3VyZSBwcm9wZXIgemVyb2l6YXRpb24gaW4gY2FzZSBvZiBhbg0KPj4gZXJyb3IgZHVy
aW5nIHRoZSBKaXR0ZXIgUk5HIGRhdGEgZ2F0aGVyaW5nLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6
IFN0ZXBoYW4gTXVlbGxlciA8c211ZWxsZXJAY2hyb25veC5kZT4NCj4+IFJldmlld2VkLWJ5OiBZ
YW5uIERyb25lYXVkIDx5ZHJvbmVhdWRAb3B0ZXlhLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IEhl
cmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4+IFNpZ25lZC1vZmYtYnk6
IFZpa2FzaCBCYW5zYWwgPGJ2aWthc0B2bXdhcmUuY29tPg0KPj4gLS0tDQo+PiAgY3J5cHRvL2Ry
YmcuYyAgICAgICAgIHwgOTQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLQ0KPj4gIGluY2x1ZGUvY3J5cHRvL2RyYmcuaCB8ICAyICsNCj4+ICAyIGZpbGVzIGNoYW5n
ZWQsIDkzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ICAgIA0KPiBUaGlzIGxvb2tz
IGxpa2UgYSBuZXcgZmVhdHVyZSB0byBtZSwgd2h5IGlzIGl0IG5lZWRlZCBpbiB0aGUgc3RhYmxl
DQo+IGtlcm5lbCB0cmVlcz8gIFdoYXQgYnVnIGRvZXMgaXQgZml4Pw0KDQpJbiA0LjE5LnksIDQu
MTQueSAmIDQuOS55LCBEUkJHIGltcGxlbWVudGF0aW9uIGlzIGFzIHBlciBOSVNUIHJlY29tbWVu
ZGF0aW9uDQpkZWZpbmVkIGluIE5JU1QgU1A4MDAtOUEgYW5kIGl0IGRlc2lnbmVkIHRvIGJlIHJl
YWR5IGZvciBGSVBTIGNlcnRpZmljYXRpb24uDQpCdXQgaXQgaGFzIG1pc3NlZCBvbmUgb2YgdGhl
IE5JU1QgdGVzdCByZXF1aXJlbWVudCBkZWZpbmUgaW4gRklQUyAxNDAtMig0LjkuMiksDQpzbyBp
dCBpcyBub3QgcmVhZHkgZm9yIE5JU1QgRklQUyBjZXJ0aWZpY2F0aW9uLg0KV2l0aCB0aGlzIHBh
dGNoIEZJUFMgMTQwLTIoNC45LjIpIGNvbnRpbnVvdXMgdGVzdCByZXF1aXJlbWVudCB3aWxsIGJl
IGZ1bGZpbGxlZC4NCg0KLSBWaWthc2gNCg0KPiB0aGFua3MsDQo+ICANCj4gZ3JlZyBrLWgNCj4g
ICANCg0K
