Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E55A49A9CA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323522AbiAYD2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353993AbiAXVFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114FCC068099;
        Mon, 24 Jan 2022 12:05:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2758B8122A;
        Mon, 24 Jan 2022 20:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68B6C340E5;
        Mon, 24 Jan 2022 20:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054720;
        bh=rk21zKQ+j7Sr59F2dIE7knXhtPu1glCcJYXJODTUaGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYKkBWbDB6ykUwPIfScWgyK5lusvuVdKGcMs+T+lY3EPBbcJtHnejQ5I8xqRUMTmb
         BsKTx4pSLRgryGS3H5JHsCZpDhcJ+PtBMBqVwLn5qSMxoKElrbie6fd7d+b4qp5rzN
         Qj3ptbBr08GRDQKuX7C+Jq/EwgKCs93ox9twBBag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lukas Czerner <lczerner@redhat.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 481/563] ext4: destroy ext4_fc_dentry_cachep kmemcache on module removal
Date:   Mon, 24 Jan 2022 19:44:06 +0100
Message-Id: <20220124184041.094594379@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit ab047d516dea72f011c15c04a929851e4d053109 upstream.

The kmemcache for ext4_fc_dentry_cachep remains registered after module
removal.

Destroy ext4_fc_dentry_cachep kmemcache on module removal.

Fixes: aa75f4d3daaeb ("ext4: main fast-commit commit path")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20211110134640.lyku5vklvdndw6uk@linutronix.de
Link: https://lore.kernel.org/r/YbiK3JetFFl08bd7@linutronix.de
Link: https://lore.kernel.org/r/20211223164436.2628390-1-bigeasy@linutronix.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h        |    1 +
 fs/ext4/fast_commit.c |    5 +++++
 fs/ext4/super.c       |    2 ++
 3 files changed, 8 insertions(+)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2778,6 +2778,7 @@ bool ext4_fc_replay_check_excluded(struc
 void ext4_fc_replay_cleanup(struct super_block *sb);
 int ext4_fc_commit(journal_t *journal, tid_t commit_tid);
 int __init ext4_fc_init_dentry_cache(void);
+void ext4_fc_destroy_dentry_cache(void);
 
 /* mballoc.c */
 extern const struct seq_operations ext4_mb_seq_groups_ops;
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2169,3 +2169,8 @@ int __init ext4_fc_init_dentry_cache(voi
 
 	return 0;
 }
+
+void ext4_fc_destroy_dentry_cache(void)
+{
+	kmem_cache_destroy(ext4_fc_dentry_cachep);
+}
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6729,6 +6729,7 @@ static int __init ext4_init_fs(void)
 out:
 	unregister_as_ext2();
 	unregister_as_ext3();
+	ext4_fc_destroy_dentry_cache();
 out05:
 	destroy_inodecache();
 out1:
@@ -6755,6 +6756,7 @@ static void __exit ext4_exit_fs(void)
 	unregister_as_ext2();
 	unregister_as_ext3();
 	unregister_filesystem(&ext4_fs_type);
+	ext4_fc_destroy_dentry_cache();
 	destroy_inodecache();
 	ext4_exit_mballoc();
 	ext4_exit_sysfs();


