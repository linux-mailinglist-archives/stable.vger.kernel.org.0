Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866F953FAD7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240166AbiFGKJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiFGKJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:09:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2122584A21;
        Tue,  7 Jun 2022 03:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF2C061444;
        Tue,  7 Jun 2022 10:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184A2C385A5;
        Tue,  7 Jun 2022 10:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654596550;
        bh=Xl70ZrJYXQ/z1wrP2I4gx9fjVbu5qC8UmIuY2iI9hq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPgOnCw+tS8CUR8g9N4w3V+AvcGPeyDSDSkV1X9XuvcfI7IBLAW/cRoVvpgzEYw/K
         5KR4qz34cqQ++7H0QjdFxUTxAxERQMU3WLCZTKWhJV/CUmiF15Y7DZW4IyCWCnpSNM
         ygc4WbhrCu/ug5hGPPeBwhb6aQ+SThGHhdh0DWmnME5BBLSewrOzXhG+/4CLLyrafF
         a7HeyezNlYXl9pY10yhfta5pcZtqBX1RWRLXIRJhaYyjnohocfPwQ5UhLjTFAubztM
         c7K7BTFlck2lFEfgvzjK0cVj+DCRyurblMkUMn+21MabqBFOiu4/xiZsZOrgC7TAeT
         cgHiSiemkYSGA==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 5.15.y 2/2] exportfs: support idmapped mounts
Date:   Tue,  7 Jun 2022 12:08:39 +0200
Message-Id: <20220607100840.1686673-2-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <165451869522688@kroah.com>
References: <20220607100840.1686673-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2178; h=from:subject; bh=Xl70ZrJYXQ/z1wrP2I4gx9fjVbu5qC8UmIuY2iI9hq8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTNV17onvanYm7oldTny5e5zfZe6sDjaTxxX8jzsyar3vze 9e88Z0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEWlMY/krPMRC/xbcvesnqm4FVKp svs9p0bTqbpSdgFpcdn1/2/Bcjw0zmLB2v0sS8ExJ171K+cT8rFXibkHjgpZfCLvMNkhfWcAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make the two locations where exportfs helpers check permission to lookup
a given inode idmapped mount aware by switching it to the lookup_one()
helper. This is a bugfix for the open_by_handle_at() system call which
doesn't take idmapped mounts into account currently. It's not tied to a
specific commit so we'll just Cc stable.

In addition this is required to support idmapped base layers in overlay.
The overlay filesystem uses exportfs to encode and decode file handles
for its index=on mount option and when nfs_export=on.

Cc: <stable@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
Hey Greg,

This was missing a preliminary commit.
My build machines are currently down so I couldn't do a test build but
this should build cleanly.

Thanks!
Christian
---
 fs/exportfs/expfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 0106eba46d5a..3ef80d000e13 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -145,7 +145,7 @@ static struct dentry *reconnect_one(struct vfsmount *mnt,
 	if (err)
 		goto out_err;
 	dprintk("%s: found name: %s\n", __func__, nbuf);
-	tmp = lookup_one_len_unlocked(nbuf, parent, strlen(nbuf));
+	tmp = lookup_one_unlocked(mnt_user_ns(mnt), nbuf, parent, strlen(nbuf));
 	if (IS_ERR(tmp)) {
 		dprintk("%s: lookup failed: %d\n", __func__, PTR_ERR(tmp));
 		err = PTR_ERR(tmp);
@@ -525,7 +525,8 @@ exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
 		}
 
 		inode_lock(target_dir->d_inode);
-		nresult = lookup_one_len(nbuf, target_dir, strlen(nbuf));
+		nresult = lookup_one(mnt_user_ns(mnt), nbuf,
+				     target_dir, strlen(nbuf));
 		if (!IS_ERR(nresult)) {
 			if (unlikely(nresult->d_inode != result->d_inode)) {
 				dput(nresult);
-- 
2.34.1

