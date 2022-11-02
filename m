Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3556061585A
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiKBCuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiKBCuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529871F9CD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06221B82075
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C28C433C1;
        Wed,  2 Nov 2022 02:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357413;
        bh=sOInzPtP8lXgKqDmoe2QjiMo59HXozo9QBb+wiglYG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1Htn4b8ySLj71QoXClSxqJmjxtTsQpUXjojOIsx16spEgcx+bDjXMPsHv64YbP/X
         YNrIxTRNs9/WZXp5y1LpWmTE6NhsbxFzxOH7XHE6lhsqH+OVJvRzoVlUoMgAs4aEO0
         8rk3B4DGJQPI/S56CimMjVZD0A6P+iXANLJ+pf0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 166/240] net: hinic: fix memory leak when reading function table
Date:   Wed,  2 Nov 2022 03:32:21 +0100
Message-Id: <20221102022115.136916966@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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



