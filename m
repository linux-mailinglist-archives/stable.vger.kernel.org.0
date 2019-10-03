Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5286FCA5BB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404370AbfJCQgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404364AbfJCQgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:36:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 058CE20830;
        Thu,  3 Oct 2019 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120567;
        bh=224I4fzK4RB0xc3LTsfu0YpM9q/+ijxfotS1WpbM0Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/uG0pU62+Yn7L7MHgoXritkUKa/9ADnjLZNdZ2Pw91NwRGk/GAIAwsRaVaUAIZDr
         vyEbWi3+Mli95nTJLKZhtd77tTQNivyEB+vIyCGNuavQiH3Wpg02UYBxZyMpYLTMfB
         COUrCAuQdeKGQ9fwBOP1oCmCbkNOpsvsdoBokZAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.2 270/313] mt76: round up length on mt76_wr_copy
Date:   Thu,  3 Oct 2019 17:54:08 +0200
Message-Id: <20191003154559.649807197@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 850e8f6fbd5d0003b0f1119d19a01c6fef1644e2 upstream.

When beacon length is not a multiple of 4, the beacon could be sent with
the last 1-3 bytes corrupted. The skb data is guaranteed to have enough
room for reading beyond the end, because it is always followed by
skb_shared_info, so rounding up is safe.
All other callers of mt76_wr_copy have multiple-of-4 length already.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mmio.c |    2 +-
 drivers/net/wireless/mediatek/mt76/usb.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -43,7 +43,7 @@ static u32 mt76_mmio_rmw(struct mt76_dev
 static void mt76_mmio_copy(struct mt76_dev *dev, u32 offset, const void *data,
 			   int len)
 {
-	__iowrite32_copy(dev->mmio.regs + offset, data, len >> 2);
+	__iowrite32_copy(dev->mmio.regs + offset, data, DIV_ROUND_UP(len, 4));
 }
 
 static int mt76_mmio_wr_rp(struct mt76_dev *dev, u32 base,
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -164,7 +164,7 @@ static void mt76u_copy(struct mt76_dev *
 	int i, ret;
 
 	mutex_lock(&usb->usb_ctrl_mtx);
-	for (i = 0; i < (len / 4); i++) {
+	for (i = 0; i < DIV_ROUND_UP(len, 4); i++) {
 		put_unaligned_le32(val[i], usb->data);
 		ret = __mt76u_vendor_request(dev, MT_VEND_MULTI_WRITE,
 					     USB_DIR_OUT | USB_TYPE_VENDOR,


