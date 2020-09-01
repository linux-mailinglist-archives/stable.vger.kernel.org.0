Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102B72596DB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgIAQHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgIAPkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9106F20866;
        Tue,  1 Sep 2020 15:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974806;
        bh=3EnFM1EqhxlGEIjlFAWWwx+otHaDaxoJh5K+xDYKgPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfwEXppeD+zvq/a9LFS7P2Wm+jrgWjeudHtdiVW3XP3+se80GzuRF1EfTjvjMuZ8v
         6mo2VXr6KxxQIymjKefRBa0UTskY6Uh8z4WgIE3Khc/oBIJ5T5ECkzi0mzaeLMa0Q9
         3u4inttmmRVIO/KdZy9QwqJ74zJobMtJV/bDYuZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 098/255] habanalabs: Fix memory corruption in debugfs
Date:   Tue,  1 Sep 2020 17:09:14 +0200
Message-Id: <20200901151005.418565007@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit eeec23cd325ad4d83927b8ee162693579cf3813f ]

This has to be a long instead of a u32 because we write a long value.
On 64 bit systems, this will cause memory corruption.

Fixes: c216477363a3 ("habanalabs: add debugfs support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/habanalabs/debugfs.c b/drivers/misc/habanalabs/debugfs.c
index 0bc036e01ee8d..6c2b9cf45e831 100644
--- a/drivers/misc/habanalabs/debugfs.c
+++ b/drivers/misc/habanalabs/debugfs.c
@@ -19,7 +19,7 @@
 static struct dentry *hl_debug_root;
 
 static int hl_debugfs_i2c_read(struct hl_device *hdev, u8 i2c_bus, u8 i2c_addr,
-				u8 i2c_reg, u32 *val)
+				u8 i2c_reg, long *val)
 {
 	struct armcp_packet pkt;
 	int rc;
@@ -36,7 +36,7 @@ static int hl_debugfs_i2c_read(struct hl_device *hdev, u8 i2c_bus, u8 i2c_addr,
 	pkt.i2c_reg = i2c_reg;
 
 	rc = hdev->asic_funcs->send_cpu_message(hdev, (u32 *) &pkt, sizeof(pkt),
-						0, (long *) val);
+						0, val);
 
 	if (rc)
 		dev_err(hdev->dev, "Failed to read from I2C, error %d\n", rc);
@@ -827,7 +827,7 @@ static ssize_t hl_i2c_data_read(struct file *f, char __user *buf,
 	struct hl_dbg_device_entry *entry = file_inode(f)->i_private;
 	struct hl_device *hdev = entry->hdev;
 	char tmp_buf[32];
-	u32 val;
+	long val;
 	ssize_t rc;
 
 	if (*ppos)
@@ -842,7 +842,7 @@ static ssize_t hl_i2c_data_read(struct file *f, char __user *buf,
 		return rc;
 	}
 
-	sprintf(tmp_buf, "0x%02x\n", val);
+	sprintf(tmp_buf, "0x%02lx\n", val);
 	rc = simple_read_from_buffer(buf, count, ppos, tmp_buf,
 			strlen(tmp_buf));
 
-- 
2.25.1



