Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F32763E039
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiK3Syv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiK3Syu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:54:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8666163D7E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:54:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9FCD61D54
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92C6C433D7;
        Wed, 30 Nov 2022 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834487;
        bh=fZLI1CPH88FenommfFpLbeK1+E6fqz51/ETnB9VyKKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puu+eVsn/5SjnafGqGquZMeSV5nOVLiDdBMkSO71UwzbE2xN1A4/iTOfMRpczd0tK
         r2U6+JNPsNYMZyWXV/f2ROkZjwfyp3kRVHuGCLUiOv6qdzo1UYaF2h0Ojm6N+R7pnP
         NKLqK3dQkE4YVRmT7OwT9elEk2lg825nX+fAfCGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 272/289] btrfs: free btrfs_path before copying inodes to userspace
Date:   Wed, 30 Nov 2022 19:24:17 +0100
Message-Id: <20221130180550.264083403@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

commit 418ffb9e3cf6c4e2574d3a732b724916684bd133 upstream.

btrfs_ioctl_logical_to_ino() frees the search path after the userspace
copy from the temp buffer @inodes. Which potentially can lead to a lock
splat.

Fix this by freeing the path before we copy @inodes to userspace.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4282,21 +4282,20 @@ static long btrfs_ioctl_logical_to_ino(s
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
@@ -4308,7 +4307,6 @@ static long btrfs_ioctl_logical_to_ino(s
 		ret = -EFAULT;
 
 out:
-	btrfs_free_path(path);
 	kvfree(inodes);
 out_loi:
 	kfree(loi);


