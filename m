Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4028913A52A
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgANKFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:32974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730039AbgANKFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F4D2467A;
        Tue, 14 Jan 2020 10:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996306;
        bh=S+40nex0JIA9ewxDDyPd0N5/flVV4l8E29pDRYNagGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNftzATmNF8PfPVy/VQPfdt1zysAPBL+wq6xmhJMULTSYZH6IuYFFidpoCCEFT9y+
         Tfbvs7mh0sMp6VAmmOBBlzGLeZ/OgW5CuS5fkpObXWmAdvPJsaBy6h53Cy6BqWYZtr
         aayHAZFtrU83xcUjzRRprUsorAsWnkoOK+fqkRW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.4 51/78] staging: vt6656: limit reg output to block size
Date:   Tue, 14 Jan 2020 11:01:25 +0100
Message-Id: <20200114094400.340325348@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 69cc1f925e1aa74b96e2ace67e3453a50d091d2f upstream.

vnt_control_out appears to fail when BBREG is greater than 64 writes.

Create new function that will relay an array in no larger than
the indicated block size.

It appears that this command has always failed but was ignored by
driver until the introduction of error checking.

Cc: stable <stable@vger.kernel.org> # v5.3+
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/a41f0601-df46-ce6e-ab7c-35e697946e2a@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/baseband.c |    4 ++--
 drivers/staging/vt6656/usbpipe.c  |   17 +++++++++++++++++
 drivers/staging/vt6656/usbpipe.h  |    5 +++++
 3 files changed, 24 insertions(+), 2 deletions(-)

--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -449,8 +449,8 @@ int vnt_vt3184_init(struct vnt_private *
 
 	memcpy(array, addr, length);
 
-	ret = vnt_control_out(priv, MESSAGE_TYPE_WRITE, 0,
-			      MESSAGE_REQUEST_BBREG, length, array);
+	ret = vnt_control_out_blocks(priv, VNT_REG_BLOCK_SIZE,
+				     MESSAGE_REQUEST_BBREG, length, array);
 	if (ret)
 		goto end;
 
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -76,6 +76,23 @@ int vnt_control_out_u8(struct vnt_privat
 			       reg_off, reg, sizeof(u8), &data);
 }
 
+int vnt_control_out_blocks(struct vnt_private *priv,
+			   u16 block, u8 reg, u16 length, u8 *data)
+{
+	int ret = 0, i;
+
+	for (i = 0; i < length; i += block) {
+		u16 len = min_t(int, length - i, block);
+
+		ret = vnt_control_out(priv, MESSAGE_TYPE_WRITE,
+				      i, reg, len, data + i);
+		if (ret)
+			goto end;
+	}
+end:
+	return ret;
+}
+
 int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
 		   u16 index, u16 length, u8 *buffer)
 {
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -18,6 +18,8 @@
 
 #include "device.h"
 
+#define VNT_REG_BLOCK_SIZE	64
+
 int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 		    u16 index, u16 length, u8 *buffer);
 int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
@@ -26,6 +28,9 @@ int vnt_control_in(struct vnt_private *p
 int vnt_control_out_u8(struct vnt_private *priv, u8 reg, u8 ref_off, u8 data);
 int vnt_control_in_u8(struct vnt_private *priv, u8 reg, u8 reg_off, u8 *data);
 
+int vnt_control_out_blocks(struct vnt_private *priv,
+			   u16 block, u8 reg, u16 len, u8 *data);
+
 int vnt_start_interrupt_urb(struct vnt_private *priv);
 int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb);
 int vnt_tx_context(struct vnt_private *priv,


