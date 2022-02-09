Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702954AFBE9
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbiBISvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241261AbiBISuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:50:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A14C03E95E;
        Wed,  9 Feb 2022 10:46:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97285B82215;
        Wed,  9 Feb 2022 18:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B090C340ED;
        Wed,  9 Feb 2022 18:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432392;
        bh=GttMzeaofkNMOCaqUHy7gLUshl9uBtQS37tupBrwCDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSymINvo3vn1ZQmlJbCXBRGCQvBBtgiP5C6WZ4GlR5dLTErs2UQimYREPYJfnTV14
         vjaYrnh7R7BLQe5HfKFEfQWofIXt82/SypcmUafBC6htHGuoKRr57OCFdkMfiht+30
         FRhnRLYSHgsfyGo8/yHiaTkbcdtmNcae6S30/oAGtaEHH4EYH2lwyHBJa1N9np5dHX
         pjp451HyxII1Efd6g1fe+9HEAqsy2h9l/gbv/BX6jaBB2OcthJXhFmiy1XUCXMklXF
         Ccxg8f2BqoUC5qsPXF7RqpAb74FsN8mnhvaamhCrrnlFJMdXHLJU+xF12CnfRT7HpR
         AON4tmMLkv5NA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jack@suse.com
Subject: [PATCH AUTOSEL 4.9 7/7] quota: make dquot_quota_sync return errors from ->sync_fs
Date:   Wed,  9 Feb 2022 13:45:50 -0500
Message-Id: <20220209184550.48481-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184550.48481-1-sashal@kernel.org>
References: <20220209184550.48481-1-sashal@kernel.org>
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
index 82a5ecbe2da96..022b237c6a134 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -676,9 +676,14 @@ int dquot_quota_sync(struct super_block *sb, int type)
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

