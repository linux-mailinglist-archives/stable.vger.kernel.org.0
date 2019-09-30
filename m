Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4129FC2AB1
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 01:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfI3XRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 19:17:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33322 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729057AbfI3XRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 19:17:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id q1so219118pgb.0;
        Mon, 30 Sep 2019 16:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ocb0Btdcve+bO+wvymS9VkmrTcFGK8V6696tRMbHc+k=;
        b=BhCKdjvdhTBZ69uqLHX2rGhrP36s1pp3LebDq630hlx5pZd1TJU2aRe3anlZwZiRp/
         dPE5Qs3uUSvt9BIhLynmIdZR+pcKG3bzSPL96tfKysMZkP9kwMc+rjXh4ToFiNqvT6NC
         iUGtYjJaiOilU71VexFOrjk5qiBbq9Q2P4XIgLZ3FP6FMG7KhT1eoTkxXuO1GH0aKM11
         wHUJY0b0Z8MDl7ScLdgRp/XoAAJ8HtsxhgSpRyGhXGN9gsYWdiF+CmNVw0Me5tJGSKSj
         1q9BYcosEACI0JScPOzFtV+gPDlX0AC9P9frw2XCieCHmFOByFFtVuCrPq8zksVnMdco
         9+Wg==
X-Gm-Message-State: APjAAAVy29WaWbqZ+2ptOMnkFdkcoKZKZsLePPDWHUl6tYW81YnCyQj8
        yul+f2I1mPmEKje7oPzVe9k=
X-Google-Smtp-Source: APXvYqxqlWVNGWrOUIUEPZcvOX2yzzKdpmHAFcs908qNTdxO1EMIqimea5iYW00BRDuKt2JUsKyy1g==
X-Received: by 2002:aa7:9104:: with SMTP id 4mr24407619pfh.176.1569885441335;
        Mon, 30 Sep 2019 16:17:21 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id l7sm585406pjy.12.2019.09.30.16.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 16:17:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        Steve Wise <larrystevenwise@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Bernard Metzler <BMT@zurich.ibm.com>,
        Krishnamraju Eraparaju <krishna2@chelsio.com>,
        stable@vger.kernel.org
Subject: [PATCH 02/15] RDMA/iwcm: Fix a lock inversion issue
Date:   Mon, 30 Sep 2019 16:16:54 -0700
Message-Id: <20190930231707.48259-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
In-Reply-To: <20190930231707.48259-1-bvanassche@acm.org>
References: <20190930231707.48259-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Steve Wise <larrystevenwise@gmail.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Bernard Metzler <BMT@zurich.ibm.com>
Cc: Krishnamraju Eraparaju <krishna2@chelsio.com>
Cc: <stable@vger.kernel.org>
Fixes: de910bd92137 ("RDMA/cma: Simplify locking needed for serialization of callbacks"; v2.6.27).
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/core/cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0e3cf3461999..d78f67623f24 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2396,9 +2396,10 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
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
2.23.0.444.g18eeb5a265-goog

