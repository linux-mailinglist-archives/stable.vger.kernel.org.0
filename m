Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6A8284EA5
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgJFPMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 11:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFPMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 11:12:08 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBE0C061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 08:12:08 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id p21so1698136pju.0
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 08:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O3wutOykn+qjv13+aIbbS9aviAcrhkTNsBYW/8APKCI=;
        b=DMTe1YUj2xSHewmkHh/K0Pojad6nQsuM1GKWuonkC3wg9L7YYrogBbWWYs36jLyjHq
         U5NuIudZf6zQAvhVoxejHZ56kZybnxAPL7ms4nWQdsz4loEFvJjL7DTCY4vK1mmuFbz9
         KzVsrSl23psLcxVF5RR1e2A3LZpEG/RcxKnJylv0Wufk1JLqvxaIXt5SL/4vqSWEhOuA
         CVzKFJ5qHlpU/txwzrUQGUQwdcx3y1+9aQ5nYZ2v6nWIqYzpu7hwxneYdn7FD2E7XO/1
         BSoMXzFhb2Ws7m1yMw8KCjBckrMIrOl1Xra+lpV3BzwYvpRzz28nBIqeJeeL2fJhSN2B
         hSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O3wutOykn+qjv13+aIbbS9aviAcrhkTNsBYW/8APKCI=;
        b=AUS0h1/9nh95y40fF0mYRmiMV3xYiM4/5+X1rAE/4alRoHcb941ak8KPsS+6IdduU1
         Qfm46VS7rSL2DGELYTwElwZaPXw80kPllafUzzSf9FGmd640an3l+uEX9AEkwGM1WrJQ
         mMKM2jD4d5q66M19z/7FDauFZ0qTeS5hzZ+8JD5ebosuBeFnd1NAgyxtE9vmg2bHvlu3
         e+M73KzP2WTy3j0m83jNWLKix2G0kATeDiezfcqIzIpUQ2PYWwBsogWLJBJTqg0y+eXU
         X9LWK8zrGHcwx37MKQ6Y9xcSgnvapsCJHuZpPjwetciEqrcjTDW/AZYpioXZ3vyDdsFl
         ZBnA==
X-Gm-Message-State: AOAM5319axegromxqsOHXsm4c1TFef4XeP/vm1/U+OTdqit5U0BjvK56
        0BxI7tYmKyB+Q7L95fLkcUzf4Fmjkn8baw==
X-Google-Smtp-Source: ABdhPJweTl1FnZF1PBsXDaqklz5AVNjIyD9EbmkGyH2bU4C7bR1//u/cDLFXJmVtmemBs7PET9q5cQ==
X-Received: by 2002:a17:90a:17c9:: with SMTP id q67mr4779043pja.128.1601997127702;
        Tue, 06 Oct 2020 08:12:07 -0700 (PDT)
Received: from ashish-sangwan.user.nutanix.com (mcp02.nutanix.com. [192.146.155.5])
        by smtp.googlemail.com with ESMTPSA id e6sm3444070pgg.83.2020.10.06.08.12.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2020 08:12:06 -0700 (PDT)
From:   Ashish Sangwan <ashishsangwan2@gmail.com>
To:     ashishsangwan2@gmail.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
Date:   Tue,  6 Oct 2020 08:11:58 -0700
Message-Id: <20201006151158.20820-1-ashishsangwan2@gmail.com>
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

