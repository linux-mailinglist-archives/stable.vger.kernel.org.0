Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C181AC36C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392148AbgDPNmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:42:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441572AbgDPNmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D73402222C;
        Thu, 16 Apr 2020 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044567;
        bh=F86Uvr/8Vvq5iRg6CyvWRy8iUXPMXaS3bKVGg6vxyPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uo5dNhhS/UEycXGm4TfCeRS5HJIFNTS6mbvwjmMwOusjA/A+JGXj13FOauG9xbli9
         Y/U+ZbeLpxNHQ1Ik2uvnulZ64uokHur2+aza1+hPQrHYD4tBd1+Wvu/QXuEepgDWky
         SEsfEwWp2kvfV5ya58+39gzPf28pXaCsstySO4TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/232] hinic: fix the bug of clearing event queue
Date:   Thu, 16 Apr 2020 15:21:47 +0200
Message-Id: <20200416131318.053610461@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 614eaa943e9fc3fcdbd4aa0692ae84973d363333 ]

should disable eq irq before freeing it, must clear event queue
depth in hw before freeing relevant memory to avoid illegal
memory access and update consumer idx to avoid invalid interrupt

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index 79243b626ddbe..6a723c4757bce 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -188,7 +188,7 @@ static u8 eq_cons_idx_checksum_set(u32 val)
  * eq_update_ci - update the HW cons idx of event queue
  * @eq: the event queue to update the cons idx for
  **/
-static void eq_update_ci(struct hinic_eq *eq)
+static void eq_update_ci(struct hinic_eq *eq, u32 arm_state)
 {
 	u32 val, addr = EQ_CONS_IDX_REG_ADDR(eq);
 
@@ -202,7 +202,7 @@ static void eq_update_ci(struct hinic_eq *eq)
 
 	val |= HINIC_EQ_CI_SET(eq->cons_idx, IDX)    |
 	       HINIC_EQ_CI_SET(eq->wrapped, WRAPPED) |
-	       HINIC_EQ_CI_SET(EQ_ARMED, INT_ARMED);
+	       HINIC_EQ_CI_SET(arm_state, INT_ARMED);
 
 	val |= HINIC_EQ_CI_SET(eq_cons_idx_checksum_set(val), XOR_CHKSUM);
 
@@ -347,7 +347,7 @@ static void eq_irq_handler(void *data)
 	else if (eq->type == HINIC_CEQ)
 		ceq_irq_handler(eq);
 
-	eq_update_ci(eq);
+	eq_update_ci(eq, EQ_ARMED);
 }
 
 /**
@@ -702,7 +702,7 @@ static int init_eq(struct hinic_eq *eq, struct hinic_hwif *hwif,
 	}
 
 	set_eq_ctrls(eq);
-	eq_update_ci(eq);
+	eq_update_ci(eq, EQ_ARMED);
 
 	err = alloc_eq_pages(eq);
 	if (err) {
@@ -752,18 +752,28 @@ err_req_irq:
  **/
 static void remove_eq(struct hinic_eq *eq)
 {
-	struct msix_entry *entry = &eq->msix_entry;
-
-	free_irq(entry->vector, eq);
+	hinic_set_msix_state(eq->hwif, eq->msix_entry.entry,
+			     HINIC_MSIX_DISABLE);
+	free_irq(eq->msix_entry.vector, eq);
 
 	if (eq->type == HINIC_AEQ) {
 		struct hinic_eq_work *aeq_work = &eq->aeq_work;
 
 		cancel_work_sync(&aeq_work->work);
+		/* clear aeq_len to avoid hw access host memory */
+		hinic_hwif_write_reg(eq->hwif,
+				     HINIC_CSR_AEQ_CTRL_1_ADDR(eq->q_id), 0);
 	} else if (eq->type == HINIC_CEQ) {
 		tasklet_kill(&eq->ceq_tasklet);
+		/* clear ceq_len to avoid hw access host memory */
+		hinic_hwif_write_reg(eq->hwif,
+				     HINIC_CSR_CEQ_CTRL_1_ADDR(eq->q_id), 0);
 	}
 
+	/* update cons_idx to avoid invalid interrupt */
+	eq->cons_idx = hinic_hwif_read_reg(eq->hwif, EQ_PROD_IDX_REG_ADDR(eq));
+	eq_update_ci(eq, EQ_NOT_ARMED);
+
 	free_eq_pages(eq);
 }
 
-- 
2.20.1



