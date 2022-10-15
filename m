Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473385FFB33
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 18:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJOQ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 12:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJOQ3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 12:29:00 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0C9422EA
        for <stable@vger.kernel.org>; Sat, 15 Oct 2022 09:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665851339; x=1697387339;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=oDiCawRg51+QAw8bsktXLJLbv3mBGOVqPq8du2F4J3E=;
  b=vQhlfXW3Gn6Y3XPtoo8CHAMPHSmeXyeohM/9YeoMyQ6fmJKjNsLAKsoP
   FvERS+IRmH+lFdE6MbavYz37P6Hv/wkZJEGxOu8GHeUDp/kfxHCKLHOpp
   8nsNU438yncYSASGIaoujIZ8Lf1JIDfBbHGKf36YbwELFeJwj0xA38GDv
   4=;
X-IronPort-AV: E=Sophos;i="5.95,187,1661817600"; 
   d="scan'208";a="255771262"
Subject: Re: [PATCH 2/9] KVM: x86: Fix recording of guest steal time / preempted
 status
Thread-Topic: [PATCH 2/9] KVM: x86: Fix recording of guest steal time / preempted status
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-41c1ef8b.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2022 16:28:58 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-41c1ef8b.us-east-1.amazon.com (Postfix) with ESMTPS id 7C410160D68;
        Sat, 15 Oct 2022 16:28:57 +0000 (UTC)
Received: from EX19D008UEA001.ant.amazon.com (10.252.134.62) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 15 Oct 2022 16:28:56 +0000
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX19D008UEA001.ant.amazon.com (10.252.134.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Sat, 15 Oct 2022 16:28:56 +0000
Received: from EX19D002UWC004.ant.amazon.com ([fe80::f92f:5ec1:6ed3:7754]) by
 EX19D002UWC004.ant.amazon.com ([fe80::f92f:5ec1:6ed3:7754%4]) with mapi id
 15.02.1118.015; Sat, 15 Oct 2022 16:28:55 +0000
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     David Woodhouse <dwmw2@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Thread-Index: AQHY4BwRh9K4m0gtGkOkr+NtQqVpGa4O8oYAgAA+VwA=
Date:   Sat, 15 Oct 2022 16:28:55 +0000
Message-ID: <F4497C96-76E1-4421-976A-400581E8C32C@amazon.com>
References: <20221014222643.25815-1-risbhat@amazon.com>
 <20221014222643.25815-4-risbhat@amazon.com> <Y0pJCrVBEGNpFzNV@kroah.com>
In-Reply-To: <Y0pJCrVBEGNpFzNV@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.43.161.77]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3CF7B821097B24CB23E92481082F6FF@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

UGxlYXNlIGlnbm9yZS9kcm9wIHRoaXMgcGF0Y2ggc2VyaWVzLiBDQyBsaXN0IGV4cGFuZGVkIGZy
b20gcGF0Y2ggYnkgbWlzdGFrZS4NClBsYW5uaW5nIHRvIGdldCBzb21lIG1vcmUgcmV2aWV3cy90
ZXN0aW5nIGJlZm9yZSByZXNlbmRpbmcgaXQgbGF0ZXIuDQoNCu+7v09uIDEwLzE0LzIyLCAxMDo0
NSBQTSwgIkdyZWcgS0giIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQoNCiAg
ICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdh
bml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0K
DQoNCg0KICAgIE9uIEZyaSwgT2N0IDE0LCAyMDIyIGF0IDEwOjI2OjM2UE0gKzAwMDAsIFJpc2hh
YmggQmhhdG5hZ2FyIHdyb3RlOg0KICAgID4gRnJvbTogRGF2aWQgV29vZGhvdXNlIDxkd213MkBp
bmZyYWRlYWQub3JnPg0KICAgID4NCiAgICA+IGNvbW1pdCA3ZTIxNzVlYmQ2OTVmMTc4NjBjNWJk
NGFkNzYxNmNjZTEyZWQ0NTkxIHVwc3RyZWFtLg0KICAgID4NCiAgICA+IEluIGNvbW1pdCBiMDQz
MTM4MjQ2YTQgKCJ4ODYvS1ZNOiBNYWtlIHN1cmUgS1ZNX1ZDUFVfRkxVU0hfVExCIGZsYWcgaXMN
CiAgICA+IG5vdCBtaXNzZWQiKSB3ZSBzd2l0Y2hlZCB0byB1c2luZyBhIGdmbl90b19wZm5fY2Fj
aGUgZm9yIGFjY2Vzc2luZyB0aGUNCiAgICA+IGd1ZXN0IHN0ZWFsIHRpbWUgc3RydWN0dXJlIGlu
IG9yZGVyIHRvIGFsbG93IGZvciBhbiBhdG9taWMgeGNoZyBvZiB0aGUNCiAgICA+IHByZWVtcHRl
ZCBmaWVsZC4gVGhpcyBoYXMgYSBjb3VwbGUgb2YgcHJvYmxlbXMuDQogICAgPg0KICAgID4gRmly
c3RseSwga3ZtX21hcF9nZm4oKSBkb2Vzbid0IHdvcmsgYXQgYWxsIGZvciBJT01FTSBwYWdlcyB3
aGVuIHRoZQ0KICAgID4gYXRvbWljIGZsYWcgaXMgc2V0LCB3aGljaCBpdCBpcyBpbiBrdm1fc3Rl
YWxfdGltZV9zZXRfcHJlZW1wdGVkKCkuIFNvIGENCiAgICA+IGd1ZXN0IHZDUFUgdXNpbmcgYW4g
SU9NRU0gcGFnZSBmb3IgaXRzIHN0ZWFsIHRpbWUgd291bGQgbmV2ZXIgaGF2ZSBpdHMNCiAgICA+
IHByZWVtcHRlZCBmaWVsZCBzZXQuDQogICAgPg0KICAgID4gU2Vjb25kbHksIHRoZSBnZm5fdG9f
cGZuX2NhY2hlIGlzIG5vdCBpbnZhbGlkYXRlZCBpbiBhbGwgY2FzZXMgd2hlcmUgaXQNCiAgICA+
IHNob3VsZCBoYXZlIGJlZW4uIFRoZXJlIGFyZSB0d28gc3RhZ2VzIHRvIHRoZSBHRk4tPlBGTiBj
b252ZXJzaW9uOw0KICAgID4gZmlyc3QgdGhlIEdGTiBpcyBjb252ZXJ0ZWQgdG8gYSB1c2Vyc3Bh
Y2UgSFZBLCBhbmQgdGhlbiB0aGF0IEhWQSBpcw0KICAgID4gbG9va2VkIHVwIGluIHRoZSBwcm9j
ZXNzIHBhZ2UgdGFibGVzIHRvIGZpbmQgdGhlIHVuZGVybHlpbmcgaG9zdCBQRk4uDQogICAgPiBD
b3JyZWN0IGludmFsaWRhdGlvbiBvZiB0aGUgbGF0dGVyIHdvdWxkIHJlcXVpcmUgYmVpbmcgaG9v
a2VkIHVwIHRvIHRoZQ0KICAgID4gTU1VIG5vdGlmaWVycywgYnV0IHRoYXQgZG9lc24ndCBoYXBw
ZW4tLS1zbyBpdCBqdXN0IGtlZXBzIG1hcHBpbmcgYW5kDQogICAgPiB1bm1hcHBpbmcgdGhlICp3
cm9uZyogUEZOIGFmdGVyIHRoZSB1c2Vyc3BhY2UgcGFnZSB0YWJsZXMgY2hhbmdlLg0KICAgID4N
CiAgICA+IEluIHRoZSAhSU9NRU0gY2FzZSBhdCBsZWFzdCB0aGUgc3RhbGUgcGFnZSAqaXMqIHBp
bm5lZCBhbGwgdGhlIHRpbWUgaXQncw0KICAgID4gY2FjaGVkLCBzbyBpdCB3b24ndCBiZSBmcmVl
ZCBhbmQgcmV1c2VkIGJ5IGFueW9uZSBlbHNlIHdoaWxlIHN0aWxsDQogICAgPiByZWNlaXZpbmcg
dGhlIHN0ZWFsIHRpbWUgdXBkYXRlcy4gVGhlIG1hcC91bm1hcCBkYW5jZSBvbmx5IHRha2VzIGNh
cmUNCiAgICA+IG9mIHRoZSBLVk0gYWRtaW5pc3RyaXZpYSBzdWNoIGFzIG1hcmtpbmcgdGhlIHBh
Z2UgZGlydHkuDQogICAgPg0KICAgID4gVW50aWwgdGhlIGdmbl90b19wZm4gY2FjaGUgaGFuZGxl
cyB0aGUgcmVtYXBwaW5nIGF1dG9tYXRpY2FsbHkgYnkNCiAgICA+IGludGVncmF0aW5nIHdpdGgg
dGhlIE1NVSBub3RpZmllcnMsIHdlIG1pZ2h0IGFzIHdlbGwgbm90IGdldCBhDQogICAgPiBrZXJu
ZWwgbWFwcGluZyBvZiBpdCwgYW5kIHVzZSB0aGUgcGVyZmVjdGx5IHNlcnZpY2VhYmxlIHVzZXJz
cGFjZSBIVkENCiAgICA+IHRoYXQgd2UgYWxyZWFkeSBoYXZlLiAgV2UganVzdCBuZWVkIHRvIGlt
cGxlbWVudCB0aGUgYXRvbWljIHhjaGcgb24NCiAgICA+IHRoZSB1c2Vyc3BhY2UgYWRkcmVzcyB3
aXRoIGFwcHJvcHJpYXRlIGV4Y2VwdGlvbiBoYW5kbGluZywgd2hpY2ggaXMNCiAgICA+IGZhaXJs
eSB0cml2aWFsLg0KICAgID4NCiAgICA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQogICAg
PiBGaXhlczogYjA0MzEzODI0NmE0ICgieDg2L0tWTTogTWFrZSBzdXJlIEtWTV9WQ1BVX0ZMVVNI
X1RMQiBmbGFnIGlzIG5vdCBtaXNzZWQiKQ0KICAgID4gU2lnbmVkLW9mZi1ieTogRGF2aWQgV29v
ZGhvdXNlIDxkd213QGFtYXpvbi5jby51az4NCiAgICA+IE1lc3NhZ2UtSWQ6IDwzNjQ1YjliODg5
ZGFjNjQzODM5NDE5NGJiNTU4NmE0NmI2OGQ1ODFmLmNhbWVsQGluZnJhZGVhZC5vcmc+DQogICAg
PiBbSSBkaWRuJ3QgZW50aXJlbHkgYWdyZWUgd2l0aCBEYXZpZCdzIGFzc2Vzc21lbnQgb2YgdGhl
DQogICAgPiAgdXNlZnVsbmVzcyBvZiB0aGUgZ2ZuX3RvX3BmbiBjYWNoZSwgYW5kIGludGVncmF0
ZWQgdGhlIG91dGNvbWUNCiAgICA+ICBvZiB0aGUgZGlzY3Vzc2lvbiBpbiB0aGUgYWJvdmUgY29t
bWl0IG1lc3NhZ2UuIC0gUGFvbG9dDQogICAgPiBTaWduZWQtb2ZmLWJ5OiBQYW9sbyBCb256aW5p
IDxwYm9uemluaUByZWRoYXQuY29tPg0KICAgID4gW3Jpc2JoYXRAYW1hem9uLmNvbTogVXNlIHRo
ZSBvbGRlciBtYXJrX3BhZ2VfZGlydHlfaW5fc2xvdCBhcGkgd2l0aG91dA0KICAgID4ga3ZtIGFy
Z3VtZW50XQ0KICAgID4gU2lnbmVkLW9mZi1ieTogUmlzaGFiaCBCaGF0bmFnYXIgPHJpc2JoYXRA
YW1hem9uLmNvbT4NCiAgICA+IC0tLQ0KICAgID4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9o
b3N0LmggfCAgIDIgKy0NCiAgICA+ICBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgIHwg
MTA1ICsrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQogICAgPiAgMiBmaWxlcyBjaGFu
Z2VkLCA3NiBpbnNlcnRpb25zKCspLCAzMSBkZWxldGlvbnMoLSkNCg0KICAgIFRoaXMgaXMgYWxy
ZWFkeSBpbiBzb21lIHN0YWJsZSBrZXJuZWxzLCB3aHkgc2VuZCBpdCBhZ2FpbiBhbmQgd2hhdA0K
ICAgIHRyZWUocykgYXJlIHlvdSBhc2tpbmcgZm9yIGl0IHRvIGJlIGFwcGxpZWQgdG8/DQoNCiAg
ICBTYW1lIGZvciB0aGUgb3RoZXIgYmFja3BvcnRzIHlvdSBzZW50Lg0KDQogICAgY29uZnVzZWQs
DQoNCiAgICBncmVnIGstaA0KDQo=
