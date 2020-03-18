Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D987118A46A
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 21:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgCRUyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727610AbgCRUyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A9421841;
        Wed, 18 Mar 2020 20:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564853;
        bh=rzO4Wfq1pgO3m0SkYQiQbx9f4kvzwkiAV1A9ruyWszE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGdRJx7gNI7Y34GesYO9lFvaMsM2nHSbpOjfEIb7z4R3M+qXnkbfdY6BgAH3uqfWW
         SwtNtUYfaVeO4qGky8zn6axy5SBagZ+KpBDcCOUw/Ts2BGA7BfJTuoQvnrRfVWPxwx
         MHANFUscBVc2U/Mtj7qgpUgzilmeQ4Zlh728MA2g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/73] futex: Fix inode life-time issue
Date:   Wed, 18 Mar 2020 16:52:54 -0400
Message-Id: <20200318205337.16279-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 8019ad13ef7f64be44d4f892af9c840179009254 ]

As reported by Jann, ihold() does not in fact guarantee inode
persistence. And instead of making it so, replace the usage of inode
pointers with a per boot, machine wide, unique inode identifier.

This sequence number is global, but shared (file backed) futexes are
rare enough that this should not become a performance issue.

Reported-by: Jann Horn <jannh@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c            |  1 +
 include/linux/fs.h    |  1 +
 include/linux/futex.h | 17 +++++----
 kernel/futex.c        | 89 ++++++++++++++++++++++++++-----------------
 4 files changed, 65 insertions(+), 43 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 96d62d97694ef..c5267a4db0f5e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -137,6 +137,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
+	atomic64_set(&inode->i_sequence, 0);
 	atomic_set(&inode->i_count, 1);
 	inode->i_op = &empty_iops;
 	inode->i_fop = &no_open_fops;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0b4d8fc79e0f3..06668379109e3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -698,6 +698,7 @@ struct inode {
 		struct rcu_head		i_rcu;
 	};
 	atomic64_t		i_version;
+	atomic64_t		i_sequence; /* see futex */
 	atomic_t		i_count;
 	atomic_t		i_dio_count;
 	atomic_t		i_writecount;
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 5cc3fed27d4c2..b70df27d7e85c 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -31,23 +31,26 @@ struct task_struct;
 
 union futex_key {
 	struct {
+		u64 i_seq;
 		unsigned long pgoff;
-		struct inode *inode;
-		int offset;
+		unsigned int offset;
 	} shared;
 	struct {
+		union {
+			struct mm_struct *mm;
+			u64 __tmp;
+		};
 		unsigned long address;
-		struct mm_struct *mm;
-		int offset;
+		unsigned int offset;
 	} private;
 	struct {
+		u64 ptr;
 		unsigned long word;
-		void *ptr;
-		int offset;
+		unsigned int offset;
 	} both;
 };
 
-#define FUTEX_KEY_INIT (union futex_key) { .both = { .ptr = NULL } }
+#define FUTEX_KEY_INIT (union futex_key) { .both = { .ptr = 0ULL } }
 
 #ifdef CONFIG_FUTEX
 enum {
diff --git a/kernel/futex.c b/kernel/futex.c
index afbf928d6a6b0..07ab324885ac0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -429,7 +429,7 @@ static void get_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		ihold(key->shared.inode); /* implies smp_mb(); (B) */
+		smp_mb();		/* explicit smp_mb(); (B) */
 		break;
 	case FUT_OFF_MMSHARED:
 		futex_get_mm(key); /* implies smp_mb(); (B) */
@@ -463,7 +463,6 @@ static void drop_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		iput(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
 		mmdrop(key->private.mm);
@@ -505,6 +504,46 @@ futex_setup_timer(ktime_t *time, struct hrtimer_sleeper *timeout,
 	return timeout;
 }
 
+/*
+ * Generate a machine wide unique identifier for this inode.
+ *
+ * This relies on u64 not wrapping in the life-time of the machine; which with
+ * 1ns resolution means almost 585 years.
+ *
+ * This further relies on the fact that a well formed program will not unmap
+ * the file while it has a (shared) futex waiting on it. This mapping will have
+ * a file reference which pins the mount and inode.
+ *
+ * If for some reason an inode gets evicted and read back in again, it will get
+ * a new sequence number and will _NOT_ match, even though it is the exact same
+ * file.
+ *
+ * It is important that match_futex() will never have a false-positive, esp.
+ * for PI futexes that can mess up the state. The above argues that false-negatives
+ * are only possible for malformed programs.
+ */
+static u64 get_inode_sequence_number(struct inode *inode)
+{
+	static atomic64_t i_seq;
+	u64 old;
+
+	/* Does the inode already have a sequence number? */
+	old = atomic64_read(&inode->i_sequence);
+	if (likely(old))
+		return old;
+
+	for (;;) {
+		u64 new = atomic64_add_return(1, &i_seq);
+		if (WARN_ON_ONCE(!new))
+			continue;
+
+		old = atomic64_cmpxchg_relaxed(&inode->i_sequence, 0, new);
+		if (old)
+			return old;
+		return new;
+	}
+}
+
 /**
  * get_futex_key() - Get parameters which are the keys for a futex
  * @uaddr:	virtual address of the futex
@@ -517,9 +556,15 @@ futex_setup_timer(ktime_t *time, struct hrtimer_sleeper *timeout,
  *
  * The key words are stored in @key on success.
  *
- * For shared mappings, it's (page->index, file_inode(vma->vm_file),
- * offset_within_page).  For private mappings, it's (uaddr, current->mm).
- * We can usually work out the index without swapping in the page.
+ * For shared mappings (when @fshared), the key is:
+ *   ( inode->i_sequence, page->index, offset_within_page )
+ * [ also see get_inode_sequence_number() ]
+ *
+ * For private mappings (or when !@fshared), the key is:
+ *   ( current->mm, address, 0 )
+ *
+ * This allows (cross process, where applicable) identification of the futex
+ * without keeping the page pinned for the duration of the FUTEX_WAIT.
  *
  * lock_page() might sleep, the caller should not hold a spinlock.
  */
@@ -659,8 +704,6 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, enum futex_a
 		key->private.mm = mm;
 		key->private.address = address;
 
-		get_futex_key_refs(key); /* implies smp_mb(); (B) */
-
 	} else {
 		struct inode *inode;
 
@@ -692,40 +735,14 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, enum futex_a
 			goto again;
 		}
 
-		/*
-		 * Take a reference unless it is about to be freed. Previously
-		 * this reference was taken by ihold under the page lock
-		 * pinning the inode in place so i_lock was unnecessary. The
-		 * only way for this check to fail is if the inode was
-		 * truncated in parallel which is almost certainly an
-		 * application bug. In such a case, just retry.
-		 *
-		 * We are not calling into get_futex_key_refs() in file-backed
-		 * cases, therefore a successful atomic_inc return below will
-		 * guarantee that get_futex_key() will still imply smp_mb(); (B).
-		 */
-		if (!atomic_inc_not_zero(&inode->i_count)) {
-			rcu_read_unlock();
-			put_page(page);
-
-			goto again;
-		}
-
-		/* Should be impossible but lets be paranoid for now */
-		if (WARN_ON_ONCE(inode->i_mapping != mapping)) {
-			err = -EFAULT;
-			rcu_read_unlock();
-			iput(inode);
-
-			goto out;
-		}
-
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode = inode;
+		key->shared.i_seq = get_inode_sequence_number(inode);
 		key->shared.pgoff = basepage_index(tail);
 		rcu_read_unlock();
 	}
 
+	get_futex_key_refs(key); /* implies smp_mb(); (B) */
+
 out:
 	put_page(page);
 	return err;
-- 
2.20.1

