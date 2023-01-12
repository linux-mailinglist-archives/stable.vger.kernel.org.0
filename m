Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5E26677C7
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbjALOsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240030AbjALOru (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:47:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9996065350
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:35:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3748662026
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E55AC433D2;
        Thu, 12 Jan 2023 14:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534133;
        bh=2Vr3VtpTr9jrMQ2dMLov2B70ogZU42C+01+00uu82Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l18jQrQiCVdq+hZrqWllH5abrzBZElAQzyjPm2Pf9iLQMn3e/tIa971sK8e7jyRh1
         LzwV351UXkIGpBy5gTylDpEjWtDorxHSXcpHf632HqvlRpu/wvZXy/UPFlRvEaO9bs
         ObJwjRTdAnYJ7HPQ8DpZFTnzPjZ5UUS3yiKKbvhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Yan <yanaijie@huawei.com>,
        Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 707/783] ext4: goto right label failed_mount3a
Date:   Thu, 12 Jan 2023 14:57:03 +0100
Message-Id: <20230112135557.137603317@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index aa7bcc856de9..eb82c1d4883c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4809,30 +4809,30 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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



