Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB6C1ECFF4
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 14:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgFCMjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 08:39:33 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:55287 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725833AbgFCMjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 08:39:32 -0400
X-UUID: 1993c3ddeb4148aa96669f9c1f46b448-20200603
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=yGhEBSj32ppLHggwGolq9ctveMSRJ1bICjDVz+fhRnY=;
        b=hegUAZBRX2s60lSecAyLBURD/bAzfG67+p2avShJo+0B4ctRdAv243tcJNqGCY4nACX96hujB458lAOTelcceeGRE0seBkA3ed2eTPmVy8khTI38enrjDpJv5jQmLZzn3WfZDEdyWcbZGipcbKOfTqwEq8KCEvl2CoNHafIfEdU=;
X-UUID: 1993c3ddeb4148aa96669f9c1f46b448-20200603
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1683903012; Wed, 03 Jun 2020 20:39:26 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 3 Jun 2020 20:39:21 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Jun 2020 20:39:23 +0800
Message-ID: <1591187964.23525.61.camel@mtkswgap22>
Subject: Re: [PATCH] sound: usb: pcm: fix incorrect power state when playing
 sound after PM_AUTO suspend
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Takashi Iwai <tiwai@suse.de>
CC:     <alsa-devel@alsa-project.org>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        Hui Wang <hui.wang@canonical.com>,
        Alexander Tsoy <alexander@tsoy.me>,
        <linux-mediatek@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Szabolcs =?UTF-8?Q?Sz=C5=91ke?= <szszoke.code@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Date:   Wed, 3 Jun 2020 20:39:24 +0800
In-Reply-To: <s5h367cfsga.wl-tiwai@suse.de>
References: <s5hpnahhbz8.wl-tiwai@suse.de>
         <1591153515.23525.50.camel@mtkswgap22> <s5heeqwfyti.wl-tiwai@suse.de>
         <s5hblm0fxl0.wl-tiwai@suse.de> <s5h367cfsga.wl-tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIwLTA2LTAzIGF0IDEwOjQ1ICswMjAwLCBUYWthc2hpIEl3YWkgd3JvdGU6DQo+
IE9uIFdlZCwgMDMgSnVuIDIwMjAgMDg6NTQ6NTEgKzAyMDAsDQo+IFRha2FzaGkgSXdhaSB3cm90
ZToNCj4gPiANCj4gPiBPbiBXZWQsIDAzIEp1biAyMDIwIDA4OjI4OjA5ICswMjAwLA0KPiA+IFRh
a2FzaGkgSXdhaSB3cm90ZToNCj4gPiA+IA0KPiA+ID4gQW5kLCB0aGUgbW9zdCBzdXNwaWNpb3Vz
IGNhc2UgaXMgdGhlIGxhc3Qgb25lLA0KPiA+ID4gY2hpcC0+bnVtX3N1c3BlbmRlZC1pbnRmLiAg
SXQgbWVhbnMgdGhhdCB0aGUgZGV2aWNlIGhhcyBtdWx0aXBsZQ0KPiA+ID4gVVNCIGludGVyZmFj
ZXMgYW5kIHRoZXkgd2VudCB0byBzdXNwZW5kLCB3aGlsZSB0aGUgcmVzdW1lIGlzbid0DQo+ID4g
PiBwZXJmb3JtZWQgZm9yIHRoZSBhbGwgc3VzcGVuZGVkIGludGVyZmFjZXMgaW4gcmV0dXJuLg0K
PiA+IA0KPiA+IElmIHRoaXMgaXMgdGhlIGNhdXNlLCBhIHBhdGNoIGxpa2UgYmVsb3cgbWlnaHQg
aGVscC4NCj4gPiBJdCBnZXRzL3B1dHMgdGhlIGFsbCBhc3NpZ25lZCBpbnRlcmZhY2VkIGluc3Rl
YWQgb2Ygb25seSB0aGUgcHJpbWFyeQ0KPiA+IG9uZS4NCj4gDQo+IC4uLiBhbmQgY29uc2lkZXJp
bmcgb2YgdGhlIHByb2JsZW0gYWdhaW4sIHJhdGhlciB0aGUgcGF0Y2ggYmVsb3cgbWlnaHQNCj4g
YmUgdGhlIHJpZ2h0IGFuc3dlci4gIE5vdyB0aGUgZHJpdmVyIHRyaWVzIHRvIHJlbWVtYmVyIGF0
IHdoaWNoIHN0YXRlDQo+IGl0IGVudGVyZWQgaW50byB0aGUgc3lzdGVtLXN1c3BlbmQuICBVcG9u
IHJlc3VtZSwgaW4gcmV0dXJuLCB3aGVuIHRoZQ0KPiBzdGF0ZSByZWFjaGVzIGJhY2sgdG8gdGhh
dCBwb2ludCwgc2V0IHRoZSBjYXJkIHN0YXRlIHRvIEQwLg0KPiANCj4gVGhlIHByZXZpb3VzIHBh
dGNoIGNhbiBiZSBhcHBsaWVkIG9uIHRoZSB0b3AsIHRvbywgYW5kIGl0IG1pZ2h0IGJlDQo+IHdv
cnRoIHRvIGFwcGx5IGJvdGguDQo+IA0KPiBMZXQgbWUga25vdyBpZiBhbnkgb2YgdGhvc2UgYWN0
dWFsbHkgaGVscHMuDQo+IA0KPiANCj4gVGFrYXNoaQ0KDQpUaGFua3MgZm9yIHlvdXIgcmVzcG9u
c2Ugc28gcXVpY2tseS4NCkkndmUganVzdCB0ZXN0IHRoaXMgcGF0Y2ggc2luY2UgaXQgbG9va3Mg
bGlrZSBlbm91Z2ggZm9yIHRoZSBpc3N1ZS4NCg0KVGhpcyBwYXRjaCB3b3JrZWQgc2luY2UgdGhl
IGZsYWcgc3lzdGVtX3N1c3BlbmQgd2lsbCBiZSBzZXQgYXQgdGhlIHNhbWUNCnRpbWUgd2hlbiBw
b3dlciBzdGF0ZSBoYXMgYmVlbiBjaGFuZ2VkLiBJIGhhdmUgMiBpbnRlcmZhY2Ugd2l0aCB0aGUg
aGVhZA0Kc2V0LiBCdXQgYWN0dWFsbHkgdGhlIHByb2JsZW0gaGFwcGVuZWQgd2hlbiBwcmltYXJ5
IG9uZSBpcyBzdXNwZW5kZWQuDQpTbyBJIGRpZG4ndCB0ZXN0IHRoZSBlYXJsaWVyIHBhdGNoICJz
dXNwZW5kIGFsbCBpbnRlcmZhY2UgaW5zdGVhZCBvZg0Kb25seSB0aGUgcHJpbWFyeSBvbmUuIg0K
DQpXaWxsIHlvdSByZXNlbmQgdGhpcyBwYXRjaCBvZmZpY2lhbGx5IGxhdGVyPyBJIHRoaW5rIHRo
aXMgc29sdXRpb24gaXMNCnJlcXVpcmVkIHRvIHNlbmQgdG8gc3RhYmxlLCB0b28uIEl0J3MgYmV0
dGVyIHRvIGhhdmUgaXQgZm9yIG90aGVyIHN0YWJsZQ0Ka2VybmVsIHZlcnNpb25zIGluY2x1ZGUg
YW5kcm9pZCdzLg0KDQo+IC0tLQ0KPiBkaWZmIC0tZ2l0IGEvc291bmQvdXNiL2NhcmQuYyBiL3Nv
dW5kL3VzYi9jYXJkLmMNCj4gLS0tIGEvc291bmQvdXNiL2NhcmQuYw0KPiArKysgYi9zb3VuZC91
c2IvY2FyZC5jDQo+IEBAIC04NDMsOSArODQzLDYgQEAgc3RhdGljIGludCB1c2JfYXVkaW9fc3Vz
cGVuZChzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZiwgcG1fbWVzc2FnZV90IG1lc3NhZ2UpDQo+
ICAJaWYgKGNoaXAgPT0gKHZvaWQgKiktMUwpDQo+ICAJCXJldHVybiAwOw0KPiAgDQo+IC0JY2hp
cC0+YXV0b3N1c3BlbmRlZCA9ICEhUE1TR19JU19BVVRPKG1lc3NhZ2UpOw0KPiAtCWlmICghY2hp
cC0+YXV0b3N1c3BlbmRlZCkNCj4gLQkJc25kX3Bvd2VyX2NoYW5nZV9zdGF0ZShjaGlwLT5jYXJk
LCBTTkRSVl9DVExfUE9XRVJfRDNob3QpOw0KPiAgCWlmICghY2hpcC0+bnVtX3N1c3BlbmRlZF9p
bnRmKyspIHsNCj4gIAkJbGlzdF9mb3JfZWFjaF9lbnRyeShhcywgJmNoaXAtPnBjbV9saXN0LCBs
aXN0KSB7DQo+ICAJCQlzbmRfdXNiX3BjbV9zdXNwZW5kKGFzKTsNCj4gQEAgLTg1OCw2ICs4NTUs
MTEgQEAgc3RhdGljIGludCB1c2JfYXVkaW9fc3VzcGVuZChzdHJ1Y3QgdXNiX2ludGVyZmFjZSAq
aW50ZiwgcG1fbWVzc2FnZV90IG1lc3NhZ2UpDQo+ICAJCQlzbmRfdXNiX21peGVyX3N1c3BlbmQo
bWl4ZXIpOw0KPiAgCX0NCj4gIA0KPiArCWlmICghUE1TR19JU19BVVRPKG1lc3NhZ2UpICYmICFj
aGlwLT5zeXN0ZW1fc3VzcGVuZCkgew0KPiArCQlzbmRfcG93ZXJfY2hhbmdlX3N0YXRlKGNoaXAt
PmNhcmQsIFNORFJWX0NUTF9QT1dFUl9EM2hvdCk7DQo+ICsJCWNoaXAtPnN5c3RlbV9zdXNwZW5k
ID0gY2hpcC0+bnVtX3N1c3BlbmRlZF9pbnRmOw0KPiArCX0NCj4gKw0KPiAgCXJldHVybiAwOw0K
PiAgfQ0KPiAgDQo+IEBAIC04NzEsMTAgKzg3MywxMCBAQCBzdGF0aWMgaW50IF9fdXNiX2F1ZGlv
X3Jlc3VtZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZiwgYm9vbCByZXNldF9yZXN1bWUpDQo+
ICANCj4gIAlpZiAoY2hpcCA9PSAodm9pZCAqKS0xTCkNCj4gIAkJcmV0dXJuIDA7DQo+IC0JaWYg
KC0tY2hpcC0+bnVtX3N1c3BlbmRlZF9pbnRmKQ0KPiAtCQlyZXR1cm4gMDsNCj4gIA0KPiAgCWF0
b21pY19pbmMoJmNoaXAtPmFjdGl2ZSk7IC8qIGF2b2lkIGF1dG9wbSAqLw0KPiArCWlmIChjaGlw
LT5udW1fc3VzcGVuZGVkX2ludGYgPiAxKQ0KPiArCQlnb3RvIG91dDsNCj4gIA0KPiAgCWxpc3Rf
Zm9yX2VhY2hfZW50cnkoYXMsICZjaGlwLT5wY21fbGlzdCwgbGlzdCkgew0KPiAgCQllcnIgPSBz
bmRfdXNiX3BjbV9yZXN1bWUoYXMpOw0KPiBAQCAtODk2LDkgKzg5OCwxMiBAQCBzdGF0aWMgaW50
IF9fdXNiX2F1ZGlvX3Jlc3VtZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZiwgYm9vbCByZXNl
dF9yZXN1bWUpDQo+ICAJCXNuZF91c2JtaWRpX3Jlc3VtZShwKTsNCj4gIAl9DQo+ICANCj4gLQlp
ZiAoIWNoaXAtPmF1dG9zdXNwZW5kZWQpDQo+ICsgb3V0Og0KPiArCWlmIChjaGlwLT5udW1fc3Vz
cGVuZGVkX2ludGYgPT0gY2hpcC0+c3lzdGVtX3N1c3BlbmQpIHsNCj4gIAkJc25kX3Bvd2VyX2No
YW5nZV9zdGF0ZShjaGlwLT5jYXJkLCBTTkRSVl9DVExfUE9XRVJfRDApOw0KPiAtCWNoaXAtPmF1
dG9zdXNwZW5kZWQgPSAwOw0KPiArCQljaGlwLT5zeXN0ZW1fc3VzcGVuZCA9IDA7DQo+ICsJfQ0K
PiArCWNoaXAtPm51bV9zdXNwZW5kZWRfaW50Zi0tOw0KPiAgDQo+ICBlcnJfb3V0Og0KPiAgCWF0
b21pY19kZWMoJmNoaXAtPmFjdGl2ZSk7IC8qIGFsbG93IGF1dG9wbSBhZnRlciB0aGlzIHBvaW50
ICovDQo+IGRpZmYgLS1naXQgYS9zb3VuZC91c2IvdXNiYXVkaW8uaCBiL3NvdW5kL3VzYi91c2Jh
dWRpby5oDQo+IGluZGV4IDFjODkyYzdmMTRkNy4uZTBlYmZiMjVmYmQ1IDEwMDY0NA0KPiAtLS0g
YS9zb3VuZC91c2IvdXNiYXVkaW8uaA0KPiArKysgYi9zb3VuZC91c2IvdXNiYXVkaW8uaA0KPiBA
QCAtMjYsNyArMjYsNyBAQCBzdHJ1Y3Qgc25kX3VzYl9hdWRpbyB7DQo+ICAJc3RydWN0IHVzYl9p
bnRlcmZhY2UgKnBtX2ludGY7DQo+ICAJdTMyIHVzYl9pZDsNCj4gIAlzdHJ1Y3QgbXV0ZXggbXV0
ZXg7DQo+IC0JdW5zaWduZWQgaW50IGF1dG9zdXNwZW5kZWQ6MTsJDQo+ICsJdW5zaWduZWQgaW50
IHN5c3RlbV9zdXNwZW5kOw0KPiAgCWF0b21pY190IGFjdGl2ZTsNCj4gIAlhdG9taWNfdCBzaHV0
ZG93bjsNCj4gIAlhdG9taWNfdCB1c2FnZV9jb3VudDsNCj4gDQo+IF9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ghDQoN
CkJlc3QgcmVnYXJkcywNCk1hY3BhdWwgTGluDQoNCg0K

