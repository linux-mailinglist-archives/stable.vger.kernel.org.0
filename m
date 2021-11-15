Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF34451490
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345162AbhKOUK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:10:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344706AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 698E8636B5;
        Mon, 15 Nov 2021 19:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002969;
        bh=tk9KwHmLvJLpOLS3JMt3XNjGDxNpP9SdzZkOxxV498I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6XesRY65mf+1qAZNjdx7IvifT+259fwjp08Rg6lWWAvHCeJ/up0MLAx27dceaYvc
         k/ZEMxR7hXb2AgiRLK+jx1e1+C2rZ0lMDkwo9bRdpGOGhnp256Q9DcmCWQpxrOIoTG
         1VyIMqX9pdKKa/QhsDT3P5xzwM9D7vxWLyNcJjDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beld Zhang <beldzhang@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 762/917] io-wq: fix max-workers not correctly set on multi-node system
Date:   Mon, 15 Nov 2021 18:04:17 +0100
Message-Id: <20211115165454.767520628@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Beld Zhang <beldzhang@gmail.com>

[ Upstream commit 71c9ce27bb57c59d8d7f5298e730c8096eef3d1f ]

In io-wq.c:io_wq_max_workers(), new_count[] was changed right after each
node's value was set. This caused the following node getting the setting
of the previous one.

Returned values are copied from node 0.

Fixes: 2e480058ddc2 ("io-wq: provide a way to limit max number of workers")
Signed-off-by: Beld Zhang <beldzhang@gmail.com>
[axboe: minor fixups]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5d189b24a8d4b..8c61315657546 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1318,7 +1318,9 @@ int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
  */
 int io_wq_max_workers(struct io_wq *wq, int *new_count)
 {
-	int i, node, prev = 0;
+	int prev[IO_WQ_ACCT_NR];
+	bool first_node = true;
+	int i, node;
 
 	BUILD_BUG_ON((int) IO_WQ_ACCT_BOUND   != (int) IO_WQ_BOUND);
 	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
@@ -1329,6 +1331,9 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 			new_count[i] = task_rlimit(current, RLIMIT_NPROC);
 	}
 
+	for (i = 0; i < IO_WQ_ACCT_NR; i++)
+		prev[i] = 0;
+
 	rcu_read_lock();
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
@@ -1337,14 +1342,19 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 		raw_spin_lock(&wqe->lock);
 		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 			acct = &wqe->acct[i];
-			prev = max_t(int, acct->max_workers, prev);
+			if (first_node)
+				prev[i] = max_t(int, acct->max_workers, prev[i]);
 			if (new_count[i])
 				acct->max_workers = new_count[i];
-			new_count[i] = prev;
 		}
 		raw_spin_unlock(&wqe->lock);
+		first_node = false;
 	}
 	rcu_read_unlock();
+
+	for (i = 0; i < IO_WQ_ACCT_NR; i++)
+		new_count[i] = prev[i];
+
 	return 0;
 }
 
-- 
2.33.0



