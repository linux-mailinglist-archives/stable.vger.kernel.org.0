Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FEE2514E8
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 11:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHYJB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 05:01:58 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:4688 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726045AbgHYJB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 05:01:58 -0400
X-UUID: d2bf482b4b75414b83c1fe20da4d041c-20200825
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=nircHIE2dwGwS6cH9noiwjPrOfmBo/K1gHtgpxbEFhY=;
        b=MDmsC9GX5O60Ehsaz4adg6HCWVrg4EFAEe1oxyJ7tSIMJmJmDbINK6yMtUxtOyf9EX0qjtI6SHvMp6PNojYLYM4/QtsREmMCvHk9ZiSwRt7HBonv7pNodFuNoFHkxtxccbLPJ5/WIObUJRGIWFctszHbfZj3OtWWlg5vatBbQOs=;
X-UUID: d2bf482b4b75414b83c1fe20da4d041c-20200825
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 74264485; Tue, 25 Aug 2020 17:01:43 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 25 Aug 2020 17:01:41 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 Aug
 2020 17:01:41 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 Aug 2020 17:01:41 +0800
Message-ID: <1598346102.10649.7.camel@mtkswgap22>
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Jens Axboe <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Date:   Tue, 25 Aug 2020 17:01:42 +0800
In-Reply-To: <20200824030607.19357-1-bvanassche@acm.org>
References: <20200824030607.19357-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQmFydCwNCg0KT24gU3VuLCAyMDIwLTA4LTIzIGF0IDIwOjA2IC0wNzAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IFdpdGggdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24gdGhlIGZvbGxv
d2luZyByYWNlIGNhbiBoYXBwZW46DQo+ICogYmxrX3ByZV9ydW50aW1lX3N1c3BlbmQoKSBjYWxs
cyBibGtfZnJlZXplX3F1ZXVlX3N0YXJ0KCkgYW5kDQo+ICAgYmxrX21xX3VuZnJlZXplX3F1ZXVl
KCkuDQo+ICogYmxrX3F1ZXVlX2VudGVyKCkgY2FsbHMgYmxrX3F1ZXVlX3BtX29ubHkoKSBhbmQg
dGhhdCBmdW5jdGlvbiByZXR1cm5zDQo+ICAgdHJ1ZS4NCj4gKiBibGtfcXVldWVfZW50ZXIoKSBj
YWxscyBibGtfcG1fcmVxdWVzdF9yZXN1bWUoKSBhbmQgdGhhdCBmdW5jdGlvbiBkb2VzDQo+ICAg
bm90IGNhbGwgcG1fcmVxdWVzdF9yZXN1bWUoKSBiZWNhdXNlIHRoZSBxdWV1ZSBydW50aW1lIHN0
YXR1cyBpcw0KPiAgIFJQTV9BQ1RJVkUuDQo+ICogYmxrX3ByZV9ydW50aW1lX3N1c3BlbmQoKSBj
aGFuZ2VzIHRoZSBxdWV1ZSBzdGF0dXMgaW50byBSUE1fU1VTUEVORElORy4NCj4gDQo+IEZpeCB0
aGlzIHJhY2UgYnkgY2hhbmdpbmcgdGhlIHF1ZXVlIHJ1bnRpbWUgc3RhdHVzIGludG8gUlBNX1NV
U1BFTkRJTkcNCj4gYmVmb3JlIHN3aXRjaGluZyBxX3VzYWdlX2NvdW50ZXIgdG8gYXRvbWljIG1v
ZGUuDQo+IA0KPiBDYzogQWxhbiBTdGVybiA8c3Rlcm5Acm93bGFuZC5oYXJ2YXJkLmVkdT4NCj4g
Q2M6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+IENjOiBNaW5nIExl
aSA8bWluZy5sZWlAcmVkaGF0LmNvbT4NCj4gQ2M6IHN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVs
Lm9yZz4NCj4gRml4ZXM6IDk4NmQ0MTNiN2MxNSAoImJsay1tcTogRW5hYmxlIHN1cHBvcnQgZm9y
IHJ1bnRpbWUgcG93ZXIgbWFuYWdlbWVudCIpDQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNh
bmdAY29kZWF1cm9yYS5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZh
bmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4gIGJsb2NrL2Jsay1wbS5jIHwgMTUgKysrKysrKysr
LS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1wbS5jIGIvYmxvY2svYmxrLXBtLmMNCj4g
aW5kZXggYjg1MjM0ZDc1OGY3Li4xN2JkMDIwMjY4ZDQgMTAwNjQ0DQo+IC0tLSBhL2Jsb2NrL2Js
ay1wbS5jDQo+ICsrKyBiL2Jsb2NrL2Jsay1wbS5jDQo+IEBAIC02Nyw2ICs2NywxMCBAQCBpbnQg
YmxrX3ByZV9ydW50aW1lX3N1c3BlbmQoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEpDQo+ICANCj4g
IAlXQVJOX09OX09OQ0UocS0+cnBtX3N0YXR1cyAhPSBSUE1fQUNUSVZFKTsNCj4gIA0KPiArCXNw
aW5fbG9ja19pcnEoJnEtPnF1ZXVlX2xvY2spOw0KPiArCXEtPnJwbV9zdGF0dXMgPSBSUE1fU1VT
UEVORElORzsNCj4gKwlzcGluX3VubG9ja19pcnEoJnEtPnF1ZXVlX2xvY2spOw0KPiArDQoNCkhh
cyBiZWxvdyBhbHRlcm5hdGl2ZSB3YXkgYmVlbiBjb25zaWRlcmVkIHRoYXQgUlBNX1NVU1BFTkRJ
TkcgaXMgc2V0DQphZnRlciBibGtfbXFfdW5mcmVlemVfcXVldWUoKT8NCg0KCWJsa19mcmVlemVf
cXVldWVfc3RhcnQocSk7DQoNCisJc3Bpbl9sb2NrX2lycSgmcS0+cXVldWVfbG9jayk7DQorCXEt
PnJwbV9zdGF0dXMgPSBSUE1fU1VTUEVORElORzsNCisJc3Bpbl91bmxvY2tfaXJxKCZxLT5xdWV1
ZV9sb2NrKTsNCg0KDQpPdGhlcndpc2UgcmVxdWVzdHMgY2FuIGVudGVyIHF1ZXVlIHdoaWxlIHJw
bV9zdGF0dXMgaXMgUlBNX1NVU1BFTkRJTkcNCmR1cmluZyBhIHNtYWxsIHdpbmRvdywgaS5lLiwg
YmVmb3JlIGJsa19zZXRfcG1fb25seSgpIGlzIGludm9rZWQuIFRoaXMNCndvdWxkIG1ha2UgdGhl
IGRlZmluaXRpb24gb2YgcnBtX3N0YXR1cyBhbWJpZ3VvdXMuDQoNCkluIHRoaXMgd2F5LCB0aGUg
cmFjaW5nIGNvdWxkIGJlIGFsc28gc29sdmVkOg0KDQotIEJlZm9yZSBibGtfZnJlZXplX3F1ZXVl
X3N0YXJ0KCksIGFueSByZXF1ZXN0cyBzaGFsbCBiZSBhbGxvd2VkIHRvDQplbnRlciBxdWV1ZQ0K
LSBibGtfZnJlZXplX3F1ZXVlX3N0YXJ0KCkgZnJlZXplcyB0aGUgcXVldWUgYW5kIGJsb2NrcyBh
bGwgdXBjb21pbmcNCnJlcXVlc3RzIChtYWtlIHRoZW0gd2FpdF9ldmVudChxLT5tcV9mcmVlemVf
d3EpKQ0KLSBycG1fc3RhdHVzIGlzIHNldCBhcyBSUE1fU1VTUEVORElORw0KLSBibGtfbXFfdW5m
cmVlemVfcXVldWUoKSB3YWtlcyB1cCBxLT5tcV9mcmVlemVfd3EgYW5kIHRoZW4NCmJsa19wbV9y
ZXF1ZXN0X3Jlc3VtZSgpIGNhbiBiZSBleGVjdXRlZA0KDQpUaGFua3MsDQoNClN0YW5sZXkgQ2h1
DQoNCg0KPiAgCS8qDQo+ICAJICogSW5jcmVhc2UgdGhlIHBtX29ubHkgY291bnRlciBiZWZvcmUg
Y2hlY2tpbmcgd2hldGhlciBhbnkNCj4gIAkgKiBub24tUE0gYmxrX3F1ZXVlX2VudGVyKCkgY2Fs
bHMgYXJlIGluIHByb2dyZXNzIHRvIGF2b2lkIHRoYXQgYW55DQo+IEBAIC04OSwxNSArOTMsMTQg
QEAgaW50IGJsa19wcmVfcnVudGltZV9zdXNwZW5kKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxKQ0K
PiAgCS8qIFN3aXRjaCBxX3VzYWdlX2NvdW50ZXIgYmFjayB0byBwZXItY3B1IG1vZGUuICovDQo+
ICAJYmxrX21xX3VuZnJlZXplX3F1ZXVlKHEpOw0KPiAgDQo+IC0Jc3Bpbl9sb2NrX2lycSgmcS0+
cXVldWVfbG9jayk7DQo+IC0JaWYgKHJldCA8IDApDQo+ICsJaWYgKHJldCA8IDApIHsNCj4gKwkJ
c3Bpbl9sb2NrX2lycSgmcS0+cXVldWVfbG9jayk7DQo+ICsJCXEtPnJwbV9zdGF0dXMgPSBSUE1f
QUNUSVZFOw0KPiAgCQlwbV9ydW50aW1lX21hcmtfbGFzdF9idXN5KHEtPmRldik7DQo+IC0JZWxz
ZQ0KPiAtCQlxLT5ycG1fc3RhdHVzID0gUlBNX1NVU1BFTkRJTkc7DQo+IC0Jc3Bpbl91bmxvY2tf
aXJxKCZxLT5xdWV1ZV9sb2NrKTsNCj4gKwkJc3Bpbl91bmxvY2tfaXJxKCZxLT5xdWV1ZV9sb2Nr
KTsNCj4gIA0KPiAtCWlmIChyZXQpDQo+ICAJCWJsa19jbGVhcl9wbV9vbmx5KHEpOw0KPiArCX0N
Cj4gIA0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQoNCg0KDQoNCg==

