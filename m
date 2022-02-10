Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97FB4B076B
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 08:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbiBJHpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 02:45:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiBJHpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 02:45:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4D5D71;
        Wed,  9 Feb 2022 23:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644479122; x=1676015122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=44LaDEnFmsyo7gpOdTVmGfFRRPZU71Ox9CAQNnOHsjA=;
  b=lyA2jZVwtH1bL85FPBk0ll9PUcd8zio+DC3T8wuta2LvN9rSRGDf7I+P
   KpsGNoBO+sxVDFQkQFywZc7zIoeLdHlyAZwckilCFl/d0gdUqBSVja0hC
   X01ncc66BehloLWcSEC1UJ7We3WoxS09SniIWgLvKx5Hx89cJZFI4dSUC
   RxfwUMRGjHGq7f/qUS1VxYUy8bgcJSuKYiFVFqrBmrn9c1mXYVqGK1MHM
   Iw7HArqGU8M/9MMEC9AthZD7zrN/l+6uwg8iLPuw6LMjQ4J7tEPBQyi74
   ysHRG1rbvZu6ET9y8yxTLGh2H2i9N+PUjxvx6JZK6YdjPGMfSlKrFOYPg
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="312722214"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="312722214"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 23:45:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="482654014"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 09 Feb 2022 23:45:22 -0800
Received: from shsmsx606.ccr.corp.intel.com (10.109.6.216) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 9 Feb 2022 23:45:20 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX606.ccr.corp.intel.com (10.109.6.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 10 Feb 2022 15:45:19 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Thu, 10 Feb 2022 15:45:19 +0800
From:   "Zhang, Rui" <rui.zhang@intel.com>
To:     Doug Smythies <dsmythies@telus.net>,
        "Tang, Feng" <feng.tang@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: RE: CPU excessively long times between frequency scaling driver calls
 - bisected
Thread-Topic: CPU excessively long times between frequency scaling driver
 calls - bisected
Thread-Index: AQHYHJVOC5v+WEtwfEyYLZSsg54kgKyIt1UAgAAiM4CAAWI5gIACK5tg
Date:   Thu, 10 Feb 2022 07:45:19 +0000
Message-ID: <e185b89fb97f47758a5e10239fc3eed0@intel.com>
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net>
 <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com>
 <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
In-Reply-To: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRG91ZyBTbXl0aGllcyA8
ZHNteXRoaWVzQHRlbHVzLm5ldD4NCj4gU2VudDogV2VkbmVzZGF5LCBGZWJydWFyeSAwOSwgMjAy
MiAyOjIzIFBNDQo+IFRvOiBUYW5nLCBGZW5nIDxmZW5nLnRhbmdAaW50ZWwuY29tPg0KPiBDYzog
VGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+OyBwYXVsbWNrQGtlcm5lbC5vcmc7
DQo+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IHg4NkBrZXJuZWwub3JnOyBsaW51eC1wbUB2Z2Vy
Lmtlcm5lbC5vcmc7IHNyaW5pdmFzDQo+IHBhbmRydXZhZGEgPHNyaW5pdmFzLnBhbmRydXZhZGFA
bGludXguaW50ZWwuY29tPjsgZHNteXRoaWVzDQo+IDxkc215dGhpZXNAdGVsdXMubmV0Pg0KPiBT
dWJqZWN0OiBSZTogQ1BVIGV4Y2Vzc2l2ZWx5IGxvbmcgdGltZXMgYmV0d2VlbiBmcmVxdWVuY3kg
c2NhbGluZyBkcml2ZXINCj4gY2FsbHMgLSBiaXNlY3RlZA0KPiANCj4gT24gVHVlLCBGZWIgOCwg
MjAyMiBhdCAxOjE1IEFNIEZlbmcgVGFuZyA8ZmVuZy50YW5nQGludGVsLmNvbT4gd3JvdGU6DQo+
ID4gT24gTW9uLCBGZWIgMDcsIDIwMjIgYXQgMTE6MTM6MDBQTSAtMDgwMCwgRG91ZyBTbXl0aGll
cyB3cm90ZToNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFNpbmNlIGtlcm5lbCA1LjE2LXJjNCBhbmQg
Y29tbWl0Og0KPiA+ID4gPiA+IGI1MGRiNzA5NWZlMDAyZmEzZTE2NjA1NTQ2Y2JhNjZiZjFiNjhh
M2UNCj4gPiA+ID4gPiAiIHg4Ni90c2M6IERpc2FibGUgY2xvY2tzb3VyY2Ugd2F0Y2hkb2cgZm9y
IFRTQyBvbiBxdWFsaWZpZWQgcGxhdG9ybXMiDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGVyZSBh
cmUgbm93IG9jY2FzaW9ucyB3aGVyZSB0aW1lcyBiZXR3ZWVuIGNhbGxzIHRvIHRoZSBkcml2ZXIN
Cj4gPiA+ID4gPiBjYW4gYmUgb3ZlciAxMDAncyBvZiBzZWNvbmRzIGFuZCBjYW4gcmVzdWx0IGlu
IHRoZSBDUFUgZnJlcXVlbmN5DQo+ID4gPiA+ID4gYmVpbmcgbGVmdCB1bm5lY2Vzc2FyaWx5IGhp
Z2ggZm9yIGV4dGVuZGVkIHBlcmlvZHMuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBGcm9tIHRoZSBu
dW1iZXIgb2YgY2xvY2sgY3ljbGVzIGV4ZWN1dGVkIGJldHdlZW4gdGhlc2UgbG9uZw0KPiA+ID4g
PiA+IGR1cmF0aW9ucyBvbmUgY2FuIHRlbGwgdGhhdCB0aGUgQ1BVIGhhcyBiZWVuIHJ1bm5pbmcg
Y29kZSwgYnV0DQo+ID4gPiA+ID4gdGhlIGRyaXZlciBuZXZlciBnb3QgY2FsbGVkLg0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gQXR0YWNoZWQgYXJlIHNvbWUgZ3JhcGhzIGZyb20gc29tZSB0cmFjZSBk
YXRhIGFjcXVpcmVkIHVzaW5nDQo+ID4gPiA+ID4gaW50ZWxfcHN0YXRlX3RyYWNlci5weSB3aGVy
ZSBvbmUgY2FuIG9ic2VydmUgYW4gaWRsZSBzeXN0ZW0NCj4gPiA+ID4gPiBiZXR3ZWVuIGFib3V0
IDQyIGFuZCB3ZWxsIG92ZXIgMjAwIHNlY29uZHMgZWxhcHNlZCB0aW1lLCB5ZXQNCj4gPiA+ID4g
PiBDUFUxMCBuZXZlciBnZXRzIGNhbGxlZCwgd2hpY2ggd291bGQgaGF2ZSByZXN1bHRlZCBpbiBy
ZWR1Y2luZw0KPiA+ID4gPiA+IGl0J3MgcHN0YXRlIHJlcXVlc3QsIHVudGlsIGFuIGVsYXBzZWQg
dGltZSBvZiAxNjcuNjE2IHNlY29uZHMsDQo+ID4gPiA+ID4gMTI2IHNlY29uZHMgc2luY2UgdGhl
IGxhc3QgY2FsbC4gVGhlIENQVSBmcmVxdWVuY3kgbmV2ZXIgZG9lcyBnbyB0bw0KPiBtaW5pbXVt
Lg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gRm9yIHJlZmVyZW5jZSwgYSBzaW1pbGFyIENQVSBmcmVx
dWVuY3kgZ3JhcGggaXMgYWxzbyBhdHRhY2hlZCwNCj4gPiA+ID4gPiB3aXRoIHRoZSBjb21taXQg
cmV2ZXJ0ZWQuIFRoZSBDUFUgZnJlcXVlbmN5IGRyb3BzIHRvIG1pbmltdW0sDQo+ID4gPiA+ID4g
b3ZlciBhYm91dCAxMCBvciAxNSBzZWNvbmRzLiwNCj4gPiA+ID4NCj4gPiA+ID4gY29tbWl0IGI1
MGRiNzA5NWZlMCBlc3NlbnRpYWxseSBkaXNhYmxlcyB0aGUgY2xvY2tzb3VyY2Ugd2F0Y2hkb2cs
DQo+ID4gPiA+IHdoaWNoIGxpdGVyYWxseSBkb2Vzbid0IGhhdmUgbXVjaCB0byBkbyB3aXRoIGNw
dWZyZXEgY29kZS4NCj4gPiA+ID4NCj4gPiA+ID4gT25lIHRoaW5nIEkgY2FuIHRoaW5rIG9mIGlz
LCB3aXRob3V0IHRoZSBwYXRjaCwgdGhlcmUgaXMgYQ0KPiA+ID4gPiBwZXJpb2RpYyBjbG9ja3Nv
dXJjZSB0aW1lciBydW5uaW5nIGV2ZXJ5IDUwMCBtcywgYW5kIGl0IGxvb3BzIHRvDQo+ID4gPiA+
IHJ1biBvbiBhbGwgQ1BVcyBpbiB0dXJuLiBGb3IgeW91ciBIVywgaXQgaGFzIDEyIENQVXMgKGZy
b20gdGhlDQo+ID4gPiA+IGdyYXBoKSwgc28gZWFjaCBDUFUgd2lsbCBnZXQgYSB0aW1lciAoSFcg
dGltZXIgaW50ZXJydXB0IGJhY2tlZCkNCj4gPiA+ID4gZXZlcnkgNiBzZWNvbmRzLiBDb3VsZCB0
aGlzIGFmZmVjdCB0aGUgY3B1ZnJlcSBnb3Zlcm5vcidzIHdvcmsNCj4gPiA+ID4gZmxvdyAoSSBq
dXN0IHF1aWNrbHkgcmVhZCBzb21lIGNwdWZyZXEgY29kZSwgYW5kIHNlZW0gdGhlcmUgaXMNCj4g
PiA+ID4gaXJxX3dvcmsvd29ya3F1ZXVlIGludm9sdmVkKS4NCj4gPiA+DQo+ID4gPiA2IFNlY29u
ZHMgaXMgdGhlIGxvbmdlc3QgZHVyYXRpb24gSSBoYXZlIGV2ZXIgc2VlbiBvbiB0aGlzIHByb2Nl
c3Nvcg0KPiA+ID4gYmVmb3JlIGNvbW1pdCBiNTBkYjcwOTVmZTAuDQo+ID4gPg0KPiA+ID4gSSBz
YWlkICJ0aGUgdGltZXMgYmV0d2VlbiBjYWxscyB0byB0aGUgZHJpdmVyIGhhdmUgbmV2ZXIgZXhj
ZWVkZWQgMTANCj4gPiA+IHNlY29uZHMiIG9yaWdpbmFsbHksIGJ1dCB0aGF0IGludm9sdmVkIG90
aGVyIHByb2Nlc3NvcnMuDQo+ID4gPg0KPiA+ID4gSSBhbHNvIGRpZCBsb25nZXIsIDkwMDAgc2Vj
b25kIHRlc3RzOg0KPiA+ID4NCj4gPiA+IEZvciBhIHJldmVydGVkIGtlcm5lbCB0aGUgZHJpdmVy
IHdhcyBjYWxsZWQgMTMxLDc0MywgYW5kIDAgdGltZXMgdGhlDQo+ID4gPiBkdXJhdGlvbiB3YXMg
bG9uZ2VyIHRoYW4gNi4xIHNlY29uZHMuDQo+ID4gPg0KPiA+ID4gRm9yIGEgbm9uLXJldmVydGVk
IGtlcm5lbCB0aGUgZHJpdmVyIHdhcyBjYWxsZWQgMTEwLDI0MSB0aW1lcywgYW5kDQo+ID4gPiAx
Mzk3IHRpbWVzIHRoZSBkdXJhdGlvbiB3YXMgbG9uZ2VyIHRoYW4gNi4xIHNlY29uZHMsIGFuZCB0
aGUgbWF4aW11bQ0KPiA+ID4gZHVyYXRpb24gd2FzIDMwMy42IHNlY29uZHMNCj4gPg0KPiA+IFRo
YW5rcyBmb3IgdGhlIGRhdGEsIHdoaWNoIHNob3dzIGl0IGlzIHJlbGF0ZWQgdG8gdGhlIHJlbW92
YWwgb2YNCj4gPiBjbG9ja3NvdXJjZSB3YXRjaGRvZyB0aW1lcnMuIEFuZCB1bmRlciB0aGlzIHNw
ZWNpZmljIGNvbmZpZ3VyYXRpb25zLA0KPiA+IHRoZSBjcHVmcmVxIHdvcmsgZmxvdyBoYXMgc29t
ZSBkZXBlbmRlbmNlIG9uIHRoYXQgd2F0Y2hkb2cgdGltZXJzLg0KPiA+DQo+ID4gQWxzbyBjb3Vs
ZCB5b3Ugc2hhcmUgeW91IGtlcm5lbCBjb25maWcsIGJvb3QgbWVzc2FnZSBhbmQgc29tZSBzeXN0
ZW0NCj4gPiBzZXR0aW5ncyBsaWtlIGZvciB0aWNrbGVzcyBtb2RlLCBzbyB0aGF0IG90aGVyIHBl
b3BsZSBjYW4gdHJ5IHRvDQo+ID4gcmVwcm9kdWNlPyB0aGFua3MNCj4gDQo+IEkgc3RlYWwgdGhl
IGtlcm5lbCBjb25maWd1cmF0aW9uIGZpbGUgZnJvbSB0aGUgVWJ1bnR1IG1haW5saW5lIFBQQSBb
MV0sIHdoYXQNCj4gdGhleSBjYWxsICJsb3dsYXRlbmN5Iiwgb3IgMTAwMEh6IHRpY2suIEkgbWFr
ZSB0aGVzZSBjaGFuZ2VzIGJlZm9yZSBjb21waWxlOg0KPiANCj4gc2NyaXB0cy9jb25maWcgLS1k
aXNhYmxlIERFQlVHX0lORk8NCj4gc2NyaXB0cy9jb25maWcgLS1kaXNhYmxlIFNZU1RFTV9UUlVT
VEVEX0tFWVMgc2NyaXB0cy9jb25maWcgLS1kaXNhYmxlDQo+IFNZU1RFTV9SRVZPQ0FUSU9OX0tF
WVMNCj4gDQo+IEkgYWxzbyBzZW5kIHlvdSB0aGUgY29uZmlnIGFuZCBkbWVzZyBmaWxlcyBpbiBh
biBvZmYtbGlzdCBlbWFpbC4NCj4gDQo+IFRoaXMgaXMgYW4gaWRsZSwgYW5kIHZlcnkgbG93IHBl
cmlvZGljIGxvYWRzLCBzeXN0ZW0gdHlwZSB0ZXN0Lg0KPiBNeSB0ZXN0IGNvbXB1dGVyIGhhcyBu
byBHVUkgYW5kIHZlcnkgZmV3IHNlcnZpY2VzIHJ1bm5pbmcuDQo+IE5vdGljZSB0aGF0IEkgaGF2
ZSBub3QgdXNlZCB0aGUgd29yZCAicmVncmVzc2lvbiIgeWV0IGluIHRoaXMgdGhyZWFkLCBiZWNh
dXNlDQo+IEkgZG9uJ3Qga25vdyBmb3IgY2VydGFpbiB0aGF0IGl0IGlzLiBJbiB0aGUgZW5kLCB3
ZSBkb24ndCBjYXJlIGFib3V0IENQVQ0KPiBmcmVxdWVuY3ksIHdlIGNhcmUgYWJvdXQgd2FzdGlu
ZyBlbmVyZ3kuDQo+IEl0IGlzIGRlZmluaXRlbHkgYSBjaGFuZ2UsIGFuZCBJIGFtIGFibGUgdG8g
bWVhc3VyZSBzbWFsbCBpbmNyZWFzZXMgaW4gZW5lcmd5DQo+IHVzZSwgYnV0IHRoaXMgaXMgYWxs
IGF0IHRoZSBsb3cgZW5kIG9mIHRoZSBwb3dlciBjdXJ2ZS4NCg0KV2hhdCBkbyB5b3UgdXNlIHRv
IG1lYXN1cmUgdGhlIGVuZXJneSB1c2U/IEFuZCB3aGF0IGRpZmZlcmVuY2UgZG8geW91IG9ic2Vy
dmU/DQoNCj4gU28gZmFyIEkgaGF2ZSBub3QgZm91bmQgYSBzaWduaWZpY2FudCBleGFtcGxlIG9m
IGluY3JlYXNlZCBwb3dlciB1c2UsIGJ1dCBJDQo+IGFsc28gaGF2ZSBub3QgbG9va2VkIHZlcnkg
aGFyZC4NCj4gDQo+IER1cmluZyBhbnkgdGVzdCwgbWFueSBtb25pdG9yaW5nIHRvb2xzIG1pZ2h0
IHNob3J0ZW4gZHVyYXRpb25zLg0KPiBGb3IgZXhhbXBsZSBpZiBJIHJ1biB0dXJib3N0YXQsIHNh
eToNCj4gDQo+IHN1ZG8gdHVyYm9zdGF0IC0tU3VtbWFyeSAtLXF1aWV0IC0tc2hvdw0KPiBCdXN5
JSxCenlfTUh6LElSUSxQa2dXYXR0LFBrZ1RtcCxSQU1XYXR0LEdGWFdhdHQsQ29yV2F0dCAtLQ0K
PiBpbnRlcnZhbA0KPiAyLjUNCj4gDQo+IFdlbGwsIHllcyB0aGVuIHRoZSBtYXhpbXVtIGR1cmF0
aW9uIHdvdWxkIGJlIDIuNSBzZWNvbmRzLCBiZWNhdXNlDQo+IHR1cmJvc3RhdCB3YWtlcyB1cCBl
YWNoIENQVSB0byBpbnF1aXJlIGFib3V0IHRoaW5ncyBjYXVzaW5nIGEgY2FsbCB0byB0aGUgQ1BV
DQo+IHNjYWxpbmcgZHJpdmVyLiAoSSB0ZXN0ZWQgdGhpcywgZm9yIGFib3V0DQo+IDkwMCBzZWNv
bmRzLikNCj4gDQo+IEZvciBteSBwb3dlciB0ZXN0cyBJIHVzZSBhIHNhbXBsZSBpbnRlcnZhbCBv
ZiA+PSAzMDAgc2Vjb25kcy4NCg0KU28geW91IHVzZSBzb21ldGhpbmcgbGlrZSAidHVyYm9zdGF0
IHNsZWVwIDkwMCIgZm9yIHBvd2VyIHRlc3QsIGFuZCB0aGUgUkFQTCBFbmVyZ3kgY291bnRlcnMg
c2hvdyB0aGUgcG93ZXIgZGlmZmVyZW5jZT8NCkNhbiB5b3UgcGFzdGUgdGhlIHR1cmJvc3RhdCBv
dXRwdXQgYm90aCB3LyBhbmQgdy9vIHRoZSB3YXRjaGRvZz8NCg0KVGhhbmtzLA0KcnVpDQoNCj4g
Rm9yIGR1cmF0aW9uIG9ubHkgdGVzdHMsIHR1cmJvc3RhdCBpcyBub3QgcnVuIGF0IHRoZSBzYW1l
IHRpbWUuDQo+IA0KPiBNeSBncnViIGxpbmU6DQo+IA0KPiBHUlVCX0NNRExJTkVfTElOVVhfREVG
QVVMVD0iaXB2Ni5kaXNhYmxlPTEgY29uc29sZWJsYW5rPTMxNA0KPiBpbnRlbF9wc3RhdGU9YWN0
aXZlIGludGVsX3BzdGF0ZT1ub19od3AgbXNyLmFsbG93X3dyaXRlcz1vbg0KPiBjcHVpZGxlLmdv
dmVybm9yPXRlbyINCj4gDQo+IEEgdHlwaWNhbCBwc3RhdGUgdHJhY2VyIGNvbW1hbmQgKHdpdGgg
dGhlIHNjcmlwdCBjb3BpZWQgdG8gdGhlIGRpcmVjdG9yeQ0KPiB3aGVyZSBJIHJ1biB0aGlzIHN0
dWZmOik6DQo+IA0KPiBzdWRvIC4vaW50ZWxfcHN0YXRlX3RyYWNlci5weSAtLWludGVydmFsIDYw
MCAtLW5hbWUgdm5ldzAyIC0tbWVtb3J5DQo+IDgwMDAwMA0KPiANCj4gPg0KPiA+ID4gPiBDYW4g
eW91IHRyeSBvbmUgdGVzdCB0aGF0IGtlZXAgYWxsIHRoZSBjdXJyZW50IHNldHRpbmcgYW5kIGNo
YW5nZQ0KPiA+ID4gPiB0aGUgaXJxIGFmZmluaXR5IG9mIGRpc2svbmV0d29yay1jYXJkIHRvIDB4
ZmZmIHRvIGxldCBpbnRlcnJ1cHRzDQo+ID4gPiA+IGZyb20gdGhlbSBiZSBkaXN0cmlidXRlZCB0
byBhbGwgQ1BVcz8NCj4gPiA+DQo+ID4gPiBJIGFtIHdpbGxpbmcgdG8gZG8gdGhlIHRlc3QsIGJ1
dCBJIGRvIG5vdCBrbm93IGhvdyB0byBjaGFuZ2UgdGhlIGlycQ0KPiA+ID4gYWZmaW5pdHkuDQo+
ID4NCj4gPiBJIG1pZ2h0IHNheSB0aGF0IHRvbyBzb29uLiBJIHVzZWQgdG8gImVjaG8gZmZmID4g
L3Byb2MvaXJxL3h4eC9zbXBfYWZmaW5pdHkiDQo+ID4gKHh4IGlzIHRoZSBpcnEgbnVtYmVyIG9m
IGEgZGV2aWNlKSB0byBsZXQgaW50ZXJydXB0cyBiZSBkaXN0cmlidXRlZCB0bw0KPiA+IGFsbCBD
UFVzIGxvbmcgdGltZSBhZ28sIGJ1dCBpdCBkb2Vzbid0IHdvcmsgb24gbXkgMiBkZXNrdG9wcyBh
dCBoYW5kLg0KPiA+IFNlZW1zIGl0IG9ubHkgc3VwcG9ydCBvbmUtY3B1IGlycSBhZmZpbml0eSBp
biByZWNlbnQga2VybmVsLg0KPiA+DQo+ID4gWW91IGNhbiBzdGlsbCB0cnkgdGhhdCBjb21tYW5k
LCB0aG91Z2ggaXQgbWF5IG5vdCB3b3JrLg0KPiANCj4gSSBkaWQgbm90IHRyeSB0aGlzIHlldC4N
Cj4gDQo+IFsxXSBodHRwczovL2tlcm5lbC51YnVudHUuY29tL35rZXJuZWwtcHBhL21haW5saW5l
L3Y1LjE3LXJjMy8NCg==
