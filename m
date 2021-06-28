Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FCB3B636C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhF1O4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235249AbhF1OxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FE1361D3B;
        Mon, 28 Jun 2021 14:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891043;
        bh=5WSj3ImtPWylynG+rVpYnClBOB1ekjAsw4fw4ioC/ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJZpnEFkwgS5q+vh9PFh3RxscO+pVDLaLFXA2RxgNi0VvJAtKIGUOtiQ1mgReENv4
         mqfdBmd9UG3jNMRtR4ivROAQNkIQsQrmJT/emNHI03e3pY1kuN83QquBAZm3lsyr/j
         7W3RT+Ix+FjStqmDamA+G+MW9Z1Tqv53aeZBICzEug3z27xFbRxnw8oPKx98yTRAqn
         5AwOc8FSI2H2sZwxUCeDChk7ElCRX6rjfBQKkSfxDaHaJCarcXFBdzsSFTWg3OQDzR
         FWmTDVe4LqZbsQG/3L03R8Q+uWJ9IVCVsmRLIxNYfVwOTOJaQfOi7vzNgj++zuzncv
         PmoIizXGxuIBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "Guilherme G . Piccoli" <gpiccoli@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 62/88] kernfs: deal with kernfs_fill_super() failures
Date:   Mon, 28 Jun 2021 10:36:02 -0400
Message-Id: <20210628143628.33342-63-sashal@kernel.org>
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

commit 82382acec0c97b91830fff7130d0acce4ac4f3f3 upstream.

make sure that info->node is initialized early, so that kernfs_kill_sb()
can list_del() it safely.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/mount.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 5019058e0f6a..610267585f8f 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -320,6 +320,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 
 	info->root = root;
 	info->ns = ns;
+	INIT_LIST_HEAD(&info->node);
 
 	sb = sget_userns(fs_type, kernfs_test_super, kernfs_set_super, flags,
 			 &init_user_ns, info);
-- 
2.30.2

