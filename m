Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B121173E1
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 19:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfLISRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 13:17:04 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:60923 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfLISRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 13:17:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1575915423; x=1607451423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=ZsrJIfoheFM0e6F9jrbre1s0mUeRj/O7QTO1xJ/UMO0=;
  b=HzQkCsPqKQeA75YOmgN2gAX2lffC8iYib7XXd6GgP0O37FBKHDZSq7qP
   mWK1Bz/cuV5skKCVOZbs1KbV550Vo/YNx2ClxGyZAllitIyvEBrvjhVOy
   pEqnxRVv5xo6KkM6h7fUFleyxPFJV1zFQEHGKVwM7/fe8JQvtZ3Rsib+Q
   Y=;
IronPort-SDR: poYUXFAkYxlfuxAnK/437nmg01EYPxWrILmlUmy/1mStT19yQh0SaonRiNNUZwlBfBCFPMSKUa
 IUt1f4Mn2iFQ==
X-IronPort-AV: E=Sophos;i="5.69,296,1571702400"; 
   d="scan'208";a="8301554"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 09 Dec 2019 18:17:00 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 55387A1DF4;
        Mon,  9 Dec 2019 18:16:58 +0000 (UTC)
Received: from EX13D01EUB001.ant.amazon.com (10.43.166.194) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 9 Dec 2019 18:16:57 +0000
Received: from EX13D07EUB004.ant.amazon.com (10.43.166.234) by
 EX13D01EUB001.ant.amazon.com (10.43.166.194) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 9 Dec 2019 18:16:56 +0000
Received: from EX13D07EUB004.ant.amazon.com ([10.43.166.234]) by
 EX13D07EUB004.ant.amazon.com ([10.43.166.234]) with mapi id 15.00.1367.000;
 Mon, 9 Dec 2019 18:16:56 +0000
From:   "Nuernberger, Stefan" <snu@amazon.de>
To:     "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Seidel, Conny" <consei@amazon.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "ross.lagerwall@citrix.com" <ross.lagerwall@citrix.com>,
        "Dannowski, Uwe" <uwed@amazon.de>
Subject: Re: [PATCH] xen/pciback: Prevent NULL pointer dereference in
 quirks_show
Thread-Topic: [PATCH] xen/pciback: Prevent NULL pointer dereference in
 quirks_show
Thread-Index: AQHVrDvmewMicN/JcUO9mDMvMIw7UKetNk+AgAAx6YCAACMwAIAElc4A
Date:   Mon, 9 Dec 2019 18:16:56 +0000
Message-ID: <1575915416.21160.49.camel@amazon.de>
References: <20191206134804.4537-1-snu@amazon.com>
         <9917a357-12f6-107f-e08d-33e464036317@oracle.com>
         <1575655787.7257.42.camel@amazon.de>
         <4bc83b82-427f-2215-3161-5776867675a1@oracle.com>
In-Reply-To: <4bc83b82-427f-2215-3161-5776867675a1@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.171]
Content-Type: text/plain; charset="utf-8"
Content-ID: <93A5DB49B5DE764399A41F55F536FE14@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDE5LTEyLTA2IGF0IDE1OjE1IC0wNTAwLCBCb3JpcyBPc3Ryb3Zza3kgd3JvdGU6
DQo+IE9uIDEyLzYvMTkgMTowOSBQTSwgTnVlcm5iZXJnZXIsIFN0ZWZhbiB3cm90ZToNCj4gPiAN
Cj4gPiBPbiBGcmksIDIwMTktMTItMDYgYXQgMTA6MTEgLTA1MDAsIEJvcmlzIE9zdHJvdnNreSB3
cm90ZToNCj4gPiA+IA0KPiA+ID4gT24gMTIvNi8xOSA4OjQ4IEFNLCBTdGVmYW4gTnVlcm5iZXJn
ZXIgd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiBGcm9tOiBVd2UgRGFubm93c2tpIDx1d2VkQGFt
YXpvbi5kZT4NCj4gPiA+ID4gwqANCj4gPiA+ID4gwqAJCWxpc3RfZm9yX2VhY2hfZW50cnkoY2Zn
X2VudHJ5LCAmZGV2X2RhdGEtDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gY29uZmlnX2ZpZWxkcywg
bGlzdCkgew0KPiA+ID4gQ291bGRuJ3QgeW91IGhhdmUgdGhlIHNhbWUgcmFjZSBoZXJlPw0KPiA+
IE5vdCBxdWl0ZSB0aGUgc2FtZSwgYnV0IGl0IG1pZ2h0IG5vdCBiZSBlbnRpcmVseSBzYWZlIHll
dC4gVGhlDQo+ID4gJ3F1aXJrc19zaG93JyB0YWtlcyB0aGUgJ2RldmljZV9pZHNfbG9jaycgYW5k
IHJhY2VzIHdpdGggdW5iaW5kIC8NCj4gPiAncGNpc3R1Yl9kZXZpY2VfcmVsZWFzZScgIndoaWNo
IHRha2VzIGRldmljZV9sb2NrIG11dGV4Ii4gU28gdGhpcw0KPiA+IG1pZ2h0DQo+ID4gbm93IGJl
IGEgVUFGIHJlYWQgYWNjZXNzIGluc3RlYWQgb2YgYSBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Uu
DQo+IFllcywgdGhhdCdzIHdoYXQgSSBtZWFudCAoYWx0aG91Z2ggSSBkb24ndCBzZWUgbXVjaCBk
aWZmZXJlbmNlIGluDQo+IHRoaXMNCj4gY29udGV4dCkuDQoNCldlbGwsIHRoZSBOVUxMIHB0ciBh
Y2Nlc3MgY2F1c2VzIGFuIGluc3RhbnQga2VybmVsIHBhbmljIHdoZXJlYXMgd2UNCmhhdmUgbm90
IGF0dHJpYnV0ZWQgY3Jhc2hlcyB0byB0aGUgcG9zc2libGUgVUFGIHJlYWQgdW50aWwgbm93Lg0K
DQo+ID4gDQo+ID4gwqBXZSBoYXZlDQo+ID4gbm90IG9ic2VydmVkIGFkdmVyc2FyaWFsIGVmZmVj
dHMgaW4gb3VyIHRlc3RpbmcgKGNvbXBhcmVkIHRvIHRoZQ0KPiA+IG9idmlvdXMgaXNzdWVzIHdp
dGggTlVMTCBwb2ludGVyKSBidXQgdGhhdCdzIG5vdCBhIGd1YXJhbnRlZSBvZg0KPiA+IGNvdXJz
ZS4NCj4gPiANCj4gPiBTbyBzaG91bGQgcXVpcmtzX3Nob3cgYWN0dWFsbHkgYmUgcHJvdGVjdGVk
IGJ5IHBjaXN0dWJfZGV2aWNlc19sb2NrDQo+ID4gaW5zdGVhZCBhcyBhcmUgb3RoZXIgZnVuY3Rp
b25zIHRoYXQgYWNjZXNzIGRldl9kYXRhPyBEb2VzIGl0IG5lZWQNCj4gPiBib3RoDQo+ID4gbG9j
a3MgaW4gdGhhdCBjYXNlPw0KPiBkZXZpY2VfaWRzX2xvY2sgcHJvdGVjdHMgZGV2aWNlX2lkcyBs
aXN0LCB3aGljaCBpcyBub3Qgd2hhdCB5b3UgYXJlDQo+IHRyeWluZyB0byBhY2Nlc3MsIHNvIHRo
YXQgZG9lc24ndCBsb29rIGxpa2UgcmlnaHQgbG9jayB0byBob2xkLiBBbmQNCj4gQUZBSUNUIHBj
aXN0dWJfZGV2aWNlc19sb2NrIGlzIG5vdCBoZWxkIHdoZW4gZGV2aWNlIGRhdGEgaXMgY2xlYXJl
ZA0KPiBpbg0KPiBwY2lzdHViX2RldmljZV9yZWxlYXNlKCkgKHdoaWNoIEkgdGhpbmsgaXMgd2hl
cmUgd2UgYXJlIHJhY2luZykuDQoNCkluZGVlZC4gVGhlIHhlbl9wY2lia19xdWlya3MgbGlzdCBk
b2VzIG5vdCBoYXZlIGEgc2VwYXJhdGUgbG9jayB0bw0KcHJvdGVjdCBpdC4gSXQncyBlaXRoZXIg
bW9kaWZpZWQgdW5kZXIgJ3BjaXN0dWJfZGV2aWNlc19sb2NrJywgZnJvbQ0KcGNpc3R1Yl9yZW1v
dmUoKSwgb3IgaXRlcmF0ZWQgb3ZlciB3aXRoIHRoZSAnZGV2aWNlX2lkc19sb2NrJyBoZWxkIGlu
DQpxdWlya3Nfc2hvdygpLiBBbHNvIHRoZSBxdWlya3MgbGlzdCBpcyBhbWVuZGVkIGZyb20NCsKg
IHBjaXN0dWJfaW5pdF9kZXZpY2UoKQ0KwqAgwqAgLT4geGVuX3BjaWJrX2NvbmZpZ19pbml0X2Rl
digpDQrCoCDCoCDCoCAtPiB4ZW5fcGNpYmtfY29uZmlnX3F1aXJrc19pbml0KCkNCndpdGhvdXQg
aG9sZGluZyBhbnkgbG9jayBhdCBhbGwuIEluIGZhY3QgdGhlDQpwY2lzdHViX2luaXRfZGV2aWNl
c19sYXRlKCkgYW5kIHBjaXN0dWJfc2VpemUoKSBmdW5jdGlvbnMgZGVsaWJlcmF0ZWx5DQpyZWxl
YXNlIHRoZSBwY2lzdHViX2RldmljZXNfbG9jayBiZWZvcmUgY2FsbGluZyBwY2lzdHViX2luaXRf
ZGV2aWNlKCkuDQpUaGlzIGxvb2tzIGJyb2tlbi4NCg0KVGhlIHJhY2UgaXMgYmV0d2Vlbg0KwqAg
cGNpc3R1Yl9yZW1vdmUoKQ0KwqAgwqAgLT4gcGNpc3R1Yl9kZXZpY2VfcHV0KCkNCsKgIMKgIMKg
IC0+IHBjaXN0dWJfZGV2aWNlX3JlbGVhc2UoKQ0Kb24gb25lIHNpZGUgYW5kIHRoZSBxdWlya3Nf
c2hvdygpIG9uIHRoZSBvdGhlciBzaWRlLiBUaGUgcHJvYmxlbWF0aWMNCnF1aXJrIGlzIGZyZWVk
IGZyb20gdGhlIHhlbl9wY2lia19xdWlya3MgbGlzdCBpbiBwY2lzdHViX3JlbW92ZSgpIGVhcmx5
DQpvbiB1bmRlciBwY2lzdHViX2RldmljZXNfbG9jayBiZWZvcmUgdGhlIGFzc29jaWF0ZWQgZGV2
X2RhdGEgaXMgZnJlZWQNCmV2ZW50dWFsbHkuIFNvIHN3aXRjaGluZyBmcm9tIGRldmljZV9pZHNf
bG9jayB0byBwY2lzdHViX2RldmljZXNfbG9jaw0KaW4gcXVpcmtzX3Nob3coKSBjb3VsZCBiZSBz
dWZmaWNpZW50IHRvIGFsd2F5cyBoYXZlIHZhbGlkIGRldl9kYXRhIGZvcg0KYWxsIHF1aXJrcyBp
biB0aGUgbGlzdC4NCg0KVGhlcmUgaXMgYWxzbyBwY2lzdHViX3B1dF9wY2lfZGV2KCkgcG9zc2li
bHkgaW4gdGhlIHJhY2UsIGNhbGxlZCBmcm9tDQp4ZW5fcGNpYmtfcmVtb3ZlX2RldmljZSgpLCBv
ciB4ZW5fcGNpYmtfeGVuYnVzX3JlbW92ZSgpLCBvcg0KcGNpc3R1Yl9yZW1vdmUoKS4gVGhlIHBj
aXN0dWJfcmVtb3ZlKCkgY2FsbCBzaXRlIGlzIHNhZmUgd2hlbiB3ZSBzd2l0Y2gNCnRvIHBjaXN0
dWJfZGV2aWNlc19sb2NrIChzYW1lIHJlYXNvbmluZyBhcyBhYm92ZSkuIEZvciB0aGUgb3RoZXJz
IEkNCmN1cnJlbnRseSBkbyBub3Qgc2VlIHdoZW4gdGhlIHF1aXJrcyBhcmUgZXZlciBmcmVlZD8N
Cg0KLSBTdGVmYW4NCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICkty
YXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBT
Y2hsYWVnZXIsIFJhbGYgSGVyYnJpY2gKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxv
dHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAy
MzcgODc5CgoK

