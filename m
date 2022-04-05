Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73844F39DB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378807AbiDELjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354037AbiDEKLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:11:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8AB4FC62;
        Tue,  5 Apr 2022 02:56:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 048456157A;
        Tue,  5 Apr 2022 09:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D86C385A2;
        Tue,  5 Apr 2022 09:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152611;
        bh=s1EScRk8aHxvIE1cwg4n5HdDlYcT5jXxGT3URTDhO2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzlFj5JMoEMIm6b5U+jf5AHKlcjxLHIawFnZ8S85QTuFmLoU9zKEI/Nb2BF2pYqih
         /7Fzjr7dISEbhpxNRtwANu8iu49rB7QQT11Haokq1c182nzCzBVo7TEJB4p4tCgUZk
         PP7creXq/p2v7I4idFZl+I9umFLFyZWNhOmiRUYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 840/913] net: hns3: fix the concurrency between functions reading debugfs
Date:   Tue,  5 Apr 2022 09:31:42 +0200
Message-Id: <20220405070405.008748302@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

commit 9c9a04212fa380d2e7d1412bb281309955c0a781 upstream.

Currently, the debugfs mechanism is that all functions share a
global variable to save the pointer for obtaining data. When
different functions concurrently access the same file node,
repeated release exceptions occur. Therefore, the granularity
of the pointer for storing the obtained data is adjusted to be
private for each function.

Fixes: 5e69ea7ee2a6 ("net: hns3: refactor the debugfs process")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   15 +++++++++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |    1 -
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -835,6 +835,7 @@ struct hnae3_handle {
 	struct dentry *hnae3_dbgfs;
 	/* protects concurrent contention between debugfs commands */
 	struct mutex dbgfs_lock;
+	char **dbgfs_buf;
 
 	/* Network interface message level enabled bits */
 	u32 msg_enable;
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1022,7 +1022,7 @@ static ssize_t hns3_dbg_read(struct file
 		return ret;
 
 	mutex_lock(&handle->dbgfs_lock);
-	save_buf = &hns3_dbg_cmd[index].buf;
+	save_buf = &handle->dbgfs_buf[index];
 
 	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
 	    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state)) {
@@ -1127,6 +1127,13 @@ int hns3_dbg_init(struct hnae3_handle *h
 	int ret;
 	u32 i;
 
+	handle->dbgfs_buf = devm_kcalloc(&handle->pdev->dev,
+					 ARRAY_SIZE(hns3_dbg_cmd),
+					 sizeof(*handle->dbgfs_buf),
+					 GFP_KERNEL);
+	if (!handle->dbgfs_buf)
+		return -ENOMEM;
+
 	hns3_dbg_dentry[HNS3_DBG_DENTRY_COMMON].dentry =
 				debugfs_create_dir(name, hns3_dbgfs_root);
 	handle->hnae3_dbgfs = hns3_dbg_dentry[HNS3_DBG_DENTRY_COMMON].dentry;
@@ -1175,9 +1182,9 @@ void hns3_dbg_uninit(struct hnae3_handle
 	u32 i;
 
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++)
-		if (hns3_dbg_cmd[i].buf) {
-			kvfree(hns3_dbg_cmd[i].buf);
-			hns3_dbg_cmd[i].buf = NULL;
+		if (handle->dbgfs_buf[i]) {
+			kvfree(handle->dbgfs_buf[i]);
+			handle->dbgfs_buf[i] = NULL;
 		}
 
 	mutex_destroy(&handle->dbgfs_lock);
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -47,7 +47,6 @@ struct hns3_dbg_cmd_info {
 	enum hnae3_dbg_cmd cmd;
 	enum hns3_dbg_dentry_type dentry;
 	u32 buf_len;
-	char *buf;
 	int (*init)(struct hnae3_handle *handle, unsigned int cmd);
 };
 


