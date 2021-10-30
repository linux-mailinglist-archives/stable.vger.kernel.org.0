Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419354408D3
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 14:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhJ3M6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 08:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhJ3M6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 08:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF042610E5;
        Sat, 30 Oct 2021 12:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635598572;
        bh=WCQ2sXUfA04sBI8ePnreJrpczjipvcawzytHiGreH1w=;
        h=Subject:To:Cc:From:Date:From;
        b=hOOmAdIXXyEAh9LOSnPI2TSnkuFyRtEzpJOe5HaxClO2Qd39fEXhzaxdnDw+BpADx
         WW2gGN6WbRWGfzvuc6Qk3423cbZP5HYqJG8LkFV2MTQiBKlwH/cwJehBVFF5qM5nBM
         mtrzJIrsYOfiO8bXZp9YDT6/yPQ4tQ/0WGEvMpqc=
Subject: FAILED: patch "[PATCH] bpf: Fix potential race in tail call compatibility check" failed to apply to 4.4-stable tree
To:     toke@redhat.com, ast@kernel.org, lorenzo.bianconi@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 14:56:02 +0200
Message-ID: <1635598562115205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 54713c85f536048e685258f880bf298a74c3620d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Date: Tue, 26 Oct 2021 13:00:19 +0200
Subject: [PATCH] bpf: Fix potential race in tail call compatibility check
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Lorenzo noticed that the code testing for program type compatibility of
tail call maps is potentially racy in that two threads could encounter a
map with an unset type simultaneously and both return true even though they
are inserting incompatible programs.

The race window is quite small, but artificially enlarging it by adding a
usleep_range() inside the check in bpf_prog_array_compatible() makes it
trivial to trigger from userspace with a program that does, essentially:

        map_fd = bpf_create_map(BPF_MAP_TYPE_PROG_ARRAY, 4, 4, 2, 0);
        pid = fork();
        if (pid) {
                key = 0;
                value = xdp_fd;
        } else {
                key = 1;
                value = tc_fd;
        }
        err = bpf_map_update_elem(map_fd, &key, &value, 0);

While the race window is small, it has potentially serious ramifications in
that triggering it would allow a BPF program to tail call to a program of a
different type. So let's get rid of it by protecting the update with a
spinlock. The commit in the Fixes tag is the last commit that touches the
code in question.

v2:
- Use a spinlock instead of an atomic variable and cmpxchg() (Alexei)
v3:
- Put lock and the members it protects into an embedded 'owner' struct (Daniel)

Fixes: 3324b584b6f6 ("ebpf: misc core cleanup")
Reported-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211026110019.363464-1-toke@redhat.com

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 020a7d5bf470..3db6f6c95489 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -929,8 +929,11 @@ struct bpf_array_aux {
 	 * stored in the map to make sure that all callers and callees have
 	 * the same prog type and JITed flag.
 	 */
-	enum bpf_prog_type type;
-	bool jited;
+	struct {
+		spinlock_t lock;
+		enum bpf_prog_type type;
+		bool jited;
+	} owner;
 	/* Programs with direct jumps into programs part of this array. */
 	struct list_head poke_progs;
 	struct bpf_map *map;
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index cebd4fb06d19..447def540544 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1072,6 +1072,7 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
 	INIT_LIST_HEAD(&aux->poke_progs);
 	mutex_init(&aux->poke_mutex);
+	spin_lock_init(&aux->owner.lock);
 
 	map = array_map_alloc(attr);
 	if (IS_ERR(map)) {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c1e7eb3f1876..6e3ae90ad107 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1823,20 +1823,26 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 bool bpf_prog_array_compatible(struct bpf_array *array,
 			       const struct bpf_prog *fp)
 {
+	bool ret;
+
 	if (fp->kprobe_override)
 		return false;
 
-	if (!array->aux->type) {
+	spin_lock(&array->aux->owner.lock);
+
+	if (!array->aux->owner.type) {
 		/* There's no owner yet where we could check for
 		 * compatibility.
 		 */
-		array->aux->type  = fp->type;
-		array->aux->jited = fp->jited;
-		return true;
+		array->aux->owner.type  = fp->type;
+		array->aux->owner.jited = fp->jited;
+		ret = true;
+	} else {
+		ret = array->aux->owner.type  == fp->type &&
+		      array->aux->owner.jited == fp->jited;
 	}
-
-	return array->aux->type  == fp->type &&
-	       array->aux->jited == fp->jited;
+	spin_unlock(&array->aux->owner.lock);
+	return ret;
 }
 
 static int bpf_check_tail_call(const struct bpf_prog *fp)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9dab49d3f394..1cad6979a0d0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -543,8 +543,10 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 
 	if (map->map_type == BPF_MAP_TYPE_PROG_ARRAY) {
 		array = container_of(map, struct bpf_array, map);
-		type  = array->aux->type;
-		jited = array->aux->jited;
+		spin_lock(&array->aux->owner.lock);
+		type  = array->aux->owner.type;
+		jited = array->aux->owner.jited;
+		spin_unlock(&array->aux->owner.lock);
 	}
 
 	seq_printf(m,

