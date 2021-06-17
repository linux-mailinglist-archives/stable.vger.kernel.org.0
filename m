Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE57C3AB3B1
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 14:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhFQMjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 08:39:01 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:46884
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S230225AbhFQMjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 08:39:01 -0400
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 17 Jun 2021 20:36:46
 +0800 (GMT+08:00)
X-Originating-IP: [114.87.236.26]
Date:   Thu, 17 Jun 2021 20:36:46 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   LinMa <linma@zju.edu.cn>
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re:Re: [PATCH 5.4 39/78] Bluetooth: use correct lock to prevent UAF
 of hdev object
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <70042d9f.111abd.17a19f94b84.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgC3L0DfQctgalBhAA--.11166W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwMTElNG3CvYeAABsC
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ck9vcHMsIHNvcnJ5IGZvciB0aGUgZGVsYXkgaGVyZS4gSSBqdXN0IGZvcmdvdCB0byBjaGVjayB0
aGUgbWFpbHMuCgpUaGlzIGNvbW1lbnQgaXMgcmlnaHQsIHdoZW4gSSBzdWJtaXQgdGhpcyBwYXRj
aCBJIG1lbnRpb25lZCB0aGF0IHRoZSByZXBsYWNlbWVudCBvZiB0aGlzIGxvY2sgY2FuIGhhbmcg
dGhlIGRldGFjaGluZyByb3V0aW5lIGJlY2F1c2UgaXQgbmVlZHMgdG8gd2FpdCB0aGUgcmVsZWFz
ZSBvZiB0aGUgbG9ja19zb2NrKCkuCgpCdXQgdGhpcyBkb2VzIG5vIGhhcm0gaW4gbXkgdGVzdGlu
Zy4gSW4gZmFjdCwgdGhlIHJlbGV2YW50IGNvZGUgY2FuIG9ubHkgYmUgZXhlY3V0ZWQgd2hlbiBy
ZW1vdmluZyB0aGUgY29udHJvbGxlci4gSSB0aGluayBpdCBjYW4gd2FpdCBmb3IgdGhlIGxvY2su
IE1vcmVvdmVyLCB0aGlzIHBhdGNoIGNhbiBmaXggdGhlIHBvdGVudGlhbCBVQUYgaW5kZWVkLgoK
PiBtYXkgbmVlZCBmdXJ0aGVyIGRpc2N1c3Npb24uICh3cm90ZSBpbiBwcmV2aW91cyBtYWlsIGxp
c3QKCldlbGNvbWUgdGhlIGFkZGl0aW9uYWwgYWR2aXNlIG9uIHRoaXMuIERvZXMgdGhpcyByZWFs
bHkgYnJva2VuIHRoZSBsb2NrIHByaW5jaXBsZT8KClJlZ2FyZHMgTGluIE1hCgrlnKggMjAyMS0w
Ni0xNiAyMzowMTowOO+8jCJHcmVnIEtyb2FoLUhhcnRtYW4iIDxncmVna2hAbGludXhmb3VuZGF0
aW9uLm9yZz4g5YaZ6YGT77yaCgo+T24gTW9uLCBKdW4gMTQsIDIwMjEgYXQgMDQ6MTU6MDJQTSAr
MDIwMCwgRXJpYyBEdW1hemV0IHdyb3RlOgo+PiAKPj4gCj4+IE9uIDYvOC8yMSA4OjI3IFBNLCBH
cmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6Cj4+ID4gRnJvbTogTGluIE1hIDxsaW5tYUB6anUuZWR1
LmNuPgo+PiA+IAo+PiA+IGNvbW1pdCBlMzA1NTA5ZTY3OGIzYTRhZjJiM2NmZDQxMGY0MDlmN2Nk
YWFiYjUyIHVwc3RyZWFtLgo+PiA+IAo+PiA+IFRoZSBoY2lfc29ja19kZXZfZXZlbnQoKSBmdW5j
dGlvbiB3aWxsIGNsZWFudXAgdGhlIGhkZXYgb2JqZWN0IGZvcgo+PiA+IHNvY2tldHMgZXZlbiBp
ZiB0aGlzIG9iamVjdCBtYXkgc3RpbGwgYmUgaW4gdXNlZCB3aXRoaW4gdGhlCj4+ID4gaGNpX3Nv
Y2tfYm91bmRfaW9jdGwoKSBmdW5jdGlvbiwgcmVzdWx0IGluIFVBRiB2dWxuZXJhYmlsaXR5Lgo+
PiA+IAo+PiA+IFRoaXMgcGF0Y2ggcmVwbGFjZSB0aGUgQkggY29udGV4dCBsb2NrIHRvIHNlcmlh
bGl6ZSB0aGVzZSBhZmZhaXJzCj4+ID4gYW5kIHByZXZlbnQgdGhlIHJhY2UgY29uZGl0aW9uLgo+
PiA+IAo+PiA+IFNpZ25lZC1vZmYtYnk6IExpbiBNYSA8bGlubWFAemp1LmVkdS5jbj4KPj4gPiBT
aWduZWQtb2ZmLWJ5OiBNYXJjZWwgSG9sdG1hbm4gPG1hcmNlbEBob2x0bWFubi5vcmc+Cj4+ID4g
U2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZz4KPj4gPiAtLS0KPj4gPiAgbmV0L2JsdWV0b290aC9oY2lfc29jay5jIHwgICAgNCArKy0t
Cj4+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+
ID4gCj4+ID4gLS0tIGEvbmV0L2JsdWV0b290aC9oY2lfc29jay5jCj4+ID4gKysrIGIvbmV0L2Js
dWV0b290aC9oY2lfc29jay5jCj4+ID4gQEAgLTc1NSw3ICs3NTUsNyBAQCB2b2lkIGhjaV9zb2Nr
X2Rldl9ldmVudChzdHJ1Y3QgaGNpX2RldiAqCj4+ID4gIAkJLyogRGV0YWNoIHNvY2tldHMgZnJv
bSBkZXZpY2UgKi8KPj4gPiAgCQlyZWFkX2xvY2soJmhjaV9za19saXN0LmxvY2spOwo+PiA+ICAJ
CXNrX2Zvcl9lYWNoKHNrLCAmaGNpX3NrX2xpc3QuaGVhZCkgewo+PiA+IC0JCQliaF9sb2NrX3Nv
Y2tfbmVzdGVkKHNrKTsKPj4gPiArCQkJbG9ja19zb2NrKHNrKTsKPj4gPiAgCQkJaWYgKGhjaV9w
aShzayktPmhkZXYgPT0gaGRldikgewo+PiA+ICAJCQkJaGNpX3BpKHNrKS0+aGRldiA9IE5VTEw7
Cj4+ID4gIAkJCQlzay0+c2tfZXJyID0gRVBJUEU7Cj4+ID4gQEAgLTc2NCw3ICs3NjQsNyBAQCB2
b2lkIGhjaV9zb2NrX2Rldl9ldmVudChzdHJ1Y3QgaGNpX2RldiAqCj4+ID4gIAo+PiA+ICAJCQkJ
aGNpX2Rldl9wdXQoaGRldik7Cj4+ID4gIAkJCX0KPj4gPiAtCQkJYmhfdW5sb2NrX3NvY2soc2sp
Owo+PiA+ICsJCQlyZWxlYXNlX3NvY2soc2spOwo+PiA+ICAJCX0KPj4gPiAgCQlyZWFkX3VubG9j
aygmaGNpX3NrX2xpc3QubG9jayk7Cj4+ID4gIAl9Cj4+ID4gCj4+ID4gCj4+IAo+PiAKPj4gVGhp
cyBwYXRjaCBpcyBidWdneS4KPj4gCj4+IGxvY2tfc29jaygpIGNhbiBzbGVlcC4KPj4gCj4+IEJ1
dCB0aGUgcmVhZF9sb2NrKCZoY2lfc2tfbGlzdC5sb2NrKSB0d28gbGluZXMgYmVmb3JlIGlzIG5v
dCBnb2luZyB0byBhbGxvdyB0aGUgc2xlZXAuCj4+IAo+PiBIbW1tID8KPj4gCj4+IAo+Cj5PZGQs
IExpbiwgZGlkIHlvdSBzZWUgYW55IHByb2JsZW1zIHdpdGggeW91ciB0ZXN0aW5nIG9mIHRoaXM/
Cj4K
