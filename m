Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F9F1481E3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390981AbgAXLXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391338AbgAXLXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:23:34 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E94CD206D4;
        Fri, 24 Jan 2020 11:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865012;
        bh=3zzxrY043VOacSysViHqR4O9nVOrozHGqKOsPmJqvJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhiGzNUoFDX7Y22aPu+dpzIJCPqrgOrPiWyxUefe6nKHdFWgwvgFC+naFKiTTIbED
         Ht0jwUK4vbhhyZpaqTGWKQZUzREI4/ECtGveDX8jYXm8RIQuKMlKlV+2s+wZLNah7C
         08ErPcKffTfijAp+kVXbVPPPhsVubL4fAjIOAM44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 428/639] qed: iWARP - Use READ_ONCE and smp_store_release to access ep->state
Date:   Fri, 24 Jan 2020 10:29:58 +0100
Message-Id: <20200124093140.627981240@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index 7002a660b6b4c..c77babd0ef952 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -532,7 +532,8 @@ int qed_iwarp_destroy_qp(struct qed_hwfn *p_hwfn, struct qed_rdma_qp *qp)
 
 	/* Make sure ep is closed before returning and freeing memory. */
 	if (ep) {
-		while (ep->state != QED_IWARP_EP_CLOSED && wait_count++ < 200)
+		while (READ_ONCE(ep->state) != QED_IWARP_EP_CLOSED &&
+		       wait_count++ < 200)
 			msleep(100);
 
 		if (ep->state != QED_IWARP_EP_CLOSED)
@@ -1023,8 +1024,6 @@ qed_iwarp_mpa_complete(struct qed_hwfn *p_hwfn,
 
 	params.ep_context = ep;
 
-	ep->state = QED_IWARP_EP_CLOSED;
-
 	switch (fw_return_code) {
 	case RDMA_RETURN_OK:
 		ep->qp->max_rd_atomic_req = ep->cm_info.ord;
@@ -1084,6 +1083,10 @@ qed_iwarp_mpa_complete(struct qed_hwfn *p_hwfn,
 		break;
 	}
 
+	if (fw_return_code != RDMA_RETURN_OK)
+		/* paired with READ_ONCE in destroy_qp */
+		smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
+
 	ep->event_cb(ep->cb_context, &params);
 
 	/* on passive side, if there is no associated QP (REJECT) we need to
@@ -2828,7 +2831,9 @@ static void qed_iwarp_qp_in_error(struct qed_hwfn *p_hwfn,
 	params.status = (fw_return_code == IWARP_QP_IN_ERROR_GOOD_CLOSE) ?
 			 0 : -ECONNRESET;
 
-	ep->state = QED_IWARP_EP_CLOSED;
+	/* paired with READ_ONCE in destroy_qp */
+	smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
+
 	spin_lock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
 	list_del(&ep->list_entry);
 	spin_unlock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
@@ -2917,7 +2922,8 @@ qed_iwarp_tcp_connect_unsuccessful(struct qed_hwfn *p_hwfn,
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



