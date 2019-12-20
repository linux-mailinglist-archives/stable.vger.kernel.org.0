Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6FA127D43
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfLTOam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:30:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbfLTOam (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 737C624684;
        Fri, 20 Dec 2019 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852241;
        bh=/MS10nszUwF6I5dV/Ux6RGz0tsPDlASNy6iNfgudSc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCpCmCeguItGmOq5zVSc9K5ChO8Vd/YAWRxOf4Eo7RCQlogR0WXXm8lX5gbi1U0r1
         Am12DPMZxDHem/lF6UAkwxeORM7YYV7b6VshC0Lbfi/lI38wTW8ofLBb+tKk10mtTR
         OKkdmaKBBry550Q/9k6A9xvIfw80zFUVrcd5Ys7s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bo Wu <wubo40@huawei.com>, Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 34/52] scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func
Date:   Fri, 20 Dec 2019 09:29:36 -0500
Message-Id: <20191220142954.9500-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bo Wu <wubo40@huawei.com>

[ Upstream commit bba340c79bfe3644829db5c852fdfa9e33837d6d ]

In iscsi_if_rx func, after receiving one request through
iscsi_if_recv_msg func, iscsi_if_send_reply will be called to try to
reply to the request in a do-while loop.  If the iscsi_if_send_reply
function keeps returning -EAGAIN, a deadlock will occur.

For example, a client only send msg without calling recvmsg func, then
it will result in the watchdog soft lockup.  The details are given as
follows:

	sock_fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ISCSI);
	retval = bind(sock_fd, (struct sock addr*) & src_addr, sizeof(src_addr);
	while (1) {
		state_msg = sendmsg(sock_fd, &msg, 0);
		//Note: recvmsg(sock_fd, &msg, 0) is not processed here.
	}
	close(sock_fd);

watchdog: BUG: soft lockup - CPU#7 stuck for 22s! [netlink_test:253305] Sample time: 4000897528 ns(HZ: 250) Sample stat:
curr: user: 675503481560, nice: 321724050, sys: 448689506750, idle: 4654054240530, iowait: 40885550700, irq: 14161174020, softirq: 8104324140, st: 0
deta: user: 0, nice: 0, sys: 3998210100, idle: 0, iowait: 0, irq: 1547170, softirq: 242870, st: 0 Sample softirq:
         TIMER:        992
         SCHED:          8
Sample irqstat:
         irq    2: delta       1003, curr:    3103802, arch_timer
CPU: 7 PID: 253305 Comm: netlink_test Kdump: loaded Tainted: G           OE
Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
pstate: 40400005 (nZcv daif +PAN -UAO)
pc : __alloc_skb+0x104/0x1b0
lr : __alloc_skb+0x9c/0x1b0
sp : ffff000033603a30
x29: ffff000033603a30 x28: 00000000000002dd
x27: ffff800b34ced810 x26: ffff800ba7569f00
x25: 00000000ffffffff x24: 0000000000000000
x23: ffff800f7c43f600 x22: 0000000000480020
x21: ffff0000091d9000 x20: ffff800b34eff200
x19: ffff800ba7569f00 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000
x15: 0000000000000000 x14: 0001000101000100
x13: 0000000101010000 x12: 0101000001010100
x11: 0001010101010001 x10: 00000000000002dd
x9 : ffff000033603d58 x8 : ffff800b34eff400
x7 : ffff800ba7569200 x6 : ffff800b34eff400
x5 : 0000000000000000 x4 : 00000000ffffffff
x3 : 0000000000000000 x2 : 0000000000000001
x1 : ffff800b34eff2c0 x0 : 0000000000000300 Call trace:
__alloc_skb+0x104/0x1b0
iscsi_if_rx+0x144/0x12bc [scsi_transport_iscsi]
netlink_unicast+0x1e0/0x258
netlink_sendmsg+0x310/0x378
sock_sendmsg+0x4c/0x70
sock_write_iter+0x90/0xf0
__vfs_write+0x11c/0x190
vfs_write+0xac/0x1c0
ksys_write+0x6c/0xd8
__arm64_sys_write+0x24/0x30
el0_svc_common+0x78/0x130
el0_svc_handler+0x38/0x78
el0_svc+0x8/0xc

Link: https://lore.kernel.org/r/EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E3D4D2@dggeml505-mbx.china.huawei.com
Signed-off-by: Bo Wu <wubo40@huawei.com>
Reviewed-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 417b868d8735e..ed8d9709b9b96 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -24,6 +24,8 @@
 
 #define ISCSI_TRANSPORT_VERSION "2.0-870"
 
+#define ISCSI_SEND_MAX_ALLOWED  10
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/iscsi.h>
 
@@ -3682,6 +3684,7 @@ iscsi_if_rx(struct sk_buff *skb)
 		struct nlmsghdr	*nlh;
 		struct iscsi_uevent *ev;
 		uint32_t group;
+		int retries = ISCSI_SEND_MAX_ALLOWED;
 
 		nlh = nlmsg_hdr(skb);
 		if (nlh->nlmsg_len < sizeof(*nlh) + sizeof(*ev) ||
@@ -3712,6 +3715,10 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
 						  ev, sizeof(*ev));
+			if (err == -EAGAIN && --retries < 0) {
+				printk(KERN_WARNING "Send reply failed, error %d\n", err);
+				break;
+			}
 		} while (err < 0 && err != -ECONNREFUSED && err != -ESRCH);
 		skb_pull(skb, rlen);
 	}
-- 
2.20.1

