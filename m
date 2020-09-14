Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A7A26842A
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 07:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgINFkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 01:40:53 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:5206 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726003AbgINFkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 01:40:52 -0400
X-UUID: ab4240b2afa94746b687547402643818-20200914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=fBVLtMBuFfeBUBqP/RzEoxUtZXT2osAXTyH79wtLx08=;
        b=Idubs2+ievcAYAZKvQ/JU5tzaCD0G58d5tKkiAY3mhv4xzcoKN3PiaHEk4uhTnzOXT4rS09CxAjSl+xqBoIlFUgEa+HHmZiBZI6a+QY1vlP5uDI1hBnqaPJCYp76PxVNTmnjHySIY5C4PQl3PwWP/dLTDqHBhb+6zEWV6Ox4leM=;
X-UUID: ab4240b2afa94746b687547402643818-20200914
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 728763372; Mon, 14 Sep 2020 13:40:55 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS31N2.mediatek.inc (172.27.4.87) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 14 Sep 2020 13:40:52 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Sep 2020 13:40:52 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Felipe Balbi <balbi@kernel.org>
CC:     Kevin Cernekee <cernekee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] usb: gadget: bcm63xx_udc: fix up the error of undeclared usb_debug_root
Date:   Mon, 14 Sep 2020 13:38:50 +0800
Message-ID: <1600061930-778-1-git-send-email-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: ECB9098F0EB5B81046F04177D76A33CE08016C522848931B0844B60C9FFF46062000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rml4IHVwIHRoZSBidWlsZCBlcnJvciBjYXVzZWQgYnkgdW5kZWNsYXJlZCB1c2JfZGVidWdfcm9v
dA0KDQpDYzogc3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KRml4ZXM6IGE2NmFkYTRm
MjQxYygidXNiOiBnYWRnZXQ6IGJjbTYzeHhfdWRjOiBjcmVhdGUgZGVidWdmcyBkaXJlY3Rvcnkg
dW5kZXIgdXNiIHJvb3QiKQ0KUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50
ZWwuY29tPg0KU2lnbmVkLW9mZi1ieTogQ2h1bmZlbmcgWXVuIDxjaHVuZmVuZy55dW5AbWVkaWF0
ZWsuY29tPg0KLS0tDQogZHJpdmVycy91c2IvZ2FkZ2V0L3VkYy9iY202M3h4X3VkYy5jIHwgMSAr
DQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3VzYi9nYWRnZXQvdWRjL2JjbTYzeHhfdWRjLmMgYi9kcml2ZXJzL3VzYi9nYWRnZXQvdWRjL2Jj
bTYzeHhfdWRjLmMNCmluZGV4IGZlYWVjMDAuLjljZDRhNzAgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3VzYi9nYWRnZXQvdWRjL2JjbTYzeHhfdWRjLmMNCisrKyBiL2RyaXZlcnMvdXNiL2dhZGdldC91
ZGMvYmNtNjN4eF91ZGMuYw0KQEAgLTI2LDYgKzI2LDcgQEANCiAjaW5jbHVkZSA8bGludXgvc2Vx
X2ZpbGUuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KICNpbmNsdWRlIDxsaW51eC90aW1l
ci5oPg0KKyNpbmNsdWRlIDxsaW51eC91c2IuaD4NCiAjaW5jbHVkZSA8bGludXgvdXNiL2NoOS5o
Pg0KICNpbmNsdWRlIDxsaW51eC91c2IvZ2FkZ2V0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3dvcmtx
dWV1ZS5oPg0KLS0gDQoxLjkuMQ0K

