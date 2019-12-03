Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F231E111D90
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbfLCWyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:54:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730049AbfLCWyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F02F20656;
        Tue,  3 Dec 2019 22:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413688;
        bh=WDj1lebzsJppGjn2JeS5Fu1Vx3UyS1VisVUioDpEbow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XK7GWyltihzqp2N1ObLAkjoBxmSnmDUPAG2JgZAi2mjbsoPsu6nEU5usiStmHPgn4
         W52iX3ufChsLPVCHIumm+C4Wsk/9941x7MhkLkuk/fVVmfONsbZUSwGY6rLNnnRha1
         Utl8Kw7KMxYzODuYNCwZjz/PB5MJu/vBBT8Ln+Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 225/321] net/smc: dont wait for send buffer space when data was already sent
Date:   Tue,  3 Dec 2019 23:34:51 +0100
Message-Id: <20191203223438.820789861@linuxfoundation.org>
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

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 6889b36da78a21a312d8b462c1fa25a03c2ff192 ]

When there is no more send buffer space and at least 1 byte was already
sent then return to user space. The wait is only done when no data was
sent by the sendmsg() call.
This fixes smc_tx_sendmsg() which tried to always send all user data and
started to wait for free send buffer space when needed. During this wait
the user space program was blocked in the sendmsg() call and hence not
able to receive incoming data. When both sides were in such a situation
then the connection stalled forever.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_tx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 28361aef99825..f1f621675db01 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -163,12 +163,11 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 			conn->local_tx_ctrl.prod_flags.urg_data_pending = 1;
 
 		if (!atomic_read(&conn->sndbuf_space) || conn->urg_tx_pend) {
+			if (send_done)
+				return send_done;
 			rc = smc_tx_wait(smc, msg->msg_flags);
-			if (rc) {
-				if (send_done)
-					return send_done;
+			if (rc)
 				goto out_err;
-			}
 			continue;
 		}
 
-- 
2.20.1



