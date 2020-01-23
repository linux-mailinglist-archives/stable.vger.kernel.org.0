Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1B4146245
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 08:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgAWHID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 02:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgAWHID (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 02:08:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BA2224673;
        Thu, 23 Jan 2020 07:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579763282;
        bh=KF+6TFrgjdCk7daC/uYjJcRbuE8TRoUpLGqNqzb1lkY=;
        h=Subject:To:From:Date:From;
        b=j2zxrxTAeBcErEkdoeqbE0LoUSYZQQ5q6B99C7zeKWx+3kzMYw/Ou8reHb6v6lRlG
         8vJd92d8/C2gPe5WqNT2rKP/U2l3Y03lMdvzHWIu16Kh9tYfnEJCm7f0b1WTaPGnBu
         ssd4JmPr8woH+Xu1MJLs7Hkw3itEBEK37Op+Tmlw=
Subject: patch "binder: fix log spam for existing debugfs file creation." added to char-misc-next
To:     martin.fuzzey@flowbird.group, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Jan 2020 08:07:26 +0100
Message-ID: <15797632463180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: fix log spam for existing debugfs file creation.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From eb143f8756e77c8fcfc4d574922ae9efd3a43ca9 Mon Sep 17 00:00:00 2001
From: Martin Fuzzey <martin.fuzzey@flowbird.group>
Date: Fri, 10 Jan 2020 16:44:01 +0100
Subject: binder: fix log spam for existing debugfs file creation.

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
 drivers/android/binder.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index b2dad43dbf82..9fcc761031d8 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5199,10 +5199,11 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 
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
@@ -5235,19 +5236,24 @@ static int binder_open(struct inode *nodp, struct file *filp)
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
@@ -5255,19 +5261,16 @@ static int binder_open(struct inode *nodp, struct file *filp)
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
@@ -5277,10 +5280,8 @@ static int binder_open(struct inode *nodp, struct file *filp)
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
 
-- 
2.25.0


