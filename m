Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335C65417CF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358641AbiFGVGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378581AbiFGVBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:01:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B3520E50F;
        Tue,  7 Jun 2022 11:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B89156156D;
        Tue,  7 Jun 2022 18:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C30C385A5;
        Tue,  7 Jun 2022 18:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627516;
        bh=rEXuqKaQFolUhzZoisORWwah/+wIF+yL/H+ScGQFSQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf+0p5HNw3NzKaPp9ZDkpALasYEpF5m62ddSeRHpnpJe8O8A+T2rCQPd9E5dnxd2f
         b7+yMD+u/hIszGC28rm9zgz31J7zKFblIhTFI0wQZ3rQk0Ycepe3d67xE7sKra8EBq
         PjOJfB+0JhFwxYBCAgc+shwKekofSYbw9B1vsEbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.17 767/772] exportfs: support idmapped mounts
Date:   Tue,  7 Jun 2022 19:05:59 +0200
Message-Id: <20220607165011.623792633@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christian Brauner <brauner@kernel.org>

commit 3a761d72fa62eec8913e45d29375344f61706541 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exportfs/expfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -145,7 +145,7 @@ static struct dentry *reconnect_one(stru
 	if (err)
 		goto out_err;
 	dprintk("%s: found name: %s\n", __func__, nbuf);
-	tmp = lookup_one_len_unlocked(nbuf, parent, strlen(nbuf));
+	tmp = lookup_one_unlocked(mnt_user_ns(mnt), nbuf, parent, strlen(nbuf));
 	if (IS_ERR(tmp)) {
 		dprintk("%s: lookup failed: %d\n", __func__, PTR_ERR(tmp));
 		err = PTR_ERR(tmp);
@@ -525,7 +525,8 @@ exportfs_decode_fh_raw(struct vfsmount *
 		}
 
 		inode_lock(target_dir->d_inode);
-		nresult = lookup_one_len(nbuf, target_dir, strlen(nbuf));
+		nresult = lookup_one(mnt_user_ns(mnt), nbuf,
+				     target_dir, strlen(nbuf));
 		if (!IS_ERR(nresult)) {
 			if (unlikely(nresult->d_inode != result->d_inode)) {
 				dput(nresult);


