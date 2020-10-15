Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635DE28F1D2
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 14:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgJOMGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 08:06:18 -0400
Received: from mail-dm6nam08on2130.outbound.protection.outlook.com ([40.107.102.130]:58303
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbgJOMGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Oct 2020 08:06:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nr7UzeK7Y3uHF1dxY/BEoQk71S2gjz1MZYpFTi/q345lPQRqtJqpv6Mz4d17eBNYgaDKHX0eQQKXDyGr5Cs10lGafNWaKHTYYJMKg4cXj3wSW09eX5reoLMTwtKrTCO8y+d4uKJvCkitJF07YuKbNvP2HnqEAg+s6yHbcsarXvNPY6KLY/4Wckn0E9th53Q93DHtpfQaGqeJuHJi64+HaHbTY1Y0ftoiazMvd1BcqBqfdEdMkF1wG4QDm4TGprnHmWKnYMEoA7tYQeFvd1imc4jI5265wOVmFo2GL2j6f/pSYsO28oC4V59C/Vpb/rTjtgY/xv1EpLshpsZXT30Nag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYznImnAiacttCmxwlLNH1QI6gnJwRFX9TIZRuUttkI=;
 b=bEKaa+ZfdzAnaJl6Y6lXBA2KYofqvQtugS0jvrhlOPxJ/FKtbShS7rwg3xGJTu63nvjOQ0U9nHVT72nStecRXGIfujrtAFeSM27XNdmNjY2s+ontbr/qqrefxl8hvs717oKssTL4klFDL2XoxyvctajJWL4Mr0svbJYb0zzDVBoY96SAMB9U3Lvws7uTq+/OtEd1XAtRtAbtsWwuj4KJQMqr0Upv1yfwcYLeq8yhbyhxvfxJjD9E2ujbEaysSF19rzYaQwjm3zX3DP3eETuRzRp59apHwQSGfwtR1Glxkb7IYQRLlZ6BHSGae8+rW4S+qyFuHtbtnsN8BRrnah44fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYznImnAiacttCmxwlLNH1QI6gnJwRFX9TIZRuUttkI=;
 b=JRLIgMpDel/RroIirWXcAm2SlDqqwska/UzS9v8Voe/ZZWcm+jyFKajWsHxOxWKty7oZ3xQSD2T2jPRYlcnfsPrvrO1t5+SiacOc55xHIaCdAj5bb9pjdpjRtWAcdKqwBdWEFTdwU90h0jqf2PSvgoFAnvev0BtOauIdMHYA3TQ=
Received: from MN2PR13MB3957.namprd13.prod.outlook.com (20.180.244.203) by
 MN2PR13MB3975.namprd13.prod.outlook.com (20.180.245.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.11; Thu, 15 Oct 2020 12:06:12 +0000
Received: from MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e8a1:6acc:70f0:ef39]) by MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e8a1:6acc:70f0:ef39%8]) with mapi id 15.20.3499.004; Thu, 15 Oct 2020
 12:06:12 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "ashishsangwan2@gmail.com" <ashishsangwan2@gmail.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
Thread-Topic: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
Thread-Index: AQHWm/OGeyO0BuEaoUK9JXx6hV8a+KmXdI6AgAAOoYCAARwMgA==
Date:   Thu, 15 Oct 2020 12:06:12 +0000
Message-ID: <622f03cd08acd861a5155a181191e9ce399bbb37.camel@hammerspace.com>
References: <20201006151456.20875-1-ashishsangwan2@gmail.com>
         <2d1ff3421a88ece2f1b7708cdbc9d34b00ad3e81.camel@hammerspace.com>
         <CAOiN93mh-ssTDuN1fAptECqc5JpUHtK=1V56jY_0MtWEcT=U2Q@mail.gmail.com>
In-Reply-To: <CAOiN93mh-ssTDuN1fAptECqc5JpUHtK=1V56jY_0MtWEcT=U2Q@mail.gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ade235d-93e8-4b45-fba6-08d87102b5b7
x-ms-traffictypediagnostic: MN2PR13MB3975:
x-microsoft-antispam-prvs: <MN2PR13MB397593AAF0BD65DF5D098732B8020@MN2PR13MB3975.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nChVLlkuZ++NPQZ+Z6ZV9AWye1b4Ho6DqmE8GWRVWIoQ5VoGMqZXtB57DzbnAEYbQaa4A3hB5ykWoujNgT7Whr8Z9s46v/sIh9WYHC/u+28Tl+vfM9K6Lgfi+ysmAn3GtS3m0bYTLKXdUXqGOmaHwYOpKrUdZ8ou0WFLIUf9FHpZttPjQaeTl5RaXqJThkzjsSdvVChpV26FhFsM+3y8hc8JqRjUKy9GNpKEGSLkFOXYlXHk/vN8c/04E7rlmERkLF838mX8ThUfQ4KWrtT2N6laJTN5phCVRj4ilujfROTmUMuHYS9bNxl6g7rp9sKUX3cKuNN3X1a6Vr5MwqBwlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR13MB3957.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(39840400004)(346002)(66476007)(36756003)(26005)(2906002)(71200400001)(6486002)(86362001)(186003)(478600001)(4326008)(2616005)(91956017)(76116006)(83380400001)(8676002)(66946007)(64756008)(66446008)(5660300002)(6512007)(4001150100001)(8936002)(6506007)(53546011)(54906003)(110136005)(316002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +35e+eIfCZm76z69tIBMJPIk7K9W4b7CLMQLDPyFvirZPmLcOiSb55EW3xNHxGgwIH2JgH2J8BJNx1sAfwblevy78jiDJtOCq795ufvgvtCH4YBdIUWuvKm27FNd7OJyTnvhdgQYL6RhEuxu84T0+ciCEgHdioUdLn2MJRjqo9MWbpZ/ms7K5YfHu3/DYtiwAMDfuVV8+FLPS4+qpT1g3DmLv61ETuRY85DR8QhLuHySjJi4duBXcrbjIcFfu6v/W9JPaQJ9Y5m/3ZDi4aaiK4V/qnViR8pX7pAbe1YnNxCuGudwMaKudDWgLaq63ptlZ6xkwpT0lhQVJExkKhinqvbQ+agy/ZFElobxwk8F2wls+j2J1fGX5jMIDEoqkqo0GieKuoTmbcje8T/AqunlS/JPLTXTp0121z4D/CCbKZlC4SMUjAX4dPZDo3lwCm6XZ8yi6W1X+0m81EZuxEFYtk6yLy0Ie6yBUIdM5venzZzpL3oXVTHVvZ0rC5smla+P6Tnyte6ohjK0cuMd/bcaPIzYbXo8Top6/u8VDS42aD9++G6lM2RcZdvxmujXbZt0GXWDtAcuPTa7Lbrcngm3Qi1MiIpGMsK1Hgl77s/WnT1n14tYmPFmOfe/G8J3vV3Hwgaj9a9/VzNSnD08bbxekQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EF2DE2ACED7F74E8DEA8D54587B27C8@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR13MB3957.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ade235d-93e8-4b45-fba6-08d87102b5b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 12:06:12.4148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dqHMzzJ+nfDkRIHGLIRE62a7fampx30jN0nwr/YlMKc1FGYcTHtktKg02QQVSnpz45xLPS4h0+wkUX4Yc6agOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3975
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTE1IGF0IDAwOjM5ICswNTMwLCBBc2hpc2ggU2FuZ3dhbiB3cm90ZToN
Cj4gT24gV2VkLCBPY3QgMTQsIDIwMjAgYXQgMTE6NDcgUE0gVHJvbmQgTXlrbGVidXN0DQo+IDx0
cm9uZG15QGhhbW1lcnNwYWNlLmNvbT4gd3JvdGU6DQo+ID4gT24gVHVlLCAyMDIwLTEwLTA2IGF0
IDA4OjE0IC0wNzAwLCBBc2hpc2ggU2FuZ3dhbiB3cm90ZToNCj4gPiA+IFJlcXVlc3QgZm9yIG1v
ZGUgYml0cyBhbmQgbmxpbmsgY291bnQgaW4gdGhlIG5mczRfZ2V0X3JlZmVycmFsDQo+ID4gPiBj
YWxsDQo+ID4gPiBhbmQgaWYgc2VydmVyIHJldHVybnMgdGhlbSB1c2UgdGhlbSBpbnN0ZWFkIG9m
IGhhcmQgY29kZWQgdmFsdWVzLg0KPiA+ID4gDQo+ID4gPiBDQzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZw0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQXNoaXNoIFNhbmd3YW4gPGFzaGlzaHNhbmd3YW4y
QGdtYWlsLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGZzL25mcy9uZnM0cHJvYy5jIHwgMjAgKysr
KysrKysrKysrKysrKystLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2ZzL25mcy9uZnM0
cHJvYy5jIGIvZnMvbmZzL25mczRwcm9jLmMNCj4gPiA+IGluZGV4IDZlOTVjODVmZTM5NS4uZWZl
YzA1YzVmNTM1IDEwMDY0NA0KPiA+ID4gLS0tIGEvZnMvbmZzL25mczRwcm9jLmMNCj4gPiA+ICsr
KyBiL2ZzL25mcy9uZnM0cHJvYy5jDQo+ID4gPiBAQCAtMjY2LDcgKzI2Niw5IEBAIGNvbnN0IHUz
MiBuZnM0X2ZzX2xvY2F0aW9uc19iaXRtYXBbM10gPSB7DQo+ID4gPiAgICAgICB8IEZBVFRSNF9X
T1JEMF9GU0lEDQo+ID4gPiAgICAgICB8IEZBVFRSNF9XT1JEMF9GSUxFSUQNCj4gPiA+ICAgICAg
IHwgRkFUVFI0X1dPUkQwX0ZTX0xPQ0FUSU9OUywNCj4gPiA+IC0gICAgIEZBVFRSNF9XT1JEMV9P
V05FUg0KPiA+ID4gKyAgICAgRkFUVFI0X1dPUkQxX01PREUNCj4gPiA+ICsgICAgIHwgRkFUVFI0
X1dPUkQxX05VTUxJTktTDQo+ID4gPiArICAgICB8IEZBVFRSNF9XT1JEMV9PV05FUg0KPiA+ID4g
ICAgICAgfCBGQVRUUjRfV09SRDFfT1dORVJfR1JPVVANCj4gPiA+ICAgICAgIHwgRkFUVFI0X1dP
UkQxX1JBV0RFVg0KPiA+ID4gICAgICAgfCBGQVRUUjRfV09SRDFfU1BBQ0VfVVNFRA0KPiA+ID4g
QEAgLTc1OTQsMTYgKzc1OTYsMjggQEAgbmZzNF9saXN0eGF0dHJfbmZzNF91c2VyKHN0cnVjdCBp
bm9kZQ0KPiA+ID4gKmlub2RlLA0KPiA+ID4gY2hhciAqbGlzdCwgc2l6ZV90IGxpc3RfbGVuKQ0K
PiA+ID4gICAqLw0KPiA+ID4gIHN0YXRpYyB2b2lkIG5mc19maXh1cF9yZWZlcnJhbF9hdHRyaWJ1
dGVzKHN0cnVjdCBuZnNfZmF0dHINCj4gPiA+ICpmYXR0cikNCj4gPiA+ICB7DQo+ID4gPiArICAg
ICBib29sIGZpeF9tb2RlID0gdHJ1ZSwgZml4X25saW5rID0gdHJ1ZTsNCj4gPiA+ICsNCj4gPiA+
ICAgICAgIGlmICghKCgoZmF0dHItPnZhbGlkICYgTkZTX0FUVFJfRkFUVFJfTU9VTlRFRF9PTl9G
SUxFSUQpIHx8DQo+ID4gPiAgICAgICAgICAgICAgKGZhdHRyLT52YWxpZCAmIE5GU19BVFRSX0ZB
VFRSX0ZJTEVJRCkpICYmDQo+ID4gPiAgICAgICAgICAgICAoZmF0dHItPnZhbGlkICYgTkZTX0FU
VFJfRkFUVFJfRlNJRCkgJiYNCj4gPiA+ICAgICAgICAgICAgIChmYXR0ci0+dmFsaWQgJiBORlNf
QVRUUl9GQVRUUl9WNF9MT0NBVElPTlMpKSkNCj4gPiA+ICAgICAgICAgICAgICAgcmV0dXJuOw0K
PiA+ID4gDQo+ID4gPiArICAgICBpZiAoZmF0dHItPnZhbGlkICYgTkZTX0FUVFJfRkFUVFJfTU9E
RSkNCj4gPiA+ICsgICAgICAgICAgICAgZml4X21vZGUgPSBmYWxzZTsNCj4gPiA+ICsgICAgIGlm
IChmYXR0ci0+dmFsaWQgJiBORlNfQVRUUl9GQVRUUl9OTElOSykNCj4gPiA+ICsgICAgICAgICAg
ICAgZml4X25saW5rID0gZmFsc2U7DQo+ID4gPiAgICAgICBmYXR0ci0+dmFsaWQgfD0gTkZTX0FU
VFJfRkFUVFJfVFlQRSB8IE5GU19BVFRSX0ZBVFRSX01PREUgfA0KPiA+ID4gICAgICAgICAgICAg
ICBORlNfQVRUUl9GQVRUUl9OTElOSyB8IE5GU19BVFRSX0ZBVFRSX1Y0X1JFRkVSUkFMOw0KPiA+
ID4gLSAgICAgZmF0dHItPm1vZGUgPSBTX0lGRElSIHwgU19JUlVHTyB8IFNfSVhVR087DQo+ID4g
PiAtICAgICBmYXR0ci0+bmxpbmsgPSAyOw0KPiA+ID4gKw0KPiA+ID4gKyAgICAgaWYgKGZpeF9t
b2RlKQ0KPiA+ID4gKyAgICAgICAgICAgICBmYXR0ci0+bW9kZSA9IFNfSUZESVIgfCBTX0lSVUdP
IHwgU19JWFVHTzsNCj4gPiA+ICsgICAgIGVsc2UNCj4gPiA+ICsgICAgICAgICAgICAgZmF0dHIt
Pm1vZGUgfD0gU19JRkRJUjsNCj4gPiA+ICsNCj4gPiA+ICsgICAgIGlmIChmaXhfbmxpbmspDQo+
ID4gPiArICAgICAgICAgICAgIGZhdHRyLT5ubGluayA9IDI7DQo+ID4gPiAgfQ0KPiA+ID4gDQo+
ID4gPiAgc3RhdGljIGludCBfbmZzNF9wcm9jX2ZzX2xvY2F0aW9ucyhzdHJ1Y3QgcnBjX2NsbnQg
KmNsaWVudCwNCj4gPiA+IHN0cnVjdA0KPiA+ID4gaW5vZGUgKmRpciwNCj4gPiANCj4gPiBOQUNL
IHRvIHRoaXMgcGF0Y2guIFRoZSB3aG9sZSBwb2ludCBpcyB0aGF0IGlmIHRoZSBzZXJ2ZXIgaGFz
IGENCj4gPiByZWZlcnJhbCwgdGhlbiBpdCBpcyBub3QgZ29pbmcgdG8gZ2l2ZSB1cyBhbnkgYXR0
cmlidXRlcyBvdGhlciB0aGFuDQo+ID4gdGhlDQo+ID4gb25lcyB3ZSdyZSBhbHJlYWR5IGFza2lu
ZyBmb3IgYmVjYXVzZSBpdCBtYXkgbm90IGV2ZW4gaGF2ZSBhIHJlYWwNCj4gPiBkaXJlY3Rvcnku
IFRoZSBjbGllbnQgaXMgcmVxdWlyZWQgdG8gZmFrZSB1cCBhbiBpbm9kZSwgaGVuY2UgdGhlDQo+
ID4gZXhpc3RpbmcgY29kZS4NCj4gDQo+IEhpIFRyb25kLCB0aGFua3MgZm9yIHJldmlld2luZyB0
aGUgcGF0Y2ghDQo+IFNvcnJ5IGJ1dCBJIGRpZG4ndCB1bmRlcnN0YW5kIHRoZSByZWFzb24gdG8g
TkFDSyBpdC4gQ291bGQgeW91IHBsZWFzZQ0KPiBlbGFib3JhdGUgeW91ciBjb25jZXJuPw0KPiBU
aGVzZSBhcmUgdGhlIGN1cnJlbnQgYXR0cmlidXRlcyB3ZSByZXF1ZXN0IGZyb20gdGhlIHNlcnZl
ciBvbiBhDQo+IHJlZmVycmFsOg0KPiBGQVRUUjRfV09SRDBfQ0hBTkdFDQo+ID4gRkFUVFI0X1dP
UkQwX1NJWkUNCj4gPiBGQVRUUjRfV09SRDBfRlNJRA0KPiA+IEZBVFRSNF9XT1JEMF9GSUxFSUQN
Cj4gPiBGQVRUUjRfV09SRDBfRlNfTE9DQVRJT05TLA0KPiBGQVRUUjRfV09SRDFfT1dORVINCj4g
PiBGQVRUUjRfV09SRDFfT1dORVJfR1JPVVANCj4gPiBGQVRUUjRfV09SRDFfUkFXREVWDQo+ID4g
RkFUVFI0X1dPUkQxX1NQQUNFX1VTRUQNCj4gPiBGQVRUUjRfV09SRDFfVElNRV9BQ0NFU1MNCj4g
PiBGQVRUUjRfV09SRDFfVElNRV9NRVRBREFUQQ0KPiA+IEZBVFRSNF9XT1JEMV9USU1FX01PRElG
WQ0KPiA+IEZBVFRSNF9XT1JEMV9NT1VOVEVEX09OX0ZJTEVJRCwNCj4gDQo+IFNvIHlvdSBhcmUg
c3VnZ2VzdGluZyB0aGF0IGl0J3Mgb2sgdG8gYXNrIGZvciBTSVpFLCBPV05FUiwgT1dORVINCj4g
R1JPVVAsIFNQQUNFIFVTRUQsIFRJTUVTVEFNUHMgZXRjIGJ1dCBub3Qgb2sgdG8gYXNrIGZvciBt
b2RlIGJpdHMgYW5kDQo+IG51bWxpbmtzPw0KDQpOby4gV2Ugc2hvdWxkbid0IGJlIGFza2luZyBm
b3IgYW55IG9mIHRoYXQgaW5mb3JtYXRpb24gZm9yIGEgcmVmZXJyYWwNCmJlY2F1c2UgdGhlIHNl
cnZlciBpc24ndCBzdXBwb3NlZCB0byByZXR1cm4gYW55IHZhbHVlcyBmb3IgaXQuDQoNCkNodWNr
IGFuZCBBbm5hLCB3aGF0J3MgdGhlIGRlYWwgd2l0aCBjb21taXQgYzA1Y2VmY2M3MjQxPyBUaGF0
IGFwcGVhcnMNCnRvIGhhdmUgY2hhbmdlZCB0aGUgb3JpZ2luYWwgY29kZSB0byBzcGVjdWxhdGl2
ZWx5IGFzc3VtZSB0aGF0IHRoZQ0Kc2VydmVyIHdpbGwgdmlvbGF0ZSBSRkM1NjYxIFNlY3Rpb24g
MTEuMy4xIGFuZC9vciBSRkM3NTMwIFNlY3Rpb24NCjguMy4xLiBTcGVjaWZpY2FsbHksIHRoZSBw
YXJhZ3JhcGggdGhhdCBzYXlzOg0KDQoiDQogICBPdGhlciBhdHRyaWJ1dGVzIFNIT1VMRCBOT1Qg
YmUgbWFkZSBhdmFpbGFibGUgZm9yIGFic2VudCBmaWxlDQogICBzeXN0ZW1zLCBldmVuIHdoZW4g
aXQgaXMgcG9zc2libGUgdG8gcHJvdmlkZSB0aGVtLiAgVGhlIHNlcnZlciBzaG91bGQNCiAgIG5v
dCBhc3N1bWUgdGhhdCBtb3JlIGluZm9ybWF0aW9uIGlzIGFsd2F5cyBiZXR0ZXIgYW5kIHNob3Vs
ZCBhdm9pZA0KICAgZ3JhdHVpdG91c2x5IHByb3ZpZGluZyBhZGRpdGlvbmFsIGluZm9ybWF0aW9u
LiINCg0KU28gd2h5IGlzIHRoZSBjbGllbnQgYXNraW5nIGZvciB0aGVtPw0KDQotLSANClRyb25k
IE15a2xlYnVzdA0KTGludXggTkZTIGNsaWVudCBtYWludGFpbmVyLCBIYW1tZXJzcGFjZQ0KdHJv
bmQubXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbQ0KDQoNCg==
