Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8664832F4
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiACOcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:32:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59974 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbiACOaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02B2961113;
        Mon,  3 Jan 2022 14:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDA7C36AEB;
        Mon,  3 Jan 2022 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220222;
        bh=3VjGqbWZWY/1mACvwPr2w8mC4atdzkzOWLEaS1/W7yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wqdv0hnh4KC1SrzRIYzCabNveKihgCuRUBrpBI334DHTN0bpswwPVVy4G8BBiFN22
         cYc7VUYPrYqvk8ns0dLUQEFKQXX7Tq2ldoS8QmtE/sTaPugX67bpMDDrsA3lJTyi+B
         i0u1Fs4WX2khbnpz1up+h362Hjw2B9RSUMfbUZ6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/48] net/smc: dont send CDC/LLC message if link not ready
Date:   Mon,  3 Jan 2022 15:24:01 +0100
Message-Id: <20220103142054.293164601@linuxfoundation.org>
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

From: Dust Li <dust.li@linux.alibaba.com>

[ Upstream commit 90cee52f2e780345d3629e278291aea5ac74f40f ]

We found smc_llc_send_link_delete_all() sometimes wait
for 2s timeout when testing with RDMA link up/down.
It is possible when a smc_link is in ACTIVATING state,
the underlaying QP is still in RESET or RTR state, which
cannot send any messages out.

smc_llc_send_link_delete_all() use smc_link_usable() to
checks whether the link is usable, if the QP is still in
RESET or RTR state, but the smc_link is in ACTIVATING, this
LLC message will always fail without any CQE entering the
CQ, and we will always wait 2s before timeout.

Since we cannot send any messages through the QP before
the QP enter RTS. I add a wrapper smc_link_sendable()
which checks the state of QP along with the link state.
And replace smc_link_usable() with smc_link_sendable()
in all LLC & CDC message sending routine.

Fixes: 5f08318f617b ("smc: connection data control (CDC)")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 2 +-
 net/smc/smc_core.h | 6 ++++++
 net/smc/smc_llc.c  | 2 +-
 net/smc/smc_wr.c   | 4 ++--
 net/smc/smc_wr.h   | 2 +-
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 135949ef85b3c..fb4327a81a0f0 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -226,7 +226,7 @@ static void smcr_lgr_link_deactivate_all(struct smc_link_group *lgr)
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		struct smc_link *lnk = &lgr->lnk[i];
 
-		if (smc_link_usable(lnk))
+		if (smc_link_sendable(lnk))
 			lnk->state = SMC_LNK_INACTIVE;
 	}
 	wake_up_all(&lgr->llc_msg_waiter);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 4745a9a5a28f5..9364d0f35ccec 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -359,6 +359,12 @@ static inline bool smc_link_usable(struct smc_link *lnk)
 	return true;
 }
 
+static inline bool smc_link_sendable(struct smc_link *lnk)
+{
+	return smc_link_usable(lnk) &&
+		lnk->qp_attr.cur_qp_state == IB_QPS_RTS;
+}
+
 static inline bool smc_link_active(struct smc_link *lnk)
 {
 	return lnk->state == SMC_LNK_ACTIVE;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index f1d323439a2af..ee1f0fdba0855 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1358,7 +1358,7 @@ void smc_llc_send_link_delete_all(struct smc_link_group *lgr, bool ord, u32 rsn)
 	delllc.reason = htonl(rsn);
 
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (!smc_link_usable(&lgr->lnk[i]))
+		if (!smc_link_sendable(&lgr->lnk[i]))
 			continue;
 		if (!smc_llc_send_message_wait(&lgr->lnk[i], &delllc))
 			break;
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index a71c9631f1ad3..cae22d240e0a6 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -169,7 +169,7 @@ void smc_wr_tx_cq_handler(struct ib_cq *ib_cq, void *cq_context)
 static inline int smc_wr_tx_get_free_slot_index(struct smc_link *link, u32 *idx)
 {
 	*idx = link->wr_tx_cnt;
-	if (!smc_link_usable(link))
+	if (!smc_link_sendable(link))
 		return -ENOLINK;
 	for_each_clear_bit(*idx, link->wr_tx_mask, link->wr_tx_cnt) {
 		if (!test_and_set_bit(*idx, link->wr_tx_mask))
@@ -212,7 +212,7 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
 	} else {
 		rc = wait_event_interruptible_timeout(
 			link->wr_tx_wait,
-			!smc_link_usable(link) ||
+			!smc_link_sendable(link) ||
 			lgr->terminating ||
 			(smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY),
 			SMC_WR_TX_WAIT_FREE_SLOT_TIME);
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index 2bc626f230a56..102d515757ee2 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -62,7 +62,7 @@ static inline void smc_wr_tx_set_wr_id(atomic_long_t *wr_tx_id, long val)
 
 static inline bool smc_wr_tx_link_hold(struct smc_link *link)
 {
-	if (!smc_link_usable(link))
+	if (!smc_link_sendable(link))
 		return false;
 	atomic_inc(&link->wr_tx_refcnt);
 	return true;
-- 
2.34.1



