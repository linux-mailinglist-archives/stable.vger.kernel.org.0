Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C1734CA92
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhC2IjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234907AbhC2Ihe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7D4A619C8;
        Mon, 29 Mar 2021 08:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007037;
        bh=So4DkYke52l59xCLo9+/4JCqYW4E4QyXVwGv+n2rcgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1+unLTzzwU3KO+Sz6YA2Kdbf5YQCVoeJJGKak36KwnNRjMKJUd6QOms0WnJL31MB
         +KV8+WDEMOqVvhpIoCGO7dUwxNTKJJagjWeisDomtWsAyYbC2RrhohzUDEFz9II1FP
         Lte9QpFmi6BdvLNULnRzfJdPPGk68XMNI1JlQ68o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 162/254] ftrace: Fix modify_ftrace_direct.
Date:   Mon, 29 Mar 2021 09:57:58 +0200
Message-Id: <20210329075638.512363025@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 8a141dd7f7060d1e64c14a5257e0babae20ac99b ]

The following sequence of commands:
  register_ftrace_direct(ip, addr1);
  modify_ftrace_direct(ip, addr1, addr2);
  unregister_ftrace_direct(ip, addr2);
will cause the kernel to warn:
[   30.179191] WARNING: CPU: 2 PID: 1961 at kernel/trace/ftrace.c:5223 unregister_ftrace_direct+0x130/0x150
[   30.180556] CPU: 2 PID: 1961 Comm: test_progs    W  O      5.12.0-rc2-00378-g86bc10a0a711-dirty #3246
[   30.182453] RIP: 0010:unregister_ftrace_direct+0x130/0x150

When modify_ftrace_direct() changes the addr from old to new it should update
the addr stored in ftrace_direct_funcs. Otherwise the final
unregister_ftrace_direct() won't find the address and will cause the splat.

Fixes: 0567d6809182 ("ftrace: Add modify_ftrace_direct()")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: https://lore.kernel.org/bpf/20210316195815.34714-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 43 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4d8e35575549..b7e29db127fa 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5045,6 +5045,20 @@ struct ftrace_direct_func *ftrace_find_direct_func(unsigned long addr)
 	return NULL;
 }
 
+static struct ftrace_direct_func *ftrace_alloc_direct_func(unsigned long addr)
+{
+	struct ftrace_direct_func *direct;
+
+	direct = kmalloc(sizeof(*direct), GFP_KERNEL);
+	if (!direct)
+		return NULL;
+	direct->addr = addr;
+	direct->count = 0;
+	list_add_rcu(&direct->next, &ftrace_direct_funcs);
+	ftrace_direct_func_count++;
+	return direct;
+}
+
 /**
  * register_ftrace_direct - Call a custom trampoline directly
  * @ip: The address of the nop at the beginning of a function
@@ -5120,15 +5134,11 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 
 	direct = ftrace_find_direct_func(addr);
 	if (!direct) {
-		direct = kmalloc(sizeof(*direct), GFP_KERNEL);
+		direct = ftrace_alloc_direct_func(addr);
 		if (!direct) {
 			kfree(entry);
 			goto out_unlock;
 		}
-		direct->addr = addr;
-		direct->count = 0;
-		list_add_rcu(&direct->next, &ftrace_direct_funcs);
-		ftrace_direct_func_count++;
 	}
 
 	entry->ip = ip;
@@ -5329,6 +5339,7 @@ int __weak ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
 int modify_ftrace_direct(unsigned long ip,
 			 unsigned long old_addr, unsigned long new_addr)
 {
+	struct ftrace_direct_func *direct, *new_direct = NULL;
 	struct ftrace_func_entry *entry;
 	struct dyn_ftrace *rec;
 	int ret = -ENODEV;
@@ -5344,6 +5355,20 @@ int modify_ftrace_direct(unsigned long ip,
 	if (entry->direct != old_addr)
 		goto out_unlock;
 
+	direct = ftrace_find_direct_func(old_addr);
+	if (WARN_ON(!direct))
+		goto out_unlock;
+	if (direct->count > 1) {
+		ret = -ENOMEM;
+		new_direct = ftrace_alloc_direct_func(new_addr);
+		if (!new_direct)
+			goto out_unlock;
+		direct->count--;
+		new_direct->count++;
+	} else {
+		direct->addr = new_addr;
+	}
+
 	/*
 	 * If there's no other ftrace callback on the rec->ip location,
 	 * then it can be changed directly by the architecture.
@@ -5357,6 +5382,14 @@ int modify_ftrace_direct(unsigned long ip,
 		ret = 0;
 	}
 
+	if (unlikely(ret && new_direct)) {
+		direct->count++;
+		list_del_rcu(&new_direct->next);
+		synchronize_rcu_tasks();
+		kfree(new_direct);
+		ftrace_direct_func_count--;
+	}
+
  out_unlock:
 	mutex_unlock(&ftrace_lock);
 	mutex_unlock(&direct_mutex);
-- 
2.30.1



