Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1844844C7FC
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhKJS5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:57:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhKJSzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:55:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD6661353;
        Wed, 10 Nov 2021 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570161;
        bh=EEEm82jlH6LelDgraPELcEi79deedFAhsw4ZNvcvYCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvdcIVXaXABWw78G2gX9w47Nrr7v7r9pWTbDt9tDO1rKzULs2g//au622JP+/o/+p
         gEu/ygpVBDPy385PGhMeeKOsmBsgGKqa4yEm6dLRQuF+Vr7ejZDWRKIS2B6rdzZGyd
         VUoXejJXgHbRZ+F50FDIqSUygI2W5jxx2tZZI9b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.14 18/24] comedi: vmk80xx: fix transfer-buffer overflows
Date:   Wed, 10 Nov 2021 19:44:10 +0100
Message-Id: <20211110182003.920179667@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit a23461c47482fc232ffc9b819539d1f837adf2b1 upstream.

The driver uses endpoint-sized USB transfer buffers but up until
recently had no sanity checks on the sizes.

Commit e1f13c879a7c ("staging: comedi: check validity of wMaxPacketSize
of usb endpoints found") inadvertently fixed NULL-pointer dereferences
when accessing the transfer buffers in case a malicious device has a
zero wMaxPacketSize.

Make sure to allocate buffers large enough to handle also the other
accesses that are done without a size check (e.g. byte 18 in
vmk80xx_cnt_insn_read() for the VMK8061_MODEL) to avoid writing beyond
the buffers, for example, when doing descriptor fuzzing.

The original driver was for a low-speed device with 8-byte buffers.
Support was later added for a device that uses bulk transfers and is
presumably a full-speed device with a maximum 64-byte wMaxPacketSize.

Fixes: 985cafccbf9b ("Staging: Comedi: vmk80xx: Add k8061 support")
Cc: stable@vger.kernel.org      # 2.6.31
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20211025114532.4599-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/vmk80xx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -90,6 +90,8 @@ enum {
 #define IC3_VERSION		BIT(0)
 #define IC6_VERSION		BIT(1)
 
+#define MIN_BUF_SIZE		64
+
 enum vmk80xx_model {
 	VMK8055_MODEL,
 	VMK8061_MODEL
@@ -678,12 +680,12 @@ static int vmk80xx_alloc_usb_buffers(str
 	struct vmk80xx_private *devpriv = dev->private;
 	size_t size;
 
-	size = usb_endpoint_maxp(devpriv->ep_rx);
+	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
 	devpriv->usb_rx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = usb_endpoint_maxp(devpriv->ep_tx);
+	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;


