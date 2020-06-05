Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF7A1EFA46
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgFEOQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgFEOQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA1322075B;
        Fri,  5 Jun 2020 14:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366569;
        bh=iK6d8iiYLeDwGlgo/490db9Xd5xTRUxqCFRX3a0V7H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+fpA4zjlyHbo8hvf775spRJusJYugayS+9JZ9VjzjB0OgUlAxOjVx6b0R8/8o24d
         Gq/5nxSTB8FNuuOkv7EuJQrk3ESrMlFIMSo5SB9EtZnXcRQhjSQSABY7EQJha+muxH
         Lb6x7aZ5iMBgcqWNiu1TsJUre4CqQn6+mYlkcOuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Garrett <mjg59@google.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.7 07/14] mt76: mt76x02u: Add support for newer versions of the XBox One wifi adapter
Date:   Fri,  5 Jun 2020 16:14:57 +0200
Message-Id: <20200605135951.447750570@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605135951.018731965@linuxfoundation.org>
References: <20200605135951.018731965@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Garrett <matthewgarrett@google.com>

commit b2934279c3e9719145ff4090d4ab951e340df17e upstream.

The current version has a new USB ID and reports as an 0x7632 device.
Adding the IDs results in it working out of the box.

Signed-off-by: Matthew Garrett <mjg59@google.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt76x02.h    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -216,6 +216,7 @@ static inline bool is_mt76x0(struct mt76
 static inline bool is_mt76x2(struct mt76x02_dev *dev)
 {
 	return mt76_chip(&dev->mt76) == 0x7612 ||
+	       mt76_chip(&dev->mt76) == 0x7632 ||
 	       mt76_chip(&dev->mt76) == 0x7662 ||
 	       mt76_chip(&dev->mt76) == 0x7602;
 }
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -18,6 +18,7 @@ static const struct usb_device_id mt76x2
 	{ USB_DEVICE(0x7392, 0xb711) },	/* Edimax EW 7722 UAC */
 	{ USB_DEVICE(0x0846, 0x9053) },	/* Netgear A6210 */
 	{ USB_DEVICE(0x045e, 0x02e6) },	/* XBox One Wireless Adapter */
+	{ USB_DEVICE(0x045e, 0x02fe) },	/* XBox One Wireless Adapter */
 	{ },
 };
 


