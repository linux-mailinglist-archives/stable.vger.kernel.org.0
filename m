Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E58117967A
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 18:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgCDRPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 12:15:13 -0500
Received: from mail-eopbgr750040.outbound.protection.outlook.com ([40.107.75.40]:2113
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727023AbgCDRPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 12:15:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aO3HYjKq3mP5lBdLy6bKOHs3AsnJGwLt4SQ0MNjTSPP6E0/mP5oJfFs3STwnELJs5lhTbzPmednhLBAn/rvxWZPJ1SkWFj3yeWPQFddmwkHu7tFYSg5wsVlfZS5Gogbttw6aS8zIoGIbd1b2E0cXwn7YevrpO/zPTBmVzUJIGaS7z+urss59N+cmmcsQGFkrm6yV8KmnPz6x8mttXru+54in0jGN6+Vr6mrElscCi9Lxh39WfcP4VRzKsPuJZusK2J9ibZ1NEmCaaPnCSrW/tlwtztR5LGdjtL+sWL0zhPzFWjiLCLtrqGZZqzJj/my6IpZZsO0eB2mDyPnIfEzhtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwOB4IJDF6wkQkebaUqFeTMHs3kV1WLfF9WLTXY1rnA=;
 b=cRnl6r95xRl34bkR30dcLmDuMk8EYO3oS7Y1vYisA0kW258m45BnkqOGjochq5giST+QJM9s3K2AIJQb4bR82FU8dC0YSpFBKkk7ySdFAvJY+UxpDDxncq28N3zxyQJIbLjXH0SjfQWq8Z0KvzhLVfyKx9lYkAPIT8i5dsUN/e01iA/ocNXJnHpjl3oOlLhKoqx/IsPznAgIe866Ub7DP7NCRvxDslSbHBUcbloGJ/84+H+eGgU15DNb0dGEhZiDRtkT0COtdvlRHTlWDZSyPMru7lkxuQI0zCbXVypxPJsI8P3N0PCWo/pB1zNet3+KLfnCZ18lJTz9SJCduuizoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwOB4IJDF6wkQkebaUqFeTMHs3kV1WLfF9WLTXY1rnA=;
 b=HTIKnymHgQFJLzeK5qxBvzaFkebYbtNCklzCzDlGLw5ElrNvIAJs16RZPbw0Cu7QVA5QH+m9SqrQN5jIBWdSakstKZCEAq/cqC+/MXvrljcBlxJBgccSO73/fRfasANzmqNux4/G2SXDkajuYYPDt3N5AYsK9ZXqEUj84pqUnEw=
Received: from SN6PR05MB4960.namprd05.prod.outlook.com (2603:10b6:805:e3::10)
 by SN6PR05MB5181.namprd05.prod.outlook.com (2603:10b6:805:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.5; Wed, 4 Mar
 2020 17:15:09 +0000
Received: from SN6PR05MB4960.namprd05.prod.outlook.com
 ([fe80::1180:b61f:68c3:37e8]) by SN6PR05MB4960.namprd05.prod.outlook.com
 ([fe80::1180:b61f:68c3:37e8%7]) with mapi id 15.20.2793.011; Wed, 4 Mar 2020
 17:15:09 +0000
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
Thread-Index: AQHV7TN3VA/f39Q7qUqcifTY1ARXB6gunMoAgAOzhoCAADrogIAGh30A
Date:   Wed, 4 Mar 2020 17:15:09 +0000
Message-ID: <A0DE5455-2F70-4916-972B-3970248BCC25@vmware.com>
References: <20200227055805.3011-1-bvikas@vmware.com>
 <20200227070030.GA290231@kroah.com>
 <87EC78FF-21EE-4921-B819-CBA4D328E159@vmware.com>
 <20200229190239.GB832132@kroah.com>
In-Reply-To: <20200229190239.GB832132@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.22.0.200209
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=bvikas@vmware.com; 
x-originating-ip: [106.201.96.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 597733ab-7748-4241-c152-08d7c05f97e5
x-ms-traffictypediagnostic: SN6PR05MB5181:|SN6PR05MB5181:|SN6PR05MB5181:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR05MB5181D8ACA7F1D2D4D2832019ABE50@SN6PR05MB5181.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(189003)(199004)(66946007)(91956017)(2616005)(66446008)(71200400001)(36756003)(64756008)(4326008)(6506007)(66476007)(66556008)(76116006)(55236004)(26005)(8676002)(53546011)(186003)(5660300002)(8936002)(81166006)(81156014)(86362001)(2906002)(54906003)(6486002)(6512007)(478600001)(33656002)(316002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5181;H:SN6PR05MB4960.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bDTEY7RQeDCDz4OoX4qAvgDj+P7ZVP+U1kuVmRqUODhTSrH8FUMPNJJi0Zvls11yZ5jltT81Nr7TEm4eZGGeBdwcAsmEuZ4YGalNKeinIKe1d/1W4xQ4/68Y27dRII/K0YdbiNmkmojKJVPVE4ywf11sbJbCdIokJgb1jqciIMBLC8EHY6Y3MtLuwvms6uRTNw2yVa3xwey6jIDojfzdqadEgQqhHtVPYVHI2cBOqgztU8plFkbU+rA/ZIAQC5a7YGlKAPfL/d6MCIM5KJ8OrakZtKP4+ZFhsOg73FHn2Gwz2XVYHSOw8oqHl9Epe8mLklVxGsp3CzUl+Gz2DDlaASN4PLLYNzJn8yvKIKXl6RQNHqdwSRoNzdMr+77ZcyF9DwtRdaCugQFXQdZXS7qAfPCReXqQB0S5pBdvzXma/7TppGZygrLRTiuExzRnvcir
x-ms-exchange-antispam-messagedata: 9HGvSR52wLD4zZmh4+Li+qTVZ+UO8jeQ+zxI0R0ZbVv3CiDwAErR30nfjlM4MSMRF40I34GMzPzRSF3eQ6vd/Kzq2NpUWgHzSNcpEh6SLqiuu7jkWMloIljIZXJZ+GhUbiO+/fvqz536v0XGx2Y8Eg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D62666ABBEE5A4EA57D536B38EFCBA7@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597733ab-7748-4241-c152-08d7c05f97e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 17:15:09.7878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: al4RHkWtDV/tJVI2iqzKdzSIFYXPvXq/yYfoMk43hHUxcVZxn1TzCKkuEDq4Np/c/pM2L2J5JflnI479VOA7RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5181
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDAxLzAzLzIwLCAxMjozMiBBTSwgIkdyZWcgS0giIDxncmVna2hAbGludXhmb3Vu
ZGF0aW9uLm9yZz4gd3JvdGU6DQoNCiAgICA+T24gU2F0LCBGZWIgMjksIDIwMjAgYXQgMTA6MDE6
NDlBTSArMDAwMCwgVmlrYXNoIEJhbnNhbCB3cm90ZToNCiAgICA+PiANCiAgICA+PiBPbiAyNy8w
Mi8yMCwgMTI6MzAgUE0sICJHcmVnIEtIIiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdy
b3RlOg0KICAgID4+IA0KICAgID4+ICAgICANCiAgICA+PiA+IE9uIFRodSwgRmViIDI3LCAyMDIw
IGF0IDA1OjU4OjA1QU0gKzAwMDAsIFZpa2FzaCBCYW5zYWwgd3JvdGU6DQogICAgPj4gPj4gRnJv
bTogU3RlcGhhbiBNdWVsbGVyIDxzbXVlbGxlckBjaHJvbm94LmRlPg0KICAgID4+ID4+DQogICAg
Pj4gPj4gY29tbWl0IGRiMDdjZDI2YWM2YTQxOGRjMjgyMzE4Nzk1OGVkY2ZkYjQxNWZhODMgdXBz
dHJlYW0NCiAgICA+PiA+Pg0KICAgID4+ID4+IEZJUFMgMTQwLTIgc2VjdGlvbiA0LjkuMiByZXF1
aXJlcyBhIGNvbnRpbnVvdXMgc2VsZiB0ZXN0IG9mIHRoZSBub2lzZQ0KICAgID4+ID4+IHNvdXJj
ZS4gVXAgdG8ga2VybmVsIDQuOCBkcml2ZXJzL2NoYXIvcmFuZG9tLmMgcHJvdmlkZWQgdGhpcyBj
b250aW51b3VzDQogICAgPj4gPj4gc2VsZiB0ZXN0LiBBZnRlcndhcmRzIGl0IHdhcyBtb3ZlZCB0
byBhIGxvY2F0aW9uIHRoYXQgaXMgaW5jb25zaXN0ZW50DQogICAgPj4gPj4gd2l0aCB0aGUgRklQ
UyAxNDAtMiByZXF1aXJlbWVudHMuIFRoZSByZWxldmFudCBwYXRjaCB3YXMNCiAgICA+PiA+PiBl
MTkyYmU5ZDlhMzA1NTVhYWUyY2ExZGMzYWFkMzdjYmE0ODRjZDRhIC4NCiAgICA+PiA+Pg0KICAg
ID4+ID4+IFRodXMsIHRoZSBGSVBTIDE0MC0yIENUUk5HIGlzIGFkZGVkIHRvIHRoZSBEUkJHIHdo
ZW4gaXQgb2J0YWlucyB0aGUNCiAgICA+PiA+PiBzZWVkLiBUaGlzIHBhdGNoIHJlc3VycmVjdHMg
dGhlIGZ1bmN0aW9uIGRyYmdfZmlwc19jb250aW5vdXNfdGVzdCB0aGF0DQogICAgPj4gPj4gZXhp
c3RlZCBzb21lIHRpbWUgYWdvIGFuZCBhcHBsaWVzIGl0IHRvIHRoZSBub2lzZSBzb3VyY2VzLiBU
aGUgcGF0Y2gNCiAgICA+PiA+PiB0aGF0IHJlbW92ZWQgdGhlIGRyYmdfZmlwc19jb250aW5vdXNf
dGVzdCB3YXMNCiAgICA+PiA+PiBiMzYxNDc2MzA1OWI4MmMyNmJkZDAyZmZjYjFjMDE2YzExMzJh
YWQwIC4NCiAgICA+PiA+Pg0KICAgID4+ID4+IFRoZSBKaXR0ZXIgUk5HIGltcGxlbWVudHMgaXRz
IG93biBGSVBTIDE0MC0yIHNlbGYgdGVzdCBhbmQgdGh1cyBkb2VzIG5vdA0KICAgID4+ID4+IG5l
ZWQgdG8gYmUgc3ViamVjdGVkIHRvIHRoZSB0ZXN0IGluIHRoZSBEUkJHLg0KICAgID4+ID4+DQog
ICAgPj4gPj4gVGhlIHBhdGNoIGNvbnRhaW5zIGEgdGlueSBmaXggdG8gZW5zdXJlIHByb3BlciB6
ZXJvaXphdGlvbiBpbiBjYXNlIG9mIGFuDQogICAgPj4gPj4gZXJyb3IgZHVyaW5nIHRoZSBKaXR0
ZXIgUk5HIGRhdGEgZ2F0aGVyaW5nLg0KICAgID4+ID4+DQogICAgPj4gPj4gU2lnbmVkLW9mZi1i
eTogU3RlcGhhbiBNdWVsbGVyIDxzbXVlbGxlckBjaHJvbm94LmRlPg0KICAgID4+ID4+IFJldmll
d2VkLWJ5OiBZYW5uIERyb25lYXVkIDx5ZHJvbmVhdWRAb3B0ZXlhLmNvbT4NCiAgICA+PiA+PiBT
aWduZWQtb2ZmLWJ5OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQog
ICAgPj4gPj4gU2lnbmVkLW9mZi1ieTogVmlrYXNoIEJhbnNhbCA8YnZpa2FzQHZtd2FyZS5jb20+
DQogICAgPj4gPj4gLS0tDQogICAgPj4gPj4gIGNyeXB0by9kcmJnLmMgICAgICAgICB8IDk0ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCiAgICA+PiA+PiAgaW5j
bHVkZS9jcnlwdG8vZHJiZy5oIHwgIDIgKw0KICAgID4+ID4+ICAyIGZpbGVzIGNoYW5nZWQsIDkz
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQogICAgPj4gPiAgICANCiAgICA+PiA+IFRo
aXMgbG9va3MgbGlrZSBhIG5ldyBmZWF0dXJlIHRvIG1lLCB3aHkgaXMgaXQgbmVlZGVkIGluIHRo
ZSBzdGFibGUNCiAgICA+PiA+IGtlcm5lbCB0cmVlcz8gIFdoYXQgYnVnIGRvZXMgaXQgZml4Pw0K
ICAgID4+IA0KICAgID4+IEluIDQuMTkueSwgNC4xNC55ICYgNC45LnksIERSQkcgaW1wbGVtZW50
YXRpb24gaXMgYXMgcGVyIE5JU1QgcmVjb21tZW5kYXRpb24NCiAgICA+PiBkZWZpbmVkIGluIE5J
U1QgU1A4MDAtOUEgYW5kIGl0IGRlc2lnbmVkIHRvIGJlIHJlYWR5IGZvciBGSVBTIGNlcnRpZmlj
YXRpb24uDQogICAgPj4gQnV0IGl0IGhhcyBtaXNzZWQgb25lIG9mIHRoZSBOSVNUIHRlc3QgcmVx
dWlyZW1lbnQgZGVmaW5lIGluIEZJUFMgMTQwLTIoNC45LjIpLA0KICAgID4+IHNvIGl0IGlzIG5v
dCByZWFkeSBmb3IgTklTVCBGSVBTIGNlcnRpZmljYXRpb24uDQogICAgPj4gV2l0aCB0aGlzIHBh
dGNoIEZJUFMgMTQwLTIoNC45LjIpIGNvbnRpbnVvdXMgdGVzdCByZXF1aXJlbWVudCB3aWxsIGJl
IGZ1bGZpbGxlZC4NCiAgICA+DQogICAgPlRoZW4gdXNlIDUuNCBvciBuZXdlciBrZXJuZWxzIGlm
IHlvdSBuZWVkIHN1Y2ggYSBjZXJ0aWZpY2F0aW9uLiAgQWRkaW5nDQogICAgPnRoaXMgbmV3IGZl
YXR1cmUgdG8gb2xkZXIga2VybmVscyBpcyBqdXN0IHRoYXQsIGEgbmV3IGZlYXR1cmUuDQogICAg
Pg0KICAgID5XaGF0IGlzIHByZXZlbnRpbmcgeW91IGZyb20gdXNpbmcgNS40PyAgSXQncyBtdWNo
IGJldHRlciBzZWN1cml0eSB3aXNlDQogICAgPnRoYW4gb2xkZXIga2VybmVscyBmb3IgYSB3aG9s
ZSBsb2FkIG9mIHJlYXNvbnMuDQoNCiAgICBUaGFua3MgZm9yIHJlc3BvbnNlLiBJIGFncmVlIHdp
dGggeW91ciBwb2ludC4gUGxlYXNlIGNsb3NlIHRoaXMgdGhyZWFkLg0KDQogICAgUmVnYXJkcw0K
ICAgIFZpa2FzaA0KICAgPiANCiAgICA+dGhhbmtzLA0KICAgID4NCiAgICA+Z3JlZyBrLWgNCiAg
ICANCg0K
