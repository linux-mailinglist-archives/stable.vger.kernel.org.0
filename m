Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F089C3FDB23
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245577AbhIAMiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343740AbhIAMgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:36:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03CD6610D2;
        Wed,  1 Sep 2021 12:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499627;
        bh=XsX46DfwGCSVnwS5A5u4uV4NsPQJZHb1w8I9iK3JLz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pR1FIjEDlMTZmjbN3Od6Ir3hFFoltNCKDyanrOykGc/CxXCp2rl9f7TYAzTLZ28m8
         VzWLS09lMtRtlIsho+SKBH6CTTWlVXQTKsEynz1scWizy03ZaIbS5xt6ukrglEEgmc
         JAwSeA0l2wDfqUsNDL2+tQAxd5FH8XrQVSt/MWGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/103] bpf: Fix NULL pointer dereference in bpf_get_local_storage() helper
Date:   Wed,  1 Sep 2021 14:27:13 +0200
Message-Id: <20210901122300.624166603@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

commit b910eaaaa4b89976ef02e5d6448f3f73dc671d91 upstream.

Jiri Olsa reported a bug ([1]) in kernel where cgroup local
storage pointer may be NULL in bpf_get_local_storage() helper.
There are two issues uncovered by this bug:
  (1). kprobe or tracepoint prog incorrectly sets cgroup local storage
       before prog run,
  (2). due to change from preempt_disable to migrate_disable,
       preemption is possible and percpu storage might be overwritten
       by other tasks.

This issue (1) is fixed in [2]. This patch tried to address issue (2).
The following shows how things can go wrong:
  task 1:   bpf_cgroup_storage_set() for percpu local storage
         preemption happens
  task 2:   bpf_cgroup_storage_set() for percpu local storage
         preemption happens
  task 1:   run bpf program

task 1 will effectively use the percpu local storage setting by task 2
which will be either NULL or incorrect ones.

Instead of just one common local storage per cpu, this patch fixed
the issue by permitting 8 local storages per cpu and each local
storage is identified by a task_struct pointer. This way, we
allow at most 8 nested preemption between bpf_cgroup_storage_set()
and bpf_cgroup_storage_unset(). The percpu local storage slot
is released (calling bpf_cgroup_storage_unset()) by the same task
after bpf program finished running.
bpf_test_run() is also fixed to use the new bpf_cgroup_storage_set()
interface.

The patch is tested on top of [2] with reproducer in [1].
Without this patch, kernel will emit error in 2-3 minutes.
With this patch, after one hour, still no error.

 [1] https://lore.kernel.org/bpf/CAKH8qBuXCfUz=w8L+Fj74OaUpbosO29niYwTki7e3Ag044_aww@mail.gmail.com/T
 [2] https://lore.kernel.org/bpf/20210309185028.3763817-1-yhs@fb.com

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Link: https://lore.kernel.org/bpf/20210323055146.3334476-1-yhs@fb.com
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup.h | 57 ++++++++++++++++++++++++++++++++------
 include/linux/bpf.h        | 15 +++++++---
 kernel/bpf/helpers.c       | 15 +++++++---
 kernel/bpf/local_storage.c |  5 ++--
 net/bpf/test_run.c         |  6 +++-
 5 files changed, 79 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index ed71bd1a0825..53f14e8827cc 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -20,14 +20,25 @@ struct bpf_sock_ops_kern;
 struct bpf_cgroup_storage;
 struct ctl_table;
 struct ctl_table_header;
+struct task_struct;
 
 #ifdef CONFIG_CGROUP_BPF
 
 extern struct static_key_false cgroup_bpf_enabled_key;
 #define cgroup_bpf_enabled static_branch_unlikely(&cgroup_bpf_enabled_key)
 
-DECLARE_PER_CPU(struct bpf_cgroup_storage*,
-		bpf_cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE]);
+#define BPF_CGROUP_STORAGE_NEST_MAX	8
+
+struct bpf_cgroup_storage_info {
+	struct task_struct *task;
+	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE];
+};
+
+/* For each cpu, permit maximum BPF_CGROUP_STORAGE_NEST_MAX number of tasks
+ * to use bpf cgroup storage simultaneously.
+ */
+DECLARE_PER_CPU(struct bpf_cgroup_storage_info,
+		bpf_cgroup_storage_info[BPF_CGROUP_STORAGE_NEST_MAX]);
 
 #define for_each_cgroup_storage_type(stype) \
 	for (stype = 0; stype < MAX_BPF_CGROUP_STORAGE_TYPE; stype++)
@@ -156,13 +167,42 @@ static inline enum bpf_cgroup_storage_type cgroup_storage_type(
 	return BPF_CGROUP_STORAGE_SHARED;
 }
 
-static inline void bpf_cgroup_storage_set(struct bpf_cgroup_storage
-					  *storage[MAX_BPF_CGROUP_STORAGE_TYPE])
+static inline int bpf_cgroup_storage_set(struct bpf_cgroup_storage
+					 *storage[MAX_BPF_CGROUP_STORAGE_TYPE])
 {
 	enum bpf_cgroup_storage_type stype;
+	int i, err = 0;
+
+	preempt_disable();
+	for (i = 0; i < BPF_CGROUP_STORAGE_NEST_MAX; i++) {
+		if (unlikely(this_cpu_read(bpf_cgroup_storage_info[i].task) != NULL))
+			continue;
+
+		this_cpu_write(bpf_cgroup_storage_info[i].task, current);
+		for_each_cgroup_storage_type(stype)
+			this_cpu_write(bpf_cgroup_storage_info[i].storage[stype],
+				       storage[stype]);
+		goto out;
+	}
+	err = -EBUSY;
+	WARN_ON_ONCE(1);
+
+out:
+	preempt_enable();
+	return err;
+}
+
+static inline void bpf_cgroup_storage_unset(void)
+{
+	int i;
+
+	for (i = 0; i < BPF_CGROUP_STORAGE_NEST_MAX; i++) {
+		if (unlikely(this_cpu_read(bpf_cgroup_storage_info[i].task) != current))
+			continue;
 
-	for_each_cgroup_storage_type(stype)
-		this_cpu_write(bpf_cgroup_storage[stype], storage[stype]);
+		this_cpu_write(bpf_cgroup_storage_info[i].task, NULL);
+		return;
+	}
 }
 
 struct bpf_cgroup_storage *
@@ -410,8 +450,9 @@ static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
 	return -EINVAL;
 }
 
-static inline void bpf_cgroup_storage_set(
-	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE]) {}
+static inline int bpf_cgroup_storage_set(
+	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE]) { return 0; }
+static inline void bpf_cgroup_storage_unset(void) {}
 static inline int bpf_cgroup_storage_assign(struct bpf_prog_aux *aux,
 					    struct bpf_map *map) { return 0; }
 static inline struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c3ccb242d199..3f93a50c25ef 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1089,9 +1089,14 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 			goto _out;			\
 		_item = &_array->items[0];		\
 		while ((_prog = READ_ONCE(_item->prog))) {		\
-			if (set_cg_storage)		\
-				bpf_cgroup_storage_set(_item->cgroup_storage);	\
-			_ret &= func(_prog, ctx);	\
+			if (!set_cg_storage) {			\
+				_ret &= func(_prog, ctx);	\
+			} else {				\
+				if (unlikely(bpf_cgroup_storage_set(_item->cgroup_storage)))	\
+					break;			\
+				_ret &= func(_prog, ctx);	\
+				bpf_cgroup_storage_unset();	\
+			}				\
 			_item++;			\
 		}					\
 _out:							\
@@ -1135,8 +1140,10 @@ _out:							\
 		_array = rcu_dereference(array);	\
 		_item = &_array->items[0];		\
 		while ((_prog = READ_ONCE(_item->prog))) {		\
-			bpf_cgroup_storage_set(_item->cgroup_storage);	\
+			if (unlikely(bpf_cgroup_storage_set(_item->cgroup_storage)))	\
+				break;			\
 			ret = func(_prog, ctx);		\
+			bpf_cgroup_storage_unset();	\
 			_ret &= (ret & 1);		\
 			_cn |= (ret & 2);		\
 			_item++;			\
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index f7e99bb8c3b6..3bd7fbd8c543 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -372,8 +372,8 @@ const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto = {
 };
 
 #ifdef CONFIG_CGROUP_BPF
-DECLARE_PER_CPU(struct bpf_cgroup_storage*,
-		bpf_cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE]);
+DECLARE_PER_CPU(struct bpf_cgroup_storage_info,
+		bpf_cgroup_storage_info[BPF_CGROUP_STORAGE_NEST_MAX]);
 
 BPF_CALL_2(bpf_get_local_storage, struct bpf_map *, map, u64, flags)
 {
@@ -382,10 +382,17 @@ BPF_CALL_2(bpf_get_local_storage, struct bpf_map *, map, u64, flags)
 	 * verifier checks that its value is correct.
 	 */
 	enum bpf_cgroup_storage_type stype = cgroup_storage_type(map);
-	struct bpf_cgroup_storage *storage;
+	struct bpf_cgroup_storage *storage = NULL;
 	void *ptr;
+	int i;
 
-	storage = this_cpu_read(bpf_cgroup_storage[stype]);
+	for (i = 0; i < BPF_CGROUP_STORAGE_NEST_MAX; i++) {
+		if (unlikely(this_cpu_read(bpf_cgroup_storage_info[i].task) != current))
+			continue;
+
+		storage = this_cpu_read(bpf_cgroup_storage_info[i].storage[stype]);
+		break;
+	}
 
 	if (stype == BPF_CGROUP_STORAGE_SHARED)
 		ptr = &READ_ONCE(storage->buf)->data[0];
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 571bb351ed3b..b139247d2dd3 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -9,10 +9,11 @@
 #include <linux/slab.h>
 #include <uapi/linux/btf.h>
 
-DEFINE_PER_CPU(struct bpf_cgroup_storage*, bpf_cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE]);
-
 #ifdef CONFIG_CGROUP_BPF
 
+DEFINE_PER_CPU(struct bpf_cgroup_storage_info,
+	       bpf_cgroup_storage_info[BPF_CGROUP_STORAGE_NEST_MAX]);
+
 #include "../cgroup/cgroup-internal.h"
 
 #define LOCAL_STORAGE_CREATE_FLAG_MASK					\
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index e7cbd1b4a5e5..72d424a5a142 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -42,13 +42,17 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	migrate_disable();
 	time_start = ktime_get_ns();
 	for (i = 0; i < repeat; i++) {
-		bpf_cgroup_storage_set(storage);
+		ret = bpf_cgroup_storage_set(storage);
+		if (ret)
+			break;
 
 		if (xdp)
 			*retval = bpf_prog_run_xdp(prog, ctx);
 		else
 			*retval = BPF_PROG_RUN(prog, ctx);
 
+		bpf_cgroup_storage_unset();
+
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
-- 
2.30.2



