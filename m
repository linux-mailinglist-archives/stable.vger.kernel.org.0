Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25378126CBB
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfLSSo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:44:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729066AbfLSSoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:44:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 490EE2465E;
        Thu, 19 Dec 2019 18:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781094;
        bh=NEpL2CzNtWa8pl2T6jNiFSD8t5+OTKp74Cn9n98fZfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmSr3JUBqxvawjNth0fBbfOhXRoh+SJZ8FWnmzOmWvI5gEtdxC76tMQoPr4x7Wcqx
         p9yHcFpSoaSWKIjKobss0aS/fIHfc5QlAjiixBpZOx2ioXGJjN0+Jlx9b0oQ6HL7o3
         EOJeUjr5ViV2N4xN4X77dAfzUdwS36zdHtf99IBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.9 078/199] CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks
Date:   Thu, 19 Dec 2019 19:32:40 +0100
Message-Id: <20191219183219.288819665@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -312,9 +312,6 @@ cifs_new_fileinfo(struct cifs_fid *fid,
 	INIT_LIST_HEAD(&fdlocks->locks);
 	fdlocks->cfile = cfile;
 	cfile->llist = fdlocks;
-	cifs_down_write(&cinode->lock_sem);
-	list_add(&fdlocks->llist, &cinode->llist);
-	up_write(&cinode->lock_sem);
 
 	cfile->count = 1;
 	cfile->pid = current->tgid;
@@ -338,6 +335,10 @@ cifs_new_fileinfo(struct cifs_fid *fid,
 		oplock = 0;
 	}
 
+	cifs_down_write(&cinode->lock_sem);
+	list_add(&fdlocks->llist, &cinode->llist);
+	up_write(&cinode->lock_sem);
+
 	spin_lock(&tcon->open_file_lock);
 	if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE && oplock)
 		oplock = fid->pending_open->oplock;


