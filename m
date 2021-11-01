Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDDF44185F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhKAJqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234411AbhKAJom (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF8DC613C8;
        Mon,  1 Nov 2021 09:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758975;
        bh=B7NlcoXBbcEdEpxjA4R1Eluq85rgu6AyqC7x2HEKsC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SI7fviDPpA2FOr8OjatzMviGMjm0JV95AVqsaitoR+nCArzt+N5Vj4H2eR1nh0zMW
         uIJ9zn+m9wtI566ZbLuYpoHw4xEtiJ460tARZlrLaFojS9puxOmBgN6IMiSTucJHzT
         MD1PDCaX2gLX+Ws8AmHXjzsxmYGZNhG/rD2Gs7EQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.14 061/125] bpf: Fix potential race in tail call compatibility check
Date:   Mon,  1 Nov 2021 10:17:14 +0100
Message-Id: <20211101082544.747102496@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit 54713c85f536048e685258f880bf298a74c3620d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h   |    7 +++++--
 kernel/bpf/arraymap.c |    1 +
 kernel/bpf/core.c     |   20 +++++++++++++-------
 kernel/bpf/syscall.c  |    6 ++++--
 4 files changed, 23 insertions(+), 11 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -900,8 +900,11 @@ struct bpf_array_aux {
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
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1051,6 +1051,7 @@ static struct bpf_map *prog_array_map_al
 	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
 	INIT_LIST_HEAD(&aux->poke_progs);
 	mutex_init(&aux->poke_mutex);
+	spin_lock_init(&aux->owner.lock);
 
 	map = array_map_alloc(attr);
 	if (IS_ERR(map)) {
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1821,20 +1821,26 @@ static unsigned int __bpf_prog_ret0_warn
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
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -543,8 +543,10 @@ static void bpf_map_show_fdinfo(struct s
 
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


