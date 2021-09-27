Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCD8419ADA
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbhI0RMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236219AbhI0RKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14D2D611C7;
        Mon, 27 Sep 2021 17:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762489;
        bh=ZgwHAiEioHWm/9mu0jnjK8OLQry1F0AmOZJ1Ca+m56g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7daOOyZQrsljPahZV12tqXHTo1Qhb0yk9JssrJcc/ZMYUMZ+1KvzNDlVhu1kiSdK
         izcQpMeMVLiCknAIbod9OyyL3kzgSkuo2XDyhG19h0xX7XFxSETusgE4dS2HFcC8WO
         CyzP4TSIZx9cI0t94WrcQRs5QrTTLV02KM5W+4A0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/103] net/smc: fix workqueue leaked lock in smc_conn_abort_work
Date:   Mon, 27 Sep 2021 19:02:14 +0200
Message-Id: <20210927170227.199687390@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit a18cee4791b1123d0a6579a7c89f4b87e48abe03 ]

The abort_work is scheduled when a connection was detected to be
out-of-sync after a link failure. The work calls smc_conn_kill(),
which calls smc_close_active_abort() and that might end up calling
smc_close_cancel_work().
smc_close_cancel_work() cancels any pending close_work and tx_work but
needs to release the sock_lock before and acquires the sock_lock again
afterwards. So when the sock_lock was NOT acquired before then it may
be held after the abort_work completes. Thats why the sock_lock is
acquired before the call to smc_conn_kill() in __smc_lgr_terminate(),
but this is missing in smc_conn_abort_work().

Fix that by acquiring the sock_lock first and release it after the
call to smc_conn_kill().

Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index af96f813c075..c491dd8e67cd 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1089,7 +1089,9 @@ static void smc_conn_abort_work(struct work_struct *work)
 						   abort_work);
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
+	lock_sock(&smc->sk);
 	smc_conn_kill(conn, true);
+	release_sock(&smc->sk);
 	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */
 }
 
-- 
2.33.0



