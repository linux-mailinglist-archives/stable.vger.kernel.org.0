Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A987253A7A2
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349102AbiFAOCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354200AbiFAOAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3593CA30B9;
        Wed,  1 Jun 2022 06:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1BD45CE1A24;
        Wed,  1 Jun 2022 13:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A13C341C0;
        Wed,  1 Jun 2022 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091743;
        bh=8jW+wbclhVLRiL+4mYuuTKPY9fQZfW+0lZRvZfuv6to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGoGxXd+W/SE6jVbGzEBkmZUCNtRP1RYh8o+IeLNceTISQJmSq2ElVgyhfW+yzrmw
         J3LtKddvevoWAl2fWgx0U8c8Kfpx6TTcrGgL1oYZh+5SuqLjO7mG6u9+l+mx3+5HvD
         IAJpkGeTk7F7CcmznHov2aoXlfZ/f3c5zLc0wCcayq8I47S40/XU3VybPRlyuclaA/
         PFEJHshIw9/a3GBfqVvt2jeZCy9fz/27hx6humQGiHmRVZJaKA6OmwwaySGCC7283l
         64ipRu+fpf/JNKQA0arsGGOflb05nQ9GiM3AOT/LX5LFbw+VHb1+V6Sg75NMjFhr14
         2k/hg5F0LEZ5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.17 35/48] cifs: fix signed integer overflow when fl_end is OFFSET_MAX
Date:   Wed,  1 Jun 2022 09:54:08 -0400
Message-Id: <20220601135421.2003328-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit d80c69846ddfddf437167b31ab4cd0de12f61001 ]

This fixes the following when running xfstests generic/504:

[  134.394698] CIFS: Attempting to mount \\win16.vm.test\Share
[  134.420905] CIFS: VFS: generate_smb3signingkey: dumping generated
AES session keys
[  134.420911] CIFS: VFS: Session Id    05 00 00 00 00 c4 00 00
[  134.420914] CIFS: VFS: Cipher type   1
[  134.420917] CIFS: VFS: Session Key   ea 0b d9 22 2e af 01 69 30 1b
15 74 bf 87 41 11
[  134.420920] CIFS: VFS: Signing Key   59 28 43 5c f0 b6 b1 6f f5 7b
65 f2 9f 9e 58 7d
[  134.420923] CIFS: VFS: ServerIn Key  eb aa 58 c8 95 01 9a f7 91 98
e4 fa bc d8 74 f1
[  134.420926] CIFS: VFS: ServerOut Key 08 5b 21 e5 2e 4e 86 f6 05 c2
58 e0 af 53 83 e7
[  134.771946]
================================================================================
[  134.771953] UBSAN: signed-integer-overflow in fs/cifs/file.c:1706:19
[  134.771957] 9223372036854775807 + 1 cannot be represented in type
'long long int'
[  134.771960] CPU: 4 PID: 2773 Comm: flock Not tainted 5.11.22 #1
[  134.771964] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  134.771966] Call Trace:
[  134.771970]  dump_stack+0x8d/0xb5
[  134.771981]  ubsan_epilogue+0x5/0x50
[  134.771988]  handle_overflow+0xa3/0xb0
[  134.771997]  ? lockdep_hardirqs_on_prepare+0xe8/0x1b0
[  134.772006]  cifs_setlk+0x63c/0x680 [cifs]
[  134.772085]  ? _get_xid+0x5f/0xa0 [cifs]
[  134.772085]  cifs_flock+0x131/0x400 [cifs]
[  134.772085]  __x64_sys_flock+0xfc/0x120
[  134.772085]  do_syscall_64+0x33/0x40
[  134.772085]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  134.772085] RIP: 0033:0x7fea4f83b3fb
[  134.772085] Code: ff 48 8b 15 8f 1a 0d 00 f7 d8 64 89 02 b8 ff ff
ff ff eb da e8 16 0b 02 00 66 0f 1f 44 00 00 f3 0f 1e fa b8 49 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d 1a 0d 00 f7 d8 64 89
01 48

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h | 5 +++++
 fs/cifs/cifssmb.c  | 3 ++-
 fs/cifs/file.c     | 8 ++++----
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 560ecc4ad87d..3c7865186e5e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1983,4 +1983,9 @@ static inline bool cifs_is_referral_server(struct cifs_tcon *tcon,
 	return is_tcon_dfs(tcon) || (ref && (ref->flags & DFSREF_REFERRAL_SERVER));
 }
 
+static inline u64 cifs_flock_len(struct file_lock *fl)
+{
+	return fl->fl_end == OFFSET_MAX ? 0 : fl->fl_end - fl->fl_start + 1;
+}
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index aca9338b0877..83820205d644 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2558,7 +2558,8 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 			pLockData->fl_start = le64_to_cpu(parm_data->start);
 			pLockData->fl_end = pLockData->fl_start +
-					le64_to_cpu(parm_data->length) - 1;
+				(le64_to_cpu(parm_data->length) ?
+				 le64_to_cpu(parm_data->length) - 1 : 0);
 			pLockData->fl_pid = -le32_to_cpu(parm_data->pid);
 		}
 	}
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a2723f7cb5e9..b8a4b43870fe 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1395,7 +1395,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 			cifs_dbg(VFS, "Can't push all brlocks!\n");
 			break;
 		}
-		length = 1 + flock->fl_end - flock->fl_start;
+		length = cifs_flock_len(flock);
 		if (flock->fl_type == F_RDLCK || flock->fl_type == F_SHLCK)
 			type = CIFS_RDLCK;
 		else
@@ -1511,7 +1511,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 	   bool wait_flag, bool posix_lck, unsigned int xid)
 {
 	int rc = 0;
-	__u64 length = 1 + flock->fl_end - flock->fl_start;
+	__u64 length = cifs_flock_len(flock);
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
@@ -1609,7 +1609,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
 	struct cifsLockInfo *li, *tmp;
-	__u64 length = 1 + flock->fl_end - flock->fl_start;
+	__u64 length = cifs_flock_len(flock);
 	struct list_head tmp_llist;
 
 	INIT_LIST_HEAD(&tmp_llist);
@@ -1713,7 +1713,7 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 	   unsigned int xid)
 {
 	int rc = 0;
-	__u64 length = 1 + flock->fl_end - flock->fl_start;
+	__u64 length = cifs_flock_len(flock);
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
-- 
2.35.1

