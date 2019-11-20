Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD13103FDE
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbfKTPqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:46:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52540 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729533AbfKTPkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:16 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004aJ-Qz; Wed, 20 Nov 2019 15:40:11 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004Gd-2h; Wed, 20 Nov 2019 15:40:11 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jiri Pirko" <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 20 Nov 2019 15:37:25 +0000
Message-ID: <lsq.1574264230.857404162@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 15/83] net: fix ifindex collision during namespace
 removal
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@mellanox.com>

commit 55b40dbf0e76b4bfb9d8b3a16a0208640a9a45df upstream.

Commit aca51397d014 ("netns: Fix arbitrary net_device-s corruptions
on net_ns stop.") introduced a possibility to hit a BUG in case device
is returning back to init_net and two following conditions are met:
1) dev->ifindex value is used in a name of another "dev%d"
   device in init_net.
2) dev->name is used by another device in init_net.

Under real life circumstances this is hard to get. Therefore this has
been present happily for over 10 years. To reproduce:

$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 86:89:3f:86:61:29 brd ff:ff:ff:ff:ff:ff
3: enp0s2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
$ ip netns add ns1
$ ip -n ns1 link add dummy1ns1 type dummy
$ ip -n ns1 link add dummy2ns1 type dummy
$ ip link set enp0s2 netns ns1
$ ip -n ns1 link set enp0s2 name dummy0
[  100.858894] virtio_net virtio0 dummy0: renamed from enp0s2
$ ip link add dev4 type dummy
$ ip -n ns1 a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy1ns1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 16:63:4c:38:3e:ff brd ff:ff:ff:ff:ff:ff
3: dummy2ns1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether aa:9e:86:dd:6b:5d brd ff:ff:ff:ff:ff:ff
4: dummy0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 86:89:3f:86:61:29 brd ff:ff:ff:ff:ff:ff
4: dev4: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5a:e1:4a:b6:ec:f8 brd ff:ff:ff:ff:ff:ff
$ ip netns del ns1
[  158.717795] default_device_exit: failed to move dummy0 to init_net: -17
[  158.719316] ------------[ cut here ]------------
[  158.720591] kernel BUG at net/core/dev.c:9824!
[  158.722260] invalid opcode: 0000 [#1] SMP KASAN PTI
[  158.723728] CPU: 0 PID: 56 Comm: kworker/u2:1 Not tainted 5.3.0-rc1+ #18
[  158.725422] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
[  158.727508] Workqueue: netns cleanup_net
[  158.728915] RIP: 0010:default_device_exit.cold+0x1d/0x1f
[  158.730683] Code: 84 e8 18 c9 3e fe 0f 0b e9 70 90 ff ff e8 36 e4 52 fe 89 d9 4c 89 e2 48 c7 c6 80 d6 25 84 48 c7 c7 20 c0 25 84 e8 f4 c8 3e
[  158.736854] RSP: 0018:ffff8880347e7b90 EFLAGS: 00010282
[  158.738752] RAX: 000000000000003b RBX: 00000000ffffffef RCX: 0000000000000000
[  158.741369] RDX: 0000000000000000 RSI: ffffffff8128013d RDI: ffffed10068fcf64
[  158.743418] RBP: ffff888033550170 R08: 000000000000003b R09: fffffbfff0b94b9c
[  158.745626] R10: fffffbfff0b94b9b R11: ffffffff85ca5cdf R12: ffff888032f28000
[  158.748405] R13: dffffc0000000000 R14: ffff8880335501b8 R15: 1ffff110068fcf72
[  158.750638] FS:  0000000000000000(0000) GS:ffff888036000000(0000) knlGS:0000000000000000
[  158.752944] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  158.755245] CR2: 00007fe8b45d21d0 CR3: 00000000340b4005 CR4: 0000000000360ef0
[  158.757654] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  158.760012] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  158.762758] Call Trace:
[  158.763882]  ? dev_change_net_namespace+0xbb0/0xbb0
[  158.766148]  ? devlink_nl_cmd_set_doit+0x520/0x520
[  158.768034]  ? dev_change_net_namespace+0xbb0/0xbb0
[  158.769870]  ops_exit_list.isra.0+0xa8/0x150
[  158.771544]  cleanup_net+0x446/0x8f0
[  158.772945]  ? unregister_pernet_operations+0x4a0/0x4a0
[  158.775294]  process_one_work+0xa1a/0x1740
[  158.776896]  ? pwq_dec_nr_in_flight+0x310/0x310
[  158.779143]  ? do_raw_spin_lock+0x11b/0x280
[  158.780848]  worker_thread+0x9e/0x1060
[  158.782500]  ? process_one_work+0x1740/0x1740
[  158.784454]  kthread+0x31b/0x420
[  158.786082]  ? __kthread_create_on_node+0x3f0/0x3f0
[  158.788286]  ret_from_fork+0x3a/0x50
[  158.789871] ---[ end trace defd6c657c71f936 ]---
[  158.792273] RIP: 0010:default_device_exit.cold+0x1d/0x1f
[  158.795478] Code: 84 e8 18 c9 3e fe 0f 0b e9 70 90 ff ff e8 36 e4 52 fe 89 d9 4c 89 e2 48 c7 c6 80 d6 25 84 48 c7 c7 20 c0 25 84 e8 f4 c8 3e
[  158.804854] RSP: 0018:ffff8880347e7b90 EFLAGS: 00010282
[  158.807865] RAX: 000000000000003b RBX: 00000000ffffffef RCX: 0000000000000000
[  158.811794] RDX: 0000000000000000 RSI: ffffffff8128013d RDI: ffffed10068fcf64
[  158.816652] RBP: ffff888033550170 R08: 000000000000003b R09: fffffbfff0b94b9c
[  158.820930] R10: fffffbfff0b94b9b R11: ffffffff85ca5cdf R12: ffff888032f28000
[  158.825113] R13: dffffc0000000000 R14: ffff8880335501b8 R15: 1ffff110068fcf72
[  158.829899] FS:  0000000000000000(0000) GS:ffff888036000000(0000) knlGS:0000000000000000
[  158.834923] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  158.838164] CR2: 00007fe8b45d21d0 CR3: 00000000340b4005 CR4: 0000000000360ef0
[  158.841917] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  158.845149] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fix this by checking if a device with the same name exists in init_net
and fallback to original code - dev%d to allocate name - in case it does.

This was found using syzkaller.

Fixes: aca51397d014 ("netns: Fix arbitrary net_device-s corruptions on net_ns stop.")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7207,6 +7207,8 @@ static void __net_exit default_device_ex
 
 		/* Push remaining network devices to init_net */
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
+		if (__dev_get_by_name(&init_net, fb_name))
+			snprintf(fb_name, IFNAMSIZ, "dev%%d");
 		err = dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
 			pr_emerg("%s: failed to move %s to init_net: %d\n",

