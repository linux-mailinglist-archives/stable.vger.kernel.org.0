Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0C159BD59
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiHVKIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiHVKIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D6CEE31
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBBF3B81011
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 10:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016ADC433D6;
        Mon, 22 Aug 2022 10:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661162916;
        bh=ncpRdTJmyzJNykpOrXFz0G0AJbGLTV807bBdpn0G/Fc=;
        h=Subject:To:Cc:From:Date:From;
        b=FIsVXAiLy6gsk3k/hza2jzpkZfH2nGc2rUhQhLzlvVaP1PgXu1ri6AJIeMFeyUIMj
         wFMbE7k3FuVHSv46uOGHfIOupKvPhJDPFFXf8hxjOAYe1yiwZKmizULqbmhcstNsGH
         3YZ4gpzWO6V32sa9MgZ6umZcJ+DfcUytILeYbE5w=
Subject: FAILED: patch "[PATCH] fs/ntfs3: Check reserved size for maximum allowed" failed to apply to 5.19-stable tree
To:     almaz.alexandrovich@paragon-software.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 12:08:33 +0200
Message-ID: <166116291319551@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 13747aac8984e069427e5de5d68bb6cefa98551e Mon Sep 17 00:00:00 2001
From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Date: Thu, 12 May 2022 19:18:11 +0300
Subject: [PATCH] fs/ntfs3: Check reserved size for maximum allowed

Also don't mask EFBIG
Fixes xfstest generic/485
Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 3e9aefcb3e6c..c9b718143603 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -2114,9 +2114,11 @@ int attr_insert_range(struct ntfs_inode *ni, u64 vbo, u64 bytes)
 
 	if (!attr_b->non_res) {
 		data_size = le32_to_cpu(attr_b->res.data_size);
+		alloc_size = data_size;
 		mask = sbi->cluster_mask; /* cluster_size - 1 */
 	} else {
 		data_size = le64_to_cpu(attr_b->nres.data_size);
+		alloc_size = le64_to_cpu(attr_b->nres.alloc_size);
 		mask = (sbi->cluster_size << attr_b->nres.c_unit) - 1;
 	}
 
@@ -2130,6 +2132,13 @@ int attr_insert_range(struct ntfs_inode *ni, u64 vbo, u64 bytes)
 		return -EINVAL;
 	}
 
+	/*
+	 * valid_size <= data_size <= alloc_size
+	 * Check alloc_size for maximum possible.
+	 */
+	if (bytes > sbi->maxbytes_sparse - alloc_size)
+		return -EFBIG;
+
 	vcn = vbo >> sbi->cluster_bits;
 	len = bytes >> sbi->cluster_bits;
 
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index bdffe4b8554b..cf16bde810cc 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -733,9 +733,6 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 	if (map_locked)
 		filemap_invalidate_unlock(mapping);
 
-	if (err == -EFBIG)
-		err = -ENOSPC;
-
 	if (!err) {
 		inode->i_ctime = inode->i_mtime = current_time(inode);
 		mark_inode_dirty(inode);

