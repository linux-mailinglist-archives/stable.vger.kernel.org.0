Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B7A398244
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 08:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFBG7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 02:59:00 -0400
Received: from [110.188.70.11] ([110.188.70.11]:64543 "EHLO spam2.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S231535AbhFBG6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 02:58:46 -0400
Received: from MK-DB.hygon.cn ([172.23.18.60])
        by spam2.hygon.cn with ESMTP id 1526tDn4007350;
        Wed, 2 Jun 2021 14:55:13 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from cncheex01.Hygon.cn ([172.23.18.10])
        by MK-DB.hygon.cn with ESMTP id 1526t5bd049012;
        Wed, 2 Jun 2021 14:55:05 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from cncheex01.Hygon.cn (172.23.18.10) by cncheex01.Hygon.cn
 (172.23.18.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.10; Wed, 2 Jun
 2021 14:55:06 +0800
Received: from cncheex01.Hygon.cn ([172.23.18.10]) by cncheex01.Hygon.cn
 ([172.23.18.10]) with mapi id 15.01.2242.010; Wed, 2 Jun 2021 14:55:06 +0800
From:   Wen Pu <puwen@hygon.cn>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@suse.de" <bp@suse.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
Thread-Topic: [PATCH] x86/sev: Check whether SEV or SME is supported first
Thread-Index: AQHXUgBKw/0mKgIIz0i8q+a993CPGqr+/loAgADP+IA=
Date:   Wed, 2 Jun 2021 06:55:05 +0000
Message-ID: <8e1d7510-563a-3b54-6037-8c0904998123@hygon.cn>
References: <20210526072424.22453-1-puwen@hygon.cn>
 <dc69a9bb-a4a0-d82b-2e9c-cf6336ab8252@amd.com>
In-Reply-To: <dc69a9bb-a4a0-d82b-2e9c-cf6336ab8252@amd.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.44]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C049996FDAED484EBCE36F654AA52901@Hygon.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MAIL: spam2.hygon.cn 1526tDn4007350
X-DNSRBL: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMjAyMS82LzIgMjozMCwgVG9tIExlbmRhY2t5IHdyb3RlOg0KPiBPbiA1LzI2LzIxIDI6MjQg
QU0sIFB1IFdlbiB3cm90ZToNCj4+IFRoZSBmaXJzdCB0d28gYml0cyBvZiB0aGUgQ1BVSUQgbGVh
ZiAweDgwMDAwMDFGIEVBWCBpbmRpY2F0ZSB3aGV0aGVyDQo+PiBTRVYgb3IgU01FIGlzIHN1cHBv
cnRlZCByZXNwZWN0aXZlbHkuIEl0J3MgYmV0dGVyIHRvIGNoZWNrIHdoZXRoZXINCj4+IFNFViBv
ciBTTUUgaXMgc3VwcG9ydGVkIGJlZm9yZSBjaGVja2luZyB0aGUgU0VWIE1TUigweGMwMDEwMTMx
KSB0bw0KPj4gc2VlIHdoZXRoZXIgU0VWIG9yIFNNRSBpcyBlbmFibGVkLg0KPj4NCj4+IFRoaXMg
YWxzbyBhdm9pZCB0aGUgTVNSIHJlYWRpbmcgZmFpbHVyZSBvbiB0aGUgZmlyc3QgZ2VuZXJhdGlv
biBIeWdvbg0KPj4gRGh5YW5hIENQVSB3aGljaCBkb2VzIG5vdCBzdXBwb3J0IFNFViBvciBTTUUu
DQo+Pg0KPj4gRml4ZXM6IGVhYjY5NmQ4ZThiOSAoIng4Ni9zZXY6IERvIG5vdCByZXF1aXJlIEh5
cGVydmlzb3IgQ1BVSUQgYml0IGZvciBTRVYgZ3Vlc3RzIikNCj4+IENjOiA8c3RhYmxlQHZnZXIu
a2VybmVsLm9yZz4gIyB2NS4xMCsNCj4+IFNpZ25lZC1vZmYtYnk6IFB1IFdlbiA8cHV3ZW5AaHln
b24uY24+DQo+IA0KPiBJIHRoaW5rIHRoZSBjb21taXQgbWVzc2FnZSBuZWVkcyB0byBiZSBleHBh
bmRlZCB0byBjbGFyaWZ5IHRoZSBzaXR1YXRpb25zDQo+IGFuZCBwcm92aWRlIG1vcmUgZGV0YWls
Lg0KDQpPa2F5Lg0KDQo+IFRoaXMgaXMgYm90aCBhIGJhcmUtbWV0YWwgaXNzdWUgYW5kIGEgZ3Vl
c3QvVk0gaXNzdWUuIFNpbmNlIEh5Z29uIGRvZXNuJ3QNCj4gc3VwcG9ydCB0aGUgTVNSX0FNRDY0
X1NFViBNU1IsIHJlYWRpbmcgdGhhdCBNU1IgcmVzdWx0cyBpbiBhICNHUCAtIGVpdGhlcg0KPiBk
aXJlY3RseSBmcm9tIGhhcmR3YXJlIGluIHRoZSBiYXJlLW1ldGFsIGNhc2Ugb3IgdmlhIHRoZSBo
eXBlcnZpc29yDQo+IChiZWNhdXNlIHRoZSBSRE1TUiBpcyBhY3R1YWxseSBpbnRlcmNlcHRlZCkg
aW4gdGhlIGd1ZXN0L1ZNIGNhc2UsDQo+IHJlc3VsdGluZyBpbiBhIGZhaWxlZCBib290LiBBbmQg
c2luY2UgdGhpcyBpcyB2ZXJ5IGVhcmx5IGluIHRoZSBib290DQo+IHBoYXNlLCByZG1zcmxfc2Fm
ZSgpL25hdGl2ZV9yZWFkX21zcl9zYWZlKCkgY2FuJ3QgYmUgdXNlZC4NCg0KVGhlIGRlc2NyaXB0
aW9uIGlzIGdvb2QsIHdpbGwgYWRkIHRoaXMuDQoNCj4gU28gYnkgY2hlY2tpbmcgdGhlIENQVUlE
IGluZm9ybWF0aW9uIGJlZm9yZSBhdHRlbXB0aW5nIHRoZSBSRE1TUiwgdGhpcw0KPiBnb2VzIGJh
Y2sgdG8gdGhlIGJlaGF2aW9yIGJlZm9yZSB0aGUgcGF0Y2ggaWRlbnRpZmllZCBpbiB0aGUgRml4
ZXM6IHRhZy4NCj4gDQo+IFdpdGggYW4gaW1wcm92ZWQgY29tbWl0IG1lc3NhZ2U6DQo+IA0KPiBB
Y2tlZC1ieTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCg0KVGhhbmtz
LCB3aWxsIHNlbmQgcGF0Y2ggdjIgd2l0aCBpbXByb3ZlZCBjb21taXQgbWVzc2FnZXMuDQoNCi0t
IA0KUmVnYXJkcywNClB1IFdlbg0KDQo+PiAtLS0NCj4+ICBhcmNoL3g4Ni9tbS9tZW1fZW5jcnlw
dF9pZGVudGl0eS5jIHwgMTEgKysrKysrLS0tLS0NCj4+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9t
bS9tZW1fZW5jcnlwdF9pZGVudGl0eS5jIGIvYXJjaC94ODYvbW0vbWVtX2VuY3J5cHRfaWRlbnRp
dHkuYw0KPj4gaW5kZXggYTk2MzlmNjYzZDI1Li40NzBiMjAyMDg0MzAgMTAwNjQ0DQo+PiAtLS0g
YS9hcmNoL3g4Ni9tbS9tZW1fZW5jcnlwdF9pZGVudGl0eS5jDQo+PiArKysgYi9hcmNoL3g4Ni9t
bS9tZW1fZW5jcnlwdF9pZGVudGl0eS5jDQo+PiBAQCAtNTA0LDEwICs1MDQsNiBAQCB2b2lkIF9f
aW5pdCBzbWVfZW5hYmxlKHN0cnVjdCBib290X3BhcmFtcyAqYnApDQo+PiAgI2RlZmluZSBBTURf
U01FX0JJVAlCSVQoMCkNCj4+ICAjZGVmaW5lIEFNRF9TRVZfQklUCUJJVCgxKQ0KPj4gIA0KPj4g
LQkvKiBDaGVjayB0aGUgU0VWIE1TUiB3aGV0aGVyIFNFViBvciBTTUUgaXMgZW5hYmxlZCAqLw0K
Pj4gLQlzZXZfc3RhdHVzICAgPSBfX3JkbXNyKE1TUl9BTUQ2NF9TRVYpOw0KPj4gLQlmZWF0dXJl
X21hc2sgPSAoc2V2X3N0YXR1cyAmIE1TUl9BTUQ2NF9TRVZfRU5BQkxFRCkgPyBBTURfU0VWX0JJ
VCA6IEFNRF9TTUVfQklUOw0KPj4gLQ0KPj4gIAkvKg0KPj4gIAkgKiBDaGVjayBmb3IgdGhlIFNN
RS9TRVYgZmVhdHVyZToNCj4+ICAJICogICBDUFVJRCBGbjgwMDBfMDAxRltFQVhdDQo+PiBAQCAt
NTE5LDExICs1MTUsMTYgQEAgdm9pZCBfX2luaXQgc21lX2VuYWJsZShzdHJ1Y3QgYm9vdF9wYXJh
bXMgKmJwKQ0KPj4gIAllYXggPSAweDgwMDAwMDFmOw0KPj4gIAllY3ggPSAwOw0KPj4gIAluYXRp
dmVfY3B1aWQoJmVheCwgJmVieCwgJmVjeCwgJmVkeCk7DQo+PiAtCWlmICghKGVheCAmIGZlYXR1
cmVfbWFzaykpDQo+PiArCS8qIENoZWNrIHdoZXRoZXIgU0VWIG9yIFNNRSBpcyBzdXBwb3J0ZWQg
Ki8NCj4+ICsJaWYgKCEoZWF4ICYgKEFNRF9TRVZfQklUIHwgQU1EX1NNRV9CSVQpKSkNCj4+ICAJ
CXJldHVybjsNCj4+ICANCj4+ICAJbWVfbWFzayA9IDFVTCA8PCAoZWJ4ICYgMHgzZik7DQo+PiAg
DQo+PiArCS8qIENoZWNrIHRoZSBTRVYgTVNSIHdoZXRoZXIgU0VWIG9yIFNNRSBpcyBlbmFibGVk
ICovDQo+PiArCXNldl9zdGF0dXMgICA9IF9fcmRtc3IoTVNSX0FNRDY0X1NFVik7DQo+PiArCWZl
YXR1cmVfbWFzayA9IChzZXZfc3RhdHVzICYgTVNSX0FNRDY0X1NFVl9FTkFCTEVEKSA/IEFNRF9T
RVZfQklUIDogQU1EX1NNRV9CSVQ7DQo+PiArDQo+PiAgCS8qIENoZWNrIGlmIG1lbW9yeSBlbmNy
eXB0aW9uIGlzIGVuYWJsZWQgKi8NCj4+ICAJaWYgKGZlYXR1cmVfbWFzayA9PSBBTURfU01FX0JJ
VCkgew0KPj4gIAkJLyoNCj4+
