Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7BB1A0B58
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgDGKZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgDGKZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB5AA20644;
        Tue,  7 Apr 2020 10:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255137;
        bh=Wh7+AJAc0sRg46fVl7Ybp0b9uAqplY9N7kq8TJFnsXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aacAbNXJDMifQ1yWwkgoyZ4fjcyzvXsNOhJzm93TDz0gRxTvvyuJ+XTlFS5XqyMAH
         53qdDrLQ87POrgl1JmtjYIELAp7nkzV+pYyLvcbRrmZvnPZ9eHnwRCD1LZ0bfbjHEm
         iBIJ6xCbxN/PFaRvQbZeUpHlHNZPA/mz+u1VQUfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 45/46] net/smc: fix cleanup for linkgroup setup failures
Date:   Tue,  7 Apr 2020 12:22:16 +0200
Message-Id: <20200407101504.120133480@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

commit 51e3dfa8906ace90c809235b3d3afebc166b6433 upstream.

If an SMC connection to a certain peer is setup the first time,
a new linkgroup is created. In case of setup failures, such a
linkgroup is unusable and should disappear. As a first step the
linkgroup is removed from the linkgroup list in smc_lgr_forget().

There are 2 problems:
smc_listen_decline() might be called before linkgroup creation
resulting in a crash due to calling smc_lgr_forget() with
parameter NULL.
If a setup failure occurs after linkgroup creation, the connection
is never unregistered from the linkgroup, preventing linkgroup
freeing.

This patch introduces an enhanced smc_lgr_cleanup_early() function
which
* contains a linkgroup check for early smc_listen_decline()
  invocations
* invokes smc_conn_free() to guarantee unregistering of the
  connection.
* schedules fast linkgroup removal of the unusable linkgroup

And the unused function smcd_conn_free() is removed from smc_core.h.

Fixes: 3b2dec2603d5b ("net/smc: restructure client and server code in af_smc")
Fixes: 2a0674fffb6bc ("net/smc: improve abnormal termination of link groups")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/smc/af_smc.c   |   25 +++++++++++++++----------
 net/smc/smc_core.c |   12 ++++++++++++
 net/smc/smc_core.h |    2 +-
 3 files changed, 28 insertions(+), 11 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -512,15 +512,18 @@ static int smc_connect_decline_fallback(
 static int smc_connect_abort(struct smc_sock *smc, int reason_code,
 			     int local_contact)
 {
+	bool is_smcd = smc->conn.lgr->is_smcd;
+
 	if (local_contact == SMC_FIRST_CONTACT)
-		smc_lgr_forget(smc->conn.lgr);
-	if (smc->conn.lgr->is_smcd)
+		smc_lgr_cleanup_early(&smc->conn);
+	else
+		smc_conn_free(&smc->conn);
+	if (is_smcd)
 		/* there is only one lgr role for SMC-D; use server lock */
 		mutex_unlock(&smc_server_lgr_pending);
 	else
 		mutex_unlock(&smc_client_lgr_pending);
 
-	smc_conn_free(&smc->conn);
 	smc->connect_nonblock = 0;
 	return reason_code;
 }
@@ -1091,7 +1094,6 @@ static void smc_listen_out_err(struct sm
 	if (newsmcsk->sk_state == SMC_INIT)
 		sock_put(&new_smc->sk); /* passive closing */
 	newsmcsk->sk_state = SMC_CLOSED;
-	smc_conn_free(&new_smc->conn);
 
 	smc_listen_out(new_smc);
 }
@@ -1102,12 +1104,13 @@ static void smc_listen_decline(struct sm
 {
 	/* RDMA setup failed, switch back to TCP */
 	if (local_contact == SMC_FIRST_CONTACT)
-		smc_lgr_forget(new_smc->conn.lgr);
+		smc_lgr_cleanup_early(&new_smc->conn);
+	else
+		smc_conn_free(&new_smc->conn);
 	if (reason_code < 0) { /* error, no fallback possible */
 		smc_listen_out_err(new_smc);
 		return;
 	}
-	smc_conn_free(&new_smc->conn);
 	smc_switch_to_fallback(new_smc);
 	new_smc->fallback_rsn = reason_code;
 	if (reason_code && reason_code != SMC_CLC_DECL_PEERDECL) {
@@ -1170,16 +1173,18 @@ static int smc_listen_ism_init(struct sm
 			    new_smc->conn.lgr->vlan_id,
 			    new_smc->conn.lgr->smcd)) {
 		if (ini->cln_first_contact == SMC_FIRST_CONTACT)
-			smc_lgr_forget(new_smc->conn.lgr);
-		smc_conn_free(&new_smc->conn);
+			smc_lgr_cleanup_early(&new_smc->conn);
+		else
+			smc_conn_free(&new_smc->conn);
 		return SMC_CLC_DECL_SMCDNOTALK;
 	}
 
 	/* Create send and receive buffers */
 	if (smc_buf_create(new_smc, true)) {
 		if (ini->cln_first_contact == SMC_FIRST_CONTACT)
-			smc_lgr_forget(new_smc->conn.lgr);
-		smc_conn_free(&new_smc->conn);
+			smc_lgr_cleanup_early(&new_smc->conn);
+		else
+			smc_conn_free(&new_smc->conn);
 		return SMC_CLC_DECL_MEM;
 	}
 
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -162,6 +162,18 @@ static void smc_lgr_unregister_conn(stru
 	conn->lgr = NULL;
 }
 
+void smc_lgr_cleanup_early(struct smc_connection *conn)
+{
+	struct smc_link_group *lgr = conn->lgr;
+
+	if (!lgr)
+		return;
+
+	smc_conn_free(conn);
+	smc_lgr_forget(lgr);
+	smc_lgr_schedule_free_work_fast(lgr);
+}
+
 /* Send delete link, either as client to request the initiation
  * of the DELETE LINK sequence from server; or as server to
  * initiate the delete processing. See smc_llc_rx_delete_link().
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -296,6 +296,7 @@ struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
 
 void smc_lgr_forget(struct smc_link_group *lgr);
+void smc_lgr_cleanup_early(struct smc_connection *conn);
 void smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
 void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
@@ -316,7 +317,6 @@ int smc_vlan_by_tcpsk(struct socket *clc
 
 void smc_conn_free(struct smc_connection *conn);
 int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini);
-void smcd_conn_free(struct smc_connection *conn);
 void smc_lgr_schedule_free_work_fast(struct smc_link_group *lgr);
 int smc_core_init(void);
 void smc_core_exit(void);


