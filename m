Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B58B15085C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbfFXKQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730788AbfFXKQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:43 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3F302089F;
        Mon, 24 Jun 2019 10:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371403;
        bh=CTGxW4HAeS9AfZqWdcoD0vkfG0UtNdWM6gNBiYfTMAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dSVrC+W2lMtH6qady/KCXxharSjRppWs5pjF4c5xKxx2F+jhmJaT7f83g9amjZWS
         GkGEQD8mSH/00rm3it/8vHLVjP/f6IqvvqESciKo//0hBG3USqaXhg/lC1GThoCGt/
         nk3qDzJ7IcrSCS8ZC61ZzLfuDovgBhj8wTVkTZoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antti Antinoja <antti@fennosys.fi>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 090/121] ovl: dont fail with disconnected lower NFS
Date:   Mon, 24 Jun 2019 17:57:02 +0800
Message-Id: <20190624092325.399144583@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
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
index c481bf5f6fe2..fa5060f59b88 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1472,23 +1472,20 @@ out_err:
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
@@ -1497,17 +1494,12 @@ static int ovl_check_layer(struct super_block *sb, struct dentry *dentry,
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



