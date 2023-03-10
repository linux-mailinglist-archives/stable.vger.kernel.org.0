Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316406B4659
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjCJOmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbjCJOmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:42:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3E6122090
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B383B822DC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52066C433EF;
        Fri, 10 Mar 2023 14:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459323;
        bh=INSTpVCYW7GE6G4Em3VxyXNantMztAcz+hHnoCAwSJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqaOnmyE+8ai7Blj5QLptoiscQnBm9gMnZpRloyYmRalDQio70VKyodxO07wDou/M
         M5LmIv/3/ybGggFiP0T/hsboBVggpCZjeQHpXi11Eqbb/ylsRqp97dsiVTmXA5WB+R
         bYZkK6AVBpetZXpDbGk7YvUol93yCKtMzAyE6V1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 293/357] ubifs: Rectify space budget for ubifs_symlink() if symlink is encrypted
Date:   Fri, 10 Mar 2023 14:39:42 +0100
Message-Id: <20230310133747.687423498@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit c2c36cc6ca23e614f9e4238d0ecf48549ee9002a ]

Fix bad space budget when symlink file is encrypted. Bad space budget
may let make_reservation() return with -ENOSPC, which could turn ubifs
to read-only mode in do_writepage() process.

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216490
Fixes: ca7f85be8d6cf9 ("ubifs: Add support for encrypted symlinks")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 83a173feb6989..0c012f8fabbb2 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1125,7 +1125,6 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	int err, sz_change, len = strlen(symname);
 	struct fscrypt_str disk_link;
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = ALIGN(len, 8),
 					.dirtied_ino = 1 };
 	struct fscrypt_name nm;
 
@@ -1141,6 +1140,7 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	 * Budget request settings: new inode, new direntry and changing parent
 	 * directory inode.
 	 */
+	req.new_ino_d = ALIGN(disk_link.len - 1, 8);
 	err = ubifs_budget_space(c, &req);
 	if (err)
 		return err;
-- 
2.39.2



