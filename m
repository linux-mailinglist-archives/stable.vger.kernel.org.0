Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F181B25150C
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 11:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgHYJL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 05:11:29 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:17546 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725947AbgHYJL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 05:11:27 -0400
X-UUID: 6cbc9302bf5a43d297398539dbe21ee1-20200825
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=PZgvhtmBXbDNGHwDLxYVc6k3rDXTzjehSINrEt1I3V4=;
        b=BL8iCtBL8zByAV6wMHdmeVwKb7BOf7ZfCYn6td3xdvo4qdvFaLjvc89HpRqtqYoWLT4nkk6FrnfJLExif3Ebg4RDHgI2pssZsS2Tsi8K+xZcLGIaEYJ39rGgZ5tN1kf//voFLqHjV6ZIRMua5nLCBtHIkt+vs2GopbyTXUwg6cI=;
X-UUID: 6cbc9302bf5a43d297398539dbe21ee1-20200825
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1189287998; Tue, 25 Aug 2020 17:11:23 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 25 Aug 2020 17:11:19 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 Aug 2020 17:11:19 +0800
Message-ID: <1598346681.10649.8.camel@mtkswgap22>
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Jens Axboe <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Date:   Tue, 25 Aug 2020 17:11:21 +0800
In-Reply-To: <20200824030607.19357-1-bvanassche@acm.org>
References: <20200824030607.19357-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 1415DBB965B67A0D6C9019982BE5298E896319063BC075E2D19CCADCCF26DD522000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

U29ycnksIHJlc2VuZCB0byBmaXggdHlwby4NCg0KSGkgQmFydCwNCg0KT24gU3VuLCAyMDIwLTA4
LTIzIGF0IDIwOjA2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+IFdpdGggdGhlIGN1
cnJlbnQgaW1wbGVtZW50YXRpb24gdGhlIGZvbGxvd2luZyByYWNlIGNhbiBoYXBwZW46DQo+ICog
YmxrX3ByZV9ydW50aW1lX3N1c3BlbmQoKSBjYWxscyBibGtfZnJlZXplX3F1ZXVlX3N0YXJ0KCkg
YW5kDQo+ICAgYmxrX21xX3VuZnJlZXplX3F1ZXVlKCkuDQo+ICogYmxrX3F1ZXVlX2VudGVyKCkg
Y2FsbHMgYmxrX3F1ZXVlX3BtX29ubHkoKSBhbmQgdGhhdCBmdW5jdGlvbiByZXR1cm5zDQo+ICAg
dHJ1ZS4NCj4gKiBibGtfcXVldWVfZW50ZXIoKSBjYWxscyBibGtfcG1fcmVxdWVzdF9yZXN1bWUo
KSBhbmQgdGhhdCBmdW5jdGlvbiBkb2VzDQo+ICAgbm90IGNhbGwgcG1fcmVxdWVzdF9yZXN1bWUo
KSBiZWNhdXNlIHRoZSBxdWV1ZSBydW50aW1lIHN0YXR1cyBpcw0KPiAgIFJQTV9BQ1RJVkUuDQo+
ICogYmxrX3ByZV9ydW50aW1lX3N1c3BlbmQoKSBjaGFuZ2VzIHRoZSBxdWV1ZSBzdGF0dXMgaW50
byBSUE1fU1VTUEVORElORy4NCj4gDQo+IEZpeCB0aGlzIHJhY2UgYnkgY2hhbmdpbmcgdGhlIHF1
ZXVlIHJ1bnRpbWUgc3RhdHVzIGludG8gUlBNX1NVU1BFTkRJTkcNCj4gYmVmb3JlIHN3aXRjaGlu
ZyBxX3VzYWdlX2NvdW50ZXIgdG8gYXRvbWljIG1vZGUuDQo+IA0KPiBDYzogQWxhbiBTdGVybiA8
c3Rlcm5Acm93bGFuZC5oYXJ2YXJkLmVkdT4NCj4gQ2M6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNo
dUBtZWRpYXRlay5jb20+DQo+IENjOiBNaW5nIExlaSA8bWluZy5sZWlAcmVkaGF0LmNvbT4NCj4g
Q2M6IHN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4gRml4ZXM6IDk4NmQ0MTNiN2Mx
NSAoImJsay1tcTogRW5hYmxlIHN1cHBvcnQgZm9yIHJ1bnRpbWUgcG93ZXIgbWFuYWdlbWVudCIp
DQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQo+IFNpZ25l
ZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4g
IGJsb2NrL2Jsay1wbS5jIHwgMTUgKysrKysrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Jsb2Nr
L2Jsay1wbS5jIGIvYmxvY2svYmxrLXBtLmMNCj4gaW5kZXggYjg1MjM0ZDc1OGY3Li4xN2JkMDIw
MjY4ZDQgMTAwNjQ0DQo+IC0tLSBhL2Jsb2NrL2Jsay1wbS5jDQo+ICsrKyBiL2Jsb2NrL2Jsay1w
bS5jDQo+IEBAIC02Nyw2ICs2NywxMCBAQCBpbnQgYmxrX3ByZV9ydW50aW1lX3N1c3BlbmQoc3Ry
dWN0IHJlcXVlc3RfcXVldWUgKnEpDQo+ICANCj4gIAlXQVJOX09OX09OQ0UocS0+cnBtX3N0YXR1
cyAhPSBSUE1fQUNUSVZFKTsNCj4gIA0KPiArCXNwaW5fbG9ja19pcnEoJnEtPnF1ZXVlX2xvY2sp
Ow0KPiArCXEtPnJwbV9zdGF0dXMgPSBSUE1fU1VTUEVORElORzsNCj4gKwlzcGluX3VubG9ja19p
cnEoJnEtPnF1ZXVlX2xvY2spOw0KPiArDQoNCkhhcyBiZWxvdyBhbHRlcm5hdGl2ZSB3YXkgYmVl
biBjb25zaWRlcmVkIHRoYXQgUlBNX1NVU1BFTkRJTkcgaXMgc2V0DQphZnRlciBibGtfZnJlZXpl
X3F1ZXVlX3N0YXJ0KCk/DQoNCglibGtfZnJlZXplX3F1ZXVlX3N0YXJ0KHEpOw0KDQorCXNwaW5f
bG9ja19pcnEoJnEtPnF1ZXVlX2xvY2spOw0KKwlxLT5ycG1fc3RhdHVzID0gUlBNX1NVU1BFTkRJ
Tkc7DQorCXNwaW5fdW5sb2NrX2lycSgmcS0+cXVldWVfbG9jayk7DQoNCg0KT3RoZXJ3aXNlIHJl
cXVlc3RzIGNhbiBlbnRlciBxdWV1ZSB3aGlsZSBycG1fc3RhdHVzIGlzIFJQTV9TVVNQRU5ESU5H
DQpkdXJpbmcgYSBzbWFsbCB3aW5kb3csIGkuZS4sIGJlZm9yZSBibGtfc2V0X3BtX29ubHkoKSBp
cyBpbnZva2VkLiBUaGlzDQp3b3VsZCBtYWtlIHRoZSBkZWZpbml0aW9uIG9mIHJwbV9zdGF0dXMg
YW1iaWd1b3VzLg0KDQpJbiB0aGlzIHdheSwgdGhlIHJhY2luZyBjb3VsZCBiZSBhbHNvIHNvbHZl
ZDoNCg0KLSBCZWZvcmUgYmxrX2ZyZWV6ZV9xdWV1ZV9zdGFydCgpLCBhbnkgcmVxdWVzdHMgc2hh
bGwgYmUgYWxsb3dlZCB0bw0KZW50ZXIgcXVldWUNCi0gYmxrX2ZyZWV6ZV9xdWV1ZV9zdGFydCgp
IGZyZWV6ZXMgdGhlIHF1ZXVlIGFuZCBibG9ja3MgYWxsIHVwY29taW5nDQpyZXF1ZXN0cyAobWFr
ZSB0aGVtIHdhaXRfZXZlbnQocS0+bXFfZnJlZXplX3dxKSkNCi0gcnBtX3N0YXR1cyBpcyBzZXQg
YXMgUlBNX1NVU1BFTkRJTkcNCi0gYmxrX21xX3VuZnJlZXplX3F1ZXVlKCkgd2FrZXMgdXAgcS0+
bXFfZnJlZXplX3dxIGFuZCB0aGVuDQpibGtfcG1fcmVxdWVzdF9yZXN1bWUoKSBjYW4gYmUgZXhl
Y3V0ZWQNCg0KVGhhbmtzLA0KDQpTdGFubGV5IENodQ0KDQoNCj4gIAkvKg0KPiAgCSAqIEluY3Jl
YXNlIHRoZSBwbV9vbmx5IGNvdW50ZXIgYmVmb3JlIGNoZWNraW5nIHdoZXRoZXIgYW55DQo+ICAJ
ICogbm9uLVBNIGJsa19xdWV1ZV9lbnRlcigpIGNhbGxzIGFyZSBpbiBwcm9ncmVzcyB0byBhdm9p
ZCB0aGF0IGFueQ0KPiBAQCAtODksMTUgKzkzLDE0IEBAIGludCBibGtfcHJlX3J1bnRpbWVfc3Vz
cGVuZChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSkNCj4gIAkvKiBTd2l0Y2ggcV91c2FnZV9jb3Vu
dGVyIGJhY2sgdG8gcGVyLWNwdSBtb2RlLiAqLw0KPiAgCWJsa19tcV91bmZyZWV6ZV9xdWV1ZShx
KTsNCj4gIA0KPiAtCXNwaW5fbG9ja19pcnEoJnEtPnF1ZXVlX2xvY2spOw0KPiAtCWlmIChyZXQg
PCAwKQ0KPiArCWlmIChyZXQgPCAwKSB7DQo+ICsJCXNwaW5fbG9ja19pcnEoJnEtPnF1ZXVlX2xv
Y2spOw0KPiArCQlxLT5ycG1fc3RhdHVzID0gUlBNX0FDVElWRTsNCj4gIAkJcG1fcnVudGltZV9t
YXJrX2xhc3RfYnVzeShxLT5kZXYpOw0KPiAtCWVsc2UNCj4gLQkJcS0+cnBtX3N0YXR1cyA9IFJQ
TV9TVVNQRU5ESU5HOw0KPiAtCXNwaW5fdW5sb2NrX2lycSgmcS0+cXVldWVfbG9jayk7DQo+ICsJ
CXNwaW5fdW5sb2NrX2lycSgmcS0+cXVldWVfbG9jayk7DQo+ICANCj4gLQlpZiAocmV0KQ0KPiAg
CQlibGtfY2xlYXJfcG1fb25seShxKTsNCj4gKwl9DQo+ICANCj4gIAlyZXR1cm4gcmV0Ow0KPiAg
fQ0KDQoNCg0KDQoNCg==

