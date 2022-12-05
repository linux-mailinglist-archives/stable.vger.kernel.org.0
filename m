Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED6964337E
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbiLETgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234447AbiLETg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD818205C0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:33:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A45561311
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8776DC433D6;
        Mon,  5 Dec 2022 19:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268801;
        bh=WAY+ROZN1O+3DR6B2p32H7vgSFAeUFAc/LOwLWx5/aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mASWx9ztCxYAi009TmGp0Z+NNQkp8TyvjgFK7b/Q23tLxDrR2HrRgU/V/PzkmEnhD
         cYiiIH0GPtVamUiCZo+t/JSB0j1XAKefTpxe6lxNWdh7QUjkm2ax6dWQqfedb8p98u
         6XWx6CUM1Xg6eOoG9bpD3P1Bz8aWsKpx8SgpZ/NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/120] btrfs: free btrfs_path before copying inodes to userspace
Date:   Mon,  5 Dec 2022 20:09:06 +0100
Message-Id: <20221205190806.745655939@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit 418ffb9e3cf6c4e2574d3a732b724916684bd133 ]

btrfs_ioctl_logical_to_ino() frees the search path after the userspace
copy from the temp buffer @inodes. Which potentially can lead to a lock
splat.

Fix this by freeing the path before we copy @inodes to userspace.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 143c2462924b..391a4af9c5e5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3946,21 +3946,20 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		size = min_t(u32, loi->size, SZ_16M);
 	}
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
-		inodes = NULL;
-		goto out;
+		goto out_loi;
 	}
 
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
 					  inodes, ignore_offset);
+	btrfs_free_path(path);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
@@ -3972,7 +3971,6 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		ret = -EFAULT;
 
 out:
-	btrfs_free_path(path);
 	kvfree(inodes);
 out_loi:
 	kfree(loi);
-- 
2.35.1



