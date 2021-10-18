Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23194431EB1
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhJROFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234399AbhJROCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:02:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7DAE61A4F;
        Mon, 18 Oct 2021 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564587;
        bh=n8Y8orHOJZk6HlF9eOnhR4oJJ4dAf7zafslDH8GuH7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eO56bIVIGTNKlhScORAQk2x8tjsH5c6/kl+XS0iGuf+cO23Yb3n6kXt6T6CMnH0kt
         o8P8W6Q1PJY4oyrTk1GonrYtTV9rHo08lCuh62DkZ0UFPZwGKFXy5MCNiUAx/M2ufj
         0RxM01nObDqOtzfVTWGq5ELThz6JmhMoWO0Jzkyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 103/151] net/smc: improved fix wait on already cleared link
Date:   Mon, 18 Oct 2021 15:24:42 +0200
Message-Id: <20211018132344.024828114@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

commit 95f7f3e7dc6bd2e735cb5de11734ea2222b1e05a upstream.

Commit 8f3d65c16679 ("net/smc: fix wait on already cleared link")
introduced link refcounting to avoid waits on already cleared links.
This patch extents and improves the refcounting to cover all
remaining possible cases for this kind of error situation.

Fixes: 15e1b99aadfb ("net/smc: no WR buffer wait for terminating link group")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_cdc.c  |    7 +++++
 net/smc/smc_core.c |   20 +++++++++-------
 net/smc/smc_llc.c  |   63 +++++++++++++++++++++++++++++++++++++++++------------
 net/smc/smc_tx.c   |   22 ++++--------------
 net/smc/smc_wr.h   |   14 +++++++++++
 5 files changed, 85 insertions(+), 41 deletions(-)

--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -150,9 +150,11 @@ static int smcr_cdc_get_slot_and_msg_sen
 
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
 
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -949,7 +949,7 @@ struct smc_link *smc_switch_conns(struct
 		to_lnk = &lgr->lnk[i];
 		break;
 	}
-	if (!to_lnk) {
+	if (!to_lnk || !smc_wr_tx_link_hold(to_lnk)) {
 		smc_lgr_terminate_sched(lgr);
 		return NULL;
 	}
@@ -981,24 +981,26 @@ again:
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
 		smc_switch_link_and_count(conn, to_lnk);
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
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -383,9 +383,11 @@ int smc_llc_send_confirm_link(struct smc
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
@@ -402,6 +404,8 @@ int smc_llc_send_confirm_link(struct smc
 	confllc->max_links = SMC_LLC_ADD_LNK_MAX_LINKS;
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -415,9 +419,11 @@ static int smc_llc_send_confirm_rkey(str
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
@@ -444,6 +450,8 @@ static int smc_llc_send_confirm_rkey(str
 		(u64)sg_dma_address(rmb_desc->sgt[send_link->link_idx].sgl));
 	/* send llc message */
 	rc = smc_wr_tx_send(send_link, pend);
+put_out:
+	smc_wr_tx_link_put(send_link);
 	return rc;
 }
 
@@ -456,9 +464,11 @@ static int smc_llc_send_delete_rkey(stru
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
@@ -467,6 +477,8 @@ static int smc_llc_send_delete_rkey(stru
 	rkeyllc->rkey[0] = htonl(rmb_desc->mr_rx[link->link_idx]->rkey);
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -480,9 +492,11 @@ int smc_llc_send_add_link(struct smc_lin
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
@@ -504,6 +518,8 @@ int smc_llc_send_add_link(struct smc_lin
 	}
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -517,9 +533,11 @@ int smc_llc_send_delete_link(struct smc_
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
@@ -536,6 +554,8 @@ int smc_llc_send_delete_link(struct smc_
 	delllc->reason = htonl(reason);
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -547,9 +567,11 @@ static int smc_llc_send_test_link(struct
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
@@ -557,6 +579,8 @@ static int smc_llc_send_test_link(struct
 	memcpy(testllc->user_data, user_data, sizeof(testllc->user_data));
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -567,13 +591,16 @@ static int smc_llc_send_message(struct s
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
@@ -586,13 +613,16 @@ static int smc_llc_send_message_wait(str
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
@@ -672,9 +702,11 @@ static int smc_llc_add_link_cont(struct
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
 
@@ -706,7 +738,10 @@ static int smc_llc_add_link_cont(struct
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
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -496,7 +496,7 @@ static int smc_tx_rdma_writes(struct smc
 /* Wakeup sndbuf consumers from any context (IRQ or process)
  * since there is more data to transmit; usable snd_wnd as max transmit
  */
-static int _smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
+static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
 	struct smc_cdc_producer_flags *pflags = &conn->local_tx_ctrl.prod_flags;
 	struct smc_link *link = conn->lnk;
@@ -505,8 +505,11 @@ static int _smcr_tx_sndbuf_nonempty(stru
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
@@ -547,22 +550,7 @@ static int _smcr_tx_sndbuf_nonempty(stru
 
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
 
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -60,6 +60,20 @@ static inline void smc_wr_tx_set_wr_id(a
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


