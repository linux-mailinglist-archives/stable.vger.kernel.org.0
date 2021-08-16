Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD843ED611
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238921AbhHPNQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240301AbhHPNPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBF0D632E0;
        Mon, 16 Aug 2021 13:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119547;
        bh=Jb+gZGHh3vH9E8gtxG4rCG8qtKkbEd3bZ0UuZsoaFz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=As+fB0sRBu4+4a8Ss5shUB/TUFp8q6d5MFA7Zoy4hBuWAKH3iKyv+iBASe4HFT481
         kWh4Fjm2sGvizNxfHSjYlog0sT5Pa39GJbz9H0fILWuE/rHOMWn6Ew9wpsBmS5D1lt
         5acOEMgOzlFVhzJdSesCsvCXMgnmPSV9wARPpzMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 069/151] net/smc: fix wait on already cleared link
Date:   Mon, 16 Aug 2021 15:01:39 +0200
Message-Id: <20210816125446.347373994@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 8f3d65c166797746455553f4eaf74a5f89f996d4 ]

There can be a race between the waiters for a tx work request buffer
and the link down processing that finally clears the link. Although
all waiters are woken up before the link is cleared there might be
waiters which did not yet get back control and are still waiting.
This results in an access to a cleared wait queue head.

Fix this by introducing atomic reference counting around the wait calls,
and wait with the link clear processing until all waiters have finished.
Move the work request layer related calls into smc_wr.c and set the
link state to INACTIVE before calling smcr_link_clear() in
smc_llc_srv_add_link().

Fixes: 15e1b99aadfb ("net/smc: no WR buffer wait for terminating link group")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.h |  2 ++
 net/smc/smc_llc.c  | 10 ++++------
 net/smc/smc_tx.c   | 18 +++++++++++++++++-
 net/smc/smc_wr.c   | 10 ++++++++++
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 6d6fd1397c87..64d86298e4df 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -97,6 +97,7 @@ struct smc_link {
 	unsigned long		*wr_tx_mask;	/* bit mask of used indexes */
 	u32			wr_tx_cnt;	/* number of WR send buffers */
 	wait_queue_head_t	wr_tx_wait;	/* wait for free WR send buf */
+	atomic_t		wr_tx_refcnt;	/* tx refs to link */
 
 	struct smc_wr_buf	*wr_rx_bufs;	/* WR recv payload buffers */
 	struct ib_recv_wr	*wr_rx_ibs;	/* WR recv meta data */
@@ -109,6 +110,7 @@ struct smc_link {
 
 	struct ib_reg_wr	wr_reg;		/* WR register memory region */
 	wait_queue_head_t	wr_reg_wait;	/* wait for wr_reg result */
+	atomic_t		wr_reg_refcnt;	/* reg refs to link */
 	enum smc_wr_reg_state	wr_reg_state;	/* state of wr_reg request */
 
 	u8			gid[SMC_GID_SIZE];/* gid matching used vlan id*/
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 273eaf1bfe49..2e7560eba981 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -888,6 +888,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	if (!rc)
 		goto out;
 out_clear_lnk:
+	lnk_new->state = SMC_LNK_INACTIVE;
 	smcr_link_clear(lnk_new, false);
 out_reject:
 	smc_llc_cli_add_link_reject(qentry);
@@ -1184,6 +1185,7 @@ int smc_llc_srv_add_link(struct smc_link *link)
 		goto out_err;
 	return 0;
 out_err:
+	link_new->state = SMC_LNK_INACTIVE;
 	smcr_link_clear(link_new, false);
 	return rc;
 }
@@ -1286,10 +1288,8 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 	del_llc->reason = 0;
 	smc_llc_send_message(lnk, &qentry->msg); /* response */
 
-	if (smc_link_downing(&lnk_del->state)) {
-		if (smc_switch_conns(lgr, lnk_del, false))
-			smc_wr_tx_wait_no_pending_sends(lnk_del);
-	}
+	if (smc_link_downing(&lnk_del->state))
+		smc_switch_conns(lgr, lnk_del, false);
 	smcr_link_clear(lnk_del, true);
 
 	active_links = smc_llc_active_link_count(lgr);
@@ -1805,8 +1805,6 @@ void smc_llc_link_clear(struct smc_link *link, bool log)
 				    link->smcibdev->ibdev->name, link->ibport);
 	complete(&link->llc_testlink_resp);
 	cancel_delayed_work_sync(&link->llc_testlink_wrk);
-	smc_wr_wakeup_reg_wait(link);
-	smc_wr_wakeup_tx_wait(link);
 }
 
 /* register a new rtoken at the remote peer (for all links) */
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 4532c16bf85e..ff02952b3d03 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -479,7 +479,7 @@ static int smc_tx_rdma_writes(struct smc_connection *conn,
 /* Wakeup sndbuf consumers from any context (IRQ or process)
  * since there is more data to transmit; usable snd_wnd as max transmit
  */
-static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
+static int _smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
 	struct smc_cdc_producer_flags *pflags = &conn->local_tx_ctrl.prod_flags;
 	struct smc_link *link = conn->lnk;
@@ -533,6 +533,22 @@ out_unlock:
 	return rc;
 }
 
+static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
+{
+	struct smc_link *link = conn->lnk;
+	int rc = -ENOLINK;
+
+	if (!link)
+		return rc;
+
+	atomic_inc(&link->wr_tx_refcnt);
+	if (smc_link_usable(link))
+		rc = _smcr_tx_sndbuf_nonempty(conn);
+	if (atomic_dec_and_test(&link->wr_tx_refcnt))
+		wake_up_all(&link->wr_tx_wait);
+	return rc;
+}
+
 static int smcd_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
 	struct smc_cdc_producer_flags *pflags = &conn->local_tx_ctrl.prod_flags;
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index cbc73a7e4d59..a419e9af36b9 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -322,9 +322,12 @@ int smc_wr_reg_send(struct smc_link *link, struct ib_mr *mr)
 	if (rc)
 		return rc;
 
+	atomic_inc(&link->wr_reg_refcnt);
 	rc = wait_event_interruptible_timeout(link->wr_reg_wait,
 					      (link->wr_reg_state != POSTED),
 					      SMC_WR_REG_MR_WAIT_TIME);
+	if (atomic_dec_and_test(&link->wr_reg_refcnt))
+		wake_up_all(&link->wr_reg_wait);
 	if (!rc) {
 		/* timeout - terminate link */
 		smcr_link_down_cond_sched(link);
@@ -566,10 +569,15 @@ void smc_wr_free_link(struct smc_link *lnk)
 		return;
 	ibdev = lnk->smcibdev->ibdev;
 
+	smc_wr_wakeup_reg_wait(lnk);
+	smc_wr_wakeup_tx_wait(lnk);
+
 	if (smc_wr_tx_wait_no_pending_sends(lnk))
 		memset(lnk->wr_tx_mask, 0,
 		       BITS_TO_LONGS(SMC_WR_BUF_CNT) *
 						sizeof(*lnk->wr_tx_mask));
+	wait_event(lnk->wr_reg_wait, (!atomic_read(&lnk->wr_reg_refcnt)));
+	wait_event(lnk->wr_tx_wait, (!atomic_read(&lnk->wr_tx_refcnt)));
 
 	if (lnk->wr_rx_dma_addr) {
 		ib_dma_unmap_single(ibdev, lnk->wr_rx_dma_addr,
@@ -728,7 +736,9 @@ int smc_wr_create_link(struct smc_link *lnk)
 	memset(lnk->wr_tx_mask, 0,
 	       BITS_TO_LONGS(SMC_WR_BUF_CNT) * sizeof(*lnk->wr_tx_mask));
 	init_waitqueue_head(&lnk->wr_tx_wait);
+	atomic_set(&lnk->wr_tx_refcnt, 0);
 	init_waitqueue_head(&lnk->wr_reg_wait);
+	atomic_set(&lnk->wr_reg_refcnt, 0);
 	return rc;
 
 dma_unmap:
-- 
2.30.2



