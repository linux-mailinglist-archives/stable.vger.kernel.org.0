Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D111C14AB
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbgEANls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731195AbgEANlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8D4C208DB;
        Fri,  1 May 2020 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340504;
        bh=zS4435gaHbhXcNFQzlsGB0b2rao3xyinhG5EY9EUhTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MW4emRmpQN+XDbSuj0NVcC5GZqAW9tC0Thee2DxjItPMTNtTLLkLHuyBNiHF+mkNh
         pEXqWK5iSOpRR5uKuK2wpMw4m9gBzmsHAYclHFnqOi3t3Z0sSuZTiMTHZCfkuQrpgv
         ATjMbwTIxiwZU/7U/mTgJQ6i+eNkI8lvDulVPsds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.6 009/106] afs: Make record checking use TASK_UNINTERRUPTIBLE when appropriate
Date:   Fri,  1 May 2020 15:22:42 +0200
Message-Id: <20200501131544.659017431@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit c4bfda16d1b40d1c5941c61b5aa336bdd2d9904a upstream.

When an operation is meant to be done uninterruptibly (such as
FS.StoreData), we should not be allowing volume and server record checking
to be interrupted.

Fixes: d2ddc776a458 ("afs: Overhaul volume and server record caching and fileserver rotation")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/internal.h |    2 +-
 fs/afs/rotate.c   |    6 +++---
 fs/afs/server.c   |    7 ++-----
 fs/afs/volume.c   |    8 +++++---
 4 files changed, 11 insertions(+), 12 deletions(-)

--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1335,7 +1335,7 @@ extern struct afs_volume *afs_create_vol
 extern void afs_activate_volume(struct afs_volume *);
 extern void afs_deactivate_volume(struct afs_volume *);
 extern void afs_put_volume(struct afs_cell *, struct afs_volume *);
-extern int afs_check_volume_status(struct afs_volume *, struct key *);
+extern int afs_check_volume_status(struct afs_volume *, struct afs_fs_cursor *);
 
 /*
  * write.c
--- a/fs/afs/rotate.c
+++ b/fs/afs/rotate.c
@@ -192,7 +192,7 @@ bool afs_select_fileserver(struct afs_fs
 			write_unlock(&vnode->volume->servers_lock);
 
 			set_bit(AFS_VOLUME_NEEDS_UPDATE, &vnode->volume->flags);
-			error = afs_check_volume_status(vnode->volume, fc->key);
+			error = afs_check_volume_status(vnode->volume, fc);
 			if (error < 0)
 				goto failed_set_error;
 
@@ -281,7 +281,7 @@ bool afs_select_fileserver(struct afs_fs
 
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


