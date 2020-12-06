Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E0C2D03A6
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgLFLjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:39:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgLFLj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:39:28 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 01/32] ipv6: addrlabel: fix possible memory leak in ip6addrlbl_net_init
Date:   Sun,  6 Dec 2020 12:17:01 +0100
Message-Id: <20201206111555.859989045@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
References: <20201206111555.787862631@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit e255e11e66da8281e337e4e352956e8a4999fca4 ]

kmemleak report a memory leak as follows:

unreferenced object 0xffff8880059c6a00 (size 64):
  comm "ip", pid 23696, jiffies 4296590183 (age 1755.384s)
  hex dump (first 32 bytes):
    20 01 00 10 00 00 00 00 00 00 00 00 00 00 00 00   ...............
    1c 00 00 00 00 00 00 00 00 00 00 00 07 00 00 00  ................
  backtrace:
    [<00000000aa4e7a87>] ip6addrlbl_add+0x90/0xbb0
    [<0000000070b8d7f1>] ip6addrlbl_net_init+0x109/0x170
    [<000000006a9ca9d4>] ops_init+0xa8/0x3c0
    [<000000002da57bf2>] setup_net+0x2de/0x7e0
    [<000000004e52d573>] copy_net_ns+0x27d/0x530
    [<00000000b07ae2b4>] create_new_namespaces+0x382/0xa30
    [<000000003b76d36f>] unshare_nsproxy_namespaces+0xa1/0x1d0
    [<0000000030653721>] ksys_unshare+0x3a4/0x780
    [<0000000007e82e40>] __x64_sys_unshare+0x2d/0x40
    [<0000000031a10c08>] do_syscall_64+0x33/0x40
    [<0000000099df30e7>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

We should free all rules when we catch an error in ip6addrlbl_net_init().
otherwise a memory leak will occur.

Fixes: 2a8cc6c89039 ("[IPV6] ADDRCONF: Support RFC3484 configurable address selection policy table.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20201124071728.8385-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrlabel.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -306,7 +306,9 @@ static int ip6addrlbl_del(struct net *ne
 /* add default label */
 static int __net_init ip6addrlbl_net_init(struct net *net)
 {
-	int err = 0;
+	struct ip6addrlbl_entry *p = NULL;
+	struct hlist_node *n;
+	int err;
 	int i;
 
 	ADDRLABEL(KERN_DEBUG "%s\n", __func__);
@@ -315,14 +317,20 @@ static int __net_init ip6addrlbl_net_ini
 	INIT_HLIST_HEAD(&net->ipv6.ip6addrlbl_table.head);
 
 	for (i = 0; i < ARRAY_SIZE(ip6addrlbl_init_table); i++) {
-		int ret = ip6addrlbl_add(net,
-					 ip6addrlbl_init_table[i].prefix,
-					 ip6addrlbl_init_table[i].prefixlen,
-					 0,
-					 ip6addrlbl_init_table[i].label, 0);
-		/* XXX: should we free all rules when we catch an error? */
-		if (ret && (!err || err != -ENOMEM))
-			err = ret;
+		err = ip6addrlbl_add(net,
+				     ip6addrlbl_init_table[i].prefix,
+				     ip6addrlbl_init_table[i].prefixlen,
+				     0,
+				     ip6addrlbl_init_table[i].label, 0);
+		if (err)
+			goto err_ip6addrlbl_add;
+	}
+	return 0;
+
+err_ip6addrlbl_add:
+	hlist_for_each_entry_safe(p, n, &net->ipv6.ip6addrlbl_table.head, list) {
+		hlist_del_rcu(&p->list);
+		kfree_rcu(p, rcu);
 	}
 	return err;
 }


