Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F82420E6C4
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404466AbgF2Vue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854FD24787;
        Mon, 29 Jun 2020 15:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444093;
        bh=FhmwB88O57CR0ErdjSaM/GnQ/TxWai5+2EiBJyy0BBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXSs+QkcT5DpZnoC/988wM3j/N/gWXfYrsSYXI/7KUdJtixmMlnDEKBApaLWhnh3T
         DDEkC0BSGQIxro4eBSkZ6BsXg/6rtTDaGukqugsuc2zVPeuJwS2VCYRtUoDVuNT35r
         xvvSoYiB0korG8Ok1n2KuUi9yUWZFFXDem6YBuqo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 203/265] kprobes: Suppress the suspicious RCU warning on kprobes
Date:   Mon, 29 Jun 2020 11:17:16 -0400
Message-Id: <20200629151818.2493727-204-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 6743ad432ec92e680cd0d9db86cb17b949cf5a43 ]

Anders reported that the lockdep warns that suspicious
RCU list usage in register_kprobe() (detected by
CONFIG_PROVE_RCU_LIST.) This is because get_kprobe()
access kprobe_table[] by hlist_for_each_entry_rcu()
without rcu_read_lock.

If we call get_kprobe() from the breakpoint handler context,
it is run with preempt disabled, so this is not a problem.
But in other cases, instead of rcu_read_lock(), we locks
kprobe_mutex so that the kprobe_table[] is not updated.
So, current code is safe, but still not good from the view
point of RCU.

Joel suggested that we can silent that warning by passing
lockdep_is_held() to the last argument of
hlist_for_each_entry_rcu().

Add lockdep_is_held(&kprobe_mutex) at the end of the
hlist_for_each_entry_rcu() to suppress the warning.

Link: http://lkml.kernel.org/r/158927055350.27680.10261450713467997503.stgit@devnote2

Reported-by: Anders Roxell <anders.roxell@linaro.org>
Suggested-by: Joel Fernandes <joel@joelfernandes.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 195ecb955fcc5..950a5cfd262ce 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -326,7 +326,8 @@ struct kprobe *get_kprobe(void *addr)
 	struct kprobe *p;
 
 	head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
-	hlist_for_each_entry_rcu(p, head, hlist) {
+	hlist_for_each_entry_rcu(p, head, hlist,
+				 lockdep_is_held(&kprobe_mutex)) {
 		if (p->addr == addr)
 			return p;
 	}
-- 
2.25.1

