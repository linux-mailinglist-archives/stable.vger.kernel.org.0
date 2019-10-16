Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC041D9ECC
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387997AbfJPWCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438629AbfJPV7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:48 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7565222C2;
        Wed, 16 Oct 2019 21:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263187;
        bh=HlXTXboAkyqn6FY2CDGUTPyMyBNKFPuj4tbRyDGzV/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/CyfTCIX1EV+QTUN51ZTjm1qMte5gzW23M/0PxSODfdTQh4TNqKSxknpfSzJ6BB2
         jWcoULZ9wFQm0+xq0RtZqfUTGbzWBJKI7CnT1pJdqSo/8DXSIINzJDGM7hx2JK/h39
         0VA3hR1S9DWMyqhp+aT0DQ9bw7dyNYqESf2FY6gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.3 074/112] cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a panic
Date:   Wed, 16 Oct 2019 14:51:06 -0700
Message-Id: <20191016214903.885682488@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

commit cb248819d209d113e45fed459773991518e8e80b upstream.

Commit 487317c99477 ("cifs: add spinlock for the openFileList to
cifsInodeInfo") added cifsInodeInfo->open_file_lock spin_lock to protect
the openFileList, but missed a few places where cifs_inode->openFileList
was enumerated.  Change these remaining tcon->open_file_lock to
cifsInodeInfo->open_file_lock to avoid panic in is_size_safe_to_change.

[17313.245641] RIP: 0010:is_size_safe_to_change+0x57/0xb0 [cifs]
[17313.245645] Code: 68 40 48 89 ef e8 19 67 b7 f1 48 8b 43 40 48 8d 4b 40 48 8d 50 f0 48 39 c1 75 0f eb 47 48 8b 42 10 48 8d 50 f0 48 39 c1 74 3a <8b> 80 88 00 00 00 83 c0 01 a8 02 74 e6 48 89 ef c6 07 00 0f 1f 40
[17313.245649] RSP: 0018:ffff94ae1baefa30 EFLAGS: 00010202
[17313.245654] RAX: dead000000000100 RBX: ffff88dc72243300 RCX: ffff88dc72243340
[17313.245657] RDX: dead0000000000f0 RSI: 00000000098f7940 RDI: ffff88dd3102f040
[17313.245659] RBP: ffff88dd3102f040 R08: 0000000000000000 R09: ffff94ae1baefc40
[17313.245661] R10: ffffcdc8bb1c4e80 R11: ffffcdc8b50adb08 R12: 00000000098f7940
[17313.245663] R13: ffff88dc72243300 R14: ffff88dbc8f19600 R15: ffff88dc72243428
[17313.245667] FS:  00007fb145485700(0000) GS:ffff88dd3e000000(0000) knlGS:0000000000000000
[17313.245670] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[17313.245672] CR2: 0000026bb46c6000 CR3: 0000004edb110003 CR4: 00000000007606e0
[17313.245753] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[17313.245756] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[17313.245759] PKRU: 55555554
[17313.245761] Call Trace:
[17313.245803]  cifs_fattr_to_inode+0x16b/0x580 [cifs]
[17313.245838]  cifs_get_inode_info+0x35c/0xa60 [cifs]
[17313.245852]  ? kmem_cache_alloc_trace+0x151/0x1d0
[17313.245885]  cifs_open+0x38f/0x990 [cifs]
[17313.245921]  ? cifs_revalidate_dentry_attr+0x3e/0x350 [cifs]
[17313.245953]  ? cifsFileInfo_get+0x30/0x30 [cifs]
[17313.245960]  ? do_dentry_open+0x132/0x330
[17313.245963]  do_dentry_open+0x132/0x330
[17313.245969]  path_openat+0x573/0x14d0
[17313.245974]  do_filp_open+0x93/0x100
[17313.245979]  ? __check_object_size+0xa3/0x181
[17313.245986]  ? audit_alloc_name+0x7e/0xd0
[17313.245992]  do_sys_open+0x184/0x220
[17313.245999]  do_syscall_64+0x5b/0x1b0

Fixes: 487317c99477 ("cifs: add spinlock for the openFileList to cifsInodeInfo")

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1853,13 +1853,12 @@ struct cifsFileInfo *find_readable_file(
 {
 	struct cifsFileInfo *open_file = NULL;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	/* only filter by fsuid on multiuser mounts */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
-	spin_lock(&tcon->open_file_lock);
+	spin_lock(&cifs_inode->open_file_lock);
 	/* we could simply get the first_list_entry since write-only entries
 	   are always at the end of the list but since the first entry might
 	   have a close pending, we go through the whole list */
@@ -1871,7 +1870,7 @@ struct cifsFileInfo *find_readable_file(
 				/* found a good file */
 				/* lock it so it will not be closed on us */
 				cifsFileInfo_get(open_file);
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&cifs_inode->open_file_lock);
 				return open_file;
 			} /* else might as well continue, and look for
 			     another, or simply have the caller reopen it
@@ -1879,7 +1878,7 @@ struct cifsFileInfo *find_readable_file(
 		} else /* write only file */
 			break; /* write only files are last so must be done */
 	}
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&cifs_inode->open_file_lock);
 	return NULL;
 }
 
@@ -1890,7 +1889,6 @@ cifs_get_writable_file(struct cifsInodeI
 {
 	struct cifsFileInfo *open_file, *inv_file = NULL;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
 	bool any_available = false;
 	int rc = -EBADF;
 	unsigned int refind = 0;
@@ -1910,16 +1908,15 @@ cifs_get_writable_file(struct cifsInodeI
 	}
 
 	cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
-	tcon = cifs_sb_master_tcon(cifs_sb);
 
 	/* only filter by fsuid on multiuser mounts */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
-	spin_lock(&tcon->open_file_lock);
+	spin_lock(&cifs_inode->open_file_lock);
 refind_writable:
 	if (refind > MAX_REOPEN_ATT) {
-		spin_unlock(&tcon->open_file_lock);
+		spin_unlock(&cifs_inode->open_file_lock);
 		return rc;
 	}
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
@@ -1931,7 +1928,7 @@ refind_writable:
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
 				cifsFileInfo_get(open_file);
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&cifs_inode->open_file_lock);
 				*ret_file = open_file;
 				return 0;
 			} else {
@@ -1951,7 +1948,7 @@ refind_writable:
 		cifsFileInfo_get(inv_file);
 	}
 
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&cifs_inode->open_file_lock);
 
 	if (inv_file) {
 		rc = cifs_reopen_file(inv_file, false);
@@ -1966,7 +1963,7 @@ refind_writable:
 		cifsFileInfo_put(inv_file);
 		++refind;
 		inv_file = NULL;
-		spin_lock(&tcon->open_file_lock);
+		spin_lock(&cifs_inode->open_file_lock);
 		goto refind_writable;
 	}
 
@@ -4405,17 +4402,15 @@ static int cifs_readpage(struct file *fi
 static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
 {
 	struct cifsFileInfo *open_file;
-	struct cifs_tcon *tcon =
-		cifs_sb_master_tcon(CIFS_SB(cifs_inode->vfs_inode.i_sb));
 
-	spin_lock(&tcon->open_file_lock);
+	spin_lock(&cifs_inode->open_file_lock);
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
-			spin_unlock(&tcon->open_file_lock);
+			spin_unlock(&cifs_inode->open_file_lock);
 			return 1;
 		}
 	}
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&cifs_inode->open_file_lock);
 	return 0;
 }
 


