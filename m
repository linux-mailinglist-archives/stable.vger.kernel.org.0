Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4893CF56D7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbfKHTLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391078AbfKHTKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F0A420673;
        Fri,  8 Nov 2019 19:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240209;
        bh=9+JX3QyceqFBH2ZujSCe4zG1aCkIeICt4OQm4sNIQHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBrquKBTD3smgRtOBjRXcMmfyG4F1RP9MQp1t1I1fzkuGdJfxhLFtpg0OIkXp7w0a
         jI0WmntKmW7hkpGSRSoFt/KwHtdRlXW0L6d7Tc2gMyXFhO76FYaNM7IpFdZZFX4coz
         GPpkVHztQPQb6XXqmulyQY5zLsSQFLLBRePBVVpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        kernel test robot <oliver.sang@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 127/140] net: reorder struct net fields to avoid false sharing
Date:   Fri,  8 Nov 2019 19:50:55 +0100
Message-Id: <20191108174912.683710821@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2a06b8982f8f2f40d03a3daf634676386bd84dbc ]

Intel test robot reported a ~7% regression on TCP_CRR tests
that they bisected to the cited commit.

Indeed, every time a new TCP socket is created or deleted,
the atomic counter net->count is touched (via get_net(net)
and put_net(net) calls)

So cpus might have to reload a contended cache line in
net_hash_mix(net) calls.

We need to reorder 'struct net' fields to move @hash_mix
in a read mostly cache line.

We move in the first cache line fields that can be
dirtied often.

We probably will have to address in a followup patch
the __randomize_layout that was added in linux-4.13,
since this might break our placement choices.

Fixes: 355b98553789 ("netns: provide pure entropy for net_hash_mix()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/net_namespace.h |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -52,6 +52,9 @@ struct bpf_prog;
 #define NETDEV_HASHENTRIES (1 << NETDEV_HASHBITS)
 
 struct net {
+	/* First cache line can be often dirtied.
+	 * Do not place here read-mostly fields.
+	 */
 	refcount_t		passive;	/* To decide when the network
 						 * namespace should be freed.
 						 */
@@ -60,7 +63,13 @@ struct net {
 						 */
 	spinlock_t		rules_mod_lock;
 
-	u32			hash_mix;
+	unsigned int		dev_unreg_count;
+
+	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
+	int			ifindex;
+
+	spinlock_t		nsid_lock;
+	atomic_t		fnhe_genid;
 
 	struct list_head	list;		/* list of network namespaces */
 	struct list_head	exit_list;	/* To linked to call pernet exit
@@ -76,11 +85,11 @@ struct net {
 #endif
 	struct user_namespace   *user_ns;	/* Owning user namespace */
 	struct ucounts		*ucounts;
-	spinlock_t		nsid_lock;
 	struct idr		netns_ids;
 
 	struct ns_common	ns;
 
+	struct list_head 	dev_base_head;
 	struct proc_dir_entry 	*proc_net;
 	struct proc_dir_entry 	*proc_net_stat;
 
@@ -93,12 +102,14 @@ struct net {
 
 	struct uevent_sock	*uevent_sock;		/* uevent socket */
 
-	struct list_head 	dev_base_head;
 	struct hlist_head 	*dev_name_head;
 	struct hlist_head	*dev_index_head;
-	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
-	int			ifindex;
-	unsigned int		dev_unreg_count;
+	/* Note that @hash_mix can be read millions times per second,
+	 * it is critical that it is on a read_mostly cache line.
+	 */
+	u32			hash_mix;
+
+	struct net_device       *loopback_dev;          /* The loopback */
 
 	/* core fib_rules */
 	struct list_head	rules_ops;
@@ -106,7 +117,6 @@ struct net {
 	struct list_head	fib_notifier_ops;  /* Populated by
 						    * register_pernet_subsys()
 						    */
-	struct net_device       *loopback_dev;          /* The loopback */
 	struct netns_core	core;
 	struct netns_mib	mib;
 	struct netns_packet	packet;
@@ -171,7 +181,6 @@ struct net {
 	struct netns_xdp	xdp;
 #endif
 	struct sock		*diag_nlsk;
-	atomic_t		fnhe_genid;
 } __randomize_layout;
 
 #include <linux/seq_file_net.h>


