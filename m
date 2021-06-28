Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A237F3B636D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhF1O44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235865AbhF1OxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:53:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32A4B61D37;
        Mon, 28 Jun 2021 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891044;
        bh=HxIbMjLZ3pfTFH/OuSuLE3sjYWU92k1375vx+sIZZ6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mvh9qlMmKuelqzX/rjcUJ/KJVHCTsfrPLKVRfGv4nqMv0DrUodYwBo9jSlrQP9dLm
         w30U7u/2xOVc/mtGbXMteeht3l+22NOUO1Sf3jlQbKSPGqlrEb0dfbvY6+s6qUmhn6
         cizRq/EJ0/+MCNji4xQWy5NbscLdt7768FjNBFmIyQ395ap74B9sROZaVRs5gWpXh8
         CmPySHDYq8im0Jcx4E63+evKhS4aL2lJnz+utk4/BIjN+ZHcIa/BUpwAT6f50MR9HK
         CHx/93TqU56HQKZAOYWdEGzK3sOd0f5bRNUqMmXxOhOylkWEfJxxcoXL4n5p50HHPy
         Cjc/GawMLyUGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "Guilherme G . Piccoli" <gpiccoli@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 63/88] unfuck sysfs_mount()
Date:   Mon, 28 Jun 2021 10:36:03 -0400
Message-Id: <20210628143628.33342-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 7b745a4e4051e1bbce40e0b1c2cf636c70583aa4 upstream.

new_sb is left uninitialized in case of early failures in kernfs_mount_ns(),
and while IS_ERR(root) is true in all such cases, using IS_ERR(root) || !new_sb
is not a solution - IS_ERR(root) is true in some cases when new_sb is true.

Make sure new_sb is initialized (and matches the reality) in all cases and
fix the condition for dropping kobj reference - we want it done precisely
in those situations where the reference has not been transferred into a new
super_block instance.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/mount.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 20b8f82e115b..2bbe84d9c0a8 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -28,7 +28,7 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 {
 	struct dentry *root;
 	void *ns;
-	bool new_sb;
+	bool new_sb = false;
 
 	if (!(flags & MS_KERNMOUNT)) {
 		if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
@@ -38,9 +38,9 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	ns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
 	root = kernfs_mount_ns(fs_type, flags, sysfs_root,
 				SYSFS_MAGIC, &new_sb, ns);
-	if (IS_ERR(root) || !new_sb)
+	if (!new_sb)
 		kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
-	else if (new_sb)
+	else if (!IS_ERR(root))
 		root->d_sb->s_iflags |= SB_I_USERNS_VISIBLE;
 
 	return root;
-- 
2.30.2

