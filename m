Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AEB147D5A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733232AbgAXJ7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730321AbgAXJ7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:59:54 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34909222C2;
        Fri, 24 Jan 2020 09:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859993;
        bh=4Kl9fCG94ZHk3X7q6iG7NzcxzBX6palqpN/xDmT0XCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1W3CW5mspKhtfqzsKUWeXgheoNRF+vsnyK2hEdicQy9JQ/H47siNl5ggzedUjHyj
         2ymDXA+n+XGuYjIAyD6INQNa4GnKIcdrn+nk7POLck76TEX8y1p5Xxja5xdB/TG7rX
         EJtlX9KvM016eN5fJW/KGorpQcUKH7fhHC8Zad10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 233/343] qed: iWARP - Use READ_ONCE and smp_store_release to access ep->state
Date:   Fri, 24 Jan 2020 10:30:51 +0100
Message-Id: <20200124092950.813772686@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 6117561e1bb30b2fe7f51e1961f34dbedd0bec8a ]

Destroy QP waits for it's ep object state to be set to CLOSED
before proceeding. ep->state can be updated from a different
context. Add smp_store_release/READ_ONCE to synchronize.

Fixes: fc4c6065e661 ("qed: iWARP implement disconnect flows")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index bb09f5a9846f6..38d0f62bf037a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -509,7 +509,8 @@ int qed_iwarp_destroy_qp(struct qed_hwfn *p_hwfn, struct qed_rdma_qp *qp)
 
 	/* Make sure ep is closed before returning and freeing memory. */
 	if (ep) {
-		while (ep->state != QED_IWARP_EP_CLOSED && wait_count++ < 200)
+		while (READ_ONCE(ep->state) != QED_IWARP_EP_CLOSED &&
+		       wait_count++ < 200)
 			msleep(100);
 
 		if (ep->state != QED_IWARP_EP_CLOSED)
@@ -991,8 +992,6 @@ qed_iwarp_mpa_complete(struct qed_hwfn *p_hwfn,
 
 	params.ep_context = ep;
 
-	ep->state = QED_IWARP_EP_CLOSED;
-
 	switch (fw_return_code) {
 	case RDMA_RETURN_OK:
 		ep->qp->max_rd_atomic_req = ep->cm_info.ord;
@@ -1052,6 +1051,10 @@ qed_iwarp_mpa_complete(struct qed_hwfn *p_hwfn,
 		break;
 	}
 
+	if (fw_return_code != RDMA_RETURN_OK)
+		/* paired with READ_ONCE in destroy_qp */
+		smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
+
 	ep->event_cb(ep->cb_context, &params);
 
 	/* on passive side, if there is no associated QP (REJECT) we need to
@@ -2069,7 +2072,9 @@ void qed_iwarp_qp_in_error(struct qed_hwfn *p_hwfn,
 	params.status = (fw_return_code == IWARP_QP_IN_ERROR_GOOD_CLOSE) ?
 			 0 : -ECONNRESET;
 
-	ep->state = QED_IWARP_EP_CLOSED;
+	/* paired with READ_ONCE in destroy_qp */
+	smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
+
 	spin_lock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
 	list_del(&ep->list_entry);
 	spin_unlock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
@@ -2157,7 +2162,8 @@ qed_iwarp_tcp_connect_unsuccessful(struct qed_hwfn *p_hwfn,
 	params.event = QED_IWARP_EVENT_ACTIVE_COMPLETE;
 	params.ep_context = ep;
 	params.cm_info = &ep->cm_info;
-	ep->state = QED_IWARP_EP_CLOSED;
+	/* paired with READ_ONCE in destroy_qp */
+	smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
 
 	switch (fw_return_code) {
 	case IWARP_CONN_ERROR_TCP_CONNECT_INVALID_PACKET:
-- 
2.20.1



