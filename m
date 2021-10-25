Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E0F43952E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhJYLsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233244AbhJYLsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BBB861040;
        Mon, 25 Oct 2021 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162381;
        bh=C6b6shzhRQx1x+0AH40ydkjoZdICJyhayKRWOP2YLnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/++InfaFv2Agba1fI6fsz7SMriqU/xMfqpXpelu/zgLmNiLQN7vHR8ipHAyikUv8
         8VEhBiC33AwOlFF1jIirj6Jat/mYbZPIwIIJ0LG2TlnXUJ0uZA48GobAQ1nPeyr8Rj
         QINwcd3VDgh2Z2FOLcfBRxhwSufCyR9zHl43JqYmQS3LQ6rDE459LXdJ4HvukAABBG
         WmgJ71jdDASRiA6N+nAR+Hpl2YlbqMo5bqFUBfd4QMSY9S3TiO3ISznvm5uRWcnL5K
         8Zsoh5QEFkwj2BtodIrJbWBRHJJD9CKTc+ENxBsWD66Ek/x7I2vYQFO9HYILryYjKi
         MlhVPQE76/pBg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyQW-0001DF-7e; Mon, 25 Oct 2021 13:46:04 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/5] comedi: dt9812: fix DMA buffers on stack
Date:   Mon, 25 Oct 2021 13:45:29 +0200
Message-Id: <20211025114532.4599-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025114532.4599-1-johan@kernel.org>
References: <20211025114532.4599-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/comedi/drivers/dt9812.c | 109 ++++++++++++++++++++++++--------
 1 file changed, 82 insertions(+), 27 deletions(-)

diff --git a/drivers/comedi/drivers/dt9812.c b/drivers/comedi/drivers/dt9812.c
index 634f57730c1e..f15c306f2d06 100644
--- a/drivers/comedi/drivers/dt9812.c
+++ b/drivers/comedi/drivers/dt9812.c
@@ -32,6 +32,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 
 #include "../comedi_usb.h"
@@ -237,22 +238,41 @@ static int dt9812_read_info(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int count, ret;
+	u8 *tbuf;
 
-	cmd.cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
-	cmd.u.flash_data_info.address =
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
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
+	kfree(cmd);
 	if (ret)
 		return ret;
 
-	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
-			    buf, buf_size, &count, DT9812_USB_TIMEOUT);
+	tbuf = kmalloc(buf_size, GFP_KERNEL);
+	if (!tbuf)
+		return -ENOMEM;
+
+	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
+			   tbuf, buf_size, &count, DT9812_USB_TIMEOUT);
+	if (!ret) {
+		if (count == buf_size)
+			memcpy(buf, tbuf, buf_size);
+		else
+			ret = -EREMOTEIO;
+	}
+	kfree(tbuf);
+
+	return ret;
 }
 
 static int dt9812_read_multiple_registers(struct comedi_device *dev,
@@ -261,22 +281,41 @@ static int dt9812_read_multiple_registers(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count, ret;
+	u8 *buf;
 
-	cmd.cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
-	cmd.u.read_multi_info.count = reg_count;
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
+	cmd->u.read_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++)
-		cmd.u.read_multi_info.address[i] = address[i];
+		cmd->u.read_multi_info.address[i] = address[i];
 
 	/* DT9812 only responds to 32 byte writes!! */
 	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
+	kfree(cmd);
 	if (ret)
 		return ret;
 
-	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
-			    value, reg_count, &count, DT9812_USB_TIMEOUT);
+	buf = kmalloc(reg_count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
+			   buf, reg_count, &count, DT9812_USB_TIMEOUT);
+	if (!ret) {
+		if (count == reg_count)
+			memcpy(value, buf, reg_count);
+		else
+			ret = -EREMOTEIO;
+	}
+	kfree(buf);
+
+	return ret;
 }
 
 static int dt9812_write_multiple_registers(struct comedi_device *dev,
@@ -285,19 +324,27 @@ static int dt9812_write_multiple_registers(struct comedi_device *dev,
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
 
-	cmd.cmd = cpu_to_le32(DT9812_W_MULTI_BYTE_REG);
-	cmd.u.read_multi_info.count = reg_count;
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
@@ -306,17 +353,25 @@ static int dt9812_rmw_multiple_registers(struct comedi_device *dev,
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
-- 
2.32.0

