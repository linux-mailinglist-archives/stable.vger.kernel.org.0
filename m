Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C951665D6E8
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239547AbjADPIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbjADPIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:08:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E028A1A229
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:08:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76DB761779
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73571C433B0;
        Wed,  4 Jan 2023 15:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844895;
        bh=0IXGiYRtfu/ym3s81qUbXib6hG9zs8xgC4+v2H8Awj4=;
        h=Subject:To:Cc:From:Date:From;
        b=xuKN+NH4kCmyl/G8dF+Ea1v2x2PG/WEhay1yjsotc+86D0Wh0MHvW8BQbyt12zCEt
         5ZEWMV4oxyodn1QZ4K6XqS2e8OjwvaWp+QQq2wI0RGe98Gs2zFti5so0uIyGzi/YLf
         Upl1UFGIqz5q3r7J4biifeDcKS5ldyub/g826mhk=
Subject: FAILED: patch "[PATCH] ext4: fix inode leak in ext4_xattr_inode_create() on an error" failed to apply to 4.9-stable tree
To:     yebin10@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:08:12 +0100
Message-ID: <167284489213195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e4db04f7d3db ("ext4: fix inode leak in ext4_xattr_inode_create() on an error path")
bd3b963b273e ("ext4: attach jinode after creation of xattr inode")
e50e5129f384 ("ext4: xattr-in-inode support")
b8cb5a545c3d ("ext4: fix quota charging for shared xattr blocks")
c755e251357a ("ext4: fix deadlock between inline_data and ext4_expand_extra_isize_ea()")
d7614cc16146 ("ext4: correctly detect when an xattr value has an invalid size")
2f8f5e76c7da ("ext4: avoid lockdep warning when inheriting encryption context")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e4db04f7d3dbbe16680e0ded27ea2a65b10f766a Mon Sep 17 00:00:00 2001
From: Ye Bin <yebin10@huawei.com>
Date: Thu, 8 Dec 2022 10:32:33 +0800
Subject: [PATCH] ext4: fix inode leak in ext4_xattr_inode_create() on an error
 path

There is issue as follows when do setxattr with inject fault:

[localhost]# fsck.ext4  -fn  /dev/sda
e2fsck 1.46.6-rc1 (12-Sep-2022)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Unattached zero-length inode 15.  Clear? no

Unattached inode 15
Connect to /lost+found? no

Pass 5: Checking group summary information

/dev/sda: ********** WARNING: Filesystem still has errors **********

/dev/sda: 15/655360 files (0.0% non-contiguous), 66755/2621440 blocks

This occurs in 'ext4_xattr_inode_create()'. If 'ext4_mark_inode_dirty()'
fails, dropping i_nlink of the inode is needed. Or will lead to inode leak.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221208023233.1231330-5-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b666d3bf8b38..7decaaf27e82 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1441,6 +1441,9 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 		if (!err)
 			err = ext4_inode_attach_jinode(ea_inode);
 		if (err) {
+			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
+				ext4_warning_inode(ea_inode,
+					"cleanup dec ref error %d", err);
 			iput(ea_inode);
 			return ERR_PTR(err);
 		}

