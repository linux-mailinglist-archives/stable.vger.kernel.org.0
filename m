Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948584D45BB
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 12:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239022AbiCJLf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 06:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbiCJLfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 06:35:55 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AAEF8BBD;
        Thu, 10 Mar 2022 03:34:54 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6FE91210E1;
        Thu, 10 Mar 2022 11:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646912093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=0Y/1Q1mX64VtaKQye+7h0nQluUSQQsodXT6hY01tbp0=;
        b=u4tEFI3N9p6aNl6fYL3Rx5p/mFPGklAMmVTl/yW8ONYheqY2BMv80Pk9JxWGKP3imybAAJ
        9Vj7KfkF47wFzPgmKSAaDK39q4EW+zJqqEfUFRC57kroeTRB328KlAfmEVi1p+OtEvwi9l
        xjsivhO9e1+7xIwslmi0fBDQzmciUqg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 88DD413FA3;
        Thu, 10 Mar 2022 11:34:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qjlbFFziKWKbEAAAMHmgww
        (envelope-from <wqu@suse.com>); Thu, 10 Mar 2022 11:34:52 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: don't trigger autodefrag if cleaner is woken up early
Date:   Thu, 10 Mar 2022 19:34:35 +0800
Message-Id: <d1ce90f37777987732b8ccf0edbfc961cd5c8873.1646912061.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[PROBLEM]
Patch "btrfs: don't let new writes to trigger autodefrag on the same
inode" now makes autodefrag really only to scan one inode once
per autodefrag run.

That patch works mostly fine, as the trace events show their intervals
are almost 30s:
(only showing the root 257 ino 329891 start 0)

 486.810041: defrag_file_start: root=257 ino=329891 start=0 len=754728960
 506.407089: defrag_file_start: root=257 ino=329891 start=0 len=754728960
 536.463320: defrag_file_start: root=257 ino=329891 start=0 len=754728960
 539.721309: defrag_file_start: root=257 ino=329891 start=0 len=754728960
 569.741417: defrag_file_start: root=257 ino=329891 start=0 len=754728960
 594.832649: defrag_file_start: root=257 ino=329891 start=0 len=754728960
 624.258214: defrag_file_start: root=257 ino=329891 start=0 len=754728960
 654.856264: defrag_file_start: root=257 ino=329891 start=0 len=754728960
 684.943029: defrag_file_start: root=257 ino=329891 start=0 len=754728960
 715.288662: defrag_file_start: root=257 ino=329891 start=0 len=754728960

But there are some outlawers, like 536s->539s, it's only 3s, not the 30s
default commit interval.

[CAUSE]
There are several call sites which can wake up transaction kthread
early, while transaction kthread itself can skip transaction if its
timer doesn't reach commit interval, but cleaner is always woken up.

This means each time transaction ktreahd gets woken up, we also trigger
autodefrag, even transaction kthread chooses to skip its work.

This is not a good behavior for files under heavy write load, as we
waste extra IO/CPU while the defragged extents can easily get fragmented
again.

[FIX]
In btrfs_run_defrag_inodes(), we check if our current time is larger
than last run + commit_interval.

If not, skip this run and wait for next opportunity.

This patch along with patch "btrfs: don't let new writes to trigger
autodefrag on the same inode" are mostly for backport to v5.16.

This is just to reduce the unnecessary IO/CPU caused by autodefrag, the
final solution would be allowing users to change autodefrag scan
interval and target extent size.

Cc: stable@vger.kernel.org # 5.16+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/file.c  | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a8a3de10cead..44116a47307e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -899,6 +899,7 @@ struct btrfs_fs_info {
 
 	/* auto defrag inodes go here */
 	spinlock_t defrag_inodes_lock;
+	u64 defrag_last_run_ksec;
 	struct rb_root defrag_inodes;
 	atomic_t defrag_running;
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index abba1871e86e..a852754f5601 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -312,9 +312,20 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 {
 	struct inode_defrag *defrag;
 	struct rb_root defrag_inodes;
+	u64 ksec = ktime_get_seconds();
 	u64 first_ino = 0;
 	u64 root_objectid = 0;
 
+	/*
+	 * If cleaner get woken up early, skip this run to avoid frequent
+	 * re-dirty, which is not really useful for heavy writes.
+	 *
+	 * TODO: Make autodefrag to happen in its own thread.
+	 */
+	if (ksec - fs_info->defrag_last_run_ksec < fs_info->commit_interval)
+		return 0;
+	fs_info->defrag_last_run_ksec = ksec;
+
 	atomic_inc(&fs_info->defrag_running);
 	spin_lock(&fs_info->defrag_inodes_lock);
 	/*
-- 
2.35.1

