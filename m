Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221D3541C2A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376996AbiFGV4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384131AbiFGVyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C8BBDA2C;
        Tue,  7 Jun 2022 12:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD149618F2;
        Tue,  7 Jun 2022 19:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98170C385A2;
        Tue,  7 Jun 2022 19:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629183;
        bh=rcb2EbCweuz3IIvcMuAiaNyBslN563Cuvdbu7vol/Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8m204655JuNFxYiHD2GkvwVJ/cWacxIECAudro+NWsnpeqNPMNMXAyKjGpqmEn00
         1h/JylIfQw6fUmbx1BnWNpvyDLYBd7g1d6FgasVdGMwwVFDN4jfHZ9EuWJzr3KeVbZ
         hl9o8EsO0EOIabH35ry7Ib24pvN1FYlhEA8ddkYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heming Zhao <heming.zhao@suse.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 600/879] ocfs2: fix mounting crash if journal is not alloced
Date:   Tue,  7 Jun 2022 19:01:58 +0200
Message-Id: <20220607165020.268176053@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>

[ Upstream commit bb20b31dee1a6c329c2f721fbe21c51945cdfc29 ]

Patch series "rewrite error handling during mounting stage".

This patch (of 5):

After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
journal init later than before, it makes NULL pointer access in free
routine.

Crash flow:

ocfs2_fill_super
 + ocfs2_mount_volume
 |  + ocfs2_dlm_init //fail & return, osb->journal is NULL.
 |  + ...
 |  + ocfs2_check_volume //no chance to init osb->journal
 |
 + ...
 + ocfs2_dismount_volume
    ocfs2_release_system_inodes
      ...
       evict
        ...
         ocfs2_clear_inode
          ocfs2_checkpoint_inode
           ocfs2_ci_fully_checkpointed
            time_after(journal->j_trans_id, ci->ci_last_trans)
             + journal is empty, crash!

For fixing, there are three solutions:

1> Partly revert commit da5e7c87827e8

   For avoiding kernel crash, this make sense for us.  We only
   concerned whether there has any non-system inode access before dlm
   init.  The answer is NO.  And all journal replay/recovery handling
   happen after dlm & journal init done.  So this method is not graceful
   but workable.

2> Add osb->journal check in free inode routine (eg ocfs2_clear_inode)

   The fix code is special for mounting phase, but it will continue
   working after mounting stage.  In another word, this method adds
   useless code in normal inode free flow.

3> Do directly free inode in mounting phase

   This method is brutal/complex and may introduce unsafe code,
   currently maintainer didn't like.

At last, we chose method <1> and did partly reverted job.  We reverted
journal init codes, and kept cleanup codes flow.

Link: https://lkml.kernel.org/r/20220424130952.2436-1-heming.zhao@suse.com
Link: https://lkml.kernel.org/r/20220424130952.2436-2-heming.zhao@suse.com
Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c   |  4 ++--
 fs/ocfs2/journal.c | 33 +++++++++++++++++++++++----------
 fs/ocfs2/journal.h |  2 ++
 fs/ocfs2/super.c   | 15 +++++++++++++++
 4 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 5739dc301569..bb116c39b581 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -125,6 +125,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
+	journal_t *journal = osb->journal->j_journal;
 
 	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
 			       sysfile_type);
@@ -171,11 +172,10 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	 * part of the transaction - the inode could have been reclaimed and
 	 * now it is reread from disk.
 	 */
-	if (osb->journal) {
+	if (journal) {
 		transaction_t *transaction;
 		tid_t tid;
 		struct ocfs2_inode_info *oi = OCFS2_I(inode);
-		journal_t *journal = osb->journal->j_journal;
 
 		read_lock(&journal->j_state_lock);
 		if (journal->j_running_transaction)
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 1887a2708709..fa87d89cf754 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -810,22 +810,20 @@ void ocfs2_set_journal_params(struct ocfs2_super *osb)
 	write_unlock(&journal->j_state_lock);
 }
 
-int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
+/*
+ * alloc & initialize skeleton for journal structure.
+ * ocfs2_journal_init() will make fs have journal ability.
+ */
+int ocfs2_journal_alloc(struct ocfs2_super *osb)
 {
-	int status = -1;
-	struct inode *inode = NULL; /* the journal inode */
-	journal_t *j_journal = NULL;
-	struct ocfs2_journal *journal = NULL;
-	struct ocfs2_dinode *di = NULL;
-	struct buffer_head *bh = NULL;
-	int inode_lock = 0;
+	int status = 0;
+	struct ocfs2_journal *journal;
 
-	/* initialize our journal structure */
 	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
 	if (!journal) {
 		mlog(ML_ERROR, "unable to alloc journal\n");
 		status = -ENOMEM;
-		goto done;
+		goto bail;
 	}
 	osb->journal = journal;
 	journal->j_osb = osb;
@@ -839,6 +837,21 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
+bail:
+	return status;
+}
+
+int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
+{
+	int status = -1;
+	struct inode *inode = NULL; /* the journal inode */
+	journal_t *j_journal = NULL;
+	struct ocfs2_journal *journal = osb->journal;
+	struct ocfs2_dinode *di = NULL;
+	struct buffer_head *bh = NULL;
+	int inode_lock = 0;
+
+	BUG_ON(!journal);
 	/* already have the inode for our journal */
 	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
 					    osb->slot_num);
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 8dcb2f2cadbc..969d0aa28718 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -154,6 +154,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
  *
+ *  ocfs2_journal_alloc    - Initialize skeleton for journal structure.
  *  ocfs2_journal_init     - Initialize journal structures in the OSB.
  *  ocfs2_journal_load     - Load the given journal off disk. Replay it if
  *                          there's transactions still in there.
@@ -167,6 +168,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
  *  ocfs2_start_checkpoint - Kick the commit thread to do a checkpoint.
  */
 void   ocfs2_set_journal_params(struct ocfs2_super *osb);
+int    ocfs2_journal_alloc(struct ocfs2_super *osb);
 int    ocfs2_journal_init(struct ocfs2_super *osb, int *dirty);
 void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
 int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 477cdf94122e..311433c69a3f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2195,6 +2195,15 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	get_random_bytes(&osb->s_next_generation, sizeof(u32));
 
+	/*
+	 * FIXME
+	 * This should be done in ocfs2_journal_init(), but any inode
+	 * writes back operation will cause the filesystem to crash.
+	 */
+	status = ocfs2_journal_alloc(osb);
+	if (status < 0)
+		goto bail;
+
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
 
@@ -2483,6 +2492,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 
 	kfree(osb->osb_orphan_wipes);
 	kfree(osb->slot_recovery_generations);
+	/* FIXME
+	 * This belongs in journal shutdown, but because we have to
+	 * allocate osb->journal at the middle of ocfs2_initialize_super(),
+	 * we free it here.
+	 */
+	kfree(osb->journal);
 	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	kfree(osb->vol_label);
-- 
2.35.1



