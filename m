Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 196A818B47A
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgCSNKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728472AbgCSNKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:10:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6D91208D6;
        Thu, 19 Mar 2020 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623408;
        bh=KCjhFg6t71SENc/TOglfUchirlI2hWjadK+FAxg2NuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCFJF76YnbD/5Rk5YDC4YvO18X7Aw2b4RFquXDivvMM52Trvhn7cRgwQbPmnzBC3f
         DSBd/Es2CnZu2EdG4xOu/0b1aBk+/5nEw2dlC627VDPAp6P4NLSQeMk5E3roH6uJ6s
         7LJeWDUh/rE34ODk8m2U6+YaZY1syCawenWeGUAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Yakunin <zeil@yandex-team.ru>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 04/90] cgroup, netclassid: periodically release file_lock on classid updating
Date:   Thu, 19 Mar 2020 13:59:26 +0100
Message-Id: <20200319123929.922845068@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Yakunin <zeil@yandex-team.ru>

[ Upstream commit 018d26fcd12a75fb9b5fe233762aa3f2f0854b88 ]

In our production environment we have faced with problem that updating
classid in cgroup with heavy tasks cause long freeze of the file tables
in this tasks. By heavy tasks we understand tasks with many threads and
opened sockets (e.g. balancers). This freeze leads to an increase number
of client timeouts.

This patch implements following logic to fix this issue:
аfter iterating 1000 file descriptors file table lock will be released
thus providing a time gap for socket creation/deletion.

Now update is non atomic and socket may be skipped using calls:

dup2(oldfd, newfd);
close(oldfd);

But this case is not typical. Moreover before this patch skip is possible
too by hiding socket fd in unix socket buffer.

New sockets will be allocated with updated classid because cgroup state
is updated before start of the file descriptors iteration.

So in common cases this patch has no side effects.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netclassid_cgroup.c |   47 +++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -55,30 +55,60 @@ static void cgrp_css_free(struct cgroup_
 	kfree(css_cls_state(css));
 }
 
+/*
+ * To avoid freezing of sockets creation for tasks with big number of threads
+ * and opened sockets lets release file_lock every 1000 iterated descriptors.
+ * New sockets will already have been created with new classid.
+ */
+
+struct update_classid_context {
+	u32 classid;
+	unsigned int batch;
+};
+
+#define UPDATE_CLASSID_BATCH 1000
+
 static int update_classid_sock(const void *v, struct file *file, unsigned n)
 {
 	int err;
+	struct update_classid_context *ctx = (void *)v;
 	struct socket *sock = sock_from_file(file, &err);
 
 	if (sock) {
 		spin_lock(&cgroup_sk_update_lock);
-		sock_cgroup_set_classid(&sock->sk->sk_cgrp_data,
-					(unsigned long)v);
+		sock_cgroup_set_classid(&sock->sk->sk_cgrp_data, ctx->classid);
 		spin_unlock(&cgroup_sk_update_lock);
 	}
+	if (--ctx->batch == 0) {
+		ctx->batch = UPDATE_CLASSID_BATCH;
+		return n + 1;
+	}
 	return 0;
 }
 
+static void update_classid_task(struct task_struct *p, u32 classid)
+{
+	struct update_classid_context ctx = {
+		.classid = classid,
+		.batch = UPDATE_CLASSID_BATCH
+	};
+	unsigned int fd = 0;
+
+	do {
+		task_lock(p);
+		fd = iterate_fd(p->files, fd, update_classid_sock, &ctx);
+		task_unlock(p);
+		cond_resched();
+	} while (fd);
+}
+
 static void cgrp_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
 	struct task_struct *p;
 
 	cgroup_taskset_for_each(p, css, tset) {
-		task_lock(p);
-		iterate_fd(p->files, 0, update_classid_sock,
-			   (void *)(unsigned long)css_cls_state(css)->classid);
-		task_unlock(p);
+		update_classid_task(p, css_cls_state(css)->classid);
 	}
 }
 
@@ -100,10 +130,7 @@ static int write_classid(struct cgroup_s
 
 	css_task_iter_start(css, &it);
 	while ((p = css_task_iter_next(&it))) {
-		task_lock(p);
-		iterate_fd(p->files, 0, update_classid_sock,
-			   (void *)(unsigned long)cs->classid);
-		task_unlock(p);
+		update_classid_task(p, cs->classid);
 		cond_resched();
 	}
 	css_task_iter_end(&it);


