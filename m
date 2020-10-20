Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD24A293519
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 08:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404443AbgJTGlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 02:41:55 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:49823 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404440AbgJTGlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 02:41:55 -0400
X-UUID: 106dd9294fcd431cb2c5a23ffead6e1c-20201020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=5oMkIsGFoLQ4IdBLm/vtbnr97rCI7oTjafuD1B2qYpM=;
        b=UhARNXEKXnk9UU42lTNFm6DiylUDMdw51fyJGTpz4PSPDMmzqFPy+9t+iSumF/Ciw0sCFymNrREWWc8OuREu0E5eAxH2kzqSQKMDvUEviBhm88ziTlPlp4ACrLQ2UQ65+yquenhDLCUF5v+b+08Fau5AX8cYdE+F/uK6NcnOJj8=;
X-UUID: 106dd9294fcd431cb2c5a23ffead6e1c-20201020
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1294043086; Tue, 20 Oct 2020 14:36:40 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 20 Oct 2020 14:36:38 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Oct 2020 14:36:39 +0800
Message-ID: <1603175799.19799.6.camel@mtkswgap22>
Subject: Re: [PATCH v2] usb: gadget: configfs: Fix use-after-free issue with
 udc_name
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Felipe Balbi <balbi@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        Eddie Hung =?UTF-8?Q?=28=E6=B4=AA=E6=AD=A3=E9=91=AB=29?= 
        <Eddie.Hung@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 20 Oct 2020 14:36:39 +0800
In-Reply-To: <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
References: <1594881666-8843-1-git-send-email-macpaul.lin@mediatek.com>
         <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU2F0LCAyMDIwLTA3LTE4IGF0IDEwOjQ1ICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
RnJvbTogRWRkaWUgSHVuZyA8ZWRkaWUuaHVuZ0BtZWRpYXRlay5jb20+DQo+IFRoZXJlIGlzIGEg
dXNlLWFmdGVyLWZyZWUgaXNzdWUsIGlmIGFjY2VzcyB1ZGNfbmFtZQ0KPiBpbiBmdW5jdGlvbiBn
YWRnZXRfZGV2X2Rlc2NfVURDX3N0b3JlIGFmdGVyIGFub3RoZXIgY29udGV4dA0KPiBmcmVlIHVk
Y19uYW1lIGluIGZ1bmN0aW9uIHVucmVnaXN0ZXJfZ2FkZ2V0Lg0KPiANCj4gQ29udGV4dCAxOg0K
PiBnYWRnZXRfZGV2X2Rlc2NfVURDX3N0b3JlKCktPnVucmVnaXN0ZXJfZ2FkZ2V0KCktPg0KPiBm
cmVlIHVkY19uYW1lLT5zZXQgdWRjX25hbWUgdG8gTlVMTA0KPiANCj4gQ29udGV4dCAyOg0KPiBn
YWRnZXRfZGV2X2Rlc2NfVURDX3Nob3coKS0+IGFjY2VzcyB1ZGNfbmFtZQ0KPiANCj4gQ2FsbCB0
cmFjZToNCj4gZHVtcF9iYWNrdHJhY2UrMHgwLzB4MzQwDQo+IHNob3dfc3RhY2srMHgxNC8weDFj
DQo+IGR1bXBfc3RhY2srMHhlNC8weDEzNA0KPiBwcmludF9hZGRyZXNzX2Rlc2NyaXB0aW9uKzB4
NzgvMHg0NzgNCj4gX19rYXNhbl9yZXBvcnQrMHgyNzAvMHgyZWMNCj4ga2FzYW5fcmVwb3J0KzB4
MTAvMHgxOA0KPiBfX2FzYW5fcmVwb3J0X2xvYWQxX25vYWJvcnQrMHgxOC8weDIwDQo+IHN0cmlu
ZysweGY0LzB4MTM4DQo+IHZzbnByaW50ZisweDQyOC8weDE0ZDANCj4gc3ByaW50ZisweGU0LzB4
MTJjDQo+IGdhZGdldF9kZXZfZGVzY19VRENfc2hvdysweDU0LzB4NjQNCj4gY29uZmlnZnNfcmVh
ZF9maWxlKzB4MjEwLzB4M2EwDQo+IF9fdmZzX3JlYWQrMHhmMC8weDQ5Yw0KPiB2ZnNfcmVhZCsw
eDEzMC8weDJiNA0KPiBTeVNfcmVhZCsweDExNC8weDIwOA0KPiBlbDBfc3ZjX25ha2VkKzB4MzQv
MHgzOA0KPiANCj4gQWRkIG11dGV4X2xvY2sgdG8gcHJvdGVjdCB0aGlzIGtpbmQgb2Ygc2NlbmFy
aW8uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFZGRpZSBIdW5nIDxlZGRpZS5odW5nQG1lZGlhdGVr
LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTWFjcGF1bCBMaW4gPG1hY3BhdWwubGluQG1lZGlhdGVr
LmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFBldGVyIENoZW4gPHBldGVyLmNoZW5AbnhwLmNvbT4NCj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+IENoYW5nZXMgZm9yIHYyOg0KPiAg
IC0gRml4IHR5cG8gJXMvY29udGV4L2NvbnRleHQsIFRoYW5rcyBQZXRlci4NCj4gDQo+ICBkcml2
ZXJzL3VzYi9nYWRnZXQvY29uZmlnZnMuYyB8IDExICsrKysrKysrKy0tDQo+ICAxIGZpbGUgY2hh
bmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdXNiL2dhZGdldC9jb25maWdmcy5jIGIvZHJpdmVycy91c2IvZ2FkZ2V0L2NvbmZp
Z2ZzLmMNCj4gaW5kZXggOWRjMDZhNGUxYjMwLi4yMTExMGIyODY1YjkgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvdXNiL2dhZGdldC9jb25maWdmcy5jDQo+ICsrKyBiL2RyaXZlcnMvdXNiL2dhZGdl
dC9jb25maWdmcy5jDQo+IEBAIC0yMjEsOSArMjIxLDE2IEBAIHN0YXRpYyBzc2l6ZV90IGdhZGdl
dF9kZXZfZGVzY19iY2RVU0Jfc3RvcmUoc3RydWN0IGNvbmZpZ19pdGVtICppdGVtLA0KPiAgDQo+
ICBzdGF0aWMgc3NpemVfdCBnYWRnZXRfZGV2X2Rlc2NfVURDX3Nob3coc3RydWN0IGNvbmZpZ19p
dGVtICppdGVtLCBjaGFyICpwYWdlKQ0KPiAgew0KPiAtCWNoYXIgKnVkY19uYW1lID0gdG9fZ2Fk
Z2V0X2luZm8oaXRlbSktPmNvbXBvc2l0ZS5nYWRnZXRfZHJpdmVyLnVkY19uYW1lOw0KPiArCXN0
cnVjdCBnYWRnZXRfaW5mbyAqZ2kgPSB0b19nYWRnZXRfaW5mbyhpdGVtKTsNCj4gKwljaGFyICp1
ZGNfbmFtZTsNCj4gKwlpbnQgcmV0Ow0KPiArDQo+ICsJbXV0ZXhfbG9jaygmZ2ktPmxvY2spOw0K
PiArCXVkY19uYW1lID0gZ2ktPmNvbXBvc2l0ZS5nYWRnZXRfZHJpdmVyLnVkY19uYW1lOw0KPiAr
CXJldCA9IHNwcmludGYocGFnZSwgIiVzXG4iLCB1ZGNfbmFtZSA/OiAiIik7DQo+ICsJbXV0ZXhf
dW5sb2NrKCZnaS0+bG9jayk7DQo+ICANCj4gLQlyZXR1cm4gc3ByaW50ZihwYWdlLCAiJXNcbiIs
IHVkY19uYW1lID86ICIiKTsNCj4gKwlyZXR1cm4gcmV0Ow0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMg
aW50IHVucmVnaXN0ZXJfZ2FkZ2V0KHN0cnVjdCBnYWRnZXRfaW5mbyAqZ2kpDQoNCkp1c3Qgd2Fu
dCB0byByZW1pbmQgd2UgaGF2ZSBhIGZpeCBoZXJlIGZvciB1c2IvZ2FkZ2V0L2NvbmZpZ2ZzLmMu
DQpJZiB0aGUgcGF0Y2ggbmVlZCB0byBiZSBmdXJ0aGVyIHJldmlzZWQsIHBsZWFzZSBsZXQgdXMg
a25vdy4NCg0KVGhhbmtzIQ0KTWFjcGF1bCBMaW4NCg==

