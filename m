Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553CC47ADF2
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbhLTO4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32948 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbhLTOyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:54:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48153B80EDE;
        Mon, 20 Dec 2021 14:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9204FC36AE8;
        Mon, 20 Dec 2021 14:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012081;
        bh=FlQRhN+FvKxaeGsp4TEQ2xMy+PJRLglVwZT3iLiKupQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psV3L3VsKVbsm/H2zgni+AhtCAiOdTLv1eprF3Ky6KHQlaxSdB3+CzXwflSw3haxz
         0CG0kMkSKOxJQuu4FfBEt9S4f8ncmFBW5q3FvQDrR6K4gENx+vUPw2zu3rhs8v96NL
         VQ/gekKXgQFmGMv4lHrLQD53kyJqIgwfJC4VzBY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/177] net: hns3: fix race condition in debugfs
Date:   Mon, 20 Dec 2021 15:33:36 +0100
Message-Id: <20211220143042.322618218@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 6dde452bceca3f2ed2b33bc46a16ff5682a03a2e ]

When multiple threads concurrently access the debugfs content, data
and pointer exceptions may occur. Therefore, mutex lock protection is
added for debugfs.

Fixes: 5e69ea7ee2a6 ("net: hns3: refactor the debugfs process")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  2 ++
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 20 +++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index d701451596c82..47bba4c62f040 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -830,6 +830,8 @@ struct hnae3_handle {
 
 	u8 netdev_flags;
 	struct dentry *hnae3_dbgfs;
+	/* protects concurrent contention between debugfs commands */
+	struct mutex dbgfs_lock;
 
 	/* Network interface message level enabled bits */
 	u32 msg_enable;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index e54f96251fea9..3205849bdb95b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1021,6 +1021,7 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 	if (ret)
 		return ret;
 
+	mutex_lock(&handle->dbgfs_lock);
 	save_buf = &hns3_dbg_cmd[index].buf;
 
 	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
@@ -1033,15 +1034,15 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 		read_buf = *save_buf;
 	} else {
 		read_buf = kvzalloc(hns3_dbg_cmd[index].buf_len, GFP_KERNEL);
-		if (!read_buf)
-			return -ENOMEM;
+		if (!read_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		/* save the buffer addr until the last read operation */
 		*save_buf = read_buf;
-	}
 
-	/* get data ready for the first time to read */
-	if (!*ppos) {
+		/* get data ready for the first time to read */
 		ret = hns3_dbg_read_cmd(dbg_data, hns3_dbg_cmd[index].cmd,
 					read_buf, hns3_dbg_cmd[index].buf_len);
 		if (ret)
@@ -1050,8 +1051,10 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 
 	size = simple_read_from_buffer(buffer, count, ppos, read_buf,
 				       strlen(read_buf));
-	if (size > 0)
+	if (size > 0) {
+		mutex_unlock(&handle->dbgfs_lock);
 		return size;
+	}
 
 out:
 	/* free the buffer for the last read operation */
@@ -1060,6 +1063,7 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 		*save_buf = NULL;
 	}
 
+	mutex_unlock(&handle->dbgfs_lock);
 	return ret;
 }
 
@@ -1132,6 +1136,8 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 			debugfs_create_dir(hns3_dbg_dentry[i].name,
 					   handle->hnae3_dbgfs);
 
+	mutex_init(&handle->dbgfs_lock);
+
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++) {
 		if ((hns3_dbg_cmd[i].cmd == HNAE3_DBG_CMD_TM_NODES &&
 		     ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) ||
@@ -1158,6 +1164,7 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 	return 0;
 
 out:
+	mutex_destroy(&handle->dbgfs_lock);
 	debugfs_remove_recursive(handle->hnae3_dbgfs);
 	handle->hnae3_dbgfs = NULL;
 	return ret;
@@ -1173,6 +1180,7 @@ void hns3_dbg_uninit(struct hnae3_handle *handle)
 			hns3_dbg_cmd[i].buf = NULL;
 		}
 
+	mutex_destroy(&handle->dbgfs_lock);
 	debugfs_remove_recursive(handle->hnae3_dbgfs);
 	handle->hnae3_dbgfs = NULL;
 }
-- 
2.33.0



