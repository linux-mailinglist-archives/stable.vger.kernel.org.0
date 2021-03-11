Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2177D336C8A
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 07:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhCKGyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 01:54:13 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:51427 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230435AbhCKGyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 01:54:01 -0500
X-UUID: 18f687241c5745ffae71f379279041dc-20210311
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=HXvdSSzvJwcQp7ImGoV9GE6S8/ULPWjlIYaMv49d5ww=;
        b=mwWehAuu50llSWl9rhY4UGPEw/phO7v9eV+XYfWvje1f1tZN84LEkMxc8L0ERbvUaPy5YksIfNhIjdyxWXio4EwKj8XrYWXrGPqCXaUxcmFOfVQMchHrEFxelb+OXRjTp7NZhKGM9TMteO3kWcs7pmDCCkpu86uRsAnNoLt5fDg=;
X-UUID: 18f687241c5745ffae71f379279041dc-20210311
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 734091626; Thu, 11 Mar 2021 14:53:55 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 11 Mar 2021 14:53:52 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 14:53:52 +0800
Message-ID: <1615445632.13420.2.camel@mtkswgap22>
Subject: Re: [PATCH v4] usb: gadget: configfs: Fix KASAN use-after-free
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Jim Lin <jilin@nvidia.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
CC:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, <stable@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:53:52 +0800
In-Reply-To: <1615444961-13376-1-git-send-email-macpaul.lin@mediatek.com>
References: <1484647168-30135-1-git-send-email-jilin@nvidia.com>
         <1615444961-13376-1-git-send-email-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 1AFDD4A18497C1AB79C36991DF15FA0620D45CD5E2DE115D246BC0D32C71F9902000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIxLTAzLTExIGF0IDE0OjQyICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
RnJvbTogSmltIExpbiA8amlsaW5AbnZpZGlhLmNvbT4NCj4gDQo+IFdoZW4gZ2FkZ2V0IGlzIGRp
c2Nvbm5lY3RlZCwgcnVubmluZyBzZXF1ZW5jZSBpcyBsaWtlIHRoaXMuDQo+IC4gY29tcG9zaXRl
X2Rpc2Nvbm5lY3QNCj4gLiBDYWxsIHRyYWNlOg0KPiAgIHVzYl9zdHJpbmdfY29weSsweGQwLzB4
MTI4DQo+ICAgZ2FkZ2V0X2NvbmZpZ19uYW1lX2NvbmZpZ3VyYXRpb25fc3RvcmUrMHg0DQo+ICAg
Z2FkZ2V0X2NvbmZpZ19uYW1lX2F0dHJfc3RvcmUrMHg0MC8weDUwDQo+ICAgY29uZmlnZnNfd3Jp
dGVfZmlsZSsweDE5OC8weDFmNA0KPiAgIHZmc193cml0ZSsweDEwMC8weDIyMA0KPiAgIFN5U193
cml0ZSsweDU4LzB4YTgNCj4gLiBjb25maWdmc19jb21wb3NpdGVfdW5iaW5kDQo+IC4gY29uZmln
ZnNfY29tcG9zaXRlX2JpbmQNCj4gDQo+IEluIGNvbmZpZ2ZzX2NvbXBvc2l0ZV9iaW5kLCBpdCBo
YXMNCj4gImNuLT5zdHJpbmdzLnMgPSBjbi0+Y29uZmlndXJhdGlvbjsiDQo+IA0KPiBXaGVuIHVz
Yl9zdHJpbmdfY29weSBpcyBpbnZva2VkLiBpdCB3b3VsZA0KPiBhbGxvY2F0ZSBtZW1vcnksIGNv
cHkgaW5wdXQgc3RyaW5nLCByZWxlYXNlIHByZXZpb3VzIHBvaW50ZWQgbWVtb3J5IHNwYWNlLA0K
PiBhbmQgdXNlIG5ldyBhbGxvY2F0ZWQgbWVtb3J5Lg0KPiANCj4gV2hlbiBnYWRnZXQgaXMgY29u
bmVjdGVkLCBob3N0IHNlbmRzIGRvd24gcmVxdWVzdCB0byBnZXQgaW5mb3JtYXRpb24uDQo+IENh
bGwgdHJhY2U6DQo+ICAgdXNiX2dhZGdldF9nZXRfc3RyaW5nKzB4ZWMvMHgxNjgNCj4gICBsb29r
dXBfc3RyaW5nKzB4NjQvMHg5OA0KPiAgIGNvbXBvc2l0ZV9zZXR1cCsweGEzNC8weDFlZTgNCj4g
DQo+IElmIGdhZGdldCBpcyBkaXNjb25uZWN0ZWQgYW5kIGNvbm5lY3RlZCBxdWlja2x5LCBpbiB0
aGUgZmFpbGVkIGNhc2UsDQo+IGNuLT5jb25maWd1cmF0aW9uIG1lbW9yeSBoYXMgYmVlbiByZWxl
YXNlZCBieSB1c2Jfc3RyaW5nX2NvcHkga2ZyZWUgYnV0DQo+IGNvbmZpZ2ZzX2NvbXBvc2l0ZV9i
aW5kIGhhc24ndCBiZWVuIHJ1biBpbiB0aW1lIHRvIGFzc2lnbiBuZXcgYWxsb2NhdGVkDQo+ICJj
bi0+Y29uZmlndXJhdGlvbiIgcG9pbnRlciB0byAiY24tPnN0cmluZ3MucyIuDQo+IA0KPiBXaGVu
ICJzdHJsZW4ocy0+cykgb2YgdXNiX2dhZGdldF9nZXRfc3RyaW5nIGlzIGJlaW5nIGV4ZWN1dGVk
LCB0aGUgZGFuZ2xpbmcNCj4gbWVtb3J5IGlzIGFjY2Vzc2VkLCAiQlVHOiBLQVNBTjogdXNlLWFm
dGVyLWZyZWUiIGVycm9yIG9jY3Vycy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEppbSBMaW4gPGpp
bGluQG52aWRpYS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE1hY3BhdWwgTGluIDxtYWNwYXVsLmxp
bkBtZWRpYXRlay5jb20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IC0tLQ0KPiBD
aGFuZ2VzIGluIHYyOg0KPiBDaGFuZ2VzIGluIHYzOg0KPiAgLSBDaGFuZ2UgY29tbWl0IGRlc2Ny
aXB0aW9uDQo+IENoYW5nZXMgaW4gdjQ6DQo+ICAtIEZpeCBidWlsZCBlcnJvciBhbmQgYWRhcHQg
cGF0Y2ggdG8ga2VybmVsLTUuMTItcmMxLg0KPiAgICBSZXBsYWNlIGRlZmluaXRpb24gIk1BWF9V
U0JfU1RSSU5HX1dJVEhfTlVMTF9MRU4iIHdpdGgNCj4gICAgIlVTQl9NQVhfU1RSSU5HX1dJVEhf
TlVMTF9MRU4iLg0KPiAgLSBOb3RlOiBUaGUgcGF0Y2ggdjIgYW5kIHYzIGhhcyBiZWVuIHZlcmlm
aWVkIGJ5DQo+ICAgIFRoYWRldSBMaW1hIGRlIFNvdXphIENhc2NhcmRvIDxjYXNjYXJkb0BjYW5v
bmljYWwuY29tPg0KPiAgICBodHRwOi8vc3Bpbmljcy5uZXQvbGlzdHMva2VybmVsL21zZzM4NDA3
OTIuaHRtbA0KDQpEZWFyIENhc2NhcmRvLA0KDQpXb3VsZCB5b3UgcGxlYXNlIGhlbHAgdG8gY29u
ZmlybSBpZiB5b3UndmUgdGVzdGVkIGl0IG9uIExpbnV4IFBDLA0KQ2hyb21lIE9TLCBvciBhbiBB
bmRyb2lkIE9TPw0KDQpUaGFua3MhDQpNYWNwYXVsIExpbg0KDQo+ICAgIGFuZA0KPiAgICBNYWNw
YXVsIExpbiA8bWFjcGF1bC5saW5AbWVkaWF0ZWsuY29tPiBvbiBBbmRyb2lkIGtlcm5lbHMuDQo+
ICAgIGh0dHA6Ly9sa21sLm9yZy9sa21sLzIwMjAvNi8xMS84DQo+ICAtIFRoZSBwYXRjaCBpcyBz
dWdnZXN0ZWQgdG8gYmUgYXBwbGllZCB0byBMVFMgdmVyc2lvbnMuDQo+IA0KPiAgZHJpdmVycy91
c2IvZ2FkZ2V0L2NvbmZpZ2ZzLmMgfCAgIDE0ICsrKysrKysrKystLS0tDQo+ICAxIGZpbGUgY2hh
bmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3VzYi9nYWRnZXQvY29uZmlnZnMuYyBiL2RyaXZlcnMvdXNiL2dhZGdldC9jb25m
aWdmcy5jDQo+IGluZGV4IDBkNTZmMzMuLjE1YTYwN2MgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
dXNiL2dhZGdldC9jb25maWdmcy5jDQo+ICsrKyBiL2RyaXZlcnMvdXNiL2dhZGdldC9jb25maWdm
cy5jDQo+IEBAIC05Nyw2ICs5Nyw4IEBAIHN0cnVjdCBnYWRnZXRfY29uZmlnX25hbWUgew0KPiAg
CXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsNCj4gIH07DQo+ICANCj4gKyNkZWZpbmUgVVNCX01BWF9T
VFJJTkdfV0lUSF9OVUxMX0xFTgkoVVNCX01BWF9TVFJJTkdfTEVOKzEpDQo+ICsNCj4gIHN0YXRp
YyBpbnQgdXNiX3N0cmluZ19jb3B5KGNvbnN0IGNoYXIgKnMsIGNoYXIgKipzX2NvcHkpDQo+ICB7
DQo+ICAJaW50IHJldDsNCj4gQEAgLTEwNiwxMiArMTA4LDE2IEBAIHN0YXRpYyBpbnQgdXNiX3N0
cmluZ19jb3B5KGNvbnN0IGNoYXIgKnMsIGNoYXIgKipzX2NvcHkpDQo+ICAJaWYgKHJldCA+IFVT
Ql9NQVhfU1RSSU5HX0xFTikNCj4gIAkJcmV0dXJuIC1FT1ZFUkZMT1c7DQo+ICANCj4gLQlzdHIg
PSBrc3RyZHVwKHMsIEdGUF9LRVJORUwpOw0KPiAtCWlmICghc3RyKQ0KPiAtCQlyZXR1cm4gLUVO
T01FTTsNCj4gKwlpZiAoY29weSkgew0KPiArCQlzdHIgPSBjb3B5Ow0KPiArCX0gZWxzZSB7DQo+
ICsJCXN0ciA9IGttYWxsb2MoVVNCX01BWF9TVFJJTkdfV0lUSF9OVUxMX0xFTiwgR0ZQX0tFUk5F
TCk7DQo+ICsJCWlmICghc3RyKQ0KPiArCQkJcmV0dXJuIC1FTk9NRU07DQo+ICsJfQ0KPiArCXN0
cmNweShzdHIsIHMpOw0KPiAgCWlmIChzdHJbcmV0IC0gMV0gPT0gJ1xuJykNCj4gIAkJc3RyW3Jl
dCAtIDFdID0gJ1wwJzsNCj4gLQlrZnJlZShjb3B5KTsNCj4gIAkqc19jb3B5ID0gc3RyOw0KPiAg
CXJldHVybiAwOw0KPiAgfQ0KDQo=

