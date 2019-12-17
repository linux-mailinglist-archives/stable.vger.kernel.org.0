Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D44C122127
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfLQAva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34488 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbfLQAva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:30 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15E-0003Ir-Uc; Tue, 17 Dec 2019 00:51:29 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15E-0005Ry-44; Tue, 17 Dec 2019 00:51:28 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Jason Gunthorpe" <jgg@mellanox.com>
Date:   Tue, 17 Dec 2019 00:45:43 +0000
Message-ID: <lsq.1576543535.499281557@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 009/136] RDMA/iwcm: Fix a lock inversion issue
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit b66f31efbdad95ec274345721d99d1d835e6de01 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/core/cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1549,9 +1549,10 @@ static int iw_conn_req_handler(struct iw
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

