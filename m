Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20905164FB6
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 21:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgBSUUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 15:20:43 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:19582 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgBSUUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 15:20:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582143642; x=1613679642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RmNg5Q4dJUngGcjme7J+r95Mhid571iCUytuRLg8HSo=;
  b=Law40/uVC1erUhhkmU4CjZy1+znaRuTBDgtKeyZgtXOq8zGj7pcshUVL
   cf5kFzvZXiKt1mBgBPPNE0MsXVX45nX6N+zNZRhgw6SutRMKM9myrSdP+
   hobiiWrBu7Q8IQBZQC6HABbmXOp9mbxGs3BKRVQFhczpJPe+ogTK1MR2w
   4=;
IronPort-SDR: iY08W6D8c+1r/y14KMu/hGESVmN1TevJ1surPH7YBwaxSbC/3wOiMtuWLtowDFiwKeIA6U6Z4q
 wlHklExzja9g==
X-IronPort-AV: E=Sophos;i="5.70,461,1574121600"; 
   d="scan'208";a="26187028"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Feb 2020 20:20:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 7957CA1D9B;
        Wed, 19 Feb 2020 20:20:31 +0000 (UTC)
Received: from EX13D30UWB002.ant.amazon.com (10.43.161.110) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 20:20:30 +0000
Received: from EX13D01UWB002.ant.amazon.com (10.43.161.136) by
 EX13D30UWB002.ant.amazon.com (10.43.161.110) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 20:20:30 +0000
Received: from EX13D01UWB002.ant.amazon.com ([10.43.161.136]) by
 EX13d01UWB002.ant.amazon.com ([10.43.161.136]) with mapi id 15.00.1497.006;
 Wed, 19 Feb 2020 20:20:30 +0000
From:   "Singh, Balbir" <sblbir@amazon.com>
To:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "Jitindar SIngh, Suraj" <surajjs@amazon.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>
Subject: Re: [PATCH 2/3] ext4: fix potential race between s_group_info online
 resizing and access
Thread-Topic: [PATCH 2/3] ext4: fix potential race between s_group_info online
 resizing and access
Thread-Index: AQHV5tIgr+sddfKiJE6XagCf4JPm56gi9mqA
Date:   Wed, 19 Feb 2020 20:20:30 +0000
Message-ID: <4a16939524d5c6e32bcd6c0f5acad003c4a73d0d.camel@amazon.com>
References: <20200219030851.2678-1-surajjs@amazon.com>
         <20200219030851.2678-3-surajjs@amazon.com>
In-Reply-To: <20200219030851.2678-3-surajjs@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.109]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DE7B3C4D2DA2945B3A5E6656EA3AAE1@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIwLTAyLTE4IGF0IDE5OjA4IC0wODAwLCBTdXJhaiBKaXRpbmRhciBTaW5naCB3
cm90ZToNCj4gRHVyaW5nIGFuIG9ubGluZSByZXNpemUgYW4gYXJyYXkgb2YgcG9pbnRlcnMgdG8g
c19ncm91cF9pbmZvIGdldHMgcmVwbGFjZWQNCj4gc28gaXQgY2FuIGdldCBlbmxhcmdlZC4gSWYg
dGhlcmUgaXMgYSBjb25jdXJyZW50IGFjY2VzcyB0byB0aGUgYXJyYXkgaW4NCj4gZXh0NF9nZXRf
Z3JvdXBfaW5mbygpIGFuZCB0aGlzIG1lbW9yeSBoYXMgYmVlbiByZXVzZWQgdGhlbiB0aGlzIGNh
biBsZWFkIHRvDQo+IGFuIGludmFsaWQgbWVtb3J5IGFjY2Vzcy4NCj4gDQo+IExpbms6IGh0dHBz
Oi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjA2NDQzDQo+IFNpZ25lZC1v
ZmYtYnk6IFN1cmFqIEppdGluZGFyIFNpbmdoIDxzdXJhampzQGFtYXpvbi5jb20+DQo+IENjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnDQo+IC0tLQ0KPiAgZnMvZXh0NC9leHQ0LmggICAgfCAgNiAr
KystLS0NCj4gIGZzL2V4dDQvbWJhbGxvYy5jIHwgMTAgKysrKysrLS0tLQ0KPiAgMiBmaWxlcyBj
aGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZnMvZXh0NC9leHQ0LmggYi9mcy9leHQ0L2V4dDQuaA0KPiBpbmRleCAyMzZmYzY1MDAzNDAu
LjNmNGFhYWFlN2RhNiAxMDA2NDQNCj4gLS0tIGEvZnMvZXh0NC9leHQ0LmgNCj4gKysrIGIvZnMv
ZXh0NC9leHQ0LmgNCj4gQEAgLTI5OTQsMTMgKzI5OTQsMTMgQEAgc3RhdGljIGlubGluZQ0KPiAg
c3RydWN0IGV4dDRfZ3JvdXBfaW5mbyAqZXh0NF9nZXRfZ3JvdXBfaW5mbyhzdHJ1Y3Qgc3VwZXJf
YmxvY2sgKnNiLA0KPiAgCQkJCQkgICAgZXh0NF9ncm91cF90IGdyb3VwKQ0KPiAgew0KPiAtCSBz
dHJ1Y3QgZXh0NF9ncm91cF9pbmZvICoqKmdycF9pbmZvOw0KPiArCSBzdHJ1Y3QgZXh0NF9ncm91
cF9pbmZvICoqZ3JwX2luZm87DQo+ICAJIGxvbmcgaW5kZXh2LCBpbmRleGg7DQo+ICAJIEJVR19P
Tihncm91cCA+PSBFWFQ0X1NCKHNiKS0+c19ncm91cHNfY291bnQpOw0KPiAtCSBncnBfaW5mbyA9
IEVYVDRfU0Ioc2IpLT5zX2dyb3VwX2luZm87DQo+ICAJIGluZGV4diA9IGdyb3VwID4+IChFWFQ0
X0RFU0NfUEVSX0JMT0NLX0JJVFMoc2IpKTsNCj4gIAkgaW5kZXhoID0gZ3JvdXAgJiAoKEVYVDRf
REVTQ19QRVJfQkxPQ0soc2IpKSAtIDEpOw0KPiAtCSByZXR1cm4gZ3JwX2luZm9baW5kZXh2XVtp
bmRleGhdOw0KPiArCSBncnBfaW5mbyA9IHNiaV9hcnJheV9yY3VfZGVyZWYoRVhUNF9TQihzYiks
IHNfZ3JvdXBfaW5mbywgaW5kZXh2KTsNCj4gKwkgcmV0dXJuIGdycF9pbmZvW2luZGV4aF07DQo+
ICB9DQo+ICANCj4gIC8qDQo+IGRpZmYgLS1naXQgYS9mcy9leHQ0L21iYWxsb2MuYyBiL2ZzL2V4
dDQvbWJhbGxvYy5jDQo+IGluZGV4IGY2NDgzODE4NzU1OS4uMGQ5YjE3YWZjODVmIDEwMDY0NA0K
PiAtLS0gYS9mcy9leHQ0L21iYWxsb2MuYw0KPiArKysgYi9mcy9leHQ0L21iYWxsb2MuYw0KPiBA
QCAtMjM1Niw3ICsyMzU2LDcgQEAgaW50IGV4dDRfbWJfYWxsb2NfZ3JvdXBpbmZvKHN0cnVjdCBz
dXBlcl9ibG9jayAqc2IsDQo+IGV4dDRfZ3JvdXBfdCBuZ3JvdXBzKQ0KPiAgew0KPiAgCXN0cnVj
dCBleHQ0X3NiX2luZm8gKnNiaSA9IEVYVDRfU0Ioc2IpOw0KPiAgCXVuc2lnbmVkIHNpemU7DQo+
IC0Jc3RydWN0IGV4dDRfZ3JvdXBfaW5mbyAqKipuZXdfZ3JvdXBpbmZvOw0KPiArCXN0cnVjdCBl
eHQ0X2dyb3VwX2luZm8gKioqb2xkX2dyb3VwaW5mbywgKioqbmV3X2dyb3VwaW5mbzsNCj4gIA0K
PiAgCXNpemUgPSAobmdyb3VwcyArIEVYVDRfREVTQ19QRVJfQkxPQ0soc2IpIC0gMSkgPj4NCj4g
IAkJRVhUNF9ERVNDX1BFUl9CTE9DS19CSVRTKHNiKTsNCj4gQEAgLTIzNjksMTMgKzIzNjksMTUg
QEAgaW50IGV4dDRfbWJfYWxsb2NfZ3JvdXBpbmZvKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsDQo+
IGV4dDRfZ3JvdXBfdCBuZ3JvdXBzKQ0KPiAgCQlleHQ0X21zZyhzYiwgS0VSTl9FUlIsICJjYW4n
dCBhbGxvY2F0ZSBidWRkeSBtZXRhIGdyb3VwIik7DQo+ICAJCXJldHVybiAtRU5PTUVNOw0KPiAg
CX0NCj4gLQlpZiAoc2JpLT5zX2dyb3VwX2luZm8pIHsNCj4gKwlvbGRfZ3JvdXBpbmZvID0gc2Jp
LT5zX2dyb3VwX2luZm87DQo+ICsJaWYgKHNiaS0+c19ncm91cF9pbmZvKQ0KPiAgCQltZW1jcHko
bmV3X2dyb3VwaW5mbywgc2JpLT5zX2dyb3VwX2luZm8sDQo+ICAJCSAgICAgICBzYmktPnNfZ3Jv
dXBfaW5mb19zaXplICogc2l6ZW9mKCpzYmktPnNfZ3JvdXBfaW5mbykpOw0KPiAtCQlrdmZyZWUo
c2JpLT5zX2dyb3VwX2luZm8pOw0KPiAtCX0NCj4gIAlzYmktPnNfZ3JvdXBfaW5mbyA9IG5ld19n
cm91cGluZm87DQo+ICsJcmN1X2Fzc2lnbl9wb2ludGVyKHNiaS0+c19ncm91cF9pbmZvLCBuZXdf
Z3JvdXBpbmZvKTsNCj4gIAlzYmktPnNfZ3JvdXBfaW5mb19zaXplID0gc2l6ZSAvIHNpemVvZigq
c2JpLT5zX2dyb3VwX2luZm8pOw0KPiArCWlmIChvbGRfZ3JvdXBpbmZvKQ0KPiArCQlleHQ0X2t2
ZnJlZV9hcnJheV9yY3Uob2xkX2dyb3VwaW5mbyk7DQo+ICAJZXh0NF9kZWJ1ZygiYWxsb2NhdGVk
IHNfZ3JvdXBpbmZvIGFycmF5IGZvciAlZCBtZXRhX2JnJ3NcbiIsIA0KPiAgCQkgICBzYmktPnNf
Z3JvdXBfaW5mb19zaXplKTsNCj4gIAlyZXR1cm4gMDsNCg0KUmV2aWV3ZWQtYnk6IEJhbGJpciBT
aW5naCA8c2JsYmlyQGFtYXpvbi5jb20+DQo=
