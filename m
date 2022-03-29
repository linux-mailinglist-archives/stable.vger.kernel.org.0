Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BD94EAB5C
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbiC2KiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 06:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiC2KiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 06:38:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EA495A0F;
        Tue, 29 Mar 2022 03:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C77F961231;
        Tue, 29 Mar 2022 10:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E6FC340ED;
        Tue, 29 Mar 2022 10:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550180;
        bh=+9eNimi5LAt7KKHQ3rAJ0gx8a6AV/bhijhdowKWF8RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loxo3il48odtQdkKsh4Kz39f/rwFPjEuuHtSvELMlSV89+KYWt4MuT40jEvTuzFpW
         xYrStH9KCsWayB6iE9JV6LW8jWBlguu9BTVzwxFJpRxv24QFMFZ2oMkIv9hfffyVAD
         n8Ftamvmzj3lrnZvV3A6Vu8n4ZHpjg2hI08GqUqhXN9iqJqyp5RV9l2MxLXuOYQ+nV
         gwpsF6hXdDmKmap91bvo12nZUOJ/duhqmI26HVOoetkEVjTWc5aK0dF9LUW+UWP2T+
         tWSY2kaUnAoz9ll99GqCYZiZGSO63epx+G+eE+RHDmc9B68O/ZbCjeSAnqRcdjdZCb
         OjJqjyEgArlmw==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH 02/18] exportfs: support idmapped mounts
Date:   Tue, 29 Mar 2022 12:35:09 +0200
Message-Id: <20220329103526.1207086-3-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1833; h=from:subject; bh=+9eNimi5LAt7KKHQ3rAJ0gx8a6AV/bhijhdowKWF8RQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5PdhjtCO39f13LfltXROzSnKOnr582jl3x66+hPl2veLn 0zdt6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIkq8M/3MP7phdtWnNu7BLidzr/D WfrPz05+MB08Os18QjEo53+Hsw/C/L/vng2aE90Wf1U/3FbijtCfxR3zgnrud6ooDYyZl6QlwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
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
2.32.0

