Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3337B226B30
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgGTPrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730800AbgGTPro (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:47:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3531B22CE3;
        Mon, 20 Jul 2020 15:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260063;
        bh=lma8JNycsSTWor3Y9EkN0plfCof0wyQ4GLF+WtuTjB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqYBXO6EaqJEA0WnxzIz3tlZf1rb+5a2pLp6+KvgUhbOlVEoqfgvY6V4bvmWf/9Ij
         Sq+dhi34yjRAWtfHKCR3PS8GN4QGRMGkuno9/a2AiNHRVHXL9LXQKSOZQwmh7NcT76
         1iEel4EBDkXQjEOVLZ5mUWRjb4qqFD9IixBep4z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?q?Dani=C3=ABl=20Sonck?= <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 053/125] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Date:   Mon, 20 Jul 2020 17:36:32 +0200
Message-Id: <20200720152805.586288264@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit ad0f75e5f57ccbceec13274e1e242f2b5a6397ed ]

When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
copied, so the cgroup refcnt must be taken too. And, unlike the
sk_alloc() path, sock_update_netprioidx() is not called here.
Therefore, it is safe and necessary to grab the cgroup refcnt
even when cgroup_sk_alloc is disabled.

sk_clone_lock() is in BH context anyway, the in_interrupt()
would terminate this function if called there. And for sk_alloc()
skcd->val is always zero. So it's safe to factor out the code
to make it more readable.

The global variable 'cgroup_sk_alloc_disabled' is used to determine
whether to take these reference counts. It is impossible to make
the reference counting correct unless we save this bit of information
in skcd->val. So, add a new bit there to record whether the socket
has already taken the reference counts. This obviously relies on
kmalloc() to align cgroup pointers to at least 4 bytes,
ARCH_KMALLOC_MINALIGN is certainly larger than that.

This bug seems to be introduced since the beginning, commit
d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
tried to fix it but not compeletely. It seems not easy to trigger until
the recent commit 090e28b229af
("netprio_cgroup: Fix unlimited memory leak of v2 cgroups") was merged.

Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
Reported-by: Peter Geis <pgwipeout@gmail.com>
Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Reported-by: Daniël Sonck <dsonck92@gmail.com>
Reported-by: Zhang Qiang <qiang.zhang@windriver.com>
Tested-by: Cameron Berkenpas <cam@neo-zeon.de>
Tested-by: Peter Geis <pgwipeout@gmail.com>
Tested-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup-defs.h |    6 ++++--
 include/linux/cgroup.h      |    4 +++-
 kernel/cgroup/cgroup.c      |   29 ++++++++++++++++++-----------
 net/core/sock.c             |    2 +-
 4 files changed, 26 insertions(+), 15 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -681,7 +681,8 @@ struct sock_cgroup_data {
 	union {
 #ifdef __LITTLE_ENDIAN
 		struct {
-			u8	is_data;
+			u8	is_data : 1;
+			u8	no_refcnt : 1;
 			u8	padding;
 			u16	prioidx;
 			u32	classid;
@@ -691,7 +692,8 @@ struct sock_cgroup_data {
 			u32	classid;
 			u16	prioidx;
 			u8	padding;
-			u8	is_data;
+			u8	no_refcnt : 1;
+			u8	is_data : 1;
 		} __packed;
 #endif
 		u64		val;
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -714,6 +714,7 @@ extern spinlock_t cgroup_sk_update_lock;
 
 void cgroup_sk_alloc_disable(void);
 void cgroup_sk_alloc(struct sock_cgroup_data *skcd);
+void cgroup_sk_clone(struct sock_cgroup_data *skcd);
 void cgroup_sk_free(struct sock_cgroup_data *skcd);
 
 static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
@@ -727,7 +728,7 @@ static inline struct cgroup *sock_cgroup
 	 */
 	v = READ_ONCE(skcd->val);
 
-	if (v & 1)
+	if (v & 3)
 		return &cgrp_dfl_root.cgrp;
 
 	return (struct cgroup *)(unsigned long)v ?: &cgrp_dfl_root.cgrp;
@@ -739,6 +740,7 @@ static inline struct cgroup *sock_cgroup
 #else	/* CONFIG_CGROUP_DATA */
 
 static inline void cgroup_sk_alloc(struct sock_cgroup_data *skcd) {}
+static inline void cgroup_sk_clone(struct sock_cgroup_data *skcd) {}
 static inline void cgroup_sk_free(struct sock_cgroup_data *skcd) {}
 
 #endif	/* CONFIG_CGROUP_DATA */
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5798,17 +5798,8 @@ void cgroup_sk_alloc_disable(void)
 
 void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 {
-	if (cgroup_sk_alloc_disabled)
-		return;
-
-	/* Socket clone path */
-	if (skcd->val) {
-		/*
-		 * We might be cloning a socket which is left in an empty
-		 * cgroup and the cgroup might have already been rmdir'd.
-		 * Don't use cgroup_get_live().
-		 */
-		cgroup_get(sock_cgroup_ptr(skcd));
+	if (cgroup_sk_alloc_disabled) {
+		skcd->no_refcnt = 1;
 		return;
 	}
 
@@ -5832,8 +5823,24 @@ void cgroup_sk_alloc(struct sock_cgroup_
 	rcu_read_unlock();
 }
 
+void cgroup_sk_clone(struct sock_cgroup_data *skcd)
+{
+	/* Socket clone path */
+	if (skcd->val) {
+		/*
+		 * We might be cloning a socket which is left in an empty
+		 * cgroup and the cgroup might have already been rmdir'd.
+		 * Don't use cgroup_get_live().
+		 */
+		cgroup_get(sock_cgroup_ptr(skcd));
+	}
+}
+
 void cgroup_sk_free(struct sock_cgroup_data *skcd)
 {
+	if (skcd->no_refcnt)
+		return;
+
 	cgroup_put(sock_cgroup_ptr(skcd));
 }
 
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1689,7 +1689,7 @@ struct sock *sk_clone_lock(const struct
 		/* sk->sk_memcg will be populated at accept() time */
 		newsk->sk_memcg = NULL;
 
-		cgroup_sk_alloc(&newsk->sk_cgrp_data);
+		cgroup_sk_clone(&newsk->sk_cgrp_data);
 
 		rcu_read_lock();
 		filter = rcu_dereference(sk->sk_filter);


