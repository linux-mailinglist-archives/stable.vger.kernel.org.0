Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214D04EBEA8
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 12:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbiC3K0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 06:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245328AbiC3K0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 06:26:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1505125845F;
        Wed, 30 Mar 2022 03:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5C2FB81B81;
        Wed, 30 Mar 2022 10:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AA2C340F2;
        Wed, 30 Mar 2022 10:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648635886;
        bh=OSUBEDpFtUGq1zuxnlsi16HS8t/VIhTkz+CQ1B058IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhhPlREa10kimGl9t1e9Ch7hkVaBD6kQ0MtJ5vieSnhQ5AVN8+cNOqIPbZYeGcil0
         hfGmS8gHBGi9lpxDksE6ibsn821bjXsXEx3HqOGil0hngm3I2KsyTtTbgpUHl29yxt
         Zijw1KGC9V7yjZ599CjlLk7pZQNFoKKXYR689csXVRSHXjhTrFRrg8en5JrVzVH5xE
         wwP3ImY+73F6A1glvGiYWvrAYmzwSW18O21XIRTBQ1yoP/l5NgRJNU3mauyoT5dKD4
         uCDU1Pxeo5Iz1SQKFIp97EtDaMY/wdgEbDmicsreq8ZEkmQ/UKTat+Pzl8CSLG5nH6
         vKM1NOA8DVmEQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 02/19] exportfs: support idmapped mounts
Date:   Wed, 30 Mar 2022 12:23:50 +0200
Message-Id: <20220330102409.1290850-3-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330102409.1290850-1-brauner@kernel.org>
References: <20220330102409.1290850-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1859; h=from:subject; bh=OSUBEDpFtUGq1zuxnlsi16HS8t/VIhTkz+CQ1B058IQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS56O/WVbrO1aAgL1AsGdBTeJ39xv4nBjfcdFuTq+9P2P3V 1/R3RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETez2D4K3DswhtWtzd5yZ8Xrnhh7q 7DtPTHTq7fX+Ms+GOuXza6ksPwv1I9S/Hq+sRDRRHL/zInNKfIPr+y0nLpx5c9TWfPnOedxQgA
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
/* v2 */
unchanged
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

