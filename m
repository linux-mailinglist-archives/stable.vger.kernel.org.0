Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF97284EAE
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 17:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgJFPPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 11:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgJFPPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 11:15:25 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E779EC061755;
        Tue,  6 Oct 2020 08:15:24 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m15so1365407pls.8;
        Tue, 06 Oct 2020 08:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O3wutOykn+qjv13+aIbbS9aviAcrhkTNsBYW/8APKCI=;
        b=Ge7sc9DFWYNmWKj/NId96QnjqS7divhkH2kHeTLILE/UPpyrCZ4IXU+0R3PRtbRyVH
         RVWsno4V7HbX1f1vratyfq6JlxSIHTI7s6CvK/KRkNviLAqBuNZBUxJZca8RdsURKy/t
         a6TubcGai1NF8WOXxKDBm8vNQsp8tbAJuPBzIpq5gazkyPhWnZj4Y3TWJ4ywE90xTQ0S
         wmhWCPeMv2RRIqEzNiSluNno3KwyBrVQZ4ZIkgGdZNeoEHL7m5LBhFDWvTa0fMCE7vSy
         ucoDTbq1s9IHd22dW7ECLT9QUIic0BEMjgQmzs9dDUkM9bVgdaLTvDzbOG83mGH2d1JV
         9asQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O3wutOykn+qjv13+aIbbS9aviAcrhkTNsBYW/8APKCI=;
        b=eCMN35Du900jj4OtMw5L8jCCimW/BUrODZc0Swqkr5VC6RDEuD7k/A8F5xUH1vbx4D
         mtGOxE0XgGYyc+CavrzIsOxCC3XHR/WFxugxMK0LheXaKlZKgkG9PvJTOpkDkg+osEKe
         p0dJ70efqbi+ZNkY2Q1iYSkF3MJj5A3YuVDxBasiWAngzdAyA9C9X7d/HMJB1axPaQ4r
         2kdLFyWabDC/oiwS//z2Xx0T9igQ5yTGmKjrI+9s4sXXrYb6d1wBdZTDI88UF9juG2JU
         xNRZhL+MxjP5gbdB2XGN0TqFixqmL2emTA3fY/le5s3A5u9EqmCQmk9GoD0oOsSii+87
         LL8Q==
X-Gm-Message-State: AOAM5311GvGhky69XwpnQUKL/6PwhG6WxklbKFSlPb2lDDx7cwT6Yue2
        cVD3vrG+U2lhL9WuUrdl93A=
X-Google-Smtp-Source: ABdhPJxJ93yZXWx4BKa4VxxHx7oDzy9xslGONHzwIA0G3joVJKEsY34G7bWYFkiQtBWe4B7/3lfdEg==
X-Received: by 2002:a17:902:b7ca:b029:d3:eca2:d221 with SMTP id v10-20020a170902b7cab02900d3eca2d221mr1808827plz.74.1601997324473;
        Tue, 06 Oct 2020 08:15:24 -0700 (PDT)
Received: from ashish-sangwan.user.nutanix.com (mcp02.nutanix.com. [192.146.155.5])
        by smtp.googlemail.com with ESMTPSA id x7sm2924159pgl.77.2020.10.06.08.15.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2020 08:15:23 -0700 (PDT)
From:   Ashish Sangwan <ashishsangwan2@gmail.com>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>
Cc:     ashishsangwan2@gmail.com, stable@vger.kernel.org,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
Date:   Tue,  6 Oct 2020 08:14:56 -0700
Message-Id: <20201006151456.20875-1-ashishsangwan2@gmail.com>
X-Mailer: git-send-email 2.16.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Request for mode bits and nlink count in the nfs4_get_referral call
and if server returns them use them instead of hard coded values.

CC: stable@vger.kernel.org
Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
---
 fs/nfs/nfs4proc.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6e95c85fe395..efec05c5f535 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -266,7 +266,9 @@ const u32 nfs4_fs_locations_bitmap[3] = {
 	| FATTR4_WORD0_FSID
 	| FATTR4_WORD0_FILEID
 	| FATTR4_WORD0_FS_LOCATIONS,
-	FATTR4_WORD1_OWNER
+	FATTR4_WORD1_MODE
+	| FATTR4_WORD1_NUMLINKS
+	| FATTR4_WORD1_OWNER
 	| FATTR4_WORD1_OWNER_GROUP
 	| FATTR4_WORD1_RAWDEV
 	| FATTR4_WORD1_SPACE_USED
@@ -7594,16 +7596,28 @@ nfs4_listxattr_nfs4_user(struct inode *inode, char *list, size_t list_len)
  */
 static void nfs_fixup_referral_attributes(struct nfs_fattr *fattr)
 {
+	bool fix_mode = true, fix_nlink = true;
+
 	if (!(((fattr->valid & NFS_ATTR_FATTR_MOUNTED_ON_FILEID) ||
 	       (fattr->valid & NFS_ATTR_FATTR_FILEID)) &&
 	      (fattr->valid & NFS_ATTR_FATTR_FSID) &&
 	      (fattr->valid & NFS_ATTR_FATTR_V4_LOCATIONS)))
 		return;
 
+	if (fattr->valid & NFS_ATTR_FATTR_MODE)
+		fix_mode = false;
+	if (fattr->valid & NFS_ATTR_FATTR_NLINK)
+		fix_nlink = false;
 	fattr->valid |= NFS_ATTR_FATTR_TYPE | NFS_ATTR_FATTR_MODE |
 		NFS_ATTR_FATTR_NLINK | NFS_ATTR_FATTR_V4_REFERRAL;
-	fattr->mode = S_IFDIR | S_IRUGO | S_IXUGO;
-	fattr->nlink = 2;
+
+	if (fix_mode)
+		fattr->mode = S_IFDIR | S_IRUGO | S_IXUGO;
+	else
+		fattr->mode |= S_IFDIR;
+
+	if (fix_nlink)
+		fattr->nlink = 2;
 }
 
 static int _nfs4_proc_fs_locations(struct rpc_clnt *client, struct inode *dir,
-- 
2.22.0

