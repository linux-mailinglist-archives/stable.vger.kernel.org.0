Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C827A3F4F9B
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhHWRhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 13:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhHWRhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 13:37:33 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC118C061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 10:36:49 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id gw9-20020a0562140f0900b0035decb1dfecso12958150qvb.5
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 10:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VWMW9qjqli2zwxlx1r9yBrrD15LP7GkrVQkVpdOIMPQ=;
        b=SPmmDA099JZkQayIpZLGwicVrtIzHHoPvcia+9ZkmAoxztyM/7UUiyrgJR13zf1yP9
         szRPx3kLlFKa5p9nTQOPbOz7ZBaMai6ybCwFb1KpdW3faxPI8bnwftPdbf0NaqZpa8P0
         9WIl7LwON0Uftbdiu5E0z2gEdVJY+LulzO8FINJF4me/rJlwLktjlNVpy3L9jwyFgwlh
         7Ns3jBu9617wj/bRtx6ghiZraKQ/nBGWuFtQuM9mz8oR1ErxbHfG8RbpUfvJ75frzPkP
         S5Wx3BXeA9LEtDgKPRv2yziPrGX9DqPqAcywpnAgPMjz89J5hbYdV/5lvtDOF/ijxpBQ
         n4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VWMW9qjqli2zwxlx1r9yBrrD15LP7GkrVQkVpdOIMPQ=;
        b=XEVUdGb5Ek3A+daXcQu9J1oQUOsMBZ5enOEftX6jlzEpIQpUEAvg4EkWYmB1s92vhq
         s15pI8Eydhl7bi/4PgG5RIn6NZuaog6QikqqOf/sVjuP8LpleCxapoPYS3N61IHaTxD8
         0wXtPSUtRA3w6llnWuxMieE/p4bKNZaSPJinnfSzYYPnyVCRrDYUAwhFgC0dhCI7o0OG
         4vJwzk3ESK3rsTKecBstXSCmlncG8NUFHKTcco6bo0oCavhjOkpKwrmKdQgrD1EZ2X2m
         ntaTr1eLsl7rNluFfJ16zmh2QZNAtgo7uBNTZuQS+Kj3MkQ/FGq4gQWUkgAV36sDKGfr
         f2Hw==
X-Gm-Message-State: AOAM53240Nnp2BV4embDGay6TnYXZKuoMXUWRR3G4fb/Gew6UWKSm6I/
        JjuhWBP61BCW4BlBJwlAz2zdMXCc+8picYzlT8VTrNEr6/KAAUX0skW9xzZW3HKJLCs/Gstb6i1
        nQFXryeuI27rybaBFZpFx8kmmoAkCiu+8HuYfNHDfvjbGHHhlmOfJhg==
X-Google-Smtp-Source: ABdhPJygOvKgg6f41crIW9f7a9gYb93A49EtbUqP0Z12G2fijTSMG1szg1L9jfNxgi3xi6KJqACegYY=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:7848:63e1:35fc:b690])
 (user=sdf job=sendgmr) by 2002:a05:6214:1cb:: with SMTP id
 c11mr34493606qvt.47.1629740209104; Mon, 23 Aug 2021 10:36:49 -0700 (PDT)
Date:   Mon, 23 Aug 2021 10:36:46 -0700
Message-Id: <552c822eac5fb168f94570056ccd8a4b790db2bf.1629740134.git.sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 5.10.y] bpf: Fix NULL pointer dereference in
 bpf_get_local_storage() helper
From:   Stanislav Fomichev <sdf@google.com>
To:     stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
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
Change-Id: I0bff719d0bfbaa819316de26391b4b2e4e60faed
Signed-off-by: Stanislav Fomichev <sdf@google.com>
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
2.33.0.rc2.250.ged5fa647cd-goog

