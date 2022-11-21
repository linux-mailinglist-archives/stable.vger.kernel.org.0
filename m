Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B68632241
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiKUMfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiKUMff (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:35:35 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631955F51
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:35:34 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id k5so10315300pjo.5
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I/YH2AbWgQODwGjtRCjquVfXM1+ODeIrNW5u2Zju0Nc=;
        b=npZNtxlc0z2+WTYQcNHmYOVmJe8kOX6TfJvIzCHtE3wdihZdykUgqjIAT2jAOvsgX1
         LcoiURcFFyOAACzmRFeXG/twbzgWxZIDkrmcrLcZhNDys1lzdgDfVUZpH2aT12w10zRQ
         1+1JfH15+mOR+IZJqh/o1zp3i2sYxOweCNoYSHwGJYCZC1EyKEToTociCsXaX6WTT16T
         f5Xygf5c13dWBOne9csddY6ZACBA6qDET9OkqU+iPh3By0QwbjsvDJQK5qNh38V/C5VX
         TjHei+4MNjwUheL3TgMPYKWm3yWT5dhzN5JUTnm0jH5w1jtxkZCK7+yRroGQDjRkz57O
         B7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I/YH2AbWgQODwGjtRCjquVfXM1+ODeIrNW5u2Zju0Nc=;
        b=QMmCYjlmelAOQbwOoVYMwI6wakqzxq1LLvyc7rxiuqzs+w99Cx0eTMjXHPLCUwMSIK
         C6XfZw4gMXQ1lCYZxnA9xb1/WAYct/l8En9s7KRE7Uvni/viYRQ1ATn/fDKt44k54vDR
         a9S9+Ibhp/trsG/AUlBRg3kRXaTHd/CT1+s1vGDCoVBBrzcuVapGQYmPX2M3MylRffRv
         aGgFh5ujGr/Y4jdvRHoBB+6cWOhqXp95NpEc8Wqq0z2ejM0CHXZN9EWjrurgpqddXZce
         Wxx/DrJUQasA3X68BfRqKRWM9MoRADFKU7d9THDa+LhQYYMm47G82bwSW1jVeUBKlvvo
         JYQw==
X-Gm-Message-State: ANoB5plvalWNDdhCg+B4+RdRhCw+F+xXpQ8a3rlCR48p7r3J06H3NiIW
        wwzUTgjLY2QC/PLGJ3MWHzuAZGXIsLM=
X-Google-Smtp-Source: AA0mqf5BhoMPI81KeY5KQJ6HoPgDNTaVhvBpGKbHJxW36sZkoSIFHUj2x3eLA4wNVnjI9fYbC3175A==
X-Received: by 2002:a17:90a:ad45:b0:20a:817e:8d16 with SMTP id w5-20020a17090aad4500b0020a817e8d16mr25576344pjv.187.1669034133500;
        Mon, 21 Nov 2022 04:35:33 -0800 (PST)
Received: from carrot.. (i220-108-44-211.s42.a014.ap.plala.or.jp. [220.108.44.211])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090aa41000b0020b7de675a4sm7619162pjp.41.2022.11.21.04.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 04:35:32 -0800 (PST)
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9] nilfs2: fix use-after-free bug of ns_writer on remount
Date:   Mon, 21 Nov 2022 21:35:28 +0900
Message-Id: <20221121123528.27639-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8cccf05fe857a18ee26e20d11a8455a73ffd4efd upstream.

If a nilfs2 filesystem is downgraded to read-only due to metadata
corruption on disk and is remounted read/write, or if emergency read-only
remount is performed, detaching a log writer and synchronizing the
filesystem can be done at the same time.

In these cases, use-after-free of the log writer (hereinafter
nilfs->ns_writer) can happen as shown in the scenario below:

 Task1                               Task2
 --------------------------------    ------------------------------
 nilfs_construct_segment
   nilfs_segctor_sync
     init_wait
     init_waitqueue_entry
     add_wait_queue
     schedule
                                     nilfs_remount (R/W remount case)
				       nilfs_attach_log_writer
                                         nilfs_detach_log_writer
                                           nilfs_segctor_destroy
                                             kfree
     finish_wait
       _raw_spin_lock_irqsave
         __raw_spin_lock_irqsave
           do_raw_spin_lock
             debug_spin_lock_before  <-- use-after-free

While Task1 is sleeping, nilfs->ns_writer is freed by Task2.  After Task1
waked up, Task1 accesses nilfs->ns_writer which is already freed.  This
scenario diagram is based on the Shigeru Yoshida's post [1].

This patch fixes the issue by not detaching nilfs->ns_writer on remount so
that this UAF race doesn't happen.  Along with this change, this patch
also inserts a few necessary read-only checks with superblock instance
where only the ns_writer pointer was used to check if the filesystem is
read-only.

Link: https://syzkaller.appspot.com/bug?id=79a4c002e960419ca173d55e863bd09e8112df8b
Link: https://lkml.kernel.org/r/20221103141759.1836312-1-syoshida@redhat.com [1]
Link: https://lkml.kernel.org/r/20221104142959.28296-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+f816fa82f8783f7a02bb@syzkaller.appspotmail.com
Reported-by: Shigeru Yoshida <syoshida@redhat.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
Please apply this patch to stable-4.9 instead of the patch that could
not be applied to it last time.

A rejected hunk has been manually resolved, and replaced sb_rdonly()
with its equivalent bitwise operation since the function does not yet
exist in this kernel.  Also, retested against that stable tree.

 fs/nilfs2/segment.c | 15 ++++++++-------
 fs/nilfs2/super.c   |  2 --
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 450bfdee513b..86769ecfe61f 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -329,7 +329,7 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (!sci || !sci->sc_flush_request)
+	if (sb->s_flags & MS_RDONLY || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2252,7 +2252,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct nilfs_transaction_info *ti;
 	int err;
 
-	if (!sci)
+	if (sb->s_flags & MS_RDONLY || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2291,7 +2291,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (!sci)
+	if (sb->s_flags & MS_RDONLY || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2788,11 +2788,12 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 
 	if (nilfs->ns_writer) {
 		/*
-		 * This happens if the filesystem was remounted
-		 * read/write after nilfs_error degenerated it into a
-		 * read-only mount.
+		 * This happens if the filesystem is made read-only by
+		 * __nilfs_error or nilfs_remount and then remounted
+		 * read/write.  In these cases, reuse the existing
+		 * writer.
 		 */
-		nilfs_detach_log_writer(sb);
+		return 0;
 	}
 
 	nilfs->ns_writer = nilfs_segctor_new(sb, root);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index c95d369e90aa..9e8f186b14d1 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1147,8 +1147,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		goto out;
 	if (*flags & MS_RDONLY) {
-		/* Shutting down log writer */
-		nilfs_detach_log_writer(sb);
 		sb->s_flags |= MS_RDONLY;
 
 		/*
-- 
2.31.1

