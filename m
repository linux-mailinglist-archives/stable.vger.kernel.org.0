Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3994506B6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 15:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbhKOO0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 09:26:54 -0500
Received: from smtp4.jd.com ([59.151.64.76]:2049 "EHLO smtp4.jd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235145AbhKOO0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 09:26:46 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2021 09:26:45 EST
Received: from JDCloudMail06.360buyAD.local (172.31.68.39) by
 JDCloudMail03.360buyAD.local (172.31.68.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 15 Nov 2021 22:08:29 +0800
Received: from JDCloudMail06.360buyAD.local ([fe80::643e:3192:cad7:c913]) by
 JDCloudMail06.360buyAD.local ([fe80::643e:3192:cad7:c913%5]) with mapi id
 15.01.2375.007; Mon, 15 Nov 2021 22:08:29 +0800
From:   =?gb2312?B?u8bA1g==?= <huangle1@jd.com>
To:     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] KVM: x86: Fix uninitialized eoi_exit_bitmap usage in
 vcpu_load_eoi_exitmap()
Thread-Topic: [PATCH v2] KVM: x86: Fix uninitialized eoi_exit_bitmap usage in
 vcpu_load_eoi_exitmap()
Thread-Index: AQHX2ioPJQ7vMfDmj0ezvcoium2MGA==
Date:   Mon, 15 Nov 2021 14:08:29 +0000
Message-ID: <62115b277dab49ea97da5633f8522daf@jd.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.31.14.18]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SW4gdmNwdV9sb2FkX2VvaV9leGl0bWFwKCksIGN1cnJlbnRseSB0aGUgZW9pX2V4aXRfYml0bWFw
WzRdIGFycmF5IGlzDQppbml0aWFsaXplZCBvbmx5IHdoZW4gSHlwZXItViBjb250ZXh0IGlzIGF2
YWlsYWJsZSwgaW4gb3RoZXIgcGF0aCBpdCBpcw0KanVzdCBwYXNzZWQgdG8ga3ZtX3g4Nl9vcHMu
bG9hZF9lb2lfZXhpdG1hcCgpIGRpcmVjdGx5IGZyb20gb24gdGhlIHN0YWNrLA0Kd2hpY2ggd291
bGQgY2F1c2UgdW5leHBlY3RlZCBpbnRlcnJ1cHQgZGVsaXZlcnkvaGFuZGxpbmcgaXNzdWVzLCBl
LmcuIGFuDQoqb2xkKiBsaW51eCBrZXJuZWwgdGhhdCByZWxpZXMgb24gUElUIHRvIGRvIGNsb2Nr
IGNhbGlicmF0aW9uIG9uIEtWTSBtaWdodA0KcmFuZG9tbHkgZmFpbCB0byBib290Lg0KDQpGaXgg
aXQgYnkgcGFzc2luZyBpb2FwaWNfaGFuZGxlZF92ZWN0b3JzIHRvIGxvYWRfZW9pX2V4aXRtYXAo
KSB3aGVuIEh5cGVyLVYNCmNvbnRleHQgaXMgbm90IGF2YWlsYWJsZS4NCg0KRml4ZXM6IGYyYmMx
NGI2OWMzOCAoIktWTTogeDg2OiBoeXBlci12OiBQcmVwYXJlIHRvIG1lZXQgdW5hbGxvY2F0ZWQg
SHlwZXItViBjb250ZXh0IikNCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQpSZXZpZXdlZC1i
eTogVml0YWx5IEt1em5ldHNvdiA8dmt1em5ldHNAcmVkaGF0LmNvbT4NClNpZ25lZC1vZmYtYnk6
IEh1YW5nIExlIDxodWFuZ2xlMUBqZC5jb20+DQotLS0NCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCmluZGV4IGRjN2ViNWZkZGZkMy4uMjY0NjZm
OTRlMzFhIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQorKysgYi9hcmNoL3g4Ni9r
dm0veDg2LmMNCkBAIC05NTQ3LDEyICs5NTQ3LDE2IEBAIHN0YXRpYyB2b2lkIHZjcHVfbG9hZF9l
b2lfZXhpdG1hcChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQogCWlmICgha3ZtX2FwaWNfaHdfZW5h
YmxlZCh2Y3B1LT5hcmNoLmFwaWMpKQ0KIAkJcmV0dXJuOw0KIA0KLQlpZiAodG9faHZfdmNwdSh2
Y3B1KSkNCisJaWYgKHRvX2h2X3ZjcHUodmNwdSkpIHsNCiAJCWJpdG1hcF9vcigodWxvbmcgKill
b2lfZXhpdF9iaXRtYXAsDQogCQkJICB2Y3B1LT5hcmNoLmlvYXBpY19oYW5kbGVkX3ZlY3RvcnMs
DQogCQkJICB0b19odl9zeW5pYyh2Y3B1KS0+dmVjX2JpdG1hcCwgMjU2KTsNCisJCXN0YXRpY19j
YWxsKGt2bV94ODZfbG9hZF9lb2lfZXhpdG1hcCkodmNwdSwgZW9pX2V4aXRfYml0bWFwKTsNCisJ
CXJldHVybjsNCisJfQ0KIA0KLQlzdGF0aWNfY2FsbChrdm1feDg2X2xvYWRfZW9pX2V4aXRtYXAp
KHZjcHUsIGVvaV9leGl0X2JpdG1hcCk7DQorCXN0YXRpY19jYWxsKGt2bV94ODZfbG9hZF9lb2lf
ZXhpdG1hcCkoDQorCQl2Y3B1LCAodTY0ICopdmNwdS0+YXJjaC5pb2FwaWNfaGFuZGxlZF92ZWN0
b3JzKTsNCiB9DQogDQogdm9pZCBrdm1fYXJjaF9tbXVfbm90aWZpZXJfaW52YWxpZGF0ZV9yYW5n
ZShzdHJ1Y3Qga3ZtICprdm0sDQo=
