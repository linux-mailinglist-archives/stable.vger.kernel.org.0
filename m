Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3243F3ED612
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhHPNQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240302AbhHPNPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C15161163;
        Mon, 16 Aug 2021 13:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119549;
        bh=S7mRn5lDKfRNIieZ7v5eL/gMsRJ8ZKDKU0rkd5AqwT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCK4y5jkfzUXE3y5rDiecw3pXPJFaI2BqHjgALwRA0MMj3bfrfn/BdO4HERZZqfNt
         z0qsxumP9X0Q2mBnOAZ9jNMgiiKKWfFxtuo5eWjraqGtym1SRd1bq3U0//zQmKIoZb
         sj78TOdqoUQFseEtkLDlB0mXGD15ymzaeo+DTuio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guvenc Gulce <guvenc@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 070/151] net/smc: Correct smc link connection counter in case of smc client
Date:   Mon, 16 Aug 2021 15:01:40 +0200
Message-Id: <20210816125446.389226705@linuxfoundation.org>
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

From: Guvenc Gulce <guvenc@linux.ibm.com>

[ Upstream commit 64513d269e8971aabb7e787955a1b320e3031306 ]

SMC clients may be assigned to a different link after the initial
connection between two peers was established. In such a case,
the connection counter was not correctly set.

Update the connection counter correctly when a smc client connection
is assigned to a different smc link.

Fixes: 07d51580ff65 ("net/smc: Add connection counters for links")
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Tested-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c   | 2 +-
 net/smc/smc_core.c | 4 ++--
 net/smc/smc_core.h | 2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 5eff7cccceff..66fbdc63f965 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -757,7 +757,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 			reason_code = SMC_CLC_DECL_NOSRVLINK;
 			goto connect_abort;
 		}
-		smc->conn.lnk = link;
+		smc_switch_link_and_count(&smc->conn, link);
 	}
 
 	/* create send buffer and rmb */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 0df85a12651e..39b24f98eac5 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -916,8 +916,8 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 	return rc;
 }
 
-static void smc_switch_link_and_count(struct smc_connection *conn,
-				      struct smc_link *to_lnk)
+void smc_switch_link_and_count(struct smc_connection *conn,
+			       struct smc_link *to_lnk)
 {
 	atomic_dec(&conn->lnk->conn_cnt);
 	conn->lnk = to_lnk;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 64d86298e4df..c043ecdca5c4 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -446,6 +446,8 @@ void smc_core_exit(void);
 int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 		   u8 link_idx, struct smc_init_info *ini);
 void smcr_link_clear(struct smc_link *lnk, bool log);
+void smc_switch_link_and_count(struct smc_connection *conn,
+			       struct smc_link *to_lnk);
 int smcr_buf_map_lgr(struct smc_link *lnk);
 int smcr_buf_reg_lgr(struct smc_link *lnk);
 void smcr_lgr_set_type(struct smc_link_group *lgr, enum smc_lgr_type new_type);
-- 
2.30.2



