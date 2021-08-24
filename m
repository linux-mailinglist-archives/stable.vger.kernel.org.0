Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A903F64C2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbhHXRHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239852AbhHXRFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:05:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84EC761501;
        Tue, 24 Aug 2021 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824378;
        bh=qon0AMhRRPKgmGhJwGKu2wgu5lQuEa/liFHyFJtUuTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHJDGtKZ7ZN+TK/bx1B8iAXm+Vn1WdC5lJQXo3WmZtU57A3J9bLQYkSG2Ii5ft0t/
         tboXvIIVPceKxsBpjOvO6q0bySR+n0M89LxflS7nEpHnBKeX+DjXczSkrzTGcqnBOO
         fTAuRLYC2RicA+EXAsALtyjwkArNNdlm5b4SLVKNqfRtdxqCIGHLnLcpmEEW+42Ynj
         ESdFlhL5Z25iHtSi32XoOCJ1T8AvNxH9d0vcGg1mNFuMf+ut5fjh/YttctZEy/EV2a
         Lj3+ESWNZ4SDrI/WFh18W8x7cGRXWbRC5lo1H//seiD/bmaPshcR4GnoL4XNYr4rVX
         s1TliUVqVLe4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/98] qede: fix crash in rmmod qede while automatic debug collection
Date:   Tue, 24 Aug 2021 12:57:58 -0400
Message-Id: <20210824165908.709932-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 3efc5899f656..f313fd730331 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -494,6 +494,7 @@ struct qede_fastpath {
 #define QEDE_SP_HW_ERR                  4
 #define QEDE_SP_ARFS_CONFIG             5
 #define QEDE_SP_AER			7
+#define QEDE_SP_DISABLE			8
 
 #ifdef CONFIG_RFS_ACCEL
 int qede_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 05e3a3b60269..d9a3c811ac8b 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1006,6 +1006,13 @@ static void qede_sp_task(struct work_struct *work)
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
@@ -1297,6 +1304,7 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 	qede_rdma_dev_remove(edev, (mode == QEDE_REMOVE_RECOVERY));
 
 	if (mode != QEDE_REMOVE_RECOVERY) {
+		set_bit(QEDE_SP_DISABLE, &edev->sp_flags);
 		unregister_netdev(ndev);
 
 		cancel_delayed_work_sync(&edev->sp_task);
-- 
2.30.2

