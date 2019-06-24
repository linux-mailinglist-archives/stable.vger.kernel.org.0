Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F572506EA
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfFXKCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729265AbfFXKCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:02:30 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5647215EA;
        Mon, 24 Jun 2019 10:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370550;
        bh=iz/njmGKd7C9zg0FABdV8/LmO3BtVWUZsbz9sW8SOm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvwLs4WTzINyFcm3P8flk5NegF3LC5ZAj15EueXFFTZ0CtIXulmqP7Cl5Tx3QUn3R
         Lx0LN5obTr5kqv5uWADAUHjjfDcISghJ/0XBlLXom+AKmvWoNSiSwLIM9Du8ikMZAa
         zREvhcXeCrl8rZcUPZWd3fapqqzea1OEOu4q/dVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antti Antinoja <antti@fennosys.fi>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/90] ovl: dont fail with disconnected lower NFS
Date:   Mon, 24 Jun 2019 17:55:58 +0800
Message-Id: <20190624092314.528830104@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9179c21dc6ed1c993caa5fe4da876a6765c26af7 ]

NFS mounts can be disconnected from fs root.  Don't fail the overlapping
layer check because of this.

The check is not authoritative anyway, since topology can change during or
after the check.

Reported-by: Antti Antinoja <antti@fennosys.fi>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: 146d62e5a586 ("ovl: detect overlapping layers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4e268f981b4d..d6e60a7156a1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1444,23 +1444,20 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
  * Check if this layer root is a descendant of:
  * - another layer of this overlayfs instance
  * - upper/work dir of any overlayfs instance
- * - a disconnected dentry (detached root)
  */
 static int ovl_check_layer(struct super_block *sb, struct dentry *dentry,
 			   const char *name)
 {
-	struct dentry *next, *parent;
-	bool is_root = false;
+	struct dentry *next = dentry, *parent;
 	int err = 0;
 
-	if (!dentry || dentry == dentry->d_sb->s_root)
+	if (!dentry)
 		return 0;
 
-	next = dget(dentry);
-	/* Walk back ancestors to fs root (inclusive) looking for traps */
-	do {
-		parent = dget_parent(next);
-		is_root = (parent == next);
+	parent = dget_parent(next);
+
+	/* Walk back ancestors to root (inclusive) looking for traps */
+	while (!err && parent != next) {
 		if (ovl_is_inuse(parent)) {
 			err = -EBUSY;
 			pr_err("overlayfs: %s path overlapping in-use upperdir/workdir\n",
@@ -1469,17 +1466,12 @@ static int ovl_check_layer(struct super_block *sb, struct dentry *dentry,
 			err = -ELOOP;
 			pr_err("overlayfs: overlapping %s path\n", name);
 		}
-		dput(next);
 		next = parent;
-	} while (!err && !is_root);
-
-	/* Did we really walk to fs root or found a detached root? */
-	if (!err && next != dentry->d_sb->s_root) {
-		err = -ESTALE;
-		pr_err("overlayfs: disconnected %s path\n", name);
+		parent = dget_parent(next);
+		dput(next);
 	}
 
-	dput(next);
+	dput(parent);
 
 	return err;
 }
-- 
2.20.1



