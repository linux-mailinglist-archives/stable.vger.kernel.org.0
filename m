Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31614228DCF
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 03:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbgGVB7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 21:59:35 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:29639 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731621AbgGVB7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 21:59:35 -0400
X-UUID: 507314be90494080be33d838767b4236-20200722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=HBs3aJUcIVxX1irCDgPsr1t6Sr5uliFctbO3YQ/k1Z0=;
        b=hCj36RiEwIWbCdUWFFXm6ZVLELzbf7n6NNUclkHRzM6SZFmO5xaTMdJxTgH3hLLiYPHydUdkMURVM7mxcweXJ15cclEAPYZB8931jNp9Zk48q37kGzSza8GfXZyGpQfmbYCkcZP9UpBjAu9KHYv7wuKnOT8LQ+5yOmWozy6OoB0=;
X-UUID: 507314be90494080be33d838767b4236-20200722
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1814161564; Wed, 22 Jul 2020 09:59:31 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 22 Jul 2020 09:59:29 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 09:59:29 +0800
Message-ID: <1595383170.14937.2.camel@mtkswgap22>
Subject: Re: [PATCH v2] usb: gadget: configfs: Fix use-after-free issue with
 udc_name
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Felipe Balbi <balbi@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>, <stable@vger.kernel.org>,
        "Mediatek WSD Upstream" <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>
Date:   Wed, 22 Jul 2020 09:59:30 +0800
In-Reply-To: <20200721113353.GA1686460@kroah.com>
References: <1594881666-8843-1-git-send-email-macpaul.lin@mediatek.com>
         <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
         <1595041133.23887.4.camel@mtkswgap22> <20200721113353.GA1686460@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTIxIGF0IDEzOjMzICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IE9uIFNhdCwgSnVsIDE4LCAyMDIwIGF0IDEwOjU4OjUzQU0gKzA4MDAsIE1hY3BhdWwg
TGluIHdyb3RlOg0KPiA+IE9uIFNhdCwgMjAyMC0wNy0xOCBhdCAxMDo0NSArMDgwMCwgTWFjcGF1
bCBMaW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBFZGRpZSBIdW5nIDxlZGRpZS5odW5nQG1lZGlhdGVr
LmNvbT4NCj4gPiA+IA0KPiA+IA0KPiA+IFdlbGwsIGl0J3Mgc3RyYW5nZSwgSSBzaW1wbHkgcmVw
bGFjZWQgdGhlIHVwbG9hZGVyJ3MgbmFtZSB0byBteQ0KPiA+IGNvbGxlYWd1ZSwgZ2l0IHNlbmQt
ZW1haWwgcG9wIHVwIHRoaXMgbGluZSBhdXRvbWF0aWNhbGx5Lg0KPiA+IA0KPiA+IFNob3VsZG4n
dCBJIGRvIHRoYXQga2luZCBvZiBjaGFuZ2UuIEl0IGRpZCBub3QgaGFwcGVuZWQgYmVmb3JlLg0K
PiA+IERvIEkgbmVlZCB0byBjaGFuZ2UgaXQgYmFjayBhbmQgdXBkYXRlIHBhdGNoIHYzPw0KPiAN
Cj4gV2hvIGlzIHRoZSByZWFsIGF1dGhvciBvZiB0aGlzLCBFZGRpZSBvciB5b3U/ICBJZiBFZGRp
ZSwgdGhpcyBpcw0KPiBjb3JyZWN0LCBpZiB5b3UsIGl0IGlzIG5vdC4NCj4gDQo+IHRoYW5rcywN
Cj4gDQo+IGdyZWcgay1oDQoNCkl0IGlzIEVkZGllISBJIGp1c3QgY2hhbmdlZCB0aGUgdXBsb2Fk
ZXIgdG8gdGhlIGNvcnJlY3QgYXV0aG9yIGZyb20gbXkNCndvcmtpbmcgdHJlZSENClRoYW5rcyEN
Cg0KUmVnYXJkcywNCk1hY3BhdWwgTGluDQoNCg==

