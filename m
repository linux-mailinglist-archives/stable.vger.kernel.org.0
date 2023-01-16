Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8FD66CD56
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbjAPRfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbjAPRe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:34:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC301CF67
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:11:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB788CE1230
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC87C433D2;
        Mon, 16 Jan 2023 17:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889069;
        bh=19dcaC59pIbQHWqhUi3haS9j7EAuoZ2tTLFAd/yluDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JS1X7IjtXNObzPVU+Z3+OSpNsIimfJYEb2WgyqCqh498dTRC4r43Al8+3QpdCKjx/
         dwjY4xsB+SPHK5SuK/ZRQDU06mB6qV/rfh3aM3WbpJVm1n7jH18Y4d24dO8EXWbPxv
         WZWWRK9IVRPTk8UJgTu7nyLv7AzjEpckVGb0ZE5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+15342c1aa6a00fb7a438@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 216/338] fs: jfs: fix shift-out-of-bounds in dbAllocAG
Date:   Mon, 16 Jan 2023 16:51:29 +0100
Message-Id: <20230116154830.446735300@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 898f706695682b9954f280d95e49fa86ffa55d08 ]

Syzbot found a crash : UBSAN: shift-out-of-bounds in dbAllocAG. The
underlying bug is the missing check of bmp->db_agl2size. The field can
be greater than 64 and trigger the shift-out-of-bounds.

Fix this bug by adding a check of bmp->db_agl2size in dbMount since this
field is used in many following functions. The upper bound for this
field is L2MAXL2SIZE - L2MAXAG, thanks for the help of Dave Kleikamp.
Note that, for maintenance, I reorganized error handling code of dbMount.

Reported-by: syzbot+15342c1aa6a00fb7a438@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a07fbb60ac3c..a46fa0f3db57 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -168,7 +168,7 @@ int dbMount(struct inode *ipbmap)
 	struct bmap *bmp;
 	struct dbmap_disk *dbmp_le;
 	struct metapage *mp;
-	int i;
+	int i, err;
 
 	/*
 	 * allocate/initialize the in-memory bmap descriptor
@@ -183,8 +183,8 @@ int dbMount(struct inode *ipbmap)
 			   BMAPBLKNO << JFS_SBI(ipbmap->i_sb)->l2nbperpage,
 			   PSIZE, 0);
 	if (mp == NULL) {
-		kfree(bmp);
-		return -EIO;
+		err = -EIO;
+		goto err_kfree_bmp;
 	}
 
 	/* copy the on-disk bmap descriptor to its in-memory version. */
@@ -194,9 +194,8 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_l2nbperpage = le32_to_cpu(dbmp_le->dn_l2nbperpage);
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
 	if (!bmp->db_numag) {
-		release_metapage(mp);
-		kfree(bmp);
-		return -EINVAL;
+		err = -EINVAL;
+		goto err_release_metapage;
 	}
 
 	bmp->db_maxlevel = le32_to_cpu(dbmp_le->dn_maxlevel);
@@ -207,6 +206,11 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
 	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
 	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
+	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG) {
+		err = -EINVAL;
+		goto err_release_metapage;
+	}
+
 	for (i = 0; i < MAXAG; i++)
 		bmp->db_agfree[i] = le64_to_cpu(dbmp_le->dn_agfree[i]);
 	bmp->db_agsize = le64_to_cpu(dbmp_le->dn_agsize);
@@ -227,6 +231,12 @@ int dbMount(struct inode *ipbmap)
 	BMAP_LOCK_INIT(bmp);
 
 	return (0);
+
+err_release_metapage:
+	release_metapage(mp);
+err_kfree_bmp:
+	kfree(bmp);
+	return err;
 }
 
 
-- 
2.35.1



