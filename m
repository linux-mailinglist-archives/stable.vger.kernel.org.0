Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AC91B7A91
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 17:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgDXPti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 11:49:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56250 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727843AbgDXPti (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 11:49:38 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS0a8-0001hP-NW; Fri, 24 Apr 2020 16:49:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS0a8-00FNGP-2R; Fri, 24 Apr 2020 16:49:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jann Horn" <jannh@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 24 Apr 2020 16:51:31 +0100
Message-ID: <lsq.1587743246.9036831@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 246/247] futex: Fix inode life-time issue
In-Reply-To: <lsq.1587743245.5555628@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc2 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 8019ad13ef7f64be44d4f892af9c840179009254 upstream.

As reported by Jann, ihold() does not in fact guarantee inode
persistence. And instead of making it so, replace the usage of inode
pointers with a per boot, machine wide, unique inode identifier.

This sequence number is global, but shared (file backed) futexes are
rare enough that this should not become a performance issue.

Reported-by: Jann Horn <jannh@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: Use atomic64_cmpxchg() instead of the
 _relaxed() variant which we don't have]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/inode.c            |  1 +
 include/linux/fs.h    |  1 +
 include/linux/futex.h | 17 +++++----
 kernel/futex.c        | 89 ++++++++++++++++++++++++++-----------------
 4 files changed, 65 insertions(+), 43 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -131,6 +131,7 @@ int inode_init_always(struct super_block
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
+	atomic64_set(&inode->i_sequence, 0);
 	atomic_set(&inode->i_count, 1);
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -570,6 +570,7 @@ struct inode {
 		struct rcu_head		i_rcu;
 	};
 	u64			i_version;
+	atomic64_t		i_sequence; /* see futex */
 	atomic_t		i_count;
 	atomic_t		i_dio_count;
 	atomic_t		i_writecount;
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -39,23 +39,26 @@ handle_futex_death(u32 __user *uaddr, st
 
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
 extern void exit_robust_list(struct task_struct *curr);
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -338,7 +338,7 @@ static void get_futex_key_refs(union fut
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		ihold(key->shared.inode); /* implies MB (B) */
+		smp_mb();		/* explicit smp_mb(); (B) */
 		break;
 	case FUT_OFF_MMSHARED:
 		futex_get_mm(key); /* implies MB (B) */
@@ -362,7 +362,6 @@ static void drop_futex_key_refs(union fu
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		iput(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
 		mmdrop(key->private.mm);
@@ -370,6 +369,46 @@ static void drop_futex_key_refs(union fu
 	}
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
+		old = atomic64_cmpxchg(&inode->i_sequence, 0, new);
+		if (old)
+			return old;
+		return new;
+	}
+}
+
 /**
  * get_futex_key() - Get parameters which are the keys for a futex
  * @uaddr:	virtual address of the futex
@@ -382,9 +421,15 @@ static void drop_futex_key_refs(union fu
  *
  * The key words are stored in *key on success.
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
@@ -545,8 +590,6 @@ again:
 		key->private.mm = mm;
 		key->private.address = address;
 
-		get_futex_key_refs(key); /* implies smp_mb(); (B) */
-
 	} else {
 		struct inode *inode;
 
@@ -578,40 +621,14 @@ again:
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
-			put_page(page_head);
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
 		key->shared.pgoff = basepage_index(page);
 		rcu_read_unlock();
 	}
 
+	get_futex_key_refs(key); /* implies smp_mb(); (B) */
+
 out:
 	put_page(page_head);
 	return err;

