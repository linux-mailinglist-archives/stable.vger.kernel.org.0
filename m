Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DA011981C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfLJVgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730361AbfLJVfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 902352467B;
        Tue, 10 Dec 2019 21:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013745;
        bh=MLDi/Ji7T8kty6LHrlWV+4ipTnMmz+vK4/FjxGpmVBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVbSEHgy4QL7iZ4RMgmH+Nz8vGrNVvync0Ix4TQoq4cN3d5lQ47RUUx28Ski0Ywsh
         wYe+GG6/UU6zxPDUjZ+9X5LEYfsAodvqkWcgwDKKUmswwtFBhsvyzS/5FuKT37IoEQ
         DWHSQA2ojFT0A/DdoGxCXjeL1fNvw54j47uWeY6E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 167/177] debugfs: Fix !DEBUG_FS debugfs_create_automount
Date:   Tue, 10 Dec 2019 16:32:11 -0500
Message-Id: <20191210213221.11921-167-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kusanagi Kouichi <slash@ac.auone-net.jp>

[ Upstream commit 4250b047039d324e0ff65267c8beb5bad5052a86 ]

If DEBUG_FS=n, compile fails with the following error:

kernel/trace/trace.c: In function 'tracing_init_dentry':
kernel/trace/trace.c:8658:9: error: passing argument 3 of 'debugfs_create_automount' from incompatible pointer type [-Werror=incompatible-pointer-types]
 8658 |         trace_automount, NULL);
      |         ^~~~~~~~~~~~~~~
      |         |
      |         struct vfsmount * (*)(struct dentry *, void *)
In file included from kernel/trace/trace.c:24:
./include/linux/debugfs.h:206:25: note: expected 'struct vfsmount * (*)(void *)' but argument is of type 'struct vfsmount * (*)(struct dentry *, void *)'
  206 |      struct vfsmount *(*f)(void *),
      |      ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Link: https://lore.kernel.org/r/20191121102021787.MLMY.25002.ppp.dion.ne.jp@dmta0003.auone-net.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/debugfs.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 3b0ba54cc4d5b..3bc1034c57e66 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -54,6 +54,8 @@ static const struct file_operations __fops = {				\
 	.llseek  = no_llseek,						\
 }
 
+typedef struct vfsmount *(*debugfs_automount_t)(struct dentry *, void *);
+
 #if defined(CONFIG_DEBUG_FS)
 
 struct dentry *debugfs_lookup(const char *name, struct dentry *parent);
@@ -75,7 +77,6 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent);
 struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 				      const char *dest);
 
-typedef struct vfsmount *(*debugfs_automount_t)(struct dentry *, void *);
 struct dentry *debugfs_create_automount(const char *name,
 					struct dentry *parent,
 					debugfs_automount_t f,
@@ -204,7 +205,7 @@ static inline struct dentry *debugfs_create_symlink(const char *name,
 
 static inline struct dentry *debugfs_create_automount(const char *name,
 					struct dentry *parent,
-					struct vfsmount *(*f)(void *),
+					debugfs_automount_t f,
 					void *data)
 {
 	return ERR_PTR(-ENODEV);
-- 
2.20.1

