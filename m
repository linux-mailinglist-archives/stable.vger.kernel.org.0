Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E94136C15E
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 10:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhD0I53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 04:57:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:38984 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhD0I52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 04:57:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619513805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=XyfHpW6N8lRKKV67J1nsRVsPnmFJb+1E7K+VBSchIKg=;
        b=S1G0IozqAapX9L2Otd5a/zm2T8JiMuehC8N1CjxZSd0yAHebNEsbjae177m9UWHyI4jD7C
        2mo5yyUHq3npa2GTuZpepbRuK/vZrkxEQj9niFEZDunZt67l3Ywa5AiCygnpkz/4y8EBHK
        WAHbGi9qBtVZNNiH44ZAPkxfhyaJR5U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D640CB01E;
        Tue, 27 Apr 2021 08:56:44 +0000 (UTC)
From:   mwilck@suse.com
To:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Chao Leng <lengchao@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, Martin Wilck <mwilck@suse.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
Date:   Tue, 27 Apr 2021 10:52:46 +0200
Message-Id: <20210427085246.13728-1-mwilck@suse.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

We have observed a few crashes run_timer_softirq(), where a broken
timer_list struct belonging to an anatt_timer was encountered. The broken
structures look like this, and we see actually multiple ones attached to
the same timer base:

crash> struct timer_list 0xffff92471bcfdc90
struct timer_list {
  entry = {
    next = 0xdead000000000122,  // LIST_POISON2
    pprev = 0x0
  },
  expires = 4296022933,
  function = 0xffffffffc06de5e0 <nvme_anatt_timeout>,
  flags = 20
}

If such a timer is encountered in run_timer_softirq(), the kernel
crashes. The test scenario was an I/O load test with lots of NVMe
controllers, some of which were removed and re-added on the storage side.

I think this may happen if the rdma recovery_work starts, in this call
chain:

nvme_rdma_error_recovery_work()
  /* this stops all sorts of activity for the controller, but not
     the multipath-related work queue and timer */
  nvme_rdma_reconnect_or_remove(ctrl)
    => kicks reconnect_work

work queue: reconnect_work

nvme_rdma_reconnect_ctrl_work()
  nvme_rdma_setup_ctrl()
    nvme_rdma_configure_admin_queue()
       nvme_init_identify()
          nvme_mpath_init()
	     # this sets some fields of the timer_list without taking a lock
             timer_setup()
             nvme_read_ana_log()
	         mod_timer() or del_timer_sync()

Similar for TCP. The idea for the patch is based on the observation that
nvme_rdma_reset_ctrl_work() calls nvme_stop_ctrl()->nvme_mpath_stop(),
whereas nvme_rdma_error_recovery_work() stops only the keepalive timer, but
not the anatt timer.

I admit that the root cause analysis isn't rock solid yet. In particular, I
can't explain why we see LIST_POISON2 in the "next" pointer, which would
indicate that the timer has been detached before; yet we find it linked to
the timer base when the crash occurs.

OTOH, the anatt_timer is only touched in nvme_mpath_init() (see above) and
nvme_mpath_stop(), so the hypothesis that modifying active timers may cause
the issue isn't totally out of sight. I suspect that the LIST_POISON2 may
come to pass in multiple steps.

If anyone has better ideas, please advise. The issue occurs very
sporadically; verifying this by testing will be difficult.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chao Leng <lengchao@huawei.com>
Cc: stable@vger.kernel.org

----
Changes in v3: Changed the subject line, as suggested by Sagi Grimberg

Changes in v2: Moved call to nvme_mpath_stop() further down, directly before
the call of nvme_rdma_reconnect_or_remove() (Chao Leng)
---
 drivers/nvme/host/multipath.c | 1 +
 drivers/nvme/host/rdma.c      | 1 +
 drivers/nvme/host/tcp.c       | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a1d476e1ac02..c63dd5dfa7ff 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -586,6 +586,7 @@ void nvme_mpath_stop(struct nvme_ctrl *ctrl)
 	del_timer_sync(&ctrl->anatt_timer);
 	cancel_work_sync(&ctrl->ana_work);
 }
+EXPORT_SYMBOL_GPL(nvme_mpath_stop);
 
 #define SUBSYS_ATTR_RW(_name, _mode, _show, _store)  \
 	struct device_attribute subsys_attr_##_name =	\
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index be905d4fdb47..fc07a7b0dc1d 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1202,6 +1202,7 @@ static void nvme_rdma_error_recovery_work(struct work_struct *work)
 		return;
 	}
 
+	nvme_mpath_stop(&ctrl->ctrl);
 	nvme_rdma_reconnect_or_remove(ctrl);
 }
 
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a0f00cb8f9f3..46287b4f4d10 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2068,6 +2068,7 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 		return;
 	}
 
+	nvme_mpath_stop(ctrl);
 	nvme_tcp_reconnect_or_remove(ctrl);
 }
 
-- 
2.31.1

