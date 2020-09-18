Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6EB26EFE5
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgIRCjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728738AbgIRCMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D2392376E;
        Fri, 18 Sep 2020 02:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395129;
        bh=J+DVPE/WCTi2SxBKzJYHwhm+7eW5FHl8NKJjIx3duh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5sPRwlHAgBJsN/52A6EDH8xdFoayukGQP1ams+xSetI2lubp6l0rCoMMlFDL09oS
         XhTq78WiKuh4Ro49UG8n1jR/O4VGDvFhoJFIXsQKcdeIhZizCg6x6TQeyEregQteKe
         Il/gT+84Cu9cuF0hrIGBHrKbv3Ikg3ShZaXOMYug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Girish Basrur <gbasrur@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Shyam Sundar <ssundar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, fcoe-devel@open-fcoe.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 199/206] scsi: libfc: Skip additional kref updating work event
Date:   Thu, 17 Sep 2020 22:07:55 -0400
Message-Id: <20200918020802.2065198-199-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 823a65409c8990f64c5693af98ce0e7819975cba ]

When an rport event (RPORT_EV_READY) is updated without work being queued,
avoid taking an additional reference.

This issue was leading to memory leak. Trace from KMEMLEAK tool:

  unreferenced object 0xffff8888259e8780 (size 512):
  comm "kworker/2:1", jiffies 4433237386 (age 113021.971s)
    hex dump (first 32 bytes):
	58 0a ec cf 83 88 ff ff 00 00 00 00 00 00 00 00
	01 00 00 00 08 00 00 00 13 7d f0 1e 0e 00 00 10
  backtrace:
  [<000000006b25760f>] fc_rport_recv_req+0x3c6/0x18f0 [libfc]
  [<00000000f208d994>] fc_lport_recv_els_req+0x120/0x8a0 [libfc]
  [<00000000a9c437b8>] fc_lport_recv+0xb9/0x130 [libfc]
  [<00000000a9c437b8>] fc_lport_recv+0xb9/0x130 [libfc]
  [<00000000ad5be37b>] qedf_ll2_process_skb+0x73d/0xad0 [qedf]
  [<00000000e0eb6893>] process_one_work+0x382/0x6c0
  [<000000002dfd9e21>] worker_thread+0x57/0x5c0
  [<00000000b648204f>] kthread+0x1a0/0x1c0
  [<0000000072f5ab20>] ret_from_fork+0x35/0x40
  [<000000001d5c05d8>] 0xffffffffffffffff

Below is the log sequence which leads to memory leak.  Here we get the
RPORT_EV_READY and RPORT_EV_STOP back to back, which lead to overwrite the
event RPORT_EV_READY by event RPORT_EV_STOP.  Because of this, kref_count
gets incremented by 1.

  kernel: host0: rport fffce5: Received PLOGI request
  kernel: host0: rport fffce5: Received PLOGI in INIT state
  kernel: host0: rport fffce5: Port is Ready
  kernel: host0: rport fffce5: Received PRLI request while in state Ready
  kernel: host0: rport fffce5: PRLI rspp type 8 active 1 passive 0
  kernel: host0: rport fffce5: Received LOGO request while in state Ready
  kernel: host0: rport fffce5: Delete port
  kernel: host0: rport fffce5: Received PLOGI request
  kernel: host0: rport fffce5: Received PLOGI in state Delete - send busy
  kernel: host0: rport fffce5: work event 3
  kernel: host0: rport fffce5: lld callback ev 3
  kernel: host0: rport fffce5: work delete

Link: https://lore.kernel.org/r/20200626094959.32151-1-jhasan@marvell.com
Reviewed-by: Girish Basrur <gbasrur@marvell.com>
Reviewed-by: Saurav Kashyap <skashyap@marvell.com>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_rport.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index f39d2d62b002f..2b3239765c249 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -495,10 +495,11 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
 
 	fc_rport_state_enter(rdata, RPORT_ST_DELETE);
 
-	kref_get(&rdata->kref);
-	if (rdata->event == RPORT_EV_NONE &&
-	    !queue_work(rport_event_queue, &rdata->event_work))
-		kref_put(&rdata->kref, fc_rport_destroy);
+	if (rdata->event == RPORT_EV_NONE) {
+		kref_get(&rdata->kref);
+		if (!queue_work(rport_event_queue, &rdata->event_work))
+			kref_put(&rdata->kref, fc_rport_destroy);
+	}
 
 	rdata->event = event;
 }
-- 
2.25.1

