Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE90664B4F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbjAJSlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239570AbjAJSko (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:40:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66C0983E2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:34:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CD3461874
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C97AC433D2;
        Tue, 10 Jan 2023 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375697;
        bh=wNagAmtUkz9/B1EWjCfdTu7kBluw3+0WyuecC1saY7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD8+JGa3aB9cZVF/TUjQGuvBUp2Ton6a2vIa8L8YNwlrzjgL94vzpXiIXqTxhx16D
         A6ilGx3bCEJGxBNSxK0KXds1B9U6zNcDmQrfEGjJfgl5Dmo7rAesiJd2AE9IxVbTcx
         fJftPFjEtmmbUOgfBfBpqdPZ3dd4bdpcTyNdXPJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/290] filelock: new helper: vfs_inode_has_locks
Date:   Tue, 10 Jan 2023 19:05:33 +0100
Message-Id: <20230110180040.319842782@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit ab1ddef98a715eddb65309ffa83267e4e84a571e ]

Ceph has a need to know whether a particular inode has any locks set on
it. It's currently tracking that by a num_locks field in its
filp->private_data, but that's problematic as it tries to decrement this
field when releasing locks and that can race with the file being torn
down.

Add a new vfs_inode_has_locks helper that just returns whether any locks
are currently held on the inode.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: 461ab10ef7e6 ("ceph: switch to vfs_inode_has_locks() to fix file lock bug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/locks.c         | 23 +++++++++++++++++++++++
 include/linux/fs.h |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/locks.c b/fs/locks.c
index 3d6fb4ae847b..82a4487e95b3 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2703,6 +2703,29 @@ int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
 }
 EXPORT_SYMBOL_GPL(vfs_cancel_lock);
 
+/**
+ * vfs_inode_has_locks - are any file locks held on @inode?
+ * @inode: inode to check for locks
+ *
+ * Return true if there are any FL_POSIX or FL_FLOCK locks currently
+ * set on @inode.
+ */
+bool vfs_inode_has_locks(struct inode *inode)
+{
+	struct file_lock_context *ctx;
+	bool ret;
+
+	ctx = smp_load_acquire(&inode->i_flctx);
+	if (!ctx)
+		return false;
+
+	spin_lock(&ctx->flc_lock);
+	ret = !list_empty(&ctx->flc_posix) || !list_empty(&ctx->flc_flock);
+	spin_unlock(&ctx->flc_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfs_inode_has_locks);
+
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 68fcf3ec9cf6..1e1ac116dd13 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1195,6 +1195,7 @@ extern int locks_delete_block(struct file_lock *);
 extern int vfs_test_lock(struct file *, struct file_lock *);
 extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
 extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
+bool vfs_inode_has_locks(struct inode *inode);
 extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
 extern void lease_get_mtime(struct inode *, struct timespec64 *time);
@@ -1307,6 +1308,11 @@ static inline int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
 	return 0;
 }
 
+static inline bool vfs_inode_has_locks(struct inode *inode)
+{
+	return false;
+}
+
 static inline int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl)
 {
 	return -ENOLCK;
-- 
2.35.1



