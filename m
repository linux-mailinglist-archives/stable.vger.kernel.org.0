Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463246B4482
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjCJOY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjCJOYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:24:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C002514212
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:23:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57E2161771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D948C433D2;
        Fri, 10 Mar 2023 14:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458211;
        bh=Bwy2PdlIrWeZMDjEprzDkgt40Idyf/mAas8hBidbTUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbB0Ve2Rl3V6Fzt9W/B2GivL6r8uyg4kIpX4fVwuRCoMYKcW6lM47eFWJhW+A8+On
         /v41f1ciNTTSkqScPQjfTvXlOMRTAOG0klS8D+Kftc+ZreCnG4a5OQCZN4B7cUnSH8
         /28Mtdk5HkzOBg+COscfB/2CRVTsBNQ0BHqL+vEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/252] ubifs: Rectify space budget for ubifs_symlink() if symlink is encrypted
Date:   Fri, 10 Mar 2023 14:39:32 +0100
Message-Id: <20230310133725.176683114@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
index 111905ddbfc2e..f054c12a0f939 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1141,7 +1141,6 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	int err, sz_change, len = strlen(symname);
 	struct fscrypt_str disk_link;
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = ALIGN(len, 8),
 					.dirtied_ino = 1 };
 	struct fscrypt_name nm;
 
@@ -1157,6 +1156,7 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	 * Budget request settings: new inode, new direntry and changing parent
 	 * directory inode.
 	 */
+	req.new_ino_d = ALIGN(disk_link.len - 1, 8);
 	err = ubifs_budget_space(c, &req);
 	if (err)
 		return err;
-- 
2.39.2



