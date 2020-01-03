Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA73812F6DB
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 11:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbgACKsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 05:48:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgACKsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 05:48:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DBAC21835;
        Fri,  3 Jan 2020 10:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578048530;
        bh=9I/iDuOhmju8LsBsGRbd55E0o2vPkrhxdmE2OueQo6s=;
        h=Subject:To:From:Date:From;
        b=EQ8+LOp21+5uSBB+9krrLeQqcTRVOqMp4mgLxymN60oGSqwBZ2tWebH2BwcbienIz
         jcZE5AxJCkSKMXwu7vf5ZaB2tm/ZzicgXlQZjBQMlxaivCd/8FsaVruuWCF0aVvDD3
         PEk4dh9YMiinjhIzyLK7BBFs2kVnDGoBtI23fheE=
Subject: patch "staging: vt6656: limit reg output to block size" added to staging-linus
To:     tvboxspy@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jan 2020 11:48:37 +0100
Message-ID: <157804851720294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vt6656: limit reg output to block size

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 69cc1f925e1aa74b96e2ace67e3453a50d091d2f Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Fri, 20 Dec 2019 21:15:24 +0000
Subject: staging: vt6656: limit reg output to block size

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
 drivers/staging/vt6656/baseband.c |  4 ++--
 drivers/staging/vt6656/usbpipe.c  | 17 +++++++++++++++++
 drivers/staging/vt6656/usbpipe.h  |  5 +++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 8d19ae71e7cc..4e651b698617 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -449,8 +449,8 @@ int vnt_vt3184_init(struct vnt_private *priv)
 
 	memcpy(array, addr, length);
 
-	ret = vnt_control_out(priv, MESSAGE_TYPE_WRITE, 0,
-			      MESSAGE_REQUEST_BBREG, length, array);
+	ret = vnt_control_out_blocks(priv, VNT_REG_BLOCK_SIZE,
+				     MESSAGE_REQUEST_BBREG, length, array);
 	if (ret)
 		goto end;
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 488ebd98773d..d977d4777e4f 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -76,6 +76,23 @@ int vnt_control_out_u8(struct vnt_private *priv, u8 reg, u8 reg_off, u8 data)
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
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index 95147ec7b96a..b65d9c01a211 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -18,6 +18,8 @@
 
 #include "device.h"
 
+#define VNT_REG_BLOCK_SIZE	64
+
 int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 		    u16 index, u16 length, u8 *buffer);
 int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
@@ -26,6 +28,9 @@ int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
 int vnt_control_out_u8(struct vnt_private *priv, u8 reg, u8 ref_off, u8 data);
 int vnt_control_in_u8(struct vnt_private *priv, u8 reg, u8 reg_off, u8 *data);
 
+int vnt_control_out_blocks(struct vnt_private *priv,
+			   u16 block, u8 reg, u16 len, u8 *data);
+
 int vnt_start_interrupt_urb(struct vnt_private *priv);
 int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb);
 int vnt_tx_context(struct vnt_private *priv,
-- 
2.24.1


