Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E699723A48F
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgHCM2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728721AbgHCM2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC34204EC;
        Mon,  3 Aug 2020 12:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457710;
        bh=upQ0vadh/GU4f/aiUZGGppbmhZRBx7Ux6CJdmf4im6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKPeuSxrzJBnoRLM5z6ZteGxSvzDZ4jjynT9yPwif2GcEPHz5CEhLiMS4q/nYRc2g
         qoKdDCY5/ql6i8dyciwKShGFdD6/X8jhiZpAYBJOuik1jUzPPwgu2A/Lalt3RkA6bC
         RtpOsqJ+2NC+J6M2DX28I+cEKoqehSYm9/mMdbEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/90] net: hns3: fix aRFS FD rules leftover after add a user FD rule
Date:   Mon,  3 Aug 2020 14:19:08 +0200
Message-Id: <20200803121859.851258153@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
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
index d4652dea4569b..6c3d13110993f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5627,9 +5627,9 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	/* to avoid rule conflict, when user configure rule by ethtool,
 	 * we need to clear all arfs rules
 	 */
+	spin_lock_bh(&hdev->fd_rule_lock);
 	hclge_clear_arfs_rules(handle);
 
-	spin_lock_bh(&hdev->fd_rule_lock);
 	ret = hclge_fd_config_rule(hdev, rule);
 
 	spin_unlock_bh(&hdev->fd_rule_lock);
@@ -5672,6 +5672,7 @@ static int hclge_del_fd_entry(struct hnae3_handle *handle,
 	return ret;
 }
 
+/* make sure being called after lock up with fd_rule_lock */
 static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 				     bool clear_list)
 {
@@ -5684,7 +5685,6 @@ static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 	if (!hnae3_dev_fd_supported(hdev))
 		return;
 
-	spin_lock_bh(&hdev->fd_rule_lock);
 	for_each_set_bit(location, hdev->fd_bmap,
 			 hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
 		hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true, location,
@@ -5701,8 +5701,6 @@ static void hclge_del_all_fd_entries(struct hnae3_handle *handle,
 		bitmap_zero(hdev->fd_bmap,
 			    hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]);
 	}
-
-	spin_unlock_bh(&hdev->fd_rule_lock);
 }
 
 static int hclge_restore_fd_entries(struct hnae3_handle *handle)
@@ -6069,7 +6067,7 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 				      u16 flow_id, struct flow_keys *fkeys)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_fd_rule_tuples new_tuples;
+	struct hclge_fd_rule_tuples new_tuples = {};
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_fd_rule *rule;
 	u16 tmp_queue_id;
@@ -6079,20 +6077,18 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
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
@@ -6177,6 +6173,7 @@ static void hclge_rfs_filter_expire(struct hclge_dev *hdev)
 #endif
 }
 
+/* make sure being called after lock up with fd_rule_lock */
 static void hclge_clear_arfs_rules(struct hnae3_handle *handle)
 {
 #ifdef CONFIG_RFS_ACCEL
@@ -6221,10 +6218,14 @@ static void hclge_enable_fd(struct hnae3_handle *handle, bool enable)
 
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
@@ -6678,8 +6679,9 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
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



