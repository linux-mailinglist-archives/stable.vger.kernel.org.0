Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AD314E13C
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgA3Smh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:42:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgA3Smg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:42:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BC092083E;
        Thu, 30 Jan 2020 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409755;
        bh=GOS1qZvCtnVV92X2RUs0Xx56D0YfKguWqkXghm3ygQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlQeN+Z9JhbOP9EQ+nlXb4jLQGGlZMsoR58kHzJ0Vx+e6lb77Wi4ec82MdRFo5fCk
         dODBY1vHNiUSRG6RfsgK8uLptpFugFQ1Xb9l0atnsur+I3PzAMkhM2fkaxD0zH2oYj
         f8ULcqCPBejuh1nZK96hDruDBFxjzIY7xcOhh4fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.4 021/110] binder: fix log spam for existing debugfs file creation.
Date:   Thu, 30 Jan 2020 19:37:57 +0100
Message-Id: <20200130183617.460576374@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

commit eb143f8756e77c8fcfc4d574922ae9efd3a43ca9 upstream.

Since commit 43e23b6c0b01 ("debugfs: log errors when something goes wrong")
debugfs logs attempts to create existing files.

However binder attempts to create multiple debugfs files with
the same name when a single PID has multiple contexts, this leads
to log spamming during an Android boot (17 such messages during
boot on my system).

Fix this by checking if we already know the PID and only create
the debugfs entry for the first context per PID.

Do the same thing for binderfs for symmetry.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Acked-by: Todd Kjos <tkjos@google.com>
Fixes: 43e23b6c0b01 ("debugfs: log errors when something goes wrong")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1578671054-5982-1-git-send-email-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5203,10 +5203,11 @@ err_bad_arg:
 
 static int binder_open(struct inode *nodp, struct file *filp)
 {
-	struct binder_proc *proc;
+	struct binder_proc *proc, *itr;
 	struct binder_device *binder_dev;
 	struct binderfs_info *info;
 	struct dentry *binder_binderfs_dir_entry_proc = NULL;
+	bool existing_pid = false;
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE, "%s: %d:%d\n", __func__,
 		     current->group_leader->pid, current->pid);
@@ -5239,19 +5240,24 @@ static int binder_open(struct inode *nod
 	filp->private_data = proc;
 
 	mutex_lock(&binder_procs_lock);
+	hlist_for_each_entry(itr, &binder_procs, proc_node) {
+		if (itr->pid == proc->pid) {
+			existing_pid = true;
+			break;
+		}
+	}
 	hlist_add_head(&proc->proc_node, &binder_procs);
 	mutex_unlock(&binder_procs_lock);
 
-	if (binder_debugfs_dir_entry_proc) {
+	if (binder_debugfs_dir_entry_proc && !existing_pid) {
 		char strbuf[11];
 
 		snprintf(strbuf, sizeof(strbuf), "%u", proc->pid);
 		/*
-		 * proc debug entries are shared between contexts, so
-		 * this will fail if the process tries to open the driver
-		 * again with a different context. The priting code will
-		 * anyway print all contexts that a given PID has, so this
-		 * is not a problem.
+		 * proc debug entries are shared between contexts.
+		 * Only create for the first PID to avoid debugfs log spamming
+		 * The printing code will anyway print all contexts for a given
+		 * PID so this is not a problem.
 		 */
 		proc->debugfs_entry = debugfs_create_file(strbuf, 0444,
 			binder_debugfs_dir_entry_proc,
@@ -5259,19 +5265,16 @@ static int binder_open(struct inode *nod
 			&proc_fops);
 	}
 
-	if (binder_binderfs_dir_entry_proc) {
+	if (binder_binderfs_dir_entry_proc && !existing_pid) {
 		char strbuf[11];
 		struct dentry *binderfs_entry;
 
 		snprintf(strbuf, sizeof(strbuf), "%u", proc->pid);
 		/*
 		 * Similar to debugfs, the process specific log file is shared
-		 * between contexts. If the file has already been created for a
-		 * process, the following binderfs_create_file() call will
-		 * fail with error code EEXIST if another context of the same
-		 * process invoked binder_open(). This is ok since same as
-		 * debugfs, the log file will contain information on all
-		 * contexts of a given PID.
+		 * between contexts. Only create for the first PID.
+		 * This is ok since same as debugfs, the log file will contain
+		 * information on all contexts of a given PID.
 		 */
 		binderfs_entry = binderfs_create_file(binder_binderfs_dir_entry_proc,
 			strbuf, &proc_fops, (void *)(unsigned long)proc->pid);
@@ -5281,10 +5284,8 @@ static int binder_open(struct inode *nod
 			int error;
 
 			error = PTR_ERR(binderfs_entry);
-			if (error != -EEXIST) {
-				pr_warn("Unable to create file %s in binderfs (error %d)\n",
-					strbuf, error);
-			}
+			pr_warn("Unable to create file %s in binderfs (error %d)\n",
+				strbuf, error);
 		}
 	}
 


