Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03876558028
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiFWQpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiFWQpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B41B424B3;
        Thu, 23 Jun 2022 09:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7A6D61F85;
        Thu, 23 Jun 2022 16:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABA2C3411B;
        Thu, 23 Jun 2022 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002736;
        bh=8Sv0Q8qy4eIop8tqsKgUXUv461v8jb9UsX/8hx8exeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmK6sZkX3kyQ3Zgl+fHrzqf/fQPbdnLcGBghRVYaEf9wISDdBM5D7GnEKwbCRkh3Q
         t9kG8iGurhMq2lHeGdA1Qz7KNaIPkflcXfOOtrzEcpOY4jI/rtMA4WZ2PGGslcaGfX
         2mMQWvUGNB3JPbAUz03tV9Un4j2Twn8p3caWJBmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.9 001/264] 9p: missing chunk of "fs/9p: Dont update file type when updating file attributes"
Date:   Thu, 23 Jun 2022 18:39:54 +0200
Message-Id: <20220623164344.098932929@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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


