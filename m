Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5782D29E2E6
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 03:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgJ2Cn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 22:43:58 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:60421 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726720AbgJ1VfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:35:13 -0400
X-UUID: b7153164330345f2bd32b659cb69359a-20201029
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=WLEo/31fxwYc8NZ/c76b+9sLBX9X2+RBbZ0M32yrPck=;
        b=TgFUJ4/UZjwL4huZEy5vKD6YLdydp2x6MU7EpNwaP7brMURqXTRTyxcPGRDiPq/c/cHrjQfY4khcBFExOc004RNaYpdpbbNBGf17ZziWoOSTetCP/Quya7kFfpjMqg8xsGcl4ypr17X9kLKqhnWpvxqCzxVOhLhbC8WQWRzjL2o=;
X-UUID: b7153164330345f2bd32b659cb69359a-20201029
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 872883384; Thu, 29 Oct 2020 01:59:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Oct 2020 01:59:13 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Oct 2020 01:59:13 +0800
Message-ID: <1603907954.21794.1.camel@mtkswgap22>
Subject: Re: [PATCH v2] usb: gadget: configfs: Fix use-after-free issue with
 udc_name
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     <macpaul@gmail.com>
CC:     <chunfeng.yun@mediatek.com>, <eddie.hung@mediatek.com>,
        Ainge Hsu <ainge.hsu@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <stable@vger.kernel.org>
Date:   Thu, 29 Oct 2020 01:59:14 +0800
In-Reply-To: <1603907723-19499-1-git-send-email-macpaul.lin@mediatek.com>
References: <1603907723-19499-1-git-send-email-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 6FF4D9C7666B2DA439629EFF15D866C8945F8FB2572A70F92FE3680A91FDC8B62000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTI5IGF0IDAxOjU1ICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
RnJvbTogRWRkaWUgSHVuZyA8ZWRkaWUuaHVuZ0BtZWRpYXRlay5jb20+DQo+IA0KPiBUaGVyZSBp
cyBhIHVzZS1hZnRlci1mcmVlIGlzc3VlLCBpZiBhY2Nlc3MgdWRjX25hbWUNCj4gaW4gZnVuY3Rp
b24gZ2FkZ2V0X2Rldl9kZXNjX1VEQ19zdG9yZSBhZnRlciBhbm90aGVyIGNvbnRleHQNCj4gZnJl
ZSB1ZGNfbmFtZSBpbiBmdW5jdGlvbiB1bnJlZ2lzdGVyX2dhZGdldC4NCj4gDQo+IENvbnRleHQg
MToNCj4gZ2FkZ2V0X2Rldl9kZXNjX1VEQ19zdG9yZSgpLT51bnJlZ2lzdGVyX2dhZGdldCgpLT4N
Cj4gZnJlZSB1ZGNfbmFtZS0+c2V0IHVkY19uYW1lIHRvIE5VTEwNCj4gDQo+IENvbnRleHQgMjoN
Cj4gZ2FkZ2V0X2Rldl9kZXNjX1VEQ19zaG93KCktPiBhY2Nlc3MgdWRjX25hbWUNCj4gDQo+IENh
bGwgdHJhY2U6DQo+IGR1bXBfYmFja3RyYWNlKzB4MC8weDM0MA0KPiBzaG93X3N0YWNrKzB4MTQv
MHgxYw0KPiBkdW1wX3N0YWNrKzB4ZTQvMHgxMzQNCj4gcHJpbnRfYWRkcmVzc19kZXNjcmlwdGlv
bisweDc4LzB4NDc4DQo+IF9fa2FzYW5fcmVwb3J0KzB4MjcwLzB4MmVjDQo+IGthc2FuX3JlcG9y
dCsweDEwLzB4MTgNCj4gX19hc2FuX3JlcG9ydF9sb2FkMV9ub2Fib3J0KzB4MTgvMHgyMA0KPiBz
dHJpbmcrMHhmNC8weDEzOA0KPiB2c25wcmludGYrMHg0MjgvMHgxNGQwDQo+IHNwcmludGYrMHhl
NC8weDEyYw0KPiBnYWRnZXRfZGV2X2Rlc2NfVURDX3Nob3crMHg1NC8weDY0DQo+IGNvbmZpZ2Zz
X3JlYWRfZmlsZSsweDIxMC8weDNhMA0KPiBfX3Zmc19yZWFkKzB4ZjAvMHg0OWMNCj4gdmZzX3Jl
YWQrMHgxMzAvMHgyYjQNCj4gU3lTX3JlYWQrMHgxMTQvMHgyMDgNCj4gZWwwX3N2Y19uYWtlZCsw
eDM0LzB4MzgNCj4gDQo+IEFkZCBtdXRleF9sb2NrIHRvIHByb3RlY3QgdGhpcyBraW5kIG9mIHNj
ZW5hcmlvLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRWRkaWUgSHVuZyA8ZWRkaWUuaHVuZ0BtZWRp
YXRlay5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE1hY3BhdWwgTGluIDxtYWNwYXVsLmxpbkBtZWRp
YXRlay5jb20+DQo+IFJldmlld2VkLWJ5OiBQZXRlciBDaGVuIDxwZXRlci5jaGVuQG54cC5jb20+
DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IC0tLQ0KPiBDaGFuZ2VzIGZvciB2MjoN
Cj4gICAtIEZpeCB0eXBvICVzL2NvbnRleC9jb250ZXh0LCBUaGFua3MgUGV0ZXIuDQo+IA0KPiAg
ZHJpdmVycy91c2IvZ2FkZ2V0L2NvbmZpZ2ZzLmMgfCAgIDExICsrKysrKysrKy0tDQo+ICAxIGZp
bGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdXNiL2dhZGdldC9jb25maWdmcy5jIGIvZHJpdmVycy91c2IvZ2FkZ2V0
L2NvbmZpZ2ZzLmMNCj4gaW5kZXggNTYwNTFiYi4uZDk3NDNmNCAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy91c2IvZ2FkZ2V0L2NvbmZpZ2ZzLmMNCj4gKysrIGIvZHJpdmVycy91c2IvZ2FkZ2V0L2Nv
bmZpZ2ZzLmMNCj4gQEAgLTIyMSw5ICsyMjEsMTYgQEAgc3RhdGljIHNzaXplX3QgZ2FkZ2V0X2Rl
dl9kZXNjX2JjZFVTQl9zdG9yZShzdHJ1Y3QgY29uZmlnX2l0ZW0gKml0ZW0sDQo+ICANCj4gIHN0
YXRpYyBzc2l6ZV90IGdhZGdldF9kZXZfZGVzY19VRENfc2hvdyhzdHJ1Y3QgY29uZmlnX2l0ZW0g
Kml0ZW0sIGNoYXIgKnBhZ2UpDQo+ICB7DQo+IC0JY2hhciAqdWRjX25hbWUgPSB0b19nYWRnZXRf
aW5mbyhpdGVtKS0+Y29tcG9zaXRlLmdhZGdldF9kcml2ZXIudWRjX25hbWU7DQo+ICsJc3RydWN0
IGdhZGdldF9pbmZvICpnaSA9IHRvX2dhZGdldF9pbmZvKGl0ZW0pOw0KPiArCWNoYXIgKnVkY19u
YW1lOw0KPiArCWludCByZXQ7DQo+ICsNCj4gKwltdXRleF9sb2NrKCZnaS0+bG9jayk7DQo+ICsJ
dWRjX25hbWUgPSBnaS0+Y29tcG9zaXRlLmdhZGdldF9kcml2ZXIudWRjX25hbWU7DQo+ICsJcmV0
ID0gc3ByaW50ZihwYWdlLCAiJXNcbiIsIHVkY19uYW1lID86ICIiKTsNCj4gKwltdXRleF91bmxv
Y2soJmdpLT5sb2NrKTsNCj4gIA0KPiAtCXJldHVybiBzcHJpbnRmKHBhZ2UsICIlc1xuIiwgdWRj
X25hbWUgPzogIiIpOw0KPiArCXJldHVybiByZXQ7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyBpbnQg
dW5yZWdpc3Rlcl9nYWRnZXQoc3RydWN0IGdhZGdldF9pbmZvICpnaSkNCg0KU29ycnksIGl0IGxv
b2tzIGxpa2Ugc3RpbGwgYSBiYXNlNjQgZW5jb2RlZCBtYWlsLg0KSSdsbCBmZWVkYmFjayB0byBv
dXIgSVQgZGVwYXJ0bWVudCBhZ2Fpbi4NClBsZWFzZSBpZ25vcmUgdGhpcyBtYWlsLg0KDQpUaGFu
a3MNCk1hY3BhdWwgTGluDQoNCg==

