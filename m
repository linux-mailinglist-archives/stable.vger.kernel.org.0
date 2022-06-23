Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29555584FB
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbiFWRwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbiFWRvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:51:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F42099171;
        Thu, 23 Jun 2022 10:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B829061D1E;
        Thu, 23 Jun 2022 17:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821F8C341C4;
        Thu, 23 Jun 2022 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004347;
        bh=8Sv0Q8qy4eIop8tqsKgUXUv461v8jb9UsX/8hx8exeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGXZd3KVb7Gmra2ow9AwXS5lriWVtk0f4FbxSUYtI/VXTz5xj5LruhxP6S/Xui2UK
         Boi8msanQQpCCUj6Htcokx2Gi2PqOqgRX84jQNu6HR+BkrT/bi2G75iubormcwAJ7c
         xup1cNx69i5FOYAZj7zRgI5cubcktdvGIoj2+x+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 001/234] 9p: missing chunk of "fs/9p: Dont update file type when updating file attributes"
Date:   Thu, 23 Jun 2022 18:41:08 +0200
Message-Id: <20220623164343.089091177@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit b577d0cd2104fdfcf0ded3707540a12be8ddd8b0 upstream.

In commit 45089142b149 Aneesh had missed one (admittedly, very unlikely
to hit) case in v9fs_stat2inode_dotl().  However, the same considerations
apply there as well - we have no business whatsoever to change ->i_rdev
or the file type.

Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode_dotl.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -656,14 +656,10 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl
 		if (stat->st_result_mask & P9_STATS_NLINK)
 			set_nlink(inode, stat->st_nlink);
 		if (stat->st_result_mask & P9_STATS_MODE) {
-			inode->i_mode = stat->st_mode;
-			if ((S_ISBLK(inode->i_mode)) ||
-						(S_ISCHR(inode->i_mode)))
-				init_special_inode(inode, inode->i_mode,
-								inode->i_rdev);
+			mode = stat->st_mode & S_IALLUGO;
+			mode |= inode->i_mode & ~S_IALLUGO;
+			inode->i_mode = mode;
 		}
-		if (stat->st_result_mask & P9_STATS_RDEV)
-			inode->i_rdev = new_decode_dev(stat->st_rdev);
 		if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE) &&
 		    stat->st_result_mask & P9_STATS_SIZE)
 			v9fs_i_size_write(inode, stat->st_size);


