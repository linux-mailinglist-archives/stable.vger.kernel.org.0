Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3900E23A6CF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgHCMye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgHCMXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 342902076B;
        Mon,  3 Aug 2020 12:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457400;
        bh=5K8yZzDkipZ/HEQTB9fDYk/IC/b3+nBlZqhBFh1ALQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zz/S4Q+z7RXh8N9p2glHHxVDABmUXozJwLhqnF6e+A+UT1/1zN6urRqIzQtwMwgaA
         Tb9MzVXSisNb862Tk4wmr3/3WctmiESPuuBvzKthASzL4hAPgJfUkKQA+VQqVJi+kB
         tC/Q/j0kd6TejFwB2mAbw8pqR3vetLGS9grJ7wqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 053/120] net: hns3: fix for VLAN config when reset failed
Date:   Mon,  3 Aug 2020 14:18:31 +0200
Message-Id: <20200803121905.378939723@linuxfoundation.org>
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

[ Upstream commit b7b5d25bdd7bdea7d72a41e0a97b1b8f3dea2ee7 ]

When device is resetting or reset failed, firmware is unable to
handle mailbox. VLAN should not be configured in this case.

Fixes: fe4144d47eef ("net: hns3: sync VLAN filter entries when kill VLAN ID failed")
Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  7 ++++---
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 10 ++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index ae4c415b97e45..dfe247ad84751 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8534,11 +8534,12 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 	bool writen_to_tbl = false;
 	int ret = 0;
 
-	/* When device is resetting, firmware is unable to handle
-	 * mailbox. Just record the vlan id, and remove it after
+	/* When device is resetting or reset failed, firmware is unable to
+	 * handle mailbox. Just record the vlan id, and remove it after
 	 * reset finished.
 	 */
-	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) && is_kill) {
+	if ((test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) ||
+	     test_bit(HCLGE_STATE_RST_FAIL, &hdev->state)) && is_kill) {
 		set_bit(vlan_id, vport->vlan_del_fail_bmap);
 		return -EBUSY;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1bdff64bb70f9..0060fa643d0e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1322,11 +1322,12 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 	if (proto != htons(ETH_P_8021Q))
 		return -EPROTONOSUPPORT;
 
-	/* When device is resetting, firmware is unable to handle
-	 * mailbox. Just record the vlan id, and remove it after
+	/* When device is resetting or reset failed, firmware is unable to
+	 * handle mailbox. Just record the vlan id, and remove it after
 	 * reset finished.
 	 */
-	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state) && is_kill) {
+	if ((test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state) ||
+	     test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state)) && is_kill) {
 		set_bit(vlan_id, hdev->vlan_del_fail_bmap);
 		return -EBUSY;
 	}
@@ -3146,7 +3147,8 @@ void hclgevf_update_port_base_vlan_info(struct hclgevf_dev *hdev, u16 state,
 
 	rtnl_lock();
 
-	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state)) {
+	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state) ||
+	    test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state)) {
 		dev_warn(&hdev->pdev->dev,
 			 "is resetting when updating port based vlan info\n");
 		rtnl_unlock();
-- 
2.25.1



