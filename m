Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905731CABF5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgEHMsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729256AbgEHMsf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EC09206D6;
        Fri,  8 May 2020 12:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942113;
        bh=QECoqsjAOlzsQnEN/5AzupQV6tE0FCuKShc1FENqbJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jrmea+aMCfiX7TMxcJgHnpIZ/mOCISvsKsjAsJfmwtEimMls3YWyxYu43SCL26rqu
         YmSCGhKWSDowX/nfKhss8SX4wCMgcKVdTj7xCcT3OY5SkCJcdo9Vs6J+OBk2zTuaDJ
         Ni1Q5qF0AWBW/zwLckW3ANNEvQx+uX0y9fYCc8bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Mans Rullgard <mans@mansr.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.4 301/312] ata: sata_dwc_460ex: remove incorrect locking
Date:   Fri,  8 May 2020 14:34:52 +0200
Message-Id: <20200508123145.606861021@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>

commit 55e610cdd28c0ad3dce0652030c0296d549673f3 upstream.

This lock is already taken in ata_scsi_queuecmd() a few levels up the
call stack so attempting to take it here is an error.  Moreover, it is
pointless in the first place since it only protects a single, atomic
assignment.

Enabling lock debugging gives the following output:

=============================================
[ INFO: possible recursive locking detected ]
4.4.0-rc5+ #189 Not tainted
---------------------------------------------
kworker/u2:3/37 is trying to acquire lock:
 (&(&host->lock)->rlock){-.-...}, at: [<90283294>] sata_dwc_exec_command_by_tag.constprop.14+0x44/0x8c

but task is already holding lock:
 (&(&host->lock)->rlock){-.-...}, at: [<902761ac>] ata_scsi_queuecmd+0x2c/0x330

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&host->lock)->rlock);
  lock(&(&host->lock)->rlock);

 *** DEADLOCK ***
 May be due to missing lock nesting notation

4 locks held by kworker/u2:3/37:
 #0:  ("events_unbound"){.+.+.+}, at: [<9003a0a4>] process_one_work+0x12c/0x430
 #1:  ((&entry->work)){+.+.+.}, at: [<9003a0a4>] process_one_work+0x12c/0x430
 #2:  (&bdev->bd_mutex){+.+.+.}, at: [<9011fd54>] __blkdev_get+0x50/0x380
 #3:  (&(&host->lock)->rlock){-.-...}, at: [<902761ac>] ata_scsi_queuecmd+0x2c/0x330

stack backtrace:
CPU: 0 PID: 37 Comm: kworker/u2:3 Not tainted 4.4.0-rc5+ #189
Workqueue: events_unbound async_run_entry_fn
Stack : 90b38e30 00000021 00000003 9b2a6040 00000000 9005f3f0 904fc8dc 00000025
        906b96e4 00000000 90528648 9b3336c4 904fc8dc 9009bf18 00000002 00000004
        00000000 00000000 9b3336c4 9b3336e4 904fc8dc 9003d074 00000000 90500000
        9005e738 00000000 00000000 00000000 00000000 00000000 00000000 00000000
        6e657665 755f7374 756f626e 0000646e 00000000 00000000 9b00ca00 9b025000
          ...
Call Trace:
[<90009d6c>] show_stack+0x88/0xa4
[<90057744>] __lock_acquire+0x1ce8/0x2154
[<900583e4>] lock_acquire+0x64/0x8c
[<9045ff10>] _raw_spin_lock_irqsave+0x54/0x78
[<90283294>] sata_dwc_exec_command_by_tag.constprop.14+0x44/0x8c
[<90283484>] sata_dwc_qc_issue+0x1a8/0x24c
[<9026b39c>] ata_qc_issue+0x1f0/0x410
[<90273c6c>] ata_scsi_translate+0xb4/0x200
[<90276234>] ata_scsi_queuecmd+0xb4/0x330
[<9025800c>] scsi_dispatch_cmd+0xd0/0x128
[<90259934>] scsi_request_fn+0x58c/0x638
[<901a3e50>] __blk_run_queue+0x40/0x5c
[<901a83d4>] blk_queue_bio+0x27c/0x28c
[<901a5914>] generic_make_request+0xf0/0x188
[<901a5a54>] submit_bio+0xa8/0x194
[<9011adcc>] submit_bh_wbc.isra.23+0x15c/0x17c
[<9011c908>] block_read_full_page+0x3e4/0x428
[<9009e2e0>] do_read_cache_page+0xac/0x210
[<9009fd90>] read_cache_page+0x18/0x24
[<901bbd18>] read_dev_sector+0x38/0xb0
[<901bd174>] msdos_partition+0xb4/0x5c0
[<901bcb8c>] check_partition+0x140/0x274
[<901bba60>] rescan_partitions+0xa0/0x2b0
[<9011ff68>] __blkdev_get+0x264/0x380
[<901201ac>] blkdev_get+0x128/0x36c
[<901b9378>] add_disk+0x3c0/0x4bc
[<90268268>] sd_probe_async+0x100/0x224
[<90043a44>] async_run_entry_fn+0x50/0x124
[<9003a11c>] process_one_work+0x1a4/0x430
[<9003a4f4>] worker_thread+0x14c/0x4fc
[<900408f4>] kthread+0xd0/0xe8
[<90004338>] ret_from_kernel_thread+0x14/0x1c

Fixes: 62936009f35a ("[libata] Add 460EX on-chip SATA driver, sata_dwc_460ex")
Tested-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Mans Rullgard <mans@mansr.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_dwc_460ex.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -924,15 +924,13 @@ static void sata_dwc_exec_command_by_tag
 					 struct ata_taskfile *tf,
 					 u8 tag, u32 cmd_issued)
 {
-	unsigned long flags;
 	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
 
 	dev_dbg(ap->dev, "%s cmd(0x%02x): %s tag=%d\n", __func__, tf->command,
 		ata_get_cmd_descript(tf->command), tag);
 
-	spin_lock_irqsave(&ap->host->lock, flags);
 	hsdevp->cmd_issued[tag] = cmd_issued;
-	spin_unlock_irqrestore(&ap->host->lock, flags);
+
 	/*
 	 * Clear SError before executing a new command.
 	 * sata_dwc_scr_write and read can not be used here. Clearing the PM


