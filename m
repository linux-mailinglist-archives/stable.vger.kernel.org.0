Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBA5373A5A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhEEMKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232925AbhEEMJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38DEE613FC;
        Wed,  5 May 2021 12:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216502;
        bh=rfjyU+DSOEWr4VJTt4P9ny29+RSwZFl9ittuIk2cjVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMrF07yZihQy9apKmC9QNNMg1OEtMeWOkBOvucgNMUHY63IYWDRL8SRHlQThD75vY
         id5Uh5AAwkSiZBvdq/qo+qyUTMPUMkTF49bLAKzvgPtG9rHoSCVc+c4I1mScTw3ptg
         c/OeI3s1nvsqsK6vcGf92uzgi4yQSOZ+sXA6V6Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.12 09/17] ovl: allow upperdir inside lowerdir
Date:   Wed,  5 May 2021 14:06:04 +0200
Message-Id: <20210505112325.259599284@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
References: <20210505112324.956720416@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 708fa01597fa002599756bf56a96d0de1677375c upstream.

Commit 146d62e5a586 ("ovl: detect overlapping layers") made sure we don't
have overlapping layers, but it also broke the arguably valid use case of

 mount -olowerdir=/,upperdir=/subdir,..

where upperdir overlaps lowerdir on the same filesystem.  This has been
causing regressions.

Revert the check, but only for the specific case where upperdir and/or
workdir are subdirectories of lowerdir.  Any other overlap (e.g. lowerdir
is subdirectory of upperdir, etc) case is crazy, so leave the check in
place for those.

Overlaps are detected at lookup time too, so reverting the mount time check
should be safe.

Fixes: 146d62e5a586 ("ovl: detect overlapping layers")
Cc: <stable@vger.kernel.org> # v5.2
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1826,7 +1826,8 @@ out_err:
  * - upper/work dir of any overlayfs instance
  */
 static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
-			   struct dentry *dentry, const char *name)
+			   struct dentry *dentry, const char *name,
+			   bool is_lower)
 {
 	struct dentry *next = dentry, *parent;
 	int err = 0;
@@ -1838,7 +1839,7 @@ static int ovl_check_layer(struct super_
 
 	/* Walk back ancestors to root (inclusive) looking for traps */
 	while (!err && parent != next) {
-		if (ovl_lookup_trap_inode(sb, parent)) {
+		if (is_lower && ovl_lookup_trap_inode(sb, parent)) {
 			err = -ELOOP;
 			pr_err("overlapping %s path\n", name);
 		} else if (ovl_is_inuse(parent)) {
@@ -1864,7 +1865,7 @@ static int ovl_check_overlapping_layers(
 
 	if (ovl_upper_mnt(ofs)) {
 		err = ovl_check_layer(sb, ofs, ovl_upper_mnt(ofs)->mnt_root,
-				      "upperdir");
+				      "upperdir", false);
 		if (err)
 			return err;
 
@@ -1875,7 +1876,8 @@ static int ovl_check_overlapping_layers(
 		 * workbasedir.  In that case, we already have their traps in
 		 * inode cache and we will catch that case on lookup.
 		 */
-		err = ovl_check_layer(sb, ofs, ofs->workbasedir, "workdir");
+		err = ovl_check_layer(sb, ofs, ofs->workbasedir, "workdir",
+				      false);
 		if (err)
 			return err;
 	}
@@ -1883,7 +1885,7 @@ static int ovl_check_overlapping_layers(
 	for (i = 1; i < ofs->numlayer; i++) {
 		err = ovl_check_layer(sb, ofs,
 				      ofs->layers[i].mnt->mnt_root,
-				      "lowerdir");
+				      "lowerdir", true);
 		if (err)
 			return err;
 	}


