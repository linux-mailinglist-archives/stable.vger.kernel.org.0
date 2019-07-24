Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8374273DB6
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392902AbfGXUTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391140AbfGXTtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:49:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2C20214AF;
        Wed, 24 Jul 2019 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997740;
        bh=lDWU2RUlt7qpyt4uDsyAnM9kfhkxyzaZS/6NI2empQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vl0EKzI9f+W8yjXBZsLRIx4kQef3QNpSRrS9MJv51Z0zjeN/3qsDPamIh08aZkyq9
         cfDPXMvkn4dgfDFLpYPx0DsvgTSwkKqVTBEIRZ86b1d2y3CgLJP/EilfH0ds3eXvFR
         JBRMiNdXoGr/7OzG37zC6tsi5ynQArWlVnmDtIGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+722da59ccb264bc19910@syzkaller.appspotmail.com,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 127/371] ipvs: defer hook registration to avoid leaks
Date:   Wed, 24 Jul 2019 21:17:59 +0200
Message-Id: <20190724191734.436972041@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cf47a0b882a4e5f6b34c7949d7b293e9287f1972 ]

syzkaller reports for memory leak when registering hooks [1]

As we moved the nf_unregister_net_hooks() call into
__ip_vs_dev_cleanup(), defer the nf_register_net_hooks()
call, so that hooks are allocated and freed from same
pernet_operations (ipvs_core_dev_ops).

[1]
BUG: memory leak
unreferenced object 0xffff88810acd8a80 (size 96):
 comm "syz-executor073", pid 7254, jiffies 4294950560 (age 22.250s)
 hex dump (first 32 bytes):
   02 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
   00 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
 backtrace:
   [<0000000013db61f1>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
   [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
   [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
   [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0 mm/slab.c:3597
   [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
   [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
   [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
   [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
   [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
   [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
   [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60 net/netfilter/core.c:61
   [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270 net/netfilter/core.c:128
   [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170 net/netfilter/core.c:337
   [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0 net/netfilter/core.c:464
   [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0 net/netfilter/core.c:480
   [<000000002ea868e0>] __ip_vs_init+0xe8/0x170 net/netfilter/ipvs/ip_vs_core.c:2280
   [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
   [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
   [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
   [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0 kernel/nsproxy.c:107
   [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
   [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150 kernel/fork.c:2035
   [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
   [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

Reported-by: syzbot+722da59ccb264bc19910@syzkaller.appspotmail.com
Fixes: 719c7d563c17 ("ipvs: Fix use-after-free in ip_vs_in")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 8ebf21149ec3..e72b51157cbb 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2250,7 +2250,6 @@ static const struct nf_hook_ops ip_vs_ops[] = {
 static int __net_init __ip_vs_init(struct net *net)
 {
 	struct netns_ipvs *ipvs;
-	int ret;
 
 	ipvs = net_generic(net, ip_vs_net_id);
 	if (ipvs == NULL)
@@ -2282,17 +2281,11 @@ static int __net_init __ip_vs_init(struct net *net)
 	if (ip_vs_sync_net_init(ipvs) < 0)
 		goto sync_fail;
 
-	ret = nf_register_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
-	if (ret < 0)
-		goto hook_fail;
-
 	return 0;
 /*
  * Error handling
  */
 
-hook_fail:
-	ip_vs_sync_net_cleanup(ipvs);
 sync_fail:
 	ip_vs_conn_net_cleanup(ipvs);
 conn_fail:
@@ -2322,6 +2315,19 @@ static void __net_exit __ip_vs_cleanup(struct net *net)
 	net->ipvs = NULL;
 }
 
+static int __net_init __ip_vs_dev_init(struct net *net)
+{
+	int ret;
+
+	ret = nf_register_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
+	if (ret < 0)
+		goto hook_fail;
+	return 0;
+
+hook_fail:
+	return ret;
+}
+
 static void __net_exit __ip_vs_dev_cleanup(struct net *net)
 {
 	struct netns_ipvs *ipvs = net_ipvs(net);
@@ -2341,6 +2347,7 @@ static struct pernet_operations ipvs_core_ops = {
 };
 
 static struct pernet_operations ipvs_core_dev_ops = {
+	.init = __ip_vs_dev_init,
 	.exit = __ip_vs_dev_cleanup,
 };
 
-- 
2.20.1



