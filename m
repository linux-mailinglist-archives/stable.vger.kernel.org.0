Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94852400E84
	for <lists+stable@lfdr.de>; Sun,  5 Sep 2021 09:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhIEHKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 03:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhIEHKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Sep 2021 03:10:05 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01F9C061757;
        Sun,  5 Sep 2021 00:09:00 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q14so4827538wrp.3;
        Sun, 05 Sep 2021 00:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ZNdQqhoDjiadw1b2TXLuMmpgre0sPnhos24zQJglFI=;
        b=EmltpoVbxOK+7ncHUuk6jnbjHt0RZJh/AOO5bFEXc5f4YFypA8yQULy2wKWyOeTFEF
         hh1d/RH6UiY53Sf/asTJ4xlI3yprCO3H3ne92IpHiqmIRaXR5L8DAw9F5jJPZqI8z2dp
         EudIBIHe8vsCx3611KQ//scVGiHLR+Os8j3VyUhNKDy2Cii4sIC+cJoAO9VlwCest7j6
         PGfVF3wLR+3teHOKP/f+CtRru8uyobatvwuaGnqVjCw+tO+P5HthLY3NL1Oux6hn0eSR
         RYnihHM8HXMi5Cr1E6z/Ow5jXTIULIqc0e1xyMX8UTe1Rb9gXJYneekgt/L3Ig/BRdCQ
         sbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ZNdQqhoDjiadw1b2TXLuMmpgre0sPnhos24zQJglFI=;
        b=cP7kOFr5WHu0x8aBZxUlRYr31Ms2a/3VnxJKSkAgmIAYItUKmACLtO6mwajQdr3RTP
         20HEXu7+OHWJfP8zVNhLEKtXL068pYAoPiPBTG6TdoGQy09wh3atIzN5/AY8m2uTtJsZ
         O7l4AjhzBj6Z8VoyKzFwQbEmONNQUbOBJE30bLqoaqDrHyKVUBMskSs8FOLfpVrnP9si
         Izp8ufDH/twhUKuOZVcznye30GRnh/YjH/z1dc/SGgkTpJKhcWqFndJH8p0feBMH9zxY
         MTDqzf598hv7KfTrWbRqvTFPCb5BXaspgamDN1nczjUTiXY9UNJBkWj32OqMD2DlnDsU
         23Uw==
X-Gm-Message-State: AOAM5338D/yMGYmPdxLDVewZUHC3BmueFgI85oU5fSmeloD74qTzvJCF
        c338clAvMSc8+isT9y2eRS2SgMRgyEI=
X-Google-Smtp-Source: ABdhPJxW8SwU5f5H9M7CgJC0O923ysbqiEqeMbrUGu7Q36mq8gHf24GRIxUbAiZ7v7te1B1bCdZPJg==
X-Received: by 2002:a5d:5642:: with SMTP id j2mr7131898wrw.264.1630825739450;
        Sun, 05 Sep 2021 00:08:59 -0700 (PDT)
Received: from localhost.localdomain ([141.226.244.47])
        by smtp.gmail.com with ESMTPSA id q4sm4148355wra.43.2021.09.05.00.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 00:08:58 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Nikolaus Rath <Nikolaus@rath.org>,
        Vivek Goyal <vgoyal@redhat.com>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 2/2] fuse: fix illegal access to inode with reused nodeid
Date:   Sun,  5 Sep 2021 10:08:33 +0300
Message-Id: <20210905070833.201102-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210905070833.201102-1-amir73il@gmail.com>
References: <20210905070833.201102-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 15db16837a35d8007cb8563358787412213db25e ]

Server responds to LOOKUP and other ops (READDIRPLUS/CREATE/MKNOD/...)
with ourarg containing nodeid and generation.

If a fuse inode is found in inode cache with the same nodeid but different
generation, the existing fuse inode should be unhashed and marked "bad" and
a new inode with the new generation should be hashed instead.

This can happen, for example, with passhrough fuse filesystem that returns
the real filesystem ino/generation on lookup and where real inode numbers
can get recycled due to real files being unlinked not via the fuse
passthrough filesystem.

With current code, this situation will not be detected and an old fuse
dentry that used to point to an older generation real inode, can be used to
access a completely new inode, which should be accessed only via the new
dentry.

Note that because the FORGET message carries the nodeid w/o generation, the
server should wait to get FORGET counts for the nlookup counts of the old
and reused inodes combined, before it can free the resources associated to
that nodeid.

Stable backport notes:
* This is not a regression. The bug has been in fuse forever, but only
  a certain class of low level fuse filesystems can trigger this bug
* Because there is no way to check if this fix is applied in runtime,
  libfuse test_examples.py tests this fix with hardcoded check for
  kernel version >= 5.14
* After backport to stable kernel(s), the libfuse test can be updated
  to also check minimal stable kernel version(s)
* Depends on "fuse: fix bad inode" which is already applied to stable
  kernels v5.4.y and v5.10.y
* Required backporting helper inode_wrong_type()

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxi8DymG=JO_sAU+wS8akFdzh+PuXwW3Ebgahd2Nwnh7zA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/fuse/dir.c     | 2 +-
 fs/fuse/fuse_i.h  | 7 +++++++
 fs/fuse/inode.c   | 4 ++--
 fs/fuse/readdir.c | 7 +++++--
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 37d50dde845e..2e300176cb88 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -252,7 +252,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 		if (ret == -ENOMEM)
 			goto out;
 		if (ret || fuse_invalid_attr(&outarg.attr) ||
-		    inode_wrong_type(inode, outarg.attr.mode))
+		    fuse_stale_inode(inode, outarg.generation, &outarg.attr))
 			goto invalid;
 
 		forget_all_cached_acls(inode);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 8150621101c6..ff94da684017 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -860,6 +860,13 @@ static inline u64 fuse_get_attr_version(struct fuse_conn *fc)
 	return atomic64_read(&fc->attr_version);
 }
 
+static inline bool fuse_stale_inode(const struct inode *inode, int generation,
+				    struct fuse_attr *attr)
+{
+	return inode->i_generation != generation ||
+		inode_wrong_type(inode, attr->mode);
+}
+
 static inline void fuse_make_bad(struct inode *inode)
 {
 	remove_inode_hash(inode);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 6345c4679fb8..053c56af3b6f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -340,8 +340,8 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 		inode->i_generation = generation;
 		fuse_init_inode(inode, attr);
 		unlock_new_inode(inode);
-	} else if (inode_wrong_type(inode, attr->mode)) {
-		/* Inode has changed type, any I/O on the old should fail */
+	} else if (fuse_stale_inode(inode, generation, attr)) {
+		/* nodeid was reused, any I/O on the old inode should fail */
 		fuse_make_bad(inode);
 		iput(inode);
 		goto retry;
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index 277f7041d55a..bc267832310c 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -200,9 +200,12 @@ static int fuse_direntplus_link(struct file *file,
 	if (!d_in_lookup(dentry)) {
 		struct fuse_inode *fi;
 		inode = d_inode(dentry);
+		if (inode && get_node_id(inode) != o->nodeid)
+			inode = NULL;
 		if (!inode ||
-		    get_node_id(inode) != o->nodeid ||
-		    inode_wrong_type(inode, o->attr.mode)) {
+		    fuse_stale_inode(inode, o->generation, &o->attr)) {
+			if (inode)
+				fuse_make_bad(inode);
 			d_invalidate(dentry);
 			dput(dentry);
 			goto retry;
-- 
2.16.5

