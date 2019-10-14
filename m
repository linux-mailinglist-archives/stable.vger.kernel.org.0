Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D56D6712
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 18:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbfJNQS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 12:18:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48361 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729271AbfJNQS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 12:18:26 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D39221E62;
        Mon, 14 Oct 2019 12:18:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 12:18:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zk+aYa
        icB6+DhPE0Ev2CXT80cOQhkThIkiGey8xQTA0=; b=lwDMYIcHIHAaycIn4OQFAr
        UjbarnybSxesDtMTFAv1EvG9O4QHD8IJundvnbxRMr6zCLDlT91gEJrrjzLhR/Ko
        9nB8dgs0Q1qyg609gS5LzlG4ipFjCLlypJ+edp/Q1narEWY4qvmj36dSQFf6Ay1x
        MC4zcoKNQXM0MzrIO2LvNZVsswRzMJW990sIvuFLyA2frfRoxLjBQsPoEf0QzVal
        m5d6HsTaOLGZ4JFhc1gn5a135JMmbChV0Sl/lo2QHeALVzt21s7o+6fJa7gmzxc+
        huagDuHewg6Yii/uWlvq5vU1LtD9A8cFPGBBJ5wTNLiL96DgH0zw1bKejYofUSEw
        ==
X-ME-Sender: <xms:0Z-kXQaDvXLPUo-UnLLmGTr5-0KSupTSipY-K72jkRkx3S7_S24eQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:0Z-kXfoiFb1-wdMlTASBDm5PTRSyjS__QZx8b1nikrdyJ_79QPsWjQ>
    <xmx:0Z-kXV9tj0sSVuoevDtUSHwJNkYqF3Sc2Q_hg1lkmV7xOicFXRw7ZA>
    <xmx:0Z-kXe_050wF3NC6_hw18PydFiZVtxvggx1k_aNrBgCPQicEtzZVRQ>
    <xmx:0Z-kXfpLzintjRREG3P5uYsPu5dRlB-e4fQdYvC-ZpdeDzK4OZuz6w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D8D9F8005A;
        Mon, 14 Oct 2019 12:18:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs: use cifsInodeInfo->open_file_lock while iterating to" failed to apply to 4.19-stable tree
To:     dwysocha@redhat.com, lsahlber@redhat.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 18:18:23 +0200
Message-ID: <15710699036748@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb248819d209d113e45fed459773991518e8e80b Mon Sep 17 00:00:00 2001
From: Dave Wysochanski <dwysocha@redhat.com>
Date: Thu, 3 Oct 2019 15:16:27 +1000
Subject: [PATCH] cifs: use cifsInodeInfo->open_file_lock while iterating to
 avoid a panic

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

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4b95700c507c..3758237bf951 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1840,13 +1840,12 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
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
@@ -1858,7 +1857,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 				/* found a good file */
 				/* lock it so it will not be closed on us */
 				cifsFileInfo_get(open_file);
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&cifs_inode->open_file_lock);
 				return open_file;
 			} /* else might as well continue, and look for
 			     another, or simply have the caller reopen it
@@ -1866,7 +1865,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 		} else /* write only file */
 			break; /* write only files are last so must be done */
 	}
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&cifs_inode->open_file_lock);
 	return NULL;
 }
 
@@ -1877,7 +1876,6 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
 {
 	struct cifsFileInfo *open_file, *inv_file = NULL;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
 	bool any_available = false;
 	int rc = -EBADF;
 	unsigned int refind = 0;
@@ -1897,16 +1895,15 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
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
@@ -1918,7 +1915,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
 				cifsFileInfo_get(open_file);
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&cifs_inode->open_file_lock);
 				*ret_file = open_file;
 				return 0;
 			} else {
@@ -1938,7 +1935,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
 		cifsFileInfo_get(inv_file);
 	}
 
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&cifs_inode->open_file_lock);
 
 	if (inv_file) {
 		rc = cifs_reopen_file(inv_file, false);
@@ -1953,7 +1950,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
 		cifsFileInfo_put(inv_file);
 		++refind;
 		inv_file = NULL;
-		spin_lock(&tcon->open_file_lock);
+		spin_lock(&cifs_inode->open_file_lock);
 		goto refind_writable;
 	}
 
@@ -4461,17 +4458,15 @@ static int cifs_readpage(struct file *file, struct page *page)
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
 

