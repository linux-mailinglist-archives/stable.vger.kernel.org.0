Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE7C1F71C0
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 03:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgFLBdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 21:33:22 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:24585 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725796AbgFLBdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 21:33:22 -0400
X-UUID: a0513a9be63a46aa87e3b1c67d53ab09-20200612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=oGuYpYnQCol1SIDGq8l3xDiCEUooJhW3zBhmGenIrI8=;
        b=LNfdT2K5CjL8kxelUN+6+XvXS45lryKOi3rBGiHhaQcV7ORUQY3vrVZA7guIJo0FfunBHDg0KyP2MPW8SmJyuoEEW6rtrWyOoNesm8uMXo/AVJA9arCn6V2V3n8s4XkKsdRl0xjL6nJ6TCAE+JmKGz2L2NXrQqZWcXB0d23WBNM=;
X-UUID: a0513a9be63a46aa87e3b1c67d53ab09-20200612
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 756543116; Fri, 12 Jun 2020 09:33:17 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 12 Jun 2020 09:33:10 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Jun 2020 09:33:04 +0800
Message-ID: <1591925590.8494.1.camel@mtkswgap22>
Subject: Re: Suggest make 'user_access_begin()' do 'access_ok()' to stable
 kernel
From:   Miles Chen <miles.chen@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>
Date:   Fri, 12 Jun 2020 09:33:10 +0800
In-Reply-To: <20200611111506.GE3802953@kroah.com>
References: <1591811900.26208.17.camel@mtkswgap22>
         <20200610180249.GA5500@kroah.com> <1591839462.26208.24.camel@mtkswgap22>
         <20200611111506.GE3802953@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: AB7BD0B4E80D8F37E8D829741A6D2F43B6CF8B0B9C461DDF8C13EA8CD6362DA82000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTA2LTExIGF0IDEzOjE1ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBU
aHUsIEp1biAxMSwgMjAyMCBhdCAwOTozNzo0MkFNICswODAwLCBNaWxlcyBDaGVuIHdyb3RlOg0K
PiA+IEBAIC0yNjAxLDcgKzI2MDMsMTcgQEAgaTkxNV9nZW1fZXhlY2J1ZmZlcjJfaW9jdGwoc3Ry
dWN0IGRybV9kZXZpY2UgKmRldiwgdm9pZCAqZGF0YSwNCj4gPiAgCQl1bnNpZ25lZCBpbnQgaTsN
Cj4gPiAgDQo+ID4gIAkJLyogQ29weSB0aGUgbmV3IGJ1ZmZlciBvZmZzZXRzIGJhY2sgdG8gdGhl
IHVzZXIncyBleGVjIGxpc3QuICovDQo+ID4gLQkJdXNlcl9hY2Nlc3NfYmVnaW4oKTsNCj4gPiAr
CQkvKg0KPiA+ICsJCSAqIE5vdGU6IGNvdW50ICogc2l6ZW9mKCp1c2VyX2V4ZWNfbGlzdCkgZG9l
cyBub3Qgb3ZlcmZsb3csDQo+ID4gKwkJICogYmVjYXVzZSB3ZSBjaGVja2VkICdjb3VudCcgaW4g
Y2hlY2tfYnVmZmVyX2NvdW50KCkuDQo+ID4gKwkJICoNCj4gPiArCQkgKiBBbmQgdGhpcyByYW5n
ZSBhbHJlYWR5IGdvdCBlZmZlY3RpdmVseSBjaGVja2VkIGVhcmxpZXINCj4gPiArCQkgKiB3aGVu
IHdlIGRpZCB0aGUgImNvcHlfZnJvbV91c2VyKCkiIGFib3ZlLg0KPiA+ICsJCSAqLw0KPiA+ICsJ
CWlmICghdXNlcl9hY2Nlc3NfYmVnaW4oVkVSSUZZX1dSSVRFLCB1c2VyX2V4ZWNfbGlzdCwNCj4g
PiArCQkJCSAgICAgICBjb3VudCAqIHNpemVvZigqdXNlcl9leGVjX2xpc3QpKSkNCj4gPiArCQkJ
Z290byBlbmRfdXNlcjsNCj4gPiArDQo+ID4gIAkJZm9yIChpID0gMDsgaSA8IGFyZ3MtPmJ1ZmZl
cl9jb3VudDsgaSsrKSB7DQo+ID4gIAkJCWlmICghKGV4ZWMyX2xpc3RbaV0ub2Zmc2V0ICYgVVBE
QVRFKSkNCj4gPiAgCQkJCWNvbnRpbnVlOw0KPiANCj4gTm8gb25lIHNlZW1zIHRvIGhhdmUgdGVz
dC1idWlsdCB0aGlzIGNvZGUsIGl0IGZhaWxzIGhlcmUgb24gdGhlIDQuMTQueQ0KPiBrZXJuZWwg
IDooDQo+IA0KPiBJJ2xsIGdvIGZpeCBpdCB1cCwgYnV0IHBsZWFzZSwgYWx3YXlzIGF0IHRoZSB2
ZXJ5IGxlYXN0LCB0ZXN0IGJ1aWxkIHlvdXINCj4gcGF0Y2hlcyBiZWZvcmUgc2VuZGluZyB0aGVt
IG91dC4uLg0KPiANCj4gdGhhbmtzLA0KDQpTb3JyeSBmb3IgdGhlIGJyZWFrYWdlLiBJdCB3b24n
dCBoYXBwZW4gbmV4dCB0aW1lLg0KDQpjaGVlcnMsDQpNaWxlcw0KDQo+IA0KPiBncmVnIGstaA0K
DQo=

