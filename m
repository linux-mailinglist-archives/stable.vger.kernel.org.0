Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8F437366A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 10:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhEEIkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 04:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbhEEIkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 04:40:23 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68192C06174A
        for <stable@vger.kernel.org>; Wed,  5 May 2021 01:39:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h10so948414edt.13
        for <stable@vger.kernel.org>; Wed, 05 May 2021 01:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=puFU4esa847OJivKerf1x4LYWy+PHaUER0sIpxgeDEM=;
        b=a3nMJRgC/03UtsE5kJ7vVSzz91t6IbXBHGILXYLxY0emDNpDe+cJSCufbfNrowXJ/6
         huJrn944MDM9sm9+oHOuwZ59wFI1cCOZnFl8gBhLGLOmWF56dQyYkEwcqLibK7whhKQ3
         DYSCPu3bUdA7U4IHI1Jl8SpfKxkVyI4iLg318=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=puFU4esa847OJivKerf1x4LYWy+PHaUER0sIpxgeDEM=;
        b=JY6SbA2A9Yh+5XyCrJq5gughvqi4Hea/yTP0E6HD3LErK9CaD5PAzZvxJr7/KvLUqO
         VpUB92QJSSupoV0XsZc50oqILUSR4l3Eki/8Y2+U+vry9AIhbYYx8cU1c/m1cqj3Yc7a
         AVLEHBwRVl7+9UvSUY9M2Fn7WcyzY0bcdQPoLcS4AMHfe6Z3bJ19zqafNhvWp6RhVUca
         3p6j5KdM/tSK8PWj9oNBFLUzTGkUvkudOaCi2BxcTvL0oNS0JOIWquewH2XrGy9Y7X32
         CIzF96/zItXLAWwHI8vXdh42js7e1jSFbm3rVSu1SAc+3/fJ++v5BRWPQ+vcVoZqIfuc
         //hg==
X-Gm-Message-State: AOAM5337h3NRvmtxUfvocOztuDEWGSXQxi+OEUXLZ3u4dC34Ez8u3yC5
        RIJ75UnzRO5GYamUEBqSzTJoWPx1XUdVPg==
X-Google-Smtp-Source: ABdhPJwSXb5gIbox6wQKlIfyKC5fU1dPZof+EAH/3WIYqUJMOm7mG6Dl5Sc62gAyVtv6eB865KaGcg==
X-Received: by 2002:a05:6402:4357:: with SMTP id n23mr31821008edc.379.1620203958193;
        Wed, 05 May 2021 01:39:18 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id h23sm2480351ejx.90.2021.05.05.01.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 01:39:17 -0700 (PDT)
Date:   Wed, 5 May 2021 10:39:15 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19/5.4 backport] ovl: allow upperdir inside lowerdir
Message-ID: <YJJZs8vKYDvKo3Db@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This is a backport of commit 708fa01597fa ("ovl: allow upperdir inside
lowerdir").

Thanks,
Miklos

---
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Mon, 12 Apr 2021 12:00:37 +0200
Subject: ovl: allow upperdir inside lowerdir

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
---
 fs/overlayfs/super.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7621ff176d15..1f0503aaf18c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1501,7 +1501,8 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
  * - upper/work dir of any overlayfs instance
  */
 static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
-			   struct dentry *dentry, const char *name)
+			   struct dentry *dentry, const char *name,
+			   bool is_lower)
 {
 	struct dentry *next = dentry, *parent;
 	int err = 0;
@@ -1513,7 +1514,7 @@ static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
 
 	/* Walk back ancestors to root (inclusive) looking for traps */
 	while (!err && parent != next) {
-		if (ovl_lookup_trap_inode(sb, parent)) {
+		if (is_lower && ovl_lookup_trap_inode(sb, parent)) {
 			err = -ELOOP;
 			pr_err("overlayfs: overlapping %s path\n", name);
 		} else if (ovl_is_inuse(parent)) {
@@ -1539,7 +1540,7 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 
 	if (ofs->upper_mnt) {
 		err = ovl_check_layer(sb, ofs, ofs->upper_mnt->mnt_root,
-				      "upperdir");
+				      "upperdir", false);
 		if (err)
 			return err;
 
@@ -1550,7 +1551,8 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 		 * workbasedir.  In that case, we already have their traps in
 		 * inode cache and we will catch that case on lookup.
 		 */
-		err = ovl_check_layer(sb, ofs, ofs->workbasedir, "workdir");
+		err = ovl_check_layer(sb, ofs, ofs->workbasedir, "workdir",
+				      false);
 		if (err)
 			return err;
 	}
@@ -1558,7 +1560,7 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 	for (i = 0; i < ofs->numlower; i++) {
 		err = ovl_check_layer(sb, ofs,
 				      ofs->lower_layers[i].mnt->mnt_root,
-				      "lowerdir");
+				      "lowerdir", true);
 		if (err)
 			return err;
 	}
-- 
2.30.2

