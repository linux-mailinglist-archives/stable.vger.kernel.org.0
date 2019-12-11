Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4821311B577
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbfLKPyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730284AbfLKPS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 134FE208C3;
        Wed, 11 Dec 2019 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077505;
        bh=Gaw9+FhkITEH1xQoprcNUFZopSw4zsuzQkRpNB2caFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLOrbVDAgW8j5V58o17nB6pb2WbN+bNjTZQPRWr78pvHZbf8EZhnLZz7FKwpiHHum
         rUXoal0tQtK0OFy2OYFNoC0BCI26N5gICxAw2G1XgekwhT3IQtTWutsA17KJHg97QB
         +w29OKbznsjwCDlPydhD5M2SxoU6z6D5fwEkW/0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Hughes <james.hughes@raspberrypi.org>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/243] firmware: raspberrypi: Fix firmware calls with large buffers
Date:   Wed, 11 Dec 2019 16:03:45 +0100
Message-Id: <20191211150343.353095927@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hughes <james.hughes@raspberrypi.org>

[ Upstream commit 91c6ada69f396e663acb2b713e8acb8a9463557d ]

Commit a1547e0bca51 ("firmware: raspberrypi: Remove VLA usage")
moved away from VLA's to a fixed maximum size for mailbox data.
However, some mailbox calls use larger data buffers
than the maximum allowed in that change. This fix therefor
moves from using fixed buffers to kmalloc to ensure all sizes
are catered for.

There is some documentation, which is somewhat out of date,
on the mailbox calls here :
https://github.com/raspberrypi/firmware/wiki/Mailbox-property-interface

Fixes: a1547e0bca51 ("firmware: raspberrypi: Remove VLA usage")

Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/raspberrypi.c | 35 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/firmware/raspberrypi.c b/drivers/firmware/raspberrypi.c
index a200a21746119..44eb99807e337 100644
--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <soc/bcm2835/raspberrypi-firmware.h>
 
 #define MBOX_MSG(chan, data28)		(((data28) & ~0xf) | ((chan) & 0xf))
@@ -21,8 +22,6 @@
 #define MBOX_DATA28(msg)		((msg) & ~0xf)
 #define MBOX_CHAN_PROPERTY		8
 
-#define MAX_RPI_FW_PROP_BUF_SIZE	32
-
 static struct platform_device *rpi_hwmon;
 
 struct rpi_firmware {
@@ -144,28 +143,30 @@ EXPORT_SYMBOL_GPL(rpi_firmware_property_list);
 int rpi_firmware_property(struct rpi_firmware *fw,
 			  u32 tag, void *tag_data, size_t buf_size)
 {
-	/* Single tags are very small (generally 8 bytes), so the
-	 * stack should be safe.
-	 */
-	u8 data[sizeof(struct rpi_firmware_property_tag_header) +
-		MAX_RPI_FW_PROP_BUF_SIZE];
-	struct rpi_firmware_property_tag_header *header =
-		(struct rpi_firmware_property_tag_header *)data;
+	struct rpi_firmware_property_tag_header *header;
 	int ret;
 
-	if (WARN_ON(buf_size > sizeof(data) - sizeof(*header)))
-		return -EINVAL;
+	/* Some mailboxes can use over 1k bytes. Rather than checking
+	 * size and using stack or kmalloc depending on requirements,
+	 * just use kmalloc. Mailboxes don't get called enough to worry
+	 * too much about the time taken in the allocation.
+	 */
+	void *data = kmalloc(sizeof(*header) + buf_size, GFP_KERNEL);
 
+	if (!data)
+		return -ENOMEM;
+
+	header = data;
 	header->tag = tag;
 	header->buf_size = buf_size;
 	header->req_resp_size = 0;
-	memcpy(data + sizeof(struct rpi_firmware_property_tag_header),
-	       tag_data, buf_size);
+	memcpy(data + sizeof(*header), tag_data, buf_size);
+
+	ret = rpi_firmware_property_list(fw, data, buf_size + sizeof(*header));
+
+	memcpy(tag_data, data + sizeof(*header), buf_size);
 
-	ret = rpi_firmware_property_list(fw, &data, buf_size + sizeof(*header));
-	memcpy(tag_data,
-	       data + sizeof(struct rpi_firmware_property_tag_header),
-	       buf_size);
+	kfree(data);
 
 	return ret;
 }
-- 
2.20.1



