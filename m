Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0563316BB
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 23:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfEaVrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 17:47:33 -0400
Received: from mail-eopbgr810049.outbound.protection.outlook.com ([40.107.81.49]:29888
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfEaVrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 17:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBx8eZVfAEZ4maYRyirG+LXcMc+sahGF6VsJynrCsLE=;
 b=qlOmYsp3BiPaetnA2l1zZsdTXKMcr473zeb9ZuHWLl7Bd/YBhImxNZQKvgCIV6LJ8utTGBz4OaEUNbggfYfuib9S2enY1yT5Flzif3tflV36D/JQy+XeworfQIzokimKvpl+Cnens9e2OzQQSNimnO7neMW/mLx04a7KG2f3Ryg=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB3942.namprd05.prod.outlook.com (52.135.195.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.14; Fri, 31 May 2019 21:47:26 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::2cb6:a3d1:f675:ced8]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::2cb6:a3d1:f675:ced8%3]) with mapi id 15.20.1943.016; Fri, 31 May 2019
 21:47:26 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Damian Tometzki <linux_dti@icloud.com>,
        Will Deacon <will.deacon@arm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 079/276] x86/modules: Avoid breaking W^X while
 loading modules
Thread-Topic: [PATCH 4.19 079/276] x86/modules: Avoid breaking W^X while
 loading modules
Thread-Index: AQHVFpYgISbaT4CZTUqCXJ66PHbqUaaFDIUAgAC7LIA=
Date:   Fri, 31 May 2019 21:47:26 +0000
Message-ID: <7FDC3F12-3F84-4BBB-A9D0-CBCD86CF5F82@vmware.com>
References: <20190530030523.133519668@linuxfoundation.org>
 <20190530030531.331779845@linuxfoundation.org> <20190531103730.GB9685@amd>
In-Reply-To: <20190531103730.GB9685@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa3d90b6-fbc6-48c1-d7a1-08d6e611926f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB3942;
x-ms-traffictypediagnostic: BYAPR05MB3942:
x-microsoft-antispam-prvs: <BYAPR05MB3942E21B8E001320E43D7825D0190@BYAPR05MB3942.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(396003)(376002)(39860400002)(199004)(189003)(66066001)(76116006)(6512007)(256004)(14444005)(71200400001)(26005)(2906002)(66476007)(66556008)(66946007)(66446008)(73956011)(36756003)(6246003)(33656002)(6486002)(229853002)(6916009)(6436002)(102836004)(6506007)(99286004)(53936002)(53546011)(3846002)(86362001)(4326008)(478600001)(6116002)(5660300002)(8936002)(186003)(11346002)(7736002)(54906003)(82746002)(76176011)(476003)(486006)(68736007)(305945005)(71190400001)(83716004)(81156014)(14454004)(81166006)(7416002)(25786009)(446003)(2616005)(64756008)(8676002)(316002)(81973001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB3942;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uZnzjBlT6d/pHb9MLICC3QgKywacPVLhfABX+2Dbh2CoT6VqvFTVytaGHpv7cNV3/T2DXFPmTNqzL+/id3923g6dBX+mZUMPM2rFTf193sE7sRGDGt55/alRj/Q72saRO3vqLOv1Cc4dnOzVx4b3EOSJsUA2KH/amfr3vyDfGMb+Lcgp66zH4/iEA/cBuJ7SibRnhFnPWrY5qxTChruoGIDasgQ31ajZMjS6o5hu9q9UC+G/ywRU3yCQkukZAvs107rQRZh0kuo6BvQiELzjwacKAznzuC6a2CypKQbhfrW403Pz2EfsJkyYICe7k+kiiVcGeiQp4XWG3Q+db59rx/BZowvecHN1FBCsA2uGx7aXT6HkWh3IW4maDyatOkNPD2x7D3GBjpNBEGFxKtUMnKBuj0CLIousWcZAW6wX/G4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE719B9F98B0E541A21F7A61FE7FE00E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3d90b6-fbc6-48c1-d7a1-08d6e611926f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 21:47:26.3370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB3942
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBPbiBNYXkgMzEsIDIwMTksIGF0IDM6MzcgQU0sIFBhdmVsIE1hY2hlayA8cGF2ZWxAZGVueC5k
ZT4gd3JvdGU6DQo+IA0KPiBIaSENCj4gDQo+PiBbIFVwc3RyZWFtIGNvbW1pdCBmMmM2NWZiMzIy
MWFkYzZiNzNiMDU0OWZjN2JhODkyMDIyZGI5Nzk3IF0NCj4+IA0KPj4gV2hlbiBtb2R1bGVzIGFu
ZCBCUEYgZmlsdGVycyBhcmUgbG9hZGVkLCB0aGVyZSBpcyBhIHRpbWUgd2luZG93IGluDQo+PiB3
aGljaCBzb21lIG1lbW9yeSBpcyBib3RoIHdyaXRhYmxlIGFuZCBleGVjdXRhYmxlLiBBbiBhdHRh
Y2tlciB0aGF0IGhhcw0KPj4gYWxyZWFkeSBmb3VuZCBhbm90aGVyIHZ1bG5lcmFiaWxpdHkgKGUu
Zy4sIGEgZGFuZ2xpbmcgcG9pbnRlcikgbWlnaHQgYmUNCj4+IGFibGUgdG8gZXhwbG9pdCB0aGlz
IGJlaGF2aW9yIHRvIG92ZXJ3cml0ZSBrZXJuZWwgY29kZS4gUHJldmVudCBoYXZpbmcNCj4+IHdy
aXRhYmxlIGV4ZWN1dGFibGUgUFRFcyBpbiB0aGlzIHN0YWdlLg0KPj4gDQo+PiBJbiBhZGRpdGlv
biwgYXZvaWRpbmcgaGF2aW5nIFcrWCBtYXBwaW5ncyBjYW4gYWxzbyBzbGlnaHRseSBzaW1wbGlm
eSB0aGUNCj4+IHBhdGNoaW5nIG9mIG1vZHVsZXMgY29kZSBvbiBpbml0aWFsaXphdGlvbiAoZS5n
LiwgYnkgYWx0ZXJuYXRpdmVzIGFuZA0KPj4gc3RhdGljLWtleSksIGFzIHdvdWxkIGJlIGRvbmUg
aW4gdGhlIG5leHQgcGF0Y2guIFRoaXMgd2FzIGFjdHVhbGx5IHRoZQ0KPj4gbWFpbiBtb3RpdmF0
aW9uIGZvciB0aGlzIHBhdGNoLg0KPj4gDQo+PiBUbyBhdm9pZCBoYXZpbmcgVytYIG1hcHBpbmdz
LCBzZXQgdGhlbSBpbml0aWFsbHkgYXMgUlcgKE5YKSBhbmQgYWZ0ZXINCj4+IHRoZXkgYXJlIHNl
dCBhcyBSTyBzZXQgdGhlbSBhcyBYIGFzIHdlbGwuIFNldHRpbmcgdGhlbSBhcyBleGVjdXRhYmxl
IGlzDQo+PiBkb25lIGFzIGEgc2VwYXJhdGUgc3RlcCB0byBhdm9pZCBvbmUgY29yZSBpbiB3aGlj
aCB0aGUgb2xkIFBURSBpcyBjYWNoZWQNCj4+IChoZW5jZSB3cml0YWJsZSksIGFuZCBhbm90aGVy
IHdoaWNoIHNlZXMgdGhlIHVwZGF0ZWQgUFRFIChleGVjdXRhYmxlKSwNCj4+IHdoaWNoIHdvdWxk
IGJyZWFrIHRoZSBXXlggcHJvdGVjdGlvbi4NCj4gDQo+IEZpcnN0LCBpcyB0aGlzIHN0YWJsZSBt
YXRlcmlhbD8gWWVzLCBpdCBjaGFuZ2VzIHNvbWV0aGluZy4NCj4gDQo+IEJ1dCBpZiB5b3UgYXNz
dW1lIGF0dGFja2VyIGNhbiB3cml0ZSBpbnRvIGtlcm5lbCBtZW1vcnkgZHVyaW5nIG1vZHVsZQ0K
PiBsb2FkLCB3aGF0IHByZXZlbnRzIGhpbSB0byBjaGFuZ2UgdGhlIG1vZHVsZSBhcyBoZSBzZWVz
IGZpdCB3aGlsZSBpdA0KPiBpcyBub3QgZXhlY3V0YWJsZSwgc2ltcGx5IHdhaXRpbmcgZm9yIHN5
c3RlbSB0byBleGVjdXRlIGl0Pw0KPiANCj4gSSBkb24ndCBzZWUgc2VjdXJpdHkgYmVuZWZpdCBo
ZXJlLg0KDQpJIGFncmVlIHRoYXQgYXQgdGhlIG1vbWVudCB0aGUgYmVuZWZpdCBpdCBsaW1pdGVk
LiBJIHRoaW5rIHRoZSBiZW5lZml0IHdvdWxkDQpjb21lIGxhdGVyLCBpZiB0aGUgbW9kdWxlIHNp
Z25hdHVyZSBjaGVjayBpcyBwZXJmb3JtZWQgYWZ0ZXIgdGhlIG1vZHVsZSBoYXMNCmJlZW4gd3Jp
dGUtcHJvdGVjdGVkLCBidXQgYmVmb3JlIGl0IGlzIGFjdHVhbGx5IGV4ZWN1dGVkLg0KDQo+PiAr
KysgYi9hcmNoL3g4Ni9rZXJuZWwvYWx0ZXJuYXRpdmUuYw0KPj4gQEAgLTY2MiwxNSArNjYyLDI5
IEBAIHZvaWQgX19pbml0IGFsdGVybmF0aXZlX2luc3RydWN0aW9ucyh2b2lkKQ0KPj4gICogaGFu
ZGxlcnMgc2VlaW5nIGFuIGluY29uc2lzdGVudCBpbnN0cnVjdGlvbiB3aGlsZSB5b3UgcGF0Y2gu
DQo+PiAgKi8NCj4+IHZvaWQgKl9faW5pdF9vcl9tb2R1bGUgdGV4dF9wb2tlX2Vhcmx5KHZvaWQg
KmFkZHIsIGNvbnN0IHZvaWQgKm9wY29kZSwNCj4+IC0JCQkJCSAgICAgIHNpemVfdCBsZW4pDQo+
PiArCQkJCSAgICAgICBzaXplX3QgbGVuKQ0KPj4gew0KPj4gCXVuc2lnbmVkIGxvbmcgZmxhZ3M7
DQo+PiAtCWxvY2FsX2lycV9zYXZlKGZsYWdzKTsNCj4+IC0JbWVtY3B5KGFkZHIsIG9wY29kZSwg
bGVuKTsNCj4+IC0JbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOw0KPj4gLQlzeW5jX2NvcmUoKTsN
Cj4+IC0JLyogQ291bGQgYWxzbyBkbyBhIENMRkxVU0ggaGVyZSB0byBzcGVlZCB1cCBDUFUgcmVj
b3Zlcnk7IGJ1dA0KPj4gLQkgICB0aGF0IGNhdXNlcyBoYW5ncyBvbiBzb21lIFZJQSBDUFVzLiAq
Lw0KPj4gKw0KPj4gKwlpZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX05YKSAmJg0KPj4gKwkg
ICAgaXNfbW9kdWxlX3RleHRfYWRkcmVzcygodW5zaWduZWQgbG9uZylhZGRyKSkgew0KPj4gKwkJ
LyoNCj4+ICsJCSAqIE1vZHVsZXMgdGV4dCBpcyBtYXJrZWQgaW5pdGlhbGx5IGFzIG5vbi1leGVj
dXRhYmxlLCBzbyB0aGUNCj4+ICsJCSAqIGNvZGUgY2Fubm90IGJlIHJ1bm5pbmcgYW5kIHNwZWN1
bGF0aXZlIGNvZGUtZmV0Y2hlcyBhcmUNCj4+ICsJCSAqIHByZXZlbnRlZC4gSnVzdCBjaGFuZ2Ug
dGhlIGNvZGUuDQo+PiArCQkgKi8NCj4+ICsJCW1lbWNweShhZGRyLCBvcGNvZGUsIGxlbik7DQo+
PiArCX0gZWxzZSB7DQo+PiArCQlsb2NhbF9pcnFfc2F2ZShmbGFncyk7DQo+PiArCQltZW1jcHko
YWRkciwgb3Bjb2RlLCBsZW4pOw0KPj4gKwkJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOw0KPj4g
KwkJc3luY19jb3JlKCk7DQo+PiArDQo+PiArCQkvKg0KPj4gKwkJICogQ291bGQgYWxzbyBkbyBh
IENMRkxVU0ggaGVyZSB0byBzcGVlZCB1cCBDUFUgcmVjb3Zlcnk7IGJ1dA0KPj4gKwkJICogdGhh
dCBjYXVzZXMgaGFuZ3Mgb24gc29tZSBWSUEgQ1BVcy4NCj4+ICsJCSAqLw0KPiANCj4gSSBkb24n
dCBnZXQgaXQuIElmIGNvZGUgY2FuIG5vdCBiZSBydW5uaW5nIGhlcmUsIGl0IGNhbiBub3QgYmUg
cnVubmluZw0KPiBpbiB0aGUgIU5YIGNhc2UsIGVpdGhlciwgYW5kIHdlIGFyZSBmcmVlIHRvIGp1
c3QgY2hhbmdlDQo+IGl0LiBTcGVjdWxhdGl2ZSBleGVjdXRpb24gc2hvdWxkIG5vdCBiZSBhIHBy
b2JsZW0sIGVpdGhlciwgYXMgQ1BVcyBhcmUNCj4gc3VwcG9zZWQgdG8gbWFzayBpdCwgYW5kIHRo
ZXJlIGFyZSBubyBrbm93biBidWdzIGluIHRoYXQgYXJlYS4gKFBsdXMsDQo+IEknZCBub3QgYmUg
c3VycHJpc2UgaWYgc3BlY3VsYXRpdmUgZXhlY3V0aW9uIGlnbm9yZWQgTlguLi4ganVzdCBzYXlp
bmcNCj4gOi0pICkNCg0KWWVzLCB0aGUgbW9kdWxlIGNvZGUgc2hvdWxkIG5vdCBydW4sIGJ1dCBz
cGVjdWxhdGl2ZSBleGVjdXRpb24gbWlnaHQgY2F1c2UNCml0IHRvIGJlIGNhY2hlZCBpbiB0aGUg
aW5zdHJ1Y3Rpb24gY2FjaGUgKGFzIHVubGlrZWx5IGFzIGl0IG1pZ2h0IGJlLCBidXQNCndlIG5l
ZWQgdG8gY29uc2lkZXIgbWFsaWNpb3VzIHVzZXJzIHRoYXQgcGxheSB3aXRoIGJyYW5jaCBwcmVk
aWN0b3JzKS4NCg0KSSBhbSB1bmZhbWlsaWFyIHdpdGggYW55IGJ1ZyB0aGF0IG1pZ2h0IGNhdXNl
IHRoZSBDUFUgdG8gc3BlY3VsYXRpdmVseQ0KaWdub3JlIHRoZSBOWCBiaXQuIFdpdGhvdXQgdW5k
ZXJlc3RpbWF0aW5nIEludGVs4oCZcyBhYmlsaXR5IHRvIGNyZWF0ZQ0KdGVycmlibGUgYnVncywg
SSB3b3VsZCBhc3N1bWUsIGZvciBub3csIHRoYXQgaXQgaXMgc2FmZS4NCiA=
