Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5075F4832CE
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiACOa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59632 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbiACO3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B3A961073;
        Mon,  3 Jan 2022 14:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30516C36AED;
        Mon,  3 Jan 2022 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220193;
        bh=jW79NwrA5s7UCUAQZPXxrZcvh0YBbNo2kji+VARXfmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFmcj706MhUwpE3sPrAcGb01E1eHWz1Q6olBJE86RQuDNMeNk9s20ytE9ZRDrazmL
         roCRQaXNDrXANvBDwJb4Kyv9NkU/oVifhGVaxYumlwPaY7n9iXlqKa/QDPEFnwY+vl
         9zRI59UPdtsu2M0oomdCnmf9OvLAg4gLfphoyEcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/48] net/smc: improved fix wait on already cleared link
Date:   Mon,  3 Jan 2022 15:24:00 +0100
Message-Id: <20220103142054.250417489@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 95f7f3e7dc6bd2e735cb5de11734ea2222b1e05a ]

Commit 8f3d65c16679 ("net/smc: fix wait on already cleared link")
introduced link refcounting to avoid waits on already cleared links.
This patch extents and improves the refcounting to cover all
remaining possible cases for this kind of error situation.

Fixes: 15e1b99aadfb ("net/smc: no WR buffer wait for terminating link group")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_cdc.c  |  7 +++++-
 net/smc/smc_core.c | 20 ++++++++-------
 net/smc/smc_llc.c  | 63 +++++++++++++++++++++++++++++++++++-----------
 net/smc/smc_tx.c   | 22 ++++------------
 net/smc/smc_wr.h   | 14 +++++++++++
 5 files changed, 85 insertions(+), 41 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index b1ce6ccbfaec8..3602829006dda 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -150,9 +150,11 @@ static int smcr_cdc_get_slot_and_msg_send(struct smc_connection *conn)
 
 again:
 	link = conn->lnk;
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_cdc_get_free_slot(conn, link, &wr_buf, NULL, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 
 	spin_lock_bh(&conn->send_lock);
 	if (link != conn->lnk) {
@@ -160,6 +162,7 @@ again:
 		spin_unlock_bh(&conn->send_lock);
 		smc_wr_tx_put_slot(link,
 				   (struct smc_wr_tx_pend_priv *)pend);
+		smc_wr_tx_link_put(link);
 		if (again)
 			return -ENOLINK;
 		again = true;
@@ -167,6 +170,8 @@ again:
 	}
 	rc = smc_cdc_msg_send(conn, wr_buf, pend);
 	spin_unlock_bh(&conn->send_lock);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 3f1343dfa16ba..135949ef85b3c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -550,7 +550,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		to_lnk = &lgr->lnk[i];
 		break;
 	}
-	if (!to_lnk) {
+	if (!to_lnk || !smc_wr_tx_link_hold(to_lnk)) {
 		smc_lgr_terminate_sched(lgr);
 		return NULL;
 	}
@@ -582,24 +582,26 @@ again:
 		read_unlock_bh(&lgr->conns_lock);
 		/* pre-fetch buffer outside of send_lock, might sleep */
 		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
-		if (rc) {
-			smcr_link_down_cond_sched(to_lnk);
-			return NULL;
-		}
+		if (rc)
+			goto err_out;
 		/* avoid race with smcr_tx_sndbuf_nonempty() */
 		spin_lock_bh(&conn->send_lock);
 		conn->lnk = to_lnk;
 		rc = smc_switch_cursor(smc, pend, wr_buf);
 		spin_unlock_bh(&conn->send_lock);
 		sock_put(&smc->sk);
-		if (rc) {
-			smcr_link_down_cond_sched(to_lnk);
-			return NULL;
-		}
+		if (rc)
+			goto err_out;
 		goto again;
 	}
 	read_unlock_bh(&lgr->conns_lock);
+	smc_wr_tx_link_put(to_lnk);
 	return to_lnk;
+
+err_out:
+	smcr_link_down_cond_sched(to_lnk);
+	smc_wr_tx_link_put(to_lnk);
+	return NULL;
 }
 
 static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index d8fe4e1f24d1f..f1d323439a2af 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -383,9 +383,11 @@ int smc_llc_send_confirm_link(struct smc_link *link,
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	confllc = (struct smc_llc_msg_confirm_link *)wr_buf;
 	memset(confllc, 0, sizeof(*confllc));
 	confllc->hd.common.type = SMC_LLC_CONFIRM_LINK;
@@ -402,6 +404,8 @@ int smc_llc_send_confirm_link(struct smc_link *link,
 	confllc->max_links = SMC_LLC_ADD_LNK_MAX_LINKS;
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -415,9 +419,11 @@ static int smc_llc_send_confirm_rkey(struct smc_link *send_link,
 	struct smc_link *link;
 	int i, rc, rtok_ix;
 
+	if (!smc_wr_tx_link_hold(send_link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(send_link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	rkeyllc = (struct smc_llc_msg_confirm_rkey *)wr_buf;
 	memset(rkeyllc, 0, sizeof(*rkeyllc));
 	rkeyllc->hd.common.type = SMC_LLC_CONFIRM_RKEY;
@@ -444,6 +450,8 @@ static int smc_llc_send_confirm_rkey(struct smc_link *send_link,
 		(u64)sg_dma_address(rmb_desc->sgt[send_link->link_idx].sgl));
 	/* send llc message */
 	rc = smc_wr_tx_send(send_link, pend);
+put_out:
+	smc_wr_tx_link_put(send_link);
 	return rc;
 }
 
@@ -456,9 +464,11 @@ static int smc_llc_send_delete_rkey(struct smc_link *link,
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	rkeyllc = (struct smc_llc_msg_delete_rkey *)wr_buf;
 	memset(rkeyllc, 0, sizeof(*rkeyllc));
 	rkeyllc->hd.common.type = SMC_LLC_DELETE_RKEY;
@@ -467,6 +477,8 @@ static int smc_llc_send_delete_rkey(struct smc_link *link,
 	rkeyllc->rkey[0] = htonl(rmb_desc->mr_rx[link->link_idx]->rkey);
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -480,9 +492,11 @@ int smc_llc_send_add_link(struct smc_link *link, u8 mac[], u8 gid[],
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	addllc = (struct smc_llc_msg_add_link *)wr_buf;
 
 	memset(addllc, 0, sizeof(*addllc));
@@ -504,6 +518,8 @@ int smc_llc_send_add_link(struct smc_link *link, u8 mac[], u8 gid[],
 	}
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -517,9 +533,11 @@ int smc_llc_send_delete_link(struct smc_link *link, u8 link_del_id,
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	delllc = (struct smc_llc_msg_del_link *)wr_buf;
 
 	memset(delllc, 0, sizeof(*delllc));
@@ -536,6 +554,8 @@ int smc_llc_send_delete_link(struct smc_link *link, u8 link_del_id,
 	delllc->reason = htonl(reason);
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -547,9 +567,11 @@ static int smc_llc_send_test_link(struct smc_link *link, u8 user_data[16])
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	testllc = (struct smc_llc_msg_test_link *)wr_buf;
 	memset(testllc, 0, sizeof(*testllc));
 	testllc->hd.common.type = SMC_LLC_TEST_LINK;
@@ -557,6 +579,8 @@ static int smc_llc_send_test_link(struct smc_link *link, u8 user_data[16])
 	memcpy(testllc->user_data, user_data, sizeof(testllc->user_data));
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -567,13 +591,16 @@ static int smc_llc_send_message(struct smc_link *link, void *llcbuf)
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
-	if (!smc_link_usable(link))
+	if (!smc_wr_tx_link_hold(link))
 		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	memcpy(wr_buf, llcbuf, sizeof(union smc_llc_msg));
-	return smc_wr_tx_send(link, pend);
+	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
+	return rc;
 }
 
 /* schedule an llc send on link, may wait for buffers,
@@ -586,13 +613,16 @@ static int smc_llc_send_message_wait(struct smc_link *link, void *llcbuf)
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
-	if (!smc_link_usable(link))
+	if (!smc_wr_tx_link_hold(link))
 		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	memcpy(wr_buf, llcbuf, sizeof(union smc_llc_msg));
-	return smc_wr_tx_send_wait(link, pend, SMC_LLC_WAIT_TIME);
+	rc = smc_wr_tx_send_wait(link, pend, SMC_LLC_WAIT_TIME);
+put_out:
+	smc_wr_tx_link_put(link);
+	return rc;
 }
 
 /********************************* receive ***********************************/
@@ -672,9 +702,11 @@ static int smc_llc_add_link_cont(struct smc_link *link,
 	struct smc_buf_desc *rmb;
 	u8 n;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	addc_llc = (struct smc_llc_msg_add_link_cont *)wr_buf;
 	memset(addc_llc, 0, sizeof(*addc_llc));
 
@@ -706,7 +738,10 @@ static int smc_llc_add_link_cont(struct smc_link *link,
 	addc_llc->hd.length = sizeof(struct smc_llc_msg_add_link_cont);
 	if (lgr->role == SMC_CLNT)
 		addc_llc->hd.flags |= SMC_LLC_FLAG_RESP;
-	return smc_wr_tx_send(link, pend);
+	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
+	return rc;
 }
 
 static int smc_llc_cli_rkey_exchange(struct smc_link *link,
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index ff02952b3d03e..52ef1fca0b604 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -479,7 +479,7 @@ static int smc_tx_rdma_writes(struct smc_connection *conn,
 /* Wakeup sndbuf consumers from any context (IRQ or process)
  * since there is more data to transmit; usable snd_wnd as max transmit
  */
-static int _smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
+static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
 	struct smc_cdc_producer_flags *pflags = &conn->local_tx_ctrl.prod_flags;
 	struct smc_link *link = conn->lnk;
@@ -488,8 +488,11 @@ static int _smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!link || !smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_cdc_get_free_slot(conn, link, &wr_buf, &wr_rdma_buf, &pend);
 	if (rc < 0) {
+		smc_wr_tx_link_put(link);
 		if (rc == -EBUSY) {
 			struct smc_sock *smc =
 				container_of(conn, struct smc_sock, conn);
@@ -530,22 +533,7 @@ static int _smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 
 out_unlock:
 	spin_unlock_bh(&conn->send_lock);
-	return rc;
-}
-
-static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
-{
-	struct smc_link *link = conn->lnk;
-	int rc = -ENOLINK;
-
-	if (!link)
-		return rc;
-
-	atomic_inc(&link->wr_tx_refcnt);
-	if (smc_link_usable(link))
-		rc = _smcr_tx_sndbuf_nonempty(conn);
-	if (atomic_dec_and_test(&link->wr_tx_refcnt))
-		wake_up_all(&link->wr_tx_wait);
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index 423b8709f1c9e..2bc626f230a56 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -60,6 +60,20 @@ static inline void smc_wr_tx_set_wr_id(atomic_long_t *wr_tx_id, long val)
 	atomic_long_set(wr_tx_id, val);
 }
 
+static inline bool smc_wr_tx_link_hold(struct smc_link *link)
+{
+	if (!smc_link_usable(link))
+		return false;
+	atomic_inc(&link->wr_tx_refcnt);
+	return true;
+}
+
+static inline void smc_wr_tx_link_put(struct smc_link *link)
+{
+	if (atomic_dec_and_test(&link->wr_tx_refcnt))
+		wake_up_all(&link->wr_tx_wait);
+}
+
 static inline void smc_wr_wakeup_tx_wait(struct smc_link *lnk)
 {
 	wake_up_all(&lnk->wr_tx_wait);
-- 
2.34.1



