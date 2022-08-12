Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03439590DFE
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 11:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiHLJWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 05:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiHLJWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 05:22:37 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8BAA347B
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 02:22:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso4041686wma.2
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 02:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=TU00raQn+9GfyKTCSjkwLiXMje/rVJBhclP3kHxNgkQ=;
        b=Vs8A9r38e9b6wd453mq5acOpObSGmWaEqr8yQ9qaZytiOK/mwk/+T7lQrcMERRulpU
         gHaBsyUwA23A7aguIJ/9o1ykBZ5SjK97SThwI8Hjssg2qDP+ILzJdEWB5h2/MP4pJeMH
         SLHjxCG/EycSGwJGRWsLDm8D64LnyLZNy5zHRwftiK+nzrWe2pJMvdY1Z1FX5KN1jSRo
         3Ny4MtOhHED6GiMdmXDE149xbyxxEG+RCebNXCjf6pwr7KKe37GeKGFhZKqsisjtpll/
         qGksKxQf+fL6BrXTaZ30hq7pr9oNBOMyE8vQ7rfSgPSl6DEs4N0PIzV1k9hzH7fFgr2Q
         RZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=TU00raQn+9GfyKTCSjkwLiXMje/rVJBhclP3kHxNgkQ=;
        b=tHD8gfge3tsyFk8v4DKYfLUFH1AV8mm88BIJjjNDwzDAAnuZZnbsmO913eGPknqAAH
         vOdPHQxqJU28eBrl/hLSOQCb6RI/c4PRNtnZZTS9aXjAG1xpF60YFuVCi+Pj6UmJOnow
         GFNiww0ysIT/c/I6iMFf+K0gkwvv5WN+h6LK309BiETnkoqNmqDr0tPeqG64iMUzZmlK
         48yaFlTJZkQjrGCXQC1/PVnCazmu4K9S8XKR+LQd/UQhHru+5Gyha/dwfr+F1ceEpApw
         cl+f6viirAWPuKmZyrAwh5jE6iCG5Yro/ShGjZpBc5xk4mWGIDvCqD7aVFeXTYeM70Oy
         wcHw==
X-Gm-Message-State: ACgBeo1b/x9hLZNleXOH1wQwlSTmlTayWttNvm24WPIxmBMNvWWZ8uD1
        l/yo2gNPvjCG16MAPUsmbv4EnE9z3ojioAc4
X-Google-Smtp-Source: AA6agR5NNvt0y/QaMk9SRohqI5mAausdvAh9UQH9rGopAyGffZBMvFDUMeVM+1OfJXHLZBH6y02Uhg==
X-Received: by 2002:a05:600c:3d0f:b0:3a5:b6be:8c63 with SMTP id bh15-20020a05600c3d0f00b003a5b6be8c63mr1963724wmb.100.1660296154420;
        Fri, 12 Aug 2022 02:22:34 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c26d100b003a2f2bb72d5sm10625550wmv.45.2022.08.12.02.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 02:22:34 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     stable@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH 4.9] bpf: fix overflow in prog accounting
Date:   Fri, 12 Aug 2022 10:22:11 +0100
Message-Id: <20220812092211.14446-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 5ccb071e97fbd9ffe623a0d3977cc6d013bee93c ]

Commit aaac3ba95e4c ("bpf: charge user for creation of BPF maps and
programs") made a wrong assumption of charging against prog->pages.
Unlike map->pages, prog->pages are still subject to change when we
need to expand the program through bpf_prog_realloc().

This can for example happen during verification stage when we need to
expand and rewrite parts of the program. Should the required space
cross a page boundary, then prog->pages is not the same anymore as
its original value that we used to bpf_prog_charge_memlock() on. Thus,
we'll hit a wrap-around during bpf_prog_uncharge_memlock() when prog
is freed eventually. I noticed this that despite having unlimited
memlock, programs suddenly refused to load with EPERM error due to
insufficient memlock.

There are two ways to fix this issue. One would be to add a cached
variable to struct bpf_prog that takes a snapshot of prog->pages at the
time of charging. The other approach is to also account for resizes. I
chose to go with the latter for a couple of reasons: i) We want accounting
rather to be more accurate instead of further fooling limits, ii) adding
yet another page counter on struct bpf_prog would also be a waste just
for this purpose. We also do want to charge as early as possible to
avoid going into the verifier just to find out later on that we crossed
limits. The only place that needs to be fixed is bpf_prog_realloc(),
since only here we expand the program, so we try to account for the
needed delta and should we fail, call-sites check for outcome anyway.
On cBPF to eBPF migrations, we don't grab a reference to the user as
they are charged differently. With that in place, my test case worked
fine.

Fixes: aaac3ba95e4c ("bpf: charge user for creation of BPF maps and programs")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Quentin: backport to 4.9: Adjust context in bpf.h ]
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
This fix was merged in Linux 4.10 but never backported to 4.9. The
overflow has been occurring regularly when running Cilium's CI tests on
kernel 4.9, so I would like to submit this patch for consideration to
the 4.9 stable branch.

The initial patch applied with a minor conflict on include/linux/bpf.h,
due to unprivileged_ebpf_enabled() backported in 6481835a9a5b
("x86/speculation: Include unprivileged eBPF status in Spectre v2
mitigation reporting")
---
 include/linux/bpf.h  | 11 +++++++++++
 kernel/bpf/core.c    | 16 +++++++++++++---
 kernel/bpf/syscall.c | 36 ++++++++++++++++++++++++++++--------
 3 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fe520d40597f..7a1e6d3d0fd9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -246,6 +246,8 @@ struct bpf_prog *bpf_prog_get_type(u32 ufd, enum bpf_prog_type type);
 struct bpf_prog *bpf_prog_add(struct bpf_prog *prog, int i);
 struct bpf_prog *bpf_prog_inc(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
+int __bpf_prog_charge(struct user_struct *user, u32 pages);
+void __bpf_prog_uncharge(struct user_struct *user, u32 pages);
 
 struct bpf_map *bpf_map_get_with_uref(u32 ufd);
 struct bpf_map *__bpf_map_get(struct fd f);
@@ -328,6 +330,15 @@ static inline struct bpf_prog *bpf_prog_inc(struct bpf_prog *prog)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline int __bpf_prog_charge(struct user_struct *user, u32 pages)
+{
+	return 0;
+}
+
+static inline void __bpf_prog_uncharge(struct user_struct *user, u32 pages)
+{
+}
+
 static inline bool unprivileged_ebpf_enabled(void)
 {
 	return false;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9976703f2dbf..5aeadf79e05e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -107,19 +107,29 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 	gfp_t gfp_flags = GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO |
 			  gfp_extra_flags;
 	struct bpf_prog *fp;
+	u32 pages, delta;
+	int ret;
 
 	BUG_ON(fp_old == NULL);
 
 	size = round_up(size, PAGE_SIZE);
-	if (size <= fp_old->pages * PAGE_SIZE)
+	pages = size / PAGE_SIZE;
+	if (pages <= fp_old->pages)
 		return fp_old;
 
+	delta = pages - fp_old->pages;
+	ret = __bpf_prog_charge(fp_old->aux->user, delta);
+	if (ret)
+		return NULL;
+
 	fp = __vmalloc(size, gfp_flags, PAGE_KERNEL);
-	if (fp != NULL) {
+	if (fp == NULL) {
+		__bpf_prog_uncharge(fp_old->aux->user, delta);
+	} else {
 		kmemcheck_annotate_bitfield(fp, meta);
 
 		memcpy(fp, fp_old, fp_old->pages * PAGE_SIZE);
-		fp->pages = size / PAGE_SIZE;
+		fp->pages = pages;
 		fp->aux->prog = fp;
 
 		/* We keep fp->aux from fp_old around in the new
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e30ad1be6841..e0d4e210b1a1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -581,19 +581,39 @@ static void free_used_maps(struct bpf_prog_aux *aux)
 	kfree(aux->used_maps);
 }
 
+int __bpf_prog_charge(struct user_struct *user, u32 pages)
+{
+	unsigned long memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	unsigned long user_bufs;
+
+	if (user) {
+		user_bufs = atomic_long_add_return(pages, &user->locked_vm);
+		if (user_bufs > memlock_limit) {
+			atomic_long_sub(pages, &user->locked_vm);
+			return -EPERM;
+		}
+	}
+
+	return 0;
+}
+
+void __bpf_prog_uncharge(struct user_struct *user, u32 pages)
+{
+	if (user)
+		atomic_long_sub(pages, &user->locked_vm);
+}
+
 static int bpf_prog_charge_memlock(struct bpf_prog *prog)
 {
 	struct user_struct *user = get_current_user();
-	unsigned long memlock_limit;
+	int ret;
 
-	memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	atomic_long_add(prog->pages, &user->locked_vm);
-	if (atomic_long_read(&user->locked_vm) > memlock_limit) {
-		atomic_long_sub(prog->pages, &user->locked_vm);
+	ret = __bpf_prog_charge(user, prog->pages);
+	if (ret) {
 		free_uid(user);
-		return -EPERM;
+		return ret;
 	}
+
 	prog->aux->user = user;
 	return 0;
 }
@@ -602,7 +622,7 @@ static void bpf_prog_uncharge_memlock(struct bpf_prog *prog)
 {
 	struct user_struct *user = prog->aux->user;
 
-	atomic_long_sub(prog->pages, &user->locked_vm);
+	__bpf_prog_uncharge(user, prog->pages);
 	free_uid(user);
 }
 
-- 
2.25.1

