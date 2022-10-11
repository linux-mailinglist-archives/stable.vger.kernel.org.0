Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A41E5FB5C8
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiJKO5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiJKO4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:56:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CE99DDA6;
        Tue, 11 Oct 2022 07:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2C7EB8124B;
        Tue, 11 Oct 2022 14:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1378C433C1;
        Tue, 11 Oct 2022 14:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499928;
        bh=1fpohBoFCSYjW4aMN3buF/BPmY5gY/NlefzrIDT83+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvkVcTEQDgQKka8cp+oUWgfDxh7+/qCP+OdxLwL4zDbnV66p7DC6FetkVyr6vBeNJ
         +dJaO5Fhh0yHXbQAw5J/0t/taLyrv1MXsP2rx8G0svKsp04QPgziFvL1yjDIXDK/yX
         IgvWaptz+dGbSJNVEhlxcNCnDLhCO6HDpDrq7PFgXga0NgtjUoszzm1kil4TqxK4b4
         wHxBq5HLNwDTeO22gZWOeEAybhz62kNKz92j1aA3EvknuRDxlCzVTmzMJ35cT5W59j
         5KghfVXOLnn4kRXB5ZJydIbjQCir6ND1jRs2Mp/H/I/DmGOPHaRoHIEVO4+QmriqGZ
         T/nVEoq0j3OyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioannis Angelakopoulos <iangelak@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 24/40] btrfs: add macros for annotating wait events with lockdep
Date:   Tue, 11 Oct 2022 10:51:13 -0400
Message-Id: <20221011145129.1623487-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioannis Angelakopoulos <iangelak@fb.com>

[ Upstream commit ab9a323f9ab576000795285dd7ac6afeedf29e32 ]

Introduce four macros that are used to annotate wait events in btrfs code
with lockdep;

  1) the btrfs_lockdep_init_map
  2) the btrfs_lockdep_acquire,
  3) the btrfs_lockdep_release
  4) the btrfs_might_wait_for_event macros.

The btrfs_lockdep_init_map macro is used to initialize a lockdep map.

The btrfs_lockdep_<acquire,release> macros are used by threads to take
the lockdep map as readers (shared lock) and release it, respectively.

The btrfs_might_wait_for_event macro is used by threads to take the
lockdep map as writers (exclusive lock) and release it.

In general, the lockdep annotation for wait events work as follows:

The condition for a wait event can be modified and signaled at the same
time by multiple threads. These threads hold the lockdep map as readers
when they enter a context in which blocking would prevent signaling the
condition. Frequently, this occurs when a thread violates a condition
(lockdep map acquire), before restoring it and signaling it at a later
point (lockdep map release).

The threads that block on the wait event take the lockdep map as writers
(exclusive lock). These threads have to block until all the threads that
hold the lockdep map as readers signal the condition for the wait event
and release the lockdep map.

The lockdep annotation is used to warn about potential deadlock scenarios
that involve the threads that modify and signal the wait event condition
and threads that block on the wait event. A simple example is illustrated
below:

Without lockdep:

TA                                        TB
cond = false
                                          lock(A)
                                          wait_event(w, cond)
                                          unlock(A)
lock(A)
cond = true
signal(w)
unlock(A)

With lockdep:

TA                                        TB
rwsem_acquire_read(lockdep_map)
cond = false
                                          lock(A)
                                          rwsem_acquire(lockdep_map)
                                          rwsem_release(lockdep_map)
                                          wait_event(w, cond)
                                          unlock(A)
lock(A)
cond = true
signal(w)
unlock(A)
rwsem_release(lockdep_map)

In the second case, with the lockdep annotation, lockdep would warn about
an ABBA deadlock, while the first case would just deadlock at some point.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1bbc810574f2..8d35db5b2b62 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1148,6 +1148,51 @@ enum {
 	BTRFS_ROOT_RESET_LOCKDEP_CLASS,
 };
 
+/*
+ * Lockdep annotation for wait events.
+ *
+ * @owner:  The struct where the lockdep map is defined
+ * @lock:   The lockdep map corresponding to a wait event
+ *
+ * This macro is used to annotate a wait event. In this case a thread acquires
+ * the lockdep map as writer (exclusive lock) because it has to block until all
+ * the threads that hold the lock as readers signal the condition for the wait
+ * event and release their locks.
+ */
+#define btrfs_might_wait_for_event(owner, lock)					\
+	do {									\
+		rwsem_acquire(&owner->lock##_map, 0, 0, _THIS_IP_);		\
+		rwsem_release(&owner->lock##_map, _THIS_IP_);			\
+	} while (0)
+
+/*
+ * Protection for the resource/condition of a wait event.
+ *
+ * @owner:  The struct where the lockdep map is defined
+ * @lock:   The lockdep map corresponding to a wait event
+ *
+ * Many threads can modify the condition for the wait event at the same time
+ * and signal the threads that block on the wait event. The threads that modify
+ * the condition and do the signaling acquire the lock as readers (shared
+ * lock).
+ */
+#define btrfs_lockdep_acquire(owner, lock)					\
+	rwsem_acquire_read(&owner->lock##_map, 0, 0, _THIS_IP_)
+
+/*
+ * Used after signaling the condition for a wait event to release the lockdep
+ * map held by a reader thread.
+ */
+#define btrfs_lockdep_release(owner, lock)					\
+	rwsem_release(&owner->lock##_map, _THIS_IP_)
+
+/* Initialization of the lockdep map */
+#define btrfs_lockdep_init_map(owner, lock)					\
+	do {									\
+		static struct lock_class_key lock##_key;			\
+		lockdep_init_map(&owner->lock##_map, #lock, &lock##_key, 0);	\
+	} while (0)
+
 static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
 {
 	clear_and_wake_up_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
-- 
2.35.1

