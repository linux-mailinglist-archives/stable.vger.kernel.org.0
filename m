Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7729246A4C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgHQPdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbgHQPdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F63723441;
        Mon, 17 Aug 2020 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678394;
        bh=jpxkMTk7y2ZnXPCxzU1NkYp6O77+c+e8n/iZSsfAKWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UiTYd8ofpKeHmXuaSsTzw/b2kk0wMEBd2zNJS4wMrQTNvb1AjNNS3Ur0ejzTWgEE
         lYon9KW+pEQV+DDWpqBnJ3cHINXwZPzcZzEGLJsGmL3bem1hrpCJvo+cTdektGbf2y
         X0sM9maBMyUejIezBQzh+2NEG0hmD7I6V2/O5kvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Stan Johnson <userm57@yahoo.com>
Subject: [PATCH 5.8 289/464] scsi: mesh: Fix panic after host or bus reset
Date:   Mon, 17 Aug 2020 17:14:02 +0200
Message-Id: <20200817143847.598183165@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit edd7dd2292ab9c3628b65c4d04514c3068ad54f6 ]

Booting Linux with a Conner CP3200 drive attached to the MESH SCSI bus
results in EH measures and a panic:

[   25.499838] mesh: configured for synchronous 5 MB/s
[   25.787154] mesh: performing initial bus reset...
[   29.867115] scsi host0: MESH
[   29.929527] mesh: target 0 synchronous at 3.6 MB/s
[   29.998763] scsi 0:0:0:0: Direct-Access     CONNER   CP3200-200mb-3.5 4040 PQ: 0 ANSI: 1 CCS
[   31.989975] sd 0:0:0:0: [sda] 415872 512-byte logical blocks: (213 MB/203 MiB)
[   32.070975] sd 0:0:0:0: [sda] Write Protect is off
[   32.137197] sd 0:0:0:0: [sda] Mode Sense: 5b 00 00 08
[   32.209661] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.332708]  sda: [mac] sda1 sda2 sda3
[   32.417733] sd 0:0:0:0: [sda] Attached SCSI disk
... snip ...
[   76.687067] mesh_abort((ptrval))
[   76.743606] mesh: state at (ptrval), regs at (ptrval), dma at (ptrval)
[   76.810798]     ct=6000 seq=86 bs=4017 fc= 0 exc= 0 err= 0 im= 7 int= 0 sp=85
[   76.880720]     dma stat=84e0 cmdptr=1f73d000
[   76.941387]     phase=4 msgphase=0 conn_tgt=0 data_ptr=24576
[   77.005567]     dma_st=1 dma_ct=0 n_msgout=0
[   77.065456]     target 0: req=(ptrval) goes_out=0 saved_ptr=0
[   77.130512] mesh_abort((ptrval))
[   77.187670] mesh: state at (ptrval), regs at (ptrval), dma at (ptrval)
[   77.255594]     ct=6000 seq=86 bs=4017 fc= 0 exc= 0 err= 0 im= 7 int= 0 sp=85
[   77.325778]     dma stat=84e0 cmdptr=1f73d000
[   77.387239]     phase=4 msgphase=0 conn_tgt=0 data_ptr=24576
[   77.453665]     dma_st=1 dma_ct=0 n_msgout=0
[   77.515900]     target 0: req=(ptrval) goes_out=0 saved_ptr=0
[   77.582902] mesh_host_reset
[   88.187083] Kernel panic - not syncing: mesh: double DMA start !
[   88.254510] CPU: 0 PID: 358 Comm: scsi_eh_0 Not tainted 5.6.13-pmac #1
[   88.323302] Call Trace:
[   88.378854] [e16ddc58] [c0027080] panic+0x13c/0x308 (unreliable)
[   88.446221] [e16ddcb8] [c02b2478] mesh_start.part.12+0x130/0x414
[   88.513298] [e16ddcf8] [c02b2fc8] mesh_queue+0x54/0x70
[   88.577097] [e16ddd18] [c02a1848] scsi_send_eh_cmnd+0x374/0x384
[   88.643476] [e16dddc8] [c02a1938] scsi_eh_tur+0x5c/0xb8
[   88.707878] [e16dddf8] [c02a1ab8] scsi_eh_test_devices+0x124/0x178
[   88.775663] [e16dde28] [c02a2094] scsi_eh_ready_devs+0x588/0x8a8
[   88.843124] [e16dde98] [c02a31d8] scsi_error_handler+0x344/0x520
[   88.910697] [e16ddf08] [c00409c8] kthread+0xe4/0xe8
[   88.975166] [e16ddf38] [c000f234] ret_from_kernel_thread+0x14/0x1c
[   89.044112] Rebooting in 180 seconds..

In theory, a panic can happen after a bus or host reset with dma_started
flag set. Fix this by halting the DMA before reinitializing the host.
Don't assume that ms->current_req is set when halt_dma() is invoked as it
may not hold for bus or host reset.

BTW, this particular Conner drive can be made to work by inhibiting
disconnect/reselect with 'mesh.resel_targets=0'.

Link: https://lore.kernel.org/r/3952bc691e150a7128b29120999b6092071b039a.1595460351.git.fthain@telegraphics.com.au
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: Paul Mackerras <paulus@ozlabs.org>
Reported-and-tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mesh.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index f9f8f4921654f..fd1d030640797 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1045,6 +1045,8 @@ static void handle_error(struct mesh_state *ms)
 		while ((in_8(&mr->bus_status1) & BS1_RST) != 0)
 			udelay(1);
 		printk("done\n");
+		if (ms->dma_started)
+			halt_dma(ms);
 		handle_reset(ms);
 		/* request_q is empty, no point in mesh_start() */
 		return;
@@ -1357,7 +1359,8 @@ static void halt_dma(struct mesh_state *ms)
 		       ms->conn_tgt, ms->data_ptr, scsi_bufflen(cmd),
 		       ms->tgts[ms->conn_tgt].data_goes_out);
 	}
-	scsi_dma_unmap(cmd);
+	if (cmd)
+		scsi_dma_unmap(cmd);
 	ms->dma_started = 0;
 }
 
@@ -1712,6 +1715,9 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
 
 	spin_lock_irqsave(ms->host->host_lock, flags);
 
+	if (ms->dma_started)
+		halt_dma(ms);
+
 	/* Reset the controller & dbdma channel */
 	out_le32(&md->control, (RUN|PAUSE|FLUSH|WAKE) << 16);	/* stop dma */
 	out_8(&mr->exception, 0xff);	/* clear all exception bits */
-- 
2.25.1



