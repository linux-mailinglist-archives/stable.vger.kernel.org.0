Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7409F419C0F
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbhI0RZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237124AbhI0RVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D0B861372;
        Mon, 27 Sep 2021 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762836;
        bh=JOHXo35h9rX1L/lWwohaM3olhp+13RbmxfxEwixT9o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLys4gmp59RbyKURk5k26bJNS4GIWKou9WHEzesywDn+IxvrxU8dZgkW5L9xYMNa9
         kga6U3JS8RJhyJOgmaYkvnFhyEhmUbBbPDE3MZ+210ALttveCWa6L+okY9E2oaOl+j
         wUz+mqeioNn3LW+aF7ypkMOiJQFppHkbLKkbVx/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 070/162] net/smc: fix workqueue leaked lock in smc_conn_abort_work
Date:   Mon, 27 Sep 2021 19:01:56 +0200
Message-Id: <20210927170235.884800708@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
index c160ff50c053..116cfd6fac1f 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1474,7 +1474,9 @@ static void smc_conn_abort_work(struct work_struct *work)
 						   abort_work);
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
+	lock_sock(&smc->sk);
 	smc_conn_kill(conn, true);
+	release_sock(&smc->sk);
 	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */
 }
 
-- 
2.33.0



