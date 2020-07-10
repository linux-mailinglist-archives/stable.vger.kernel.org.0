Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C574821AF13
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 07:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgGJF7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 01:59:05 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:36738 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725966AbgGJF7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 01:59:04 -0400
X-UUID: 8c6f72ef7b134dfaa0591a3f94dd9dbe-20200710
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=3J4M+F0supuqFwxgQsU3V/czRpfnA/Zs7qlL02F271M=;
        b=eaOWi4hboW4xKQFG6Pz2Ttjuvu9LRJe9uYlsgtwdQEAF4M90fJb/wBYfVh/GKmCF8pWrjdL4FcrIO2HrhR+YHGfjvGQevi3sz16QpKqr/LpN/m/Mku0mVEEQHZwOkc7CfDR9ywpuFuVzm23MCU6cnl/6uEjqG6x+Re4YtB8xv9Q=;
X-UUID: 8c6f72ef7b134dfaa0591a3f94dd9dbe-20200710
Received: from mtkcas36.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 1894286242; Fri, 10 Jul 2020 13:58:56 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS32DR.mediatek.inc
 (172.27.6.104) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 10 Jul
 2020 13:58:52 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 10 Jul 2020 13:58:51 +0800
Message-ID: <1594360692.23885.29.camel@mhfsdcap03>
Subject: Re: [PATCH] usb: xhci-mtk: fix the failure of bandwidth allocation
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Nicolas Boichat <drinkcat@chromium.org>
CC:     Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Ikjoon Jang <ikjn@chromium.org>
Date:   Fri, 10 Jul 2020 13:58:12 +0800
In-Reply-To: <CANMq1KA2kT1yLGqhJFBKt4sRzzE6r=ABkSX59S-Mjr8Dg8sTOQ@mail.gmail.com>
References: <1594348182-431-1-git-send-email-chunfeng.yun@mediatek.com>
         <CANMq1KA2kT1yLGqhJFBKt4sRzzE6r=ABkSX59S-Mjr8Dg8sTOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 97B22A963E31DADB986C97287E9D5D6F20148FF6D6DB6C9860D7A8A1AC4405352000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTEwIGF0IDExOjE0ICswODAwLCBOaWNvbGFzIEJvaWNoYXQgd3JvdGU6
DQo+IE9uIEZyaSwgSnVsIDEwLCAyMDIwIGF0IDEwOjMwIEFNIENodW5mZW5nIFl1biA8Y2h1bmZl
bmcueXVuQG1lZGlhdGVrLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBUaGUgd01heFBhY2tldFNpemUg
ZmllbGQgb2YgZW5kcG9pbnQgZGVzY3JpcHRvciBtYXkgYmUgemVybw0KPiA+IGFzIGRlZmF1bHQg
dmFsdWUgaW4gYWx0ZXJuYXRlIGludGVyZmFjZSwgYW5kIHRoZXkgYXJlIG5vdA0KPiA+IGFjdHVh
bGx5IHNlbGVjdGVkIHdoZW4gc3RhcnQgc3RyZWFtLCBzbyBza2lwIHRoZW0gd2hlbiB0cnkgdG8N
Cj4gPiBhbGxvY2F0ZSBiYW5kd2lkdGguDQo+ID4NCj4gPiBDYzogc3RhYmxlIDxzdGFibGVAdmdl
ci5rZXJuZWwub3JnPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENodW5mZW5nIFl1biA8Y2h1bmZlbmcu
eXVuQG1lZGlhdGVrLmNvbT4NCj4gDQo+IEFkZCB0aGlzPw0KPiBGaXhlczogMGNiZDRiMzRjZGE5
ZGZkICgieGhjaTogbWVkaWF0ZWs6IHN1cHBvcnQgTVRLIHhIQ0kgaG9zdCBjb250cm9sbGVyIikN
Ck9rLCB0aGFua3MNCg0KPiANCj4gPiAtLS0NCj4gPiAgZHJpdmVycy91c2IvaG9zdC94aGNpLW10
ay1zY2guYyB8IDQgKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+
ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvaG9zdC94aGNpLW10ay1zY2guYyBiL2Ry
aXZlcnMvdXNiL2hvc3QveGhjaS1tdGstc2NoLmMNCj4gPiBpbmRleCBmZWE1NTU1Li40NWM1NGQ1
NiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktbXRrLXNjaC5jDQo+ID4g
KysrIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLW10ay1zY2guYw0KPiA+IEBAIC01NTcsNiArNTU3
LDEwIEBAIHN0YXRpYyBib29sIG5lZWRfYndfc2NoKHN0cnVjdCB1c2JfaG9zdF9lbmRwb2ludCAq
ZXAsDQo+ID4gICAgICAgICBpZiAoaXNfZnNfb3JfbHMoc3BlZWQpICYmICFoYXNfdHQpDQo+ID4g
ICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gPg0KPiA+ICsgICAgICAgLyogc2tpcCBl
bmRwb2ludCB3aXRoIHplcm8gbWF4cGt0ICovDQo+ID4gKyAgICAgICBpZiAodXNiX2VuZHBvaW50
X21heHAoJmVwLT5kZXNjKSA9PSAwKQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7
DQo+ID4gKw0KPiA+ICAgICAgICAgcmV0dXJuIHRydWU7DQo+ID4gIH0NCj4gPg0KPiA+IC0tDQo+
ID4gMS45LjENCj4gPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXw0KPiA+IExpbnV4LW1lZGlhdGVrIG1haWxpbmcgbGlzdA0KPiA+IExpbnV4LW1lZGlhdGVr
QGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LW1lZGlhdGVrDQoNCg==

