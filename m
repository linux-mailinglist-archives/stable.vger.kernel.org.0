Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA096159A7
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiKBDQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiKBDPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:15:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F9824BE2
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:15:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0840617D5
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C33EC433D6;
        Wed,  2 Nov 2022 03:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358922;
        bh=sOInzPtP8lXgKqDmoe2QjiMo59HXozo9QBb+wiglYG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVSu+igi8dS2ttAX5X/vVkC6BITc4PCu+4Xwr2c7zkFPq5vifv/g1X4WaSM+UGflI
         EkmAOmFxxwJ+DWWBhwzmhqwRdBi8Xwo/1FqGxFwfmkHO3gBQDJE5JfD14NCxG/urh5
         /7KcalmbBXjpOuGFhIwTm57CqgZ2GO7R50nGtJv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/91] net: hinic: fix memory leak when reading function table
Date:   Wed,  2 Nov 2022 03:33:30 +0100
Message-Id: <20221102022056.364086928@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 4c1f602df8956bc0decdafd7e4fc7eef50c550b1 ]

When the input parameter idx meets the expected case option in
hinic_dbg_get_func_table(), read_data is not released. Fix it.

Fixes: 5215e16244ee ("hinic: add support to query function table")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/huawei/hinic/hinic_debugfs.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
index 19eb839177ec..061952c6c21a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
@@ -85,6 +85,7 @@ static int hinic_dbg_get_func_table(struct hinic_dev *nic_dev, int idx)
 	struct tag_sml_funcfg_tbl *funcfg_table_elem;
 	struct hinic_cmd_lt_rd *read_data;
 	u16 out_size = sizeof(*read_data);
+	int ret = ~0;
 	int err;
 
 	read_data = kzalloc(sizeof(*read_data), GFP_KERNEL);
@@ -111,20 +112,25 @@ static int hinic_dbg_get_func_table(struct hinic_dev *nic_dev, int idx)
 
 	switch (idx) {
 	case VALID:
-		return funcfg_table_elem->dw0.bs.valid;
+		ret = funcfg_table_elem->dw0.bs.valid;
+		break;
 	case RX_MODE:
-		return funcfg_table_elem->dw0.bs.nic_rx_mode;
+		ret = funcfg_table_elem->dw0.bs.nic_rx_mode;
+		break;
 	case MTU:
-		return funcfg_table_elem->dw1.bs.mtu;
+		ret = funcfg_table_elem->dw1.bs.mtu;
+		break;
 	case RQ_DEPTH:
-		return funcfg_table_elem->dw13.bs.cfg_rq_depth;
+		ret = funcfg_table_elem->dw13.bs.cfg_rq_depth;
+		break;
 	case QUEUE_NUM:
-		return funcfg_table_elem->dw13.bs.cfg_q_num;
+		ret = funcfg_table_elem->dw13.bs.cfg_q_num;
+		break;
 	}
 
 	kfree(read_data);
 
-	return ~0;
+	return ret;
 }
 
 static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer, size_t count,
-- 
2.35.1



