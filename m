Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA0E664842
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbjAJSKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239017AbjAJSJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:09:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1B78E9AF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:07:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EDE261864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453D9C433EF;
        Tue, 10 Jan 2023 18:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374041;
        bh=nZDmItBdGvC3CO5KZ+tgxZKIFpNdgUB4S5GVcgYHbrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsnXI5Lzxp6hj3eyX/yiBKJF7pyd4lhJ755fgxoSahQ7xdg7lLpMM5nuWy5KSFQEi
         VjwKDEy8LwURZuHd0kgzel8bhd1IXZx8INHzPw1LWfEeKqbTUTvc3ihQRKh+nCktXf
         WUh3Hch5SaURP2F4HDspTqu4wL39QJgOJLF/z+1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Yan <yanaijie@huawei.com>,
        Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 009/148] ext4: goto right label failed_mount3a
Date:   Tue, 10 Jan 2023 19:01:53 +0100
Message-Id: <20230110180017.477766184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Jason Yan <yanaijie@huawei.com>

[ Upstream commit 43bd6f1b49b61f43de4d4e33661b8dbe8c911f14 ]

Before these two branches neither loaded the journal nor created the
xattr cache. So the right label to goto is 'failed_mount3a'. Although
this did not cause any issues because the error handler validated if the
pointer is null. However this still made me confused when reading
the code. So it's still worth to modify to goto the right label.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220916141527.1012715-2-yanaijie@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 89481b5fa8c0 ("ext4: correct inconsistent error msg in nojournal mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2eae6e038f38..fedfe8cb78c6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5063,30 +5063,30 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		   ext4_has_feature_journal_needs_recovery(sb)) {
 		ext4_msg(sb, KERN_ERR, "required journal recovery "
 		       "suppressed and not mounted read-only");
-		goto failed_mount_wq;
+		goto failed_mount3a;
 	} else {
 		/* Nojournal mode, all journal mount options are illegal */
 		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "journal_checksum, fs mounted w/o journal");
-			goto failed_mount_wq;
+			goto failed_mount3a;
 		}
 		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "journal_async_commit, fs mounted w/o journal");
-			goto failed_mount_wq;
+			goto failed_mount3a;
 		}
 		if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "commit=%lu, fs mounted w/o journal",
 				 sbi->s_commit_interval / HZ);
-			goto failed_mount_wq;
+			goto failed_mount3a;
 		}
 		if (EXT4_MOUNT_DATA_FLAGS &
 		    (sbi->s_mount_opt ^ sbi->s_def_mount_opt)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "data=, fs mounted w/o journal");
-			goto failed_mount_wq;
+			goto failed_mount3a;
 		}
 		sbi->s_def_mount_opt &= ~EXT4_MOUNT_JOURNAL_CHECKSUM;
 		clear_opt(sb, JOURNAL_CHECKSUM);
-- 
2.35.1



