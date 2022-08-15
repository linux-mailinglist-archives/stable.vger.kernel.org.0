Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB00594643
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346433AbiHOWCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348511AbiHOWBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:01:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42E26DADF;
        Mon, 15 Aug 2022 12:35:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D45C3B81136;
        Mon, 15 Aug 2022 19:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA35C433D6;
        Mon, 15 Aug 2022 19:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592122;
        bh=Fm4OrmpyXmEg2khjH7fOWPAv6wsvk3GvL1nY1SfhlpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2SZdownYZKAI7K3ddTeK7mIKRENMBp18r/AOZ1M7IQkV01wPuk/oaooHdNUJj1SE1
         TgxGsYB+10tICLEyJAPkNUOh2I76gzZrh86x98FjM/1PwalGA0DomFhu0qLoaJt2TE
         WKzYwpTC9lz4dQ+uBiavXpG7tywI9Eb2cNB6TorI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Carlos Llamas <cmllamas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0737/1095] binder: fix redefinition of seq_file attributes
Date:   Mon, 15 Aug 2022 20:02:16 +0200
Message-Id: <20220815180459.870190745@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit b7e241bbff24f9e106bf616408fd58bcedc44bae ]

The patchset in [1] exported some definitions to binder_internal.h in
order to make the debugfs entries such as 'stats' and 'transaction_log'
available in a binderfs instance. However, the DEFINE_SHOW_ATTRIBUTE
macro expands into a static function/variable pair, which in turn get
redefined each time a source file includes this internal header.

This problem was made evident after a report from the kernel test robot
<lkp@intel.com> where several W=1 build warnings are seen in downstream
kernels. See the following example:

  include/../drivers/android/binder_internal.h:111:23: warning: 'binder_stats_fops' defined but not used [-Wunused-const-variable=]
     111 | DEFINE_SHOW_ATTRIBUTE(binder_stats);
         |                       ^~~~~~~~~~~~
  include/linux/seq_file.h:174:37: note: in definition of macro 'DEFINE_SHOW_ATTRIBUTE'
     174 | static const struct file_operations __name ## _fops = {                 \
         |                                     ^~~~~~

This patch fixes the above issues by moving back the definitions into
binder.c and instead creates an array of the debugfs entries which is
more convenient to share with binderfs and iterate through.

  [1] https://lore.kernel.org/all/20190903161655.107408-1-hridya@google.com/

Fixes: 0e13e452dafc ("binder: Add stats, state and transactions files")
Fixes: 03e2e07e3814 ("binder: Make transaction_log available in binderfs")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20220701182041.2134313-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binder.c          | 114 +++++++++++++++++++++---------
 drivers/android/binder_internal.h |  46 +++---------
 drivers/android/binderfs.c        |  47 +++---------
 3 files changed, 100 insertions(+), 107 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index f3b639e89dd8..5243fe0eb402 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -170,8 +170,32 @@ static inline void binder_stats_created(enum binder_stat_types type)
 	atomic_inc(&binder_stats.obj_created[type]);
 }
 
-struct binder_transaction_log binder_transaction_log;
-struct binder_transaction_log binder_transaction_log_failed;
+struct binder_transaction_log_entry {
+	int debug_id;
+	int debug_id_done;
+	int call_type;
+	int from_proc;
+	int from_thread;
+	int target_handle;
+	int to_proc;
+	int to_thread;
+	int to_node;
+	int data_size;
+	int offsets_size;
+	int return_error_line;
+	uint32_t return_error;
+	uint32_t return_error_param;
+	char context_name[BINDERFS_MAX_NAME + 1];
+};
+
+struct binder_transaction_log {
+	atomic_t cur;
+	bool full;
+	struct binder_transaction_log_entry entry[32];
+};
+
+static struct binder_transaction_log binder_transaction_log;
+static struct binder_transaction_log binder_transaction_log_failed;
 
 static struct binder_transaction_log_entry *binder_transaction_log_add(
 	struct binder_transaction_log *log)
@@ -6084,8 +6108,7 @@ static void print_binder_proc_stats(struct seq_file *m,
 	print_binder_stats(m, "  ", &proc->stats);
 }
 
-
-int binder_state_show(struct seq_file *m, void *unused)
+static int state_show(struct seq_file *m, void *unused)
 {
 	struct binder_proc *proc;
 	struct binder_node *node;
@@ -6124,7 +6147,7 @@ int binder_state_show(struct seq_file *m, void *unused)
 	return 0;
 }
 
-int binder_stats_show(struct seq_file *m, void *unused)
+static int stats_show(struct seq_file *m, void *unused)
 {
 	struct binder_proc *proc;
 
@@ -6140,7 +6163,7 @@ int binder_stats_show(struct seq_file *m, void *unused)
 	return 0;
 }
 
-int binder_transactions_show(struct seq_file *m, void *unused)
+static int transactions_show(struct seq_file *m, void *unused)
 {
 	struct binder_proc *proc;
 
@@ -6196,7 +6219,7 @@ static void print_binder_transaction_log_entry(struct seq_file *m,
 			"\n" : " (incomplete)\n");
 }
 
-int binder_transaction_log_show(struct seq_file *m, void *unused)
+static int transaction_log_show(struct seq_file *m, void *unused)
 {
 	struct binder_transaction_log *log = m->private;
 	unsigned int log_cur = atomic_read(&log->cur);
@@ -6228,6 +6251,45 @@ const struct file_operations binder_fops = {
 	.release = binder_release,
 };
 
+DEFINE_SHOW_ATTRIBUTE(state);
+DEFINE_SHOW_ATTRIBUTE(stats);
+DEFINE_SHOW_ATTRIBUTE(transactions);
+DEFINE_SHOW_ATTRIBUTE(transaction_log);
+
+const struct binder_debugfs_entry binder_debugfs_entries[] = {
+	{
+		.name = "state",
+		.mode = 0444,
+		.fops = &state_fops,
+		.data = NULL,
+	},
+	{
+		.name = "stats",
+		.mode = 0444,
+		.fops = &stats_fops,
+		.data = NULL,
+	},
+	{
+		.name = "transactions",
+		.mode = 0444,
+		.fops = &transactions_fops,
+		.data = NULL,
+	},
+	{
+		.name = "transaction_log",
+		.mode = 0444,
+		.fops = &transaction_log_fops,
+		.data = &binder_transaction_log,
+	},
+	{
+		.name = "failed_transaction_log",
+		.mode = 0444,
+		.fops = &transaction_log_fops,
+		.data = &binder_transaction_log_failed,
+	},
+	{} /* terminator */
+};
+
 static int __init init_binder_device(const char *name)
 {
 	int ret;
@@ -6273,36 +6335,18 @@ static int __init binder_init(void)
 	atomic_set(&binder_transaction_log_failed.cur, ~0U);
 
 	binder_debugfs_dir_entry_root = debugfs_create_dir("binder", NULL);
-	if (binder_debugfs_dir_entry_root)
+	if (binder_debugfs_dir_entry_root) {
+		const struct binder_debugfs_entry *db_entry;
+
+		binder_for_each_debugfs_entry(db_entry)
+			debugfs_create_file(db_entry->name,
+					    db_entry->mode,
+					    binder_debugfs_dir_entry_root,
+					    db_entry->data,
+					    db_entry->fops);
+
 		binder_debugfs_dir_entry_proc = debugfs_create_dir("proc",
 						 binder_debugfs_dir_entry_root);
-
-	if (binder_debugfs_dir_entry_root) {
-		debugfs_create_file("state",
-				    0444,
-				    binder_debugfs_dir_entry_root,
-				    NULL,
-				    &binder_state_fops);
-		debugfs_create_file("stats",
-				    0444,
-				    binder_debugfs_dir_entry_root,
-				    NULL,
-				    &binder_stats_fops);
-		debugfs_create_file("transactions",
-				    0444,
-				    binder_debugfs_dir_entry_root,
-				    NULL,
-				    &binder_transactions_fops);
-		debugfs_create_file("transaction_log",
-				    0444,
-				    binder_debugfs_dir_entry_root,
-				    &binder_transaction_log,
-				    &binder_transaction_log_fops);
-		debugfs_create_file("failed_transaction_log",
-				    0444,
-				    binder_debugfs_dir_entry_root,
-				    &binder_transaction_log_failed,
-				    &binder_transaction_log_fops);
 	}
 
 	if (!IS_ENABLED(CONFIG_ANDROID_BINDERFS) &&
diff --git a/drivers/android/binder_internal.h b/drivers/android/binder_internal.h
index d6b6b8cb7346..1ade9799c8d5 100644
--- a/drivers/android/binder_internal.h
+++ b/drivers/android/binder_internal.h
@@ -107,41 +107,19 @@ static inline int __init init_binderfs(void)
 }
 #endif
 
-int binder_stats_show(struct seq_file *m, void *unused);
-DEFINE_SHOW_ATTRIBUTE(binder_stats);
-
-int binder_state_show(struct seq_file *m, void *unused);
-DEFINE_SHOW_ATTRIBUTE(binder_state);
-
-int binder_transactions_show(struct seq_file *m, void *unused);
-DEFINE_SHOW_ATTRIBUTE(binder_transactions);
-
-int binder_transaction_log_show(struct seq_file *m, void *unused);
-DEFINE_SHOW_ATTRIBUTE(binder_transaction_log);
-
-struct binder_transaction_log_entry {
-	int debug_id;
-	int debug_id_done;
-	int call_type;
-	int from_proc;
-	int from_thread;
-	int target_handle;
-	int to_proc;
-	int to_thread;
-	int to_node;
-	int data_size;
-	int offsets_size;
-	int return_error_line;
-	uint32_t return_error;
-	uint32_t return_error_param;
-	char context_name[BINDERFS_MAX_NAME + 1];
+struct binder_debugfs_entry {
+	const char *name;
+	umode_t mode;
+	const struct file_operations *fops;
+	void *data;
 };
 
-struct binder_transaction_log {
-	atomic_t cur;
-	bool full;
-	struct binder_transaction_log_entry entry[32];
-};
+extern const struct binder_debugfs_entry binder_debugfs_entries[];
+
+#define binder_for_each_debugfs_entry(entry)	\
+	for ((entry) = binder_debugfs_entries;	\
+	     (entry)->name;			\
+	     (entry)++)
 
 enum binder_stat_types {
 	BINDER_STAT_PROC,
@@ -575,6 +553,4 @@ struct binder_object {
 	};
 };
 
-extern struct binder_transaction_log binder_transaction_log;
-extern struct binder_transaction_log binder_transaction_log_failed;
 #endif /* _LINUX_BINDER_INTERNAL_H */
diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index e3605cdd4335..6d717ed76766 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -621,6 +621,7 @@ static int init_binder_features(struct super_block *sb)
 static int init_binder_logs(struct super_block *sb)
 {
 	struct dentry *binder_logs_root_dir, *dentry, *proc_log_dir;
+	const struct binder_debugfs_entry *db_entry;
 	struct binderfs_info *info;
 	int ret = 0;
 
@@ -631,43 +632,15 @@ static int init_binder_logs(struct super_block *sb)
 		goto out;
 	}
 
-	dentry = binderfs_create_file(binder_logs_root_dir, "stats",
-				      &binder_stats_fops, NULL);
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
-		goto out;
-	}
-
-	dentry = binderfs_create_file(binder_logs_root_dir, "state",
-				      &binder_state_fops, NULL);
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
-		goto out;
-	}
-
-	dentry = binderfs_create_file(binder_logs_root_dir, "transactions",
-				      &binder_transactions_fops, NULL);
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
-		goto out;
-	}
-
-	dentry = binderfs_create_file(binder_logs_root_dir,
-				      "transaction_log",
-				      &binder_transaction_log_fops,
-				      &binder_transaction_log);
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
-		goto out;
-	}
-
-	dentry = binderfs_create_file(binder_logs_root_dir,
-				      "failed_transaction_log",
-				      &binder_transaction_log_fops,
-				      &binder_transaction_log_failed);
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
-		goto out;
+	binder_for_each_debugfs_entry(db_entry) {
+		dentry = binderfs_create_file(binder_logs_root_dir,
+					      db_entry->name,
+					      db_entry->fops,
+					      db_entry->data);
+		if (IS_ERR(dentry)) {
+			ret = PTR_ERR(dentry);
+			goto out;
+		}
 	}
 
 	proc_log_dir = binderfs_create_dir(binder_logs_root_dir, "proc");
-- 
2.35.1



