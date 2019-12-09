Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAF81172E2
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 18:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfLIRfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 12:35:06 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34322 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfLIRfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 12:35:06 -0500
Received: by mail-pj1-f68.google.com with SMTP id j11so5069555pjs.1;
        Mon, 09 Dec 2019 09:35:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ep+Vw+NwQH5uxzU1cX05xT3L8SOImqjjEgikHxrPweQ=;
        b=ugTGDIHEvpUh154kFjgIKoJ3cmpIqwrf3t/pTAAvLNVO3mC9131N+/izb3BrYq9Zpk
         Sd+x8JJo2t3LGN1EnAztj+il7Wg5QEAoCUFhCkBNgNq6Ow8hB7+sbgikpe/2DUdXmtZT
         RVKNzkwcYAjtc1peUIv8OX/T94y33lZsQuuI//uS6S0tT6vN8K/sGnKIUHbPW4+VS1m0
         FB4av2D6FjKn8SqMBygkNV682t8euiC31TCu6FVq6dE3pp6A28BRMRtgu9POI8WxwkXk
         7fTx9S2EBFFHsJBNdh77nu/1Gur2sG6oU9Yv1tGB4qP48uYPEvecsaGPAnxQZqV63BSs
         s80g==
X-Gm-Message-State: APjAAAUJ2sVeLK3WIeWtUWjoLPT9QEWaTs5BUCkt4Iupyx/j7SC8+Ggm
        DRPWVq68C3uWzh1DAMz8hDY=
X-Google-Smtp-Source: APXvYqzoAB/cufkG7AbOYsPKHllM1MpE9TMeRUVPMlQeYEGalTLf2T3kaIel1cIVCy29AJbMdhkbzQ==
X-Received: by 2002:a17:902:6acb:: with SMTP id i11mr31081371plt.214.1575912905157;
        Mon, 09 Dec 2019 09:35:05 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.11])
        by smtp.gmail.com with ESMTPSA id q7sm88069pfb.44.2019.12.09.09.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 09:35:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] iscsi: Fix a potential deadlock in the timeout handler
Date:   Mon,  9 Dec 2019 09:34:57 -0800
Message-Id: <20191209173457.187370-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some time ago the block layer was modified such that timeout handlers are called
from thread context instead of interrupt context. Make it safe to run the iSCSI
timeout handler in thread context. This patch fixes the following lockdep
complaint:

================================
WARNING: inconsistent lock state
5.5.1-dbg+ #11 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
kworker/7:1H/206 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff88802d9827e8 (&(&session->frwd_lock)->rlock){+.?.}, at: iscsi_eh_cmd_timed_out+0xa6/0x6d0 [libiscsi]
{IN-SOFTIRQ-W} state was registered at:
  lock_acquire+0x106/0x240
  _raw_spin_lock+0x38/0x50
  iscsi_check_transport_timeouts+0x3e/0x210 [libiscsi]
  call_timer_fn+0x132/0x470
  __run_timers.part.0+0x39f/0x5b0
  run_timer_softirq+0x63/0xc0
  __do_softirq+0x12d/0x5fd
  irq_exit+0xb3/0x110
  smp_apic_timer_interrupt+0x131/0x3d0
  apic_timer_interrupt+0xf/0x20
  default_idle+0x31/0x230
  arch_cpu_idle+0x13/0x20
  default_idle_call+0x53/0x60
  do_idle+0x38a/0x3f0
  cpu_startup_entry+0x24/0x30
  start_secondary+0x222/0x290
  secondary_startup_64+0xa4/0xb0
irq event stamp: 1383705
hardirqs last  enabled at (1383705): [<ffffffff81aace5c>] _raw_spin_unlock_irq+0x2c/0x50
hardirqs last disabled at (1383704): [<ffffffff81aacb98>] _raw_spin_lock_irq+0x18/0x50
softirqs last  enabled at (1383690): [<ffffffffa0e2efea>] iscsi_queuecommand+0x76a/0xa20 [libiscsi]
softirqs last disabled at (1383682): [<ffffffffa0e2e998>] iscsi_queuecommand+0x118/0xa20 [libiscsi]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&session->frwd_lock)->rlock);
  <Interrupt>
    lock(&(&session->frwd_lock)->rlock);

 *** DEADLOCK ***

2 locks held by kworker/7:1H/206:
 #0: ffff8880d57bf928 ((wq_completion)kblockd){+.+.}, at: process_one_work+0x472/0xab0
 #1: ffff88802b9c7de8 ((work_completion)(&q->timeout_work)){+.+.}, at: process_one_work+0x476/0xab0

stack backtrace:
CPU: 7 PID: 206 Comm: kworker/7:1H Not tainted 5.5.1-dbg+ #11
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Workqueue: kblockd blk_mq_timeout_work
Call Trace:
 dump_stack+0xa5/0xe6
 print_usage_bug.cold+0x232/0x23b
 mark_lock+0x8dc/0xa70
 __lock_acquire+0xcea/0x2af0
 lock_acquire+0x106/0x240
 _raw_spin_lock+0x38/0x50
 iscsi_eh_cmd_timed_out+0xa6/0x6d0 [libiscsi]
 scsi_times_out+0xf4/0x440 [scsi_mod]
 scsi_timeout+0x1d/0x20 [scsi_mod]
 blk_mq_check_expired+0x365/0x3a0
 bt_iter+0xd6/0xf0
 blk_mq_queue_tag_busy_iter+0x3de/0x650
 blk_mq_timeout_work+0x1af/0x380
 process_one_work+0x56d/0xab0
 worker_thread+0x7a/0x5d0
 kthread+0x1bc/0x210
 ret_from_fork+0x24/0x30

Cc: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: 287922eb0b18 ("block: defer timeouts to a workqueue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ebd47c0cf9e9..70b99c0e2e67 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1945,7 +1945,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
-	spin_lock(&session->frwd_lock);
+	spin_lock_bh(&session->frwd_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task) {
 		/*
@@ -2072,7 +2072,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 done:
 	if (task)
 		task->last_timeout = jiffies;
-	spin_unlock(&session->frwd_lock);
+	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
 		     "timer reset" : "shutdown or nh");
 	return rc;
