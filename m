Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD70551BCB
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344153AbiFTN2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344412AbiFTN0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:26:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E181C12D;
        Mon, 20 Jun 2022 06:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0255CCE13A2;
        Mon, 20 Jun 2022 13:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC94AC3411B;
        Mon, 20 Jun 2022 13:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730636;
        bh=ihYjR+K6C4Ij3E7dcukP0z6SrLrtMKHF1u6OB+m00Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVnvbNyHbR+DzN3Y8FWwxVjMsq/ncbIldKQTMIp8rDw1fBZdxl4w5/F3JM7aP7/r+
         nYRtBy2Wy6Zr6VpN93St/lGWjexmuWaW+Qlag2Ha4Q5Q5pe/3YWpyEYgljAvV/IM7A
         PaxCAbDwW4Zvn87+QP8XkoghRGSMgYgD0c8mZsAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.4 001/240] 9p: missing chunk of "fs/9p: Dont update file type when updating file attributes"
Date:   Mon, 20 Jun 2022 14:48:22 +0200
Message-Id: <20220620124737.844728943@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
@@ -641,14 +641,10 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl
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


