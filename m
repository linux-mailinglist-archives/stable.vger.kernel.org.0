Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B588695E
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404455AbfHHTGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404424AbfHHTGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:06:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9C51214C6;
        Thu,  8 Aug 2019 19:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291192;
        bh=rk6tcLs2L2UIlcvgNRZk3BQfsJ/va8mSvpxFd/vUt9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omSqvL9QSwRqPtpetFhZUp0NVUfgC9oJlqjPpglhLpZFQbO+9G4fw4MDiv74E2J3r
         2YbHRJrO8pL9lFvWz4fKWQDzIxIH4+u9HNuce8U3F+HwkR6ZnfxYns6eA+QES4MPgQ
         0/NLP/k2k9UcI881UeX01ah4qt46MEQPnjUR+3FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 21/56] net: fix ifindex collision during namespace removal
Date:   Thu,  8 Aug 2019 21:04:47 +0200
Message-Id: <20190808190453.725834754@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit 55b40dbf0e76b4bfb9d8b3a16a0208640a9a45df ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9711,6 +9711,8 @@ static void __net_exit default_device_ex
 
 		/* Push remaining network devices to init_net */
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
+		if (__dev_get_by_name(&init_net, fb_name))
+			snprintf(fb_name, IFNAMSIZ, "dev%%d");
 		err = dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
 			pr_emerg("%s: failed to move %s to init_net: %d\n",


