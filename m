Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60470111E92
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfLCXCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:02:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730101AbfLCWzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:55:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E82520803;
        Tue,  3 Dec 2019 22:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413701;
        bh=CQuBCBvKAAsOoZocCAsqj8Qd5e+iFxFP6/c3gZsHpI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJcNxhej0VcBTpBcJdUIMFfFhB5ov3OEWketlX5ODP+4N0HcW15N3S1sn5ut8+UGw
         0mNRmI9pMz51IbVdeGb6iFiT2nF2wO4z4ZO+1MsxZ3ObNj4Wvgv/YJB+5JPuPq+sB7
         Oj5r/Db3115KDNKEsbPa+lWNnO5YdJ47NZZWsWpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 230/321] net/smc: fix byte_order for rx_curs_confirmed
Date:   Tue,  3 Dec 2019 23:34:56 +0100
Message-Id: <20191203223439.079727632@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit ccc8ca9b90acb45a3309f922b2591b07b4e070ec ]

The recent change in the rx_curs_confirmed assignment disregards
byte order, which causes problems on little endian architectures.
This patch fixes it.

Fixes: b8649efad879 ("net/smc: fix sender_free computation") (net-tree)
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_cdc.c |  4 +---
 net/smc/smc_cdc.h | 19 ++++++++++---------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 8f691b5a44ddf..333e4353498f8 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -106,9 +106,7 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 
 	conn->tx_cdc_seq++;
 	conn->local_tx_ctrl.seqno = conn->tx_cdc_seq;
-	smc_host_msg_to_cdc((struct smc_cdc_msg *)wr_buf,
-			    &conn->local_tx_ctrl, conn);
-	smc_curs_copy(&cfed, &((struct smc_host_cdc_msg *)wr_buf)->cons, conn);
+	smc_host_msg_to_cdc((struct smc_cdc_msg *)wr_buf, conn, &cfed);
 	rc = smc_wr_tx_send(link, (struct smc_wr_tx_pend_priv *)pend);
 	if (!rc)
 		smc_curs_copy(&conn->rx_curs_confirmed, &cfed, conn);
diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 2377a51772d51..34d2e1450320a 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -186,26 +186,27 @@ static inline int smc_curs_diff_large(unsigned int size,
 
 static inline void smc_host_cursor_to_cdc(union smc_cdc_cursor *peer,
 					  union smc_host_cursor *local,
+					  union smc_host_cursor *save,
 					  struct smc_connection *conn)
 {
-	union smc_host_cursor temp;
-
-	smc_curs_copy(&temp, local, conn);
-	peer->count = htonl(temp.count);
-	peer->wrap = htons(temp.wrap);
+	smc_curs_copy(save, local, conn);
+	peer->count = htonl(save->count);
+	peer->wrap = htons(save->wrap);
 	/* peer->reserved = htons(0); must be ensured by caller */
 }
 
 static inline void smc_host_msg_to_cdc(struct smc_cdc_msg *peer,
-				       struct smc_host_cdc_msg *local,
-				       struct smc_connection *conn)
+				       struct smc_connection *conn,
+				       union smc_host_cursor *save)
 {
+	struct smc_host_cdc_msg *local = &conn->local_tx_ctrl;
+
 	peer->common.type = local->common.type;
 	peer->len = local->len;
 	peer->seqno = htons(local->seqno);
 	peer->token = htonl(local->token);
-	smc_host_cursor_to_cdc(&peer->prod, &local->prod, conn);
-	smc_host_cursor_to_cdc(&peer->cons, &local->cons, conn);
+	smc_host_cursor_to_cdc(&peer->prod, &local->prod, save, conn);
+	smc_host_cursor_to_cdc(&peer->cons, &local->cons, save, conn);
 	peer->prod_flags = local->prod_flags;
 	peer->conn_state_flags = local->conn_state_flags;
 }
-- 
2.20.1



