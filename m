Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF271714F1
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 11:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgB0K2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 05:28:33 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:17818 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728652AbgB0K2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 05:28:33 -0500
X-UUID: 595f9f8033474e46bb46bd07602317cc-20200227
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=LEaZatPGQmSTfFljV7UsLw7F1kUhEvQfFkNEr7oUNNE=;
        b=hd69dLLIulXRKM4L8dzuOAO0bc1n/LqO4Bhzsq3RRc2lahOAQhpDH9w3rmsK11b6U8vR8PeQ4wr0qnSGQ/IKcO4CalqELPXGuEcAtu+YW1+8LXEs5WpjAm+mseCw5vP84MA+PGvooxwUv6wwQdiFalQUrJa3E2qi5KTTfwa+EYI=;
X-UUID: 595f9f8033474e46bb46bd07602317cc-20200227
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 198747016; Thu, 27 Feb 2020 18:28:27 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 27 Feb 2020 18:28:25 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 27 Feb 2020 18:28:13 +0800
Message-ID: <1582799305.12083.12.camel@mtkswgap22>
Subject: Re: [PATCH v4] usb: gadget: f_fs: try to fix AIO issue under ARM 64
 bit TAGGED mode
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Shen Jing <jingx.shen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Jerry Zhang <zhangjerry@google.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        CC Hwang <cc.hwang@mediatek.com>,
        Loda Chou <loda.chou@mediatek.com>,
        Al Viro <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>,
        <andreyknvl@google.com>, Peter Chen <peter.chen@nxp.com>,
        Miles Chen <miles.chen@mediatek.com>
Date:   Thu, 27 Feb 2020 18:28:25 +0800
In-Reply-To: <20200227095521.GA3281767@arrakis.emea.arm.com>
References: <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
         <1582718512-28923-1-git-send-email-macpaul.lin@mediatek.com>
         <20200227095521.GA3281767@arrakis.emea.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTAyLTI3IGF0IDA5OjU1ICswMDAwLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6
DQo+IE9uIFdlZCwgRmViIDI2LCAyMDIwIGF0IDA4OjAxOjUyUE0gKzA4MDAsIE1hY3BhdWwgTGlu
IHdyb3RlOg0KPiA+IFRoaXMgaXNzdWUgd2FzIGZvdW5kIHdoZW4gYWRiZCB0cnlpbmcgdG8gb3Bl
biBmdW5jdGlvbmZzIHdpdGggQUlPIG1vZGUuDQo+ID4gVXN1YWxseSwgd2UgbmVlZCB0byBzZXQg
InNldHByb3Agc3lzLnVzYi5mZnMuYWlvX2NvbXBhdCAwIiB0byBlbmFibGUNCj4gPiBhZGJkIHdp
dGggQUlPIG1vZGUgb24gQW5kcm9pZC4NCj4gPiANCj4gPiBXaGVuIGFkYmQgaXMgb3BlbmluZyBm
dW5jdGlvbmZzLCBpdCB3aWxsIHRyeSB0byByZWFkIDI0IGJ5dGVzIGF0IHRoZQ0KPiA+IGZpcnN0
IHJlYWQgSS9PIGNvbnRyb2wuIElmIHRoaXMgcmVhZGluZyBoYXMgYmVlbiBmYWlsZWQsIGFkYmQg
d2lsbA0KPiA+IHRyeSB0byBzZW5kIEZVTkNUSU9ORlNfQ0xFQVJfSEFMVCB0byBmdW5jdGlvbmZz
LiBXaGVuIGFkYmQgaXMgaW4gQUlPDQo+ID4gbW9kZSwgZnVuY3Rpb25mcyB3aWxsIGJlIGFjdGVk
IHdpdGggYXN5bmNyb25pemVkIEkvTyBwYXRoLiBBZnRlciB0aGUNCj4gPiBzdWNjZXNzZnVsIHJl
YWQgdHJhbnNmZXIgaGFzIGJlZW4gY29tcGxldGVkIGJ5IGdhZGdldCBoYXJkd2FyZSwgdGhlDQo+
ID4gZm9sbG93aW5nIHNlcmllcyBvZiBmdW5jdGlvbnMgd2lsbCBiZSBjYWxsZWQuDQo+ID4gICBm
ZnNfZXBmaWxlX2FzeW5jX2lvX2NvbXBsZXRlKCkgLT4gZmZzX3VzZXJfY29weV93b3JrZXIoKSAt
Pg0KPiA+ICAgICBjb3B5X3RvX2l0ZXIoKSAtPiBfY29weV90b19pdGVyKCkgLT4gY29weW91dCgp
IC0+DQo+ID4gICAgIGl0ZXJhdGVfYW5kX2FkdmFuY2UoKSAtPiBpdGVyYXRlX2lvdmVjKCkNCj4g
PiANCj4gPiBBZGRpbmcgZGVidWcgdHJhY2UgdG8gdGhlc2UgZnVuY3Rpb25zLCBpdCBoYXMgYmVl
biBmb3VuZCB0aGF0IGluDQo+ID4gY29weW91dCgpLCBhY2Nlc3Nfb2soKSB3aWxsIGNoZWNrIGlm
IHRoZSB1c2VyIHNwYWNlIGFkZHJlc3MgaXMgdmFsaWQNCj4gPiB0byB3cml0ZS4gSG93ZXZlciBp
ZiBDT05GSUdfQVJNNjRfVEFHR0VEX0FERFJfQUJJIGlzIGVuYWJsZWQsIGFkYmQNCj4gPiBhbHdh
eXMgcGFzc2VzIHVzZXIgc3BhY2UgYWRkcmVzcyBzdGFydCB3aXRoICIweDNDIiB0byBnYWRnZXQn
cyBBSU8NCj4gPiBibG9ja3MuIFRoaXMgdGFnZ2VkIGFkZHJlc3Mgd2lsbCBjYXVzZSBhY2Nlc3Nf
b2soKSBjaGVjayBhbHdheXMgZmFpbC4NCj4gPiBXaGljaCBjYXVzZXMgbGF0ZXIgY2FsY3VsYXRp
b24gaW4gaXRlcmF0ZV9pb3ZlYygpIHR1cm4gemVyby4NCj4gPiBDb3B5b3V0KCkgd29uJ3QgY29w
eSBkYXRhIHRvIHVzZXIgc3BhY2Ugc2luY2UgdGhlIGxlbmd0aCB0byBiZSBjb3BpZWQNCj4gPiAi
di5pb3ZfbGVuIiB3aWxsIGJlIHplcm8uIEZpbmFsbHkgbGVhZHMgZmZzX2NvcHlfdG9faXRlcigp
IGFsd2F5cyByZXR1cm4NCj4gPiAtRUZBVUxULCBjYXVzZXMgYWRiZCBjYW5ub3Qgb3BlbiBmdW5j
dGlvbmZzIGFuZCBzZW5kDQo+ID4gRlVOQ1RJT05GU19DTEVBUl9IQUxULg0KPiA+IA0KPiA+IFNp
Z25lZC1vZmYtYnk6IE1hY3BhdWwgTGluIDxtYWNwYXVsLmxpbkBtZWRpYXRlay5jb20+DQo+ID4g
Q2M6IFBldGVyIENoZW4gPHBldGVyLmNoZW5AbnhwLmNvbT4NCj4gPiBDYzogQ2F0YWxpbiBNYXJp
bmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT4NCj4gPiBDYzogTWlsZXMgQ2hlbiA8bWlsZXMu
Y2hlbkBtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gQ2hhbmdlcyBmb3IgdjQ6DQo+ID4gICAt
IEFiYW5kb24gc29sdXRpb24gdjMgYnkgYWRkaW5nICJUSUZfVEFHR0VEX0FERFIiIGZsYWcgdG8g
Z2FkZ2V0IGRyaXZlci4NCj4gPiAgICAgQWNjb3JkaW5nIHRvIENhdGFsaW4ncyBzdWdnZXN0aW9u
LCBjaGFuZ2UgdGhlIHNvbHV0aW9uIGJ5IHVudGFnZ2luZyANCj4gPiAgICAgdXNlciBzcGFjZSBh
ZGRyZXNzIHBhc3NlZCBieSBBSU8gaW4gZ2FkZ2V0IGRyaXZlci4NCj4gDQo+IFdlbGwsIHRoaXMg
d2FzIHN1Z2dlc3RlZCBpbiBjYXNlIHlvdSBoYXZlIGEgc3Ryb25nIHJlYXNvbiBub3QgdG8gZG8g
dGhlDQo+IHVudGFnZ2luZyBpbiBhZGJkLiBBcyBJIHNhaWQsIHRhZ2dlZCBwb2ludGVycyBpbiB1
c2VyIHNwYWNlIHdlcmUNCj4gc3VwcG9ydGVkIGxvbmcgYmVmb3JlIHdlIGludHJvZHVjZWQgQ09O
RklHX0FSTTY0X1RBR0dFRF9BRERSX0FCSS4gSG93DQo+IGRpZCBhZGIgY29wZSB3aXRoIHN1Y2gg
dGFnZ2VkIHBvaW50ZXJzIGJlZm9yZT8gSXQgd2FzIG5vdCBzdXBwb3NlZCB0bw0KPiBwYXNzIHRo
ZW0gdG8gdGhlIGtlcm5lbC4NCg0KVGhhbmsgZm9yIHlvdXIgZXhwbGFuYXRpb24uIFNpbmNlIGFk
YmQgd2FzIGRldmVsb3BlZCBieSBHb29nbGUgYW5kIHdlDQpjYW4gb25seSBzdWdnZXN0IChsaWtl
LCBmaWxlIGFuIGlzc3VlKSB0byB0aGVtLiBIZXJlIHByb3ZpZGVzIGENCnRlbXBvcmFyeSBzb2x1
dGlvbiBmb3Igb3RoZXIgZGV2ZWxvcGVyIHRvIHNvbHZlIHRoZXJlIG5lZWRzIGluIGEgc2hvcnQN
CnBlcmlvZC4gWWVzLCBJIHVuZGVyc3Rvb2Qgbm90IHN1cHBvc2VkIHRvIHBhc3MgdGhvc2UgdGFn
Z2VkIHBvaW50ZXJzIHRvDQprZXJuZWwgYW5kIHdpbGwgYWxzbyBleHBsYWluIHRoaXMgdG8gR29v
Z2xlIGFkYmQgb3duZXJzLg0KDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2dhZGdldC9m
dW5jdGlvbi9mX2ZzLmMgYi9kcml2ZXJzL3VzYi9nYWRnZXQvZnVuY3Rpb24vZl9mcy5jDQo+ID4g
aW5kZXggY2UxZDAyMy4uMTkyOTM1ZiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3VzYi9nYWRn
ZXQvZnVuY3Rpb24vZl9mcy5jDQo+ID4gKysrIGIvZHJpdmVycy91c2IvZ2FkZ2V0L2Z1bmN0aW9u
L2ZfZnMuYw0KPiA+IEBAIC03MTUsNyArNzE1LDIwIEBAIHN0YXRpYyB2b2lkIGZmc19lcGZpbGVf
aW9fY29tcGxldGUoc3RydWN0IHVzYl9lcCAqX2VwLCBzdHJ1Y3QgdXNiX3JlcXVlc3QgKnJlcSkN
Cj4gPiAgDQo+ID4gIHN0YXRpYyBzc2l6ZV90IGZmc19jb3B5X3RvX2l0ZXIodm9pZCAqZGF0YSwg
aW50IGRhdGFfbGVuLCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIpDQo+ID4gIHsNCj4gPiAtCXNzaXpl
X3QgcmV0ID0gY29weV90b19pdGVyKGRhdGEsIGRhdGFfbGVuLCBpdGVyKTsNCj4gPiArCXNzaXpl
X3QgcmV0Ow0KPiA+ICsNCj4gPiArI2lmIGRlZmluZWQoQ09ORklHX0FSTTY0KQ0KPiA+ICsJLyoN
Cj4gPiArCSAqIFJlcGxhY2UgdGFnZ2VkIGFkZHJlc3MgcGFzc2VkIGJ5IHVzZXIgc3BhY2UgYXBw
bGljYXRpb24gYmVmb3JlDQo+ID4gKwkgKiBjb3B5aW5nLg0KPiA+ICsJICovDQo+ID4gKwlpZiAo
SVNfRU5BQkxFRChDT05GSUdfQVJNNjRfVEFHR0VEX0FERFJfQUJJKSAmJg0KPiA+ICsJCShpdGVy
LT50eXBlID09IElURVJfSU9WRUMpKSB7DQo+ID4gKwkJKih1bnNpZ25lZCBsb25nICopJml0ZXIt
Pmlvdi0+aW92X2Jhc2UgPQ0KPiA+ICsJCQkodW5zaWduZWQgbG9uZyl1bnRhZ2dlZF9hZGRyKGl0
ZXItPmlvdi0+aW92X2Jhc2UpOw0KPiA+ICsJfQ0KPiA+ICsjZW5kaWYNCj4gPiArCXJldCA9IGNv
cHlfdG9faXRlcihkYXRhLCBkYXRhX2xlbiwgaXRlcik7DQo+IA0KPiBIZXJlIHlvdSBzaG91bGQg
cHJvYmFibHkgZHJvcCBhbGwgdGhlICNpZmRlZnMgYW5kIElTX0VOQUJMRUQgY2hlY2tzDQo+IHNp
bmNlIHVudGFnZ2VkX2FkZHIoKSBpcyBkZWZpbmVkIGdsb2JhbGx5IGFzIGEgbm8tb3AgKGFuZCBv
dmVycmlkZGVuIGJ5DQo+IGFybTY0IGFuZCBzcGFyYykuDQo+IA0KPiBQbGVhc2UgZG9uJ3Qgc2Vu
ZCBhbm90aGVyIHBhdGNoIHVudGlsIHdlIHVuZGVyc3RhbmQgKGEpIHdoZXRoZXIgdGhpcyBpcw0K
PiBhIHVzZXItc3BhY2UgcHJvYmxlbSB0byBmaXggb3IgKGIpIGlmIHdlIGZpeCBpdCBpbiB0aGUg
a2VybmVsLCBpcyB0aGlzDQo+IHRoZSBvbmx5L3JpZ2h0IHBsYWNlPyBJZiB3ZSBzZXR0bGUgZm9y
IHRoZSBpbi1rZXJuZWwgdW50YWdnaW5nLCBkbyB3ZQ0KPiBleHBsaWNpdGx5IHVudGFnIHRoZSBh
ZGRyZXNzZXMgaW4gc3VjaCBrZXJuZWwgdGhyZWFkcyBvciB3ZSBkZWZhdWx0IHRvDQo+IFRJRl9U
QUdHRURfQUREUiBmb3IgYWxsIGtlcm5lbCB0aHJlYWRzLCBpbiBjYXNlIHRoZXkgZXZlciBjYWxs
IHVzZV9tbSgpDQo+IChvciB3ZSBjb3VsZCBldmVuIGhvb2sgc29tZXRoaW5nIGluIHVzZV9tbSgp
IHRvIHNldCB0aGlzIFRJRiBmbGFnDQo+IHRlbXBvcmFyaWx5KS4NCj4gDQo+IExvb2tpbmcgZm9y
IGZlZWRiYWNrIGZyb20gdGhlIEFuZHJvaWQgZm9sayBhbmQgYSBiZXR0ZXIgYW5hbHlzaXMgb2Yg
dGhlDQo+IHBvc3NpYmxlIHNvbHV0aW9uLg0KPiANCg0KSWYgd2UgaGF2ZSBhbnkgZnVydGhlciB1
cGRhdGUgYWJvdXQgdGhpcyB1c2VyIHNwYWNlIGlzc3VlLCBJJ2xsIHVwZGF0ZQ0KdGhlIHNvbHV0
aW9uIHRvIHRoaXMgdGhyZWFkIGZvciBvdGhlciBkZXZlbG9wZXJzIHdobyBuZWVkIHRvIHNvbHZl
IHRoaXMNCmlzc3VlLg0KDQpUaGFua3MhDQpNYWNwYXVsIExpbg0KDQo=

