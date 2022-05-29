Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57962537106
	for <lists+stable@lfdr.de>; Sun, 29 May 2022 14:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiE2M6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 May 2022 08:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiE2M6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 May 2022 08:58:06 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA744163F
        for <stable@vger.kernel.org>; Sun, 29 May 2022 05:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1653829082; x=1685365082;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=qpu4ngyG8MeKahG9GUq5VVWW9Ff3+dXr4msUpuoX0Wo=;
  b=VVVe7MGjrp6k/43XKOTRKxwjqhEwsEahT3+3QnkLBPaYatnmMhAl03s5
   BlwvNM3JewZOsuzZ4hQ+fwJDsTKykU5FjFvmFdjnHiSJAt1W7nOQfYMOu
   JiTpxZ6xD6oVBUBD4d2C+um517oYDGZN5XqG/Jp1Zl/kG+H2NxgJZhcay
   0=;
X-IronPort-AV: E=Sophos;i="5.91,260,1647302400"; 
   d="scan'208";a="92959821"
Subject: Re: [PATCH] nfsd: destroy percpu stats counters after reply cache #5.11.0-rc5
Thread-Topic: [PATCH] nfsd: destroy percpu stats counters after reply cache #5.11.0-rc5
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 29 May 2022 12:58:01 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id A1ACF42768;
        Sun, 29 May 2022 12:58:01 +0000 (UTC)
Received: from EX13D01UWA004.ant.amazon.com (10.43.160.99) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 29 May 2022 12:58:00 +0000
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13d01UWA004.ant.amazon.com (10.43.160.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 29 May 2022 12:57:59 +0000
Received: from EX13D01UWA002.ant.amazon.com ([10.43.160.74]) by
 EX13d01UWA002.ant.amazon.com ([10.43.160.74]) with mapi id 15.00.1497.036;
 Sun, 29 May 2022 12:57:59 +0000
From:   "Schroeder, Julian" <jumaco@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Thread-Index: AQHYcPmYYwP7PR5610ygZphXVCOQwK0z+5gAgABaXgCAASu1AA==
Date:   Sun, 29 May 2022 12:57:59 +0000
Message-ID: <D8BE70AD-BD25-44A9-B1D7-D1CEC20461E9@amazon.com>
References: <20220523211152.GB23843@dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com>
 <Yo9t7Whg/XGa/jmb@kroah.com>
 <15AC3FF9-F74D-4C08-ADF4-8A1E14BE811F@amazon.com>
 <YpIsHLKZbeSENvaZ@kroah.com>
In-Reply-To: <YpIsHLKZbeSENvaZ@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.125]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0555020D3D5E2245A3C9BD7C5ACEE5E0@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-12.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pj4gPj4gRnJvbTogSnVsaWFuIFNjaHJvZWRlciA8anVtYWNvQGFtYXpvbi5jb20+DQo+PiA+PiBE
YXRlOiBGcmksIDIwIE1heSAyMDIyIDE4OjMzOjI3ICswMDAwDQo+PiA+PiBTdWJqZWN0OiBbUEFU
Q0hdIG5mc2Q6IGRlc3Ryb3kgcGVyY3B1IHN0YXRzIGNvdW50ZXJzIGFmdGVyIHJlcGx5IGNhY2hl
DQo+PiA+PiAgc2h1dGRvd24NCj4+ID4+IE1JTUUtVmVyc2lvbjogMS4wDQo+PiA+PiBDb250ZW50
LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgNCj4+ID4+IENvbnRlbnQtVHJhbnNmZXIt
RW5jb2Rpbmc6IDhiaXQNCj4+ID4+IFVwb24gbmZzZCBzaHV0ZG93biBhbnkgcGVuZGluZyBEUkMg
Y2FjaGUgaXMgZnJlZWQuIERSQyBjYWNoZSB1c2UgaXMNCj4+ID4+IHRyYWNrZWQgdmlhIGEgcGVy
Y3B1IGNvdW50ZXIuIEluIHRoZSBjdXJyZW50IGNvZGUgdGhlIHBlcmNwdSBjb3VudGVyDQo+PiA+
PiBpcyBkZXN0cm95ZWQgYmVmb3JlLiBJZiBhbnkgcGVuZGluZyBjYWNoZSBpcyBzdGlsbCBwcmVz
ZW50LA0KPj4gPj4gcGVyY3B1X2NvdW50ZXJfYWRkIGlzIGNhbGxlZCB3aXRoIGEgcGVyY3B1IGNv
dW50ZXI9PU5VTEwuIFRoaXMgY2F1c2VzDQo+PiA+PiBhIGtlcm5lbCBjcmFzaC4NCj4+ID4+IFRo
ZSBzb2x1dGlvbiBpcyB0byBkZXN0cm95IHRoZSBwZXJjcHUgY291bnRlciBhZnRlciB0aGUgY2Fj
aGUgaXMgZnJlZWQuDQo+PiA+PiBGaXhlczogZTU2N2I5OGNlOWE0YiAow6JFVVJvZW5mc2Q6IHBy
b3RlY3QgY29uY3VycmVudCBhY2Nlc3MgdG8gbmZzZCBzdGF0cyBjb3VudGVyc8OiRVVSwp0pDQo+
PiA+PiBTaWduZWQtb2ZmLWJ5OiBKdWxpYW4gU2Nocm9lZGVyIDxqdW1hY29AYW1hem9uLmNvbT4N
Cj4+ID4+IC0tLQ0KPj4gPj4gIGZzL25mc2QvbmZzY2FjaGUuYyB8IDIgKy0NCj4+ID4+ICAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4+ID4+IGRpZmYgLS1n
aXQgYS9mcy9uZnNkL25mc2NhY2hlLmMgYi9mcy9uZnNkL25mc2NhY2hlLmMNCj4+ID4+IGluZGV4
IDBiM2YxMmFhMzdmZi4uN2RhODhiZGMwZDZjIDEwMDY0NA0KPj4gPj4gLS0tIGEvZnMvbmZzZC9u
ZnNjYWNoZS5jDQo+PiA+PiArKysgYi9mcy9uZnNkL25mc2NhY2hlLmMNCj4+ID4+IEBAIC0yMDYs
NyArMjA2LDYgQEAgdm9pZCBuZnNkX3JlcGx5X2NhY2hlX3NodXRkb3duKHN0cnVjdCBuZnNkX25l
dCAqbm4pDQo+PiA+PiAgICAgICAgIHN0cnVjdCBzdmNfY2FjaGVyZXAgICAgICpycDsNCj4+ID4+
ICAgICAgICAgdW5zaWduZWQgaW50IGk7DQo+PiA+Pg0KPj4gPj4gLSAgICAgICBuZnNkX3JlcGx5
X2NhY2hlX3N0YXRzX2Rlc3Ryb3kobm4pOw0KPj4gPj4gICAgICAgICB1bnJlZ2lzdGVyX3Nocmlu
a2VyKCZubi0+bmZzZF9yZXBseV9jYWNoZV9zaHJpbmtlcik7DQo+PiA+Pg0KPj4gPj4gICAgICAg
ICBmb3IgKGkgPSAwOyBpIDwgbm4tPmRyY19oYXNoc2l6ZTsgaSsrKSB7DQo+PiA+PiBAQCAtMjE3
LDYgKzIxNiw3IEBAIHZvaWQgbmZzZF9yZXBseV9jYWNoZV9zaHV0ZG93bihzdHJ1Y3QgbmZzZF9u
ZXQgKm5uKQ0KPj4gPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcnAsIG5uKTsNCj4+ID4+ICAgICAgICAgICAg
ICAgICB9DQo+PiA+PiAgICAgICAgIH0NCj4+ID4+ICsgICAgICAgbmZzZF9yZXBseV9jYWNoZV9z
dGF0c19kZXN0cm95KG5uKTsNCj4+ID4+DQo+PiA+PiAgICAgICAgIGt2ZnJlZShubi0+ZHJjX2hh
c2h0YmwpOw0KPj4gPj4gICAgICAgICBubi0+ZHJjX2hhc2h0YmwgPSBOVUxMOw0KPj4gPj4gLS0N
Cj4+ID4+IDIuMzIuMA0KPj4gPj4NCj4+DQo+PiA+V2hhdCBpcyB0aGUgZ2l0IGNvbW1pdCBpZCBv
ZiB0aGlzIGluIExpbnVzJ3MgdHJlZT8NCj4+DQo+PiA+QW5kIHRoaXMgcGF0Y2ggaXMgdG90YWxs
eSBkYW1hZ2VkIHdpdGggd2hpdGVzcGFjZSBhbmQgY2FuIG5vdCBiZSBhcHBsaWVkDQo+PiA+YXQg
YWxsIDooDQo+Pg0KPj4gPlBsZWFzZSBmaXggaXQgdXAgYW5kIHN1Ym1pdCBpdCBhZ2Fpbi4NCj4+
DQo+PiA+dGhhbmtzLA0KPj4NCj4+ID5ncmVnIGstaA0KPj4NCj4+IFRoZSBwYXRjaCBtYWRlIGl0
IGludG8gbGludXggbmV4dC4gY29tbWl0IGZkNWUzNjNlYWM3N2UuDQo+PiBJIHNlbnQgdGhlIHBh
dGNoIHRvIHN0YWJsZSBhZ2FpbiB2aWEgZ2l0IHNlbmQtZW1haWwgKGh0dHBzOi8vd3d3LnNwaW5p
Y3MubmV0L2xpc3RzL3N0YWJsZS9tc2c1NjA4MTguaHRtbCkNCj4NCj48Zm9ybWxldHRlcj4NCj4N
Cj5UaGlzIGlzIG5vdCB0aGUgY29ycmVjdCB3YXkgdG8gc3VibWl0IHBhdGNoZXMgZm9yIGluY2x1
c2lvbiBpbiB0aGUNCj5zdGFibGUga2VybmVsIHRyZWUuICBQbGVhc2UgcmVhZDoNCj4gICAgaHR0
cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3QvcHJvY2Vzcy9zdGFibGUta2VybmVs
LXJ1bGVzLmh0bWwNCj5mb3IgaG93IHRvIGRvIHRoaXMgcHJvcGVybHkuDQo+DQo+PC9mb3JtbGV0
dGVyPg0KVXBvbiBuZnNkIHNodXRkb3duIGFueSBwZW5kaW5nIERSQyBjYWNoZSBpcyBmcmVlZC4g
RFJDIGNhY2hlIHVzZSBpcw0KdHJhY2tlZCB2aWEgYSBwZXJjcHUgY291bnRlci4gSW4gdGhlIGN1
cnJlbnQgY29kZSB0aGUgcGVyY3B1IGNvdW50ZXINCmlzIGRlc3Ryb3llZCBiZWZvcmUuIElmIGFu
eSBwZW5kaW5nIGNhY2hlIGlzIHN0aWxsIHByZXNlbnQsDQpwZXJjcHVfY291bnRlcl9hZGQgaXMg
Y2FsbGVkIHdpdGggYSBwZXJjcHUgY291bnRlcj09TlVMTC4gVGhpcyBjYXVzZXMNCmEga2VybmVs
IGNyYXNoLg0KVGhlIHNvbHV0aW9uIGlzIHRvIGRlc3Ryb3kgdGhlIHBlcmNwdSBjb3VudGVyIGFm
dGVyIHRoZSBjYWNoZSBpcyBmcmVlZC4NCg0KRml4ZXM6IGU1NjdiOThjZTlhNGIgKOKAnG5mc2Q6
IHByb3RlY3QgY29uY3VycmVudCBhY2Nlc3MgdG8gbmZzZCBzdGF0cyBjb3VudGVyc+KAnSkNClNp
Z25lZC1vZmYtYnk6IEp1bGlhbiBTY2hyb2VkZXIgPGp1bWFjb0B4eHh4eHh4eHh4Pg0KLS0tDQog
ZnMvbmZzZC9uZnNjYWNoZS5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZnMvbmZzZC9uZnNjYWNoZS5jIGIvZnMv
bmZzZC9uZnNjYWNoZS5jDQppbmRleCAwYjNmMTJhYTM3ZmYuLjdkYTg4YmRjMGQ2YyAxMDA2NDQN
Ci0tLSBhL2ZzL25mc2QvbmZzY2FjaGUuYw0KKysrIGIvZnMvbmZzZC9uZnNjYWNoZS5jDQpAQCAt
MjA2LDcgKzIwNiw2IEBAIHZvaWQgbmZzZF9yZXBseV9jYWNoZV9zaHV0ZG93bihzdHJ1Y3QgbmZz
ZF9uZXQgKm5uKQ0KIAlzdHJ1Y3Qgc3ZjX2NhY2hlcmVwCSpycDsNCiAJdW5zaWduZWQgaW50IGk7
DQogDQotCW5mc2RfcmVwbHlfY2FjaGVfc3RhdHNfZGVzdHJveShubik7DQogCXVucmVnaXN0ZXJf
c2hyaW5rZXIoJm5uLT5uZnNkX3JlcGx5X2NhY2hlX3Nocmlua2VyKTsNCiANCiAJZm9yIChpID0g
MDsgaSA8IG5uLT5kcmNfaGFzaHNpemU7IGkrKykgew0KQEAgLTIxNyw2ICsyMTYsNyBAQCB2b2lk
IG5mc2RfcmVwbHlfY2FjaGVfc2h1dGRvd24oc3RydWN0IG5mc2RfbmV0ICpubikNCiAJCQkJCQkJ
CQlycCwgbm4pOw0KIAkJfQ0KIAl9DQorCW5mc2RfcmVwbHlfY2FjaGVfc3RhdHNfZGVzdHJveShu
bik7DQogDQogCWt2ZnJlZShubi0+ZHJjX2hhc2h0YmwpOw0KIAlubi0+ZHJjX2hhc2h0YmwgPSBO
VUxMOw0KLS0gDQoyLjMyLjANCg0KDQoNCg==
