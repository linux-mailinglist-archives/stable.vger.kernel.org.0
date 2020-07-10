Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB6B21AD11
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 04:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGJCar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 22:30:47 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:47983 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726446AbgGJCar (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 22:30:47 -0400
X-UUID: 593811f480164a9ea9c7c0c594f73d8b-20200710
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Kd0C+S4Ayp+24088Gsa5JiqqukKJHb4/Z3Dk20GZNaA=;
        b=rD3EhzO4i+X+SbryJ8Nm4eTbBaXYYDXu/tvU8MWyfwbbt6SFX+bDQ7T9+y8sUZZt20w+Jy8gtnFuOU8S3pMx6rqZ9eMXUPRzIa6WbTT4zM5UTMUhQaqpFmfyB/b+o//4CTXqbSZ7hEUfRXKGtuKmJyhBt9EH/c688eN6j3rIG1s=;
X-UUID: 593811f480164a9ea9c7c0c594f73d8b-20200710
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 299434186; Fri, 10 Jul 2020 10:30:26 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 MTKMBS31N2.mediatek.inc (172.27.4.87) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 10 Jul 2020 10:30:19 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 10 Jul 2020 10:30:18 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Mathias Nyman <mathias.nyman@intel.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] usb: xhci-mtk: fix the failure of bandwidth allocation
Date:   Fri, 10 Jul 2020 10:29:42 +0800
Message-ID: <1594348182-431-1-git-send-email-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 3E47718F58DC4962AF1F31FFDB8BDCC6908A18FE5C4F4A0FE152DF2C456BC00A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlIHdNYXhQYWNrZXRTaXplIGZpZWxkIG9mIGVuZHBvaW50IGRlc2NyaXB0b3IgbWF5IGJlIHpl
cm8NCmFzIGRlZmF1bHQgdmFsdWUgaW4gYWx0ZXJuYXRlIGludGVyZmFjZSwgYW5kIHRoZXkgYXJl
IG5vdA0KYWN0dWFsbHkgc2VsZWN0ZWQgd2hlbiBzdGFydCBzdHJlYW0sIHNvIHNraXAgdGhlbSB3
aGVuIHRyeSB0bw0KYWxsb2NhdGUgYmFuZHdpZHRoLg0KDQpDYzogc3RhYmxlIDxzdGFibGVAdmdl
ci5rZXJuZWwub3JnPg0KU2lnbmVkLW9mZi1ieTogQ2h1bmZlbmcgWXVuIDxjaHVuZmVuZy55dW5A
bWVkaWF0ZWsuY29tPg0KLS0tDQogZHJpdmVycy91c2IvaG9zdC94aGNpLW10ay1zY2guYyB8IDQg
KysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL2hvc3QveGhjaS1tdGstc2NoLmMgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktbXRr
LXNjaC5jDQppbmRleCBmZWE1NTU1Li40NWM1NGQ1NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNi
L2hvc3QveGhjaS1tdGstc2NoLmMNCisrKyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1tdGstc2No
LmMNCkBAIC01NTcsNiArNTU3LDEwIEBAIHN0YXRpYyBib29sIG5lZWRfYndfc2NoKHN0cnVjdCB1
c2JfaG9zdF9lbmRwb2ludCAqZXAsDQogCWlmIChpc19mc19vcl9scyhzcGVlZCkgJiYgIWhhc190
dCkNCiAJCXJldHVybiBmYWxzZTsNCiANCisJLyogc2tpcCBlbmRwb2ludCB3aXRoIHplcm8gbWF4
cGt0ICovDQorCWlmICh1c2JfZW5kcG9pbnRfbWF4cCgmZXAtPmRlc2MpID09IDApDQorCQlyZXR1
cm4gZmFsc2U7DQorDQogCXJldHVybiB0cnVlOw0KIH0NCiANCi0tIA0KMS45LjENCg==

