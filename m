Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F202499381
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385757AbiAXUeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51730 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382654AbiAXU0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:26:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E410961507;
        Mon, 24 Jan 2022 20:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C793AC340E5;
        Mon, 24 Jan 2022 20:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055963;
        bh=zmPrmCci9ND2nKShJYq9Ar62zaJchuZq8Y2H9EE5zlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1xapJ0jCN8lRZL4GYFTs9g1dwUFruQiihGckOX2USTZieN1BGnF0Ry6mmsRdvC+j
         h6ivslBE6S/z+MO5MyUbBwnUJF8ED2p1Zekupd4TUaHGmFHQOKJQRmjKg4Vo2hfiOq
         iKANgb+mRDeCNRbmqGMJ0IXJDZF6PpmEID0kEw8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Wen Gu <guwen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/846] net/smc: Reset conn->lgr when link group registration fails
Date:   Mon, 24 Jan 2022 19:37:20 +0100
Message-Id: <20220124184112.044939407@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 36595d8ad46d9e4c41cc7c48c4405b7c3322deac ]

SMC connections might fail to be registered in a link group due to
unable to find a usable link during its creation. As a result,
smc_conn_create() will return a failure and most resources related
to the connection won't be applied or initialized, such as
conn->abort_work or conn->lnk.

If smc_conn_free() is invoked later, it will try to access the
uninitialized resources related to the connection, thus causing
a warning or crash.

This patch tries to fix this by resetting conn->lgr to NULL if an
abnormal exit occurs in smc_lgr_register_conn(), thus avoiding the
access to uninitialized resources in smc_conn_free().

Meanwhile, the new created link group should be terminated if smc
connections can't be registered in it. So smc_lgr_cleanup_early() is
modified to take care of link group only and invoked to terminate
unusable link group by smc_conn_create(). The call to smc_conn_free()
is moved out from smc_lgr_cleanup_early() to smc_conn_abort().

Fixes: 56bc3b2094b4 ("net/smc: assign link to a new connection")
Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c   |  8 +++++---
 net/smc/smc_core.c | 12 +++++++-----
 net/smc/smc_core.h |  2 +-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index eea6d4a854e90..07ff719f39077 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -613,10 +613,12 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
 
 static void smc_conn_abort(struct smc_sock *smc, int local_first)
 {
+	struct smc_connection *conn = &smc->conn;
+	struct smc_link_group *lgr = conn->lgr;
+
+	smc_conn_free(conn);
 	if (local_first)
-		smc_lgr_cleanup_early(&smc->conn);
-	else
-		smc_conn_free(&smc->conn);
+		smc_lgr_cleanup_early(lgr);
 }
 
 /* check if there is a rdma device available for this connection. */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 506b8498623b0..79d5e6a90845d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -170,8 +170,10 @@ static int smc_lgr_register_conn(struct smc_connection *conn, bool first)
 
 	if (!conn->lgr->is_smcd) {
 		rc = smcr_lgr_conn_assign_link(conn, first);
-		if (rc)
+		if (rc) {
+			conn->lgr = NULL;
 			return rc;
+		}
 	}
 	/* find a new alert_token_local value not yet used by some connection
 	 * in this link group
@@ -579,15 +581,13 @@ int smcd_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-void smc_lgr_cleanup_early(struct smc_connection *conn)
+void smc_lgr_cleanup_early(struct smc_link_group *lgr)
 {
-	struct smc_link_group *lgr = conn->lgr;
 	spinlock_t *lgr_lock;
 
 	if (!lgr)
 		return;
 
-	smc_conn_free(conn);
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
 	/* do not use this link group for new connections */
@@ -1750,8 +1750,10 @@ create:
 		write_lock_bh(&lgr->conns_lock);
 		rc = smc_lgr_register_conn(conn, true);
 		write_unlock_bh(&lgr->conns_lock);
-		if (rc)
+		if (rc) {
+			smc_lgr_cleanup_early(lgr);
 			goto out;
+		}
 	}
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 51a3e8248ade2..9a0523f4c7ba6 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -419,7 +419,7 @@ static inline void smc_set_pci_values(struct pci_dev *pci_dev,
 struct smc_sock;
 struct smc_clc_msg_accept_confirm;
 
-void smc_lgr_cleanup_early(struct smc_connection *conn);
+void smc_lgr_cleanup_early(struct smc_link_group *lgr);
 void smc_lgr_terminate_sched(struct smc_link_group *lgr);
 void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport);
 void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport);
-- 
2.34.1



