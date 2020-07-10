Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D341221AF10
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 07:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgGJF67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 01:58:59 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:2731 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726288AbgGJF67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 01:58:59 -0400
X-UUID: 608734bb72ea495f801e4bd979a00c26-20200710
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=NXSoc40w/vzs0ddT+Wgmf68IXPtgdbuXrs4l5A4rBb8=;
        b=QbSlvJqPSnMFhxDlQjAwuFfqCFVI8kw/C7eolqgnJz5u2aKy00V+DxPsVgxoWxdDdDoLi3iddwQt7gT09KYlLmZRn0W3Kcxkq69Zf5jpDlxhrofjBPuxqcggQy6vfLBc+hJ+wEu+6uqetrP7p/GYtuhk2NOeiG8jh1k0uXpWgHc=;
X-UUID: 608734bb72ea495f801e4bd979a00c26-20200710
Received: from mtkcas36.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 758997052; Fri, 10 Jul 2020 13:58:52 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS31N1.mediatek.inc (172.27.4.69) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 10 Jul 2020 13:58:48 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 10 Jul 2020 13:58:49 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Mathias Nyman <mathias.nyman@intel.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        stable <stable@vger.kernel.org>
Subject: [v2 PATCH] usb: xhci-mtk: fix the failure of bandwidth allocation
Date:   Fri, 10 Jul 2020 13:57:52 +0800
Message-ID: <1594360672-2076-1-git-send-email-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: A4E306D334522FFBCC74B2420148282F0928E1E8771E2A2BEF95B67EF98867B52000:8
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
ci5rZXJuZWwub3JnPg0KRml4ZXM6IDBjYmQ0YjM0Y2RhOSgieGhjaTogbWVkaWF0ZWs6IHN1cHBv
cnQgTVRLIHhIQ0kgaG9zdCBjb250cm9sbGVyIikNClNpZ25lZC1vZmYtYnk6IENodW5mZW5nIFl1
biA8Y2h1bmZlbmcueXVuQG1lZGlhdGVrLmNvbT4NCi0tLQ0KVjI6IGFkZCBGaXhlcyBzdWdnZXN0
ZWQgYnkgTmljb2xhcw0KLS0tDQogZHJpdmVycy91c2IvaG9zdC94aGNpLW10ay1zY2guYyB8IDQg
KysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL2hvc3QveGhjaS1tdGstc2NoLmMgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktbXRr
LXNjaC5jDQppbmRleCBmZWE1NTU1Li40NWM1NGQ1NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNi
L2hvc3QveGhjaS1tdGstc2NoLmMNCisrKyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1tdGstc2No
LmMNCkBAIC01NTcsNiArNTU3LDEwIEBAIHN0YXRpYyBib29sIG5lZWRfYndfc2NoKHN0cnVjdCB1
c2JfaG9zdF9lbmRwb2ludCAqZXAsDQogCWlmIChpc19mc19vcl9scyhzcGVlZCkgJiYgIWhhc190
dCkNCiAJCXJldHVybiBmYWxzZTsNCiANCisJLyogc2tpcCBlbmRwb2ludCB3aXRoIHplcm8gbWF4
cGt0ICovDQorCWlmICh1c2JfZW5kcG9pbnRfbWF4cCgmZXAtPmRlc2MpID09IDApDQorCQlyZXR1
cm4gZmFsc2U7DQorDQogCXJldHVybiB0cnVlOw0KIH0NCiANCi0tIA0KMS45LjENCg==

