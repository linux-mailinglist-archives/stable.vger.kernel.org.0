Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7DA59D3DD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242416AbiHWIRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242631AbiHWIPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:15:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB956D9D9;
        Tue, 23 Aug 2022 01:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B94BBB81C22;
        Tue, 23 Aug 2022 08:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACC1C433D6;
        Tue, 23 Aug 2022 08:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242213;
        bh=dpotEm7dc6Kgd+lBiw8ygGH4KNcLBsJs5OmMAjOPzU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZX3OQ0ACkC3VD4IeIifnBiU4zi028L+pLZ7EK8fbhuntL7/x6TTpqucHhr6usOdHm
         y/C93lowSa7gf5PyeeHbQFOoVKfARaVXa0tZRn4A2kCj/YfjFxFh2u0OlcvJggD39J
         I7IzGwTLAJe1JalrPN/pUoU269c+Cx5N/wM54O9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH 4.9 037/101] bpf: fix overflow in prog accounting
Date:   Tue, 23 Aug 2022 10:03:10 +0200
Message-Id: <20220823080035.990269412@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 5ccb071e97fbd9ffe623a0d3977cc6d013bee93c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h  |   11 +++++++++++
 kernel/bpf/core.c    |   16 +++++++++++++---
 kernel/bpf/syscall.c |   36 ++++++++++++++++++++++++++++--------
 3 files changed, 52 insertions(+), 11 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -246,6 +246,8 @@ struct bpf_prog *bpf_prog_get_type(u32 u
 struct bpf_prog *bpf_prog_add(struct bpf_prog *prog, int i);
 struct bpf_prog *bpf_prog_inc(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
+int __bpf_prog_charge(struct user_struct *user, u32 pages);
+void __bpf_prog_uncharge(struct user_struct *user, u32 pages);
 
 struct bpf_map *bpf_map_get_with_uref(u32 ufd);
 struct bpf_map *__bpf_map_get(struct fd f);
@@ -328,6 +330,15 @@ static inline struct bpf_prog *bpf_prog_
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
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -107,19 +107,29 @@ struct bpf_prog *bpf_prog_realloc(struct
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
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -581,19 +581,39 @@ static void free_used_maps(struct bpf_pr
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
-
-	memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	int ret;
 
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
@@ -602,7 +622,7 @@ static void bpf_prog_uncharge_memlock(st
 {
 	struct user_struct *user = prog->aux->user;
 
-	atomic_long_sub(prog->pages, &user->locked_vm);
+	__bpf_prog_uncharge(user, prog->pages);
 	free_uid(user);
 }
 


