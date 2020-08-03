Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB2223A424
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgHCMXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgHCMXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A21C20775;
        Mon,  3 Aug 2020 12:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457398;
        bh=aSgBZZ3WxASOQs9tP6z2R1qM/vh8yYYpRtEu8M9Ki+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZzPg15NBibc1G59/zQKe6zpecbng+9mLGab5PrE0oN3S2e3MC7z03X2dkhlEkriB
         UvixzY0VcgS9/E7TBoOWKcL/71LANaaDIaHRjBD9BjeAF5oRDHNWCEh0wjPtHPwfQu
         M67TMWGKKnRC5qREkbhuhX4XdSL2Mpzl5AWzFkY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 052/120] net: hns3: fix aRFS FD rules leftover after add a user FD rule
Date:   Mon,  3 Aug 2020 14:18:30 +0200
Message-Id: <20200803121905.331289317@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

[ Upstream commit efe3fa45f770f1d66e2734ee7a3523c75694ff04 ]

When user had created a FD rule, all the aRFS rules should be clear up.
HNS3 process flow as below:
1.get spin lock of fd_ruls_list
2.clear up all aRFS rules
3.release lock
4.get spin lock of fd_ruls_list
5.creat a rules
6.release lock;

There is a short period of time between step 3 and step 4, which would
creatting some new aRFS FD rules if driver was receiving packet.
So refactor the fd_rule_lock to fix it.

Fixes: 441228875706 ("net: hns3: refine the flow director handle")
Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b66b93f320b42..ae4c415b97e45 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5737,9 +5737,9 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	/* to avoid rule conflict, when user configure rule by ethtool,
 	 * we need to clear all arfs rules
 	 */
+	spin_lock_bh(&hdev->fd_rule_lock);
 	hclge_clear_arfs_rules(handle);
 
-	spin_lock_bh(&hdev->fd_rule_lock);
 	ret = hclge_fd_config_rule(hdev, rule);
 
 	spin_unlock_bh(&hdev->fd_rule_lock);
@@ -5782,6 +5782,7 @@ static int hclge_del_fd_entry(struct hnae3_handle *handle,
 	return ret;
 }
 
+/* make sure being called after lock up with fd_rule_lock */
 static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 				     bool clear_list)
 {
@@ -5794,7 +5795,6 @@ static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 	if (!hnae3_dev_fd_supported(hdev))
 		return;
 
-	spin_lock_bh(&hdev->fd_rule_lock);
 	for_each_set_bit(location, hdev->fd_bmap,
 			 hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
 		hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true, location,
@@ -5811,8 +5811,6 @@ static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 		bitmap_zero(hdev->fd_bmap,
 			    hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]);
 	}
-
-	spin_unlock_bh(&hdev->fd_rule_lock);
 }
 
 static int hclge_restore_fd_entries(struct hnae3_handle *handle)
@@ -6179,7 +6177,7 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 				      u16 flow_id, struct flow_keys *fkeys)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_fd_rule_tuples new_tuples;
+	struct hclge_fd_rule_tuples new_tuples = {};
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_fd_rule *rule;
 	u16 tmp_queue_id;
@@ -6189,20 +6187,18 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 	if (!hnae3_dev_fd_supported(hdev))
 		return -EOPNOTSUPP;
 
-	memset(&new_tuples, 0, sizeof(new_tuples));
-	hclge_fd_get_flow_tuples(fkeys, &new_tuples);
-
-	spin_lock_bh(&hdev->fd_rule_lock);
-
 	/* when there is already fd rule existed add by user,
 	 * arfs should not work
 	 */
+	spin_lock_bh(&hdev->fd_rule_lock);
 	if (hdev->fd_active_type == HCLGE_FD_EP_ACTIVE) {
 		spin_unlock_bh(&hdev->fd_rule_lock);
 
 		return -EOPNOTSUPP;
 	}
 
+	hclge_fd_get_flow_tuples(fkeys, &new_tuples);
+
 	/* check is there flow director filter existed for this flow,
 	 * if not, create a new filter for it;
 	 * if filter exist with different queue id, modify the filter;
@@ -6287,6 +6283,7 @@ static void hclge_rfs_filter_expire(struct hclge_dev *hdev)
 #endif
 }
 
+/* make sure being called after lock up with fd_rule_lock */
 static void hclge_clear_arfs_rules(struct hnae3_handle *handle)
 {
 #ifdef CONFIG_RFS_ACCEL
@@ -6331,10 +6328,14 @@ static void hclge_enable_fd(struct hnae3_handle *handle, bool enable)
 
 	hdev->fd_en = enable;
 	clear = hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE;
-	if (!enable)
+
+	if (!enable) {
+		spin_lock_bh(&hdev->fd_rule_lock);
 		hclge_del_all_fd_entries(handle, clear);
-	else
+		spin_unlock_bh(&hdev->fd_rule_lock);
+	} else {
 		hclge_restore_fd_entries(handle);
+	}
 }
 
 static void hclge_cfg_mac_mode(struct hclge_dev *hdev, bool enable)
@@ -6799,8 +6800,9 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 	int i;
 
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
-
+	spin_lock_bh(&hdev->fd_rule_lock);
 	hclge_clear_arfs_rules(handle);
+	spin_unlock_bh(&hdev->fd_rule_lock);
 
 	/* If it is not PF reset, the firmware will disable the MAC,
 	 * so it only need to stop phy here.
-- 
2.25.1



