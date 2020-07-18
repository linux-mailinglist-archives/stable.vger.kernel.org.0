Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF47922482D
	for <lists+stable@lfdr.de>; Sat, 18 Jul 2020 05:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgGRC64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 22:58:56 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:40875 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726262AbgGRC64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 22:58:56 -0400
X-UUID: 9aebe2b8f4c84eddab7362cb0c116591-20200718
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=6gkKHN2VVvizCwFgJMmDy6tc+BUb4z5fDOqpe6ABGnY=;
        b=rHSax3s5IhGzQFxB5dxoiTLclQBbsrH+3cBki8T5WGt5sD5yXkT6LhHyHuOW2eeEJB9vUBx0BHj8GbQGQx7fG1yxgEAJXPljwoAo8k2o5of774lfHCT2rmz4eaTXYN+5D7kd08/p4EI2ktJUnW+YL5NCYlHidk5qL65R5OsZKdk=;
X-UUID: 9aebe2b8f4c84eddab7362cb0c116591-20200718
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1493739415; Sat, 18 Jul 2020 10:58:54 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 18 Jul 2020 10:58:52 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 18 Jul 2020 10:58:52 +0800
Message-ID: <1595041133.23887.4.camel@mtkswgap22>
Subject: Re: [PATCH v2] usb: gadget: configfs: Fix use-after-free issue with
 udc_name
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>, <stable@vger.kernel.org>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>
Date:   Sat, 18 Jul 2020 10:58:53 +0800
In-Reply-To: <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
References: <1594881666-8843-1-git-send-email-macpaul.lin@mediatek.com>
         <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU2F0LCAyMDIwLTA3LTE4IGF0IDEwOjQ1ICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
RnJvbTogRWRkaWUgSHVuZyA8ZWRkaWUuaHVuZ0BtZWRpYXRlay5jb20+DQo+IA0KDQpXZWxsLCBp
dCdzIHN0cmFuZ2UsIEkgc2ltcGx5IHJlcGxhY2VkIHRoZSB1cGxvYWRlcidzIG5hbWUgdG8gbXkN
CmNvbGxlYWd1ZSwgZ2l0IHNlbmQtZW1haWwgcG9wIHVwIHRoaXMgbGluZSBhdXRvbWF0aWNhbGx5
Lg0KDQpTaG91bGRuJ3QgSSBkbyB0aGF0IGtpbmQgb2YgY2hhbmdlLiBJdCBkaWQgbm90IGhhcHBl
bmVkIGJlZm9yZS4NCkRvIEkgbmVlZCB0byBjaGFuZ2UgaXQgYmFjayBhbmQgdXBkYXRlIHBhdGNo
IHYzPw0KIA0KPiBUaGVyZSBpcyBhIHVzZS1hZnRlci1mcmVlIGlzc3VlLCBpZiBhY2Nlc3MgdWRj
X25hbWUNCj4gaW4gZnVuY3Rpb24gZ2FkZ2V0X2Rldl9kZXNjX1VEQ19zdG9yZSBhZnRlciBhbm90
aGVyIGNvbnRleHQNCj4gZnJlZSB1ZGNfbmFtZSBpbiBmdW5jdGlvbiB1bnJlZ2lzdGVyX2dhZGdl
dC4NCj4gDQo+IENvbnRleHQgMToNCj4gZ2FkZ2V0X2Rldl9kZXNjX1VEQ19zdG9yZSgpLT51bnJl
Z2lzdGVyX2dhZGdldCgpLT4NCj4gZnJlZSB1ZGNfbmFtZS0+c2V0IHVkY19uYW1lIHRvIE5VTEwN
Cj4gDQo+IENvbnRleHQgMjoNCj4gZ2FkZ2V0X2Rldl9kZXNjX1VEQ19zaG93KCktPiBhY2Nlc3Mg
dWRjX25hbWUNCj4gDQo+IENhbGwgdHJhY2U6DQo+IGR1bXBfYmFja3RyYWNlKzB4MC8weDM0MA0K
PiBzaG93X3N0YWNrKzB4MTQvMHgxYw0KPiBkdW1wX3N0YWNrKzB4ZTQvMHgxMzQNCj4gcHJpbnRf
YWRkcmVzc19kZXNjcmlwdGlvbisweDc4LzB4NDc4DQo+IF9fa2FzYW5fcmVwb3J0KzB4MjcwLzB4
MmVjDQo+IGthc2FuX3JlcG9ydCsweDEwLzB4MTgNCj4gX19hc2FuX3JlcG9ydF9sb2FkMV9ub2Fi
b3J0KzB4MTgvMHgyMA0KPiBzdHJpbmcrMHhmNC8weDEzOA0KPiB2c25wcmludGYrMHg0MjgvMHgx
NGQwDQo+IHNwcmludGYrMHhlNC8weDEyYw0KPiBnYWRnZXRfZGV2X2Rlc2NfVURDX3Nob3crMHg1
NC8weDY0DQo+IGNvbmZpZ2ZzX3JlYWRfZmlsZSsweDIxMC8weDNhMA0KPiBfX3Zmc19yZWFkKzB4
ZjAvMHg0OWMNCj4gdmZzX3JlYWQrMHgxMzAvMHgyYjQNCj4gU3lTX3JlYWQrMHgxMTQvMHgyMDgN
Cj4gZWwwX3N2Y19uYWtlZCsweDM0LzB4MzgNCj4gDQo+IEFkZCBtdXRleF9sb2NrIHRvIHByb3Rl
Y3QgdGhpcyBraW5kIG9mIHNjZW5hcmlvLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRWRkaWUgSHVu
ZyA8ZWRkaWUuaHVuZ0BtZWRpYXRlay5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE1hY3BhdWwgTGlu
IDxtYWNwYXVsLmxpbkBtZWRpYXRlay5jb20+DQo+IFJldmlld2VkLWJ5OiBQZXRlciBDaGVuIDxw
ZXRlci5jaGVuQG54cC5jb20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IC0tLQ0K
PiBDaGFuZ2VzIGZvciB2MjoNCj4gICAtIEZpeCB0eXBvICVzL2NvbnRleC9jb250ZXh0LCBUaGFu
a3MgUGV0ZXIuDQo+IA0KPiAgZHJpdmVycy91c2IvZ2FkZ2V0L2NvbmZpZ2ZzLmMgfCAxMSArKysr
KysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkNCg0KVGhhbmtzLg0KTWFjcGF1bCBMaW4NCg0K

