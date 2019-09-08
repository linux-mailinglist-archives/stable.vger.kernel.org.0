Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E619DACDBB
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbfIHMww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733230AbfIHMwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:51 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD75E21A4C;
        Sun,  8 Sep 2019 12:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947170;
        bh=wLjdstvG1O+WeMYWfoQn+Z5t7IC8vFptHoT0KlpyZdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mq9PHAoCnj+FBoFKEWdeDXr+446xCWleOymH4YyuT5qJxI8JbWal5jJBMGqtccfK0
         +AlfdusCcfGizDIAB3Ewgjn2AS+hx3V6BXvqIatK1cIp1RpNtCId1mfES/RmkwGmqP
         pfrcHwlQjVntZdOQ5Ha0vachb6UsHP1GJseYMe/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 87/94] RDMA/bnxt_re: Fix stack-out-of-bounds in bnxt_qplib_rcfw_send_message
Date:   Sun,  8 Sep 2019 13:42:23 +0100
Message-Id: <20190908121152.922301256@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d37b1e534071ab1983e7c85273234b132c77591a ]

Driver copies FW commands to the HW queue as  units of 16 bytes. Some
of the command structures are not exact multiple of 16. So while copying
the data from those structures, the stack out of bounds messages are
reported by KASAN. The following error is reported.

[ 1337.530155] ==================================================================
[ 1337.530277] BUG: KASAN: stack-out-of-bounds in bnxt_qplib_rcfw_send_message+0x40a/0x850 [bnxt_re]
[ 1337.530413] Read of size 16 at addr ffff888725477a48 by task rmmod/2785

[ 1337.530540] CPU: 5 PID: 2785 Comm: rmmod Tainted: G           OE     5.2.0-rc6+ #75
[ 1337.530541] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 1.0.4 08/28/2014
[ 1337.530542] Call Trace:
[ 1337.530548]  dump_stack+0x5b/0x90
[ 1337.530556]  ? bnxt_qplib_rcfw_send_message+0x40a/0x850 [bnxt_re]
[ 1337.530560]  print_address_description+0x65/0x22e
[ 1337.530568]  ? bnxt_qplib_rcfw_send_message+0x40a/0x850 [bnxt_re]
[ 1337.530575]  ? bnxt_qplib_rcfw_send_message+0x40a/0x850 [bnxt_re]
[ 1337.530577]  __kasan_report.cold.3+0x37/0x77
[ 1337.530581]  ? _raw_write_trylock+0x10/0xe0
[ 1337.530588]  ? bnxt_qplib_rcfw_send_message+0x40a/0x850 [bnxt_re]
[ 1337.530590]  kasan_report+0xe/0x20
[ 1337.530592]  memcpy+0x1f/0x50
[ 1337.530600]  bnxt_qplib_rcfw_send_message+0x40a/0x850 [bnxt_re]
[ 1337.530608]  ? bnxt_qplib_creq_irq+0xa0/0xa0 [bnxt_re]
[ 1337.530611]  ? xas_create+0x3aa/0x5f0
[ 1337.530613]  ? xas_start+0x77/0x110
[ 1337.530615]  ? xas_clear_mark+0x34/0xd0
[ 1337.530623]  bnxt_qplib_free_mrw+0x104/0x1a0 [bnxt_re]
[ 1337.530631]  ? bnxt_qplib_destroy_ah+0x110/0x110 [bnxt_re]
[ 1337.530633]  ? bit_wait_io_timeout+0xc0/0xc0
[ 1337.530641]  bnxt_re_dealloc_mw+0x2c/0x60 [bnxt_re]
[ 1337.530648]  bnxt_re_destroy_fence_mr+0x77/0x1d0 [bnxt_re]
[ 1337.530655]  bnxt_re_dealloc_pd+0x25/0x60 [bnxt_re]
[ 1337.530677]  ib_dealloc_pd_user+0xbe/0xe0 [ib_core]
[ 1337.530683]  srpt_remove_one+0x5de/0x690 [ib_srpt]
[ 1337.530689]  ? __srpt_close_all_ch+0xc0/0xc0 [ib_srpt]
[ 1337.530692]  ? xa_load+0x87/0xe0
...
[ 1337.530840]  do_syscall_64+0x6d/0x1f0
[ 1337.530843]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1337.530845] RIP: 0033:0x7ff5b389035b
[ 1337.530848] Code: 73 01 c3 48 8b 0d 2d 0b 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fd 0a 2c 00 f7 d8 64 89 01 48
[ 1337.530849] RSP: 002b:00007fff83425c28 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[ 1337.530852] RAX: ffffffffffffffda RBX: 00005596443e6750 RCX: 00007ff5b389035b
[ 1337.530853] RDX: 000000000000000a RSI: 0000000000000800 RDI: 00005596443e67b8
[ 1337.530854] RBP: 0000000000000000 R08: 00007fff83424ba1 R09: 0000000000000000
[ 1337.530856] R10: 00007ff5b3902960 R11: 0000000000000206 R12: 00007fff83425e50
[ 1337.530857] R13: 00007fff8342673c R14: 00005596443e6260 R15: 00005596443e6750

[ 1337.530885] The buggy address belongs to the page:
[ 1337.530962] page:ffffea001c951dc0 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
[ 1337.530964] flags: 0x57ffffc0000000()
[ 1337.530967] raw: 0057ffffc0000000 0000000000000000 ffffffff1c950101 0000000000000000
[ 1337.530970] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[ 1337.530970] page dumped because: kasan: bad access detected

[ 1337.530996] Memory state around the buggy address:
[ 1337.531072]  ffff888725477900: 00 00 00 00 f1 f1 f1 f1 00 00 00 00 00 f2 f2 f2
[ 1337.531180]  ffff888725477980: 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00
[ 1337.531288] >ffff888725477a00: 00 f2 f2 f2 f2 f2 f2 00 00 00 f2 00 00 00 00 00
[ 1337.531393]                                                  ^
[ 1337.531478]  ffff888725477a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1337.531585]  ffff888725477b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1337.531691] ==================================================================

Fix this by passing the exact size of each FW command to
bnxt_qplib_rcfw_send_message as req->cmd_size. Before sending
the command to HW, modify the req->cmd_size to number of 16 byte units.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1566468170-489-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  8 +++++++-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h | 11 ++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 48b04d2f175f9..60c8f76aab33d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -136,6 +136,13 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
 		spin_unlock_irqrestore(&cmdq->lock, flags);
 		return -EBUSY;
 	}
+
+	size = req->cmd_size;
+	/* change the cmd_size to the number of 16byte cmdq unit.
+	 * req->cmd_size is modified here
+	 */
+	bnxt_qplib_set_cmd_slots(req);
+
 	memset(resp, 0, sizeof(*resp));
 	crsqe->resp = (struct creq_qp_event *)resp;
 	crsqe->resp->cookie = req->cookie;
@@ -150,7 +157,6 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
 
 	cmdq_ptr = (struct bnxt_qplib_cmdqe **)cmdq->pbl_ptr;
 	preq = (u8 *)req;
-	size = req->cmd_size * BNXT_QPLIB_CMDQE_UNITS;
 	do {
 		/* Locate the next cmdq slot */
 		sw_prod = HWQ_CMP(cmdq->prod, cmdq);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 2138533bb6426..dfeadc192e174 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -55,9 +55,7 @@
 	do {								\
 		memset(&(req), 0, sizeof((req)));			\
 		(req).opcode = CMDQ_BASE_OPCODE_##CMD;			\
-		(req).cmd_size = (sizeof((req)) +			\
-				BNXT_QPLIB_CMDQE_UNITS - 1) /		\
-				BNXT_QPLIB_CMDQE_UNITS;			\
+		(req).cmd_size = sizeof((req));				\
 		(req).flags = cpu_to_le16(cmd_flags);			\
 	} while (0)
 
@@ -95,6 +93,13 @@ static inline u32 bnxt_qplib_cmdqe_cnt_per_pg(u32 depth)
 		 BNXT_QPLIB_CMDQE_UNITS);
 }
 
+/* Set the cmd_size to a factor of CMDQE unit */
+static inline void bnxt_qplib_set_cmd_slots(struct cmdq_base *req)
+{
+	req->cmd_size = (req->cmd_size + BNXT_QPLIB_CMDQE_UNITS - 1) /
+			 BNXT_QPLIB_CMDQE_UNITS;
+}
+
 #define MAX_CMDQ_IDX(depth)		((depth) - 1)
 
 static inline u32 bnxt_qplib_max_cmdq_idx_per_pg(u32 depth)
-- 
2.20.1



