Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783EF44C6E2
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhKJSqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:46:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232519AbhKJSqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:46:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52CD0611C9;
        Wed, 10 Nov 2021 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569822;
        bh=RjInd3JGIV8bHmngubFKVhbNniHOFgdPRRrxz8odIdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVntHmwOoqi/p1YghRx9XdnnhiNEdXxe/1xgAzvv6T1etp6O+GgwJcNIzoY8UBx9O
         w+6XHuNH7wa1CNxOcSH1chIlK0jcaX7lLg1hG2T6SBPOFCakKJxOVEsefiCaie5snB
         g1ZaJiO2VDMPXstclQJ9cT9coHAPBLLX0yhxVqiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 11/19] comedi: dt9812: fix DMA buffers on stack
Date:   Wed, 10 Nov 2021 19:43:13 +0100
Message-Id: <20211110182001.623863456@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
References: <20211110182001.257350381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 536de747bc48262225889a533db6650731ab25d3 upstream.

USB transfer buffers are typically mapped for DMA and must not be
allocated on the stack or transfers will fail.

Allocate proper transfer buffers in the various command helpers and
return an error on short transfers instead of acting on random stack
data.

Note that this also fixes a stack info leak on systems where DMA is not
used as 32 bytes are always sent to the device regardless of how short
the command is.

Fixes: 63274cd7d38a ("Staging: comedi: add usb dt9812 driver")
Cc: stable@vger.kernel.org      # 2.6.29
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211027093529.30896-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dt9812.c |  115 +++++++++++++++++++++++---------
 1 file changed, 86 insertions(+), 29 deletions(-)

--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -41,6 +41,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 
 #include "../comedi_usb.h"
@@ -246,22 +247,42 @@ static int dt9812_read_info(struct comed
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
+	size_t tbuf_size;
 	int count, ret;
+	void *tbuf;
 
-	cmd.cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
-	cmd.u.flash_data_info.address =
+	tbuf_size = max(sizeof(*cmd), buf_size);
+
+	tbuf = kzalloc(tbuf_size, GFP_KERNEL);
+	if (!tbuf)
+		return -ENOMEM;
+
+	cmd = tbuf;
+
+	cmd->cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
+	cmd->u.flash_data_info.address =
 	    cpu_to_le16(DT9812_DIAGS_BOARD_INFO_ADDR + offset);
-	cmd.u.flash_data_info.numbytes = cpu_to_le16(buf_size);
+	cmd->u.flash_data_info.numbytes = cpu_to_le16(buf_size);
 
 	/* DT9812 only responds to 32 byte writes!! */
 	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
 	if (ret)
-		return ret;
+		goto out;
+
+	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
+			   tbuf, buf_size, &count, DT9812_USB_TIMEOUT);
+	if (!ret) {
+		if (count == buf_size)
+			memcpy(buf, tbuf, buf_size);
+		else
+			ret = -EREMOTEIO;
+	}
+out:
+	kfree(tbuf);
 
-	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
-			    buf, buf_size, &count, DT9812_USB_TIMEOUT);
+	return ret;
 }
 
 static int dt9812_read_multiple_registers(struct comedi_device *dev,
@@ -270,22 +291,42 @@ static int dt9812_read_multiple_register
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count, ret;
+	size_t buf_size;
+	void *buf;
+
+	buf_size = max_t(size_t, sizeof(*cmd), reg_count);
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	cmd = buf;
 
-	cmd.cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
-	cmd.u.read_multi_info.count = reg_count;
+	cmd->cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
+	cmd->u.read_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++)
-		cmd.u.read_multi_info.address[i] = address[i];
+		cmd->u.read_multi_info.address[i] = address[i];
 
 	/* DT9812 only responds to 32 byte writes!! */
 	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
 	if (ret)
-		return ret;
+		goto out;
 
-	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
-			    value, reg_count, &count, DT9812_USB_TIMEOUT);
+	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
+			   buf, reg_count, &count, DT9812_USB_TIMEOUT);
+	if (!ret) {
+		if (count == reg_count)
+			memcpy(value, buf, reg_count);
+		else
+			ret = -EREMOTEIO;
+	}
+out:
+	kfree(buf);
+
+	return ret;
 }
 
 static int dt9812_write_multiple_registers(struct comedi_device *dev,
@@ -294,19 +335,27 @@ static int dt9812_write_multiple_registe
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count;
+	int ret;
 
-	cmd.cmd = cpu_to_le32(DT9812_W_MULTI_BYTE_REG);
-	cmd.u.read_multi_info.count = reg_count;
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->cmd = cpu_to_le32(DT9812_W_MULTI_BYTE_REG);
+	cmd->u.read_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++) {
-		cmd.u.write_multi_info.write[i].address = address[i];
-		cmd.u.write_multi_info.write[i].value = value[i];
+		cmd->u.write_multi_info.write[i].address = address[i];
+		cmd->u.write_multi_info.write[i].value = value[i];
 	}
 
 	/* DT9812 only responds to 32 byte writes!! */
-	return usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			    &cmd, 32, &count, DT9812_USB_TIMEOUT);
+	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
+	kfree(cmd);
+
+	return ret;
 }
 
 static int dt9812_rmw_multiple_registers(struct comedi_device *dev,
@@ -315,17 +364,25 @@ static int dt9812_rmw_multiple_registers
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
 
-	cmd.cmd = cpu_to_le32(DT9812_RMW_MULTI_BYTE_REG);
-	cmd.u.rmw_multi_info.count = reg_count;
+	cmd->cmd = cpu_to_le32(DT9812_RMW_MULTI_BYTE_REG);
+	cmd->u.rmw_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++)
-		cmd.u.rmw_multi_info.rmw[i] = rmw[i];
+		cmd->u.rmw_multi_info.rmw[i] = rmw[i];
 
 	/* DT9812 only responds to 32 byte writes!! */
-	return usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			    &cmd, 32, &count, DT9812_USB_TIMEOUT);
+	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
+	kfree(cmd);
+
+	return ret;
 }
 
 static int dt9812_digital_in(struct comedi_device *dev, u8 *bits)


