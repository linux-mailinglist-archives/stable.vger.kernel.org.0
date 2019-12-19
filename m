Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2B5126BAC
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfLSSzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730310AbfLSSzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 279CA206EC;
        Thu, 19 Dec 2019 18:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781723;
        bh=CpXIL1R4lHqNtvthudV/rtjAZQJEG73Fl+AcFWBSIR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONlKmThufYwIePpC6+n1EaZko/5rdHbd72ECGBRvX2fvz5ZukxOVso3EkylHqmTO4
         sQTjZCTFLJrOeAnbgAWRhE5LTrhnEm9DvSYoP2aNrCfUPk2yxpYd8baucSISHEYI7N
         +a6S8mvq8Yt58nAIVsp8AyxoSmH+T93CRxvrrIcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 54/80] dm clone metadata: Use a two phase commit
Date:   Thu, 19 Dec 2019 19:34:46 +0100
Message-Id: <20191219183127.945374000@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 8fdbfe8d1690e8a38d497d83a30607d0d90cc15a upstream.

Split the metadata commit in two parts:

1. dm_clone_metadata_pre_commit(): Prepare the current transaction for
   committing. After this is called, all subsequent metadata updates,
   done through either dm_clone_set_region_hydrated() or
   dm_clone_cond_set_range(), will be part of the next transaction.

2. dm_clone_metadata_commit(): Actually commit the current transaction
   to disk and start a new transaction.

This is required by the following commit. It allows dm-clone to flush
the destination device after step (1) to ensure that all freshly
hydrated regions, for which we are updating the metadata, are properly
written to non-volatile storage and won't be lost in case of a crash.

Fixes: 7431b7835f55 ("dm: add clone target")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-clone-metadata.c |   46 ++++++++++++++++++++++++++++++++---------
 drivers/md/dm-clone-metadata.h |   17 +++++++++++++++
 drivers/md/dm-clone-target.c   |    7 +++++-
 3 files changed, 60 insertions(+), 10 deletions(-)

--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -127,6 +127,9 @@ struct dm_clone_metadata {
 	struct dirty_map dmap[2];
 	struct dirty_map *current_dmap;
 
+	/* Protected by lock */
+	struct dirty_map *committing_dmap;
+
 	/*
 	 * In core copy of the on-disk bitmap to save constantly doing look ups
 	 * on disk.
@@ -511,6 +514,7 @@ static int dirty_map_init(struct dm_clon
 	}
 
 	cmd->current_dmap = &cmd->dmap[0];
+	cmd->committing_dmap = NULL;
 
 	return 0;
 }
@@ -775,16 +779,18 @@ static int __flush_dmap(struct dm_clone_
 	return 0;
 }
 
-int dm_clone_metadata_commit(struct dm_clone_metadata *cmd)
+int dm_clone_metadata_pre_commit(struct dm_clone_metadata *cmd)
 {
-	int r = -EPERM;
+	int r = 0;
 	unsigned long flags;
 	struct dirty_map *dmap, *next_dmap;
 
 	down_write(&cmd->lock);
 
-	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm))
+	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) {
+		r = -EPERM;
 		goto out;
+	}
 
 	/* Get current dirty bitmap */
 	dmap = cmd->current_dmap;
@@ -796,7 +802,7 @@ int dm_clone_metadata_commit(struct dm_c
 	 * The last commit failed, so we don't have a clean dirty-bitmap to
 	 * use.
 	 */
-	if (WARN_ON(next_dmap->changed)) {
+	if (WARN_ON(next_dmap->changed || cmd->committing_dmap)) {
 		r = -EINVAL;
 		goto out;
 	}
@@ -806,11 +812,33 @@ int dm_clone_metadata_commit(struct dm_c
 	cmd->current_dmap = next_dmap;
 	spin_unlock_irqrestore(&cmd->bitmap_lock, flags);
 
-	/*
-	 * No one is accessing the old dirty bitmap anymore, so we can flush
-	 * it.
-	 */
-	r = __flush_dmap(cmd, dmap);
+	/* Set old dirty bitmap as currently committing */
+	cmd->committing_dmap = dmap;
+out:
+	up_write(&cmd->lock);
+
+	return r;
+}
+
+int dm_clone_metadata_commit(struct dm_clone_metadata *cmd)
+{
+	int r = -EPERM;
+
+	down_write(&cmd->lock);
+
+	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm))
+		goto out;
+
+	if (WARN_ON(!cmd->committing_dmap)) {
+		r = -EINVAL;
+		goto out;
+	}
+
+	r = __flush_dmap(cmd, cmd->committing_dmap);
+	if (!r) {
+		/* Clear committing dmap */
+		cmd->committing_dmap = NULL;
+	}
 out:
 	up_write(&cmd->lock);
 
--- a/drivers/md/dm-clone-metadata.h
+++ b/drivers/md/dm-clone-metadata.h
@@ -73,7 +73,23 @@ void dm_clone_metadata_close(struct dm_c
 
 /*
  * Commit dm-clone metadata to disk.
+ *
+ * We use a two phase commit:
+ *
+ * 1. dm_clone_metadata_pre_commit(): Prepare the current transaction for
+ *    committing. After this is called, all subsequent metadata updates, done
+ *    through either dm_clone_set_region_hydrated() or
+ *    dm_clone_cond_set_range(), will be part of the **next** transaction.
+ *
+ * 2. dm_clone_metadata_commit(): Actually commit the current transaction to
+ *    disk and start a new transaction.
+ *
+ * This allows dm-clone to flush the destination device after step (1) to
+ * ensure that all freshly hydrated regions, for which we are updating the
+ * metadata, are properly written to non-volatile storage and won't be lost in
+ * case of a crash.
  */
+int dm_clone_metadata_pre_commit(struct dm_clone_metadata *cmd);
 int dm_clone_metadata_commit(struct dm_clone_metadata *cmd);
 
 /*
@@ -110,6 +126,7 @@ int dm_clone_metadata_abort(struct dm_cl
  * Switches metadata to a read only mode. Once read-only mode has been entered
  * the following functions will return -EPERM:
  *
+ *   dm_clone_metadata_pre_commit()
  *   dm_clone_metadata_commit()
  *   dm_clone_set_region_hydrated()
  *   dm_clone_cond_set_range()
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1120,8 +1120,13 @@ static int commit_metadata(struct clone
 		goto out;
 	}
 
-	r = dm_clone_metadata_commit(clone->cmd);
+	r = dm_clone_metadata_pre_commit(clone->cmd);
+	if (unlikely(r)) {
+		__metadata_operation_failed(clone, "dm_clone_metadata_pre_commit", r);
+		goto out;
+	}
 
+	r = dm_clone_metadata_commit(clone->cmd);
 	if (unlikely(r)) {
 		__metadata_operation_failed(clone, "dm_clone_metadata_commit", r);
 		goto out;


