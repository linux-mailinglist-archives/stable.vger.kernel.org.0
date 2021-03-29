Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F1C34C6D3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhC2IKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232082AbhC2IJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:09:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EBE161477;
        Mon, 29 Mar 2021 08:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005364;
        bh=yywFeTFmyBEUS+7GkJST7ioadp1BSgJZUfLO1NiJT8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfw3e+/ARhfaIpSr10f77YwgMwgJnD+O2ijSL+3j/W/j4tRNKXmoluW/qkioulINv
         vIrHZl8bIZxAOqsj+v7AJrf8JVZ6mcLpZQrR0HiYDgmOVzaauwOGtG1NbSzMBijUYm
         e2NHpnTH5kK8iIfQrUT0w6wFcL/+ThoRepfkNK20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Roman Gushchin <guro@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/72] bpf: Dont do bpf_cgroup_storage_set() for kuprobe/tp programs
Date:   Mon, 29 Mar 2021 09:58:31 +0200
Message-Id: <20210329075612.094491422@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 05a68ce5fa51a83c360381630f823545c5757aa2 ]

For kuprobe and tracepoint bpf programs, kernel calls
trace_call_bpf() which calls BPF_PROG_RUN_ARRAY_CHECK()
to run the program array. Currently, BPF_PROG_RUN_ARRAY_CHECK()
also calls bpf_cgroup_storage_set() to set percpu
cgroup local storage with NULL value. This is
due to Commit 394e40a29788 ("bpf: extend bpf_prog_array to store
pointers to the cgroup storage") which modified
__BPF_PROG_RUN_ARRAY() to call bpf_cgroup_storage_set()
and this macro is also used by BPF_PROG_RUN_ARRAY_CHECK().

kuprobe and tracepoint programs are not allowed to call
bpf_get_local_storage() helper hence does not
access percpu cgroup local storage. Let us
change BPF_PROG_RUN_ARRAY_CHECK() not to
modify percpu cgroup local storage.

The issue is observed when I tried to debug [1] where
percpu data is overwritten due to
  preempt_disable -> migration_disable
change. This patch does not completely fix the above issue,
which will be addressed separately, e.g., multiple cgroup
prog runs may preempt each other. But it does fix
any potential issue caused by tracing program
overwriting percpu cgroup storage:
 - in a busy system, a tracing program is to run between
   bpf_cgroup_storage_set() and the cgroup prog run.
 - a kprobe program is triggered by a helper in cgroup prog
   before bpf_get_local_storage() is called.

 [1] https://lore.kernel.org/bpf/CAKH8qBuXCfUz=w8L+Fj74OaUpbosO29niYwTki7e3Ag044_aww@mail.gmail.com/T

Fixes: 394e40a29788 ("bpf: extend bpf_prog_array to store pointers to the cgroup storage")
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Link: https://lore.kernel.org/bpf/20210309185028.3763817-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 16f6beef5cad..3b3337333cfd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -382,7 +382,7 @@ int bpf_prog_array_copy(struct bpf_prog_array __rcu *old_array,
 			struct bpf_prog *include_prog,
 			struct bpf_prog_array **new_array);
 
-#define __BPF_PROG_RUN_ARRAY(array, ctx, func, check_non_null)	\
+#define __BPF_PROG_RUN_ARRAY(array, ctx, func, check_non_null, set_cg_storage) \
 	({						\
 		struct bpf_prog_array_item *_item;	\
 		struct bpf_prog *_prog;			\
@@ -395,7 +395,8 @@ int bpf_prog_array_copy(struct bpf_prog_array __rcu *old_array,
 			goto _out;			\
 		_item = &_array->items[0];		\
 		while ((_prog = READ_ONCE(_item->prog))) {		\
-			bpf_cgroup_storage_set(_item->cgroup_storage);	\
+			if (set_cg_storage)		\
+				bpf_cgroup_storage_set(_item->cgroup_storage);	\
 			_ret &= func(_prog, ctx);	\
 			_item++;			\
 		}					\
@@ -406,10 +407,10 @@ _out:							\
 	 })
 
 #define BPF_PROG_RUN_ARRAY(array, ctx, func)		\
-	__BPF_PROG_RUN_ARRAY(array, ctx, func, false)
+	__BPF_PROG_RUN_ARRAY(array, ctx, func, false, true)
 
 #define BPF_PROG_RUN_ARRAY_CHECK(array, ctx, func)	\
-	__BPF_PROG_RUN_ARRAY(array, ctx, func, true)
+	__BPF_PROG_RUN_ARRAY(array, ctx, func, true, false)
 
 #ifdef CONFIG_BPF_SYSCALL
 DECLARE_PER_CPU(int, bpf_prog_active);
-- 
2.30.1



