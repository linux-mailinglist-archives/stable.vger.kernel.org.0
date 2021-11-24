Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE045BA3E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238822AbhKXMJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:09:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232959AbhKXMHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:07:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC2F60F5D;
        Wed, 24 Nov 2021 12:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755461;
        bh=Ng8Wx9JFD4clCDFuuDB/KVwGeLsotpyiH5oz957Eu2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3pH4Np5SZPWOxhpBwbydlTURitGBbyc7G7lLBebSC2hmcNItl9G+JmlP/qH5eljw
         fN/tM/r8y9Qr6SfbuSLUZKEWvMgeDCXZd+CzYzRjdkSOuSlY+RaQqe+Y5GCGPTWVjc
         +RDhxy+cM8TV7M1Y49DbNS6P44/CMqEitE/h6kr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Guobin <huangguobin4@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 105/162] bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed
Date:   Wed, 24 Nov 2021 12:56:48 +0100
Message-Id: <20211124115701.726750120@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Guobin <huangguobin4@huawei.com>

[ Upstream commit b93c6a911a3fe926b00add28f3b932007827c4ca ]

When I do fuzz test for bonding device interface, I got the following
use-after-free Calltrace:

==================================================================
BUG: KASAN: use-after-free in bond_enslave+0x1521/0x24f0
Read of size 8 at addr ffff88825bc11c00 by task ifenslave/7365

CPU: 5 PID: 7365 Comm: ifenslave Tainted: G            E     5.15.0-rc1+ #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
Call Trace:
 dump_stack_lvl+0x6c/0x8b
 print_address_description.constprop.0+0x48/0x70
 kasan_report.cold+0x82/0xdb
 __asan_load8+0x69/0x90
 bond_enslave+0x1521/0x24f0
 bond_do_ioctl+0x3e0/0x450
 dev_ifsioc+0x2ba/0x970
 dev_ioctl+0x112/0x710
 sock_do_ioctl+0x118/0x1b0
 sock_ioctl+0x2e0/0x490
 __x64_sys_ioctl+0x118/0x150
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f19159cf577
Code: b3 66 90 48 8b 05 11 89 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 78
RSP: 002b:00007ffeb3083c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffeb3084bca RCX: 00007f19159cf577
RDX: 00007ffeb3083ce0 RSI: 0000000000008990 RDI: 0000000000000003
RBP: 00007ffeb3084bc4 R08: 0000000000000040 R09: 0000000000000000
R10: 00007ffeb3084bc0 R11: 0000000000000246 R12: 00007ffeb3083ce0
R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffeb3083cb0

Allocated by task 7365:
 kasan_save_stack+0x23/0x50
 __kasan_kmalloc+0x83/0xa0
 kmem_cache_alloc_trace+0x22e/0x470
 bond_enslave+0x2e1/0x24f0
 bond_do_ioctl+0x3e0/0x450
 dev_ifsioc+0x2ba/0x970
 dev_ioctl+0x112/0x710
 sock_do_ioctl+0x118/0x1b0
 sock_ioctl+0x2e0/0x490
 __x64_sys_ioctl+0x118/0x150
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 7365:
 kasan_save_stack+0x23/0x50
 kasan_set_track+0x20/0x30
 kasan_set_free_info+0x24/0x40
 __kasan_slab_free+0xf2/0x130
 kfree+0xd1/0x5c0
 slave_kobj_release+0x61/0x90
 kobject_put+0x102/0x180
 bond_sysfs_slave_add+0x7a/0xa0
 bond_enslave+0x11b6/0x24f0
 bond_do_ioctl+0x3e0/0x450
 dev_ifsioc+0x2ba/0x970
 dev_ioctl+0x112/0x710
 sock_do_ioctl+0x118/0x1b0
 sock_ioctl+0x2e0/0x490
 __x64_sys_ioctl+0x118/0x150
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x23/0x50
 kasan_record_aux_stack+0xb7/0xd0
 insert_work+0x43/0x190
 __queue_work+0x2e3/0x970
 delayed_work_timer_fn+0x3e/0x50
 call_timer_fn+0x148/0x470
 run_timer_softirq+0x8a8/0xc50
 __do_softirq+0x107/0x55f

Second to last potentially related work creation:
 kasan_save_stack+0x23/0x50
 kasan_record_aux_stack+0xb7/0xd0
 insert_work+0x43/0x190
 __queue_work+0x2e3/0x970
 __queue_delayed_work+0x130/0x180
 queue_delayed_work_on+0xa7/0xb0
 bond_enslave+0xe25/0x24f0
 bond_do_ioctl+0x3e0/0x450
 dev_ifsioc+0x2ba/0x970
 dev_ioctl+0x112/0x710
 sock_do_ioctl+0x118/0x1b0
 sock_ioctl+0x2e0/0x490
 __x64_sys_ioctl+0x118/0x150
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88825bc11c00
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 0 bytes inside of
 1024-byte region [ffff88825bc11c00, ffff88825bc12000)
The buggy address belongs to the page:
page:ffffea00096f0400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x25bc10
head:ffffea00096f0400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x57ff00000010200(slab|head|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000010200 ffffea0009a71c08 ffff888240001968 ffff88810004dbc0
raw: 0000000000000000 00000000000a000a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88825bc11b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88825bc11b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88825bc11c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88825bc11c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88825bc11d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Put new_slave in bond_sysfs_slave_add() will cause use-after-free problems
when new_slave is accessed in the subsequent error handling process. Since
new_slave will be put in the subsequent error handling process, remove the
unnecessary put to fix it.
In addition, when sysfs_create_file() fails, if some files have been crea-
ted successfully, we need to call sysfs_remove_file() to remove them.
Since there are sysfs_create_files() & sysfs_remove_files() can be used,
use these two functions instead.

Fixes: 7afcaec49696 (bonding: use kobject_put instead of _del after kobject_add)
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_sysfs_slave.c | 36 ++++++++------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 68bbac4715c35..1e1e77a40f182 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -112,15 +112,15 @@ static ssize_t ad_partner_oper_port_state_show(struct slave *slave, char *buf)
 }
 static SLAVE_ATTR_RO(ad_partner_oper_port_state);
 
-static const struct slave_attribute *slave_attrs[] = {
-	&slave_attr_state,
-	&slave_attr_mii_status,
-	&slave_attr_link_failure_count,
-	&slave_attr_perm_hwaddr,
-	&slave_attr_queue_id,
-	&slave_attr_ad_aggregator_id,
-	&slave_attr_ad_actor_oper_port_state,
-	&slave_attr_ad_partner_oper_port_state,
+static const struct attribute *slave_attrs[] = {
+	&slave_attr_state.attr,
+	&slave_attr_mii_status.attr,
+	&slave_attr_link_failure_count.attr,
+	&slave_attr_perm_hwaddr.attr,
+	&slave_attr_queue_id.attr,
+	&slave_attr_ad_aggregator_id.attr,
+	&slave_attr_ad_actor_oper_port_state.attr,
+	&slave_attr_ad_partner_oper_port_state.attr,
 	NULL
 };
 
@@ -141,24 +141,10 @@ const struct sysfs_ops slave_sysfs_ops = {
 
 int bond_sysfs_slave_add(struct slave *slave)
 {
-	const struct slave_attribute **a;
-	int err;
-
-	for (a = slave_attrs; *a; ++a) {
-		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
-		if (err) {
-			kobject_put(&slave->kobj);
-			return err;
-		}
-	}
-
-	return 0;
+	return sysfs_create_files(&slave->kobj, slave_attrs);
 }
 
 void bond_sysfs_slave_del(struct slave *slave)
 {
-	const struct slave_attribute **a;
-
-	for (a = slave_attrs; *a; ++a)
-		sysfs_remove_file(&slave->kobj, &((*a)->attr));
+	sysfs_remove_files(&slave->kobj, slave_attrs);
 }
-- 
2.33.0



