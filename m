Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C391ACBC1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442674AbgDPPtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896593AbgDPNc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:32:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11A7A22274;
        Thu, 16 Apr 2020 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043944;
        bh=11vf19ynF9ce2u3AKITi0k04euLov3bRklA1vKBe+5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ia/x7Or07z3rLfkwI3QYVW0EVKzj4y91xuza5om4wJxc5YPBPYciz765PJr7lnlDd
         lgccWwrsPLK4H2Qn/DnvBKpOIznNR8lwPXrtanBle1lcguLUvm65J4HjOLXIrqhK7v
         K739ThgJnj+PIyxLb/tkxX40Sk2lwBwDtPs1PtdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 018/257] hinic: fix wrong para of wait_for_completion_timeout
Date:   Thu, 16 Apr 2020 15:21:09 +0200
Message-Id: <20200416131328.185985326@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 0da7c322f116210ebfdda59c7da663a6fc5e9cc8 ]

the second input parameter of wait_for_completion_timeout should
be jiffies instead of millisecond

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 33f93cc25193a..5f2d57d1b2d37 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -389,7 +389,8 @@ static int cmdq_sync_cmd_direct_resp(struct hinic_cmdq *cmdq,
 
 	spin_unlock_bh(&cmdq->cmdq_lock);
 
-	if (!wait_for_completion_timeout(&done, CMDQ_TIMEOUT)) {
+	if (!wait_for_completion_timeout(&done,
+					 msecs_to_jiffies(CMDQ_TIMEOUT))) {
 		spin_lock_bh(&cmdq->cmdq_lock);
 
 		if (cmdq->errcode[curr_prod_idx] == &errcode)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index c1a6be6bf6a8c..8995e32dd1c00 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -43,7 +43,7 @@
 
 #define MSG_NOT_RESP                    0xFFFF
 
-#define MGMT_MSG_TIMEOUT                1000
+#define MGMT_MSG_TIMEOUT                5000
 
 #define mgmt_to_pfhwdev(pf_mgmt)        \
 		container_of(pf_mgmt, struct hinic_pfhwdev, pf_to_mgmt)
@@ -267,7 +267,8 @@ static int msg_to_mgmt_sync(struct hinic_pf_to_mgmt *pf_to_mgmt,
 		goto unlock_sync_msg;
 	}
 
-	if (!wait_for_completion_timeout(recv_done, MGMT_MSG_TIMEOUT)) {
+	if (!wait_for_completion_timeout(recv_done,
+					 msecs_to_jiffies(MGMT_MSG_TIMEOUT))) {
 		dev_err(&pdev->dev, "MGMT timeout, MSG id = %d\n", msg_id);
 		err = -ETIMEDOUT;
 		goto unlock_sync_msg;
-- 
2.20.1



