Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0808C20DB2F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388762AbgF2UE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732988AbgF2Tab (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AF5425256;
        Mon, 29 Jun 2020 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444972;
        bh=4Blk32RzQ+UzyP7QmJitEaBEKLU/tRY+xGER/lF4uZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UqcnoTAiJzcIiMbemxzARkH1JUsMzizZwhDMLAldlG1umBgdrHW7MUr8QcOssESjf
         aZialkukAMLlkPoRlU+PiX5nObdLtKhmSlev4TN0h6TiBrr+K0kPMtoH4x6ZwqRb50
         DkDGF2Jv3y9aj7w5SA2plGE/OU53YyBbvKDSSNx0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/131] RDMA/qedr: Fix KASAN: use-after-free in ucma_event_handler+0x532
Date:   Mon, 29 Jun 2020 11:34:02 -0400
Message-Id: <20200629153502.2494656-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 0dfbd5ecf28cbcb81674c49d34ee97366db1be44 ]

Private data passed to iwarp_cm_handler is copied for connection request /
response, but ignored otherwise.  If junk is passed, it is stored in the
event and used later in the event processing.

The driver passes an old junk pointer during connection close which leads
to a use-after-free on event processing.  Set private data to NULL for
events that don 't have private data.

  BUG: KASAN: use-after-free in ucma_event_handler+0x532/0x560 [rdma_ucm]
  kernel: Read of size 4 at addr ffff8886caa71200 by task kworker/u128:1/5250
  kernel:
  kernel: Workqueue: iw_cm_wq cm_work_handler [iw_cm]
  kernel: Call Trace:
  kernel: dump_stack+0x8c/0xc0
  kernel: print_address_description.constprop.0+0x1b/0x210
  kernel: ? ucma_event_handler+0x532/0x560 [rdma_ucm]
  kernel: ? ucma_event_handler+0x532/0x560 [rdma_ucm]
  kernel: __kasan_report.cold+0x1a/0x33
  kernel: ? ucma_event_handler+0x532/0x560 [rdma_ucm]
  kernel: kasan_report+0xe/0x20
  kernel: check_memory_region+0x130/0x1a0
  kernel: memcpy+0x20/0x50
  kernel: ucma_event_handler+0x532/0x560 [rdma_ucm]
  kernel: ? __rpc_execute+0x608/0x620 [sunrpc]
  kernel: cma_iw_handler+0x212/0x330 [rdma_cm]
  kernel: ? iw_conn_req_handler+0x6e0/0x6e0 [rdma_cm]
  kernel: ? enqueue_timer+0x86/0x140
  kernel: ? _raw_write_lock_irq+0xd0/0xd0
  kernel: cm_work_handler+0xd3d/0x1070 [iw_cm]

Fixes: e411e0587e0d ("RDMA/qedr: Add iWARP connection management functions")
Link: https://lore.kernel.org/r/20200616093408.17827-1-michal.kalderon@marvell.com
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 93b16237b7677..2566715773675 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -128,8 +128,17 @@ qedr_iw_issue_event(void *context,
 	if (params->cm_info) {
 		event.ird = params->cm_info->ird;
 		event.ord = params->cm_info->ord;
-		event.private_data_len = params->cm_info->private_data_len;
-		event.private_data = (void *)params->cm_info->private_data;
+		/* Only connect_request and reply have valid private data
+		 * the rest of the events this may be left overs from
+		 * connection establishment. CONNECT_REQUEST is issued via
+		 * qedr_iw_mpa_request
+		 */
+		if (event_type == IW_CM_EVENT_CONNECT_REPLY) {
+			event.private_data_len =
+				params->cm_info->private_data_len;
+			event.private_data =
+				(void *)params->cm_info->private_data;
+		}
 	}
 
 	if (ep->cm_id)
-- 
2.25.1

