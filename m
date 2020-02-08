Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0688B156621
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgBHScM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:32:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34698 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727962AbgBHS3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:49 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003ji-V7; Sat, 08 Feb 2020 18:29:43 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrM-000CWU-Ik; Sat, 08 Feb 2020 18:29:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pavel Shilovsky" <pshilov@microsoft.com>,
        "Steve French" <stfrench@microsoft.com>,
        "Aurelien Aptel" <aaptel@suse.com>
Date:   Sat, 08 Feb 2020 18:21:12 +0000
Message-ID: <lsq.1581185941.602937819@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 133/148] CIFS: Fix NULL-pointer dereference in
 smb2_push_mandatory_locks
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilov@microsoft.com>

commit 6f582b273ec23332074d970a7fb25bef835df71f upstream.

Currently when the client creates a cifsFileInfo structure for
a newly opened file, it allocates a list of byte-range locks
with a pointer to the new cfile and attaches this list to the
inode's lock list. The latter happens before initializing all
other fields, e.g. cfile->tlink. Thus a partially initialized
cifsFileInfo structure becomes available to other threads that
walk through the inode's lock list. One example of such a thread
may be an oplock break worker thread that tries to push all
cached byte-range locks. This causes NULL-pointer dereference
in smb2_push_mandatory_locks() when accessing cfile->tlink:

[598428.945633] BUG: kernel NULL pointer dereference, address: 0000000000000038
...
[598428.945749] Workqueue: cifsoplockd cifs_oplock_break [cifs]
[598428.945793] RIP: 0010:smb2_push_mandatory_locks+0xd6/0x5a0 [cifs]
...
[598428.945834] Call Trace:
[598428.945870]  ? cifs_revalidate_mapping+0x45/0x90 [cifs]
[598428.945901]  cifs_oplock_break+0x13d/0x450 [cifs]
[598428.945909]  process_one_work+0x1db/0x380
[598428.945914]  worker_thread+0x4d/0x400
[598428.945921]  kthread+0x104/0x140
[598428.945925]  ? process_one_work+0x380/0x380
[598428.945931]  ? kthread_park+0x80/0x80
[598428.945937]  ret_from_fork+0x35/0x40

Fix this by reordering initialization steps of the cifsFileInfo
structure: initialize all the fields first and then add the new
byte-range lock list to the inode's lock list.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -313,9 +313,6 @@ cifs_new_fileinfo(struct cifs_fid *fid,
 	INIT_LIST_HEAD(&fdlocks->locks);
 	fdlocks->cfile = cfile;
 	cfile->llist = fdlocks;
-	cifs_down_write(&cinode->lock_sem);
-	list_add(&fdlocks->llist, &cinode->llist);
-	up_write(&cinode->lock_sem);
 
 	cfile->count = 1;
 	cfile->pid = current->tgid;
@@ -339,6 +336,10 @@ cifs_new_fileinfo(struct cifs_fid *fid,
 		oplock = 0;
 	}
 
+	cifs_down_write(&cinode->lock_sem);
+	list_add(&fdlocks->llist, &cinode->llist);
+	up_write(&cinode->lock_sem);
+
 	spin_lock(&tcon->open_file_lock);
 	if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE && oplock)
 		oplock = fid->pending_open->oplock;

