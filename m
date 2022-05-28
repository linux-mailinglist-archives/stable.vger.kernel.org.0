Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E37B536D26
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 15:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbiE1Nl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 09:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236121AbiE1Nlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 09:41:55 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE941B7BC
        for <stable@vger.kernel.org>; Sat, 28 May 2022 06:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1653745315; x=1685281315;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=aKRoLkVq2PiKFrTDag/1L+Dz/QeOgb1huiiHxqqKc3k=;
  b=juPMzDAQIYmhT8U3obu67Izzz2Cjg+YyNKLsY+8dsVVRnEv6jyfHCt4/
   xqcQ8/uWPIHFTzCdt7S+gFt9RI4GFW+3IxQELwafYJ1KCfYcbz+OqGz38
   59kADDAZdaa5J4frMrsyA+JbeapcBsjCUh+hMcXGeWf3gRZ+XoH48D0Xp
   c=;
X-IronPort-AV: E=Sophos;i="5.91,258,1647302400"; 
   d="scan'208";a="202717610"
Subject: Re: [PATCH] nfsd: destroy percpu stats counters after reply cache #5.11.0-rc5
Thread-Topic: [PATCH] nfsd: destroy percpu stats counters after reply cache #5.11.0-rc5
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 28 May 2022 13:41:53 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id 2B43942653;
        Sat, 28 May 2022 13:41:52 +0000 (UTC)
Received: from EX13D01UWA001.ant.amazon.com (10.43.160.60) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sat, 28 May 2022 13:41:52 +0000
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13d01UWA001.ant.amazon.com (10.43.160.60) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sat, 28 May 2022 13:41:51 +0000
Received: from EX13D01UWA002.ant.amazon.com ([10.43.160.74]) by
 EX13d01UWA002.ant.amazon.com ([10.43.160.74]) with mapi id 15.00.1497.036;
 Sat, 28 May 2022 13:41:51 +0000
From:   "Schroeder, Julian" <jumaco@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Thread-Index: AQHYcPmYYwP7PR5610ygZphXVCOQwK0z+5gA
Date:   Sat, 28 May 2022 13:41:51 +0000
Message-ID: <15AC3FF9-F74D-4C08-ADF4-8A1E14BE811F@amazon.com>
References: <20220523211152.GB23843@dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com>
 <Yo9t7Whg/XGa/jmb@kroah.com>
In-Reply-To: <Yo9t7Whg/XGa/jmb@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.203]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D52D8A8E37378E4DBE6F4C23FF8C6C91@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-12.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pj4gRnJvbTogSnVsaWFuIFNjaHJvZWRlciA8anVtYWNvQGFtYXpvbi5jb20+DQo+PiBEYXRlOiBG
cmksIDIwIE1heSAyMDIyIDE4OjMzOjI3ICswMDAwDQo+PiBTdWJqZWN0OiBbUEFUQ0hdIG5mc2Q6
IGRlc3Ryb3kgcGVyY3B1IHN0YXRzIGNvdW50ZXJzIGFmdGVyIHJlcGx5IGNhY2hlDQo+PiAgc2h1
dGRvd24NCj4+IE1JTUUtVmVyc2lvbjogMS4wDQo+PiBDb250ZW50LVR5cGU6IHRleHQvcGxhaW47
IGNoYXJzZXQ9VVRGLTgNCj4+IENvbnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQNCj4+IFVw
b24gbmZzZCBzaHV0ZG93biBhbnkgcGVuZGluZyBEUkMgY2FjaGUgaXMgZnJlZWQuIERSQyBjYWNo
ZSB1c2UgaXMNCj4+IHRyYWNrZWQgdmlhIGEgcGVyY3B1IGNvdW50ZXIuIEluIHRoZSBjdXJyZW50
IGNvZGUgdGhlIHBlcmNwdSBjb3VudGVyDQo+PiBpcyBkZXN0cm95ZWQgYmVmb3JlLiBJZiBhbnkg
cGVuZGluZyBjYWNoZSBpcyBzdGlsbCBwcmVzZW50LA0KPj4gcGVyY3B1X2NvdW50ZXJfYWRkIGlz
IGNhbGxlZCB3aXRoIGEgcGVyY3B1IGNvdW50ZXI9PU5VTEwuIFRoaXMgY2F1c2VzDQo+PiBhIGtl
cm5lbCBjcmFzaC4NCj4+IFRoZSBzb2x1dGlvbiBpcyB0byBkZXN0cm95IHRoZSBwZXJjcHUgY291
bnRlciBhZnRlciB0aGUgY2FjaGUgaXMgZnJlZWQuDQo+PiBGaXhlczogZTU2N2I5OGNlOWE0YiAo
w6JFVVJvZW5mc2Q6IHByb3RlY3QgY29uY3VycmVudCBhY2Nlc3MgdG8gbmZzZCBzdGF0cyBjb3Vu
dGVyc8OiRVVSwp0pDQo+PiBTaWduZWQtb2ZmLWJ5OiBKdWxpYW4gU2Nocm9lZGVyIDxqdW1hY29A
YW1hem9uLmNvbT4NCj4+IC0tLQ0KPj4gIGZzL25mc2QvbmZzY2FjaGUuYyB8IDIgKy0NCj4+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4+IGRpZmYgLS1n
aXQgYS9mcy9uZnNkL25mc2NhY2hlLmMgYi9mcy9uZnNkL25mc2NhY2hlLmMNCj4+IGluZGV4IDBi
M2YxMmFhMzdmZi4uN2RhODhiZGMwZDZjIDEwMDY0NA0KPj4gLS0tIGEvZnMvbmZzZC9uZnNjYWNo
ZS5jDQo+PiArKysgYi9mcy9uZnNkL25mc2NhY2hlLmMNCj4+IEBAIC0yMDYsNyArMjA2LDYgQEAg
dm9pZCBuZnNkX3JlcGx5X2NhY2hlX3NodXRkb3duKHN0cnVjdCBuZnNkX25ldCAqbm4pDQo+PiAg
ICAgICAgIHN0cnVjdCBzdmNfY2FjaGVyZXAgICAgICpycDsNCj4+ICAgICAgICAgdW5zaWduZWQg
aW50IGk7DQo+Pg0KPj4gLSAgICAgICBuZnNkX3JlcGx5X2NhY2hlX3N0YXRzX2Rlc3Ryb3kobm4p
Ow0KPj4gICAgICAgICB1bnJlZ2lzdGVyX3Nocmlua2VyKCZubi0+bmZzZF9yZXBseV9jYWNoZV9z
aHJpbmtlcik7DQo+Pg0KPj4gICAgICAgICBmb3IgKGkgPSAwOyBpIDwgbm4tPmRyY19oYXNoc2l6
ZTsgaSsrKSB7DQo+PiBAQCAtMjE3LDYgKzIxNiw3IEBAIHZvaWQgbmZzZF9yZXBseV9jYWNoZV9z
aHV0ZG93bihzdHJ1Y3QgbmZzZF9uZXQgKm5uKQ0KPj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcnAsIG5uKTsN
Cj4+ICAgICAgICAgICAgICAgICB9DQo+PiAgICAgICAgIH0NCj4+ICsgICAgICAgbmZzZF9yZXBs
eV9jYWNoZV9zdGF0c19kZXN0cm95KG5uKTsNCj4+DQo+PiAgICAgICAgIGt2ZnJlZShubi0+ZHJj
X2hhc2h0YmwpOw0KPj4gICAgICAgICBubi0+ZHJjX2hhc2h0YmwgPSBOVUxMOw0KPj4gLS0NCj4+
IDIuMzIuMA0KPj4NCg0KPldoYXQgaXMgdGhlIGdpdCBjb21taXQgaWQgb2YgdGhpcyBpbiBMaW51
cydzIHRyZWU/DQoNCj5BbmQgdGhpcyBwYXRjaCBpcyB0b3RhbGx5IGRhbWFnZWQgd2l0aCB3aGl0
ZXNwYWNlIGFuZCBjYW4gbm90IGJlIGFwcGxpZWQNCj5hdCBhbGwgOigNCg0KPlBsZWFzZSBmaXgg
aXQgdXAgYW5kIHN1Ym1pdCBpdCBhZ2Fpbi4NCg0KPnRoYW5rcywNCg0KPmdyZWcgay1oDQoNClRo
ZSBwYXRjaCBtYWRlIGl0IGludG8gbGludXggbmV4dC4gY29tbWl0IGZkNWUzNjNlYWM3N2UuDQpJ
IHNlbnQgdGhlIHBhdGNoIHRvIHN0YWJsZSBhZ2FpbiB2aWEgZ2l0IHNlbmQtZW1haWwgKGh0dHBz
Oi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL3N0YWJsZS9tc2c1NjA4MTguaHRtbCkNCg0KVGhhbmtz
LA0KSnVsaWFuLg0KDQoNCg==
