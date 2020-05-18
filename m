Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027701D8632
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbgERRsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729933AbgERRsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:48:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D166320671;
        Mon, 18 May 2020 17:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824132;
        bh=OEMasGLuz+c2UXS9PLCnzW0dw2a1bMpm1NDuXLWIZXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZW5g3LGsZKQgujUxd2OsVmi3x6csOz0a0OKchEzMP2NqbA+Bf8gtruDgrlqR6QcV8
         N0rqAnD7FoikwFGv7em/8b/BSqIVAHquzhL+UZlYKGYBAzrh12hEVGmHPb9T4O7exS
         KA627pZbYRzUiSOoBcuMeIa/hgtzH9fQkbb+Xk/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 085/114] hinic: fix a bug of ndo_stop
Date:   Mon, 18 May 2020 19:36:57 +0200
Message-Id: <20200518173517.690851421@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit e8a1b0efd632d1c9db7d4e93da66377c7b524862 ]

if some function in ndo_stop interface returns failure because of
hardware fault, must go on excuting rest steps rather than return
failure directly, otherwise will cause memory leak.And bump the
timeout for SET_FUNC_STATE to ensure that cmd won't return failure
when hw is busy. Otherwise hw may stomp host memory if we free
memory regardless of the return value of SET_FUNC_STATE.

Fixes: 51ba902a16e6 ("net-next/hinic: Initialize hw interface")
Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c |   16 ++++++++++++----
 drivers/net/ethernet/huawei/hinic/hinic_main.c    |   18 +++---------------
 2 files changed, 15 insertions(+), 19 deletions(-)

--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -54,6 +54,8 @@
 
 #define MGMT_MSG_TIMEOUT                5000
 
+#define SET_FUNC_PORT_MGMT_TIMEOUT	25000
+
 #define mgmt_to_pfhwdev(pf_mgmt)        \
 		container_of(pf_mgmt, struct hinic_pfhwdev, pf_to_mgmt)
 
@@ -247,12 +249,13 @@ static int msg_to_mgmt_sync(struct hinic
 			    u8 *buf_in, u16 in_size,
 			    u8 *buf_out, u16 *out_size,
 			    enum mgmt_direction_type direction,
-			    u16 resp_msg_id)
+			    u16 resp_msg_id, u32 timeout)
 {
 	struct hinic_hwif *hwif = pf_to_mgmt->hwif;
 	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_recv_msg *recv_msg;
 	struct completion *recv_done;
+	unsigned long timeo;
 	u16 msg_id;
 	int err;
 
@@ -276,8 +279,9 @@ static int msg_to_mgmt_sync(struct hinic
 		goto unlock_sync_msg;
 	}
 
-	if (!wait_for_completion_timeout(recv_done,
-					 msecs_to_jiffies(MGMT_MSG_TIMEOUT))) {
+	timeo = msecs_to_jiffies(timeout ? timeout : MGMT_MSG_TIMEOUT);
+
+	if (!wait_for_completion_timeout(recv_done, timeo)) {
 		dev_err(&pdev->dev, "MGMT timeout, MSG id = %d\n", msg_id);
 		err = -ETIMEDOUT;
 		goto unlock_sync_msg;
@@ -351,6 +355,7 @@ int hinic_msg_to_mgmt(struct hinic_pf_to
 {
 	struct hinic_hwif *hwif = pf_to_mgmt->hwif;
 	struct pci_dev *pdev = hwif->pdev;
+	u32 timeout = 0;
 
 	if (sync != HINIC_MGMT_MSG_SYNC) {
 		dev_err(&pdev->dev, "Invalid MGMT msg type\n");
@@ -362,9 +367,12 @@ int hinic_msg_to_mgmt(struct hinic_pf_to
 		return -EINVAL;
 	}
 
+	if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
+		timeout = SET_FUNC_PORT_MGMT_TIMEOUT;
+
 	return msg_to_mgmt_sync(pf_to_mgmt, mod, cmd, buf_in, in_size,
 				buf_out, out_size, MGMT_DIRECT_SEND,
-				MSG_NOT_RESP);
+				MSG_NOT_RESP, timeout);
 }
 
 /**
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -473,7 +473,6 @@ static int hinic_close(struct net_device
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	unsigned int flags;
-	int err;
 
 	down(&nic_dev->mgmt_lock);
 
@@ -487,20 +486,9 @@ static int hinic_close(struct net_device
 
 	up(&nic_dev->mgmt_lock);
 
-	err = hinic_port_set_func_state(nic_dev, HINIC_FUNC_PORT_DISABLE);
-	if (err) {
-		netif_err(nic_dev, drv, netdev,
-			  "Failed to set func port state\n");
-		nic_dev->flags |= (flags & HINIC_INTF_UP);
-		return err;
-	}
-
-	err = hinic_port_set_state(nic_dev, HINIC_PORT_DISABLE);
-	if (err) {
-		netif_err(nic_dev, drv, netdev, "Failed to set port state\n");
-		nic_dev->flags |= (flags & HINIC_INTF_UP);
-		return err;
-	}
+	hinic_port_set_state(nic_dev, HINIC_PORT_DISABLE);
+
+	hinic_port_set_func_state(nic_dev, HINIC_FUNC_PORT_DISABLE);
 
 	free_rxqs(nic_dev);
 	free_txqs(nic_dev);


