Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A353FDA73
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244468AbhIAMcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244901AbhIAMbk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A44DD610C7;
        Wed,  1 Sep 2021 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499444;
        bh=dpZviuB18/f2+QVvv/GObX4eLrcajeiFgytlhcVkGzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8yAz1fxssOlG9dTDScjtLBzVCA/g0sZhSR7QXIh8KvVkZUxoiAUUgUm3bXohSbFU
         HQw5d385zMqxpqxxPg4PUTe3CS975NSSN3XFSN/qP3gum+JkFjCCoLujp5AKmrpdCb
         HrsZQR425dt6T+ENbah8hPE2BVxwXmvntrStZzCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/33] qed: qed ll2 race condition fixes
Date:   Wed,  1 Sep 2021 14:28:13 +0200
Message-Id: <20210901122251.591791007@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit 37110237f31105d679fc0aa7b11cdec867750ea7 ]

Avoiding qed ll2 race condition and NULL pointer dereference as part
of the remove and recovery flows.

Changes form V1:
- Change (!p_rx->set_prod_addr).
- qed_ll2.c checkpatch fixes.

Change from V2:
- Revert "qed_ll2.c checkpatch fixes".

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 2847509a183d..cb3569ac85f7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -354,6 +354,9 @@ static int qed_ll2_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	unsigned long flags;
 	int rc = -EINVAL;
 
+	if (!p_ll2_conn)
+		return rc;
+
 	spin_lock_irqsave(&p_tx->lock, flags);
 	if (p_tx->b_completing_packet) {
 		rc = -EBUSY;
@@ -527,7 +530,16 @@ static int qed_ll2_rxq_completion(struct qed_hwfn *p_hwfn, void *cookie)
 	unsigned long flags = 0;
 	int rc = 0;
 
+	if (!p_ll2_conn)
+		return rc;
+
 	spin_lock_irqsave(&p_rx->lock, flags);
+
+	if (!QED_LL2_RX_REGISTERED(p_ll2_conn)) {
+		spin_unlock_irqrestore(&p_rx->lock, flags);
+		return 0;
+	}
+
 	cq_new_idx = le16_to_cpu(*p_rx->p_fw_cons);
 	cq_old_idx = qed_chain_get_cons_idx(&p_rx->rcq_chain);
 
@@ -848,6 +860,9 @@ static int qed_ll2_lb_rxq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	struct qed_ll2_info *p_ll2_conn = (struct qed_ll2_info *)p_cookie;
 	int rc;
 
+	if (!p_ll2_conn)
+		return 0;
+
 	if (!QED_LL2_RX_REGISTERED(p_ll2_conn))
 		return 0;
 
@@ -871,6 +886,9 @@ static int qed_ll2_lb_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	u16 new_idx = 0, num_bds = 0;
 	int rc;
 
+	if (!p_ll2_conn)
+		return 0;
+
 	if (!QED_LL2_TX_REGISTERED(p_ll2_conn))
 		return 0;
 
@@ -1628,6 +1646,8 @@ int qed_ll2_post_rx_buffer(void *cxt,
 	if (!p_ll2_conn)
 		return -EINVAL;
 	p_rx = &p_ll2_conn->rx_queue;
+	if (!p_rx->set_prod_addr)
+		return -EIO;
 
 	spin_lock_irqsave(&p_rx->lock, flags);
 	if (!list_empty(&p_rx->free_descq))
-- 
2.30.2



