Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CCC3C4A30
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbhGLGtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235609AbhGLGsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:48:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45B39611ED;
        Mon, 12 Jul 2021 06:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072238;
        bh=NJi1vJzWiV3fzhBzSwLY0/L+f3LY/qnesIh6LylrguQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RO5fmW9/+ycN2reFBiF69d/Md8N0ZZ/5li3tp02tV+NPyYWdn+EizC8Os2tKCrpw0
         MkKTOmS9y/eEixkF1vpi/NIYdmHkHf400G8QqzQ7tG5gK6G8M6IvxBkZ91E2mEBaEk
         znI/IPwiNDFxlzowFmtfQZjSJp3bFubMPI2keH94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Oros <poros@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/593] Revert "be2net: disable bh with spin_lock in be_process_mcc"
Date:   Mon, 12 Jul 2021 08:09:32 +0200
Message-Id: <20210712060933.268552001@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Oros <poros@redhat.com>

[ Upstream commit d6765985a42a660f078896d5c5b27f97c580a490 ]

Patch was based on wrong presumption that be_poll can be called only
from bh context. It reintroducing old regression (also reverted) and
causing deadlock when we use netconsole with benet in bonding.

Old revert: commit 072a9c486004 ("netpoll: revert 6bdb7fe3104 and fix
be_poll() instead")

[  331.269715] bond0: (slave enp0s7f0): Releasing backup interface
[  331.270121] CPU: 4 PID: 1479 Comm: ifenslave Not tainted 5.13.0-rc7+ #2
[  331.270122] Call Trace:
[  331.270122] [c00000001789f200] [c0000000008c505c] dump_stack+0x100/0x174 (unreliable)
[  331.270124] [c00000001789f240] [c008000001238b9c] be_poll+0x64/0xe90 [be2net]
[  331.270125] [c00000001789f330] [c000000000d1e6e4] netpoll_poll_dev+0x174/0x3d0
[  331.270127] [c00000001789f400] [c008000001bc167c] bond_poll_controller+0xb4/0x130 [bonding]
[  331.270128] [c00000001789f450] [c000000000d1e624] netpoll_poll_dev+0xb4/0x3d0
[  331.270129] [c00000001789f520] [c000000000d1ed88] netpoll_send_skb+0x448/0x470
[  331.270130] [c00000001789f5d0] [c0080000011f14f8] write_msg+0x180/0x1b0 [netconsole]
[  331.270131] [c00000001789f640] [c000000000230c0c] console_unlock+0x54c/0x790
[  331.270132] [c00000001789f7b0] [c000000000233098] vprintk_emit+0x2d8/0x450
[  331.270133] [c00000001789f810] [c000000000234758] vprintk+0xc8/0x270
[  331.270134] [c00000001789f850] [c000000000233c28] printk+0x40/0x54
[  331.270135] [c00000001789f870] [c000000000ccf908] __netdev_printk+0x150/0x198
[  331.270136] [c00000001789f910] [c000000000ccfdb4] netdev_info+0x68/0x94
[  331.270137] [c00000001789f950] [c008000001bcbd70] __bond_release_one+0x188/0x6b0 [bonding]
[  331.270138] [c00000001789faa0] [c008000001bcc6f4] bond_do_ioctl+0x42c/0x490 [bonding]
[  331.270139] [c00000001789fb60] [c000000000d0d17c] dev_ifsioc+0x17c/0x400
[  331.270140] [c00000001789fbc0] [c000000000d0db70] dev_ioctl+0x390/0x890
[  331.270141] [c00000001789fc10] [c000000000c7c76c] sock_do_ioctl+0xac/0x1b0
[  331.270142] [c00000001789fc90] [c000000000c7ffac] sock_ioctl+0x31c/0x6e0
[  331.270143] [c00000001789fd60] [c0000000005b9728] sys_ioctl+0xf8/0x150
[  331.270145] [c00000001789fdb0] [c0000000000336c0] system_call_exception+0x160/0x2f0
[  331.270146] [c00000001789fe10] [c00000000000d35c] system_call_common+0xec/0x278
[  331.270147] --- interrupt: c00 at 0x7fffa6c6ec00
[  331.270147] NIP:  00007fffa6c6ec00 LR: 0000000105c4185c CTR: 0000000000000000
[  331.270148] REGS: c00000001789fe80 TRAP: 0c00   Not tainted  (5.13.0-rc7+)
[  331.270148] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 28000428  XER: 00000000
[  331.270155] IRQMASK: 0
[  331.270156] GPR00: 0000000000000036 00007fffd494d5b0 00007fffa6d57100 0000000000000003
[  331.270158] GPR04: 0000000000008991 00007fffd494d6d0 0000000000000008 00007fffd494f28c
[  331.270161] GPR08: 0000000000000003 0000000000000000 0000000000000000 0000000000000000
[  331.270164] GPR12: 0000000000000000 00007fffa6dfa220 0000000000000000 0000000000000000
[  331.270167] GPR16: 0000000105c44880 0000000000000000 0000000105c60088 0000000105c60318
[  331.270170] GPR20: 0000000105c602c0 0000000105c44560 0000000000000000 0000000000000000
[  331.270172] GPR24: 00007fffd494dc50 00007fffd494d6a8 0000000105c60008 00007fffd494d6d0
[  331.270175] GPR28: 00007fffd494f27e 0000000105c6026c 00007fffd494f284 0000000000000000
[  331.270178] NIP [00007fffa6c6ec00] 0x7fffa6c6ec00
[  331.270178] LR [0000000105c4185c] 0x105c4185c
[  331.270179] --- interrupt: c00

This reverts commit d0d006a43e9a7a796f6f178839c92fcc222c564d.

Fixes: d0d006a43e9a7a ("be2net: disable bh with spin_lock in be_process_mcc")
Signed-off-by: Petr Oros <poros@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 6 ++++--
 drivers/net/ethernet/emulex/benet/be_main.c | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 701c12c9e033..649c5c429bd7 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -550,7 +550,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	int num = 0, status = 0;
 	struct be_mcc_obj *mcc_obj = &adapter->mcc_obj;
 
-	spin_lock_bh(&adapter->mcc_cq_lock);
+	spin_lock(&adapter->mcc_cq_lock);
 
 	while ((compl = be_mcc_compl_get(adapter))) {
 		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
@@ -566,7 +566,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	if (num)
 		be_cq_notify(adapter, mcc_obj->cq.id, mcc_obj->rearm_cq, num);
 
-	spin_unlock_bh(&adapter->mcc_cq_lock);
+	spin_unlock(&adapter->mcc_cq_lock);
 	return status;
 }
 
@@ -581,7 +581,9 @@ static int be_mcc_wait_compl(struct be_adapter *adapter)
 		if (be_check_error(adapter, BE_ERROR_ANY))
 			return -EIO;
 
+		local_bh_disable();
 		status = be_process_mcc(adapter);
+		local_bh_enable();
 
 		if (atomic_read(&mcc_obj->q.used) == 0)
 			break;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index cb1e1ad652d0..89697cb09d1c 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5509,7 +5509,9 @@ static void be_worker(struct work_struct *work)
 	 * mcc completions
 	 */
 	if (!netif_running(adapter->netdev)) {
+		local_bh_disable();
 		be_process_mcc(adapter);
+		local_bh_enable();
 		goto reschedule;
 	}
 
-- 
2.30.2



