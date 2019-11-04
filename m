Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98FFBEEBEC
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfKDVwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:52:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730221AbfKDVwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:10 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F04C62184C;
        Mon,  4 Nov 2019 21:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904329;
        bh=BT5g7okK7GOY7awUj1RlSha07wwJtV+TgL6wEfrCD0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JX/m7e44ETkJW0PHd1d3XvSunr22qtMAjEHJgNlgrZyZn9RTxpt5x0H/tyxwov7UH
         QVMx/IHNoLg11hqPeGPzUuuawsdX4lr9TBo8rpAM5RyUHCo9SGbzGlqSItga9iPEnt
         C7mUeRO/G0C3P1icY7F0vB6LDNdZQvxY34R3zg1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/62] RDMA/iwcm: Fix a lock inversion issue
Date:   Mon,  4 Nov 2019 22:44:39 +0100
Message-Id: <20191104211918.043711182@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit b66f31efbdad95ec274345721d99d1d835e6de01 ]

This patch fixes the lock inversion complaint:

============================================
WARNING: possible recursive locking detected
5.3.0-rc7-dbg+ #1 Not tainted
--------------------------------------------
kworker/u16:6/171 is trying to acquire lock:
00000000035c6e6c (&id_priv->handler_mutex){+.+.}, at: rdma_destroy_id+0x78/0x4a0 [rdma_cm]

but task is already holding lock:
00000000bc7c307d (&id_priv->handler_mutex){+.+.}, at: iw_conn_req_handler+0x151/0x680 [rdma_cm]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&id_priv->handler_mutex);
  lock(&id_priv->handler_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u16:6/171:
 #0: 00000000e2eaa773 ((wq_completion)iw_cm_wq){+.+.}, at: process_one_work+0x472/0xac0
 #1: 000000001efd357b ((work_completion)(&work->work)#3){+.+.}, at: process_one_work+0x476/0xac0
 #2: 00000000bc7c307d (&id_priv->handler_mutex){+.+.}, at: iw_conn_req_handler+0x151/0x680 [rdma_cm]

stack backtrace:
CPU: 3 PID: 171 Comm: kworker/u16:6 Not tainted 5.3.0-rc7-dbg+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Workqueue: iw_cm_wq cm_work_handler [iw_cm]
Call Trace:
 dump_stack+0x8a/0xd6
 __lock_acquire.cold+0xe1/0x24d
 lock_acquire+0x106/0x240
 __mutex_lock+0x12e/0xcb0
 mutex_lock_nested+0x1f/0x30
 rdma_destroy_id+0x78/0x4a0 [rdma_cm]
 iw_conn_req_handler+0x5c9/0x680 [rdma_cm]
 cm_work_handler+0xe62/0x1100 [iw_cm]
 process_one_work+0x56d/0xac0
 worker_thread+0x7a/0x5d0
 kthread+0x1bc/0x210
 ret_from_fork+0x24/0x30

This is not a bug as there are actually two lock classes here.

Link: https://lore.kernel.org/r/20190930231707.48259-3-bvanassche@acm.org
Fixes: de910bd92137 ("RDMA/cma: Simplify locking needed for serialization of callbacks")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 85d4ef319c905..dcfbf326f45c9 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2119,9 +2119,10 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 		conn_id->cm_id.iw = NULL;
 		cma_exch(conn_id, RDMA_CM_DESTROYING);
 		mutex_unlock(&conn_id->handler_mutex);
+		mutex_unlock(&listen_id->handler_mutex);
 		cma_deref_id(conn_id);
 		rdma_destroy_id(&conn_id->id);
-		goto out;
+		return ret;
 	}
 
 	mutex_unlock(&conn_id->handler_mutex);
-- 
2.20.1



