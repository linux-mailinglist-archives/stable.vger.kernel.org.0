Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DC94FDA85
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353957AbiDLHiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353124AbiDLHdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:33:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C2050B05;
        Tue, 12 Apr 2022 00:08:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFF00B81B4F;
        Tue, 12 Apr 2022 07:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20485C385A1;
        Tue, 12 Apr 2022 07:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747333;
        bh=R+OxrBqZV7ygX3E3Xvoy9v1rAvn5mARN24vjLcFSEoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZPyUrNc1zUifUOlf+DT6yu4viDa/bYXX3i04IX+tSGgGfANlLrIPkHeZlEuZ6iWo
         zFhKwFEC2fs+d71N9WQzYACO62apU4of3rAxuLElfQIGau/Ujz8kqyhBlJeo0pNtvc
         SzWpeCs03y+7WlmV6vebFrRBdvsxCVWM7DfG1QX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 041/343] net/smc: Send directly when TCP_CORK is cleared
Date:   Tue, 12 Apr 2022 08:27:39 +0200
Message-Id: <20220412062952.292562944@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

[ Upstream commit ea785a1a573b390a150010b3c5b81e1ccd8c98a8 ]

According to the man page of TCP_CORK [1], if set, don't send out
partial frames. All queued partial frames are sent when option is
cleared again.

When applications call setsockopt to disable TCP_CORK, this call is
protected by lock_sock(), and tries to mod_delayed_work() to 0, in order
to send pending data right now. However, the delayed work smc_tx_work is
also protected by lock_sock(). There introduces lock contention for
sending data.

To fix it, send pending data directly which acts like TCP, without
lock_sock() protected in the context of setsockopt (already lock_sock()ed),
and cancel unnecessary dealyed work, which is protected by lock.

[1] https://linux.die.net/man/7/tcp

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c |  4 ++--
 net/smc/smc_tx.c | 25 +++++++++++++++----------
 net/smc/smc_tx.h |  1 +
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 284befa90967..67fc72047c9c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2636,8 +2636,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		    sk->sk_state != SMC_CLOSED) {
 			if (!val) {
 				SMC_STAT_INC(smc, cork_cnt);
-				mod_delayed_work(smc->conn.lgr->tx_wq,
-						 &smc->conn.tx_work, 0);
+				smc_tx_pending(&smc->conn);
+				cancel_delayed_work(&smc->conn.tx_work);
 			}
 		}
 		break;
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index be241d53020f..7b0b6e24582f 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -597,27 +597,32 @@ int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
 	return rc;
 }
 
-/* Wakeup sndbuf consumers from process context
- * since there is more data to transmit
- */
-void smc_tx_work(struct work_struct *work)
+void smc_tx_pending(struct smc_connection *conn)
 {
-	struct smc_connection *conn = container_of(to_delayed_work(work),
-						   struct smc_connection,
-						   tx_work);
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 	int rc;
 
-	lock_sock(&smc->sk);
 	if (smc->sk.sk_err)
-		goto out;
+		return;
 
 	rc = smc_tx_sndbuf_nonempty(conn);
 	if (!rc && conn->local_rx_ctrl.prod_flags.write_blocked &&
 	    !atomic_read(&conn->bytes_to_rcv))
 		conn->local_rx_ctrl.prod_flags.write_blocked = 0;
+}
+
+/* Wakeup sndbuf consumers from process context
+ * since there is more data to transmit
+ */
+void smc_tx_work(struct work_struct *work)
+{
+	struct smc_connection *conn = container_of(to_delayed_work(work),
+						   struct smc_connection,
+						   tx_work);
+	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
-out:
+	lock_sock(&smc->sk);
+	smc_tx_pending(conn);
 	release_sock(&smc->sk);
 }
 
diff --git a/net/smc/smc_tx.h b/net/smc/smc_tx.h
index 07e6ad76224a..a59f370b8b43 100644
--- a/net/smc/smc_tx.h
+++ b/net/smc/smc_tx.h
@@ -27,6 +27,7 @@ static inline int smc_tx_prepared_sends(struct smc_connection *conn)
 	return smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);
 }
 
+void smc_tx_pending(struct smc_connection *conn);
 void smc_tx_work(struct work_struct *work);
 void smc_tx_init(struct smc_sock *smc);
 int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len);
-- 
2.35.1



