Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1503C5210
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349756AbhGLHoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346938AbhGLHjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:39:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18047611CC;
        Mon, 12 Jul 2021 07:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075288;
        bh=gwnCwie+LU+Razt7Cq/sOgDreUV8VUwsRqswjxRYppU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ApoRssVJtlPTpyFMpMkCTkovP68fcywzWMoagNT625gvof91NJQFt86g77GVO2+8k
         7RYt79mE413DAzMkfkdXuSMcEdYw+NvLc6yUwfV1TEfjy/OxwcEM3JAqf8D3wBwJLy
         oxO3E/eumtN9O52osRM2PKYT2IjTGbu22IhQaQCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 170/800] media: bt8xx: Fix a missing check bug in bt878_probe
Date:   Mon, 12 Jul 2021 08:03:13 +0200
Message-Id: <20210712060936.887109561@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 1a4520090681853e6b850cbe54b27247a013e0e5 ]

In 'bt878_irq', the driver calls 'tasklet_schedule', but this tasklet is
set in 'dvb_bt8xx_load_card' of another driver 'dvb-bt8xx'.
However, this two drivers are separate. The user may not load the
'dvb-bt8xx' driver when loading the 'bt8xx' driver, that is, the tasklet
has not been initialized when 'tasklet_schedule' is called, so it is
necessary to check whether the tasklet is initialized in 'bt878_probe'.

Fix this by adding a check at the end of bt878_probe.

The KASAN's report reveals it:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
PGD 800000006aab2067 P4D 800000006aab2067 PUD 6b2ea067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN PTI
CPU: 2 PID: 8724 Comm: syz-executor.0 Not tainted 4.19.177-
gdba4159c14ef-dirty #40
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-
gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:          (null)
Code: Bad RIP value.
RSP: 0018:ffff88806c287ea0 EFLAGS: 00010246
RAX: fffffbfff1b01774 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 1ffffffff1b01775 RDI: 0000000000000000
RBP: ffff88806c287f00 R08: fffffbfff1b01774 R09: fffffbfff1b01774
R10: 0000000000000001 R11: fffffbfff1b01773 R12: 0000000000000000
R13: ffff88806c29f530 R14: ffffffff8d80bb88 R15: ffffffff8d80bb90
FS:  00007f6b550e6700(0000) GS:ffff88806c280000(0000) knlGS:
0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000005ec98000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 tasklet_action_common.isra.17+0x141/0x420 kernel/softirq.c:522
 tasklet_action+0x50/0x70 kernel/softirq.c:540
 __do_softirq+0x224/0x92c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:372 [inline]
 irq_exit+0x15a/0x180 kernel/softirq.c:412
 exiting_irq arch/x86/include/asm/apic.h:535 [inline]
 do_IRQ+0x123/0x1e0 arch/x86/kernel/irq.c:260
 common_interrupt+0xf/0xf arch/x86/entry/entry_64.S:670
 </IRQ>
RIP: 0010:__do_sys_interrupt kernel/sys.c:2593 [inline]
RIP: 0010:__se_sys_interrupt kernel/sys.c:2584 [inline]
RIP: 0010:__x64_sys_interrupt+0x5b/0x80 kernel/sys.c:2584
Code: ba 00 04 00 00 48 c7 c7 c0 99 31 8c e8 ae 76 5e 01 48 85 c0 75 21 e8
14 ae 24 00 48 c7 c3 c0 99 31 8c b8 0c 00 00 00 0f 01 c1 <31> db e8 fe ad
24 00 48 89 d8 5b 5d c3 48 c7 c3 ea ff ff ff eb ec
RSP: 0018:ffff888054167f10 EFLAGS: 00000212 ORIG_RAX: ffffffffffffffde
RAX: 000000000000000c RBX: ffffffff8c3199c0 RCX: ffffc90001ca6000
RDX: 000000000000001a RSI: ffffffff813478fc RDI: ffffffff8c319dc0
RBP: ffff888054167f18 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000080 R11: fffffbfff18633b7 R12: ffff888054167f58
R13: ffff88805f638000 R14: 0000000000000000 R15: 0000000000000000
 do_syscall_64+0xb0/0x4e0 arch/x86/entry/common.c:293
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4692a9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6b550e5c48 EFLAGS: 00000246 ORIG_RAX: 000000000000014f
RAX: ffffffffffffffda RBX: 000000000077bf60 RCX: 00000000004692a9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000140
RBP: 00000000004cf7eb R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf60
R13: 0000000000000000 R14: 000000000077bf60 R15: 00007fff55a1dca0
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
CR2: 0000000000000000
---[ end trace 68e5849c3f77cbb6 ]---
RIP: 0010:          (null)
Code: Bad RIP value.
RSP: 0018:ffff88806c287ea0 EFLAGS: 00010246
RAX: fffffbfff1b01774 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 1ffffffff1b01775 RDI: 0000000000000000
RBP: ffff88806c287f00 R08: fffffbfff1b01774 R09: fffffbfff1b01774
R10: 0000000000000001 R11: fffffbfff1b01773 R12: 0000000000000000
R13: ffff88806c29f530 R14: ffffffff8d80bb88 R15: ffffffff8d80bb90
FS:  00007f6b550e6700(0000) GS:ffff88806c280000(0000) knlGS:
0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000005ec98000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/bt8xx/bt878.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index 7ca309121fb5..90972d6952f1 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -478,6 +478,9 @@ static int bt878_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	btwrite(0, BT878_AINT_MASK);
 	bt878_num++;
 
+	if (!bt->tasklet.func)
+		tasklet_disable(&bt->tasklet);
+
 	return 0;
 
       fail2:
-- 
2.30.2



