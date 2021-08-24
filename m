Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDE83F639A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhHXQ5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233501AbhHXQ5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35D5A6138B;
        Tue, 24 Aug 2021 16:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824186;
        bh=E9kaRJxVpf+8P2HM+fpUkNC7dS+kvhRtWM9VeXt2BJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mj3KWHcy6Lga6twtOnJvHuC8lxLjJCXgrcclfj0hLtVLM78JjYrmE1kf3KosnIzlT
         Ra06GrLM6JFO/dRkGe5EgvpI2yJKCifmqUL5MbKJSUI9wDP9RI5W84mUvqdfs/yzVI
         yGVcjNIxDgFNR0qWJS/nRdAEH0axvyFbhej20N1dmNA6MnwE4sNgdvvxWr6aDEthL9
         4zFz5qO/VB3350JE8kDx7UdAuphggUsadw1bPOmNecpU5Sc3ROS2ofKnr7QSxYGaIz
         WQ0546+ZzhTbiDUP5b74/6YmG1yFvaBISLbBkRioeY4WegKV43Ns7KVAwp+V4r2/48
         vHgX3wnDHT5ZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 017/127] qede: fix crash in rmmod qede while automatic debug collection
Date:   Tue, 24 Aug 2021 12:54:17 -0400
Message-Id: <20210824165607.709387-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

[ Upstream commit 1159e25c137422bdc48ee96e3fb014bd942092c6 ]

A crash has been observed if rmmod is done while automatic debug
collection in progress. It is due to a race  condition between
both of them.

To fix stop the sp_task during unload to avoid running qede_sp_task
even if they are schedule during removal process.

Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede.h      | 1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 2e62a2c4eb63..5630008f38b7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -501,6 +501,7 @@ struct qede_fastpath {
 #define QEDE_SP_HW_ERR                  4
 #define QEDE_SP_ARFS_CONFIG             5
 #define QEDE_SP_AER			7
+#define QEDE_SP_DISABLE			8
 
 #ifdef CONFIG_RFS_ACCEL
 int qede_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 01ac1e93d27a..7c6064baeba2 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1009,6 +1009,13 @@ static void qede_sp_task(struct work_struct *work)
 	struct qede_dev *edev = container_of(work, struct qede_dev,
 					     sp_task.work);
 
+	/* Disable execution of this deferred work once
+	 * qede removal is in progress, this stop any future
+	 * scheduling of sp_task.
+	 */
+	if (test_bit(QEDE_SP_DISABLE, &edev->sp_flags))
+		return;
+
 	/* The locking scheme depends on the specific flag:
 	 * In case of QEDE_SP_RECOVERY, acquiring the RTNL lock is required to
 	 * ensure that ongoing flows are ended and new ones are not started.
@@ -1300,6 +1307,7 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 	qede_rdma_dev_remove(edev, (mode == QEDE_REMOVE_RECOVERY));
 
 	if (mode != QEDE_REMOVE_RECOVERY) {
+		set_bit(QEDE_SP_DISABLE, &edev->sp_flags);
 		unregister_netdev(ndev);
 
 		cancel_delayed_work_sync(&edev->sp_task);
-- 
2.30.2

