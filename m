Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C6267824
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 06:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfGMEMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 00:12:36 -0400
Received: from nibbler.cm4all.net ([82.165.145.151]:37152 "EHLO
        nibbler.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfGMEMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 00:12:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id 68369C0201
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 06:12:24 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at nibbler.cm4all.net
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id CIxc-C2uMjWU for <stable@vger.kernel.org>;
        Sat, 13 Jul 2019 06:12:24 +0200 (CEST)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id 42FDDC01DC
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 06:12:24 +0200 (CEST)
Received: (qmail 30950 invoked from network); 13 Jul 2019 06:44:01 +0200
Received: from unknown (HELO rabbit.intern.cm-ag) (172.30.3.1)
  by zero.intern.cm-ag with SMTP; 13 Jul 2019 06:44:01 +0200
Received: by rabbit.intern.cm-ag (Postfix, from userid 1023)
        id EAD4F460C4C; Sat, 13 Jul 2019 06:12:18 +0200 (CEST)
From:   Max Kellermann <mk@cm4all.com>
To:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com, bfields@redhat.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, hughd@google.com,
        anna.schumaker@netapp.com
Cc:     linux-kernel@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 4/4] nfs/super: check NFS_CAP_ACLS instead of the NFS version
Date:   Sat, 13 Jul 2019 06:12:00 +0200
Message-Id: <20190713041200.18566-4-mk@cm4all.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190713041200.18566-1-mk@cm4all.com>
References: <20190713041200.18566-1-mk@cm4all.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This sets MS_POSIXACL only if ACL support is really enabled, instead
of always setting MS_POSIXACL if the NFS protocol version
theoretically supports ACL.

The code comment says "We will [apply the umask] ourselves", but that
happens in posix_acl_create() only if the kernel has POSIX ACL
support.  Without it, posix_acl_create() is an empty dummy function.

So let's not pretend we will apply the umask if we can already know
that we will never.

This fixes a problem where the umask is always ignored in the NFS
client when compiled without CONFIG_FS_POSIX_ACL.  This is a 4 year
old regression caused by commit 013cdf1088d723 which itself was not
completely wrong, but failed to consider all the side effects by
misdesigned VFS code.

Signed-off-by: Max Kellermann <mk@cm4all.com>
Cc: stable@vger.kernel.org
---
 fs/nfs/super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index f88ddac2dcdf..886ad89af676 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2353,11 +2353,14 @@ void nfs_fill_super(struct super_block *sb, struct nfs_mount_info *mount_info)
 	if (data && data->bsize)
 		sb->s_blocksize = nfs_block_size(data->bsize, &sb->s_blocksize_bits);
 
-	if (server->nfs_client->rpc_ops->version != 2) {
+	if (NFS_SB(sb)->caps & NFS_CAP_ACLS) {
 		/* The VFS shouldn't apply the umask to mode bits. We will do
 		 * so ourselves when necessary.
 		 */
 		sb->s_flags |= SB_POSIXACL;
+	}
+
+	if (server->nfs_client->rpc_ops->version != 2) {
 		sb->s_time_gran = 1;
 		sb->s_export_op = &nfs_export_ops;
 	}
@@ -2383,7 +2386,7 @@ static void nfs_clone_super(struct super_block *sb,
 	sb->s_time_gran = 1;
 	sb->s_export_op = old_sb->s_export_op;
 
-	if (server->nfs_client->rpc_ops->version != 2) {
+	if (NFS_SB(sb)->caps & NFS_CAP_ACLS) {
 		/* The VFS shouldn't apply the umask to mode bits. We will do
 		 * so ourselves when necessary.
 		 */
-- 
2.20.1

