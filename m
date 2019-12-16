Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AFA1217A1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfLPShk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:37:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbfLPSGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:06:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02FCC20700;
        Mon, 16 Dec 2019 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519560;
        bh=Fuzx3MD10UTEWpoIo+tb/rfAjkPW5zaJnqeC+50ff3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gk3dYV/kob478HhQqg0KBZUOoIux1OtmLuKRyVuV7qxvy1QZoLTTxTHcG8Ks4Q0fa
         J1+uKoAredTbnRVVnYuDAabz0TfAAP4f4oJCuynbQHtQGOIfqAv2JauZ7E7UQGyiWJ
         wsw3GU99sHn/8t1cSbvJln1QayZcziS53r/6E8oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/140] net/smc: do not wait under send_lock
Date:   Mon, 16 Dec 2019 18:49:44 +0100
Message-Id: <20191216174819.039049758@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 33f3fcc290671590821ff3c0c9396db1ec9b7d4c ]

smc_cdc_get_free_slot() might wait for free transfer buffers when using
SMC-R. This wait should not be done under the send_lock, which is a
spin_lock. This fixes a cpu loop in parallel threads waiting for the
send_lock.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_tx.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 0ecbbdc337b82..62885a2781c9a 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -486,25 +486,23 @@ static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
-	spin_lock_bh(&conn->send_lock);
 	rc = smc_cdc_get_free_slot(conn, &wr_buf, &pend);
 	if (rc < 0) {
 		if (rc == -EBUSY) {
 			struct smc_sock *smc =
 				container_of(conn, struct smc_sock, conn);
 
-			if (smc->sk.sk_err == ECONNABORTED) {
-				rc = sock_error(&smc->sk);
-				goto out_unlock;
-			}
+			if (smc->sk.sk_err == ECONNABORTED)
+				return sock_error(&smc->sk);
 			rc = 0;
 			if (conn->alert_token_local) /* connection healthy */
 				mod_delayed_work(system_wq, &conn->tx_work,
 						 SMC_TX_WORK_DELAY);
 		}
-		goto out_unlock;
+		return rc;
 	}
 
+	spin_lock_bh(&conn->send_lock);
 	if (!conn->local_tx_ctrl.prod_flags.urg_data_present) {
 		rc = smc_tx_rdma_writes(conn);
 		if (rc) {
-- 
2.20.1



