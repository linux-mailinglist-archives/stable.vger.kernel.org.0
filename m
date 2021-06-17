Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0FD3AB45C
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 15:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhFQNNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 09:13:30 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:51592 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232050AbhFQNNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 09:13:30 -0400
Received: by ajax-webmail-mail-app2 (Coremail) ; Thu, 17 Jun 2021 21:11:16
 +0800 (GMT+08:00)
X-Originating-IP: [10.214.160.123]
Date:   Thu, 17 Jun 2021 21:11:16 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   LinMa <linma@zju.edu.cn>
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        eric.dumazet@gmail.com, marcel@holtmann.org
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re ...: [PATCH 5.4 39/78] Bluetooth: use correct lock to prevent
 UAF of hdev object
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <70042d9f.111abd.17a19f94b84.Coremail.linma@zju.edu.cn>
References: <70042d9f.111abd.17a19f94b84.Coremail.linma@zju.edu.cn>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <3a861419.11a1ce.17a1a18e470.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: by_KCgC3gGT0SctgdQtSAA--.13017W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwITElNG3CvZBwAAs8
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CgoKQnkgY2hlY2tpbmcgdGhlIHNvdXJjZSBjb2RlLCBJIGZvdW5kIHRoYXQgdGhlcmUgYXJlIGZv
bGxvd2luZyBwb3NpdGlvbnMgdGhhdCB3aWxsIGFjY2VzcyB0aGUgaGNpX3NrX2xpc3QubG9jawoK
MS4gdm9pZCBoY2lfc2VuZF90b19zb2NrKHN0cnVjdCBoY2lfZGV2ICpoZGV2LCBzdHJ1Y3Qgc2tf
YnVmZiAqc2tiKQoyLiB2b2lkIGhjaV9zZW5kX3RvX2NoYW5uZWwodW5zaWduZWQgc2hvcnQgY2hh
bm5lbCwgc3RydWN0IHNrX2J1ZmYgKnNrYiwKCQkJIGludCBmbGFnLCBzdHJ1Y3Qgc29jayAqc2tp
cF9zaykKMy4gdm9pZCBoY2lfc2VuZF9tb25pdG9yX2N0cmxfZXZlbnQoc3RydWN0IGhjaV9kZXYg
KmhkZXYsIHUxNiBldmVudCwKCQkJCSB2b2lkICpkYXRhLCB1MTYgZGF0YV9sZW4sIGt0aW1lX3Qg
dHN0YW1wLAoJCQkJIGludCBmbGFnLCBzdHJ1Y3Qgc29jayAqc2tpcF9zaykKNC4gc3RhdGljIHZv
aWQgc2VuZF9tb25pdG9yX2NvbnRyb2xfcmVwbGF5KHN0cnVjdCBzb2NrICptb25fc2spCkFuZCB0
aGlzIGRpc2N1c3NlZCBvbmUKNS4gdm9pZCBoY2lfc29ja19kZXZfZXZlbnQoc3RydWN0IGhjaV9k
ZXYgKmhkZXYsIGludCBldmVudCkKCj4gVGhpcyBjb21tZW50IGlzIHJpZ2h0LCB3aGVuIEkgc3Vi
bWl0IHRoaXMgcGF0Y2ggSSBtZW50aW9uZWQgdGhhdCB0aGUgcmVwbGFjZW1lbnQgb2YgdGhpcyBs
b2NrIGNhbiBoYW5nIHRoZSBkZXRhY2hpbmcgcm91dGluZSBiZWNhdXNlIGl0IG5lZWRzIHRvIHdh
aXQgdGhlIHJlbGVhc2Ugb2YgdGhlIGxvY2tfc29jaygpLgo+IAo+IEJ1dCB0aGlzIGRvZXMgbm8g
aGFybSBpbiBteSB0ZXN0aW5nLiBJbiBmYWN0LCB0aGUgcmVsZXZhbnQgY29kZSBjYW4gb25seSBi
ZSBleGVjdXRlZCB3aGVuIHJlbW92aW5nIHRoZSBjb250cm9sbGVyLiBJIHRoaW5rIGl0IGNhbiB3
YWl0IGZvciB0aGUgbG9jay4gTW9yZW92ZXIsIHRoaXMgcGF0Y2ggY2FuIGZpeCB0aGUgcG90ZW50
aWFsIFVBRiBpbmRlZWQuCgpBc3N1bWluZyB0aGUgaGNpX3NrX2xpc3QubG9jayBpcyBoZWxkIGJ5
IHRoZSBjbGVhbnVwIHJvdXRpbmUuIEkgZG9uJ3QgdGhpbmsgb3RoZXIgcG9zc2libGUgZnVuY3Rp
b25zIHdpbGwgbmVjZXNzYXJpbHkgYnVzeSB3YWl0aW5nIHRoaXMgbG9jay4KCj4+ID4gIAkJLyog
RGV0YWNoIHNvY2tldHMgZnJvbSBkZXZpY2UgKi8KPj4gPiAgCQlyZWFkX2xvY2soJmhjaV9za19s
aXN0LmxvY2spOwo+PiA+ICAJCXNrX2Zvcl9lYWNoKHNrLCAmaGNpX3NrX2xpc3QuaGVhZCkgewo+
PiA+IC0JCQliaF9sb2NrX3NvY2tfbmVzdGVkKHNrKTsKPj4gPiArCQkJbG9ja19zb2NrKHNrKTsK
Pj4gPiAgCQkJaWYgKGhjaV9waShzayktPmhkZXYgPT0gaGRldikgewo+PiA+ICAJCQkJaGNpX3Bp
KHNrKS0+aGRldiA9IE5VTEw7Cj4+ID4gIAkJCQlzay0+c2tfZXJyID0gRVBJUEU7Cj4+ID4gQEAg
LTc2NCw3ICs3NjQsNyBAQCB2b2lkIGhjaV9zb2NrX2Rldl9ldmVudChzdHJ1Y3QgaGNpX2RldiAq
Cj4+ID4gIAo+PiA+ICAJCQkJaGNpX2Rldl9wdXQoaGRldik7Cj4+ID4gIAkJCX0KPj4gPiAtCQkJ
YmhfdW5sb2NrX3NvY2soc2spOwo+PiA+ICsJCQlyZWxlYXNlX3NvY2soc2spOwo+PiA+ICAJCX0K
Pj4gPiAgCQlyZWFkX3VubG9jaygmaGNpX3NrX2xpc3QubG9jayk7Cj4+ID4gIAl9Cj4+ID4gCj4+
ID4KCkluIGFub3RoZXIgd29yZCwgdGhlc2UgbG9jayByZXF1aXJpbmcgZXZlbnRzIHdvbid0IGJl
IG5vcm1hbC4gRm9yIGV4YW1wbGUsIHRoZSBoY2lfc2VuZF90b19zb2NrKCkgZnVuY3Rpb24gaXMg
bm90IGFzc3VtZWQgdG8gYmUgYXdha2VuZWQgd2hlbiB0aGUgY29udHJvbGxlciBpcyBnb2luZyB0
byBiZSByZW1vdmVkLiBUaGUgYXR0YWNrZXIgbWF5IGludGVuZCB0byBkbyB0aGlzLCBob3dldmVy
LCBpdCBzZWVtcyB0aGF0IGhlIGNhbiBvbmx5IGhhbmcgdGhlIGtlcm5lbCBieSBrZWVwaW5nIHRo
ZSB1c2VyZmF1bHRmZCBwYWdlLiBCZWNhdXNlIGhlIGNhbm5vdCB0cmlnZ2VyIHRoZSBVQUYgZm9y
IG5vdywgaGUgd29uJ3QgZ2FpbiBhbnkgYmVuZWZpdCBmb3IgaGFuZ2luZyB0aGUgaGNpX3NvY2tf
ZGV2X2V2ZW50KCkgZnVuY3Rpb24uIEFmdGVyIHRoZSBhdHRhY2tlciByZWxlYXNlIHRoZSB1c2Vy
ZmF1bHRmZCBwYWdlIGFuZCB0aGUgaGNpX3NlbmRfdG9fc29jaygpIG1vdmVzIG9uLCB0aGUgaGNp
X3NrX2xpc3QubG9jayB3aWxsIGJlIGhlbmNlIHJlbGVhc2VkIGFzIGV4cGVjdGVkLgoKSW4gc3Vt
bWFyeSwgSSB0aGluayB0aGF0OiBldmVuIHRoZSBoY2lfc2tfbGlzdC5sb2NrIGlzIGhlbGQgYW5k
IHRoZSBoY2lfc2VuZF90b19zb2NrKCkgZnVuY3Rpb25zIHNsZWVwLCBpdCBzaG91bGQgbm90IGhh
dmUgYW55IGJhZCBlZmZlY3QgYXMgdGhpcyBhcHBlYXJhbmNlIGNhbiBvbmx5IHRha2UgcGxhY2Ug
aW4gdGhlIGNvbnRyb2xsZXIgcmVtb3ZhbCByb3V0aW5lLiBXZWxjb21lIGZvciB0aGUgZnVydGhl
ciBzdWdnZXN0aW9ucy4KCkJlc3QgUmVnYXJkcwoKTGluIE1hCgoKCg==
