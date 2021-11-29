Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F384A461E2C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349249AbhK2Sdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:33:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50582 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379254AbhK2SbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:31:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D852CE140F;
        Mon, 29 Nov 2021 18:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AB9C53FC7;
        Mon, 29 Nov 2021 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210477;
        bh=/+YhwYJ3KXbQNAP5k/IZtI0W5zXK5PeBf+6vYaJOOkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFeYsQqlwzlsYa9lfmtOEEdCBvLnGz4TFpYalwFZ/MMbYwk8REBVANqCdVxoymX5d
         GC4V8UqDettA2ZETws+aoq5le/MtG+3cErvjzD1qcmy0UfMEWMviOfnktaiZPMITEX
         fXtLIm9yN3iVVuuWCShi17TPPiINbQBmUFMasd/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, w1tcher.bupt@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Masami Ichikawa(CIP)" <masami.ichikawa@cybertrust.co.jp>
Subject: [PATCH 5.10 001/121] bpf: Fix toctou on read-only maps constant scalar tracking
Date:   Mon, 29 Nov 2021 19:17:12 +0100
Message-Id: <20211129181711.692010016@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 353050be4c19e102178ccc05988101887c25ae53 upstream.

Commit a23740ec43ba ("bpf: Track contents of read-only maps as scalars") is
checking whether maps are read-only both from BPF program side and user space
side, and then, given their content is constant, reading out their data via
map->ops->map_direct_value_addr() which is then subsequently used as known
scalar value for the register, that is, it is marked as __mark_reg_known()
with the read value at verification time. Before a23740ec43ba, the register
content was marked as an unknown scalar so the verifier could not make any
assumptions about the map content.

The current implementation however is prone to a TOCTOU race, meaning, the
value read as known scalar for the register is not guaranteed to be exactly
the same at a later point when the program is executed, and as such, the
prior made assumptions of the verifier with regards to the program will be
invalid which can cause issues such as OOB access, etc.

While the BPF_F_RDONLY_PROG map flag is always fixed and required to be
specified at map creation time, the map->frozen property is initially set to
false for the map given the map value needs to be populated, e.g. for global
data sections. Once complete, the loader "freezes" the map from user space
such that no subsequent updates/deletes are possible anymore. For the rest
of the lifetime of the map, this freeze one-time trigger cannot be undone
anymore after a successful BPF_MAP_FREEZE cmd return. Meaning, any new BPF_*
cmd calls which would update/delete map entries will be rejected with -EPERM
since map_get_sys_perms() removes the FMODE_CAN_WRITE permission. This also
means that pending update/delete map entries must still complete before this
guarantee is given. This corner case is not an issue for loaders since they
create and prepare such program private map in successive steps.

However, a malicious user is able to trigger this TOCTOU race in two different
ways: i) via userfaultfd, and ii) via batched updates. For i) userfaultfd is
used to expand the competition interval, so that map_update_elem() can modify
the contents of the map after map_freeze() and bpf_prog_load() were executed.
This works, because userfaultfd halts the parallel thread which triggered a
map_update_elem() at the time where we copy key/value from the user buffer and
this already passed the FMODE_CAN_WRITE capability test given at that time the
map was not "frozen". Then, the main thread performs the map_freeze() and
bpf_prog_load(), and once that had completed successfully, the other thread
is woken up to complete the pending map_update_elem() which then changes the
map content. For ii) the idea of the batched update is similar, meaning, when
there are a large number of updates to be processed, it can increase the
competition interval between the two. It is therefore possible in practice to
modify the contents of the map after executing map_freeze() and bpf_prog_load().

One way to fix both i) and ii) at the same time is to expand the use of the
map's map->writecnt. The latter was introduced in fc9702273e2e ("bpf: Add mmap()
support for BPF_MAP_TYPE_ARRAY") and further refined in 1f6cb19be2e2 ("bpf:
Prevent re-mmap()'ing BPF map as writable for initially r/o mapping") with
the rationale to make a writable mmap()'ing of a map mutually exclusive with
read-only freezing. The counter indicates writable mmap() mappings and then
prevents/fails the freeze operation. Its semantics can be expanded beyond
just mmap() by generally indicating ongoing write phases. This would essentially
span any parallel regular and batched flavor of update/delete operation and
then also have map_freeze() fail with -EBUSY. For the check_mem_access() in
the verifier we expand upon the bpf_map_is_rdonly() check ensuring that all
last pending writes have completed via bpf_map_write_active() test. Once the
map->frozen is set and bpf_map_write_active() indicates a map->writecnt of 0
only then we are really guaranteed to use the map's data as known constants.
For map->frozen being set and pending writes in process of still being completed
we fall back to marking that register as unknown scalar so we don't end up
making assumptions about it. With this, both TOCTOU reproducers from i) and
ii) are fixed.

Note that the map->writecnt has been converted into a atomic64 in the fix in
order to avoid a double freeze_mutex mutex_{un,}lock() pair when updating
map->writecnt in the various map update/delete BPF_* cmd flavors. Spanning
the freeze_mutex over entire map update/delete operations in syscall side
would not be possible due to then causing everything to be serialized.
Similarly, something like synchronize_rcu() after setting map->frozen to wait
for update/deletes to complete is not possible either since it would also
have to span the user copy which can sleep. On the libbpf side, this won't
break d66562fba1ce ("libbpf: Add BPF object skeleton support") as the
anonymous mmap()-ed "map initialization image" is remapped as a BPF map-backed
mmap()-ed memory where for .rodata it's non-writable.

Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")
Reported-by: w1tcher.bupt@gmail.com
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[fix conflict to call bpf_map_write_active_dec() in err_put block.
fix conflict to insert new functions after find_and_alloc_map().]
Reference: CVE-2021-4001
Signed-off-by: Masami Ichikawa(CIP) <masami.ichikawa@cybertrust.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h   |    3 +-
 kernel/bpf/syscall.c  |   57 +++++++++++++++++++++++++++++++-------------------
 kernel/bpf/verifier.c |   17 ++++++++++++++
 3 files changed, 54 insertions(+), 23 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -173,7 +173,7 @@ struct bpf_map {
 	atomic64_t usercnt;
 	struct work_struct work;
 	struct mutex freeze_mutex;
-	u64 writecnt; /* writable mmap cnt; protected by freeze_mutex */
+	atomic64_t writecnt;
 };
 
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
@@ -1252,6 +1252,7 @@ void bpf_map_charge_move(struct bpf_map_
 void *bpf_map_area_alloc(u64 size, int numa_node);
 void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
 void bpf_map_area_free(void *base);
+bool bpf_map_write_active(const struct bpf_map *map);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 int  generic_map_lookup_batch(struct bpf_map *map,
 			      const union bpf_attr *attr,
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -127,6 +127,21 @@ static struct bpf_map *find_and_alloc_ma
 	return map;
 }
 
+static void bpf_map_write_active_inc(struct bpf_map *map)
+{
+	atomic64_inc(&map->writecnt);
+}
+
+static void bpf_map_write_active_dec(struct bpf_map *map)
+{
+	atomic64_dec(&map->writecnt);
+}
+
+bool bpf_map_write_active(const struct bpf_map *map)
+{
+	return atomic64_read(&map->writecnt) != 0;
+}
+
 static u32 bpf_map_value_size(struct bpf_map *map)
 {
 	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
@@ -588,11 +603,8 @@ static void bpf_map_mmap_open(struct vm_
 {
 	struct bpf_map *map = vma->vm_file->private_data;
 
-	if (vma->vm_flags & VM_MAYWRITE) {
-		mutex_lock(&map->freeze_mutex);
-		map->writecnt++;
-		mutex_unlock(&map->freeze_mutex);
-	}
+	if (vma->vm_flags & VM_MAYWRITE)
+		bpf_map_write_active_inc(map);
 }
 
 /* called for all unmapped memory region (including initial) */
@@ -600,11 +612,8 @@ static void bpf_map_mmap_close(struct vm
 {
 	struct bpf_map *map = vma->vm_file->private_data;
 
-	if (vma->vm_flags & VM_MAYWRITE) {
-		mutex_lock(&map->freeze_mutex);
-		map->writecnt--;
-		mutex_unlock(&map->freeze_mutex);
-	}
+	if (vma->vm_flags & VM_MAYWRITE)
+		bpf_map_write_active_dec(map);
 }
 
 static const struct vm_operations_struct bpf_map_default_vmops = {
@@ -654,7 +663,7 @@ static int bpf_map_mmap(struct file *fil
 		goto out;
 
 	if (vma->vm_flags & VM_MAYWRITE)
-		map->writecnt++;
+		bpf_map_write_active_inc(map);
 out:
 	mutex_unlock(&map->freeze_mutex);
 	return err;
@@ -1086,6 +1095,7 @@ static int map_update_elem(union bpf_att
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
+	bpf_map_write_active_inc(map);
 	if (!(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
 		err = -EPERM;
 		goto err_put;
@@ -1127,6 +1137,7 @@ free_value:
 free_key:
 	kfree(key);
 err_put:
+	bpf_map_write_active_dec(map);
 	fdput(f);
 	return err;
 }
@@ -1149,6 +1160,7 @@ static int map_delete_elem(union bpf_att
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
+	bpf_map_write_active_inc(map);
 	if (!(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
 		err = -EPERM;
 		goto err_put;
@@ -1179,6 +1191,7 @@ static int map_delete_elem(union bpf_att
 out:
 	kfree(key);
 err_put:
+	bpf_map_write_active_dec(map);
 	fdput(f);
 	return err;
 }
@@ -1483,6 +1496,7 @@ static int map_lookup_and_delete_elem(un
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
+	bpf_map_write_active_inc(map);
 	if (!(map_get_sys_perms(map, f) & FMODE_CAN_READ) ||
 	    !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
 		err = -EPERM;
@@ -1524,6 +1538,7 @@ free_value:
 free_key:
 	kfree(key);
 err_put:
+	bpf_map_write_active_dec(map);
 	fdput(f);
 	return err;
 }
@@ -1550,8 +1565,7 @@ static int map_freeze(const union bpf_at
 	}
 
 	mutex_lock(&map->freeze_mutex);
-
-	if (map->writecnt) {
+	if (bpf_map_write_active(map)) {
 		err = -EBUSY;
 		goto err_put;
 	}
@@ -3976,6 +3990,9 @@ static int bpf_map_do_batch(const union
 			    union bpf_attr __user *uattr,
 			    int cmd)
 {
+	bool has_read  = cmd == BPF_MAP_LOOKUP_BATCH ||
+			 cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH;
+	bool has_write = cmd != BPF_MAP_LOOKUP_BATCH;
 	struct bpf_map *map;
 	int err, ufd;
 	struct fd f;
@@ -3988,16 +4005,13 @@ static int bpf_map_do_batch(const union
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
-
-	if ((cmd == BPF_MAP_LOOKUP_BATCH ||
-	     cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH) &&
-	    !(map_get_sys_perms(map, f) & FMODE_CAN_READ)) {
+	if (has_write)
+		bpf_map_write_active_inc(map);
+	if (has_read && !(map_get_sys_perms(map, f) & FMODE_CAN_READ)) {
 		err = -EPERM;
 		goto err_put;
 	}
-
-	if (cmd != BPF_MAP_LOOKUP_BATCH &&
-	    !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
+	if (has_write && !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
 		err = -EPERM;
 		goto err_put;
 	}
@@ -4010,8 +4024,9 @@ static int bpf_map_do_batch(const union
 		BPF_DO_BATCH(map->ops->map_update_batch);
 	else
 		BPF_DO_BATCH(map->ops->map_delete_batch);
-
 err_put:
+	if (has_write)
+		bpf_map_write_active_dec(map);
 	fdput(f);
 	return err;
 }
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3486,7 +3486,22 @@ static void coerce_reg_to_size(struct bp
 
 static bool bpf_map_is_rdonly(const struct bpf_map *map)
 {
-	return (map->map_flags & BPF_F_RDONLY_PROG) && map->frozen;
+	/* A map is considered read-only if the following condition are true:
+	 *
+	 * 1) BPF program side cannot change any of the map content. The
+	 *    BPF_F_RDONLY_PROG flag is throughout the lifetime of a map
+	 *    and was set at map creation time.
+	 * 2) The map value(s) have been initialized from user space by a
+	 *    loader and then "frozen", such that no new map update/delete
+	 *    operations from syscall side are possible for the rest of
+	 *    the map's lifetime from that point onwards.
+	 * 3) Any parallel/pending map update/delete operations from syscall
+	 *    side have been completed. Only after that point, it's safe to
+	 *    assume that map value(s) are immutable.
+	 */
+	return (map->map_flags & BPF_F_RDONLY_PROG) &&
+	       READ_ONCE(map->frozen) &&
+	       !bpf_map_write_active(map);
 }
 
 static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)


