Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978C4469D4C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378101AbhLFP26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58762 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348018AbhLFPY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 524C7B81125;
        Mon,  6 Dec 2021 15:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D9FC341C1;
        Mon,  6 Dec 2021 15:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804086;
        bh=tGCVU7G1+r3weFIpLm2SRUJIDptC8F7kGk49YmP4oDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAPzSQ8AaAEz1Bl2YhiJ1Vq5dDUg4bDcSI1gSt17je+jlOR8rygz3Rg5yN+nHktG/
         Nu0nxlnhifKCs337K4zGHlCjQ69jtcsBGDYvZrN3PVykjN9ssLB01vEqq3piB3IlQn
         sMhyyUvsYRkqHnZKaUcmzDZQGG8ih1I56E7k5Bkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/207] net/smc: Transfer remaining wait queue entries during fallback
Date:   Mon,  6 Dec 2021 15:54:35 +0100
Message-Id: <20211206145610.937621302@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 2153bd1e3d3dbf6a3403572084ef6ed31c53c5f0 ]

The SMC fallback is incomplete currently. There may be some
wait queue entries remaining in smc socket->wq, which should
be removed to clcsocket->wq during the fallback.

For example, in nginx/wrk benchmark, this issue causes an
all-zeros test result:

server: nginx -g 'daemon off;'
client: smc_run wrk -c 1 -t 1 -d 5 http://11.200.15.93/index.html

  Running 5s test @ http://11.200.15.93/index.html
     1 threads and 1 connections
     Thread Stats   Avg      Stdev     Max   ± Stdev
     	Latency     0.00us    0.00us   0.00us    -nan%
	Req/Sec     0.00      0.00     0.00      -nan%
	0 requests in 5.00s, 0.00B read
     Requests/sec:      0.00
     Transfer/sec:       0.00B

The reason for this all-zeros result is that when wrk used SMC
to replace TCP, it added an eppoll_entry into smc socket->wq
and expected to be notified if epoll events like EPOLL_IN/
EPOLL_OUT occurred on the smc socket.

However, once a fallback occurred, wrk switches to use clcsocket.
Now it is clcsocket->wq instead of smc socket->wq which will
be woken up. The eppoll_entry remaining in smc socket->wq does
not work anymore and wrk stops the test.

This patch fixes this issue by removing remaining wait queue
entries from smc socket->wq to clcsocket->wq during the fallback.

Link: https://www.spinics.net/lists/netdev/msg779769.html
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 3d8219e3b0264..c0456cb7623cb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -548,6 +548,10 @@ static void smc_stat_fallback(struct smc_sock *smc)
 
 static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
+	wait_queue_head_t *smc_wait = sk_sleep(&smc->sk);
+	wait_queue_head_t *clc_wait = sk_sleep(smc->clcsock->sk);
+	unsigned long flags;
+
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -556,6 +560,16 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		smc->clcsock->file->private_data = smc->clcsock;
 		smc->clcsock->wq.fasync_list =
 			smc->sk.sk_socket->wq.fasync_list;
+
+		/* There may be some entries remaining in
+		 * smc socket->wq, which should be removed
+		 * to clcsocket->wq during the fallback.
+		 */
+		spin_lock_irqsave(&smc_wait->lock, flags);
+		spin_lock(&clc_wait->lock);
+		list_splice_init(&smc_wait->head, &clc_wait->head);
+		spin_unlock(&clc_wait->lock);
+		spin_unlock_irqrestore(&smc_wait->lock, flags);
 	}
 }
 
-- 
2.33.0



