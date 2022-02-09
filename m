Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC1F4AFB3D
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbiBISoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240394AbiBISnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:43:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D02C050CF1;
        Wed,  9 Feb 2022 10:42:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8547612AC;
        Wed,  9 Feb 2022 18:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71336C36AE2;
        Wed,  9 Feb 2022 18:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432145;
        bh=w6sjBU12a8Mb7PDBBTpIsEYtUcJdmMdiiyt4YkBPl4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+TASf64MBEhQJMc1vLTWsLzKsXk80hmJE4gSlN3Yp9eJS6duOvY4wqruMsupR40I
         cxNLVNjUnrquWHTaUWk1QmwxWSs81WfzF6ghhWX5dFkyNB1ixl5OfGAIsE9ZYiUuMj
         BLTlHLn/lAX+5Oo+/IG6JPMTsqE71D65xULd1lvU2tyOeQ3NXS+xH4+h3kyEqTIudk
         xYuZKJ2ZgYlPGOui98piIX6gxxJlE1LWclFFVUfQaqlmC07McKf8xrCNRthfp9w6EG
         chChqAwGtavtysPKLv52kSuMS/5ETJu+/nNZdP+NV0MT3VIK8VcfwNV1MgQVVJk1Ze
         7rE1OTozcmwSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jack@suse.com
Subject: [PATCH AUTOSEL 5.10 15/27] quota: make dquot_quota_sync return errors from ->sync_fs
Date:   Wed,  9 Feb 2022 13:40:51 -0500
Message-Id: <20220209184103.47635-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184103.47635-1-sashal@kernel.org>
References: <20220209184103.47635-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit dd5532a4994bfda0386eb2286ec00758cee08444 ]

Strangely, dquot_quota_sync ignores the return code from the ->sync_fs
call, which means that quotacalls like Q_SYNC never see the error.  This
doesn't seem right, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 4f13734637660..09fb8459bb5ce 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -692,9 +692,14 @@ int dquot_quota_sync(struct super_block *sb, int type)
 	/* This is not very clever (and fast) but currently I don't know about
 	 * any other simple way of getting quota data to disk and we must get
 	 * them there for userspace to be visible... */
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
-	sync_blockdev(sb->s_bdev);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
+	ret = sync_blockdev(sb->s_bdev);
+	if (ret)
+		return ret;
 
 	/*
 	 * Now when everything is written we can discard the pagecache so
-- 
2.34.1

