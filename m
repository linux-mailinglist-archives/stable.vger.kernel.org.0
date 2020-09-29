Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07FF27C519
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgI2Lal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726431AbgI2L3U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68D9523A5C;
        Tue, 29 Sep 2020 11:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378625;
        bh=HJPvvsusc2XJLDTuhpelOIyXJzUhpKNPkUQq/2875Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WADoCB6HuYs4xlJqJDSXZYU2vcnXR729kdSQYXUcvU1IOXUGfA0FkMtr+6Ce77Gmp
         kcf2k/0dJlmXQh8ty3De8C3Vql6EYXFgTvZYFrzQ5fk0a5iBFs3+UWvzrqhpeu6Qbf
         TzIg22HRcO3evdGOeVu5OKcWhd3cIZ21iijqoixE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/245] debugfs: Fix !DEBUG_FS debugfs_create_automount
Date:   Tue, 29 Sep 2020 12:58:12 +0200
Message-Id: <20200929105948.999217045@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
2.25.1



