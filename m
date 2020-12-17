Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2B92DCF81
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 11:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgLQK3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 05:29:40 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:34951 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726488AbgLQK3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 05:29:39 -0500
X-UUID: 93d1136e26624109865faab7044a0562-20201217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=NJ+Woh3w6z3vlb9GDrGYWFJxOWvffKrwn6YuBZHwOtc=;
        b=Ppqa+J3vMg1YMA91Ftz9KtwxAUJaoiiFnP8wTshgK0X34nG1coQ+oZlNT88mVpfbxQ3V8Bf7KXY4uqsNYKqS5kdTuhOWhZ8NG8xZOgVweGQGAw6GKw0A/I6FDgHH20KShSDgMiPI+reX8+jpwWC+ImwKF1SupzQkKbzA7I38NRo=;
X-UUID: 93d1136e26624109865faab7044a0562-20201217
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <kuan-ying.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1630589223; Thu, 17 Dec 2020 18:28:51 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 17 Dec 2020 18:28:47 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 18:28:47 +0800
Message-ID: <1608200928.31376.37.camel@mtksdccf07>
Subject: Re: [PATCH 1/1] kasan: fix memory leak of kasan quarantine
From:   Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>
CC:     Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <stable@vger.kernel.org>
Date:   Thu, 17 Dec 2020 18:28:48 +0800
In-Reply-To: <1608031683-24967-2-git-send-email-Kuan-Ying.Lee@mediatek.com>
References: <1608031683-24967-1-git-send-email-Kuan-Ying.Lee@mediatek.com>
         <1608031683-24967-2-git-send-email-Kuan-Ying.Lee@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 2752E72A10EB865FFDCC2B6C40094E72E1BF4CF53284D1973037E26C5DE696AE2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIwLTEyLTE1IGF0IDE5OjI4ICswODAwLCBLdWFuLVlpbmcgTGVlIHdyb3RlOg0K
PiBXaGVuIGNwdSBpcyBnb2luZyBvZmZsaW5lLCBzZXQgcS0+b2ZmbGluZSBhcyB0cnVlDQo+IGFu
ZCBpbnRlcnJ1cHQgaGFwcGVuZWQuIFRoZSBpbnRlcnJ1cHQgbWF5IGNhbGwgdGhlDQo+IHF1YXJh
bnRpbmVfcHV0LiBCdXQgcXVhcmFudGluZV9wdXQgZG8gbm90IGZyZWUgdGhlDQo+IHRoZSBvYmpl
Y3QuIFRoZSBvYmplY3Qgd2lsbCBjYXVzZSBtZW1vcnkgbGVhay4NCj4gDQo+IEFkZCBxbGlua19m
cmVlKCkgdG8gZnJlZSB0aGUgb2JqZWN0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS3Vhbi1ZaW5n
IExlZSA8S3Vhbi1ZaW5nLkxlZUBtZWRpYXRlay5jb20+DQo+IENjOiBBbmRyZXkgUnlhYmluaW4g
PGFyeWFiaW5pbkB2aXJ0dW96em8uY29tPg0KPiBDYzogQWxleGFuZGVyIFBvdGFwZW5rbyA8Z2xp
ZGVyQGdvb2dsZS5jb20+DQo+IENjOiBEbWl0cnkgVnl1a292IDxkdnl1a292QGdvb2dsZS5jb20+
DQo+IENjOiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiBDYzog
TWF0dGhpYXMgQnJ1Z2dlciA8bWF0dGhpYXMuYmdnQGdtYWlsLmNvbT4NCj4gQ2M6IDxzdGFibGVA
dmdlci5rZXJuZWwub3JnPiAgICBbNS4xMC1dDQo+IC0tLQ0KPiAgbW0va2FzYW4vcXVhcmFudGlu
ZS5jIHwgMSArDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9tbS9rYXNhbi9xdWFyYW50aW5lLmMgYi9tbS9rYXNhbi9xdWFyYW50aW5lLmMNCj4g
aW5kZXggMGUzZjg0OTQ2MjhmLi5jYWM3YzYxN2RmNzIgMTAwNjQ0DQo+IC0tLSBhL21tL2thc2Fu
L3F1YXJhbnRpbmUuYw0KPiArKysgYi9tbS9rYXNhbi9xdWFyYW50aW5lLmMNCj4gQEAgLTE5MSw2
ICsxOTEsNyBAQCB2b2lkIHF1YXJhbnRpbmVfcHV0KHN0cnVjdCBrYXNhbl9mcmVlX21ldGEgKmlu
Zm8sIHN0cnVjdCBrbWVtX2NhY2hlICpjYWNoZSkNCj4gIA0KPiAgCXEgPSB0aGlzX2NwdV9wdHIo
JmNwdV9xdWFyYW50aW5lKTsNCj4gIAlpZiAocS0+b2ZmbGluZSkgew0KPiArCQlxbGlua19mcmVl
KCZpbmZvLT5xdWFyYW50aW5lX2xpbmssIGNhY2hlKTsNCj4gIAkJbG9jYWxfaXJxX3Jlc3RvcmUo
ZmxhZ3MpOw0KPiAgCQlyZXR1cm47DQo+ICAJfQ0KDQpTb3JyeS4NCg0KUGxlYXNlIGlnbm9yZSB0
aGlzIHBhdGNoLg0KDQpUaGFua3MuDQo=

