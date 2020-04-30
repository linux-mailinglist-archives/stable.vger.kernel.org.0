Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29BA1BFA34
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgD3NwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgD3NwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455FC21775;
        Thu, 30 Apr 2020 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254723;
        bh=JB18C4FnNIFN+VNs2OuLeXmWGRjYmbuBlNcy1dbMBPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPn7+Kk1Lc0nqbud+E/oKrwztmnzzRM1mxjhlGoZQ4wzikGuvuxkuF4iDwTLs1krm
         ari1nBgHSO3GbBvpSVu6RW5I0M6VefFEvCiMH8WSG1X6phZDWOr5l5BmzYojeANgqW
         Mudffi///6ya/+kpYAVm7nw8CSlCh3yop+UXxGMI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 71/79] afs: Make record checking use TASK_UNINTERRUPTIBLE when appropriate
Date:   Thu, 30 Apr 2020 09:50:35 -0400
Message-Id: <20200430135043.19851-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c4bfda16d1b40d1c5941c61b5aa336bdd2d9904a ]

When an operation is meant to be done uninterruptibly (such as
FS.StoreData), we should not be allowing volume and server record checking
to be interrupted.

Fixes: d2ddc776a458 ("afs: Overhaul volume and server record caching and fileserver rotation")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h | 2 +-
 fs/afs/rotate.c   | 6 +++---
 fs/afs/server.c   | 7 ++-----
 fs/afs/volume.c   | 8 +++++---
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index ef732dd4e7ef5..15ae9c7f9c00a 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1335,7 +1335,7 @@ extern struct afs_volume *afs_create_volume(struct afs_fs_context *);
 extern void afs_activate_volume(struct afs_volume *);
 extern void afs_deactivate_volume(struct afs_volume *);
 extern void afs_put_volume(struct afs_cell *, struct afs_volume *);
-extern int afs_check_volume_status(struct afs_volume *, struct key *);
+extern int afs_check_volume_status(struct afs_volume *, struct afs_fs_cursor *);
 
 /*
  * write.c
diff --git a/fs/afs/rotate.c b/fs/afs/rotate.c
index 172ba569cd602..2a3305e42b145 100644
--- a/fs/afs/rotate.c
+++ b/fs/afs/rotate.c
@@ -192,7 +192,7 @@ bool afs_select_fileserver(struct afs_fs_cursor *fc)
 			write_unlock(&vnode->volume->servers_lock);
 
 			set_bit(AFS_VOLUME_NEEDS_UPDATE, &vnode->volume->flags);
-			error = afs_check_volume_status(vnode->volume, fc->key);
+			error = afs_check_volume_status(vnode->volume, fc);
 			if (error < 0)
 				goto failed_set_error;
 
@@ -281,7 +281,7 @@ bool afs_select_fileserver(struct afs_fs_cursor *fc)
 
 			set_bit(AFS_VOLUME_WAIT, &vnode->volume->flags);
 			set_bit(AFS_VOLUME_NEEDS_UPDATE, &vnode->volume->flags);
-			error = afs_check_volume_status(vnode->volume, fc->key);
+			error = afs_check_volume_status(vnode->volume, fc);
 			if (error < 0)
 				goto failed_set_error;
 
@@ -341,7 +341,7 @@ start:
 	/* See if we need to do an update of the volume record.  Note that the
 	 * volume may have moved or even have been deleted.
 	 */
-	error = afs_check_volume_status(vnode->volume, fc->key);
+	error = afs_check_volume_status(vnode->volume, fc);
 	if (error < 0)
 		goto failed_set_error;
 
diff --git a/fs/afs/server.c b/fs/afs/server.c
index b7f3cb2130cae..11b90ac7ea30f 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -594,12 +594,9 @@ retry:
 	}
 
 	ret = wait_on_bit(&server->flags, AFS_SERVER_FL_UPDATING,
-			  TASK_INTERRUPTIBLE);
+			  (fc->flags & AFS_FS_CURSOR_INTR) ?
+			  TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
 	if (ret == -ERESTARTSYS) {
-		if (!(fc->flags & AFS_FS_CURSOR_INTR) && server->addresses) {
-			_leave(" = t [intr]");
-			return true;
-		}
 		fc->error = ret;
 		_leave(" = f [intr]");
 		return false;
diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 92ca5e27573b7..4310336b9bb8c 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -281,7 +281,7 @@ error:
 /*
  * Make sure the volume record is up to date.
  */
-int afs_check_volume_status(struct afs_volume *volume, struct key *key)
+int afs_check_volume_status(struct afs_volume *volume, struct afs_fs_cursor *fc)
 {
 	time64_t now = ktime_get_real_seconds();
 	int ret, retries = 0;
@@ -299,7 +299,7 @@ retry:
 	}
 
 	if (!test_and_set_bit_lock(AFS_VOLUME_UPDATING, &volume->flags)) {
-		ret = afs_update_volume_status(volume, key);
+		ret = afs_update_volume_status(volume, fc->key);
 		clear_bit_unlock(AFS_VOLUME_WAIT, &volume->flags);
 		clear_bit_unlock(AFS_VOLUME_UPDATING, &volume->flags);
 		wake_up_bit(&volume->flags, AFS_VOLUME_WAIT);
@@ -312,7 +312,9 @@ retry:
 		return 0;
 	}
 
-	ret = wait_on_bit(&volume->flags, AFS_VOLUME_WAIT, TASK_INTERRUPTIBLE);
+	ret = wait_on_bit(&volume->flags, AFS_VOLUME_WAIT,
+			  (fc->flags & AFS_FS_CURSOR_INTR) ?
+			  TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
 	if (ret == -ERESTARTSYS) {
 		_leave(" = %d", ret);
 		return ret;
-- 
2.20.1

