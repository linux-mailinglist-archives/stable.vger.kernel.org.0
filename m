Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFAA4AFBAF
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbiBISsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240917AbiBISsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:48:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA95C1DC2F1;
        Wed,  9 Feb 2022 10:44:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FC6B61197;
        Wed,  9 Feb 2022 18:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361F9C36AE3;
        Wed,  9 Feb 2022 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432290;
        bh=QLgNFFjgZ6DaDTAvrvKsCZ9z3EEri2BOYUICe27mOcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahf8Q9X6XBvpDpt+NxMtxJ8baySuQZIAUqefsMTRoYcrlCSHU6PF1ghzayrRA3/mK
         eir7ew2B+DCtguvTjeus1muFe882a8P9ZeFnUEc4GqbdQ10ojWaBpKkzVmgLGEL9iK
         iF0aJR/OxUiVd5C6he5dpHD34BW4uEVJHFolSugwRabS+HI9qCMiN2VZVd9OokILRE
         PKBDk/jpv0JYKl9w/r+0nM3H19vZ9u/WtUtqOwccFRmNuvF9GGsP8L5wUGn4lSKo+n
         D+nHg66V9iXXBSTz7BDbYrtSVOW433X+saL88BQIjavLHzO4eBfoOk+WnyzA3fz2uL
         lAUo7Skr1fKTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jack@suse.com
Subject: [PATCH AUTOSEL 4.19 07/10] quota: make dquot_quota_sync return errors from ->sync_fs
Date:   Wed,  9 Feb 2022 13:44:06 -0500
Message-Id: <20220209184410.48223-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184410.48223-1-sashal@kernel.org>
References: <20220209184410.48223-1-sashal@kernel.org>
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
index 1d1d393f4208d..ddb379abd919d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -687,9 +687,14 @@ int dquot_quota_sync(struct super_block *sb, int type)
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

