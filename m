Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738546AF51E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbjCGTW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjCGTWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:22:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44674C6E66
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:06:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D44D36150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9763C433EF;
        Tue,  7 Mar 2023 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216018;
        bh=bmqPlYx0xvc08V/dfPHJba81qrIANkm/2PAG9joVBqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLegDoNcb5sgKUs11U3u806u2HBQyrW1yaXE3oWnBlEYUq1BMuxmzXq/EIw3Y76w+
         le5w3ZYpVqyolZRc6EHkIWFQGYBP71MghnkSps6gyoUD+S+9T2XJy0ojuPtL2OCi+J
         ZK+qI49HShV24BAjjBti+fb1oVVbaJftimMD5Aac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yugui <wangyugui@e16-tech.com>,
        Yuezhang Mo <Yuezhang.Mo@sony.com>, Andy Wu <Andy.Wu@sony.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.15 449/567] exfat: fix inode->i_blocks for non-512 byte sector size device
Date:   Tue,  7 Mar 2023 18:03:05 +0100
Message-Id: <20230307165925.379533361@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit 39c1ce8eafc0ff64fb9e28536ccc7df6a8e2999d upstream.

inode->i_blocks is not real number of blocks, but 512 byte ones.

Fixes: 98d917047e8b ("exfat: add file operations")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Tested-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/file.c  |    3 +--
 fs/exfat/inode.c |    6 ++----
 fs/exfat/namei.c |    2 +-
 fs/exfat/super.c |    3 +--
 4 files changed, 5 insertions(+), 9 deletions(-)

--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -251,8 +251,7 @@ void exfat_truncate(struct inode *inode,
 	else
 		mark_inode_dirty(inode);
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 write_size:
 	aligned_size = i_size_read(inode);
 	if (aligned_size & (blocksize - 1)) {
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -243,8 +243,7 @@ static int exfat_map_cluster(struct inod
 				return err;
 		} /* end of if != DIR_DELETED */
 
-		inode->i_blocks +=
-			num_to_be_allocated << sbi->sect_per_clus_bits;
+		inode->i_blocks += EXFAT_CLU_TO_B(num_to_be_allocated, sbi) >> 9;
 
 		/*
 		 * Move *clu pointer along FAT chains (hole care) because the
@@ -602,8 +601,7 @@ static int exfat_fill_inode(struct inode
 
 	exfat_save_attr(inode, info->attr);
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 	inode->i_mtime = info->mtime;
 	inode->i_ctime = info->mtime;
 	ei->i_crtime = info->crtime;
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -398,7 +398,7 @@ static int exfat_find_empty_entry(struct
 		ei->i_size_ondisk += sbi->cluster_size;
 		ei->i_size_aligned += sbi->cluster_size;
 		ei->flags = p_dir->flags;
-		inode->i_blocks += 1 << sbi->sect_per_clus_bits;
+		inode->i_blocks += sbi->cluster_size >> 9;
 	}
 
 	return dentry;
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -364,8 +364,7 @@ static int exfat_read_root(struct inode
 	inode->i_op = &exfat_dir_inode_operations;
 	inode->i_fop = &exfat_dir_operations;
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 	ei->i_pos = ((loff_t)sbi->root_dir << 32) | 0xffffffff;
 	ei->i_size_aligned = i_size_read(inode);
 	ei->i_size_ondisk = i_size_read(inode);


